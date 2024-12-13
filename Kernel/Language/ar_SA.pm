# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2007 Mohammad Saleh <maoaf at yahoo.com>
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
package Kernel::Language::ar_SA;

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
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.848344073130526;

    # csv separator
    $Self->{Separator}         = '';

    $Self->{DecimalSeparator}  = '';
    $Self->{ThousandSeparator} = '';
    # TextDirection rtl or ltr
    $Self->{TextDirection} = 'rtl';

    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'إِدَارَةٌ-ACL',
        'Filter by valid state' => '',
        'Include invalid ACLs' => '',
        'Actions' => 'إجراءات',
        'Create New ACL' => 'إنشاء ACL جديد',
        'Deploy ACLs' => 'تشغل ACLs',
        'Export ACLs' => 'تصدير ACLs',
        'Filter for ACLs' => 'تَصْفِيَةٌ ACLs',
        'Just start typing to filter...' => 'ابدأ الكتابة للتصفية ...',
        'Configuration Import' => 'استيراد التكوين',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'هنا يمكنك الاستيراد ACLs إلى النظام عبر ملف التكوين. يجب أن يكون هذا الملف بتنسيق .yml المستخدم بواسطة محرر ACL.',
        'This field is required.' => 'هذا الحقل مطلوب.',
        'Overwrite existing ACLs?' => 'هل تريد استبدال قوائم ACLs الموجودة؟',
        'Upload ACL configuration' => 'تحميل تكوين ACL',
        'Import ACL configuration(s)' => 'استيراد تكوين (تكوينات) قائمة التحكم بالوصول (ACL)',
        'Description' => 'الشرح',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'إذا كنت تريد إنشاء قائمة ACL، فيمكنك استيرادها من نظام آخر أو إنشاء ACL جديد بالكامل.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'تسري التغييرات على قوائم ACLs فقط عندما تقوم بتشغيل ACLs. هنا يتم حفظ التغييرات في ملف التكوين.',
        'To delete an existing ACL you have to set the validity to invalid and save it. Afterwards a new button to delete the ACL will appear.' =>
            '',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'ملاحظة: يمثل هذا الجدول ترتيب تنفيذ قائمة ACLs. إذا كنت تريد تغيير الترتيب، فيرجى تغيير أسماء قوائم ACLs ذات الصلة.',
        'ACL name' => 'اسم ACL',
        'Comment' => 'تعليق',
        'Validity' => 'صَلاحِيَة',
        'Export' => 'تصدير',
        'Copy' => 'نَسَخَ',
        'No data found.' => 'لا توجد بيانات.',
        'No matches found.' => 'لم يتم العثور على تطابق.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Edit ACL' => 'تعديل ACL',
        'Go to overview' => 'انتقل إلى نظرة عامة',
        'Delete ACL' => 'حذف ACL',
        'Delete Invalid ACL' => 'حذف ACL غير صالح',
        'Match settings' => 'شروط التصفية',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'قم بإعداد شروط التصفية لقائمة ACLs. استخدم "Properties" للتحقق من القيمة من الشاشة الحالية أو "PropertiesDatabase" لقيمة التذكرة كما تم تخزينها في قاعدة البيانات.',
        'Change settings' => 'تغيير الاعدادات',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'يضبط القيمة المتغيرة عند استيفاء شروط التصفية. حيث تكون "Possible" قائمة بيضاء و "PossibleNot" هي قائمة سلبية.',
        'Check the official %sdocumentation%s.' => 'تحقق من الوثائق الرسمية sdocumentation%s%.',
        'Show or hide the content' => 'إظهار أو إخفاء المحتوى',
        'Edit ACL Information' => 'تعديل معلومات ACL',
        'Name' => 'الإسم',
        'Stop after match' => 'توقف بعد اصابة الهدف',
        'Edit ACL Structure' => 'تعديل هيكل ACL',
        'Save ACL' => 'حفظ ACL',
        'Save' => 'حفظ',
        'or' => 'أو',
        'Save and finish' => 'احفظ و أَنْهَى',
        'Cancel' => 'إِلْغاء',
        'Do you really want to delete this ACL?' => 'هل تريد حقًا حذف ACL؟',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAbout
        'About' => 'بِشَأْن',
        'Toggle this widget' => 'تبديل هذه القطعة',
        'This language is not present or enabled on the system. This text could be deleted if it is not needed anymore.' =>
            'هذه اللغة غير موجودة أو ممكّنة على النظام. يمكن حذف هذا النص إذا لم تعد هناك حاجة إليه.',
        'Remove Language' => 'إزالة اللغة',
        'Text' => 'نص',
        'Message body' => 'نص الرسالة',
        'This field is required and must have less than 4000 characters.' =>
            'هذا الحقل مطلوب ويجب أن يحتوي على أقل من 4000 حرف.',
        'Remove About Language' => 'إزالة اللغة',
        'Add new language' => 'أضف لغة جديدة',
        'Save Changes' => 'حفظ التغييرات',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'إدارة التقويم',
        'Add Calendar' => 'إضافة تقويم',
        'Edit Calendar' => 'تحرير التقويم',
        'Include invalid calendars' => '',
        'Calendar Overview' => 'استعراض التقويم',
        'Add new Calendar' => 'إضافة تقويم جديد',
        'Import Appointments' => 'إستيراد مواعيد',
        'Calendar Import' => 'إستيراد تقويم',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'هنا يمكنك رفع ملف تهيئة لإستيراد تقويم إلى نظامك. الملف يجب أن يكون إمتداده بتنسيق ( yml ) كما تم تصديره بموديول إدارة التقويم.',
        'Overwrite existing entities' => 'الكتابة فوق الإدخالات الموجودة',
        'Upload calendar configuration' => 'رفع ملف تهيئة تقويم',
        'Import Calendar' => 'استيراد تقويم',
        'Filter for Calendars' => 'تصفية التقاويم',
        'Filter for calendars' => 'مرشح ( فلتر ) التقاويم',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'تبعاً لحقل المجموعة، سوف يسمح النظام للمستخدمين بالوصول إلى التقويم حسب مستوى الأوذونات الخاصة بهم.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'قراءة فقط: المستخدمون يمكنهم مشاهدة واستيراد جميع المواعيد في التقويم.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'نقل إلى: يمكن للمستخدمين تحرير المواعيد في تقويم واحد، ولكن لا يمكنهم نقلها إلى تقويمات أخرى.',
        'Create: users can create and delete appointments in the calendar.' =>
            'إنشاء: يمكن للمستخدمين إنشاء وحذف المواعيد في التقويم.',
        'Read/write: users can manage the calendar itself.' => 'القراءة / الكتابة: يمكن للمستخدمين إدارة التقويمات بأنفسهم.',
        'Group' => 'المجموعة',
        'Changed' => 'تم تغييره',
        'Created' => 'أنشيء',
        'Download' => 'تنزيل',
        'URL' => 'رابط تشعبي',
        'Export calendar' => 'تصدير التقويم',
        'Download calendar' => 'تنزيل التقويم',
        'Copy public calendar URL' => 'نسخ رابط التقويم العام',
        'Calendar' => 'التقويم',
        'Calendar name' => 'إسم التقويم',
        'Calendar with same name already exists.' => 'تقويم بنفس الإسم موجود فعلياً.',
        'Color' => 'لون',
        'Permission group' => 'مجموعة الإذن',
        'Ticket Appointments' => 'مواعيد التذكرة',
        'Rule' => 'قاعدة',
        'Remove this entry' => 'قم بإزالة هذا الإدخال',
        'Remove' => 'إزالة',
        'Start date' => 'تاريخ البدء',
        'End date' => 'تاريخ النهاية',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'استخدم الخيارات التالية لتحديد تواريخ التذاكر التي يجب إنشاؤها تلقائيًا.',
        'Queues' => 'قوائم البطاقات',
        'Please select a valid queue.' => 'فضلاً اختر قائمة تذاكر صحيحة.',
        'Search attributes' => 'سمات البحث',
        'Add entry' => 'إضافة إدخال',
        'Add' => 'أضف',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'حدد القواعد لإنشاء المواعيد تلقائيًا في هذا التقويم بناءً على تواريخ التذاكر.',
        'Add Rule' => 'أضف القاعدة',
        'Submit' => 'أَرْسَلَ',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'استيراد المواعيد',
        'Go back' => 'رجوع',
        'Uploaded file must be in valid iCal format (.ics).' => 'يجب أن يكون الملف الذي تم تحميله بتنسيق iCal صالح (ice.).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'إذا لم يكن التقويم المطلوب مدرجا هنا، يرجى التأكد من أن لديك على الأقل الإذن لإنشاء تقويمات.',
        'Upload' => 'تحميل',
        'Update existing appointments?' => 'الكتابة فوق المواعيد الحالية؟',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'سيتم الكتابة فوق جميع المواعيد الحالية التي تحمل نفس "UniqueID" في التقويم المقابل.',
        'Upload calendar' => 'تحميل التقويم',
        'Import appointments' => 'استيراد المواعيد',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'إدارة إشعارات المواعيد',
        'Add Notification' => 'إضافة إشعار',
        'Edit Notification' => 'تحرير الإشعار',
        'Include invalid appointment notifications' => '',
        'Include invalid appoitnment notifications' => '',
        'Export Notifications' => 'تصدير الإشعارات',
        'Filter for Notifications' => 'فلاتر الإشعارات',
        'Filter for notifications' => 'فلاتر الإشعارات',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'هنا يمكنك تحميل ملف تكوين يمكن استخدامه لاستيراد إشعارات المواعيد إلى النظام. يجب أن يكون الملف في مِلَفّ تنسيق (yml.)، تماما كما يتم تصديره بواسطة وحدة إشعار الموعد.',
        'Overwrite existing notifications?' => 'الكتابة فوق الإشعارات الموجودة؟',
        'Upload Notification configuration' => 'تحميل تكوين الإشعارات',
        'Import Notification configuration' => 'استيراد تكوين الإشعارات',
        'List' => 'قائِمَة',
        'Delete' => 'حذف',
        'Delete this notification' => 'حذف هذا الإشعار',
        'Show in agent preferences' => 'العرض في إعدادات الوكيل',
        'Agent preferences tooltip' => 'معلومات سريعة لإعدادات الوكيل الشخصي',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'يتم عرض هذه الرسالة كاختصار لهذا الإعلام في شاشة إعدادات الوكيل.',
        'Events' => 'أحداث',
        'Event' => 'حدث',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'هنا يمكنك تحديد الأحداث التي تؤدي إلى تشغيل هذا الإشعار. يمكن تعيين فلتر مواعيد إضافي أدناه لإرسال الإشعارات فقط للمواعيد ذات الخصائص المعينة.',
        'Appointment Filter' => 'فلتر المواعيد',
        'Type' => 'النوع',
        'Title' => 'العنوان',
        'Location' => 'الموقع',
        'Team' => 'فَرِيقٌ',
        'Resource' => 'مَوْرِد',
        'Recipients' => 'مرسل إليه',
        'Send to' => 'ارسل إلى',
        'Send to these agents' => 'أرسل إلى هؤلاء العمال',
        'Send to all group members (agents only)' => 'إرسال إلى جميع أعضاء المجموعة (ينطبق على العمال فقط)',
        'Send to all role members' => '',
        'Send on out of office' => 'أرسل على الرغم من خارج المكتب.',
        'Also send if the user is currently out of office.' => 'أرسل أيضا عندما لا يكون المستخدم في العمل.',
        'Once per day' => 'مرة في اليوم',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'قم بإعلام المستخدم مرة واحدة فقط يوميًا بموعد واحد باستخدام وسيلة نقل محددة.',
        'Notification Methods' => 'طرق الإخطار',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'هذه هي الطرق الممكنة التي يمكن استخدامها لإرسال هذا الإشعار إلى كل من المستلمين. يرجى تحديد طريقة واحدة على الأقل أدناه.',
        'Enable this notification method' => 'قم بتمكين طريقة الإعلام هذه',
        'Transport' => 'نَقْلٌ',
        'At least one method is needed per notification.' => 'مطلوب طريقة واحدة على الأقل لكل إخطار.',
        'Active by default in agent preferences' => 'نشط بشكل افتراضي في إعدادات الوكيل',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'هذه هي القيمة الافتراضية لوكلاء المستلمين المعينين الذين لم يقوموا بعد بتحديد هذا الإخطار في إعداداتهم. إذا تم تحديد المربع ، فسيتم تسليم الإخطار إلى هؤلاء الوكلاء.',
        'This feature is currently not available.' => 'هذه الميزة غير متوفرة حاليا.',
        'Upgrade to %s' => 'الترقية إلى٪ s',
        'Please activate this transport in order to use it.' => 'لاستخدام هذا النقل ، يجب عليك أولاً تنشيطه.',
        'No data found' => 'لاتوجد بيانات',
        'No notification method found.' => 'لم يتم العثور على طريقة إعلام.',
        'Notification Text' => 'نص الإخطار',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'هذه اللغة غير متوفرة في النظام أو معطلة. يمكن حذف نص الإخطار إذا لم تعد هناك حاجة إليه.',
        'Remove Notification Language' => 'إزالة لغة الإخطار',
        'Subject' => 'العنوان',
        'Add new notification language' => 'أضف لغة جديدة للإشعارات',
        'Tag Reference' => '',
        'Notifications are sent to an agent.' => 'يتم إرسال الإشعارات إلى وكيل.',
        'You can use the following tags' => 'يمكنك استخدام العلامات التالية',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => 'سمات الموعد',
        ' e. g.' => ' على سبيل المثال.',
        'To get the calendar attribute' => 'سمات التقويم',
        'Attributes of the recipient user for the notification' => 'سمات بيانات المستخدم الخاصة بمستلم الإخطار',
        'Config options' => 'خيارات التكوين',
        'Example notification' => 'مثال على الإخطار',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'عناوين البريد الإلكتروني للمستلمين الإضافية',
        'This field must have less then 200 characters.' => 'لا يمكن أن يحتوي هذا الحقل إلا على 200 حرف بالضبط أو أقل.',
        'Article visible for customer' => 'عنصر مرئي للزَبُون',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'يتم إنشاء مقال عندما يتم إرسال الإشعار إلى زَبُون أو إلى عنوان بريد إلكتروني إضافي.',
        'Email template' => 'نَموذَج البريد الإلكتروني',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'استخدم هذا القالب لإنشاء البريد الإلكتروني الكامل (فقط لرسائل البريد الإلكتروني بتنسيق HTML).',
        'Enable email security' => 'تمكين أمان البريد الإلكتروني',
        'Email security level' => 'مستوى أمان البريد الإلكتروني',
        'If signing key/certificate is missing' => 'إذا كان مفتاح / شهادة التوقيع مفقودة',
        'If encryption key/certificate is missing' => 'إذا كان مفتاح / شهادة التشفير مفقودة',

        # Template: AdminAttachment
        'Attachment Management' => 'إدارة الملفات المرفقة',
        'Add Attachment' => 'إضافة مرفق',
        'Edit Attachment' => 'تحرير المرفق',
        'Include invalid attachments' => '',
        'Filter for Attachments' => 'تصفية المرفقات',
        'Filter for attachments' => 'تصفية المرفقات',
        'Filename' => 'اسم الملف',
        'Download file' => 'تحميل الملف',
        'Delete this attachment' => 'إزالة هذا المرفق',
        'Do you really want to delete this attachment?' => 'هل تريد حقًا حذف هذا المرفق؟',
        'Attachment' => 'ملف مرفق',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'إدارة الرد الآلي',
        'Add Auto Response' => 'أضف الرد التلقائي',
        'Edit Auto Response' => 'تحرير الرد التلقائي',
        'Include invalid auto responses' => '',
        'Filter for Auto Responses' => 'تصفية الردود التلقائية',
        'Filter for auto responses' => 'تصفية الردود التلقائية',
        'Response' => 'الرد',
        'Auto response from' => 'الرد التلقائي من',
        'Reference' => 'مَرجِع',
        'To get the first 20 character of the subject.' => 'أول 20 حرفًا من الموضوع.',
        'To get the first 5 lines of the email.' => 'الأسطر الخمسة الأولى من الرسالة.',
        'To get the name of the ticket\'s customer user (if given).' => 'اسم مستخدم العميل (إن وجد) للتذكرة.',
        'To get the article attribute' => 'سمات المقال',
        'Options of the current customer user data' => 'سمات العميل الحالي',
        'Ticket owner options' => 'سمات مالك التذكرة',
        'Ticket responsible options' => 'سمات مَسْؤُولٌ التذكرة',
        'Options of the current user who requested this action' => 'سمات المستخدم الحالي الذي طلب الإجراء',
        'Options of the ticket data' => 'سمات بيانات التذكرة',
        'Options of ticket dynamic fields internal key values' => 'القيم الداخلية للحقول الديناميكية للتذكرة',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'عرض قيم الحقول الديناميكية للتذاكر، القابلة للاستخدام مع القائمة المنسدلة والاختيار المتعدد',
        'Example response' => 'مثال الجواب',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'إدارة الخدمات السحابية',
        'Support Data Collector' => 'دعم تحليل البيانات',
        'Support data collector' => 'دعم تحليل البيانات',
        'Hint' => 'إشارَةٌ',
        'Currently support data is only shown in this system.' => 'يتم عرض بيانات الدعم حاليًا على هذا النظام فقط.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            'في بعض الحالات ، يُنصح بإرسال هذه البيانات إلى فريق OTOBO للحصول على دعم أفضل.',
        'Configuration' => 'تَكْوينٌ',
        'Send support data' => 'إرسال بيانات الدعم',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            'يتيح هذا الإعداد إرسال معلومات دعم إضافية إلى فريق OTOBO.',
        'Update' => 'تحديث',
        'System Registration' => 'تسجيل النظام',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'لتمكين إرسال البيانات ، يرجى تسجيل النظام الخاص بك مع فريق OTOBO أو تحديث تسجيل النظام الخاص بك (قم بتمكين الخيار "إرسال بيانات الدعم".)',
        'Register this System' => 'سجل هذا النظام',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'تم تعطيل تسجيل النظام لنظامك. يرجى التحقق من التكوين.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            'التسجيل في النظام هي خدمة من فريق OTOBO تمنحك العديد من المزايا!',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'يرجى ملاحظة أن استخدام خدمات OTOBO السحابية يتطلب نظامًا مسجلاً.',
        'Register this system' => 'سجل هذا النظام',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'يمكنك هنا تكوين الخدمات السحابية المتوفرة التي تتواصل بأمان مع٪ s.',
        'Available Cloud Services' => 'الخدمات السحابية المتاحة',

        # Template: AdminCommunicationLog
        'Communication Log' => 'بروتوكول الاتصالات',
        'Time Range' => 'النطاق الزمني',
        'Show only communication logs created in specific time range.' =>
            'عرض فقط سجلات الاتصال التي تم جمعها في فترة زمنية محددة.',
        'Filter for Communications' => 'تصفية الاتصالات',
        'Filter for communications' => 'تصفية الاتصالات',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'في هذه الشاشة يمكنك رؤية نظرة عامة حول الاتصالات الواردة والصادرة.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'يمكنك تغيير ترتيب الأعمدة وترتيبها بالنقر فوق رؤوس الأعمدة.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'إذا قمت بالنقر فوق الإدخالات المختلفة، فسيتم إعادة توجيهك إلى شاشة مفصلة حول الرسالة.',
        'Status for: %s' => 'الحالة ل: ٪ s',
        'Failing accounts' => 'الحسابات الفاشلة',
        'Some account problems' => 'بعض مشاكل الحساب',
        'No account problems' => 'لا مشاكل الحساب',
        'No account activity' => 'لا يوجد نشاط حساب',
        'Number of accounts with problems: %s' => 'عدد الحسابات التي بها مشاكل: ٪ s',
        'Number of accounts with warnings: %s' => 'عدد الحسابات التي بها تحذيرات: ٪ s',
        'Failing communications' => 'الاتصالات الفاشلة',
        'No communication problems' => 'لا توجد مشاكل في الاتصال',
        'No communication logs' => 'لا توجد سجلات اتصال',
        'Number of reported problems: %s' => 'عدد المشاكل المبلغ عنها: ٪ s',
        'Open communications' => 'اتصالات مفتوحة',
        'No active communications' => 'لا توجد اتصالات نشطة',
        'Number of open communications: %s' => 'عدد الاتصالات المفتوحة: ٪ s',
        'Average processing time' => 'متوسط وقت المعالجة',
        'List of communications (%s)' => 'قائمة الاتصالات (٪ s)',
        'Settings' => 'اعدادات',
        'Entries per page' => 'إدخالات في كل صفحة',
        'No communications found.' => 'لم يتم العثور على اتصالات.',
        '%s s' => '٪ s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'حالة الحساب',
        'Back to overview' => 'الرجوع إلى النظرة العامة',
        'Filter for Accounts' => 'تصفية الحسابات',
        'Filter for accounts' => 'تصفية الحسابات',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'يمكنك تغيير ترتيب وترتيب هذه الأعمدة من خلال النقر على رؤوس الأعمدة.',
        'Account status for: %s' => 'حالة الحساب ل: ٪ s',
        'Status' => 'الحالة',
        'Account' => 'الحساب',
        'Edit' => 'تعديل',
        'No accounts found.' => 'لم يتم العثور على حسابات.',
        'Communication Log Details (%s)' => 'تفاصيل سجل الاتصال (٪ s)',
        'Direction' => 'اِتِّجَاهٌ',
        'Start Time' => 'وقت البدء',
        'End Time' => 'وقت النهاية',
        'No communication log entries found.' => 'لم يتم العثور على إدخالات السجل.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'مُدَّة',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'أولوية',
        'Module' => 'موديول',
        'Information' => 'مَعْلُومَة',
        'No log entries found.' => 'لم يتم العثور على إدخالات السجل.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'طريقة عرض تفصيلية لاتصال ٪s بدأت عند ٪s',
        'Filter for Log Entries' => 'تصفية لإدخالات السجل',
        'Filter for log entries' => 'تصفية لإدخالات السجل',
        'Show only entries with specific priority and higher:' => 'عرض الإدخالات ذات الأولوية المحددة فقط (وأعلى):',
        'Communication Log Overview (%s)' => 'نظرة عامة على بروتوكول الاتصال (٪ s)',
        'No communication objects found.' => 'لم يتم العثور على كائنات اتصال.',
        'Communication Log Details' => 'تفاصيل بروتوكول الاتصال',
        'Please select an entry from the list.' => 'يرجى اختيار إدخال من القائمة.',

        # Template: AdminContactWD
        'Contact with data management' => 'بيانات الاتصال',
        'Contact with data' => 'بيانات الاتصال',
        'Add contact with data' => 'أضف معلومات الاتصال',
        'Edit contact with data' => 'تحرير معلومات الاتصال',
        'Back to search results' => 'العودة إلى نتيجة البحث',
        'Select' => 'اِخْتِيَارٌ',
        'Search' => 'بحث',
        'Wildcards like \'*\' are allowed.' => 'يُسمح باستخدام أحرف البدل مثل "*".',
        'Please enter a search term to look for contacts with data.' => 'الرجاء إدخال مصطلح البحث للبحث عن العملاء.',
        'Valid' => 'صَالِحٌ',

        # Template: AdminCustomerAccept
        'Privacy Policy Management' => 'إدارة إشعارات الخصوصية',
        'Privacy Policy' => 'حماية الخصوصية',
        'Remove PrivacyPolicy Language' => 'إزالة اللغة لإشعارات الخصوصية',

        # Template: AdminCustomerCompany
        'Customer Management' => 'ادارة الزبائن',
        'Add Customer' => 'إضافة الزبون',
        'Edit Customer' => 'تحرير الزَّبُون',
        'Include invalid customer companies' => '',
        'List (only %s shown - more available)' => 'قائمة (٪ s معروضة فقط - المزيد متوفر)',
        'total' => 'كُلّيّ',
        'Please enter a search term to look for customers.' => 'الرجاء إدخال مصطلح البحث للبحث عن العملاء.',
        'Customer ID' => 'رقم العميل',
        'Please note' => 'يرجى ملاحظة',
        'This customer backend is read only!' => 'لا يمكن تحرير هذه الواجهة الخلفية للعملاء!',

        # Template: AdminCustomerDashboardInfoTile
        'Customer Info' => '',
        'Customer Info Management' => '',
        'Create new info tile entry' => '',
        'Filter for info tile entries' => '',
        'Create a new entry to be displayed on the info tile on the customer dashboard.' =>
            '',
        'Stop date' => 'وقت الانتهاء',
        'Delete info tile entry' => '',

        # Template: AdminCustomerDashboardInfoTileEdit
        'Edit customer dashboard info tile entry' => '',
        'Date invalid!' => 'التاريخ غير صالح!',
        'Tile content' => '',
        'Content Body' => '',
        'Marquee content' => '',
        'Group Selection' => '',

        # Template: AdminCustomerDashboardInfoTileNew
        'Create new customer dashboard info tile entry' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'إدارة مهام مجموعة العملاء',
        'Notice' => 'ملاحظة',
        'This feature is disabled!' => 'تم تعطيل هذه الوظيفة!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'استخدم هذه الوظيفة إذا كنت تريد تحديد أذونات المجموعة للعملاء.',
        'Enable it here!' => 'تفعيل هنا!',
        'Edit Customer Default Groups' => 'تحرير المجموعات الافتراضية للعملاء',
        'These groups are automatically assigned to all customers.' => 'يتم تعيين هذه المجموعات تلقائيا لجميع العملاء.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'يمكنك إدارة هذه المجموعات عبر إعداد التكوين "CustomerGroupCompanyAlwaysGroups".',
        'Filter for Groups' => 'الفلتر للمجموعات',
        'Select the customer:group permissions.' => 'حدد أذونات المجموعة للعملاء.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'إذا لم يتم تحديد أي شيء ، فلن يكون للعميل أي حقوق في هذه المجموعة (ولا يمكنه الوصول إلى التذاكر).',
        'Search Results' => 'نتائج البحث',
        'Customers' => 'الزبائن',
        'Groups' => 'المجموعات',
        'Change Group Relations for Customer' => 'تغيير علاقات المجموعة للعملاء',
        'Change Customer Relations for Group' => 'إدارة تعيينات العملاء للمجموعة',
        'Toggle %s Permission for all' => 'تبديل ٪s إذن للجميع',
        'Toggle %s permission for %s' => 'تبديل إذن ٪s ل ٪s',
        'Customer Default Groups:' => 'مجموعات العملاء الافتراضية:',
        'No changes can be made to these groups.' => 'لا يمكن إجراء أي تغييرات على هذه المجموعات.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'فقط اذن القراءة على التذاكر في هذه المجموعات / قوائم الانتظار.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'الوصول الكامل للقراءة والكتابة إلى التذاكر في هذه المجموعة / قائمة الانتظار.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'إدارة مستخدم العميل',
        'Add Customer User' => 'إضافة مستخدم العميل',
        'Edit Customer User' => 'تحرير مستخدم العميل',
        'Include invalid customer users' => '',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'يحتاج مستخدم العميل إلى أن يكون لديه سجل عميل وأن يقوم بتسجيل الدخول عبر لوحة العميل.',
        'List (%s total)' => 'القائمة (٪s الإجمالية)',
        'Username' => 'إسم المستخدم',
        'Email' => 'البريد الإلكتروني',
        'Last Login' => 'آخر تسجيل دخول',
        'Login as' => 'تسجيل دخول ك',
        'Switch to customer' => 'التبديل إلى العميل',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'الواجهة الخلفية للعميل للقراءة فقط، ولكن يمكن تغيير تفضيلات المستخدم الخاصة بالعميل!',
        'This field is required and needs to be a valid email address.' =>
            'هذا الحقل مطلوب ويجب أن يكون عنوان بريد إلكتروني صالحًا.',
        'This email address is not allowed due to the system configuration.' =>
            'عنوان البريد الإلكتروني هذا غير مسموح به بسبب تكوين النظام.',
        'This email address failed MX check.' => 'فشل التحقق من MX لعنوان البريد الإلكتروني هذا.',
        'DNS problem, please check your configuration and the error log.' =>
            'مشكلة DNS، يرجى التحقق من التكوين الخاص بك وسجل الأخطاء.',
        'The syntax of this email address is incorrect.' => 'صيغة عنوان البريد الإلكتروني هذا غير صحيحة.',
        'This CustomerID is invalid.' => 'رقم هذا الزَّبُون غير صالح.',
        'Effective Permissions for Customer User' => 'أذونات فعالة لمستخدمي العملاء',
        'Group Permissions' => 'أذونات المجموعة',
        'This customer user has no group permissions.' => 'ليس لدى مستخدم العميل هذا أذونات المجموعة.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'يوضح الجدول أعلاه أذونات المجموعة الفعالة لمستخدم العميل. تأخذ المصفوفة أيضا في الاعتبار جميع التفويضات الموروثة (على سبيل المثال من قبل مجموعات العملاء). ملاحظة: لا يعرض الجدول التغييرات في هذه الشاشة حتى تقوم بحفظها.',
        'Customer Access' => 'مَدْخَل العملاء',
        'Customer' => 'عميل',
        'This customer user has no customer access.' => 'هذا المستخدم العميل ليس لديه حق الوصول إلى العملاء.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'يوضح الجدول أعلاه وصول العميل الممنوح لمستخدم العميل حسب سياق التفويض. تأخذ المصفوفة أيضا في الاعتبار جميع التفويضات الموروثة (على سبيل المثال من قبل مجموعات العملاء). ملاحظة: لا يعرض الجدول التغييرات في هذه الشاشة حتى تقوم بحفظها.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'إدارة علاقات العملاء والمستخدمين',
        'Select the customer user:customer relations.' => 'حدد العلاقة بين مستخدم العميل والعميل.',
        'Customer Users' => 'العملاء',
        'Change Customer Relations for Customer User' => 'تغيير علاقات العملاء لمستخدم العميل',
        'Change Customer User Relations for Customer' => 'تغيير علاقات المستخدم مع العملاء',
        'Toggle active state for all' => 'تبديل الحالة النشطة للجميع',
        'Active' => 'نَشِط',
        'Toggle active state for %s' => 'تبديل الحالة النشطة ل ٪s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'إدارة الارتباطات بين مستخدمي العملاء والمجموعات',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'استخدم هذه الميزة إذا كنت تريد تحديد أذونات المجموعة لمستخدمي العملاء.',
        'Edit Customer User Default Groups' => 'تحرير المجموعات الافتراضية للمستخدمين العملاء',
        'These groups are automatically assigned to all customer users.' =>
            'يتم تعيين هذه المجموعات تلقائيًا لجميع مستخدمي العملاء.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'يمكنك تحرير هذه المجموعات باستخدام إعداد تكوين "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'عوامل التصفية للمجموعات',
        'Select the customer user - group permissions.' => 'حدد أذونات المجموعة لمستخدمي العملاء.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'إذا لم يتم تحديد أي شيء ، فلن يكون للعميل أي حقوق في هذه المجموعة (ولا يمكنه الوصول إلى التذاكر).',
        'Customer User Default Groups:' => 'المجموعات الافتراضية لمستخدم العميل:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'إدارة تعيينات خدمة العملاء',
        'Edit default services' => 'تحرير الخدمات الافتراضية',
        'Filter for Services' => 'تصفية للخدمات',
        'Filter for services' => 'تصفية للخدمات',
        'Services' => 'خدمات',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'إدارة الحقول الديناميكية',
        'Include invalid dynamic fields' => '',
        'Filter for Dynamic Fields' => 'تصفية الحقول الديناميكية',
        'Filter for dynamic fields' => 'تصفية الحقول الديناميكية',
        'Filter field by object type' => '',
        'Filter field by namespace' => '',
        'Add new field for object' => 'إضافة حقل جديد للكائن',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'لإضافة حقل جديد، حدد نوع الحقل من قائمة الأنواع المتوفرة لهذا الكائن. تحديد الكائن ملزم ولا يمكن تغييره لاحقا.',
        'New Dynamic Fields' => 'حقول ديناميكية جديدة',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            'هل ترغب في الاستفادة من المجالات الديناميكية الأخرى؟ لديك حق الوصول الكامل إلى أنواع الحقول التالية:',
        'Database' => 'قاعدة البيانات',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'استخدم قواعد البيانات الخارجية كمصادر بيانات قابلة للتكوين لهذا الحقل الديناميكي.',
        'Web service' => 'خدمة ويب',
        'External web services can be configured as data sources for this dynamic field.' =>
            'يمكن تكوين خدمات ويب الخارجية كمصدر بيانات لهذا الحقل.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'تتيح لك هذه الميزة إضافة جهات اتصال (متعددة) تحتوي على بيانات إلى التذاكر.',
        'Dynamic Fields List' => 'قائمة الحقول الديناميكية',
        'Dynamic fields per page' => 'الحقول الديناميكية لكل صفحة',
        'Label' => 'تَسْمية',
        'Order' => 'مَوْضِع',
        'Object' => 'كائن',
        'Copy this field' => '',
        'Delete this field' => 'حذف هذا الحقل',

        # Template: AdminDynamicFieldAdvanced
        'Import / Export' => 'استيراد/تصدير',
        'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.' =>
            'هنا يمكنك تحميل ملف تكوين لاستيراد الحقول الديناميكية إلى نظامك. يجب أن يكون الملف بتنسيق . yml كما تم تصديره بواسطة الوحدة النمطية لإدارة الحقول الديناميكية.',
        'DynamicFields Import' => 'استيراد حقول ديناميكية',
        'DynamicFields Export' => 'تصدير الحقول الديناميكية',
        'Dynamic Fields Screens' => 'أسطح الحقول الديناميكية',
        'Here you can manage the dynamic fields in the respective screens.' =>
            'هنا يمكنك إدارة الحقول الديناميكية في الواجهات المعنية.',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'الحقول الديناميكية',
        'Go back to overview' => 'ارجع إلى النظرة العامة',
        'General' => 'عَامٌّ',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'هذا الحقل مطلوب، ويجب أن تكون القيمة أحرف أبجدية ورقمية فقط.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'يجب أن تكون فريدة من نوعها ويجب أن تتكون فقط من الحروف والأرقام.',
        'Changing this value will require manual changes in the system.' =>
            'سيتطلب تغيير هذه القيمة تغييرات يدوية في النظام.',
        'This is the name to be shown on the screens where the field is active.' =>
            'يظهر هذا الاسم على الشاشات التي يكون فيها هذا الحقل نشطا.',
        'Field order' => 'الترتيب الميداني',
        'This field is required and must be numeric.' => 'هذا الحقل مطلوب ويمكن أن يحتوي فقط على أرقام.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'هذا هو الترتيب الذي سيظهر به هذا الحقل على الشاشات حيث يكون نشطًا.',
        'Namespace' => 'مساحة الاسم',
        'This is the namespace in which this field will be used as prefix with the name.' =>
            '',
        'Tooltip message:' => 'رسالة تلميح الأداة:',
        'This is the tooltip message shown inside the customer interface.' =>
            'هذه هي رسالة تلميح الأدوات المعروضة داخل واجهة العميل.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'لا يمكن تعيين هذا الإدخال إلى غير صالح حتى يتم ضبط جميع التكوينات المتأثرة وفقا لذلك.',
        'Field type' => 'نوع الحقل',
        'Object type' => 'نوع الكائن',
        'Internal field' => 'المجال الداخلي',
        'This field is protected and can\'t be deleted.' => 'هذا حقل داخلي محمي ولا يمكن حذفه.',
        'This dynamic field is used in the following config settings:' =>
            'يتم استخدام هذا الحقل الديناميكي في إعدادات التكوين التالية:',
        'Field Settings' => 'إعدادات الحقل',
        'Default value' => 'القيمة الافتراضية',
        'This is the default value for this field.' => 'هذه هي القيمة الافتراضية لهذا الحقل.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => 'إضافة أو تحرير جهات الاتصال',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            'لإضافة جهات اتصال إلى هذا الحقل ، يرجى ملء جميع المعلومات المطلوبة وحفظها.',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            'انقر على اسم الحقل في النظرة العامة لتحريره والعثور على الإجراء المقابل في الشريط الجانبي أو في القائمة "التذاكر".',
        'Name Field' => 'اسم الحقل',
        'ValidID Field' => '',
        'Other Fields' => 'مجالات أخرى',
        'Key' => 'مفتاح',
        'Value' => 'قيمة',
        'Remove value' => 'إزالة القيمة',
        'Add Field' => 'إضافة حقل',
        'Add value' => 'إضافة قيمة',
        'These are the possible data attributes for contacts.' => 'هذه هي سمات البيانات المحتملة لجهات الاتصال.',
        'Mandatory fields' => 'الحقول المطلوبة',
        'Comma separated list of mandatory keys (optional). Keys \'Name\' and \'ValidID\' are always mandatory and doesn\'t have to be listed here.' =>
            'قائمة الحقول الإلزامية مفصولة بفواصل (اختياري). دائمًا ما يكون المفتاحان "Name" و "ValidID" حقلين إلزاميين ولا يجب إدراجهما هنا.',
        'Sorted fields' => 'الحقول التي تم فرزها',
        'Comma separated list of keys in sort order (optional). Keys listed here come first, all remaining fields afterwards and sorted alphabetically.' =>
            'قائمة مفاتيح مفصولة بفواصل بترتيب فرز (اختياري). تأتي المفاتيح المدرجة هنا أولا ، وجميع الحقول المتبقية بعد ذلك ويتم فرزها أبجديا.',
        'Searchable fields' => 'الحقول القابلة للبحث',
        'Comma separated list of searchable keys (optional). Key \'Name\' is always searchable and doesn\'t have to be listed here.' =>
            'قائمة مفصولة بفواصل للمفاتيح القابلة للبحث (اختياري). يمكن دائمًا البحث عن المفتاح "Name" ولا يلزم إدراجه هنا.',
        'Translatable values' => 'قيم قابلة للترجمة',
        'If you activate this option the values will be translated to the user defined language.' =>
            'إذا قمت بتنشيط هذا الخيار، فسيتم ترجمة القيم إلى اللغة التي يحددها المستخدم.',
        'Note' => 'ملاحظة',
        'You need to add the translations manually into the language translation files.' =>
            'تحتاج إلى إضافة الترجمات يدويا إلى ملفات ترجمة اللغة.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'القيم المحتملة',
        'Datatype' => 'نوع البيانات',
        'Filter' => 'فِلْتَر',
        'Searchfield' => 'مربع البحث',
        'Listfield' => 'مربع قائمة',
        'Show link' => 'إظهار الرابط',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'هنا يمكنك تحديد ارتباط HTTP اختياري لقيمة الحقل في شاشات اللمحات العامة والتكبير/التصغير.',
        'Example' => 'مثال',
        'You can reference the field with its own field name. You can also refer to other fields, e.g. with \'DynamicField_OtherFieldName\'.' =>
            '',
        'Link for preview' => 'رابط للمعاينة',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'يتم استخدام عنوان URL هذا (إن وجد) للمعاينة عندما يكون الماوس فوق هذا الرابط في طريقة عرض التذكرة. لهذا الغرض، يجب أيضا ملء حقل عنوان URL أعلاه.',
        'SID' => '',
        'Driver' => 'برنامج تشغيل الجهاز',
        'Server' => 'خَادِمٌ',
        'Port' => 'مَنْفَذٌ',
        'Table / View' => 'الجدول / العرض',
        'User' => 'مستخدم',
        'Password' => 'كلمة المرور',
        'Identifier' => 'المعرف',
        'Must be unique column from the table entered in Table/View.' => 'يجب أن يكون عمودا فريدا من الجدول الذي تم إدخاله في الجدول/طريقة العرض.',
        'Multiselect' => 'اختيار متعدد',
        'CacheTTL' => 'ذاكرة التخزين المؤقت TTL',
        'Searchprefix' => 'بادئة البحث',
        'Searchsuffix' => 'لاحقة البحث',
        'Result Limit' => 'قيود النتائج',
        'Case Sensitive' => 'يميز بين الأحرف الكبيرة والصغيرة',
        'Multiple Values' => '',
        'Activate this option to allow multiple values for this field.' =>
            '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'فرق التاريخ الافتراضي',
        'This field must be numeric.' => 'يمكن أن يحتوي هذا الحقل على أرقام فقط.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'يتم استخدام الفرق من الآن، بالثواني، لحساب القيمة الافتراضية للحقل (على سبيل المثال، 3600 أو -60).',
        'Define years period' => 'تحديد النطاق السنوي',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'قم بتنشيط هذه الميزة لتحديد نطاق ثابت من السنوات (في المستقبل وفي الماضي) ليتم عرضها في جزء السنة من الحقل.',
        'Years in the past' => 'سنوات في الماضي',
        'Years in the past to display (default: 5 years).' => 'السنوات الماضية المراد عرضها (الافتراضي: 5 سنوات).',
        'Years in the future' => 'سنوات في المستقبل',
        'Years in the future to display (default: 5 years).' => 'السنوات المستقبلية التي يتم عرضها (الافتراضية: 5).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'إذا كنت لا ترغب في ترميز الأحرف الخاصة (&، @، :، /، إلخ)، فاستخدم فلتر "URL" بدلا من عامل تصفية "uri".',
        'Restrict entering of dates' => 'تقييد إدخال البيانات',
        'Here you can restrict the entering of dates of tickets.' => 'هنا يمكنك تقييد إدخال البيانات في هذا الحقل.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'إضافة قيمة',
        'Add empty value' => 'إضافة قيمة فارغة',
        'Activate this option to create an empty selectable value.' => 'قم بتنشيط هذا الخيار لإنشاء قيمة فارغة قابلة للتحديد.',
        'Tree View' => 'عرض الشجرة',
        'Activate this option to display values as a tree.' => 'قم بتنشيط هذا الخيار لعرض القيم كشجرة.',

        # Template: AdminDynamicFieldImportExport
        '%s - %s' => '٪ s -٪ s',
        'Select the items you want to ' => 'حدد العناصر التي تريدها ',
        'Select the desired elements and confirm the import with \'import\'.' =>
            'حدد العناصر المطلوبة وقم بتأكيد الاستيراد باستخدام "استيراد".',
        'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.' =>
            'هنا يمكنك تصدير ملف تكوين من الحقول الديناميكية وشاشات الحقول الديناميكية لاستيرادها على نظام آخر. يتم تصدير ملف التكوين بتنسيق yml.',
        'The following dynamic fields can not be imported because of an invalid backend.' =>
            'لا يمكن استيراد الحقول الديناميكية التالية بسبب خلفية غير صالحة.',
        'Toggle all available elements' => 'تبديل جميع العناصر المتاحة',
        'Fields' => 'حقول',
        'Screens' => 'شاشات',

        # Template: AdminDynamicFieldReference
        'Check ReferenceFilter' => '',
        'Below you can configure filters to restrict the list of referenced objects. The filters compare an attribute of the referenced object either to an attribute of the mask you are currently editing or to a fixed string.' =>
            '',
        'Object attribute' => '',
        'Select an attribute of the referenced object by which the selectable entries will be filtered.' =>
            '',
        'Invalid ReferenceFilter_ReferenceObjectAttribute' => '',
        'matches mask attribute' => '',
        'Select an attribute of the edit mask to compare the selected attribute of the referenced object against.' =>
            '',
        'matches string' => '',
        'Type a string to compare the selected attribute of the referenced object against.' =>
            '',
        'Add ReferenceFilter' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => 'إدارة الحقول الديناميكية <-> شاشات',
        'Overview' => 'نظرة عامة',
        'Default Columns Screens' => 'شاشات الأعمدة الافتراضية',
        'Add DynamicField' => 'إضافة حقل ديناميكي',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            'يمكنك تعيين عناصر لهذه الشاشة/الحقل عن طريق سحب العناصر بالماوس من القائمة اليسرى إلى القائمة اليمنى.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'يمكن أيضا ترتيب العناصر عن طريق تحريكها باستخدام الماوس.',
        'Filter available elements' => 'تصفية العناصر المتوفرة',
        'selected to available elements' => 'العناصر المختارة التي ستكون متاحة',
        'Available Elements' => 'العناصر المتوفرة',
        'Filter disabled elements' => 'تصفية العناصر المعطلة',
        'selected to disabled elements' => 'سيتم إلغاء تنشيط العناصر المحددة',
        'Toggle all disabled elements' => 'تبديل جميع العناصر المعطلة',
        'Disabled Elements' => 'العناصر المعطلة',
        'Filter assigned elements' => 'تصفية العناصر المعينة',
        'selected to assigned elements' => 'العناصر المحددة التي سيتم تعيينها',
        'Toggle all assigned elements' => 'تبديل جميع العناصر المعينة',
        'Assigned Elements' => 'العناصر المعينة',
        'Filter assigned required elements' => 'تصفية العناصر المطلوبة المعينة',
        'selected to assigned required elements' => 'تم اختياره للعناصر المطلوبة المعينة',
        'Toggle all assigned required elements' => 'تبديل جميع العناصر المطلوبة المعينة',
        'Assigned Required Elements' => 'العناصر المطلوبة المعينة',
        'Reset' => 'إعادة ضبط',

        # Template: AdminDynamicFieldScript
        'Expression' => '',
        'The function which will be evaluated.' => '',
        'Requirements' => '',
        'If set, the function will only be evaluated if all chosen attributes are set.' =>
            '',
        'Preview Triggers' => '',
        'If set, the field will be recalculated upon AJAX updates in edit masks.' =>
            '',
        'Storage Triggers (Events)' => '',
        'If set, the field will be recalculated for the following events.' =>
            '',
        'Check RegEx' => 'تحقق من RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'هنا يمكنك تحديد تعبير عادي للتحقق من القيمة. سيتم تنفيذ regex مع المعدلات xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx غير صالح',
        'Error Message' => 'بلاغ الخطأ',
        'Add RegEx' => 'أضف RegEx',

        # Template: AdminDynamicFieldSet
        'Auto Indent Code' => '',
        'Comment/Uncomment Code' => '',
        'Search & Replace' => '',
        'Select All' => '',
        'Full Screen' => '',
        'The YAML array of included dynamic fields. Syntax: \'--- [{DF: Name},...]\'' =>
            '',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'عدد الصفوف',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'يحدد عدد الصفوف لهذا الحقل في وضع التحرير.',
        'Number of cols' => 'عدد الأعمدة',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'حدد العرض (بالأحرف) لهذا الحقل في وضع التحرير.',

        # Template: AdminDynamicFieldTitle
        'Template' => 'نَموذَج',
        'Style' => 'أُسلوب',
        'bold' => 'غَامِقٌ',
        'italic' => 'مَائِلٌ',
        'underline' => 'أكد',
        'Font style of the label.' => 'نمط خط التسمية التوضيحية.',
        'Size' => 'الحجم',
        'Font size of the label.' => 'حجم خط التسمية التوضيحية.',
        'Color in hex.' => 'اللون كقيمة HEX.',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'هذا الحقل مطلوب',
        'The web service to be executed for possible values.' => 'خدمة الويب التي سيتم تنفيذها للقيم المحتملة.',
        'Invoker' => 'المنادي على',
        'The invoker to be used to perform requests (invoker needs to be of type \'Generic::PassThrough\').' =>
            'المستحضر الذي سيتم استخدامه لتنفيذ الطلبات (يجب أن يكون المستحضر من النوع "Generic :: PassThrough").',
        'Activate this option to allow multiselect on results.' => 'قم بتنشيط هذا الخيار للسماح بتحديدات متعددة على النتائج.',
        'Cache TTL' => 'ذاكرة التخزين المؤقت TTL',
        'Cache time to live (in minutes), to save the retrieved possible values.' =>
            'تخزين TTL مؤقتًا (بالدقائق)، لحفظ القيم المحتملة التي تم استردادها.',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens. Optional HTTP link works only for single-select fields.' =>
            'هنا يمكنك تحديد ارتباط HTTP اختياري لقيمة الحقل في لمحات عامة وطرق عرض التفاصيل. يعمل رابط HTTP الاختياري فقط مع الحقول ذات التحديد الفردي.',

        # Template: AdminEmail
        'Admin Message' => 'رسالة المسؤول',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'تسمح هذه الوحدة للمسؤولين بإرسال رسائل إلى الوكلاء أو المجموعة أو أعضاء الأدوار.',
        'Create Administrative Message' => 'إنشاء رسالة مسؤول',
        'Your message was sent to' => 'تم إرسال رسالتك إلى',
        'From' => 'من',
        'Send message to users' => 'إرسال رسالة إلى المستخدمين',
        'Send message to group members' => 'إرسال رسالة إلى أعضاء المجموعة',
        'Group members need to have permission' => 'أعضاء المجموعة بحاجة إلى الحصول على إذن',
        'Send message to role members' => 'إرسال رسالة إلى أعضاء الدور',
        'Also send to customers in groups' => 'أرسل أيضا إلى العملاء في مجموعات',
        'Body' => 'نص الرسالة',
        'Send' => 'أَرْسَلَ',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'إدارة وظائف الوكيل العام',
        'Edit Job' => 'تعديل الوظيفة',
        'Add Job' => 'إضافة وظيفة',
        'Run Job' => 'تشغيل الوظيفة',
        'Include invalid jobs' => '',
        'Filter for Jobs' => 'تصفية للوظائف',
        'Filter for jobs' => 'تصفية للوظائف',
        'Last run' => 'آخر تشغيل',
        'Run Now!' => 'تشغيل الآن!',
        'Delete this task' => 'حذف هذا الطلب',
        'Run this task' => 'تشغيل هذه المهمة',
        'Job Settings' => 'إعدادات الوظيفة',
        'Job name' => 'اسم الوظيفة',
        'The name you entered already exists.' => 'الاسم الذي أدخلته موجود بالفعل.',
        'Automatic Execution (Multiple Tickets)' => 'التنفيذ التلقائي (تذاكر متعددة)',
        'Execution Schedule' => 'خطة التنفيذ',
        'Schedule minutes' => 'تشغيل إلى دقيقة (دقائق)',
        'Schedule hours' => 'تشغيل في ساعة (ساعات)',
        'Schedule days' => 'تشغيل في اليوم (الأيام)',
        'Automatic execution values are in the system timezone.' => 'توجد قيم التنفيذ التلقائي في المنطقة الزمنية للنظام.',
        'Currently this generic agent job will not run automatically.' =>
            'حاليا لن يتم تشغيل وظيفة الوكيل العام هذه تلقائيًا.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'لتمكين التنفيذ التلقائي، حدد قيمة واحدة على الأقل من الدقائق والساعات والأيام!',
        'Event Based Execution (Single Ticket)' => 'التنفيذ القائم على الحدث (تذكرة واحدة)',
        'Event Triggers' => 'محفزات الحدث',
        'List of all configured events' => 'قائمة بجميع الأحداث التي تم تكوينها',
        'Delete this event' => 'حذف هذا الحدث',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'بالإضافة إلى التنفيذ الدوري أو كبديل له، يمكنك تحديد أحداث التذاكر التي ستؤدي إلى تشغيل هذه المهمة.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'إذا تم تشغيل حدث تذكرة، فسيتحقق فلتر التذاكر أولا مما إذا كانت التذكرة المعنية متأثرة أم لا. عندها فقط سيتم تنفيذ الطلب لهذه التذكرة، إذا لزم الأمر.',
        'Do you really want to delete this event trigger?' => 'هل تريد حقًا حذف مشغل هذا الحدث؟',
        'Add Event Trigger' => 'إضافة مشغل الحدث',
        'To add a new event select the event object and event name' => 'حدد كائن الحدث واسمه لإضافة حدث جديد',
        'Select Tickets' => 'حدد التذاكر',
        '(e. g. 10*5155 or 105658*)' => '(على سبيل المثال 10 * 5155 أو 105658 *)',
        '(e. g. 234321)' => '(مثال: 234321)',
        'Customer user ID' => 'رقم مستخدم العميل',
        '(e. g. U5150)' => '(مثل U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'البحث عن النص الكامل في المقالات (مثل "Mar*in" أو "Baue*").',
        'To' => 'إلى',
        'Cc' => 'Cc',
        'Service' => 'خِدْمة',
        'Service Level Agreement' => 'اتفاقية مستوى الخدمة',
        'Queue' => 'قائمة البطاقات',
        'State' => 'الحالة',
        'Agent' => 'عَامِلٌ',
        'Owner' => 'المالك',
        'Responsible' => 'مسؤوليات',
        'Ticket lock' => 'قفل التذاكر',
        'Dynamic fields' => 'الحقول الديناميكية',
        'Add dynamic field' => 'إضافة حقل ديناميكي',
        'Create times' => 'أوقات الإنشاء',
        'No create time settings.' => 'لا توجد إعدادات وقت الإنشاء.',
        'Ticket created' => 'تم إنشاء التذكرة',
        'Ticket created between' => 'تم إنشاء التذكرة بين',
        'and' => 'و',
        'Last changed times' => 'آخر مرة تم تغييرها',
        'No last changed time settings.' => 'لا توجد إعدادات لآخر تعديل.',
        'Ticket last changed' => 'آخر تعديل للتذكرة',
        'Ticket last changed between' => 'آخر تعديل للتذكرة بين',
        'Change times' => 'تغيير الأوقات',
        'No change time settings.' => 'لا تغيير إعدادات الوقت.',
        'Ticket changed' => 'تم تغيير التذكرة',
        'Ticket changed between' => 'تم تغيير التذكرة بين',
        'Last close times' => 'آخر أوقات الإغلاق',
        'No last close time settings.' => 'لا توجد إعدادات وقت الإغلاق الأخير.',
        'Ticket last close' => 'آخر إغلاق للتذكرة',
        'Ticket last close between' => 'آخر تذكرة تم إغلاقها بين',
        'Close times' => 'أوقات الإغلاق',
        'No close time settings.' => 'لا توجد إعدادات وقت الإغلاق.',
        'Ticket closed' => 'تم إغلاق التذكرة',
        'Ticket closed between' => 'تم إغلاق التذكرة بين',
        'Pending times' => 'أوقات التذكير',
        'No pending time settings.' => 'لا توجد إعدادات وقت التذكير.',
        'Ticket pending time reached' => 'تم الوصول إلى وقت تذكير التذكرة',
        'Ticket pending time reached between' => 'وقت تذكير التذكرة الذي تم الوصول إليه بين',
        'Escalation times' => 'أوقات التصعيد',
        'No escalation time settings.' => 'لا توجد إعدادات وقت التصعيد.',
        'Ticket escalation time reached' => 'تم الوصول إلى وقت تصعيد التذاكر',
        'Ticket escalation time reached between' => 'تم الوصول إلى وقت تصعيد التذاكر بين',
        'Escalation - first response time' => 'التصعيد - حان وقت رد الفعل الأول',
        'Ticket first response time reached' => 'تم الوصول إلى وقت استجابة التذكرة',
        'Ticket first response time reached between' => 'وقت استجابة التذكرة الذي تم الوصول إليه بين',
        'Escalation - update time' => 'التصعيد - وقت التحديث',
        'Ticket update time reached' => 'تم الوصول إلى وقت تحديث التذاكر',
        'Ticket update time reached between' => 'وقت تحديث التذاكر الذي تم الوصول إليه بين',
        'Escalation - solution time' => 'التصعيد - وقت الحل',
        'Ticket solution time reached' => 'تم الوصول إلى وقت حل التذاكر',
        'Ticket solution time reached between' => 'وقت حل التذكرة الذي تم الوصول إليه بين',
        'Archive search option' => 'البحث في الأرشيف',
        'Update/Add Ticket Attributes' => 'تحديث / إضافة سمات التذكرة',
        'Set new service' => 'تعيين خدمة جديدة',
        'Set new Service Level Agreement' => 'إنشاء اتفاقية مستوى خدمة جديدة',
        'Set new priority' => 'تعيين أولوية جديدة',
        'Set new queue' => 'تعيين قائمة انتظار جديدة',
        'Set new state' => 'تعيين حالة جديدة',
        'Pending date' => 'انتظر حتى',
        'Set new agent' => 'تعيين وكيل جديد',
        'new owner' => 'مالك جديد',
        'new responsible' => 'مسؤول جديد',
        'Set new ticket lock' => 'تعيين قفل تذكرة جديد',
        'New customer user ID' => 'رقم مستخدم العميل الجديد',
        'New customer ID' => 'رقم عميل جديد',
        'New title' => 'عنوان جديد',
        'New type' => 'نوع جديد',
        'Archive selected tickets' => 'أرشفة التذاكر المختارة',
        'Add Note' => 'إضافة ملاحظة',
        'Visible for customer' => 'مرئي للعملاء',
        'Time units' => 'وحدات زمنية',
        'Execute Ticket Commands' => 'تنفيذ أوامر التذكرة',
        'Send agent/customer notifications on changes' => 'إرسال إشعار وكيل / عميل بالتغييرات',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'يتم تشغيل هذا الأمر مع رقم التذكرة كوسيطة أولى ومعرف التذكرة كوسيطة ثانية.',
        'Delete tickets' => 'حذف التذاكر',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'تحذير: سيتم حذف جميع التذاكر المتأثرة من قاعدة البيانات ولا يمكن استعادتها!',
        'Execute Custom Module' => 'تنفيذ الوحدة النمطية المخصصة',
        'Param %s key' => 'مفتاح Param٪ s',
        'Param %s value' => 'قيمة المعلمة ٪s',
        'Results' => 'النتيجة',
        '%s Tickets affected! What do you want to do?' => 'تأثرت التذاكر بنسبة ٪s! ماذا تريد أن تفعل؟',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'تحذير: أنت تستخدم خيار الحذف. ستفقد جميع التذاكر المحذوفة!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'تحذير:٪ s تذاكر متأثرة، ولكن يمكن تغيير ٪s فقط أثناء تنفيذ الأمر!',
        'Affected Tickets' => 'التذاكر المتأثرة',
        'Age' => 'عمر البطاقة',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface - إدارة خدمة الويب',
        'Web Service Management' => 'إدارة خدمة الويب',
        'Debugger' => 'مُصَحِّحٌ',
        'Go back to web service' => 'العودة إلى خدمة الويب',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            'هل أنت متأكد من أنك تريد حذف سجل تصحيح الأخطاء لخدمة الويب هذه؟',
        'Request List' => 'قائمة الاستفسارات',
        'Time' => 'الوقت',
        'Communication ID' => 'مُعرِّف الاتصال',
        'Remote IP' => 'Remote-IP',
        'Loading' => 'تحميل',
        'Select a single request to see its details.' => 'حدد استفسار لمعرفة تفاصيله.',
        'Filter by type' => 'تصفية حسب النوع',
        'Filter from' => 'تصفية من',
        'Filter to' => 'تصفية إلى',
        'Filter by remote IP' => 'تصفية بواسطة IP البعيد',
        'Limit' => 'حَدّ',
        'Refresh' => 'تَحْدِيثٌ',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'إضافة معالجة الأخطاء',
        'Edit ErrorHandling' => 'تحرير معالجة الأخطاء',
        'Do you really want to delete this error handling module?' => 'هل تريد حقًا حذف وحدة معالجة الأخطاء هذه؟',
        'All configuration data will be lost.' => 'سيتم فقدان جميع بيانات التكوين.',
        'General options' => 'خيارات عامة',
        'The name can be used to distinguish different error handling configurations.' =>
            'يمكن استخدام الاسم للتمييز بين تكوينات معالجة الأخطاء المختلفة.',
        'Please provide a unique name for this web service.' => 'الرجاء إدخال اسم فريد لخدمة الويب هذه.',
        'Error handling module backend' => 'معالجة الأخطاء الخلفية',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'يتم استدعاء الواجهة الخلفية لمعالجة الأخطاء OTOBO داخليا لإجراء معالجة الأخطاء.',
        'Processing options' => 'خيارات المعالجة',
        'Configure filters to control error handling module execution.' =>
            'تكوين عوامل التصفية للتحكم في تنفيذ الوحدة النمطية لمعالجة الأخطاء.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'فقط الطلبات التي تطابق جميع عوامل التصفية التي تم تكوينها (إن وجدت) هي التي ستؤدي إلى تنفيذ الوحدة النمطية.',
        'Operation filter' => 'مرشح التشغيل',
        'Only execute error handling module for selected operations.' => 'تنفيذ وحدة معالجة الأخطاء فقط للعمليات المحددة.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'ملاحظة: بالنسبة للأخطاء التي تحدث عند تلقي بيانات الطلب الوارد، تكون العملية غير محددة. يجب ألا تستخدم المرشحات التي تتضمن مرحلة الخطأ هذه مرشح التشغيل.',
        'Invoker filter' => 'مرشح Invoker',
        'Only execute error handling module for selected invokers.' => 'تنفيذ وحدة معالجة الأخطاء للمستدعين المختارين فقط.',
        'Error message content filter' => 'تصفية لمحتوى رسائل الخطأ',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'أدخل تعبيرا عاديا لتقييد رسائل الخطأ التي يجب أن تتسبب في تنفيذ الوحدة النمطية لمعالجة الأخطاء.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'يتم التحقق من عنوان رسالة الخطأ ومحتواها (كما هو موضح في إدخال خطأ مصحح الأخطاء المقابل) بحثا عن التطابقات.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'مثال: أدخل "^. * 401 Unauthorized. * \ $" لمعالجة الأخطاء المتعلقة بالمصادقة فقط.',
        'Error stage filter' => 'تصفية لمراحل معالجة الخطأ',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'تشغيل وحدة معالجة الأخطاء فقط لمراحل المعالجة المحددة.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'مثال: معالجة الأخطاء التي تحدث عند تعيين البيانات الصادرة فقط.',
        'Error code' => 'رمز الخطأ',
        'An error identifier for this error handling module.' => 'معرف خطأ لوحدة معالجة الأخطاء هذه.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'سيتوفر هذا المعرف في XSLT-Mapping ويظهر في إخراج مصحح الأخطاء.',
        'Error message' => 'رسالة خطأ',
        'An error explanation for this error handling module.' => 'تفسير خطأ لوحدة معالجة الأخطاء هذه.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'ستتوفر هذه الرسالة في XSLT-Mapping وستظهر في إخراج مصحح الأخطاء.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'حدد ما إذا كان يجب إيقاف المعالجة بعد تنفيذ الوحدة النمطية، وتخطي جميع الوحدات المتبقية أو فقط تلك الموجودة في نفس الواجهة الخلفية.',
        'Default behavior is to resume, processing the next module.' => 'السلوك الافتراضي هو استئناف، ومعالجة الوحدة التالية.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'تسمح هذه الوحدة بتكوين عمليات إعادة المحاولة المجدولة للطلبات الفاشلة.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'السلوك الافتراضي لخدمات الويب GenericInterface هو إرسال كل طلب مرة واحدة بالضبط ولا تعيد جدولتها بعد حدوث الأخطاء.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'إذا تم تنفيذ أكثر من وحدة واحدة لطلب ما ، مما يتيح التخطيط للتكرار ، فإن الوحدة النمطية الأخيرة المنفذة تكون حاسمة لاتخاذ قرار بشأن ما إذا كان التكرار مقررا أم لا.',
        'Request retry options' => 'خيارات لإعادة محاولة الطلبات',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'يتم تطبيق خيارات إعادة المحاولة عندما تؤدي الطلبات إلى تشغيل الوحدة النمطية لمعالجة الأخطاء (استنادا إلى خيارات المعالجة).',
        'Schedule retry' => 'جدولة إعادة المحاولة',
        'Should requests causing an error be triggered again at a later time?' =>
            'هل تريد تشغيل طلبات خاطئة مرة أخرى في وقت لاحق؟',
        'Initial retry interval' => 'الفاصل الزمني الأولي لإعادة المحاولة',
        'Interval after which to trigger the first retry.' => 'الفاصل الزمني الذي يتم بعده تشغيل إعادة المحاولة الأولى.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'ملاحظة: يتم حساب الفاصل الزمني لهذه التكرارات وجميع التكرارات الأخرى استنادا إلى وقت تنفيذ وحدة معالجة الأخطاء للطلب الأولي.',
        'Factor for further retries' => 'عامل لمزيد من عمليات إعادة المحاولة',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'إذا قام طلب بإرجاع خطأ حتى بعد إعادة المحاولة الأولى، فحدد ما إذا كانت عمليات إعادة المحاولة اللاحقة يتم تشغيلها باستخدام نفس الفاصل الزمني أو في فترات زمنية متزايدة.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'مثال: إذا تم تشغيل طلب في البداية في الساعة 10:00 مع الفاصل الزمني الأولي عند "دقيقة واحدة" وعامل إعادة المحاولة عند "2"، تشغيل عمليات إعادة المحاولة في الساعة 10:01 (دقيقة واحدة)، 10:03 (2 * 1 = 2 دقيقة)، 10:07 (2 * 2 = 4 دقائق)، 10:15 (2 * 4 = 8 دقائق)، ......',
        'Maximum retry interval' => 'الفاصل الزمني الأقصى لإعادة المحاولة',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'إذا تم تحديد عامل التكرار "1.5" أو "2"، فيمكن تجنب مسافات طويلة بشكل غير مرغوب فيه من خلال تحديد أكبر فاصل زمني ممكن.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'سيتم بعد ذلك تلقائيًا تقصير الفترات المحسوبة لتجاوز الحد الأقصى للفاصل الزمني لإعادة المحاولة وفقًا لذلك.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'مثال: إذا تم تشغيل طلب مبدئيًا في الساعة 10:00 مع فاصل زمني أولي عند "دقيقة واحدة"، وأعد المحاولة عند "2" والفاصل الزمني الأقصى عند "5 دقائق"، فسيتم تشغيل عمليات إعادة المحاولة عند 10:01 (دقيقة واحدة)، 10 : 03 (دقيقتان)، 10:07 (4 دقائق)، 10:12 (8 => 5 دقائق)، 10:17، ...',
        'Maximum retry count' => 'الحد الأقصى لعدد التكرارات',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'الحد الأقصى لعدد عمليات إعادة المحاولة قبل تجاهل الطلب الفاشل، دون احتساب الطلب الأولي.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'مثال: إذا تم تشغيل طلب في البداية في الساعة 10:00 مع الفاصل الزمني الأولي عند "دقيقة واحدة" وعامل إعادة المحاولة عند "2" والحد الأقصى لعدد إعادة المحاولة عند "2"، تشغيل عمليات إعادة المحاولة في الساعة 10:01 والساعة 10:02 فقط.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'ملاحظة: قد لا يتم الوصول إلى الحد الأقصى لعدد مرات إعادة المحاولة إذا تم تكوين الحد الأقصى لفترة إعادة المحاولة أيضًا وتم الوصول إليها في وقت سابق.',
        'This field must be empty or contain a positive number.' => 'يجب أن يحتوي هذا الحقل على رقم موجب أو أن يظل فارغًا.',
        'Maximum retry period' => 'الحد الأقصى لفترة إعادة المحاولة',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'الحد الأقصى من الوقت لإعادة محاولة الطلبات الفاشلة قبل تجاهلها (بناءً على وقت تنفيذ وحدة معالجة الأخطاء للطلب الأولي).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'سيتم تشغيل عمليات إعادة المحاولة التي يتم تشغيلها عادةً بعد انقضاء الفترة القصوى (وفقًا لحساب الفاصل الزمني لإعادة المحاولة) تلقائيًا في أقصى فترة زمنية بالضبط.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'مثال: إذا تم تشغيل طلب في البداية في الساعة 10:00 مع الفاصل الزمني الأولي عند "دقيقة واحدة" وعامل إعادة المحاولة عند "2" والحد الأقصى لفترة إعادة المحاولة عند "30 دقيقة"، تشغيل عمليات إعادة المحاولة في الساعة 10:01 و10:03 و10:07 و10:15 وأخيرا في الساعة 10:31 = >10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'ملاحظة: قد لا يتم الوصول إلى الحد الأقصى لفترة إعادة المحاولة إذا تم تكوين الحد الأقصى لعدد مرات إعادة المحاولة أيضا وتم الوصول إليه في وقت سابق.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'إضافة مستحضر (Invoker)',
        'Edit Invoker' => 'تحرير المستحضر (Invoker)',
        'Do you really want to delete this invoker?' => 'هل تريد حقا حذف هذا المستحضر؟',
        'Invoker Details' => 'تفاصيل المستدعي',
        'The name is typically used to call up an operation of a remote web service.' =>
            'يستخدم الاسم عادةً لاستدعاء عملية خدمة ويب بعيدة.',
        'Invoker backend' => 'الواجهة الخلفية ل Invoker',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'سيتم استدعاء وحدة الواجهة الخلفية OTOBO Invoker لإعداد البيانات لإرسالها إلى النظام البعيد، ومعالجة بيانات الاستجابة الخاصة به.',
        'Mapping for outgoing request data' => 'تعيين بيانات الطلب الصادر',
        'Configure' => 'تهيئة',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'تتم معالجة بيانات استدعاء OTOBO بواسطة هذا التعيين لإعادة تشكيلها عندما يحتاج النظام البعيد إلى البيانات.',
        'Mapping for incoming response data' => 'تعيين بيانات الاستجابة الواردة',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'تتم معالجة بيانات الاستجابة للنظام البعيد بواسطة هذا التعيين لإعادة تشكيله كما هو مطلوب من قبل مستحضر OTOBO.',
        'Asynchronous' => 'غير متزامن',
        'Condition' => 'شَرْط',
        'Edit this event' => 'تحرير هذا الحدث',
        'This invoker will be triggered by the configured events.' => 'يتم تشغيل هذا المستحضر بواسطة الأحداث التي تم تكوينها.',
        'Add Event' => 'إضافة حدث',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'لإضافة حدث جديد، حدد كائن الحدث واسم الحدث وانقر فوق الزر "+"',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'تتم معالجة مشغلات الأحداث غير المتزامنة بواسطة OTOBO Scheduler Daemon في الخلفية (موصى به).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'ستتم معالجة مشغلات الأحداث المتزامنة مباشرة أثناء طلب الويب.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'إعدادات حدث GenericInterface Invoker لخدمة الويب٪ s',
        'Go back to' => 'العودة إلى',
        'Delete all conditions' => 'حذف جميع الشروط',
        'Do you really want to delete all the conditions for this event?' =>
            'هل أنت متأكد أنك تريد حذف جميع الشروط لهذا الحدث؟',
        'General Settings' => 'الإعدادات العامة',
        'Event type' => 'نوع الحدث',
        'Conditions' => 'شُرُوط',
        'Conditions can only operate on non-empty fields.' => 'يمكن أن تعمل الشروط فقط على الحقول غير الفارغة.',
        'Type of Linking between Conditions' => 'نوع الربط بين الشروط',
        'Remove this Condition' => 'إزالة هذا الشرط',
        'Type of Linking' => 'نوع الارتباط',
        'Add a new Field' => 'أضف حقلاً جديدًا',
        'Remove this Field' => 'إزالة هذا الحقل',
        'And can\'t be repeated on the same condition.' => 'ولا يمكن تكرارها على نفس الحالة.',
        'Add New Condition' => 'إضافة شرط جديد',

        # Template: AdminGenericInterfaceInvokerTicket
        'General invoker data' => 'بيانات المستدعي العامة',
        'Settings for outgoing request data' => 'إعدادات بيانات الطلبات الصادرة',
        'Ticket fields' => 'حقول التذاكر',
        'Only the selected ticket fields will be considered for the request data.' =>
            'يتم النظر فقط في حقول التذاكر المحددة لبيانات الطلب.',
        'Article fields' => 'حقول المقالات',
        'Only the selected article fields will be considered for the request data.' =>
            'سيتم النظر فقط في حقول المقالة المحددة لبيانات الطلب.',
        'Ticket dynamic fields' => 'تذاكر الحقول الديناميكية',
        'Only the selected ticket dynamic fields will be considered for the request data.' =>
            'سيتم النظر فقط في الحقول الديناميكية للتذكرة المحددة لبيانات الطلب.',
        'Article dynamic fields' => 'الحقول الديناميكية للمقالة',
        'Only the selected article dynamic fields will be considered for the request data.' =>
            'سيتم النظر فقط في الحقول الديناميكية للمقالة المحددة لبيانات الطلب.',
        'Number of articles' => 'عدد المقالات',
        'The outgoing request data will only contain the configured number of articles. If left empty, only 1 article will be sent.' =>
            'ستحتوي بيانات الطلب الصادر فقط على عدد المقالات التي تم تكوينها. إذا تركت فارغة، سيتم إرسال مقالة 1 فقط.',
        'Communication channels' => 'قنوات الاتصال',
        'The outgoing request data will only consider articles of the selected communication channels. If left empty, articles created by all communication channels will be used.' =>
            'ستأخذ بيانات الطلب الصادر في الاعتبار فقط المقالات الخاصة بقنوات الاتصال المحددة. إذا تُركت فارغة، فسيتم استخدام المقالات التي تم إنشاؤها بواسطة جميع قنوات الاتصال.',
        'Customer visibility' => 'الرؤية للعملاء',
        'The outgoing request data will only consider articles created with the selected customer visibility.' =>
            'لا تأخذ بيانات الطلبات الصادرة في الاعتبار سوى العناصر التي تم إنشاؤها باستخدام رؤية العميل المحددة.',
        'Sender Types' => 'أنواع المرسل',
        'The outgoing request data will only consider articles created by the selected sender types. If left empty, articles created by all sender types will be used.' =>
            'ستأخذ بيانات الطلب الصادر في الاعتبار فقط المقالات التي تم إنشاؤها بواسطة أنواع المرسلين المحددين. إذا تركت فارغة، استخدام المقالات التي تم إنشاؤها بواسطة جميع أنواع المرسلين.',
        'Mapping' => 'تَخْطِيطٌ',
        'Settings for incoming response data' => 'إعدادات بيانات الاستجابة الواردة',
        'Remote TicketID dynamic field' => 'الحقل الديناميكي ل TicketID البعيد',
        'The selected ticket dynamic field is being used to store the remote TicketID.' =>
            'يتم استخدام الحقل الديناميكي المحدد للتذكرة لتخزين TicketID البعيد.',
        'If left empty, the remote TicketID will not be stored, unless you define a system configuration value for this web service.' =>
            'إذا ظلت فارغة، فلن يتم تخزين Remote TicketID إلا إذا تم تعريف قيمة لخدمة الويب هذه في تكوين النظام.',
        'The selected field is already in use by the Ticket dynamic fields option.' =>
            'الحقل المحدد قيد الاستخدام بالفعل بواسطة خيار الحقول الديناميكية للتذكرة.',
        'Only the selected ticket dynamic fields are being considered for processing the incoming response data. If left empty, no dynamic field will be processed.' =>
            'يتم النظر فقط في الحقول الديناميكية للبطاقة المحددة لمعالجة بيانات الاستجابة الواردة. إذا تُركت فارغة، فلن تتم معالجة أي حقل ديناميكي.',
        'Event data' => 'بيانات الحدث',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'رسم الخرائط البسيط',
        'Default rule for unmapped keys' => 'القاعدة الافتراضية للمفاتيح غير المعينة',
        'This rule will apply for all keys with no mapping rule.' => 'يتم تطبيق هذه القاعدة على جميع المفاتيح التي لا تحتوي على قاعدة مطابقة.',
        'Default rule for unmapped values' => 'القاعدة الافتراضية للقيم غير المعينة',
        'This rule will apply for all values with no mapping rule.' => 'يتم تطبيق هذه القاعدة على كافة القيم بدون قاعدة مطابقة.',
        'New key map' => 'تعيين مفتاح جديد',
        'Add key mapping' => 'إضافة تعيين مفتاح',
        'Mapping for Key ' => 'تعيين المفاتيح ',
        'Remove key mapping' => 'إزالة تعيين المفاتيح',
        'Key mapping' => 'تخطيط المفاتيح',
        'Map key' => 'مفتاح الخريطة',
        'matching the' => 'مطابقة مع',
        'to new key' => 'تعيين مفتاح جديد',
        'Value mapping' => 'تعيين القيمة',
        'Map value' => 'أهَمِّيَّةٌ',
        'to new value' => 'إلى قيمة جديدة',
        'Remove value mapping' => 'إزالة تعيين القيمة',
        'New value map' => 'تعيين قيمة جديدة',
        'Add value mapping' => 'إضافة تعيين القيمة',
        'Do you really want to delete this key mapping?' => 'هل تريد حقًا حذف تعيين المفتاح هذا؟',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'اختصارات لوحة المفاتيح العامة',
        'MacOS Shortcuts' => 'اختصارات لوحة مفاتيح MacOS',
        'Comment/Uncomment code' => '',
        'Auto indent code' => '',
        'Jump to line' => '',
        'Autocomplete' => '',
        'Find' => 'بَحَثَ',
        'Find next' => 'البحث عن التالي',
        'Find previous' => 'البحث عن السابق',
        'Find and replace' => 'البحث والاستبدال',
        'Exit full screen' => '',
        'XSLT Mapping' => 'تعيين XSLT',
        'XSLT stylesheet' => 'ورقة الأنماط XSLT',
        'The entered data is not a valid XSLT style sheet.' => 'البيانات التي تدخلها ليست ورقة أنماط XSLT صالحة.',
        'Here you can add or modify your XSLT mapping code.' => 'هنا يمكنك إضافة أو تعديل كود تعيين XSLT.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'يسمح حقل التحرير باستخدام وظائف مختلفة مثل التنسيق التلقائي وتغيير حجم النافذة وإكمال العلامة والأقواس.',
        'Data includes' => 'تتضمن البيانات',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'حدد مجموعة واحدة أو أكثر من البيانات التي تم إنشاؤها في مراحل الطلب/الاستجابة السابقة ليتم تضمينها في البيانات القابلة للتعيين.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'ستظهر هذه المجموعات في بنية البيانات في \'< DataInclude / <DataSetName/\' (راجع إخراج مصحح الأخطاء للطلبات الفعلية للحصول على التفاصيل).',
        'Data key regex filters (before mapping)' => 'عامل تصفية RegEx لمفاتيح البيانات (قبل التعيين)',
        'Data key regex filters (after mapping)' => 'عامل تصفية RegEx لمفاتيح البيانات (بعد التعيين)',
        'Regular expressions' => 'التعبيرات العادية',
        'Replace' => 'اِسْتَبْدَلَ',
        'Remove regex' => 'إزالة regex',
        'Add regex' => 'إضافة regex',
        'These filters can be used to transform keys using regular expressions.' =>
            'يمكن استخدام هذه المرشحات لتحويل المفاتيح باستخدام التعبيرات العادية.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'سيتم اجتياز بنية البيانات بشكل متكرر ويتم تطبيق جميع التعبيرات العادية التي تم تكوينها على جميع المفاتيح.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'حالات الاستخدام هي على سبيل المثال إزالة بادئات المفاتيح غير المرغوب فيها أو تصحيح المفاتيح التي لا تمثل أسماء عناصر XML صالحة.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'مثال 1: البحث = \'^ jira:\' / استبدال = \'\' يحول \'jira: element\' إلى \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'مثال 2: البحث = \'^\' / استبدال = \'_\' يحول \'16x16\' إلى \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'المثال 3: البحث = \'^ (+number> \ d>) (؟+.<text>؟) \ $\' / استبدال = \'_ \ $ + {text} _ \ $ + {number}\' يحول \'16 elementname\'إلى\' elementname_16_\'.',
        'For information about regular expressions in Perl please see here:' =>
            'يمكن العثور على معلومات حول التعبيرات النمطية في لغة Perl هنا:',
        'Perl regular expressions tutorial' => 'برنامج تعليمي عن التعبيرات العادية في لغة Perl',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'إذا كان استخدام المُعدِّلات مطلوبًا، فيجب تحديدها ضمن التعبيرات النمطية.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'يتم تطبيق التعبيرات العادية المعرفة هنا قبل تعيين XSLT.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'يتم تطبيق التعبيرات العادية المعرفة هنا بعد تعيين XSLT.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'إضافة عملية',
        'Edit Operation' => 'تحرير العملية',
        'Do you really want to delete this operation?' => 'هل تريد حقًا حذف هذه العملية؟',
        'Operation Details' => 'تفاصيل العملية',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'يستخدم الاسم عادةً لاستدعاء عملية خدمة الويب من نظام بعيد.',
        'Operation backend' => 'الواجهة الخلفية للعمليات',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'يتم استدعاء وحدة الواجهة الخلفية لعملية OTOBO داخليًا لمعالجة الطلب وإنشاء بيانات للاستجابة.',
        'Mapping for incoming request data' => 'تعيين بيانات الطلب الوارد',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'تتم معالجة بيانات الطلب الواردة من خلال هذا التعيين لتحويلها إلى الطريقة التي تحتاجها عملية OTOBO.',
        'Mapping for outgoing response data' => 'تعيين بيانات الاستجابة الصادرة',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'تتم معالجة بيانات الاستجابة بواسطة هذا التعيين لإعادة تشكيلها عندما يحتاج النظام البعيد إلى البيانات.',
        'Include Ticket Data' => 'تضمين بيانات التذكرة',
        'Include ticket data in response.' => 'تضمين بيانات التذكرة استجابة لذلك.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'شبكة النقل',
        'Properties' => 'خَصَائص',
        'Route mapping for Operation' => 'تعيين الطريق للعملية',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'يحدد المسار الذي سيتم تعيينه للعملية. المتغيرات المميزة بعلامة ":" يتم تعيينها إلى الاسم المُدخل وتمريرها إلى الوظيفة باستخدام المتغيرات الأخرى. (على سبيل المثال: / Ticket /: TicketID).',
        'Valid request methods for Operation' => 'طرق طلب صالحة للتشغيل',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'قصر هذه العملية على طرق طلب محددة. إذا لم يتم تحديد طريقة الطلب، فسيتم قبول جميع الطلبات.',
        'Maximum message length' => 'الحد الأقصى لطول الرسالة',
        'This field should be an integer number.' => 'يجب أن يكون هذا الحقل عددًا صحيحًا.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'حدد الحجم الأقصى (بالبايت) لرسائل REST التي يجب أن يقبلها OTOBO.',
        'Send Keep-Alive' => 'أرسل Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'يحدد هذا التكوين ما إذا كان يجب إغلاق الاتصالات الواردة أو الإبقاء عليها حية.',
        'Additional response headers' => 'رؤوس استجابة إضافية',
        'Add response header' => 'أضف عنوان الرد',
        'Endpoint' => 'نقطة النهاية',
        'URI to indicate specific location for accessing a web service.' =>
            'عنوان URI لتحديد موقع معين للوصول إلى خدمة ويب.',
        'e.g. https://www.otobo.de:10745/api/v1.0 (without trailing backslash)' =>
            'على سبيل المثال https://www.otobo.de:10745/api/v1.0 (بدون الخط المائل العكسي)',
        'Timeout' => 'مُهْلَةٌ',
        'Timeout value for requests.' => 'قيمة المهلة للطلبات.',
        'Authentication' => 'مُصَادَقَةٌ',
        'An optional authentication mechanism to access the remote system.' =>
            'طريقة المصادقة الاختيارية للوصول إلى النظام البعيد.',
        'BasicAuth User' => 'مستخدم BasicAuth',
        'The user name to be used to access the remote system.' => 'اسم المستخدم الذي سيتم استخدامه للوصول إلى النظام البعيد.',
        'BasicAuth Password' => 'كلمة مرور BasicAuth',
        'The password for the privileged user.' => 'كلمة مرور المستخدم المصرح له.',
        'Kerberos User' => '',
        'Kerberos keytab file' => '',
        'The kerberos keytab file for the privileged user.' => '',
        'Use Proxy Options' => 'استخدام خيارات الوكيل',
        'Show or hide Proxy options to connect to the remote system.' => 'إظهار خيارات الوكيل أو إخفاؤها للاتصال بالنظام البعيد.',
        'Proxy Server' => 'مخدم بروكسي',
        'URI of a proxy server to be used (if needed).' => 'عنوان URI لخادم وكيل (اختياري).',
        'e.g. http://proxy_hostname:8080' => 'على سبيل المثال http://proxy_hostname:8080',
        'Proxy User' => 'مستخدم الوكيل',
        'The user name to be used to access the proxy server.' => 'اسم المستخدم للوصول إلى الخادم الوكيل.',
        'Proxy Password' => 'كلمة مرور الوكيل',
        'The password for the proxy user.' => 'كلمة مرور مستخدم الوكيل.',
        'Skip Proxy' => '‮تخطي الوكيل',
        'Skip proxy servers that might be configured globally?' => 'هل تريد تجاوز الخوادم الوكيلة المحتملة التي تم تكوينها عالميًا؟',
        'Use SSL Options' => 'استخدم خيارات SSL',
        'Show or hide SSL options to connect to the remote system.' => 'إظهار أو إخفاء خيارات SSL للاتصال بالنظام البعيد.',
        'Client Certificate' => 'شهادة العميل',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'المسار الكامل واسم ملف شهادة عميل SSL (يجب أن يكون بتنسيق PEM أو DER أو PKCS#12).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'على سبيل المثال opt/otobo/var/certificates/SOAP/certificate.pem/',
        'Client Certificate Key' => 'مفتاح شهادة العميل',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'المسار الكامل واسم ملف مفتاح شهادة عميل SSL (إذا لم يكن مدرجًا بالفعل في ملف الشهادة).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'على سبيل المثال opt/otobo/var/certificates/SOAP/key.pem/',
        'Client Certificate Key Password' => 'كلمة المرور لمفتاح شهادة العميل',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'كلمة المرور للوصول إلى شهادة SSL إذا كان المفتاح مشفرا.',
        'Certification Authority (CA) Certificate' => 'شهادة المرجع المصدق (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'المسار الكامل واسم ملف شهادة المرجع المصدق الذي يتحقق من صحة شهادة SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'على سبيل المثال opt/otobo/var/certificates/SOAP/CA/ca.pem/',
        'Certification Authority (CA) Directory' => 'دليل المرجع المصدق (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'المسار الكامل واسم الملف الخاص بدليل CA حيث يتم تخزين شهادات CA.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'على سبيل المثال opt/otobo/var/certificates/SOAP/CA/',
        'SSL hostname verification.' => 'التحقق من اسم مضيف SSL.',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            'قم بإلغاء الطلب إذا كان لا يمكن التحقق من اسم المضيف. تعطيل بحذر! يعد تخطي التحقق مخاطرة أمنية! بشكل أساسي لأغراض الاختبار في حالة شهادات SSL الموقعة ذاتيًا، أو إذا كنت تعرف ما تفعله.',
        'Controller mapping for Invoker' => 'تعيين وحدة التحكم للمستحضرين',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'وحدة التحكم التي يجب على المستحضر إرسال الطلبات إليها. المتغيرات المميزة بعلامة ":" سيتم استبدالها بقيمة البيانات وتمريرها مع الطلب. (على سبيل المثال Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password/).',
        'Valid request command for Invoker' => 'أمر طلب صالح للمستحضرين',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'أمر HTTP محدد لاستخدامه للطلبات مع هذا المستحضر (اختياري).',
        'Default command' => 'الأمر الافتراضي',
        'The default HTTP command to use for the requests.' => 'أمر HTTP الافتراضي المراد استخدامه للطلبات.',
        'Additional request headers (all invokers)' => 'رؤوس طلبات إضافية (جميع المستدعين)',
        'Additional request headers (invoker specific)' => 'رؤوس طلبات إضافية (خاص بالمستدعى)',
        'Remove all headers for this invoker' => 'إزالة كافة الرؤوس لهذا المستدعي',
        'Headers for invoker' => 'رأس المستحضر',
        'Additional response headers (all operations)' => 'رؤوس استجابة إضافية (كل العمليات)',
        'Additional response headers (operation specific)' => 'رؤوس استجابة إضافية (عمليات محددة)',
        'Remove all headers for this operation' => 'إزالة كافة الرؤوس لهذه العملية',
        'Headers for operation' => 'رؤوس للعملية',
        'Common headers' => 'الرؤوس المشتركة',
        'Header Name' => 'اسم الرأس',
        'Remove header' => 'إزالة الرأس',
        'Add header' => 'إضافة رأس',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otobo.de:8000/Webservice/Example' => 'على سبيل المثال https://local.otobo.de:8000/Webservice/Example',
        'Set SOAPAction' => 'إعداد SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'اضبط على "نعم" لإرسال رأس SOAPAction مملوء.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'اضبط على "لا" لإرسال رأس SOAPAction فارغ.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'اضبط على "نعم" للتحقق من رأس SOAPAction المستلم (إذا لم يكن فارغًا).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'اضبط على "لا" لتجاهل رأس SOAPAction المستلم.',
        'SOAPAction scheme' => 'مخطط SOAPAction',
        'Select how SOAPAction should be constructed.' => 'حدد كيفية بناء SOAPAction.',
        'Some web services require a specific construction.' => 'تتطلب بعض خدمات الويب تصميما محددا.',
        'Some web services send a specific construction.' => 'ترسل بعض خدمات الويب بنية محددة.',
        'SOAPAction separator' => 'فاصل SOAPAction',
        'Character to use as separator between name space and SOAP operation.' =>
            'الحرف المراد استخدامه كفاصل بين مساحة الاسم وعملية SOAP.',
        'Usually .Net web services use "/" as separator.' => 'عادةً ما تستخدم خدمات الويب Net. "/" كفاصل.',
        'SOAPAction free text' => 'نص مجاني من SOAPAction',
        'Text to be used to as SOAPAction.' => 'النص المراد استخدامه ك SOAPAction.',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI الذي يعطي أساليب SOAP سياقًا، مما يقلل الغموض.',
        'e.g. urn:otobo-com:soap:functions or http://www.otobo.de/GenericInterface/actions' =>
            'على سبيل المثال urn:otobo-com:soap:functions أو http://www.otobo.de/GenericInterface/actions',
        'Request name scheme' => 'طلب مخطط التسمية',
        'Select how SOAP request function wrapper should be constructed.' =>
            'اختر كيفية إنشاء استدعاء وظيفة SOAP.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            'يستخدم "FunctionName" كمثال على الاسم الفعلي للمستحضر / العملية.',
        '\'FreeText\' is used as example for actual configured value.' =>
            'يتم استخدام \'FreeText\' كمثال على القيمة الفعلية المكونة.',
        'Request name free text' => 'نص مجاني لأسماء الطلبات',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'نص لاستخدامه كمرفق أو كبديل لاسم الوظيفة.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'يرجى مراعاة قيود تسمية عناصر XML (على سبيل المثال، لا تستخدم "<" و "&").',
        'Response name scheme' => 'مخطط تسمية الاستجابة',
        'Select how SOAP response function wrapper should be constructed.' =>
            'حدد كيفية إنشاء غلاف وظيفة استجابة SOAP.',
        'Response name free text' => 'نص مجاني لاسم الإجابة',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'هنا يمكنك تحديد الحد الأقصى للحجم (بالبايت) لرسائل SOAP التي يعالجها OTOBO.',
        'Encoding' => 'تَشْفِيْر',
        'The character encoding for the SOAP message contents.' => 'ترميز الأحرف لمحتوى رسالة SOAP.',
        'e.g. utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'على سبيل المثال utf-8، latin1، iso-8859-1، cp1250، إلخ.',
        'Sort options' => 'خيارات الفرز',
        'Add new first level element' => 'أضف عنصرًا جديدًا في المستوى الأعلى',
        'Element' => 'عُنْصُر',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'الفرز لحقول XML الصادرة (البنية أسفل استدعاء الدالة) - راجع الوثائق الخاصة بنقل SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'إضافة خدمة ويب',
        'Edit Web Service' => 'تحرير خدمة الويب',
        'Include invalid webservices' => '',
        'Clone Web Service' => 'استنساخ خدمة الويب',
        'The name must be unique.' => 'يجب أن يكون الاسم فريدا.',
        'Clone' => 'اِسْتِنْساخٌ',
        'Export Web Service' => 'تصدير خدمة الويب',
        'Import web service' => 'استيراد خدمة الويب',
        'Configuration File' => 'ملف التكوين',
        'The file must be a valid web service configuration YAML file.' =>
            'يجب أن يكون الملف ملف تكوين خدمة ويب صالحًا بتنسيق YAML.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'هنا يمكنك تحديد اسم لخدمة الويب. إذا كان هذا الحقل فارغًا، فسيتم استخدام اسم ملف التكوين كاسم.',
        'Import' => 'اِسْتِيراد',
        'Configuration History' => 'تاريخ التكوين',
        'Delete web service' => 'حذف خدمة الويب',
        'Do you really want to delete this web service?' => 'هل تريد حقًا حذف خدمة الويب هذه؟',
        'Ready2Adopt Web Services' => 'خدمات الويب Ready2Adopt',
        'Here you can activate Ready2Adopt web services showcasing our best practices.' =>
            'هنا يمكنك تفعيل خدمات الويب Ready2Adoption التي تعرض أفضل ممارساتنا.',
        'Import Ready2Adopt web service' => 'استيراد خدمة ويب Ready2Adopt',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'بعد حفظ التكوين، ستتم إعادة توجيهك مرة أخرى إلى شاشة التحرير.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'إذا كنت تريد العودة إلى النظرة العامة، يرجى استخدام زر "الرجوع إلى النظرة العامة".',
        'Remote system' => 'نظام التحكم عن بعد',
        'Provider transport' => 'مزود النقل',
        'Requester transport' => 'نقل مقدم الطلب',
        'Debug threshold' => 'مستوى التصحيح',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'في وضع المزود، تقدم OTOBO خدمات الويب التي تستخدمها الأنظمة البعيدة.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'في وضع "الطالب"، يستخدم OTOBO نفسه خدمات الويب من الأنظمة الخارجية.',
        'Network transport' => 'شبكة النقل',
        'Error Handling Modules' => 'وحدات معالجة الأخطاء',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'تستخدم وحدات معالجة الأخطاء للاستجابة للأخطاء التي تحدث أثناء الاتصال. يتم تشغيل هذه الوحدات بترتيب ثابت، والذي يمكنك تغييره عن طريق تحريكها باستخدام الماوس.',
        'Backend' => 'خَلْفِيَّة',
        'Add error handling module' => 'أضف وحدة معالجة الأخطاء',
        'Operations are individual system functions which remote systems can request.' =>
            'العمليات هي وظائف نظام فردية يمكن للأنظمة البعيدة الاتصال بها.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'يقوم المستدعون بإعداد البيانات لطلب إلى خدمة ويب بعيدة، ومعالجة بيانات الاستجابة الخاصة بها.',
        'Controller' => 'وحدات تحكم',
        'Inbound mapping' => 'تعيين الخرائط الواردة',
        'Outbound mapping' => 'تعيين الخرائط الصادرة',
        'Delete this action' => 'حذف هذا الإجراء',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'لا يزال هناك٪ s واحد على الأقل لديه وحدة تحكم غير نشطة أو غير موجودة، يرجى التحقق من تسجيل وحدة التحكم أو حذف٪ s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'تاريخ',
        'Go back to Web Service' => 'العودة إلى خدمة الويب',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'هنا يمكنك عرض الإصدارات القديمة من تكوين خدمة الويب الحالية أو تصديرها أو حتى استعادتها.',
        'Configuration History List' => 'قائمة محفوظات التكوين',
        'Version' => 'النسخة',
        'Create time' => 'وقت الإنشاء',
        'Select a single configuration version to see its details.' => 'حدد إصدار تكوين واحد للاطلاع على تفاصيله.',
        'Export web service configuration' => 'تصدير تكوين خدمة ويب',
        'Restore web service configuration' => 'استعادة تكوين خدمة الويب',
        'Do you really want to restore this version of the web service configuration?' =>
            'هل تريد حقًا استعادة هذا الإصدار من تكوين خدمة الويب؟',
        'Your current web service configuration will be overwritten.' => 'سيتم الكتابة فوق تكوين خدمة الويب الحالي الخاص بك.',

        # Template: AdminGroup
        'Group Management' => 'إدارة المجموعات',
        'Add Group' => 'إضافة مجموعة',
        'Edit Group' => 'تحرير المجموعة',
        'Include invalid groups' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'مجموعة المسؤول هي الدخول إلى منطقة المسؤول ومجموعة الإحصائيات للحصول على منطقة الإحصائيات.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'إنشاء مجموعات جديدة للتعامل مع أذونات الوصول لمجموعات مختلفة من الوكلاء (مثل قسم المشتريات، قسم الدعم، قسم المبيعات، ...). ',
        'It\'s useful for ASP solutions. ' => 'هذا مفيد لحلول ASP. ',

        # Template: AdminImportExport
        'Import/Export Management' => '',
        'Add template' => '',
        'Create a template to import and export object information.' => '',
        'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.' =>
            '',
        'Number' => 'الرقم',
        'Format' => 'تنسيق',
        'Start Import' => '',
        'Start Export' => '',
        'Delete this template' => '',
        'Step 1 of 5 - Edit common information' => '',
        'Name is required!' => '',
        'Object is required!' => '',
        'Format is required!' => '',
        'Next' => 'التالي',
        'Step 2 of 5 - Edit object information' => '',
        'Back' => 'السابق',
        'Step 3 of 5 - Edit format information' => '',
        'is required!' => '',
        'Step 4 of 5 - Edit mapping information' => '',
        'No map elements found.' => '',
        'Up' => 'أعلى',
        'Down' => 'من',
        'Add Mapping Element' => '',
        'Step 5 of 5 - Edit search information' => '',
        'Template Name' => 'اسم القالب',
        'Restrict export per search' => '',
        'Finish' => 'إِنْهاء',
        'Import information' => '',
        'Source File' => '',
        'Import summary for %s' => '',
        'Records' => '',
        'Success' => '',
        'Failed' => 'فشل',
        'Duplicate names' => '',
        'Last processed line number of import file' => '',
        'Ok' => '',
        'Do you really want to delete this template item?' => '',

        # Template: AdminLog
        'System Log' => 'سجل النظام',
        'Here you will find log information about your system.' => 'ستجد هنا معلومات السجل حول نظامك.',
        'Hide this message' => 'إخفاء هذا الإشعار',
        'Recent Log Entries' => 'الإدخالات الحالية في سجل النظام',
        'Facility' => 'مرفق',
        'Message' => 'رسالة',

        # Template: AdminMailAccount
        'Mail Account Management' => 'إدارة حساب البريد الإلكتروني',
        'Add Mail Account' => 'إضافة حساب بريد إلكتروني',
        'Edit Mail Account for host' => 'تحرير حساب البريد الإلكتروني للمضيف',
        'and user account' => 'وحساب المستخدم',
        'Include invalid Mail Accounts' => '',
        'Filter for Mail Accounts' => 'تصفية حسابات البريد الإلكتروني',
        'Filter for mail accounts' => 'تصفية حسابات البريد الإلكتروني',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'يتم فرز رسائل البريد الإلكتروني الواردة من حسابات POP3 في قائمة الانتظار المحددة.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'إذا تم تمييز حسابك على أنه موثوق به، فسيتم الاحتفاظ برؤوس X-OTOBO الموجودة بالفعل في وقت الوصول (للأولوية وما إلى ذلك) واستخدامها، على سبيل المثال في مرشحات PostMaster.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'يمكن تكوين البريد الإلكتروني الصادر عبر إعدادات *Sendmail في ٪s.',
        'System Configuration' => 'تكوين النظام',
        'Host' => 'مُضيف',
        'Delete account' => 'حذف الحساب',
        'Fetch mail' => 'جلب البريد',
        'Do you really want to delete this mail account?' => 'هل أنت متأكد أنك تريد حذف حساب البريد الإلكتروني هذا؟',
        'Example: mail.example.com' => 'مثال: mail.example.com',
        'IMAP Folder' => 'مجلد IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'قم بتغيير هذا الإعداد فقط إذا كان سيتم جلب رسائل البريد الإلكتروني من مجلد آخر غير "INBOX".',
        'Trusted' => 'موثوق',
        'Dispatching' => 'تَوْزِيعٌ',
        'Edit Mail Account' => 'تحرير حساب البريد الإلكتروني',

        # Template: AdminNavigationBar
        'Administration Overview' => 'نظرة عامة على الإدارة',
        'Filter for Items' => 'تصفية للعناصر',
        'Favorites' => 'الْمُفَضَّلَة',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'يمكنك إضافة المفضلة عن طريق تحريك المؤشر فوق العناصر الموجودة على الجانب الأيسر والنقر فوق رمز النجمة.',
        'Links' => 'روابط',
        'View the admin manual' => '',
        'No Matches' => 'لا يوجد تطابق',
        'Sorry, your search didn\'t match any items.' => 'عذرا، لم يتطابق بحثك مع أي عناصر.',
        'Set as favorite' => 'تعيين كمفضلة',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'إدارة إشعارات التذاكر',
        'Include invalid notifications' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'هنا يمكنك تحميل ملف تكوين يمكن استخدامه لاستيراد إشعارات التذاكر إلى النظام. يجب أن يكون الملف في ملف تنسيق yml.، تماما كما يتم تصديره بواسطة وحدة إشعار التذكرة.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'هنا يمكنك تحديد الأحداث التي تؤدي إلى تشغيل هذا الإشعار. يمكن تعيين مرشح تذاكر إضافي أدناه لإرسال الإشعار فقط بشأن التذاكر ذات الخصائص المحددة.',
        'Ticket Filter' => 'فلتر التذاكر',
        'Lock' => 'إقفال',
        'SLA' => 'SLA',
        'Customer User ID' => 'رقم مستخدم العميل',
        'Article Filter' => 'فلتر المقالة',
        'Only for ArticleCreate and ArticleSend event' => 'فقط للأحداث ArticleCreate و ArticleSend',
        'Article sender type' => 'نوع مرسل المقالة',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'إذا تم استخدام ArticleCreate أو ArticleSend كحدث محفز، فأنت بحاجة إلى تحديد عامل تصفية المقالة أيضًا. الرجاء تحديد حقل واحد على الأقل من حقول تصفية المقالات.',
        'Communication channel' => 'قناة الاتصال',
        'Include attachments to notification' => 'إرفاق المرفقات بالإشعار',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'قم بإخطار المستخدم مرة واحدة فقط يوميا بتذكرة واحدة باستخدام وسيلة نقل محددة.',
        'Notifications are sent to an agent or a customer.' => 'يتم إرسال الإشعارات إلى الوكلاء والعملاء.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'أول 20 حرفا من الموضوع (مقالة الوكيل الأخيرة).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'الأسطر الخمسة الأولى من الرسالة (مقالة الوكيل الأخيرة).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'أول 20 حرفًا من الموضوع (من آخر مقالة للعميل).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'الأسطر الخمسة الأولى من الرسالة (مقالة العميل الأخيرة).',
        'Attributes of the current customer user data' => 'سمات سجل مستخدم الزبون الحالي',
        'Attributes of the current ticket owner user data' => 'سمات بيانات مستخدم مالك التذكرة الحالي',
        'Attributes of the current ticket responsible user data' => 'سمات بيانات المستخدم المسؤولة عن التذكرة الحالية',
        'Attributes of the current agent user who requested this action' =>
            'سمات بيانات المستخدم للوكيل الذي أدى إلى تنفيذ الإجراء',
        'Attributes of the ticket data' => 'سمات بيانات التذكرة',
        'Ticket dynamic fields internal key values' => 'المفاتيح الداخلية للحقول الديناميكية للتذكرة',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'عرض قيم الحقول الديناميكية للتذكرة، والتي يمكن استخدامها لحقول الاختيار',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'استخدم الفواصل أو الفاصلة المنقوطة للفصل بين عناوين البريد الإلكتروني.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'يمكنك استخدام علامات OTOBO مثل <..._OTOBO_TICKET_DynamicField> لإدراج قيم التذكرة الحالية.',

        # Template: AdminPGP
        'PGP Management' => 'إدارة PGP',
        'Add PGP Key' => 'إضافة مفتاح PGP',
        'PGP support is disabled' => 'تم تعطيل دعم PGP',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'لتتمكن من استخدام PGP في OTOBO، يجب عليك تمكينه أولاً.',
        'Enable PGP support' => 'تفعيل دعم PGP',
        'Faulty PGP configuration' => 'تكوين PGP غير صحيح',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'تم تمكين دعم PGP، لكن التكوين غير صحيح. يرجى التحقق من التكوين بالنقر فوق الزر أدناه.',
        'Configure it here!' => 'قم بتكوينه هنا!',
        'Check PGP configuration' => 'تحقق من تكوين PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'وبهذه الطريقة يمكنك تحرير حلقة المفاتيح التي تم تكوينها مباشرة في SysConfig.',
        'Introduction to PGP' => 'مقدمة في PGP',
        'Bit' => 'بِتْ',
        'Fingerprint' => 'بصمة الإصبع',
        'Expires' => 'تنتهي',
        'Delete this key' => 'حذف هذا المفتاح',
        'PGP key' => 'مفتاح PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'إدارة الحزم',
        'Uninstall Package' => 'إلغاء تثبيت الحزمة',
        'Uninstall package' => 'إلغاء تثبيت الحزمة',
        'Do you really want to uninstall this package?' => 'هل تريد حقًا إلغاء تثبيت هذه الحزمة؟',
        'Reinstall package' => 'إعادة تثبيت الحزمة',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'هل أنت متأكد أنك تريد إعادة تثبيت هذه الحزمة؟ ستفقد جميع التغييرات اليدوية.',
        'Go to updating instructions' => 'انتقل إلى تعليمات التحديث',
        'Go to the OTOBO customer portal' => 'انتقل إلى بوابة عملاء OTOBO',
        'package information' => 'معلومات الحزمة',
        'Package installation requires a patch level update of OTOBO.' =>
            'يتطلب تثبيت الحزمة تحديث مستوى التصحيح من OTOBO.',
        'Package update requires a patch level update of OTOBO.' => 'يتطلب تحديث الحزمة تحديث مستوى التصحيح من OTOBO.',
        'Please note that your installed OTOBO version is %s.' => 'يرجى ملاحظة أن إصدار OTOBO المثبت لديك هو٪ s.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'لتثبيت هذه الحزمة، يجب عليك أولاً تحديث OTOBO إلى الإصدار٪ s أو أحدث.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'يمكن تثبيت هذه الحزمة فقط على إصدار OTOBO ٪ s أو الأقدم.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'يمكن تثبيت هذه الحزمة فقط على إصدار OTOBO ٪ s أو الأحدث.',
        'Why should I keep OTOBO up to date?' => 'لماذا يجب أن أبقي OTOBO محدثًا؟',
        'You will receive updates about relevant security issues.' => 'ستتلقى تحديثات حول قضايا الأمان ذات الصلة.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'ستتلقى تحديثات لجميع المشكلات الأخرى ذات الصلة ب OTOBO.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'كيف يمكنني إجراء تحديث لمستوى التصحيح إذا لم يكن لدي عقد؟',
        'Please find all relevant information within the updating instructions at %s.' =>
            'يرجى الاطلاع على جميع المعلومات ذات الصلة ضمن تعليمات التحديث على ٪s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'إذا كان لديك أي أسئلة أخرى، سنكون سعداء بالإجابة عليها.',
        'Please visit our customer portal and file a request.' => 'يرجى زيارة بوابة العملاء وفتح استفسار.',
        'Install Package' => 'تثبيت الحزمة',
        'Update Package' => 'حزمة التحديث',
        'Continue' => 'التَّالِي',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'قم بتخصيص قاعدة البيانات الخاصة بك لقبول الحزم التي تزيد عن ٪s ميغا بايت (لا تقبل حاليًا سوى حزم يصل حجمها إلى٪ s ميغا بايت). يرجى ضبط إعداد "max_allowed_packet" على تكوين قاعدة البيانات لتجنب الأخطاء.',
        'Install' => 'تثبيت',
        'Update repository information' => 'تحديث الدليل',
        'Cloud services are currently disabled.' => 'الخدمات السحابية معطلة حاليا.',
        'OTOBO Verify can not continue!' => 'OTOBO Verify لا يمكن أن يستمر!',
        'Enable cloud services' => 'تفعيل الخدمات السحابية',
        'Update all installed packages' => 'تحديث كافة الحزم المثبتة',
        'Online Repository' => 'الدليل الإلكتروني',
        'Vendor' => 'موفّر',
        'Action' => 'إِجْرَاءٌ',
        'Module documentation' => 'وثائق الوحدة',
        'Local Repository' => 'الدليل المحلي',
        'This package is verified by OTOBOverify (tm)' => 'تمت مراجعة هذه الحزمة من قبل OTOBOVerify (tm)',
        'Uninstall' => 'إلغاء تثبيت',
        'Package not correctly deployed! Please reinstall the package.' =>
            'الحزمة غير مثبتة بشكل صحيح. الرجاء التثبيت مرة أخرى.',
        'Reinstall' => 'إعادة التثبيت',
        'Features for %s customers only' => 'حصري: ميزات لعملاء ٪s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'باستخدام ٪s، يمكنك الاستفادة من الميزات الاختيارية التالية. يرجى الاتصال ب ٪s لمزيد من المعلومات.',
        'Package Information' => 'معلومات الحزمة',
        'Download package' => 'تحميل الحزمة',
        'Rebuild package' => 'إعادة بناء الحزمة',
        'Metadata' => 'بيانات تعريف',
        'Change Log' => 'سجل التغيير',
        'Date' => 'تَارِيخٌ',
        'List of Files' => 'قائمة الملفات',
        'Permission' => 'أذونات',
        'Download file from package!' => 'تحميل الملف من الحزمة!',
        'Required' => 'مطلوب',
        'Primary Key' => 'المفتاح الأساسي',
        'Auto Increment' => 'زيادة تلقائية',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'الاختلافات في الملف ٪s',
        'File differences for file %s' => 'الاختلافات في الملف ٪s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'سجل الأداء',
        'Range' => 'نِطاق',
        'last' => 'الأخير',
        'This feature is enabled!' => 'تم تمكين هذه الميزة!',
        'Just use this feature if you want to log each request.' => 'ما عليك سوى استخدام هذه الميزة إذا كنت ترغب في تسجيل كل طلب.',
        'Activating this feature might affect your system performance!' =>
            'يرجى ملاحظة أن تنشيط هذه الوظيفة يمكن أن يؤدي إلى انخفاض الأداء!',
        'Disable it here!' => 'قم بإلغاء التنشيط هنا!',
        'Logfile too large!' => 'ملف السجل كبير جدًا!',
        'The logfile is too large, you need to reset it' => 'ملف السجل كبير جدًا، ويجب إعادة تعيينه',
        'Interface' => 'وَاجِهَةٌ',
        'Requests' => 'طَلَبَات',
        'Min Response' => 'الحد الأدنى من وقت الاستجابة',
        'Max Response' => 'أقصى وقت استجابة',
        'Average Response' => 'متوسط وقت الاستجابة',
        'Period' => 'فَتْرة',
        'minutes' => 'دقائق',
        'Min' => 'الحد الأدنى',
        'Max' => 'حدَ أقصى',
        'Average' => 'مُتَوَسِّطٌ',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'إدارة عامل التصفية Postmaster',
        'Add PostMaster Filter' => 'أضف عامل تصفية PostMaster',
        'Edit PostMaster Filter' => 'تحرير عامل تصفية PostMaster',
        'Filter for PostMaster Filters' => 'تصفية لفلاتر PostMaster',
        'Filter for PostMaster filters' => 'تصفية لفلاتر PostMaster',
        'Search through PostMaster filters' => '',
        'Search all filter attributes' => '',
        'Limit search to selected header fields' => '',
        'Limit search to selected set fields' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'توزيع رسائل البريد الإلكتروني الواردة أو تصفيتها باستخدام رؤوس البريد الإلكتروني. يمكن أيضًا استخدام التعبيرات العادية في البحث.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'إذا كنت تبحث فقط عن عنوان بريد إلكتروني، فاستخدم EMAILADDRESS: info@example.com في من أو إلى أو نسخة.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'إذا كنت تستخدم التعبيرات العادية، يمكنك أيضًا استخدام القيمة المطابقة في () مثل [***] في إجراء "التعيين".',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'يمكنك أيضًا استخدام المجموعات المسماة٪ s والأسماء في إجراء "المجموعة"٪ s (على سبيل المثال، Regexp: %s, Set action: %s). تم العثور على EMAILADDRESS له الاسم "٪ s".',
        'Delete this filter' => 'حذف هذا الفلتر',
        'Do you really want to delete this postmaster filter?' => 'هل أنت متأكد من أنك تريد حذف فلتر مدير البريد هذا؟',
        'A postmaster filter with this name already exists!' => 'يوجد بالفعل مرشح مدير مكتب البريد بهذا الاسم!',
        'Filter Condition' => 'حالة الفلتر',
        'AND Condition' => '"و" الشرط',
        'Search header field' => 'استعراض حقل الرأس',
        'for value' => 'حسب القيمة',
        'The field needs to be a valid regular expression or a literal word.' =>
            'يجب أن يحتوي هذا الحقل على تعبير عادي أو كلمة صالحة.',
        'Negate' => 'أَبْطَلَ',
        'Set Email Headers' => 'تعيين رؤوس البريد الإلكتروني',
        'Set email header' => 'تعيين رؤوس البريد الإلكتروني',
        'with value' => 'مع قيمة',
        'The field needs to be a literal word.' => 'يجب أن يكون الحقل كلمة حرفية.',
        'Header' => 'عُنْوَان',

        # Template: AdminPriority
        'Priority Management' => 'إدارة الأولويات',
        'Add Priority' => 'إضافة أولوية',
        'Edit Priority' => 'تحرير الأولوية',
        'Include invalid priorities' => '',
        'Filter for Priorities' => 'تصفية للأولويات',
        'Filter for priorities' => 'تصفية للأولويات',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'توجد هذه الأولوية في إعداد SysConfig. التأكيد مطلوب لتحديث الإعداد إلى الأولوية الجديدة!',
        'This priority is used in the following config settings:' => 'يتم استخدام هذه الأولوية في إعدادات التكوين التالية:',

        # Template: AdminProcessManagement
        'Process Management' => 'ادارة العمليات',
        'Include inactive processes' => '',
        'Filter for Processes' => 'تصفية العمليات',
        'Filter for processes' => 'تصفية العمليات',
        'Create New Process' => 'إنشاء عملية جديدة',
        'Deploy All Processes' => 'وضع جميع العمليات موضع التنفيذ',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'هنا يمكنك تحميل ملف تكوين لاستيراد عملية إلى نظامك. يجب أن يكون الملف بتنسيق YML، تمامًا كما يتم تصديره بواسطة إدارة العملية.',
        'Upload process configuration' => 'تحميل تكوين عملية',
        'Import process configuration' => 'تكوين عملية الاستيراد',
        'Ready2Adopt Processes' => 'عمليات Ready2Adopt',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'هنا يمكنك تنشيط عمليات Ready2Adoption لإظهار أفضل ممارساتنا. يرجى ملاحظة أنه قد تكون هناك حاجة إلى إعدادات إضافية.',
        'Import Ready2Adopt process' => 'استيراد عمليات Ready2Adopt',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'لإنشاء عملية جديدة، يمكنك إما استيراد عملية من نظام آخر أو إنشاء عملية جديدة تمامًا.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'لا تصبح التغييرات التي تطرأ على العمليات سارية المفعول حتى تقوم بمزامنة تكوين العملية. يتم تطبيق كافة التغييرات على تكوين النظام.',
        'Processes' => 'عمليات',
        'Process name' => 'اسم العملية',
        'Print' => 'طَبَعَ',
        'Export Process Configuration' => 'تصدير عملية التكوين',
        'Copy Process' => 'عملية النسخ',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'إلغاء وإغلاق',
        'Go Back' => 'الرجوع للخلف',
        'Please note, that changing this activity will affect the following processes' =>
            'تحذير: ستؤثر التغييرات في هذا النشاط على العمليات التالية',
        'Activity' => 'نَشَاطٌ',
        'Activity Name' => 'اسم النشاط',
        'Activity Dialogs' => 'حوارات النشاط',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'يمكنك تخصيص مربعات حوار النشاط لهذا النشاط عن طريق تحريك العناصر من القائمة اليسرى إلى القائمة اليمنى بالماوس.',
        'Filter available Activity Dialogs' => 'تصفية مربعات حوار الأنشطة المتاحة',
        'Available Activity Dialogs' => 'حوارات النشاط المتوفرة',
        'Name: %s, EntityID: %s' => 'Name: %s, EntityID: %s',
        'Create New Activity Dialog' => 'إنشاء مربع حوار نشاط جديد',
        'Assigned Activity Dialogs' => 'مربعات حوار النشاط المعينة',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'يرجى ملاحظة أن تغيير مربع حوار النشاط هذا سيؤثر على الأنشطة التالية',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'يرجى ملاحظة أن المستخدمين العملاء لن يتمكنوا من رؤية أو استخدام الحقول التالية: المالك (Owner) والمسؤول (Responsible) والقفل (Lock) ووقت الانتظار (PendingTime) ومعرف العميل (CustomerID).',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'لا يمكن تحديد حقل قائمة الانتظار إلا من قبل العملاء عند إنشاء تذكرة جديدة.',
        'Activity Dialog' => 'حوار النشاط',
        'Activity dialog Name' => 'اسم مربع حوار النشاط',
        'Available in' => 'متوفر في',
        'Description (short)' => 'الوصف (قصير)',
        'Description (long)' => 'الوصف (طويل)',
        'The selected permission does not exist.' => 'الإذن المحدد غير موجود.',
        'Required Lock' => 'القفل المطلوب',
        'The selected required lock does not exist.' => 'القفل المحدد غير موجود.',
        'Submit Advice Text' => 'نص الملاحظة عند الإرسال',
        'Submit Button Text' => 'نص تلميح للزر "إرسال"',
        'Input Field Definition' => '',
        'Direct submit' => '',
        'This property won\'t take effect because there are fields configured as visible.' =>
            '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'يمكنك تعيين حقول لمربع حوار النشاط هذا عن طريق سحبها من القائمة اليمنى إلى القائمة اليسرى بالماوس.',
        'Filter available fields' => 'تصفية الحقول المتوفرة',
        'Available Fields' => 'الحقول المتاحة',
        'Assigned Fields' => 'الحقول المعينة',
        'Communication Channel' => 'قناة الاتصال',
        'Is visible for customer' => 'مرئي للعملاء',
        'Display' => 'إِظْهار',

        # Template: AdminProcessManagementPath
        'Path' => 'مَسَار',
        'Edit this transition' => 'تحرير هذا الانتقال',
        'Transition Actions' => 'إجراءات الانتقال',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'يمكنك تعيين إجراءات الانتقال لهذا الانتقال عن طريق سحب العناصر بالماوس من القائمة اليسرى إلى القائمة اليمنى.',
        'Filter available Transition Actions' => 'تصفية إجراءات الانتقال المتاحة',
        'Available Transition Actions' => 'إجراءات الانتقال المتاحة',
        'Create New Transition Action' => 'إنشاء إجراء انتقالي جديد',
        'Assigned Transition Actions' => 'إجراءات الانتقال المعينة',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'النَشَاطَات',
        'Filter Activities...' => 'تصفية الأنشطة ...',
        'Create New Activity' => 'إنشاء نشاط جديد',
        'Filter Activity Dialogs...' => 'مربعات حوار تصفية النشاط ...',
        'Transitions' => 'انتقالات',
        'Filter Transitions...' => 'تصفية الانتقالات. . .',
        'Create New Transition' => 'إنشاء انتقال جديد',
        'Filter Transition Actions...' => 'تصفية إجراءات الانتقال ...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'تحرير العملية',
        'Print process information' => 'طباعة معلومات العملية',
        'Delete Process' => 'حذف العملية',
        'Delete Inactive Process' => 'حذف العملية غير النشطة',
        'Available Process Elements' => 'عناصر العملية المتاحة',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'يمكن سحب العناصر المدرجة في الشريط الجانبي إلى منطقة الرسم باستخدام الماوس.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'يمكنك وضع الأنشطة في منطقة الرسم لربط هذه الأنشطة بالعملية.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'يمكنك تعيين مربعات حوار النشاط لنشاط ما عن طريق سحبها من الشريط الجانبي فوق النشاط في منطقة الرسم.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'يمكنك إنشاء اتصال بين الأنشطة عن طريق سحب عنصر الانتقال إلى نشاط بدء الاتصال. يمكنك بعد ذلك سحب النهاية الحرة للسهم إلى النشاط المستهدف.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'يمكن تعيين الإجراءات للانتقال عن طريق سحب عنصر الإجراء إلى اسم الانتقال.',
        'Edit Process Information' => 'تحرير معلومات العملية',
        'Process Name' => 'اسم العملية',
        'The selected state does not exist.' => 'الحالة المحددة غير موجودة.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'إضافة وتحرير الأنشطة ومربعات حوار النشاط والانتقالات',
        'Show EntityIDs' => 'إظهار EntityIDs',
        'Extend the width of the Canvas' => 'زيادة عرض منطقة الرسم',
        'Extend the height of the Canvas' => 'زيادة ارتفاع منطقة الرسم',
        'Remove the Activity from this Process' => 'إزالة النشاط من هذه العملية',
        'Edit this Activity' => 'تعديل هذا النشاط',
        'Save Activities, Activity Dialogs and Transitions' => 'حفظ الأنشطة ومربعات حوار الأنشطة والانتقالات',
        'Do you really want to delete this Process?' => 'هل تريد حقًا حذف هذه العملية؟',
        'Do you really want to delete this Activity?' => 'هل أنت متأكد من أنك تريد حذف هذا النشاط؟',
        'Do you really want to delete this Activity Dialog?' => 'هل أنت متأكد أنك تريد حذف مربع حوار النشاط هذا؟',
        'Do you really want to delete this Transition?' => 'هل أنت متأكد أنك تريد حذف هذا الانتقال؟',
        'Do you really want to delete this Transition Action?' => 'هل أنت متأكد من أنك تريد حذف إجراء الانتقال هذا؟',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'هل أنت متأكد من أنك تريد إزالة هذا النشاط من منطقة الرسم؟ لا يمكن التراجع عن ذلك إلا إذا تركت طريقة العرض هذه دون حفظ.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'هل أنت متأكد من أنك تريد إزالة هذا الانتقال من لوح الرسم؟ لا يمكن التراجع عن هذا إلا إذا غادرت هذه النافذة دون حفظ.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '‮هنا يمكنك إنشاء عملية جديدة. لجعل العملية متاحة للمستخدمين، يجب عليك تعيين الحالة إلى "نشط" وإجراء المزامنة عند الانتهاء من عملك.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'إلغاء وإغلاق',
        'Start Activity' => 'بدء النشاط',
        'Contains %s dialog(s)' => 'يحتوي على مربع (مربعات) حوار ٪s',
        'Assigned dialogs' => 'مربعات الحوار المعينة',
        'Activities are not being used in this process.' => 'لا يتم استخدام أي أنشطة في هذه العملية.',
        'Assigned fields' => 'الحقول المعينة',
        'Activity dialogs are not being used in this process.' => 'لا يتم استخدام مربعات حوار النشاط في هذه العملية.',
        'Condition linking' => 'روابط شرطية',
        'Transitions are not being used in this process.' => 'لا يتم استخدام الانتقالات في هذه العملية.',
        'Module name' => 'اسم الوحدة',
        'Transition actions are not being used in this process.' => 'لا يتم استخدام إجراءات الانتقال في هذه العملية.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'يرجى ملاحظة أن تغيير هذا الانتقال سيؤثر على العمليات التالية',
        'Transition' => 'اِنْتِقالٌ',
        'Transition Name' => 'اسم الانتقال',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'يرجى ملاحظة أن تغيير إجراء الانتقال هذا سيؤثر على العمليات التالية',
        'Transition Action' => 'إجراء انتقالي',
        'Transition Action Name' => 'اسم إجراء الانتقال',
        'Transition Action Module' => 'وحدة إجراء الانتقال',
        'Config Parameters' => 'معلمات التكوين',
        'Add a new Parameter' => 'أضف معاملاً جديدًا',
        'Remove this Parameter' => 'إزالة هذه المعلمة',

        # Template: AdminQueue
        'Queue Management' => 'إدارة قائمة الانتظار',
        'Add Queue' => 'إضافة قائمة الانتظار',
        'Edit Queue' => 'تحرير قائمة الانتظار',
        'Include invalid queues' => '',
        'Filter for Queues' => 'تصفية لقوائم الانتظار',
        'Filter for queues' => 'تصفية لقوائم الانتظار',
        'A queue with this name already exists!' => 'توجد قائمة انتظار بهذا الاسم بالفعل!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'قائمة الانتظار هذه موجودة في إعداد SysConfig. مطلوب تأكيد لتحديث الإعداد إلى قائمة الانتظار الجديدة!',
        'Sub-queue of' => 'قائمة انتظار فرعية من',
        'Unlock timeout' => 'فتح المهلة',
        '0 = no unlock' => '0 = بدون إلغاء قفل',
        'hours' => 'ساعات',
        'Only business hours are counted.' => 'يتم أخذ ساعات العمل فقط في الاعتبار.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'إذا أقفل الوكيل تذكرة ولم يغلقها قبل وقت الفتح، فسيتم إلغاء قفلها وإتاحتها مرة أخرى للوكلاء الآخرين.',
        'Notify by' => 'إخطار من قبل',
        '0 = no escalation' => '0 = لا يوجد تصعيد',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'إذا لم يكن هناك استجابة من العميل (بريد إلكتروني خارجي أو هاتف) قبل الوقت المحدد، فسيتم تصعيد التذكرة.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'عندما يضيف العميل عنصرا - على سبيل المثال عن طريق البريد الإلكتروني أو في منطقة العميل - تتم إعادة تعيين وقت التصعيد. إذا لم يتم الاتصال بالعميل مرة أخرى بحلول الوقت المحدد، فإن التذكرة تتصاعد.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'إذا لم يتم ضبط التذكرة على الإغلاق قبل انتهاء الوقت المحدد هنا، فسيتم تصعيد التذكرة.',
        'Follow up Option' => 'خيار الطلب',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'يحدد ما إذا كانت الاستجابة لتذكرة مغلقة تعيد فتح تلك التذكرة أو يتم رفضها أو تؤدي إلى تذكرة جديدة.',
        'Ticket lock after a follow up' => 'إقفال البطاقة بعد الرد',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'إذا تم إغلاق تذكرة وأرسل العميل ردا، فسيتم قفل التذكرة للمالك القديم.',
        'System address' => 'عنوان النظام',
        'Will be the sender address of this queue for email answers.' => 'عنوان المرسل لرسائل البريد الإلكتروني من قائمة الانتظار هذه.',
        'Default sign key' => 'مفتاح التوقيع الافتراضي',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'لاستخدام مفتاح توقيع، يجب إضافة مفاتيح PGP أو شهادات S / MIME مع معرفات لعنوان النظام المحدد إلى قائمة الانتظار.',
        'Salutation' => 'التحية',
        'The salutation for email answers.' => 'التحية لردود البريد الإلكتروني.',
        'Signature' => 'التوقيع',
        'The signature for email answers.' => 'التوقيع لردود البريد الإلكتروني.',
        'This queue is used in the following config settings:' => 'يتم استخدام قائمة الانتظار هذه في إعدادات التكوين التالية:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'إدارة تعيين قوائم الانتظار والردود التلقائية',
        'Change Auto Response Relations for Queue' => 'تغيير تعيينات الاستجابة التلقائية لقائمة الانتظار',
        'This filter allow you to show queues without auto responses' => 'يسمح لك هذا الفلتر بإظهار قوائم الانتظار بدون ردود تلقائية',
        'Queues without Auto Responses' => 'قوائم الانتظار بدون ردود تلقائية',
        'This filter allow you to show all queues' => 'يسمح هذا المرشح بعرض جميع قوائم الانتظار',
        'Show All Queues' => 'إظهار جميع قوائم الانتظار',
        'Auto Responses' => 'الردود التلقائية',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'إدارة تخصيص القوالب لقوائم الانتظار',
        'Filter for Templates' => 'تصفية القوالب',
        'Filter for templates' => 'تصفية القوالب',
        'Templates' => 'نماذج',

        # Template: AdminRegistration
        'System Registration Management' => 'إدارة تسجيل النظام',
        'Edit System Registration' => 'تحرير تسجيل النظام',
        'System Registration Overview' => 'نظرة عامة على تسجيل النظام',
        'Register System' => 'نظام التسجيل',
        'Validate OTOBO-ID' => 'التحقق من صحة OTOBO-ID',
        'Deregister System' => 'نظام إلغاء التسجيل',
        'Edit details' => 'تعديل التفاصيل',
        'Show transmitted data' => 'إظهار البيانات المرسلة',
        'Deregister system' => 'نظام إلغاء التسجيل',
        'Overview of registered systems' => 'نظرة عامة على الأنظمة المسجلة',
        'This system is registered with OTOBO Team.' => 'هذا النظام مسجل لدى مجموعة OTOBO.',
        'System type' => 'نوع النظام',
        'Unique ID' => 'Unique ID',
        'Last communication with registration server' => 'آخر اتصال مع خادم التسجيل',
        'System Registration not Possible' => 'التسجيل في النظام غير ممكن',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'يرجى ملاحظة أنه لا يمكنك تسجيل النظام الخاص بك إذا كان OTOBO Daemon لا يعمل!',
        'Instructions' => 'تَعْلِيمَاتٌ',
        'System Deregistration not Possible' => 'تعذر إلغاء تسجيل النظام',
        'OTOBO-ID Login' => 'تسجيل الدخول إلى OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'تسجيل النظام هي خدمة من مجموعة OTOBO تمنحك العديد من المزايا!',
        'Read more' => 'اقرأ أكثر',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'لتسجيل النظام الخاص بك ، يرجى تسجيل الدخول باستخدام OTOBO-ID الخاص بك.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'OTOBO-ID الخاص بك هو عنوان البريد الإلكتروني الذي استخدمته للتسجيل في صفحة الويب OTOBO.com.',
        'Data Protection' => 'حماية الخصوصية',
        'What are the advantages of system registration?' => 'ما هي مميزات التسجيل في النظام؟',
        'You will receive updates about relevant security releases.' => 'سيتم إعلامك بالإصدارات المتعلقة بالأمان.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'يتيح تسجيل نظامك لمجموعة OTOBO خدمتك بشكل أسرع وأكثر كفاءة لأن لدينا بالفعل معلومات مهمة حول نظامك تجعل الاستفسارات المتكررة غير ضرورية.',
        'This is only the beginning!' => 'هذه ليست سوى البداية!',
        'We will inform you about our new services and offerings soon.' =>
            'كن متشوقًا لمعرفة المزيد من خدماتنا وعروضنا الجديدة التي سنقدمها لك.',
        'Can I use OTOBO without being registered?' => 'هل يمكنني استخدام OTOBO بدون تسجيل؟',
        'System registration is optional.' => 'تسجيل النظام اختياري.',
        'You can download and use OTOBO without being registered.' => 'يمكنك أيضا تنزيل واستخدام OTOBO بالكامل دون تسجيل.',
        'Is it possible to deregister?' => 'هل من الممكن إلغاء التسجيل؟',
        'You can deregister at any time.' => 'يمكنك إلغاء التسجيل في أي وقت.',
        'Which data is transfered when registering?' => 'ما هي البيانات التي يتم نقلها عند التسجيل؟',
        'A registered system sends the following data to OTOBO Team:' => 'يرسل النظام المسجل البيانات التالية إلى فريق OTOBO:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'اسم المجال المؤهل بالكامل (FQDN) وإصدار OTOBO وقاعدة البيانات ونظام التشغيل وإصدار Perl.',
        'Why do I have to provide a description for my system?' => 'لماذا يجب وصف النظام؟',
        'The description of the system is optional.' => 'وصف النظام اختياري.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'سيساعدك نوع النظام ووصفه في تحديد أنظمتك وإدارة سجل النظام.',
        'How often does my OTOBO system send updates?' => 'كم مرة يرسل OTOBO الخاص بي التحديثات؟',
        'Your system will send updates to the registration server at regular intervals.' =>
            'سيرسل نظامك تحديثات إلى خادم التسجيل على فترات منتظمة.',
        'Typically this would be around once every three days.' => 'عادة ما يكون هذا حوالي مرة واحدة كل ثلاثة أيام.',
        'If you deregister your system, you will lose these benefits:' =>
            'إذا قمت بإلغاء تسجيل نظامك، فستفقد المزايا التالية:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'تحتاج إلى تسجيل الدخول باستخدام OTOBO-ID الخاص بك لإلغاء تسجيل نظامك.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'ليس لديك OTOBO-ID حتى الآن؟',
        'Sign up now' => 'سجل الآن',
        'Forgot your password?' => 'هل نسيت كلمة المرور؟',
        'Retrieve a new one' => 'استرداد واحدة جديدة',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'سيتم نقل هذه البيانات بشكل متكرر إلى فريق OTOBO عند تسجيل هذا النظام.',
        'Attribute' => 'سِمَة',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'إصدار OTOBO',
        'Operating System' => 'نظام التشغيل',
        'Perl Version' => 'إصدار Perl',
        'Optional description of this system.' => 'وصف اختياري لهذا النظام.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'يتيح هذا الإعداد إرسال معلومات دعم إضافية إلى مجموعة OTOBO.',
        'Register' => 'سَجَّلَ',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'سيؤدي الاستمرار في هذه الخطوة إلى إلغاء تسجيل النظام من فريق OTOBO.',
        'Deregister' => 'إلغاء التسجيل',
        'You can modify registration settings here.' => 'يمكنك تعديل إعدادات التسجيل هنا.',
        'Overview of Transmitted Data' => 'نظرة عامة على البيانات المرسلة',
        'There is no data regularly sent from your system to %s.' => 'لا يتم إرسال أي بيانات بشكل منتظم إلى٪ s من نظامك.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'يتم نقل البيانات التالية من نظامك إلى٪ s كل 3 أيام على الأقل.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'سيتم نقل البيانات بتنسيق JSON عبر اتصال https آمن.',
        'System Registration Data' => 'بيانات تسجيل النظام',
        'Support Data' => 'بيانات الدعم',

        # Template: AdminResponseTemplatesStatePreselection
        'Manage ticket state pre-selections for response templates' => '',
        'Edit Response' => '',
        'Pre-selected ticket state' => '',

        # Template: AdminRole
        'Role Management' => 'إدارة الأدوار',
        'Add Role' => 'إضافة دور',
        'Edit Role' => 'تحرير الدور',
        'Include invalid roles' => '',
        'Filter for Roles' => 'تصفية الأدوار',
        'Filter for roles' => 'تصفية الأدوار',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'إنشاء دور ووضع المجموعات فيه. ثم أضف الدور إلى المستخدمين.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'لا توجد أدوار محددة. الرجاء استخدام الزر "إضافة" لإنشاء دور جديد.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'إدارة تعيينات الأدوار للمجموعات',
        'Roles' => 'ادوار',
        'Select the role:group permissions.' => 'حدد الدور:أذونات المجموعة.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'إذا لم يتم تحديد أي شيء، فإن الدور في تلك المجموعة ليس لديه أذونات (ولا يمكنه الوصول إلى التذاكر).',
        'Toggle %s permission for all' => 'تبديل إذن٪ s للجميع',
        'Read only access to the ticket in this group/queue. The ticket can be found via a search and its TicketZoom can be accessed. If used for a calendar, users can see and export all appointments in the calendar.' =>
            '',
        'move_into' => 'الانتقال إلى',
        'Permissions to move tickets into this group/queue. If used for a calendar, users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '',
        'create' => 'أَنْشَأَ',
        'Permissions to create tickets in this group/queue. If used for a calendar, users can create and delete appointments in the calendar.' =>
            '',
        'note' => 'مُلاحَظَة',
        'Permissions to add notes to tickets in this group/queue. It also allows agents to be informed via the \'Inform Agents\' section in the Notes.' =>
            '',
        'owner' => 'مَالِك',
        'Permissions to be become the owner of tickets in this group/queue. One can be selected as an owner while creating a ticket or changing the owner. Being the owner gives full rw permissions to this ticket.' =>
            '',
        'priority' => 'أَوْلَوِيَّةٌ',
        'Permissions to open the priority action in this group/queue.' =>
            '',
        'Full read and write access to the tickets in this group/queue. If used for a calendar, users can manage the calendar itself.' =>
            '',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'إدارة العلاقات بين الوكيل والدور',
        'Add Agent' => 'إضافة وكيل',
        'Filter for Agents' => 'تصفية للوكلاء',
        'Filter for agents' => 'تصفية للوكلاء',
        'Agents' => 'الوكلاء',
        'Manage Role-Agent Relations' => 'إدارة العلاقات بين الدور والوكيل',

        # Template: AdminSLA
        'SLA Management' => 'إدارة اتفاقية مستوى الخدمة',
        'Edit SLA' => 'تحرير اتفاقية مستوى الخدمة',
        'Add SLA' => 'إضافة اتفاقية مستوى الخدمة',
        'Include invalid SLAs' => '',
        'Filter for SLAs' => 'تصفية لاتفاقيات مستوى الخدمة',
        'Please write only numbers!' => 'الرجاء كتابة الأرقام فقط!',

        # Template: AdminSMIME
        'S/MIME Management' => 'إدارة S/MIME',
        'Add Certificate' => 'إضافة شهادة',
        'Add Private Key' => 'إضافة مفتاح خاص',
        'SMIME support is disabled' => 'تم تعطيل دعم SMIME',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'لتتمكن من استخدام SMIME في OTOBO، يجب عليك تمكينه أولا.',
        'Enable SMIME support' => 'تفعيل دعم SMIME',
        'Faulty SMIME configuration' => 'تكوين SMIME خاطئ',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'تم تمكين دعم SMIME، ولكن التكوين ذي الصلة يحتوي على أخطاء. يرجى التحقق من التكوين باستخدام الزر أدناه.',
        'Check SMIME configuration' => 'التحقق من تكوين S/MIME',
        'Filter for Certificates' => 'تصفية الشهادات',
        'Filter for certificates' => 'تصفية الشهادات',
        'To show certificate details click on a certificate icon.' => 'لعرض تفاصيل الشهادة، انقر على أيقونة الشهادة.',
        'To manage private certificate relations click on a private key icon.' =>
            'لإدارة ارتباطات الشهادات، يمكنك النقر فوق رمز المفتاح الخاص.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'يمكنك هنا إضافة علاقات إلى شهادتك الخاصة، والتي تتم إضافتها إلى توقيع S/MIME في كل مرة تستخدم فيها هذه الشهادة لتوقيع رسالة بريد إلكتروني.',
        'See also' => 'أنظر أيضا',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'بهذه الطريقة، يمكنك تحرير الشهادات والمفاتيح الخاصة مباشرةً في نظام الملفات.',
        'Hash' => 'تجزئة',
        'Create' => 'إنشاء',
        'Handle related certificates' => 'إدارة الشهادات المرتبطة',
        'Read certificate' => 'قراءة الشهادة',
        'Delete this certificate' => 'حذف هذه الشهادة',
        'File' => 'ملف',
        'Secret' => 'خَفِيَّةٌ',
        'Related Certificates for' => 'الشهادات المرتبطة ب',
        'Delete this relation' => 'حذف هذه العلاقة',
        'Available Certificates' => 'الشهادات المتاحة',
        'Filter for S/MIME certs' => 'تصفية لشهادات S/MIME',
        'Relate this certificate' => 'ربط هذه الشهادة',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'شهادة S/MIME',
        'Certificate Details' => 'تفاصيل الشهادة',
        'Close this dialog' => 'إغلاق مربع الحوار هذا',

        # Template: AdminSalutation
        'Salutation Management' => 'إدارة التحية',
        'Add Salutation' => 'إضافة تحية',
        'Edit Salutation' => 'تحرير التحية',
        'Include invalid salutations' => '',
        'Filter for Salutations' => 'تصفية التحية',
        'Filter for salutations' => 'تصفية التحية',
        'e. g.' => 'على سبيل المثال.',
        'Example salutation' => 'مثال على التحية',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'يجب تمكين الوضع الآمن!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'عادةً ما يتم تشغيل الوضع الآمن بعد اكتمال التثبيت.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'إذا لم يكن وضع الأمان نشطًا، فيمكنك تمكينه باستخدام SysConfig نظرًا لأن نظامك قيد التشغيل بالفعل.',

        # Template: AdminSelectBox
        'SQL Box' => 'صندوق SQL',
        'Filter for Results' => 'تصفية النتائج',
        'Filter for results' => 'تصفية النتائج',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'هنا يمكنك إدخال SQL لإرساله مباشرة إلى قاعدة بيانات التطبيق. لا يمكن تغيير محتوى الجداول، يسمح فقط بتحديد الاستعلامات.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'هنا يمكنك إدخال SQL التي سيتم إرسالها إلى قاعدة البيانات.',
        'Options' => 'خيارات',
        'Only select queries are allowed.' => 'يسمح فقط بتحديد الاستعلامات.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'يحتوي بناء جملة استعلام SQL على خطأ. يرجى التحقق من ذلك.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'معلمة واحدة على الأقل للربط مفقودة. يرجى التحقق.',
        'Result format' => 'شكل النتيجة',
        'Run Query' => 'تنفيذ الاستفسار',
        '%s Results' => 'نتائج٪ s',
        'Query is executed.' => 'الطلب قيد التنفيذ.',

        # Template: AdminService
        'Service Management' => 'إدارة الخدمات',
        'Add Service' => 'إضافة خدمة',
        'Edit Service' => 'تحرير الخدمة',
        'Include invalid services' => '',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'الحد الأقصى لطول اسم الخدمة هو 200 حرف (مع الخدمة الفرعية).',
        'Sub-service of' => 'الخدمة الفرعية ل',

        # Template: AdminSession
        'Session Management' => 'إدارة الجلسة',
        'Detail Session View for %s (%s)' => 'عرض الجلسة التفصيلية ل٪ s (٪ s)',
        'All sessions' => 'جميع الجلسات',
        'Agent sessions' => 'جلسات الوكلاء',
        'Customer sessions' => 'جلسات العملاء',
        'Unique agents' => 'وكلاء فريدون',
        'Unique customers' => 'عملاء فريدون',
        'Kill all sessions' => 'إنهاء كل الجلسات',
        'Kill this session' => 'إنهاء هذه الجلسة',
        'Filter for Sessions' => 'تصفية للجلسات',
        'Filter for sessions' => 'تصفية للجلسات',
        'Session' => 'جلسة',
        'Kill' => 'إنْهَاءٌ',
        'Detail View for SessionID: %s - %s' => 'طريقة عرض التفاصيل ل SessionID: ٪s - ٪s',

        # Template: AdminSignature
        'Signature Management' => 'إدارة التوقيع',
        'Add Signature' => 'إضافة توقيع',
        'Edit Signature' => 'تحرير التوقيع',
        'Include invalid signatures' => '',
        'Filter for Signatures' => 'تصفية التواقيع',
        'Filter for signatures' => 'تصفية التواقيع',
        'Example signature' => 'مثال على التوقيع',

        # Template: AdminState
        'State Management' => 'إدارة الحالة',
        'Add State' => 'إضافة حالة',
        'Edit State' => 'تحرير الحالة',
        'Include invalid states' => '',
        'Filter for States' => 'تصفية الحالة',
        'Filter for states' => 'تصفية الحالة',
        'Attention' => 'تنبيه',
        'Please also update the states in SysConfig where needed.' => 'يرجى أيضًا تحديث الحالات في SysConfig عند الحاجة.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'توجد هذه الحالة في إعداد SysConfig. من الضروري وجود تأكيد لتحديث الإعداد إلى الحالة الجديدة!',
        'State type' => 'نوع الحالة',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'لا يمكن إبطال هذا الإدخال لأنه لا توجد حالات دمج أخرى في النظام!',
        'This state is used in the following config settings:' => 'يتم استخدام هذه الحالة في إعدادات التكوين التالية:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'إرسال بيانات الدعم إلى فريق OTOBO غير ممكن!',
        'Enable Cloud Services' => 'تمكين الخدمات السحابية',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'يتم إرسال هذه البيانات إلى فريق OTOBO على أساس منتظم. للتوقف عن إرسال هذه البيانات، يرجى تحديث تسجيل النظام.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'يمكنك تشغيل إرسال بيانات الدعم يدويًا بالضغط على هذا الزر:',
        'Send Update' => 'إرسال التحديث',
        'Currently this data is only shown in this system.' => 'حاليا يتم عرض هذه البيانات فقط في هذا النظام.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'يوصى بشدة بإرسال هذه البيانات إلى فريق OTOBO للحصول على دعم أفضل.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'لتمكين إرسال البيانات، يرجى تسجيل نظامك مع فريق OTOBO أو تحديث معلومات تسجيل النظام (تأكد من تفعيل خيار \'إرسال بيانات الدعم\'.)',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'يمكن إنشاء حزمة دعم (بما في ذلك: بيانات تسجيل النظام وبيانات الدعم وقائمة الحزم المثبتة وجميع ملفات كود المصدر المعدلة محليًا) باستخدام هذا الزر:',
        'Generate Support Bundle' => 'إنشاء حزمة دعم',
        'The Support Bundle has been Generated' => 'تم إنشاء حزمة الدعم',
        'Please choose one of the following options.' => 'الرجاء اختيار واحد من الخيارات التالية.',
        'Send by Email' => 'ارسل بالبريد الإلكترونى',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'حزمة الدعم كبيرة جدًا بحيث لا يمكن إرسالها عبر البريد الإلكتروني، تم تعطيل هذا الخيار.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'عنوان البريد الإلكتروني لهذا المستخدم غير صالح، تم إلغاء التحديد.',
        'Sending' => 'إرسال',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'سيتم إرسال حزمة الدعم إلى فريق OTOBO عبر البريد الإلكتروني تلقائيًا.',
        'Download File' => 'تحميل الملف',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'يتم تنزيل حزمة الدعم كملف إلى نظام الملفات المحلي. يرجى حفظ الملف وإرساله إلى مجموعة OTOBO بوسائل أخرى.',
        'Error: Support data could not be collected (%s).' => 'خطأ: تعذر تحديد بيانات الدعم (٪ s).',
        'Details' => 'التفاصيل',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'إدارة عناوين البريد الإلكتروني للنظام',
        'Add System Email Address' => 'إضافة عنوان البريد الإلكتروني للنظام',
        'Edit System Email Address' => 'تحرير عنوان البريد الإلكتروني للنظام',
        'Include invalid system addresses' => '',
        'Add System Address' => 'إضافة عنوان النظام',
        'Filter for System Addresses' => 'تصفية لعناوين النظام',
        'Filter for system addresses' => 'تصفية لعناوين النظام',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'سيتم إرسال جميع رسائل البريد الإلكتروني الواردة بهذا العنوان في "إلى" أو "نسخة" إلى قائمة الانتظار المحددة.',
        'Email address' => 'عنوان البريد الالكترونى',
        'Display name' => 'اسم العرض',
        'This email address is already used as system email address.' => 'عنوان البريد الإلكتروني هذا مستخدم بالفعل كعنوان بريد إلكتروني للنظام.',
        'The display name and email address will be shown on mail you send.' =>
            'يتم استخدام اسم العرض وعنوان البريد الإلكتروني لرسائل البريد الإلكتروني المرسلة.',
        'This system address cannot be set to invalid.' => 'لا يمكن تعيين عنوان النظام هذا إلى غير صالح.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'لا يمكن تعيين عنوان النظام إلى غير صالح لأنه يستخدم في قائمة انتظار واحدة أو أكثر أو الردود التلقائية.',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'دليل المسؤول عبر الإنترنت',
        'System configuration' => 'تكوين النظام',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'تنقل عبر الإعدادات المتاحة باستخدام الشجرة الموجودة على اليسار.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'ابحث عن إعدادات معينة باستخدام حقل البحث أدناه أو من أيقونة البحث في شريط التنقل الرئيسي.',
        'Find out how to use the system configuration by reading the %s.' =>
            'تعرف على المزيد حول استخدام تكوين النظام في٪ s.',
        'Search in all settings...' => 'بحث في كافة الإعدادات ...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'لا توجد حاليا أي إعدادات متوفرة. يرجى التأكد من تشغيل "otobo. Console. pl Maint::Config::Rebuild" قبل استخدام البرنامج.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'نشر التغييرات',
        'Help' => 'مساعدة',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'ستجد هنا نظرة عامة على جميع الإعدادات التي سيتم تضمينها في التشغيل التالي. يمكنك مقارنة كل إعداد بحالته السابقة من خلال النقر على الرمز في أعلى اليمين.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'لاستبعاد إعدادات معينة من التشغيل، انقر فوق مربع الاختيار الموجود في شريط رأس أحد الإعدادات.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'بشكل افتراضي، يتم تشغيل الإعدادات التي قمت بتغييرها بنفسك فقط. ذا كنت ترغب أيضا في تشغيل التغييرات من المستخدمين الآخرين، فيرجى النقر فوق الارتباط الموجود أعلى الشاشة للدخول إلى وضع النشر المتقدم.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'تمت استعادة عملية النشر للتو، مما يعني أنه تمت إعادة جميع الإعدادات المتأثرة إلى الحالة التي كانت عليها وقت التشغيل المحدد.',
        'Please review the changed settings and deploy afterwards.' => 'يرجى مراجعة الإعدادات التي تم تغييرها ونشرها بعد ذلك.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'تعني قائمة التغييرات الفارغة عدم وجود اختلافات بين الحالة المستعادة والحالية للإعدادات المتأثرة.',
        'Changes Overview' => 'نظرة عامة على التغييرات',
        'There are %s changed settings which will be deployed in this run.' =>
            'في هذا التشغيل، يتم تشغيل إعدادات ٪s التي تم تغييرها.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'قم بالتبديل إلى الوضع الأساسي لاستخدام الإعدادات التي قمت بتغييرها بنفسك فقط.',
        'You have %s changed settings which will be deployed in this run.' =>
            'في هذا التشغيل، يتم تشغيل إعدادات ٪s التي تم تغييرها.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'قم بالتبديل إلى الوضع المتقدم لبدء الإعدادات التي تم تغييرها بواسطة وكلاء آخرين.',
        'There are no settings to be deployed.' => 'لا توجد إعدادات ليتم نشرها.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'قم بالتبديل إلى الوضع المتقدم للاطلاع على الإعدادات التي تم تغييرها بواسطة وكلاء آخرين وجاهزة للتشغيل.',
        'Deploy selected changes' => 'قم بتنشيط الإعدادات المحددة',

        # Template: AdminSystemConfigurationDeploymentHistory
        'Deployment History' => 'تاريخ التكليف',
        'Filter for Deployments' => 'تصفية لعمليات النشر',
        'Recent Deployments' => 'عمليات النشر الأخيرة',
        'Restore' => 'اِسْتَعادَ',
        'View Details' => 'عرض التفاصيل',
        'Restore this deployment.' => 'استعادة التكليف.',
        'Export this deployment.' => 'تصدير هذا النشر.',

        # Template: AdminSystemConfigurationDeploymentHistoryDetails
        'Deployment Details' => 'تفاصيل التكليف',
        'by' => 'بواسطة',
        'No settings have been deployed in this run.' => 'لم يتم تفويض أي إعدادات في هذا التشغيل.',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'لا تحتوي هذه المجموعة على أي إعدادات. يرجى محاولة الانتقال إلى إحدى مجموعاتها الفرعية.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'استيراد و تصدير',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'اختر ملفًا لاستيراده إلى نظامك (بتنسيق .yml تم تصديره بواسطة تكوين النظام).',
        'Upload system configuration' => 'تحميل تكوين النظام',
        'Import system configuration' => 'استيراد تكوين النظام',
        'Download current configuration settings of your system in a .yml file.' =>
            'قم بتنزيل إعدادات التكوين الحالية لنظامك في ملف .yml.',
        'Include user settings' => 'تضمين إعدادات المستخدم',
        'Export current configuration' => 'تصدير التكوين الحالي',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'البحث عن',
        'Search for category' => 'البحث عن فئة',
        'Settings I\'m currently editing' => 'الإعدادات التي أقوم بتحريرها حاليًا',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'لم يؤد بحثك عن "٪ s" في الفئة "٪ s" إلى أي نتائج.',
        'Your search for "%s" in category "%s" returned one result.' => 'أدى بحثك عن "٪s" في الفئة "٪s" إلى إرجاع نتيجة واحدة.',
        'Your search for "%s" in category "%s" returned %s results.' => 'أدى البحث عن "٪ s" في الفئة "٪ s" إلى إرجاع٪ s من النتائج.',
        'You\'re currently not editing any settings.' => 'أنت لا تقوم حاليًا بتحرير أي إعدادات.',
        'You\'re currently editing %s setting(s).' => 'أنت تقوم حاليا بتحرير إعداد (إعدادات) ٪s.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'فِئَةٌ',
        'Run search' => 'بدء البحث',

        # Template: AdminSystemConfigurationSettingHistoryDetails
        'Change History' => 'تاريخ التكليف',
        'Change History of %s' => 'سجل التغييرات في ٪s',
        'No modified values for this setting, the default value is used.' =>
            'لا توجد تغييرات لهذا الإعداد، يتم استخدام القيمة الافتراضية.',

        # Template: AdminSystemConfigurationUserModifiedDetails
        'Review users setting value' => 'مراجعة تغييرات المستخدم',
        'Users Value' => 'تغيير المستخدم',
        'For' => 'من أجل',
        'Delete all user values.' => 'تجاهل جميع تغييرات المستخدم.',
        'No user value for this setting.' => 'لا يوجد تغيير للمستخدم لهذا الإعداد.',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => 'عرض قائمة إعدادات مخصصة',
        'View single Setting: %s' => 'الإعداد: إظهار٪ s',
        'Go back to Deployment Details' => 'ارجع إلى تفاصيل التكليف',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'إدارة صيانة النظام',
        'Include invalid system maintenances' => '',
        'Schedule New System Maintenance' => 'جدولة صيانة النظام الجديد',
        'Filter for System Maintenances' => 'مرشح صيانة النظام',
        'Filter for system maintenances' => 'مرشح صيانة النظام',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'جدولة نافذة صيانة النظام لتنبيه الوكلاء والعملاء إلى وقت التوقف.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'قبل صيانة النظام ببعض الوقت، سيرى المستخدمون إشعارًا على كل شاشة.',
        'Delete System Maintenance' => 'إزالة صيانة النظام',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'تحرير صيانة النظام',
        'Edit System Maintenance Information' => 'تحرير معلومات صيانة النظام',
        'Login message' => 'رسالة عند تسجيل الدخول',
        'This field must have less then 250 characters.' => 'يجب أن يحتوي هذا الحقل على أقل من 250 حرفا.',
        'Show login message' => 'إظهار رسالة تسجيل الدخول',
        'Notify message' => 'نص تلميح',
        'Manage Sessions' => 'إدارة الجلسات',
        'All Sessions' => 'جميع الجلسات',
        'Agent Sessions' => 'جلسات الوكلاء',
        'Customer Sessions' => 'جلسات العملاء',
        'Kill all Sessions, except for your own' => 'إنهاء جميع الجلسات، باستثناء جلساتك',

        # Template: AdminTemplate
        'Template Management' => 'إدارة القوالب',
        'Add Template' => 'إضافة قالب',
        'Edit Template' => 'تحرير القالب',
        'Include invalid templates' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'القالب هو نص قياسي يمكن أن يساعد وكلاؤك في إنشاء التذاكر أو الرد عليها أو إعادة توجيهها بشكل أسرع.',
        'Don\'t forget to add new templates to queues.' => 'لا تنس تعيين قوالب جديدة لقوائم الانتظار.',
        'Attachments' => 'ملفات مرفقه',
        'Delete this entry' => 'حذف هذا الإدخال',
        'Do you really want to delete this template?' => 'هل تريد حقًا حذف هذا النموذج؟',
        'A standard template with this name already exists!' => 'قالب قياسي بهذا الاسم موجود بالفعل!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'يسترجع أول 20 حرفًا من موضوع مقالة الوكيل الحالية / الأخيرة (حاليًا بالنسبة لأنواع قوالب الرد وإعادة التوجيه، والأخير بالنسبة للملاحظات). العلامة غير مدعومة لأنواع القوالب الأخرى.',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'استرداد أول 5 سطور من نص مقالة الوكيل الحالية / الأخيرة (الحالية لأنواع قوالب الرد وإعادة التوجيه، والأخير للملاحظات). العلامة غير مدعومة لأنواع القوالب الأخرى.',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'للحصول على أول 20 حرفًا من موضوع المقالة الحالية / الأخيرة (الحالية للإجابة وإعادة التوجيه، الأحدث لنوع قالب الملاحظات). هذه العلامة غير مدعومة لأنواع القوالب الأخرى.',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'للحصول على أول 5 أسطر من نص المقالة الحالية / الأخيرة (الحالية للإجابة وإعادة التوجيه، الأحدث لنوع قالب الملاحظات). هذه العلامة غير مدعومة لأنواع القوالب الأخرى.',
        'Create type templates only supports this smart tags' => 'نماذج لإنشاء تدعم فقط هذه "العلامات الذكية"',
        'Example template' => 'مثال على القالب',
        'The current ticket state is' => 'حالة التذكرة الحالية هي',
        'Your email address is' => 'عنوان بريدك الإلكتروني هو',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'إدارة علاقات المرفقات بالقوالب',
        'Toggle active for all' => 'التبديل النشط للجميع',
        'Link %s to selected %s' => 'ربط ٪s ب٪s (محدد)',

        # Template: AdminTicketMask
        'Ticket Mask Management' => '',
        'Change mask definition' => '',
        'Ticket Mask' => '',
        'Change' => '',
        'Definition' => '',

        # Template: AdminTranslations
        'Translation Management' => '',
        'Add Translations' => '',
        'Edit Translations' => '',
        'Language' => 'اللغة',
        'Deploy Translations' => '',
        'Translation States' => '',
        'New Translation' => '',
        'Editing Translation' => '',
        'Translation Marked for Deletion' => '',
        'Deployed Translation' => '',
        'Changes made here only affect the system behaviour after your draft translations have been deployed. By deploying them, all changes will be written to the language files.' =>
            '',
        'Select an object to start adding translations. Depending on your selection, single or multiple translations can be added.' =>
            '',
        'Edit active translations using provided text fields!' => '',
        'List custom translations for' => '',
        'Draft Translations' => '',
        'Filter for Draft Translations' => '',
        'Active Translations' => '',
        'Filter for Active Translations' => '',
        'Content' => 'مُحْتَوىً',
        'Translation' => '',
        'Marked for Deletion' => '',
        'Edit Translation' => '',
        'Overwrites OTOBO translation' => '',
        'Undo Delete Translation' => '',
        'Delete Translation' => '',
        'Translations' => '',

        # Template: AdminType
        'Type Management' => 'إدارة أنواع',
        'Add Type' => 'إضافة نوع',
        'Edit Type' => 'تحرير النوع',
        'Include invalid types' => '',
        'Filter for Types' => 'تصفية الأنواع',
        'Filter for types' => 'تصفية الأنواع',
        'A type with this name already exists!' => 'يوجد بالفعل نوع بهذا الاسم!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'هذا النوع موجود في إعداد SysConfig، يلزم تأكيد تحديث الإعدادات للإشارة إلى النوع الجديد!',
        'This type is used in the following config settings:' => 'يستخدم هذا النوع في إعدادات التكوين التالية:',

        # Template: AdminUser
        'Agent Management' => 'إدارة الوكلاء',
        'Edit Agent' => 'تحرير عميل',
        'Include invalid users' => '',
        'Edit personal preferences for this agent' => 'تعديل الإعدادات الشخصية لهذا الوكيل',
        'Agents will be needed to handle tickets.' => 'ستكون هناك حاجة إلى وكلاء للتعامل مع التذاكر.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'لا تنس إضافة عميل جديد إلى المجموعات و/أو الأدوار!',
        'Please enter a search term to look for agents.' => 'الرجاء إدخال مصطلح البحث للبحث عن وكلاء.',
        'Last login' => 'آخر تسجيل دخول',
        'Switch to agent' => 'التبديل إلى العميل',
        'Title or salutation' => 'العنوان أو التحية',
        'Firstname' => 'الإسم الأول',
        'Lastname' => 'الإسم الأخير',
        'A user with this username already exists!' => 'يوجد مستخدم باسم المستخدم هذا بالفعل!',
        'Will be auto-generated if left empty.' => 'سيتم إنشاؤها تلقائيًا إذا تركت فارغة.',
        'Mobile' => 'رقم الجوال',
        'Effective Permissions for Agent' => 'أذونات صالحة للوكيل',
        'This agent has no group permissions.' => 'لا يملك هذا الوكيل أذونات مجموعة.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'يظهر الجدول أعلاه أذونات المجموعة الصالحة للوكيل. وتأخذ المصفوفة في الاعتبار جميع الأذونات الموروثة (مثلا عن طريق الأدوار).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'إدارة العلاقات بين الوكيل والمجموعة',
        'Permissions to move tickets into this group/queue.' => 'أذونات لنقل التذاكر إلى هذه المجموعة/قائمة الانتظار.',
        'Permissions to create tickets in this group/queue.' => 'أذونات لإنشاء تذاكر في هذه المجموعة / قائمة الانتظار.',
        'Permissions to add notes to tickets in this group/queue.' => 'أذونات لإضافة ملاحظات إلى التذاكر في هذه المجموعة / قائمة الانتظار.',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'أذونات لتغيير مالك التذاكر في هذه المجموعة / قائمة الانتظار.',
        'Permissions to change the ticket priority in this group/queue.' =>
            'أذونات لتغيير أولوية التذكرة في هذه المجموعة / قائمة الانتظار.',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'استعراض الأجندة',
        'Manage Calendars' => 'إدارة التقويم',
        'Add Appointment' => 'إضافة موعد',
        'Today' => 'اليوم',
        'All-day' => 'طوال اليوم',
        'Repeat' => 'إعادة',
        'Notification' => 'التنبيهات',
        'Yes' => 'نَعَمْ',
        'No' => 'لا',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'لم يتم العثور على تقويم. الرجاء إضافة تقويم أولا بإستخدام صفحة إدارة التقويم.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'إضافة موعد جديد',
        'Calendars' => 'تَقْويمٌ',

        # Template: AgentAppointmentEdit
        'Basic information' => 'معلومات أساسية',
        'Date/Time' => 'التاريخ/الوقت',
        'Invalid date!' => 'التاريخ غير صحيح!',
        'Please set this to value before End date.' => 'يرجى تحديد قيمة قبل تاريخ الانتهاء.',
        'Please set this to value after Start date.' => 'الرجاء وضع قيمة بعد تاريخ البدء.',
        'This an occurrence of a repeating appointment.' => 'هذا عنصر في موعد متكرر.',
        'Click here to see the parent appointment.' => 'انقر هنا لمشاهدة الموعد الأصلي.',
        'Click here to edit the parent appointment.' => 'انقر هنا لتحرير الموعد الأصلي.',
        'Frequency' => 'تَكْرارٌ',
        'Every' => 'كُلّ',
        'day(s)' => 'يوم/أيام',
        'week(s)' => 'أسبوع/أسابيع',
        'month(s)' => 'شهر/أشهر',
        'year(s)' => 'سنة/سنين',
        'On' => 'تفعيل',
        'Monday' => 'الاِثْنَيْن',
        'Mon' => 'الإثنين',
        'Tuesday' => 'الثُّلاثاء',
        'Tue' => 'الثّلاَثاء',
        'Wednesday' => 'الأَرْبِعاء',
        'Wed' => 'الأربعاء',
        'Thursday' => 'الخَمِيس',
        'Thu' => 'خَمِيس',
        'Friday' => 'الجُمْعَة',
        'Fri' => 'الجمعة',
        'Saturday' => 'السَّبْت',
        'Sat' => 'السبت',
        'Sunday' => 'الأَحَد',
        'Sun' => 'الأحد',
        'January' => 'يَنَاير',
        'Jan' => 'يَنَاير',
        'February' => 'فِبْراير',
        'Feb' => 'فِبْراير',
        'March' => 'مارِس',
        'Mar' => 'مارِس',
        'April' => 'أبْرِيل',
        'Apr' => 'أبْرِيل',
        'May_long' => 'مايُو',
        'May' => 'مايُو',
        'June' => 'يُونْيُو',
        'Jun' => 'يُونْيُو',
        'July' => 'يُولْيُو',
        'Jul' => 'يُولْيُو',
        'August' => 'أُغُسْطُس',
        'Aug' => 'أُغُسْطُس',
        'September' => 'سِبْتمبر',
        'Sep' => 'سِبْتمبر',
        'October' => 'أُكْتُوبر',
        'Oct' => 'أُكْتُوبر',
        'November' => 'نُوفَمْبِر',
        'Nov' => 'نوفمبر',
        'December' => 'دِيسِمْبر',
        'Dec' => 'ديسمبر',
        'Relative point of time' => 'نقطة زمنية نسبية',
        'Link' => 'رابط',
        'Remove entry' => 'إزالة الإدخال',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'مركز معلومات العملاء',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'العميل',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'ملاحظة: العميل غير صالح!',
        'Start chat' => 'بدء الدردشة',
        'Video call' => 'مكالمة فيديو',
        'Audio call' => 'مكالمة صوتية',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'دفتر عناوين العميل',
        'Search for recipients and add the results as \'%s\'.' => 'ابحث عن المستلمين وأضف النتائج ك \'٪s\'.',
        'Search template' => 'قالب البحث',
        'Create Template' => 'إنشاء قالب',
        'Create New' => 'إنشاء جديد',
        'Save changes in template' => 'حفظ التغييرات في القالب',
        'Filters in use' => 'الفلاتر المستخدمة',
        'Additional filters' => 'عوامل تصفية إضافية',
        'Add another attribute' => 'إضافة سمة أخرى',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'تنتمي السمات المسماة \'(العميل)\' إلى شركة العميل.',
        '(e. g. Term* or *Term*)' => '(على سبيل المثال، المصطلح* أو *المصطلح*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'تحديد الكل',
        'The customer user is already selected in the ticket mask.' => 'تم تحديد العميل بالفعل في قناع التذكرة.',
        'Select this customer user' => 'تحديد مستخدم العميل هذا',
        'Add selected customer user to' => 'إضافة مستخدم العميل المحدد إلى',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'تغيير خصائص البحث',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'مركز معلومات مستخدم العميل',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTOBO Daemon عبارة عن عملية برنامج يقوم بتنفيذ مهام غير متزامنة، مثل تشغيل تصعيد التذكرة وإرسال البريد الإلكتروني وما إلى ذلك.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'يعد تشغيل OTOBO Daemon إلزاميًا لتشغيل النظام بشكل صحيح.',
        'Starting the OTOBO Daemon' => 'بدء تشغيل برنامج Otobo Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'تأكد من وجود الملف \'٪s\' (بدون ملحق . dist). ستقوم مهمة cron هذه بالتحقق كل 5 دقائق مما إذا كان OTOBO Daemon قيد التشغيل وبدء تشغيله إذا لزم الأمر.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'قم بتنفيذ \'٪s start\' للتأكد من أن وظائف cron الخاصة بالمستخدم \'otobo\' نشطة.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'بعد 5 دقائق، تحقق من تشغيل برنامج OTOBO Daemon في النظام ("bin / otobo.Daemon.pl status").',

        # Template: AgentDashboard
        'Dashboard' => 'نَظْرَة عامة',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'موعد جديد',
        'Tomorrow' => 'غداً',
        'Soon' => 'قَرِيباً',
        '5 days' => '5 أيام',
        'Start' => 'إبدأ',
        'none' => 'بدون',

        # Template: AgentDashboardCalendarOverview
        'in' => 'فِي',

        # Template: AgentDashboardCommon
        'Save settings' => 'حفظ الإعدادات',
        'Close this widget' => 'أغلق هذه الأداة',
        'more' => 'أكثر',
        'Available Columns' => 'الأعمدة المتوفرة',
        'Visible Columns (order by drag & drop)' => 'الأعمدة المرئية (ترتيب بالسحب والإفلات)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'تغيير التعيينات للعملاء',
        'Open' => 'مَفْتُوح',
        'Closed' => 'مُغْلَق',
        '%s open ticket(s) of %s' => '٪s تذكرة (تذاكر) مفتوحة ل ٪s',
        '%s closed ticket(s) of %s' => '٪ s تذكرة (تذاكر) مغلقة ل٪ s',
        'Edit customer ID' => 'تعديل رقم العميل',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'تصعيد التذاكر',
        'Open tickets' => 'تذاكر مفتوحة',
        'Closed tickets' => 'التذاكر المغلقة',
        'All tickets' => 'جميع التذاكر',
        'Archived tickets' => 'التذاكر المحفوظة في الأرشيف',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'ملاحظة: مستخدم العميل غير صالح!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'معلومات مستخدم العميل',
        'Phone ticket' => 'تذكرة الهاتف',
        'Email ticket' => 'تذكرة البريد الإلكتروني',
        'New phone ticket from %s' => 'تذكرة هاتف جديدة من٪ s',
        'New email ticket to %s' => 'تذكرة بريد إلكتروني جديدة إلى ٪s',

        # Template: AgentDashboardMyLastChangedTickets
        'No tickets found.' => 'لم يتم العثور على تذاكر.',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '٪s ٪s متاح!',
        'Please update now.' => 'يرجى التحديث الآن.',
        'Release Note' => 'إصدار',
        'Level' => 'مُسْتَوى',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'تم النشر قبل ٪s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'يحتوي تكوين أداة الإحصاءات هذه على أخطاء، يرجى التحقق من إعداداتك.',
        'Download as SVG file' => 'تنزيل كملف SVG',
        'Download as PNG file' => 'تنزيل كملف PNG',
        'Download as CSV file' => 'تنزيل كملف CSV',
        'Download as Excel file' => 'تنزيل كملف Excel',
        'Download as PDF file' => 'تنزيل كملف PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'الرجاء تحديد تنسيق إخراج صالح في تكوين هذه الأداة.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'يتم إعداد محتويات هذه الإحصاءات. يرجى التحلي بالصبر.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'لا يمكن إستخدام هذه الإحصائية حاليا لأن تكوينها يحتاج إلى تصحيح من قبل مسؤول الإحصاءات.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'مخصص للعميل',
        'Accessible for customer user' => 'يمكن الوصول إليه للعملاء',
        'My locked tickets' => 'تذاكري المقفلة',
        'My watched tickets' => 'تذاكري المراقبة',
        'My responsibilities' => 'مسؤولياتي',
        'Tickets in My Queues' => 'تذاكر في قوائم الانتظار الخاصة بي',
        'Tickets in My Services' => 'تذاكر في خدماتي',
        'Service Time' => 'وقت الخدمة',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'مجموع',

        # Template: AgentDashboardUserOnline
        'out of office' => 'خارج المكتب',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'إلَى',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Detailed search' => 'بحث مفصل',
        'Add an additional attribute' => 'إضافة سمة أخرى',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => 'عرض التفاصيل',

        # Template: AgentElasticsearchQuickResult
        'Tickets' => 'تذاكر',
        'ConfigItems' => 'عناصر التكوين',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'تأكيد الأخبار أو الترخيص أو التغييرات.',
        'Yes, accepted.' => 'نعم، مقبول.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'إدارة الارتباطات ل ٪s',
        'Create new links' => 'إنشاء روابط جديدة',
        'Manage existing links' => 'إدارة الارتباطات الموجودة',
        'Link with' => 'رابط إلى',
        'Start search' => 'بدء البحث',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'لا توجد حاليا أي روابط. يرجى النقر فوق "إنشاء روابط جديدة" في الأعلى لربط هذا العنصر بكائنات أخرى.',

        # Template: AgentPassword
        'Password Policy' => 'نهج كلمة المرور',
        'Your current password is older than %s days. You need to set a new one.' =>
            'كلمة المرور الحالية أقدم من ٪s يوم. يجب أن تقوم بتعيين واحدة جديدة.',
        'Change password' => 'تغيير كلمة المرور',
        'Current password' => 'كلمة المرور الحالية',
        'New password' => 'كلمة مرور جديدة',
        'Repeat new password' => 'كرر كلمة المرور الجديدة',
        'Password needs to be renewed every %s days.' => 'يجب إعادة تعيين كلمة المرور كل ٪s يوما.',
        'Password history is active, you can\'t use a password which was used the last %s times.' =>
            'سجل كلمات المرور نشط. لا يمكنك إعادة استخدام أي من كلمات مرور ٪s الأخيرة.',
        'Password length must be at least %s characters.' => 'يجب أن يكون طول كلمة المرور ٪s على الأقل.',
        'Password requires at least two lower- and two uppercase characters.' =>
            'يجب أن تحتوي كلمة المرور على الأقل على حرفين كبيرين وحرفين صغيرين.',
        'Password requires at least two characters.' => 'تتطلب كلمة المرور حرفين على الأقل.',
        'Password requires at least one digit.' => 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل.',
        'Change config options' => 'تخصيص خيارات التكوين',
        'Admin permissions are required!' => 'أذونات المسؤول مطلوبة!',

        # Template: AgentPreferences
        'Edit your preferences' => 'تحرير الإعدادات الشخصية',
        'Personal Preferences' => 'الإعدادات الشخصية',
        'Preferences' => 'إعدادات',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'يرجى ملاحظة: أنت تقوم حاليا بتحرير إعدادات ٪s.',
        'Go back to editing this agent' => 'العودة إلى تحرير الوكيل',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'حدد إعداداتك الشخصية. احفظ الإعدادات بالنقر فوق رمز علامة الاختيار على اليمين.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'يمكنك إستخدام شجرة التنقل أدناه لإظهار الإعدادات من مجموعات معينة فقط.',
        'Dynamic Actions' => 'الإجراءات الديناميكية',
        'Filter settings...' => 'إعدادات التصفية...',
        'Filter for settings' => 'تصفية الإعدادات',
        'Save all settings' => 'حفظ كافة الإعدادات',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'تم تعطيل الصور الرمزية من قبل مسؤول النظام. سترى الأحرف الأولى بدلاً من ذلك.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'يمكنك تغيير صورتك الرمزية بالتسجيل باستخدام عنوان بريدك الإلكتروني٪ s في٪ s. يرجى ملاحظة أن الأمر قد يستغرق بعض الوقت حتى تصبح صورتك الرمزية الجديدة متاحة بسبب التخزين المؤقت.',
        'End' => 'نِهَايَةٌ',
        'This setting can currently not be saved.' => 'يتعذر حفظ هذا الإعداد حاليًا.',
        'This setting can currently not be saved' => 'يتعذر حفظ هذا الإعداد حاليًا',
        'Save this setting' => 'حفظ هذا الإعداد',
        'Did you know? You can help translating OTOBO at %s.' => 'هل تعلم؟ يمكنك المساعدة في ترجمة OTOBO على ٪s.',

        # Template: SettingsList
        'Reset to default' => 'إعادة التعيين إلى الافتراضي',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'في المربعات الموجودة على اليمين، اختر الإعدادات التي تريد تغييرها.',
        'Did you know?' => 'هل تعلم؟',
        'You can change your avatar by registering with your email address %s on %s' =>
            'يمكنك تغيير صورتك الرمزية بالتسجيل باستخدام عنوان بريدك الإلكتروني٪ s على٪ s',

        # Template: AgentSplitSelection
        'Target' => 'هَدَفٌ',
        'Process' => 'عَمَليَّة',
        'Split' => 'تَقْسِيم',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'إدارة الإحصاءات',
        'Add Statistics' => 'إضافة إحصائيات',
        'Read more about statistics in OTOBO' => 'قراءة المزيد حول الإحصائيات في OTOBO',
        'Dynamic Matrix' => 'مصفوفة ديناميكية',
        'Each cell contains a singular data point.' => 'تحتوي كل خلية على نقطة بيانات واحدة.',
        'Dynamic List' => 'قائمة ديناميكية',
        'Each row contains data of one entity.' => 'يحتوي كل صف على بيانات كيان واحد.',
        'Static' => 'ثَابِتٌ',
        'Non-configurable complex statistics.' => 'إحصائيات معقدة غير قابلة للتكوين.',
        'General Specification' => 'مواصفات عامة',
        'Create Statistic' => 'إنشاء إحصائيات',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'تحرير الإحصائيات',
        'Run now' => 'تشغيل',
        'Statistics Preview' => 'معاينة الإحصائيات',
        'Save Statistic' => 'حفظ الإحصائية',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'إستيراد الإحصائيات',
        'Import Statistics Configuration' => 'إستيراد تكوين الإحصائيات',

        # Template: AgentStatisticsOverview
        'Statistics' => 'إحصائيات',
        'Run' => 'تَشْغِيلٌ',
        'Edit statistic "%s".' => 'تحرير الإحصائيات "٪s".',
        'Export statistic "%s"' => 'تصدير الإحصائيات "٪s"',
        'Export statistic %s' => 'تصدير الإحصائيات ٪s',
        'Delete statistic "%s"' => 'حذف الإحصائية "٪s"',
        'Delete statistic %s' => 'حذف إحصائيات ٪s',

        # Template: AgentStatisticsReportsAdd
        'Report Management' => 'إدارة التقارير',
        'Add Report' => 'إضافة تقرير',

        # Template: AgentStatisticsReportsEdit
        'Edit Report' => 'تحرير التقرير',
        'Here you can combine several statistics to a report which you can generate as a PDF manually or automatically at configured times.' =>
            'يمكنك هنا دمج العديد من الإحصائيات في تقرير واحد وإنشاء ملف PDF منه يدويًا أو تلقائيًا في أوقات محددة مسبقًا.',
        'Please note that you can only select charts as statistics output format if you configured one of the renderer binaries on your system.' =>
            'ملاحظة: يمكنك فقط تحديد المخططات كتنسيق إخراج الإحصائيات إذا كان لديك أحد ملفات العرض التي تم تكوينها على نظامك.',
        'Configure PhantomJS' => 'تكوين PhantomJS',
        'Configure GoogleChrome' => 'تكوين GoogleChrome',
        'General settings' => 'الإعدادات العامة',
        'Automatic generation settings' => 'إعدادات الإنشاء التلقائي',
        'Automatic generation times (cron)' => 'أوقات الإنشاء التلقائي (cron)',
        'Specify when the report should be automatically generated in cron format, e. g. "10 1 * * *" for every day at 1:10 am.' =>
            'حدد في تنسيق cron وقت إنشاء تقرير تلقائيًا، على سبيل المثال "10 1 * * *" لكل يوم الساعة 01:10.',
        'Times are in the system timezone.' => 'تتوافق الأوقات مع المنطقة الزمنية للنظام.',
        'Last automatic generation time' => 'وقت الإنشاء التلقائي الأخير',
        'Next planned automatic generation time' => 'وقت الإنشاء التلقائي المجدول التالي',
        'Automatic generation language' => 'لغة الإنشاء التلقائي',
        'The language to be used when the report is automatically generated.' =>
            'اللغة التي سيتم إستخدامها عند إنشاء التقرير تلقائيا.',
        'Email subject' => 'موضوع البريد الإلكتروني',
        'Specify the subject for the automatically generated email.' => 'الرجاء إدخال موضوع للبريد الإلكتروني الذي تم إنشاؤه تلقائيًا.',
        'Email body' => 'نص البريد الإلكتروني',
        'Specify the text for the automatically generated email.' => 'حدد النص للبريد الإلكتروني الذي تم إنشاؤه تلقائيا.',
        'Email recipients' => 'مستلم البريد الإلكتروني',
        'Specify recipient email addresses (comma separated).' => 'أدخل عناوين البريد الإلكتروني للمستلمين (مفصولة بفاصلة).',
        'Output settings' => 'إعدادات الإخراج',
        'Headline' => 'عُنْوَان',
        'Caption for preamble' => 'عنوان المقدمة',
        'Preamble' => 'مُقَدِّمَةٌ',
        'Caption for epilogue' => 'العنوان للكلمة الأخيرة',
        'Epilogue' => 'خاتِمَة',
        'Add statistic to report' => 'إضافة إحصائيات إلى التقرير',

        # Template: AgentStatisticsReportsOverview
        'Statistics Reports' => 'تقارير إحصائية',
        'Edit statistics report "%s".' => 'تحرير تقرير الإحصائيات "٪s".',
        'Delete statistics report "%s"' => 'حذف تقرير الإحصائيات "٪s"',

        # Template: AgentStatisticsReportsView
        'View Report' => 'عرض التقرير',
        'This statistics report contains configuration errors and can currently not be used.' =>
            'يحتوي تقرير الإحصائيات هذا على أخطاء في التكوين ولا يمكن استخدامه حاليًا.',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'نظرة عامة على الإحصائيات',
        'View Statistics' => 'عرض الإحصائيات',
        'Statistics Information' => 'معلومات إحصائية',
        'Created by' => 'تم الإنشاء بواسطة',
        'Changed by' => 'تم تغييره من خلال',
        'Sum rows' => 'مجموع الصفوف',
        'Sum columns' => 'مجموع الأعمدة',
        'Show as dashboard widget' => 'إظهار كعنصر واجهة لوحة المعلومات',
        'Cache' => 'ذاكرة تخزين مؤقت',
        'This statistic contains configuration errors and can currently not be used.' =>
            'تحتوي هذه الإحصائية على أخطاء في التكوين ولا يمكن استخدامها حاليًا.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'تغيير النص الحر ل ٪s٪s٪s',
        'Change Owner of %s%s%s' => 'تغيير ملكية ٪s٪s٪s',
        'Close %s%s%s' => 'إغلاق ٪s٪s٪s',
        'Add Note to %s%s%s' => 'إضافة ملاحظة إلى ٪s٪s٪s',
        'Set Pending Time for %s%s%s' => 'تعيين وقت الانتظار ل ٪s٪s٪s',
        'Change Priority of %s%s%s' => 'تغيير أولوية ٪s٪s٪s',
        'Change Responsible of %s%s%s' => 'التغيير مسؤول عن ٪s٪s٪s',
        'Edit Article "%s" of %s%s%s' => '',
        'The ticket has been locked' => 'تم تأمين التذكرة',
        'Undo & close' => 'التراجع والخروج',
        'Ticket Settings' => 'إعدادات التذكرة',
        'Queue invalid.' => 'قائمة الانتظار غير صالحة.',
        'Service invalid.' => 'الخدمة غير صالحة.',
        'SLA invalid.' => 'SLA غير صالحة.',
        'New Owner' => 'مالك جديد',
        'Please set a new owner!' => 'الرجاء تعيين مالك جديد!',
        'Owner invalid.' => 'المالك غير صالح.',
        'New Responsible' => 'مسؤول جديد',
        'Please set a new responsible!' => 'الرجاء تعيين مسؤول جديد!',
        'Responsible invalid.' => 'المسؤول غير صالح.',
        'Next state' => 'الحالة التالية',
        'State invalid.' => 'الحالة غير صالحة.',
        'For all pending* states.' => 'لجميع الحالات المعلقة*.',
        'Add Article' => 'إضافة مقالة',
        'Create an Article' => 'إنشاء مقالة',
        'Inform agents' => 'إبلاغ الوكلاء',
        'Inform involved agents' => 'إبلاغ الوكلاء المعنيين',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'هنا يمكنك تحديد وكلاء إضافيين يجب أن يتلقوا إشعارًا بالمقال الجديد.',
        'Text will also be received by' => 'سيتم إستلام النص أيضا بواسطة',
        'Text Template' => 'قالب النص',
        'Setting a template will overwrite any text or attachment.' => 'سيؤدي تحديد قالب إلى حذف النص أو المرفقات الموجودة.',
        'Invalid time!' => 'وقت غير صالح!',

        # Template: AgentTicketArticleVersionView
        'Viewing Article Version#%s of current Article: #%s %s' => '',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'إعادة توجيه ٪ s٪ s٪ s',
        'Bounce to' => 'إعادة التوجيه إلى',
        'You need a email address.' => 'تحتاج إلى عنوان بريد إلكتروني.',
        'Need a valid email address or don\'t use a local email address.' =>
            'تحتاج إلى عنوان بريد إلكتروني صالح أو لا تستخدم عنوان بريد إلكتروني محلي.',
        'Next ticket state' => 'حالة التذكرة التالية',
        'Inform sender' => 'أخبر المرسل',
        'Send mail' => 'إرسال البريد',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'التنفيذ الجماعي للبطاقة',
        'Send Email' => 'إرسال البريد',
        'Merge' => 'دمج',
        'Merge to' => 'دمج إلى',
        'Invalid ticket identifier!' => 'معرف تذكرة غير صالح!',
        'Merge to oldest' => 'دمج إلى الأقدم',
        'Link together' => 'ربط مع بعض',
        'Link to parent' => 'الارتباط بالآباء',
        'Unlock tickets' => 'إلغاء تأمين التذاكر',
        'Execute Bulk Action' => 'تنفيذ إجراء مجمع',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'إنشاء الإجابة ل ٪s٪s٪s',
        'This address is registered as system address and cannot be used: %s' =>
            'تم تسجيل هذا العنوان كعنوان للنظام ولا يمكن إستخدامه: ٪s',
        'Please include at least one recipient' => 'الرجاء تضمين مستلم واحد على الأقل',
        'Select one or more recipients from the customer user address book.' =>
            'حدد مستلمًا واحدًا أو أكثر من دفتر عناوين المستخدم الخاص بالعميل.',
        'Customer user address book' => 'دفتر عناوين مستخدم العميل',
        'Remove Ticket Customer' => 'إزالة تذكرة العميل',
        'Move to Cc' => 'نقل إلى Cc',
        'Move to Bcc' => 'نقل إلى Bcc',
        'Please remove this entry and enter a new one with the correct value.' =>
            'الرجاء إزالة هذا الإدخال وإدخال قيمة صالحة.',
        'This address already exists on the address list.' => 'هذا العنوان موجود بالفعل في قائمة العناوين.',
        'Remove Cc' => 'إزالة Cc',
        'Move to To' => 'نقل إلى To',
        'Bcc' => '(نسخة مخفية الوجهة) Bcc',
        'Remove Bcc' => 'إزالة Bcc',
        'Date Invalid!' => 'التاريخ غير صحيح!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'تغيير عميل ٪s٪s٪s',
        'Customer Information' => 'بيانات العميل',
        'Customer user' => 'مستخدم العميل',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'إنشاء تذكرة بريد إلكتروني جديدة',
        'Example Template' => 'مثال على القالب',
        'To customer user' => 'إلى مستخدم العميل',
        'Please include at least one customer user for the ticket.' => 'الرجاء إدخال مستخدم عميل واحد على الأقل للتذكرة.',
        'Select this customer as the main customer.' => 'حدد هذا العميل باعتباره العميل الرئيسي.',
        'Remove Ticket Customer User' => 'إزالة مستخدم عميل التذكرة',
        'From queue' => 'من قائمة الانتظار',
        'Get all' => 'إحضار كل شيء',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'البريد الإلكتروني الصادر ل ٪s٪s٪s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'إعادة إرسال البريد الإلكتروني ل ٪s٪s٪s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'التذكرة ٪s: انتهت مدة الاستجابة الأولى (٪s٪/s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'التذكرة ٪s: ستنتهي فترة الاستجابة الأولى في ٪s٪/s!',
        'Ticket %s: update time is over (%s/%s)!' => 'التذكرة ٪s: وقت التحديث قد انتهى (٪s٪/s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'التذكرة ٪s: سيتم إنهاء وقت التحديث في ٪s٪/s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'التذكرة ٪s: وقت الحل قد انتهى (٪s٪/s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'التذكرة ٪s: سينتهي وقت الحل في ٪s٪/s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'إعادة توجيه ٪s٪s٪s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'محفوظات ٪s٪s٪s',
        'Filter for history items' => 'تصفية عناصر المحفوظات',
        'Expand/collapse all' => 'توسيع / تصغير الكل',
        'CreateTime' => 'إنشاء الوقت',
        'Article' => 'موضوع',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'دمج ٪s٪s٪s',
        'Merge Settings' => 'إعدادات الدمج',
        'You need to use a ticket number!' => 'يجب إستخدام رقم تذكرة!',
        'A valid ticket number is required.' => 'مطلوب رقم تذكرة صالح.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'حاول كتابة جزء من رقم التذكرة أو عنوانها لكي تبحث به.',
        'Limit the search to tickets with same Customer ID (%s).' => 'قصر البحث على التذاكر المخصصة لنفس رقم العميل (٪s).',
        'Inform Sender' => 'إعلام المرسل',
        'Need a valid email address.' => 'تحتاج إلى عنوان بريد إلكتروني صالح.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'نقل ٪s٪s٪s',
        'New Queue' => 'قائمة انتظار جديدة',
        'Move' => 'نقل',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'لم يتم العثور على بيانات تذكرة.',
        'Open / Close ticket action menu' => 'فتح/إغلاق قائمة إجراءات التذاكر',
        'Select this ticket' => 'تحديد هذه التذكرة',
        'Sender' => 'المرسل',
        'First Response Time' => 'وقت الاستجابة الأول',
        'Update Time' => 'وقت التحديث',
        'Solution Time' => 'وقت الحل',
        'Move ticket to a different queue' => 'نقل التذكرة إلى قائمة انتظار مختلفة',
        'Change queue' => 'تغيير قائمة الانتظار',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'إزالة عوامل التصفية النشطة لهذه الشاشة.',
        'Tickets per page' => 'التذاكر لكل صفحة',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'قناة مفقودة',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'إعادة تعيين نظرة عامة',
        'Column Filters Form' => 'نموذج عوامل تصفية الأعمدة',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'تقسيم إلى تذكرة هاتف جديدة',
        'Save Chat Into New Phone Ticket' => 'حفظ المحادثة في تذكرة الهاتف الجديدة',
        'Create New Phone Ticket' => 'إنشاء تذكرة هاتف جديدة',
        'Please include at least one customer for the ticket.' => 'يرجى تضمين عميل واحد على الأقل للتذكرة.',
        'To queue' => 'إلى قائمة الانتظار',
        'Chat protocol' => 'بروتوكول المحادثة',
        'The chat will be appended as a separate article.' => 'سيتم إلحاق الدردشة كمقالة منفصلة.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'مكالمة هاتفية ل ٪s٪s٪s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'عرض نص البريد الإلكتروني العادي ل ٪s٪s٪s',
        'Plain' => 'عادي',
        'Download this email' => 'تنزيل هذا البريد الإلكتروني',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'إنشاء تذكرة عملية جديدة',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'تسجيل التذكرة في عملية',

        # Template: AgentTicketSearch
        'Profile link' => 'رابط الملف الشخصي',
        'Output' => 'نموذج النتيجة',
        'Fulltext' => 'النص الكامل',
        'Customer ID (complex search)' => 'رقم العميل (بحث معقد)',
        '(e. g. 234*)' => '(على سبيل المثال: 234*)',
        'Customer ID (exact match)' => 'رقم العميل (بحث دقيق)',
        'Assigned to Customer User Login (complex search)' => 'مخصص لتسجيل دخول مستخدم العميل (بحث معقد)',
        '(e. g. U51*)' => '(على سبيل المثال: U51*)',
        'Assigned to Customer User Login (exact match)' => 'مخصص لتسجيل دخول مستخدم العميل (يطابق تماما)',
        'Accessible to Customer User Login (exact match)' => 'يمكن الوصول إليه من خلال تسجيل دخول مستخدم العميل (تطابق تام)',
        'Created in Queue' => 'تم الإنشاء في قائمة الانتظار',
        'Lock state' => 'حالة القفل',
        'Watcher' => 'مُرَاقِب',
        'Article Create Time (before/after)' => 'وقت إنشاء المقالة (قبل/بعد)',
        'Article Create Time (between)' => 'وقت إنشاء المقالة (بين)',
        'Please set this to value before end date.' => 'الرجاء تعيين هذه القيمة قبل تاريخ الانتهاء.',
        'Please set this to value after start date.' => 'الرجاء تعيين هذه القيمة بعد تاريخ البدء.',
        'Ticket Create Time (before/after)' => 'وقت إنشاء التذكرة (قبل/بعد)',
        'Ticket Create Time (between)' => 'وقت إنشاء التذكرة (بين)',
        'Ticket Change Time (before/after)' => 'وقت تغيير التذكرة (قبل/بعد)',
        'Ticket Change Time (between)' => 'وقت تغيير التذكرة (بين)',
        'Ticket Last Change Time (before/after)' => 'آخر وقت لتغيير التذاكر (قبل/بعد)',
        'Ticket Last Change Time (between)' => 'وقت آخر تغيير للتذكرة (بين)',
        'Ticket Pending Until Time (before/after)' => 'تذكرة معلقة حتى الوقت (قبل/بعد)',
        'Ticket Pending Until Time (between)' => 'التذكرة معلقة حتى الوقت (بين)',
        'Ticket Close Time (before/after)' => 'وقت إغلاق التذكرة (قبل/بعد)',
        'Ticket Close Time (between)' => 'وقت إغلاق التذكرة (بين)',
        'Ticket Escalation Time (before/after)' => 'وقت تصعيد التذكرة (قبل/بعد)',
        'Ticket Escalation Time (between)' => 'وقت تصعيد التذكرة (بين)',
        'Archive Search' => 'البحث في الأرشيف',

        # Template: AgentTicketZoom
        'Sender Type' => 'نوع المرسل',
        'Save filter settings as default' => 'حفظ إعدادات عامل التصفية كافتراضي',
        'Event Type' => 'نوع الحدث',
        'Save as default' => 'حفظ كافتراضي',
        'Drafts' => 'مسودات',
        'Change Queue' => 'تغيير قائمة الانتظار',
        'There are no dialogs available at this point in the process.' =>
            'لا تتوفر أي مربعات حوار في هذه المرحلة من العملية.',
        'This item has no articles yet.' => 'لا يحتوي هذا العنصر على مقالات حتى الآن.',
        'Ticket Timeline View' => 'عرض سجل التذكرة',
        'Article Overview - %s Article(s)' => 'نظرة عامة على المقالة - ٪s مقالة (مقالات)',
        'Page %s' => 'الصفحة ٪s',
        'Add Filter' => 'إضافة عامل تصفية',
        'Set' => 'تحديد',
        'Reset Filter' => 'إعادة تعيين عامل التصفية',
        'No.' => 'لا',
        'Unread articles' => 'مقالات غير مقروءة',
        'Via' => 'عَنْ طَرِيق',
        'Article Edited' => '',
        'Important' => 'مُهِمّ',
        'Unread Article!' => 'مقالة غير مقروءة!',
        'Incoming message' => 'رسالة واردة',
        'Outgoing message' => 'رسالة صادرة',
        'Internal message' => 'رسالة داخلية',
        'Sending of this message has failed.' => 'فشل إرسال هذه الرسالة.',
        'The article was edited' => '',
        'Resize' => 'تغيير الحجم',
        'Mark this article as read' => 'وضع علامة مقروءة على هذه المقالة',
        'Show Full Text' => 'إظهار النص الكامل',
        'Full Article Text' => 'نص المقالة الكاملة',
        'No more events found. Please try changing the filter settings.' =>
            'لم يتم العثور على المزيد من الأحداث. الرجاء محاولة تغيير إعدادات عامل التصفية.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'عبر ٪s',
        'by %s' => 'بواسطة ٪s',
        'Toggle article details' => 'تبديل تفاصيل المقالة',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'تتم معالجة هذه الرسالة. تم بالفعل محاولة إرسال ٪s مرة (مرات). ستكون المحاولة التالية ٪s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'لفتح الارتباطات في المقالة التالية، قد تحتاج إلى الضغط على مفتاح Ctrl أو Cmd أو مفتاح Shift أثناء النقر فوق الارتباط (وفقا للمستعرض ونظام التشغيل).',
        'Close this message' => 'إغلاق هذه الرسالة',
        'Image' => 'صورة',
        'PDF' => 'PDF',
        'Unknown' => 'غير معروف',
        'View' => 'عرض',

        # Template: LinkTable
        'Linked Objects' => 'الكائنات المرتبطة',

        # Template: TicketInformation
        'Archive' => 'أرشيف',
        'This ticket is archived.' => 'هذه التذكرة محفوظة في الأرشيف.',
        'Note: Type is invalid!' => 'ملاحظة: النوع غير صالح!',
        'Pending till' => 'معلق حتى',
        'Locked' => 'مقفل',
        '%s Ticket(s)' => '٪s تذكرة (بطاقات)',
        'Accounted time' => 'الوقت المحسوب',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'معاينة هذه المقالة غير ممكنة لأن قناة ٪s مفقودة في النظام.',
        'Please re-install %s package in order to display this article.' =>
            'الرجاء إعادة تثبيت حزمة ٪s لعرض هذه المقالة.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'لحماية خصوصيتك، تم حظر المحتوى البعيد.',
        'Load blocked content.' => 'تحميل محتوى محظور.',

        # Template: Breadcrumb
        'Home' => 'الصفحة الرئيسية',
        'Back to admin overview' => 'الرجوع إلى النظرة العامة',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'تتطلب هذه الميزة خدمات السحابة',
        'You can' => 'يمكنك ذلك',
        'go back to the previous page' => 'العودة إلى الصفحة السابقة',

        # Template: CustomerAccept
        'Click to accept' => 'انقر للقبول',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'لا يمكن تغيير رقم العميل، ولا يمكن تعيين رقم عميل آخر إلى التذكرة.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'حدد أولا مستخدم عميل، ثم يمكنك تحديد رقم عميل لتعيينه لهذه التذكرة.',
        'Select a customer ID to assign to this ticket.' => 'حدد رقم العميل لتعيين التذكرة إليه.',
        'From all Customer IDs' => 'من جميع أرقام العملاء',
        'From assigned Customer IDs' => 'من جميع أرقام العملاء المعينة',

        # Template: CustomerDashboard
        'Ticket Search' => 'البحث عن التذكرة',
        'New Ticket' => 'تذكرة جديدة',

        # Template: CustomerError
        'An Error Occurred' => 'حدث خطأ',
        'Error Details' => 'تفاصيل الخطأ',
        'Traceback' => 'تتبع الأثر',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            'اكتشف ٪s مشاكل الشبكة المحتملة. يمكنك إما محاولة إعادة تحميل الصفحة يدويا أو الانتظار حتى يتم إعادة الاتصال بالمتصفح.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'تم إستعادة الاتصال بعد انقطاع مؤقت. لذلك، بعض عناصر الصفحة الحالية قد لا تعمل بشكل صحيح (بعد الآن). حتى تتمكن من إستخدام كل العناصر كما تريد، يجب إعادة تحميل الصفحة الحالية.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript غير متوفر',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'من أجل تجربة هذا البرنامج، ستحتاج إلى تمكين JavaScript في المستعرض.',
        'Browser Warning' => 'تحذير المستعرض',
        'The browser you are using is too old.' => 'المستعرض الذي تستخدمه قديم جدا.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'يعمل هذا البرنامج مع مجموعة كبيرة من متصفحات الويب التي يمكنك الاختيار منها. الرجاء تثبيت مستعرض ويب أحدث أو تحديث مستعرض ويب الحالي.',
        'Please see the documentation or ask your admin for further information.' =>
            'يرجى الاطلاع على المستندات أو طلب المزيد من المعلومات من المسؤول.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            'لا يعتمد المستعرض الذي تستخدمه شبكة css. من المحتمل أنه قديم جدا.',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            'يعمل Internet Explorer، ولكن لا يتم دعم كافة الميزات بشكل كامل. الرجاء مراعاة التحديث إلى مستعرض حديث.',
        'One moment please, you are being redirected...' => 'لحظة واحدة من فضلك، يتم إعادة توجيهك...',
        'Login' => 'تسجيل الدخول',
        'Your user name' => 'اسم المستخدم الخاص بك',
        'User name' => 'اسم المستخدم',
        'Your password' => 'كلمة المرور الخاصة بك',
        'Forgot password?' => 'هل نسيت كلمة المرور؟',
        'Your 2 Factor Token' => 'الرمز المميز ثنائي العامل',
        '2 Factor Token' => 'رمز مميز ثنائي العامل',
        'Log In' => 'تسجيل الدخول',
        'Request Account' => 'طلب حساب',
        'Request New Password' => 'طلب كلمة مرور جديدة',
        'Your User Name' => 'اسم المستخدم الخاص بك',
        'A new password will be sent to your email address.' => 'سيتم إرسال كلمة مرور جديدة إلى عنوان بريدك الإلكتروني.',
        'Create Account' => 'إنشاء حساب جديد',
        'Please fill out this form to receive login credentials.' => 'يرجى ملء هذا النموذج لتلقي تفاصيل التسجيل الخاصة بك.',
        'How we should address you' => 'كيف يجب أن نخاطبك',
        'Your First Name' => 'اسمك الأول',
        'Your Last Name' => 'اسمك الأخير',
        'Your email address (this will become your username)' => 'عنوان بريدك الإلكتروني (سيصبح اسم المستخدم الخاص بك)',

        # Template: CustomerNavigationBar
        'Logout' => 'تسجيل الخروج',

        # Template: CustomerPassword
        'Change Password' => 'تغيير كلمة المرور',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            'يجب أن تحتوي كلمة المرور على ٣ على الأقل من فئات الحرف التالية: حروف صغيرة، حروف كبيرة، أرقام، حروف خاصة.',

        # Template: CustomerTicketList
        'Welcome!' => 'أهلا بكم!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            'ليس لديك تذاكر حتى الآن. يرجى النقر هنا، لإنشاء واحدة جديدة.',
        'Nothing to show.' => 'لا شيء لإظهاره.',
        'Click here for an unfiltered list of all your tickets.' => 'انقر هنا للحصول على قائمة غير مفلترة بجميع تذاكرك.',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => 'إنشاء تذكرة جديدة',
        'Service level agreement' => 'إتفاقية مستوى الخدمة',

        # Template: CustomerTicketOverview
        'Your Tickets' => 'تذاكرك',
        'Page' => 'الصفحة',
        'Sort' => 'فَرَزَ',

        # Template: CustomerTicketSearch
        'Profile' => 'ملف تعريف',
        'e. g. 10*5155 or 105658*' => 'على سبيل المثال 10*5155 أو *105658',
        'CustomerID' => 'رقم العميل',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'بحث النص الكامل في التذاكر (على سبيل المثال. "John*n" أو "Will*"',
        'Types' => 'أنواع',
        'Time Restrictions' => 'قيود الوقت',
        'No time settings' => 'لا توجد إعدادات للوقت',
        'All' => 'الكل',
        'Specific date' => 'تاريخ محدد',
        'Only tickets created' => 'فقط التذاكر التي تم إنشاؤها',
        'Date range' => 'نطاق التاريخ',
        'Only tickets created between' => 'فقط التذاكر التي تم إنشاؤها بين',
        'Ticket Archive System' => 'نظام أرشيف التذاكر',
        'Save Search as Template?' => 'هل تريد حفظ البحث كقالب؟',
        'Save as Template?' => 'هل تريد الحفظ كقالب؟',
        'Save as Template' => 'حفظ كقالب',
        'Pick a profile name' => 'حدد اسم ملف التعريف',
        'Output to' => 'الإخراج حسب',

        # Template: CustomerTicketSearchResultShort
        'of' => 'من',
        'Search Results for' => 'نتائج البحث عن',
        'Remove this Search Term.' => 'إزالة مصطلح البحث هذا.',

        # Template: CustomerTicketZoom
        'Reply' => 'رَدّ',
        'Discard' => 'تَخَلّصَ مِنْ',

        # Template: Chat
        'Expand article' => 'توسيع المقالة',

        # Template: MIMEBase
        'Article Information' => 'معلومات المقالة',

        # Template: TicketInfo
        'Ticket Information' => 'معلومات التذكرة',
        'Categories' => 'فِئَات',
        'Further actions' => 'إجراءات أخرى',

        # Template: CustomerWarning
        'Warning' => 'تحذير',

        # Template: TileNewTicket
        'Issue%sa ticket' => 'إنشاء تذكرة s%',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'معلومات الحدث',

        # Template: Error
        'Send a bugreport' => 'إرسال تقرير الخطأ',
        'Expand' => 'توسيع',

        # Template: Footer
        'Powered by %s' => 'مشغل بواسطة ٪s',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'انقر لحذف هذا المرفق.',

        # Template: DraftButtons
        'Update draft' => 'تحديث المسودة',
        'Save as new draft' => 'حفظ كمسودة جديدة',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'لقد قمت بتحميل المسودة "٪s".',
        'You have loaded the draft "%s". You last changed it %s.' => 'لقد قمت بتحميل المسودة "٪s". آخر تغيير قمت به هو ٪s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'لقد قمت بتحميل المسودة "٪s". تم تغييره للمرة الأخيرة ٪s بواسطة ٪s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'الرجاء ملاحظة أن هذه المسودة قديمة نظرا لتعديل التذكرة منذ إنشاء هذه المسودة.',

        # Template: Header
        'Edit personal preferences' => 'تحرير الإعدادات الشخصية',
        'Personal preferences' => 'الإعدادات الشخصية',
        'You are logged in as' => 'تم تسجيل دخولك ك',

        # Template: Installer
        'JavaScript not available' => 'JavaScript غير متوفر',
        'Step %s' => 'الخطوة ٪s',
        'License' => 'الترخيص',
        'Database Settings' => 'إعدادات قاعدة البيانات',
        'General Specifications and Mail Settings' => 'الإعدادات العامة وإعدادات البريد الإلكتروني',
        'Welcome to %s' => 'مرحبا بك في ٪s',
        'Germany' => 'ألمانيا',
        'Phone' => 'هاتف',
        'Web site' => 'موقع ويب',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'تكوين البريد الصادر',
        'Outbound mail type' => 'نوع البريد الصادر',
        'Select outbound mail type.' => 'حدد نوع البريد الصادر.',
        'Outbound mail port' => 'منفذ البريد الصادر',
        'Select outbound mail port.' => 'تحديد منفذ البريد الصادر.',
        'SMTP host' => 'SMTP-Host',
        'SMTP host.' => 'SMTP-Host.',
        'SMTP authentication' => 'مصادقة SMTP',
        'Does your SMTP host need authentication?' => 'هل يحتاج SMTP-Host إلى مصادقة؟',
        'SMTP auth user' => 'مستخدم مصادقة SMTP',
        'Username for SMTP auth.' => 'اسم المستخدم لمصادقة SMTP.',
        'SMTP auth password' => 'كلمة مرور مصادقة SMTP',
        'Password for SMTP auth.' => 'كلمة مرور لمصادقة SMTP.',
        'Configure Inbound Mail' => 'تكوين البريد الوارد',
        'Inbound mail type' => 'نوع البريد الوارد',
        'Select inbound mail type.' => 'تحديد نوع البريد الوارد.',
        'Inbound mail host' => 'مضيف البريد الوارد',
        'Inbound mail host.' => 'مضيف البريد الوارد.',
        'Inbound mail user' => 'مستخدم البريد الوارد',
        'User for inbound mail.' => 'مستخدم للبريد الوارد.',
        'Inbound mail password' => 'كلمة مرور البريد الوارد',
        'Password for inbound mail.' => 'كلمة المرور للبريد الوارد.',
        'Result of mail configuration check' => 'نتيجة فحص تكوين البريد الإلكتروني',
        'Check mail configuration' => 'فحص تكوين البريد الإلكتروني',
        'Skip this step' => 'تخطي هذه الخطوة',

        # Template: InstallerDBResult
        'Done' => 'تم بنجاح',
        'Error' => 'خطأ',
        'Database setup successful!' => 'تم إنشاء قاعدة البيانات بنجاح!',

        # Template: InstallerDBStart
        'Install Type' => 'نوع التثبيت',
        'Create a new database for OTOBO' => 'إنشاء قاعدة بيانات جديدة ل OTOBO',
        'Use an existing database for OTOBO' => 'إستخدام قاعدة بيانات موجودة ل OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'إذا قمت بتعيين كلمة مرور جذرية لقاعدة البيانات، فيجب إدخالها هنا. إذا لم يكن الأمر كذلك، أترك هذا الحقل فارغا.',
        'Database name' => 'اسم قاعدة البيانات',
        'Check database settings' => 'التحقق من إعدادات قاعدة البيانات',
        'Result of database check' => 'نتيجة فحص قاعدة البيانات',
        'Database check successful.' => 'تم التحقق من قاعدة البيانات بنجاح.',
        'Database User' => 'مستخدم قاعدة البيانات',
        'New' => 'جديد',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'سيتم إنشاء مستخدم قاعدة بيانات جديد بأذونات محدودة لنظام OTOBO هذا.',
        'Generated password' => 'كلمة المرور التي تم إنشاؤها',
        'Repeat Password' => 'كرر كلمة المرور',
        'Passwords do not match' => 'كلمات المرور غير متطابقة',

        # Template: InstallerFinish
        'Start page' => 'الصفحة الرئيسية',
        'Your OTOBO Team' => 'فريق OTOBO الخاص بك',

        # Template: InstallerLicense
        'Don\'t accept license' => 'عدم قبول الترخيص',
        'Accept license and continue' => 'قبول الترخيص والمتابعة',

        # Template: InstallerSystem
        'SystemID' => 'معرف النظام',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'معرف النظام. يحتوي كل رقم تذكرة وكل معرف جلسة عمل HTTP على هذا الرقم.',
        'HTTP Type' => 'نوع HTTP',
        'Set the request scheme used for cookies and various links. For production purposes always use https.' =>
            'يحدد النظام المستخدم لاسترداد ملفات تعريف الارتباط والروابط المختلفة. استخدم دائمًا HTTPS في بيئات الإنتاج.',
        'System FQDN' => 'نظام FQDN',
        'Fully qualified domain name of your system.' => 'اسم المجال المؤهل بالكامل لنظامك.',
        'AdminEmail' => 'البريد الإلكتروني للمسؤول',
        'Email address of the system administrator.' => 'عنوان البريد الإلكتروني لمسؤول النظام.',
        'Organization' => 'مُؤسَّسَة',
        'Log' => 'سِجِلّ',
        'LogModule' => 'وحدة السجل',
        'Log backend to use.' => 'سجل الخلفية للاستخدام.',
        'LogFile' => 'ملف السجل',
        'Webfrontend' => 'واجهة ويب',
        'Default language' => 'اللغة الافتراضية',
        'Default language.' => 'اللغة الافتراضية.',
        'CheckMXRecord' => 'تحقق من MXRecord',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'يتم التحقق من عناوين البريد الإلكتروني التي تم إدخالها يدويا مقابل سجلات MX الموجودة في DNS. لا تستخدم هذا الخيار إذا كان DNS بطيئا أو لا يحل العناوين العامة.',
        'Elasticsearch' => 'البحث المرن',
        'Initialize Elasticsearch' => 'تهيئة البحث المرن',
        'Elasticsearch server was found, and it has been activated automatically for OTOBO.' =>
            'تم العثور على خادم Elasticsearch، وتم تنشيطه تلقائيا ل OTOBO.',
        'Seemingly either no clean Elasticsearch server is running, or it is not using the standard configuration. To activate Elasticsearch manually, please edit the web service in the admin interface if necessary, activate \'Elasticsearch::Active\' and \'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext\' in the SysConfig and run the otobo.Console command \'Maint::Elasticsearch::Migration\'.' =>
            'يبدو أنه لا يوجد خادم Elasticsearch نظيف قيد التشغيل، أو أنه لا يستخدم التكوين القياسي. لتنشيط Elasticsearch يدويا، الرجاء تحرير خدمة ويب في واجهة المسؤول إذا لزم الأمر، قم بتنشيط \'Elasticsearch::Active\' و\'FrontTend::ToolBarModule##250-Ticket::ElasticsearchFulltext\' في SysConfig وقم بتشغيل الأمر otobo.Console \'Maint::Elasticsearch::Migration\'.',

        # Template: LinkObject
        'Delete link' => 'حذف الارتباط',
        'Delete Link' => 'حذف الارتباط',
        'Object#' => 'رقم الكائن',
        'Add links' => 'إضافة إرتباطات',
        'Delete links' => 'حذف الارتباطات',

        # Template: Login
        'Lost your password?' => 'هل نسيت كلمة المرور؟',
        'Back to login' => 'العودة إلى تسجيل الدخول',

        # Template: MetaFloater
        'Scale preview content' => 'قياس محتوى المعاينة',
        'Open URL in new tab' => 'فتح URL في علامة تبويب جديدة',
        'Close preview' => 'إغلاق المعاينة',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'لا يمكن توفير معاينة لموقع الويب هذا لأنه لا يسمح بتضمينه.',

        # Template: Copy
        'Start migration' => 'بدء الترحيل',
        'Result of data migration' => 'نتيجة ترحيل البيانات',
        'Last successful task:' => 'آخر مهمة ناجحة:',
        'Migration will restart from the last successfully finished task. Please do a complete rerun if you changed your system in the meantime.' =>
            'ستتم إعادة تشغيل الترحيل من المهمة الأخيرة التي تم الانتهاء منها بنجاح. الرجاء إجراء إعادة تشغيل كاملة إذا قمت بتغيير النظام في هذه الأثناء.',
        'Clean up and finish' => 'التنظيف والانتهاء',

        # Template: Finish
        'The migration is complete, thank you for trying out OTOBO - we hope you will like it.' =>
            'لقد اكتملت عملية الترحيل، شكرا لك على تجربتك لتطبيق OTOBO - نأمل أن ينال الإعجاب.',
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'لتتمكن من إستخدام OTOBO، يجب إدخال السطر التالي في سطر الأوامر (Terminal/Shell) كجذر.',
        'Restart your webserver' => 'إعادة تشغيل خادم ويب',
        'After doing so your OTOBO is up and running.' => 'بعد القيام بذلك ، يتم تشغيل OTOBO الخاص بك.',

        # Template: Intro
        'This migration script will lead you step by step through the process of migrating your ticket system from OTRS or ((OTRS)) Community Edition version 6 to OTOBO 10.' =>
            'سيقودك هذا البرنامج النصي للترحيل خطوة بخطوة خلال عملية ترحيل نظام تذكرتك من OTRS أو ((OTRS) Community Edition الإصدار 6 إلى OTOBO 10.',
        'There is no danger whatsoever for your original system: nothing is changed there.' =>
            'لا يوجد أي خطر على الإطلاق على نظامك الأصلي: لا يوجد أي تغيير هناك.',
        'Instructions and details on migration prerequisites can be found in the migration manual. We strongly recommend reading it before starting migration.' =>
            'ويمكن الاطلاع على التعليمات والتفاصيل المتعلقة بالشروط الأساسية للهجرة في دليل الهجرة. نوصي بشدة بقراءتها قبل بدء الترحيل.',
        'In case you have to suspend migration, you can resume it anytime at the same point as long as the cache has not been deleted.' =>
            'في حال اضطررت إلى إيقاف الترحيل مؤقتا، يمكنك إستئنافه في أي وقت عند نفس النقطة طالما لم يتم حذف ذاكرة التخزين المؤقت.',
        'All entered passwords are cached until the migration is finished.' =>
            'يتم تخزين كل كلمات المرور المدخلة مؤقتا حتى انتهاء الترحيل.',
        ' Anyone with access to this page, or read permission for the OTOBO Home Directory will be able to read them. If you abort the migration, you are given the option to clear the cache by visiting this page again.' =>
            ' سيتمكن أي شخص لديه حق الوصول إلى هذه الصفحة أو إذن القراءة ل "دليل OTOBO الرئيسي" من قراءتها. إذا قمت بإجهاض الترحيل، سيتم إعطاؤك خيار مسح ذاكرة التخزين المؤقت عن طريق زيارة هذه الصفحة مرة أخرى.',
        'If you need support, just ask our experts – either at' => 'إذا كنت بحاجة إلى الدعم، فما عليك سوى أن تسأل خبراءنا - إما على',
        'OTOBO forum' => 'منتدى OTOBO',
        'or directly via mail to' => 'أو مباشرة عن طريق البريد الإلكتروني إلى',
        'Cached data found' => 'تم العثور على البيانات المخزنة مؤقتا',
        'You will continue where you aborted the migration last time. If you do not want this, please discard your previous progress.' =>
            'ستتم المتابعة حيث قمت بإجهاض الترحيل في المرة الأخيرة. إذا كنت تريد بدء الترحيل مرة أخرى من الصفر، تجاهل كل التغييرات السابقة.',
        'An error occured.' => 'حدث خطأ.',
        'Discard previous progress' => 'تجاهل التغييرات السابقة',
        'Insecure HTTP connection' => 'اتصال HTTP غير آمن',
        'You are using the migration script via http. This is highly insecure as various passwords are required during the process, and will be transferred unencrypted. Anyone between you and the OTOBO server will be able to read them! Please consider setting up https instead.' =>
            'أنت تستخدم البرنامج النصي للترحيل عبر http. وهذا أمر غير آمن إلى حد كبير لأن هناك حاجة إلى كلمات مرور مختلفة أثناء العملية، وسيتم نقلها دون تشفير. سيتمكن أي شخص بينك وبين خادم OTOBO من قراءتها! الرجاء التفكير في إعداد https بدلا من ذلك.',
        'Continue anyways :(' => 'تابع على كل حال :(',
        ' Continue anyways :(' => ' تابع على كل حال :(',

        # Template: OTRSDBSettings
        'DSN' => 'DSN',
        'Skip DB migration' => 'تخطي ترحيل قاعدة البيانات',
        'Expert option! Only works if the migration has already been done by hand.' =>
            'انتباه - خيار خبير! تعمل فقط إذا كان الترحيل قد تم بالفعل يدويا.',
        'Skipped.' => 'تخطي.',

        # Template: OTRSFileSettings
        'OTRS server' => 'خادم OTRS',
        'SSH User' => 'مستخدم SSH',
        'OTRS home directory' => 'الدليل الرئيسي ل OTRS',
        'Check settings' => 'التحقق من الإعدادات',
        'Result of settings check' => 'نتيجة فحص الإعدادات',
        'Settings check successful.' => 'تم التحقق من الإعدادات بنجاح.',

        # Template: PreChecks
        'Execute migration pre-checks' => 'تنفيذ الفحوصات المسبقة للترحيل',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'الميزة غير متوفرة',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'عذرا، ولكن هذه الميزة من OTOBO غير متوفرة حاليا للأجهزة المحمولة. إذا كنت ترغب في إستخدامه، فيمكنك إما التبديل إلى وضع سطح المكتب أو إستخدام جهاز سطح المكتب العادي.',

        # Template: Motd
        'Message of the Day' => 'رسالة اليوم',
        'This is the message of the day. You can edit this in %s.' => 'هذه هي رسالة اليوم. يمكنك تحرير هذا في ٪s.',

        # Template: NoPermission
        'Insufficient Rights' => 'حقوق غير كافية',
        'Back to the previous page' => 'العودة إلى الصفحة السابقة',

        # Template: Alert
        'Alert' => 'تَحْذِير',
        'Powered by' => 'مشغل بواسطة',

        # Template: Pagination
        'Show first page' => 'إظهار الصفحة الأولى',
        'Show previous pages' => 'إظهار الصفحات السابقة',
        'Show page %s' => 'إظهار الصفحة ٪s',
        'Show next pages' => 'إظهار الصفحات التالية',
        'Show last page' => 'إظهار الصفحة الأخيرة',

        # Template: PictureUpload
        'Need FormID!' => 'مطلوب FormID!',
        'No file found!' => 'لم يتم العثور على ملف!',
        'The file is not an image that can be shown inline!' => 'الملف ليس صورة يمكن عرضها في السطر!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'لم يتم العثور على إعلامات قابلة للتكوين من قبل المستخدم.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'تلقي رسائل للإخطار \'٪s\' باستخدام أسلوب النقل \'٪s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'معلومات العملية',
        'Dialog' => 'حِوَارٌ',

        # Template: Article
        'Inform Agent' => 'إعلام العميل',

        # Template: PublicDefault
        'Welcome' => 'أهلا بكم',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'هذه هي الواجهة العامة الافتراضية ل OTOBO! لم يتم توفير معلمة إجراء.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'يمكنك تثبيت وحدة نمطية عامة مخصصة (من خلال إدارة الحزمة)، على سبيل المثال، الوحدة النمطية للأسئلة المتداولة، والتي لها واجهة عامة.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'أذونات',
        'You can select one or more groups to define access for different agents.' =>
            'يمكنك تحديد مجموعة واحدة أو أكثر لمنح حقوق الوصول لوكلاء مختلفين.',
        'Result formats' => 'تنسيقات النتائج',
        'Time Zone' => 'المنطقة الزمنية',
        'The selected time periods in the statistic are time zone neutral.' =>
            'تعتبر الفترات الزمنية المحددة للإحصاءات مستقلة عن المنطقة الزمنية.',
        'Create summation row' => 'إنشاء صف تجميع',
        'Generate an additional row containing sums for all data rows.' =>
            'أنشئ صفًا إضافيًا بإجماليات جميع صفوف البيانات.',
        'Create summation column' => 'إنشاء عمود تجميع',
        'Generate an additional column containing sums for all data columns.' =>
            'إنشاء عمود إضافي بإجماليات كافة أعمدة البيانات.',
        'Cache results' => 'نتائج ذاكرة التخزين المؤقت',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'يخزن بيانات نتائج الإحصائيات في ذاكرة تخزين مؤقت لاستخدامها في طرق العرض اللاحقة بنفس التكوين (يتطلب حقل وقت محددًا واحدًا على الأقل).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'قدم هذه الإحصائية كعنصر واجهة مستخدم للوحة المعلومات يمكن للوكلاء تمكينه على لوحة المعلومات الخاصة بك.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'الرجاء ملاحظة أن تمكين عنصر واجهة مستخدم لوحة المعلومات سيقوم بتنشيط التخزين المؤقت لهذه الإحصائية في لوحة المعلومات.',
        'If set to invalid end users can not generate the stat.' => 'إذا كانت الحالة "غير صالحة" ، فلن يتمكن المستخدمون من تشغيل الإحصائيات.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'هناك مشاكل في تكوين هذه الإحصائية:',
        'You may now configure the X-axis of your statistic.' => 'يمكنك الآن تكوين المحور X للإحصائية الخاصة بك.',
        'This statistic does not provide preview data.' => 'لا توفر هذه الإحصائية بيانات معاينة.',
        'Preview format' => 'تنسيق المعاينة',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'يرجى ملاحظة أن المعاينة تستخدم بيانات عشوائية ولا تأخذ في الاعتبار عوامل تصفية البيانات.',
        'Configure X-Axis' => 'تكوين المحور X',
        'X-axis' => 'المحور X',
        'Configure Y-Axis' => 'تكوين المحور Y',
        'Y-axis' => 'المحور Y',
        'Configure Filter' => 'تكوين عامل التصفية',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'الرجاء تحديد عنصر واحد فقط أو إلغاء تحديد مربع الاختيار "ثابت".',
        'Absolute period' => 'الفترة المطلقة',
        'Between %s and %s' => 'بين ٪s و ٪s',
        'Relative period' => 'الفترة النسبية',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'الماضي ٪s والحالي+القادم ٪s ٪s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'لا تسمح بإجراء تغييرات على هذا العنصر عند إنشاء الإحصائية.',

        # Template: StatsParamsWidget
        'Exchange Axis' => 'محاور التبادل',
        'Configurable Params of Static Stat' => 'معلمات قابلة للتكوين للإحصاءات الثابتة',
        'No element selected.' => 'لم يتم تحديد أي عنصر.',
        'Scale' => 'تَصْعِيدٌ',
        'show more' => 'إظهار المزيد',
        'show less' => 'إظهار أقل',

        # Template: D3
        'Download SVG' => 'تنزيل SVG',
        'Download PNG' => 'تنزيل PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'تحدد الفترة الزمنية المحددة الوقت (الافتراضي) الذي تجمع منه هذه الإحصائية البيانات.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'يحدد الوحدة الزمنية التي يتم بها تقسيم الفترة الزمنية المحددة إلى نقاط بيانات التقرير.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'يرجى تذكر أن مقياس المحور Y يجب أن يكون أكبر من مقياس المحور X (على سبيل المثال ، المحور X = > الشهر ، المحور Y = > السنة).',

        # Template: StatsWidget
        'Remove statistic' => 'إزالة الإحصائية',
        'If you don\'t specify a title here, the title of the statistic will be used.' =>
            'إذا لم تحدد عنوانا هنا، فسيتم إستخدام عنوان الإحصائية.',
        'Preface' => 'مُقَدِّمَةٌ',
        'Postface' => 'خَاتِمة',

        # Template: SettingHistoryListCompare
        'On ' => 'إلَى ',
        'Reset to this value' => 'إعادة التعيين إلى هذه القيمة',

        # Template: SettingsList
        'This setting is disabled.' => 'تم تعطيل هذا الإعداد.',
        'This setting is fixed but not deployed yet!' => 'تم تصحيح الإعداد، ولكن لم يتم تشغيله بعد!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'يتم الكتابة فوق هذا الإعداد حاليًا في٪ s وبالتالي لا يمكن تغييره هنا!',
        'Changing this setting is only available in a higher config level!' =>
            'لا يتوفر تغيير هذا الإعداد إلا في مستوى تكوين أعلى!',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => 'إظهار/إخفاء الخيارات المتقدمة لهذا الإعداد',
        'Disable this setting, so it is no longer effective' => 'تعطيل الإعداد بحيث لا يعود له أي تأثير',
        'Disable' => 'تعطيل',
        'Enable this setting, so it becomes effective' => 'تمكين هذا الإعداد، بحيث يصبح فعالا',
        'Enable' => 'تمكين',
        'Reset this setting to its default state' => 'إعادة تعيين الإعداد إلى الإعداد الافتراضي',
        'Reset setting' => 'إعادة تعيين الإعداد',
        'Allow users to adapt this setting from within their personal preferences' =>
            'السماح للمستخدمين بضبط هذا الإعداد في إعداداتهم الشخصية',
        'Allow users to update' => 'السماح للمستخدمين بالتحديث',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'لم يعد يسمح للمستخدمين بضبط هذا الإعداد في إعداداتهم الشخصية',
        'Forbid users to update' => 'منع المستخدمين من التحديث',
        'Show user specific changes for this setting' => 'إظهار التغييرات التي قام بها المستخدمون لهذا الإعداد',
        'Show user settings' => 'إظهار إعدادات المستخدم',
        'Copy a direct link to this setting to your clipboard' => 'نسخ إرتباط مباشر إلى هذا الإعداد إلى الحافظة الخاصة بك',
        'Copy direct link' => 'نسخ الارتباط المباشر',
        'Remove this setting from your favorites setting' => 'إزالة هذا الإعداد من إعداد المفضلة',
        'Remove from favourites' => 'إزالة من المفضلة',
        'Add this setting to your favorites' => 'إضافة هذا الإعداد إلى المفضلة',
        'Add to favourites' => 'إضافة إلى المفضلة',
        'Cancel editing this setting' => 'إلغاء تحرير هذا الإعداد',
        'Save changes on this setting' => 'حفظ التغييرات على هذا الإعداد',
        'Edit this setting' => 'تحرير هذا الإعداد',
        'Enable this setting' => 'تمكين هذا الإعداد',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'لا تحتوي هذه المجموعة على أي إعدادات. الرجاء محاولة الانتقال إلى إحدى مجموعاتها الفرعية أو مجموعة أخرى.',

        # Template: SettingsListCompare
        'Now' => 'الآن',
        'User modification' => 'تعديل المستخدم',
        'enabled' => 'مُمَكّنٌ',
        'disabled' => 'معطّل',
        'Setting state' => 'حالة الإعداد',

        # Template: Actions
        'Edit search' => 'تحرير البحث',
        'Go back to admin: ' => 'العودة إلى المسؤول: ',
        'Deployment' => 'تَفْعِيلٌ',
        'My favourite settings' => 'الإعدادات المفضلة لدي',
        'Invalid settings' => 'إعدادات غير صالحة',

        # Template: DynamicActions
        'Filter visible settings...' => 'تصفية الإعدادات المرئية...',
        'Enable edit mode for all settings' => 'تمكين وضع التحرير لكافة الإعدادات',
        'Save all edited settings' => 'حفظ كافة الإعدادات المحررة',
        'Cancel editing for all settings' => 'إلغاء التحرير لكافة الإعدادات',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'كل الإجراءات من عنصر واجهة المستخدم هذا تنطبق على الإعدادات المرئية الموجودة على اليمين فقط.',

        # Template: Help
        'Currently edited by me.' => 'تم تحريره حاليا بواسطتي.',
        'Modified but not yet deployed.' => 'تم تحريره ولكن لم يتم تشغيله بعد.',
        'Currently edited by another user.' => 'تم تحريره حاليا من قبل مستخدم آخر.',
        'Different from its default value.' => 'تختلف عن قيمتها الافتراضية.',
        'Save current setting.' => 'حفظ الإعداد الحالي.',
        'Cancel editing current setting.' => 'إلغاء تحرير الإعداد الحالي.',

        # Template: Navigation
        'Navigation' => 'التصفح',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => 'تجاهل تغيير المستخدم.',

        # Template: Test
        'OTOBO Test Page' => 'صفحة إختبار OTOBO',
        'Unlock' => 'الغاء القفل',
        'Welcome %s %s' => 'مرحبا ٪s ٪s',
        'Counter' => 'عَدَّاد',

        # Template: TranslationsTable
        'Filter Content' => '',
        'Filter for Translations' => '',
        'No content available to translate.' => '',

        # Template: Warning
        'Go back to the previous page' => 'العودة إلى الصفحة السابقة',

        # JS Template: CalendarSettingsDialog
        'Show' => 'إظهار',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'عنوان المسودة',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'عرض المقالة',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'هل تريد حقا حذف "٪s"؟',
        'Confirm' => 'تأكيد',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'يتم الآن التحميل، الرجاء الانتظار...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => 'إظهار الكل',
        'Show less' => 'إظهار أقل',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'انقر لتحديد ملف للتحميل.',
        'Click to select or drop files here.' => 'انقر لتحديد أو إسقاط الملفات هنا.',
        'Click to select files or just drop them here.' => 'انقر لتحديد الملفات أو قم بإفلاتها هنا.',
        'Click to select a file or just drop it here.' => 'انقر لتحديد ملف أو قم بإفلاته هنا.',
        'Uploading...' => 'يتم الآن التحميل...',

        # JS Template: MigrationState
        'Time needed' => 'الوقت اللازم',

        # JS Template: PackageResolve
        'Package' => 'حُزْمَةٌ',
        'Uninstall from OTOBO' => 'إزالة التثبيت من OTOBO',
        'Ignore' => 'تجاهل',
        'Migrate' => 'تَرْحِيلٌ',

        # JS Template: InformationDialog
        'Process state' => 'حالة العملية',
        'Running' => 'مُسْتَمِرٌّ',
        'Finished' => 'انتهى',
        'No package information available.' => 'لا تتوفر معلومات الحزمة.',

        # JS Template: AddButton
        'Add new entry' => 'إضافة إدخال جديد',

        # JS Template: AddHashKey
        'Add key' => 'إضافة مفتاح',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'تعليق النشر...',
        'This field can have no more than 250 characters.' => 'لا يمكن أن يحتوي هذا الحقل على أكثر من 250 حرفا.',
        'Deploying, please wait...' => 'يتم التنفيذ، يرجى الانتظار...',
        'Preparing to deploy, please wait...' => 'يتم الآن التحضير للتنفيذ، الرجاء الانتظار...',
        'Deploy now' => 'ضعها موضع التنفيذ الآن',
        'Try again' => 'حاول مرة أخرى',

        # JS Template: DialogReset
        'Reset options' => 'خيارات إعادة الضبط',
        'Reset setting on global level.' => 'إعادة تعيين الإعداد على المستوى العمومي.',
        'Reset globally' => 'إعادة تعيين بشكل عمومي',
        'Remove all user changes.' => 'إزالة كافة تغييرات المستخدم.',
        'Reset locally' => 'إعادة التعيين محليا',
        'user(s) have modified this setting.' => 'قام المستخدم (المستخدمين) بتعديل هذا الإعداد.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'هل تريد حقا إعادة تعيين هذا الإعداد إلى قيمته الافتراضية؟',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'يمكنك إستخدام تحديد الفئة لتقييد شجرة التصفح بإدخالات من الفئة المحددة. عند تحديد مدخل، سيتم إعادة بناء الشجرة تلقائيا.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'قاعدة البيانات الخلفية',
        'CustomerIDs' => 'أرقام العميل',
        'Fax' => 'رقم الفاكس',
        'Street' => 'الشارع',
        'Zip' => 'الرمز البريدي',
        'City' => 'المدينة',
        'Country' => 'الدولة',
        'Mr.' => 'سيد',
        'Mrs.' => 'سيدة',
        'Manager' => '',
        'Address' => 'العنوان',
        'View system log messages.' => 'عرض رسائل سجل النظام.',
        'Edit the system configuration settings.' => 'تحرير إعدادات تكوين النظام.',
        'Update and extend your system with software packages.' => 'قم بتحديث النظام الخاص بك وتوسيعه باستخدام حزم البرامج.',

        # Perl Module: Kernel/Language.pm
        '(in process)' => '(قيد التنفيذ)',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'معلومات ال ACL في قاعدة البيانات غير متزامنة مع إعدادات تكوين النظام. فضلاً قم بتمرير كل ال ACLs.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'تعذر استيراد قوائم التحكم في الوصول (ACLs) بسبب خطأ غير معروف، يرجى مراجعة سجلات OTOBO لمزيد من المعلومات',
        'The following ACLs have been added successfully: %s' => 'تمت إضافة قوائم التحكم بالوصول (ACLs) التالية بنجاح: ٪s',
        'The following ACLs have been updated successfully: %s' => 'تم تحديث قوائم التحكم بالوصول (ACLs) التالية بنجاح: ٪s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'هناك أخطاء في إضافة/تحديث قوائم التحكم بالوصول (ACLs) التالية: ٪s. الرجاء التحقق من ملف السجل للحصول على مزيد من المعلومات.',
        'There was an error creating the ACL' => 'حدث خطأ في إنشاء قائمة التحكم بالوصول (ACL)',
        'Need ACLID!' => 'تحتاج إلى ACL-ID!',
        'Could not get data for ACLID %s' => 'تعذر الحصول على بيانات ل ACL-ID ٪s',
        'There was an error updating the ACL' => 'حدث خطأ في تحديث قائمة التحكم بالوصول (ACL)',
        'There was an error setting the entity sync status.' => 'حدث خطأ أثناء تعيين حالة المزامنة.',
        'There was an error synchronizing the ACLs.' => 'حدث خطأ أثناء مزامنة قوائم التحكم بالوصول (ACLs).',
        'ACL %s could not be deleted' => 'تعذر حذف قوائم التحكم في الوصول (ACL) ٪s',
        'There was an error getting data for ACL with ID %s' => 'حدث خطأ في الحصول على بيانات لقوائم التحكم في الوصول (ACL) باستخدام ID ٪s',
        '%s (copy) %s' => '٪s (نسخة) ٪s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'يرجى ملاحظة أن قيود ACL لا تنطبق على حساب المستخدم المتميز (UserID 1).',
        'Exact match' => 'تطابق تام',
        'Negated exact match' => 'نفي المطابقة التامة',
        'Regular expression' => 'تعبير نمطي',
        'Regular expression (ignore case)' => 'التعبير النمطي (تجاهل حالة الأحرف)',
        'Negated regular expression' => 'نفي التعبير العادي',
        'Negated regular expression (ignore case)' => 'التعبير العادي المنفي (تجاهل الحالة)',

        # Perl Module: Kernel/Modules/AdminAbout.pm
        'Could not update About message!' => 'تعذر تحديث حول الرسالة!',
        'About message updated!' => 'حول الرسالة التي تم تحديثها!',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'تعذر على النظام إنشاء تقويم!',
        'Please contact the administrator.' => 'الرجاء الاتصال بالمسؤول.',
        'No CalendarID!' => 'لا يوجد معرف تقويم!',
        'You have no access to this calendar!' => 'ليس لديك حق الوصول إلى هذا التقويم!',
        'Error updating the calendar!' => 'خطأ في تحديث التقويم!',
        'Couldn\'t read calendar configuration file.' => 'تعذر قراءة ملف تكوين التقويم.',
        'Please make sure your file is valid.' => 'الرجاء التأكد من أن ملفك صالح.',
        'Could not import the calendar!' => 'تعذر إستيراد التقويم!',
        'Calendar imported!' => 'تم إستيراد التقويم!',
        'Need CalendarID!' => 'بحاجة إلى معرف التقويم!',
        'Could not retrieve data for given CalendarID' => 'تعذر إسترداد البيانات ل معرف تقويم المحدد',
        'Successfully imported %s appointment(s) to calendar %s.' => 'تم إستيراد ٪s موعد/مواعيد بنجاح إلى التقويم ٪s.',
        '+5 minutes' => '+5 دقائق',
        '+15 minutes' => '+15 دقيقة',
        '+30 minutes' => '+30 دقيقة',
        '+1 hour' => '+1 ساعة',
        '+1 day' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'لا توجد أذونات',
        'System was unable to import file!' => 'تعذر على النظام إستيراد الملف!',
        'Please check the log for more information.' => 'الرجاء مراجعة السجل للحصول على مزيد من المعلومات.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'اسم الإخطار موجود بالفعل!',
        'Notification added!' => 'تمت إضافة إخطار!',
        'There was an error getting data for Notification with ID:%s!' =>
            'حدث خطأ أثناء إسترداد البيانات للإشعار بالمعرف ٪s!',
        'Unknown Notification %s!' => 'إخطار غير معروف ٪s!',
        '%s (copy)' => '٪s (نسخة)',
        'There was an error creating the Notification' => 'حدث خطأ في إنشاء الإخطار',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'تعذر استيراد الإخطارات بسبب خطأ غير معروف، يرجى مراجعة سجلات OTOBO لمزيد من المعلومات',
        'The following Notifications have been added successfully: %s' =>
            'تمت إضافة الإخطارات التالية بنجاح: ٪s',
        'The following Notifications have been updated successfully: %s' =>
            'تم تحديث الإخطارات التالية بنجاح: ٪s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'هناك أخطاء في إضافة/تحديث الإخطارات التالية: ٪s. الرجاء التحقق من ملف السجل للحصول على مزيد من المعلومات.',
        'Notification updated!' => 'تم تحديث الإخطار!',
        'Agent (resources), who are selected within the appointment' => 'الوكيل (الموارد)، الذي يتم إختياره ضمن الموعد',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'جميع الوكلاء الذين لديهم (على الأقل) إذن القراءة للموعد (التقويم)',
        'All agents with write permission for the appointment (calendar)' =>
            'جميع الوكلاء الذين لديهم إذن الكتابة للموعد (التقويم)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'No permission to edit this attachment.' => '',
        'Attachment added!' => 'تمت إضافة المرفق!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'تمت إضافة الاستجابة التلقائية!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'معرف الاتصال غير صالح!',
        'All communications' => 'جميع الاتصالات',
        'Last 1 hour' => 'آخر ساعة',
        'Last 3 hours' => 'آخر 3 ساعات',
        'Last 6 hours' => 'آخر 6 ساعات',
        'Last 12 hours' => 'آخر 12 ساعة',
        'Last 24 hours' => 'آخر 24 ساعة',
        'Last week' => 'الأسبوع الماضي',
        'Last month' => 'الشهر الماضي',
        'Invalid StartTime: %s!' => 'وقت بدء غير صالح: ٪s!',
        'Successful' => 'نَاجِحٌ',
        'Processing' => 'تمت معالجتها',
        'Invalid Filter: %s!' => 'فشل عامل التصفية غير صالح: ٪s!',
        'Less than a second' => 'أقل من ثانية',
        'sorted descending' => 'فرز تنازلي',
        'sorted ascending' => 'فرز تصاعدي',
        'Trace' => 'وَثَّقَ',
        'Debug' => 'تصحيح الأخطاء',
        'Info' => 'معلومات',
        'Warn' => 'تحذير',
        'days' => 'أيام',
        'day' => 'يوم',
        'hour' => 'ساعة',
        'minute' => 'دقيقة',
        'seconds' => 'ثواني',
        'second' => 'ثانية',

        # Perl Module: Kernel/Modules/AdminContactWD.pm
        'No contact is given!' => 'لا توجد تفاصيل جهة الاتصال!',
        'No data found for given contact in given source!' => 'تعذر العثور على بيانات جهة الاتصال في المصدر المحدد!',
        'Contact updated!' => 'تم تحديث جهة الاتصال!',
        'No field data found!' => 'لم يتم العثور على بيانات الحقل!',
        'Contact created!' => 'تم إنشاء جهة اتصال!',
        'Error creating contact!' => 'خطأ في إنشاء جهة اتصال!',
        'No sources found, at least one "Contact with data" dynamic field must be added to the system!' =>
            'لم يتم العثور على مصادر. الرجاء إضافة حقل ديناميكي واحد على الأقل "بيانات الاتصال" إلى النظام!',
        'No data found for given source!' => 'لم يتم العثور على بيانات في المصدر المحدد!',

        # Perl Module: Kernel/Modules/AdminCustomerAccept.pm
        'Could not update Privacy Policy!' => 'تعذر تحديث نهج الخصوصية!',
        'Privacy Policy updated!' => 'تم تحديث نهج الخصوصية!',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'تم تحديث شركة العميل!',
        'Dynamic field %s not found!' => 'لم يتم العثور على الحقل الديناميكي ٪s!',
        'Unable to set value for dynamic field %s!' => 'يتعذر تعيين قيمة للحقل الديناميكي ٪s!',
        'Customer Company %s already exists!' => 'شركة العميل ٪s موجودة بالفعل!',
        'Customer company added!' => 'تمت اضافة شركة العميل!',

        # Perl Module: Kernel/Modules/AdminCustomerDashboardInfoTile.pm
        'Start date shouldn\'t be defined after Stop date!' => 'يجب عدم تحديد تاريخ البدء بعد تاريخ الإيقاف!',
        'Name is missing!' => '',
        'Content is missing!' => '',
        'ValidID is missing!' => '',
        'Group is missing!' => '',
        'There was an error creating the info tile entry' => '',
        'Need ID!' => '',
        'This Entry does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Could not get data for ID %s' => '',
        'Info tile entry was added successfully!' => '',
        'Info tile entry was updated successfully!' => '',
        'Session has been killed!' => 'تم إغلاق الجلسة!',
        'All sessions have been killed, except for your own.' => 'تم إغلاق جميع الجلسات، ما عدا جلستك.',
        'There was an error updating the info tile entry' => '',
        'It was not possible to delete the info tile entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'لم يتم العثور على تكوين ل \'CustomerGroupPermissionContext\'!',
        'Please check system configuration.' => 'الرجاء التحقق من تكوين النظام.',
        'Invalid permission context configuration:' => 'تكوين سياق الإذن غير صالح:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'تم تحديث العميل!',
        'New phone ticket' => 'تذكرة هاتف جديدة',
        'New email ticket' => 'تذكرة بريد إلكتروني جديدة',
        'Customer %s added' => 'تمت إضافة العميل ٪s',
        'Customer user updated!' => 'تم تحديث مستخدم العميل!',
        'Same Customer' => 'نفس العميل',
        'Direct' => 'مُبَاشِرٌ',
        'Indirect' => 'غَيْرُ مُبَاشِر',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'تغيير علاقات مستخدم العميل للمجموعة',
        'Change Group Relations for Customer User' => 'إدارة مهام المجموعة لمستخدمي العملاء',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'تعيين مستخدمي العملاء إلى الخدمات',
        'Allocate Services to Customer User' => 'تخصيص الخدمات لمستخدم العميل',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'تكوين الحقول غير صالح',
        'Objects configuration is not valid' => 'تكوين الكائن غير صالح',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'تعذر إعادة تعيين ترتيب "الحقل الديناميكي" بشكل صحيح، الرجاء التحقق من سجل الأخطاء للحصول على مزيد من التفاصيل.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'إجراء فرعي غير معرف.',
        'Need %s' => 'الحاجة إلى ٪s',
        'Add %s field' => 'إضافة حقل ٪s',
        'The field must be numeric.' => 'قد يحتوي الحقل على أرقام فقط.',
        'The field does not contain only ASCII letters and numbers.' => 'لا يحتوي الحقل على أحرف وأرقام ASCII فقط.',
        'There is another field with the same name.' => 'يوجد حقل آخر يحمل نفس الاسم.',
        'Need ValidID' => 'مطلوب معرف صالح',
        'Could not create the new field' => 'تعذر إنشاء الحقل الجديد',
        'Need ID' => 'بحاجة إلى معرف',
        'Could not get data for dynamic field %s' => 'تعذر الحصول على بيانات للحقل الديناميكي ٪s',
        'Change %s field' => 'تغيير حقل ٪s',
        'The name for this field should not change.' => 'يجب عدم تغيير اسم هذا الحقل.',
        'Could not update the field %s' => 'تعذر تحديث الحقل ٪s',
        'Currently' => 'حالياً',
        'Unchecked' => 'غير محدد',
        'Checked' => 'مُنْتَقىً',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => 'مفتاح الحقل هذا موجود بالفعل.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'هذه القيمة موجودة بالفعل.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'منع إدخال التواريخ في المستقبل',
        'Prevent entry of dates in the past' => 'منع إدخال التواريخ في الماضي',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'Syntax is incorrect. Please provide a parent element name in front of the double colon.' =>
            '',
        'An element is used as parent element, but not included itself. Please include it.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldLens.pm
        'The referenced dynamic field' => '',
        'Select the dynamic field that references an object' => '',
        'The attribute of the referenced object' => '',
        'Select the attribute dynamic field that references an object' =>
            '',
        'A field of type %s is currently not usable as lens attribute.' =>
            '',
        'Field %s is not a reference field.' => '',
        'Not a valid dynamic field.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => 'تم حفظ الإعدادات.',
        'System was not able to save the setting!' => 'تعذر على النظام حفظ الإعداد!',
        'Setting is locked by another user!' => 'تم تأمين الإعداد بواسطة مستخدم آخر!',
        'System was not able to reset the setting!' => 'تعذر على النظام إعادة تعيين الإعداد!',
        'Settings were reset.' => 'تم إعادة تعيين الإعدادات.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScript.pm
        'Need valid field driver.' => '',
        'Bad value in RequiredArgs.' => '',
        'Bad value in PreviewTriggers.' => '',
        'Bad value in StorageTriggers.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldSet.pm
        'Missing Dynamic Field.' => '',
        'No valid dynamic field "%s."' => '',
        'The dynamic field type "%s" of dynamic field "%s" can not be used in sets.' =>
            '',
        'The dynamic field "%s" is already in use in a ticket mask.' => '',
        'Misconfigured Grid - need Rows as Array!' => '',
        'Misconfigured Grid - need Columns as integer > 0!' => '',
        'Misconfigured Grid - Rows can\'t be empty!' => '',
        'Misconfigured Grid - Rows must contain entries with key \'DF\'!' =>
            '',
        'Missing Dynamic Field or Grid.' => '',
        'The field must be a valid YAML containing an array of dynamic fields.' =>
            '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'حدد مستلما واحدا على الأقل.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'دقيقة (دقائق)',
        'hour(s)' => 'ساعة (ساعات)',
        'Time unit' => 'وحدة قياس الوقت',
        'within the last ...' => 'في آخر ...',
        'within the next ...' => 'خلال الفترة القادمة . . .',
        'more than ... ago' => 'أكثر من ... قبل',
        'Unarchived tickets' => 'تذاكر غير محفوظة في الأرشيف',
        'archive tickets' => 'تذاكر الأرشيف',
        'restore tickets from archive' => 'إستعادة التذاكر من الأرشيف',
        'Need Profile!' => 'مطلوب ملف التعريف!',
        'Got no values to check.' => 'لا توجد قيم للتحقق منها.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'الرجاء إزالة الكلمات التالية لأنه لا يمكن إستخدامها لتحديد التذاكر:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'بحاجة إلى معرف خدمة الويب!',
        'Could not get data for WebserviceID %s' => 'تعذر العثور على بيانات لمعرف خدمة ويب ٪s',
        'ascending' => 'تصاعدي',
        'descending' => 'تنازلي',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'نوع الاتصال مطلوب!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'يجب أن يكون نوع الاتصال \'الطالب\' أو \'الموفر\'!',
        'Invalid Subaction!' => 'إجراء فرعي غير صالح!',
        'Need ErrorHandlingType!' => 'تحتاج إلى نوع معالجة الخطأ!',
        'ErrorHandlingType %s is not registered' => 'خطأ في معالجة النوع ٪s غير مسجل',
        'Could not update web service' => 'تعذر تحديث خدمة ويب',
        'Need ErrorHandling' => 'تحتاج معالجة الخطأ',
        'Could not determine config for error handler %s' => 'تعذر تحديد التكوين لمعالج الأخطاء ٪s',
        'Invoker processing outgoing request data' => 'يقوم Invoker بمعالجة بيانات الطلب الصادر',
        'Mapping outgoing request data' => 'تعيين بيانات الطلب الصادر',
        'Transport processing request into response' => 'طلب معالجة النقل إلى إستجابة',
        'Mapping incoming response data' => 'تعيين بيانات الاستجابة الواردة',
        'Invoker processing incoming response data' => 'معالجة Invoker لبيانات الاستجابة الواردة',
        'Transport receiving incoming request data' => 'نقل بيانات الطلبات الواردة',
        'Mapping incoming request data' => 'تعيين بيانات الطلب الواردة',
        'Operation processing incoming request data' => 'معالجة بيانات الطلب الوارد للعملية',
        'Mapping outgoing response data' => 'تعيين بيانات الاستجابة الصادرة',
        'Transport sending outgoing response data' => 'النقل يرسل بيانات الاستجابة',
        'skip same backend modules only' => 'تخطي نفس وحدات الطرف الخلفي فقط',
        'skip all modules' => 'تخطي كافة الوحدات النمطية',
        'Operation deleted' => 'تم حذف العملية',
        'Invoker deleted' => 'تم حذف Invoker',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 ثانية',
        '15 seconds' => '15 ثانية',
        '30 seconds' => '30 ثانية',
        '45 seconds' => '45 ثانية',
        '1 minute' => 'دقيقة واحدة',
        '2 minutes' => 'دقيقتان',
        '3 minutes' => '3 دقائق',
        '4 minutes' => '4 دقائق',
        '5 minutes' => '5 دقائق',
        '10 minutes' => '10 دقائق',
        '15 minutes' => '15 دقيقة',
        '30 minutes' => '30 دقيقة',
        '1 hour' => 'ساعة واحدة',
        '2 hours' => 'ساعتان',
        '3 hours' => '3 ساعات',
        '4 hours' => '4 ساعات',
        '5 hours' => '5 ساعات',
        '6 hours' => '6 ساعات',
        '12 hours' => '12 ساعة',
        '18 hours' => '18 ساعة',
        '1 day' => 'يوم واحد',
        '2 days' => 'يومان',
        '3 days' => '3 أيام',
        '4 days' => '4 أيام',
        '6 days' => '6 أيام',
        '1 week' => 'أسبوع واحد',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'تعذر تحديد التكوين للمدعي ٪s',
        'InvokerType %s is not registered' => 'نوع المدعو ٪s غير مسجل',
        'MappingType %s is not registered' => 'نوع التعيين ٪s غير مسجل',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'تحتاج إلى Invoker!',
        'Need Event!' => 'بحاجة الى حدث!',
        'Could not get registered modules for Invoker' => 'تعذر إسترداد الوحدات المسجلة للمستدعين',
        'Could not get backend for Invoker %s' => 'تعذر استدعاء الواجهة الخلفية للمستدعي ٪s',
        'The event %s is not valid.' => 'الحدث ٪s غير صالح.',
        'Could not update configuration data for WebserviceID %s' => 'تعذر تحديث بيانات التكوين لمعرف خدمة ويب ٪s',
        'This sub-action is not valid' => 'هذا الإجراء الفرعي غير صالح',
        'xor' => 'حصري أو (xor)',
        'String' => 'سلسلة أحرف',
        'Regexp' => 'Regexp',
        'Validation Module' => 'وحدة التحقق',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerTicket.pm
        'Invisible only' => 'غير مرئي فقط',
        'Visible only' => 'مرئي فقط',
        'Visible and invisible' => 'مرئي وغير مرئي',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'تعيين بسيط للبيانات الصادرة',
        'Simple Mapping for Incoming Data' => 'تعيين بسيط للبيانات الواردة',
        'Could not get registered configuration for action type %s' => 'تعذر الحصول على تكوين مسجل لنوع الإجراء ٪s',
        'Could not get backend for %s %s' => 'تعذر الحصول على النهاية الخلفية ل ٪s ٪s',
        'Keep (leave unchanged)' => 'الاحتفاظ (ترك دون تغيير)',
        'Ignore (drop key/value pair)' => 'تجاهل (إزالة زوج المفاتيح/القيمة)',
        'Map to (use provided value as default)' => 'تعيين إلى (إستخدام القيمة المقدمة كقيمة افتراضية)',
        'Exact value(s)' => 'القيمة (القيم) بالضبط',
        'Ignore (drop Value/value pair)' => 'تجاهل (إسقاط زوج القيمة/القيمة)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'تعيين XSLT للبيانات الصادرة',
        'XSLT Mapping for Incoming Data' => 'تعيين XSLT للبيانات الواردة',
        'Could not find required library %s' => 'تعذر العثور على المكتبة المطلوبة ٪s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'بيانات الطلب الصادر قبل المعالجة (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'بيانات الطلب الصادر قبل التعيين (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'بيانات الطلب الصادر بعد التعيين (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'بيانات الاستجابة الواردة قبل التعيين (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'بيانات معالج أخطاء الصادر بعد معالجة الخطأ (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'بيانات الطلب الواردة قبل التعيين (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'بيانات الطلب الواردة بعد التعيين (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'بيانات الاستجابة الصادرة قبل التعيين (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'بيانات معالج أخطاء الصادر بعد معالجة الخطأ (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'تعذر تحديد التكوين للعملية ٪s',
        'OperationType %s is not registered' => 'نوع العملية ٪s غير مسجل',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'الحاجة إلى إجراء فرعي صالح!',
        'This field should be an integer.' => 'يجب أن يكون هذا الحقل عددًا صحيحًا.',
        'File or Directory not found.' => 'لم يتم العثور على الملف أو الدليل.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'توجد خدمة ويب أخرى بنفس الاسم.',
        'There was an error updating the web service.' => 'حدث خطأ أثناء تحديث خدمة ويب.',
        'There was an error creating the web service.' => 'حدث خطأ أثناء إنشاء خدمة ويب.',
        'Web service "%s" created!' => 'تم إنشاء خدمة ويب "٪s"!',
        'Need Name!' => 'تحتاج إلى اسم!',
        'Need ExampleWebService!' => 'تحتاج إلى عينة من خدمة الويب!',
        'Could not load %s.' => 'تعذر تحميل ٪s.',
        'Could not read %s!' => 'تعذر قراءة ٪s!',
        'Need a file to import!' => 'تحتاج إلى ملف لاستيراده!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'الملف الذي تم إستيراده لا يحتوي على محتوى YAML صحيح! يرجى مراجعة سجل OTOBO للحصول على التفاصيل',
        'Web service "%s" deleted!' => 'تم حذف خدمة ويب "٪s"!',
        'OTOBO as provider' => 'OTOBO كمزود',
        'Operations' => 'العمليات',
        'OTOBO as requester' => 'OTOBO كطالب',
        'Invokers' => 'المستدعون',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'لم يتم استلام معرف سجل خدمة الويب!',
        'Could not get history data for WebserviceHistoryID %s' => 'تعذر الحصول على بيانات المحفوظات لمعرف محفوظات خدمة الويب ٪s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'تم تحديث المجموعة!',

        # Perl Module: Kernel/Modules/AdminImportExport.pm
        'No object backend found!' => '',
        'No format backend found!' => '',
        'Template not found!' => '',
        'Can\'t insert/update template!' => '',
        'Needed TemplateID!' => '',
        'Error occurred. Import impossible! See Syslog for details.' => '',
        'Error occurred. Export impossible! See Syslog for details.' => '',
        'Template List' => '',
        'number' => '',
        'number bigger than zero' => '',
        'integer' => '',
        'integer bigger than zero' => '',
        'Element required, please insert data' => '',
        'Invalid data, please insert a valid %s' => '',
        'Format not found!' => '',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'تمت اضافة حساب البريد الإلكتروني!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'إحضار حساب البريد الإلكتروني بالفعل من قبل عملية أخرى. الرجاء المحاولة مرة أخرى لاحقا!',
        'Dispatching by email To: field.' => 'الإرسال عبر البريد الإلكتروني إلى: الحقل.',
        'Dispatching by selected Queue.' => 'الإرسال حسب قائمة الانتظار المحددة.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'No permission to edit this ticket notification.' => '',
        'You need %s permissions!' => 'تحتاج إلى أذونات %s!',
        'Agent who created the ticket' => 'الوكيل الذي أنشأ التذكرة',
        'Agent who owns the ticket' => 'الوكيل الذي يملك التذكرة',
        'Agent who is responsible for the ticket' => 'الوكيل المسؤول عن التذكرة',
        'All agents watching the ticket' => 'جميع العملاء الذين يراقبون التذكرة',
        'All agents with write permission for the ticket' => 'كل الوكلاء الذين لديهم إذن كتابة للتذكرة',
        'All agents subscribed to the ticket\'s queue' => 'جميع الوكلاء المشتركين في قائمة انتظار التذكرة',
        'All agents subscribed to the ticket\'s service' => 'جميع الوكلاء مشتركون في خدمة التذكرة',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'جميع الوكلاء مشتركون في كل من قائمة انتظار التذكرة والخدمة',
        'Customer user of the ticket' => 'مستخدم العميل للتذكرة',
        'All recipients of the first article' => 'كل المتلقين للمقال الأول',
        'All recipients of the last article' => 'جميع المستلمين في المقالة الأخيرة',
        'Only send within working hours' => '',
        'Only send outside working hours' => '',
        'Invisible to customer' => 'غير مرئي للعميل',
        'Visible to customer' => 'مرئي للعميل',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'بيئة PGP لا تعمل. الرجاء التحقق من السجل للحصول على مزيد من المعلومات!',
        'Need param Key to delete!' => 'تحتاج إلى مفتاح param للحذف!',
        'Key %s deleted!' => 'تم حذف المفتاح ٪s!',
        'Need param Key to download!' => 'تحتاج إلى مفتاح Param للتنزيل!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'No such package!' => 'لا يوجد مثل هذه الحزمة!',
        'No such file %s in package!' => 'لا يوجد مثل هذا الملف ٪s في الحزمة!',
        'No such file %s in local file system!' => 'لا يوجد مثل هذا الملف ٪s في نظام الملفات المحلي!',
        'Can\'t read %s!' => 'لا يمكن قراءة ٪s!',
        'File is OK' => 'الملف على ما يرام',
        'Package has locally modified files.' => 'تحتوي الحزمة على ملفات معدلة محليا.',
        'Package not verified by the OTOBO Team!' => 'لم يتم التحقق من الحزمة من قبل فريق OTOBO!',
        'Not Started' => 'لم يتم البدء',
        'Updated' => 'تم التحديث',
        'Already up-to-date' => 'محدث بالفعل',
        'Installed' => 'مثبت',
        'Not correctly deployed' => 'لم يتم النشر بشكل صحيح',
        'Package updated correctly' => 'تم تحديث الحزمة بشكل صحيح',
        'Package was already updated' => 'تم تحديث الحزمة بالفعل',
        'Dependency installed correctly' => 'تم تثبيت التبعية بشكل صحيح',
        'The package needs to be reinstalled' => 'يجب إعادة تثبيت الحزمة',
        'The package contains cyclic dependencies' => 'تحتوي الحزمة على تبعيات دورية',
        'Not found in on-line repositories' => 'غير موجود في المستودعات على الإنترنت',
        'Required version is higher than available' => 'الإصدار المطلوب أعلى من المتوفر',
        'Dependencies fail to upgrade or install' => 'فشلت التبعيات في الترقية أو التثبيت',
        'Package could not be installed' => 'تعذر تثبيت الحزمة',
        'Package could not be upgraded' => 'تعذر ترقية الحزمة',
        'Repository List' => 'قائمة المستودعات',
        'No packages found in selected repository. Please check log for more info!' =>
            'لم يتم العثور على أي حزم في المستودع المحدد. الرجاء التحقق من السجل للحصول على مزيد من المعلومات!',
        'Package not verified due a communication issue with verification server!' =>
            'لم يتم التحقق من الحزمة بسبب مشكلة في الاتصال مع خادم التحقق!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'يتعذر الاتصال بخادم قائمة الميزات الإضافية OTOBO!',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'يتعذر الحصول على قائمة الوظائف الإضافية لميزة OTOBO من الخادم!',
        'Can\'t get OTOBO Feature Add-on from server!' => 'يتعذر الحصول على الوظيفة الإضافية لميزة OTOBO من الخادم!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'لا يوجد عامل تصفية من هذا القبيل: ٪s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'تمت إضافة الأولوية!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'معلومات إدارة العملية من قاعدة البيانات غير متزامنة مع تكوين النظام، الرجاء مزامنة كافة العمليات.',
        'Need ExampleProcesses!' => 'الحاجة إلى عمليات نموذجية!',
        'Need ProcessID!' => 'يلزم معرف العملية!',
        'Yes (mandatory)' => 'نعم (إلزامي)',
        'Unknown Process %s!' => 'عملية غير معروفة ٪s!',
        'There was an error generating a new EntityID for this Process' =>
            'حدث خطأ أثناء إنشاء EntityID جديد لهذه العملية',
        'The StateEntityID for state Inactive does not exists' => 'StateEntityID للحالة غير نشط غير موجود',
        'There was an error creating the Process' => 'حدث خطأ أثناء إنشاء العملية',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'حدث خطأ أثناء إعداد حالة المزامنة لإدخال العملية ٪s',
        'Could not get data for ProcessID %s' => 'تعذر تعريف البيانات لمعرف العملية ٪s',
        'There was an error updating the Process' => 'حدث خطأ أثناء تحديث العملية',
        'Process: %s could not be deleted' => 'تعذر حذف العملية: ٪s',
        'There was an error synchronizing the processes.' => 'حدث خطأ أثناء مزامنة العمليات.',
        'The %s:%s is still in use' => 'لا يزال ٪s:٪s قيد الاستخدام',
        'The %s:%s has a different EntityID' => 'يحتوي ٪s:٪s على معرف كيان مختلف',
        'Could not delete %s:%s' => 'تعذر حذف ٪s:٪s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'حدث خطأ أثناء تعيين حالة مزامنة الكيان للكيان ٪s: ٪s',
        'Could not get %s' => 'تعذر الحصول على ٪s',
        'Need %s!' => 'الحاجة إلى ٪s!',
        'Process: %s is not Inactive' => 'العملية: ٪s ليست غير نشطة',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'حدث خطأ أثناء إنشاء EntityID جديد لهذا النشاط',
        'There was an error creating the Activity' => 'حدث خطأ أثناء إنشاء النشاط',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'حدث خطأ أثناء تعيين حالة مزامنة الكيان لكيان النشاط: ٪s',
        'Need ActivityID!' => 'يلزم معرف النشاط!',
        'Could not get data for ActivityID %s' => 'تعذر الحصول على بيانات ل ActivityID ٪s',
        'There was an error updating the Activity' => 'حدث خطأ أثناء تحديث النشاط',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'المعلمات المفقودة: تحتاج إلى مربع حوار النشاط والنشاط!',
        'Activity not found!' => 'لم يتم العثور على النشاط!',
        'ActivityDialog not found!' => 'لم يتم العثور على مربع حوار النشاط!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'تم بالفعل تعيين مربع حوار النشاط للنشاط. لا يمكنك تخصيص مربع حوار النشاط نفسه أكثر من مرة!',
        'Error while saving the Activity to the database!' => 'حدث خطأ أثناء حفظ النشاط إلى قاعدة البيانات!',
        'This subaction is not valid' => 'هذا الإجراء الفرعي غير صالح',
        'Edit Activity "%s"' => 'تحرير النشاط "٪s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'حدث خطأ أثناء إنشاء EntityID جديد لمربع حوار النشاط هذا',
        'There was an error creating the ActivityDialog' => 'حدث خطأ أثناء إنشاء مربع حوار النشاط',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'حدث خطأ أثناء تعيين حالة المزامنة لمربع حوار النشاط ٪s',
        'Need ActivityDialogID!' => 'تحتاج إلى ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'تعذر الحصول على بيانات ل ActivityDialogID ٪s',
        'There was an error updating the ActivityDialog' => 'حدث خطأ أثناء تحديث مربع حوار النشاط',
        'Edit Activity Dialog "%s"' => 'تحرير مربع حوار النشاط "٪s"',
        'Agent Interface' => 'واجهة الوكيل',
        'Customer Interface' => 'واجهة العميل',
        'Agent and Customer Interface' => 'واجهة العميل والوكيل',
        'Do not show Field' => 'عدم إظهار الحقل',
        'Show Field' => 'إظهار الحقل',
        'Show Field As Mandatory' => 'إظهار الحقل كإلزامي',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'تحرير المسار',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'حدث خطأ أثناء إنشاء معرف كيان جديد لهذا الانتقال',
        'There was an error creating the Transition' => 'حدث خطأ أثناء إنشاء الانتقال',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'حدث خطأ أثناء تعيين حالة مزامنة الكيان لكيان الانتقال: ٪s',
        'Need TransitionID!' => 'بحاجة إلى معرف الانتقال!',
        'Could not get data for TransitionID %s' => 'تعذر تعريف البيانات لمعرف الانتقال ٪s',
        'There was an error updating the Transition' => 'حدث خطأ أثناء تحديث الانتقال',
        'Edit Transition "%s"' => 'تحرير الانتقال "٪s"',
        'Transition validation module' => 'وحدة التحقق من صحة الانتقال',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'مطلوب معلمة تكوين صالحة واحدة على الأقل.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'حدث خطأ أثناء إنشاء معرف كيان جديد للإجراء الانتقالي هذا',
        'There was an error creating the TransitionAction' => 'حدث خطأ أثناء إنشاء الانتقال',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'حدث خطأ أثناء إعداد حالة المزامنة للإجراء الانتقالي ٪s',
        'Need TransitionActionID!' => 'بحاجة إلى معرف إجراء النقل!',
        'Could not get data for TransitionActionID %s' => 'تعذر العثور على بيانات ل ٪s معرف إجراء الانتقال',
        'There was an error updating the TransitionAction' => 'حدث خطأ أثناء تحديث الانتقال',
        'Edit Transition Action "%s"' => 'تحرير إجراء الانتقال "٪s"',
        'Error: Not all keys seem to have values or vice versa.' => 'خطأ: لا يبدو أن كل المفاتيح لها قيم أو العكس.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'تم تحديث قائمة الانتظار!',
        'Don\'t use :: in queue name!' => 'الرجاء عدم استخدام "::" ضمن اسم قائمة الانتظار!',
        'Click back and change it!' => 'يرجى العودة وتغييره!',
        '-none-' => '-بدون-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'قوائم الانتظار (بدون إجابات تلقائية)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'تغيير علاقات قائمة الانتظار للقالب',
        'Change Template Relations for Queue' => 'تغيير علاقات القوالب لقائمة الانتظار',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'إنتاجي',
        'Test' => 'إختبار',
        'Training' => 'تَدْرِيبٌ',
        'Development' => 'تَطْوِيرٌ',

        # Perl Module: Kernel/Modules/AdminResponseTemplatesStatePreselection.pm
        'Template updated!' => 'تم تحديث القالب!',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'تم تحديث الدور!',
        'Role added!' => 'تمت إضافة الدور!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'تغيير علاقات المجموعة للدور',
        'Change Role Relations for Group' => 'تغيير علاقات الأدوار للمجموعة',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'دور',
        'Change Role Relations for Agent' => 'تغيير علاقات دور الوكيل',
        'Change Agent Relations for Role' => 'تغيير علاقات الوكيل للدور',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'فضلاً فعل %s أولاً!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'بيئة S/MIME لا تعمل. الرجاء التحقق من السجل للحصول على مزيد من المعلومات!',
        'Need param Filename to delete!' => 'تحتاج المعلمة "اسم الملف" لحذف!',
        'Need param Filename to download!' => 'تحتاج المعلمة "اسم الملف" لتحميل!',
        'Needed CertFingerprint and CAFingerprint!' => 'تحتاج إلى CertFingerprint و CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'يجب أن يكون CAFingerprint مختلفا عن CertFingerprint',
        'Relation exists!' => 'العلاقة موجودة!',
        'Relation added!' => 'تمت إضافة العلاقة!',
        'Impossible to add relation!' => 'تعذر إضافة العلاقة!',
        'Relation doesn\'t exists' => 'العلاقة غير موجودة',
        'Relation deleted!' => 'تم حذف العلاقة!',
        'Impossible to delete relation!' => 'تعذر حذف العلاقة!',
        'Certificate %s could not be read!' => 'تعذر قراءة الشهادة %s!',
        'Needed Fingerprint' => 'تحتاج إلى بصمة الإصبع',
        'Handle Private Certificate Relations' => 'معالجة علاقات الشهادات الخاصة',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'أضيفت التحية!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'تم تحديث التوقيع!',
        'Signature added!' => 'تم إضافة التوقيع!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'تمت إضافة الحالة!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'تعذر قراءة الملف ٪s!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'تمت إضافة عنوان البريد الإلكتروني الخاص بالنظام!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'إعدادات غير صالحة',
        'There are no invalid settings active at this time.' => 'لا توجد حاليا إعدادات غير صالحة نشطة.',
        'You currently don\'t have any favourite settings.' => 'ليس لديك حاليا أي إعدادات مفضلة.',
        'The following settings could not be found: %s' => 'تعذر العثور على الإعدادات التالية: %s',
        'Import not allowed!' => 'الاستيراد غير مسموح به!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'تعذر استيراد تكوين النظام بسبب خطأ غير معروف، يرجى التحقق من سجلات OTOBO لمزيد من المعلومات.',
        'Category Search' => 'بحث عن الفئة',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'بعض الإعدادات المستوردة غير موجودة في الحالة الحالية للتكوين أو تعذر تحديثها. الرجاء مراجعة سجل OTOBO للحصول على مزيد من المعلومات.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            'لا يحتوي هذا النشر على تغييرات في قيم الإعداد!',
        'No DeploymentID received!' => 'لم يتم استلام معرف التكليف!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'System was unable to update setting!' => 'تعذر على النظام تحديث الإعداد!',
        'You need to enable the setting before locking!' => 'يجب تنشيط الإعداد قبل التحرير!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'لا يمكنك تحرير هذا الإعداد لأنه يتم تحريره حاليا بواسطة s% (s%).',
        'Missing setting name!' => 'اسم الإعداد مفقود!',
        'Missing ResetOptions!' => 'خيارات إعادة التعيين مفقودة!',
        'System was not able to lock the setting!' => 'لا يمكن قفل الإعداد للتحرير!',
        'Missing setting name.' => 'اسم الإعداد مفقود.',
        'Setting not found.' => 'لم يتم العثور على الإعداد.',
        'Missing Settings!' => 'إعدادات مفقودة!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationSettingHistory.pm
        'No setting name received!' => 'لم يتم تلقي اسم إعداد!',
        'Modified Version' => 'الإصدار المعدل',
        'Reset To Default' => 'إعادة التعيين إلى الافتراضي',
        'Default Version' => 'الإصدار الافتراضي',
        'No setting name or modified version id received!' => 'لم يتم تلقي اسم إعداد أو معرف إصدار معدل!',
        'Was not possible to revert the historical value!' => 'لم يكن من الممكن إعادة الضبط إلى القيمة التاريخية!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationUser.pm
        'Missing setting name or modified id!' => 'اسم إعداد مفقود أو معرف معدل!',
        'System was not able to delete the user setting values!' => 'تعذر على النظام حذف قيم إعداد المستخدم!',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'There was an error creating the System Maintenance' => 'حدث خطأ أثناء إنشاء صيانة النظام',
        'Need SystemMaintenanceID!' => 'بحاجة إلى معرف صيانة النظام!',
        'Could not get data for SystemMaintenanceID %s' => 'تعذر الحصول على بيانات ل SystemMaintenanceID %s',
        'System Maintenance was added successfully!' => 'تمت إضافة صيانة النظام بنجاح!',
        'System Maintenance was updated successfully!' => 'تم تحديث صيانة النظام بنجاح!',
        'There was an error updating the System Maintenance' => 'حدث خطأ أثناء تحديث صيانة النظام',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'تعذر حذف الإدخال %s الخاص بصيانة النظام!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'No permission to edit this template.' => '',
        'Template added!' => 'تمت إضافة القالب!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'تغيير علاقات المرفقات للقالب',
        'Change Template Relations for Attachment' => 'تغيير علاقات القوالب للمرفق',

        # Perl Module: Kernel/Modules/AdminTranslations.pm
        'Translation unmarked for deletion!' => '',
        'Error trying unmark translation for delete!' => '',
        'Translations changed!' => '',
        'No translations were changed!' => '',
        'Errors trying to change translations!' => '',
        'Translations added!' => '',
        'No translations were given to add!' => '',
        'Translation already exists!' => '',
        'Translations deployed successfuly!' => '',
        'Nothing to do!' => '',
        'Errors ocurred when trying to deploy translation. Please check system logs!' =>
            '',
        'All Items' => '',
        'Deployment Results' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'تحتاج نوع!',
        'Type added!' => 'تمت اضافة النوع!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'تم تحديث الوكيل!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'تغيير علاقات المجموعة للوكيل',
        'Change Agent Relations for Group' => 'تغيير علاقات الوكيل للمجموعة',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'الشهر',
        'Week' => 'أسبوع',
        'Day' => 'يوم',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'جميع المواعيد',
        'Appointments assigned to me' => 'المواعيد المعينة لي',
        'Showing only appointments assigned to you! Change settings' => 'سيتم عرض المواعيد المعينة لك فقط! تغيير الإعدادات',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'لم يتم العثور على موعد!',
        'Never' => 'أبداً',
        'Every Day' => 'كل يوم',
        'Every Week' => 'كل أسبوع',
        'Every Month' => 'كل شهر',
        'Every Year' => 'كل عام',
        'Custom' => 'مخصص',
        'Daily' => 'يوميا',
        'Weekly' => 'أسبوعيا',
        'Monthly' => 'شهريا',
        'Yearly' => 'سنويا',
        'every' => 'كل',
        'for %s time(s)' => 'لمدة %s من الوقت (الأوقات)',
        'until ...' => 'حتى ...',
        'for ... time(s)' => 'من أجل ... تكرار',
        'until %s' => 'حتى %s',
        'No notification' => 'لا يوجد إشعار',
        '%s minute(s) before' => '%s دقيقة (دقائق) قبل',
        '%s hour(s) before' => '%s ساعة (ساعات) قبل',
        '%s day(s) before' => '%s يوم (أيام) قبل',
        '%s week before' => '%s أسبوع (أسابيع) قبل',
        'before the appointment starts' => 'قبل بدء الموعد',
        'after the appointment has been started' => 'بعد بدء الموعد',
        'before the appointment ends' => 'قبل انتهاء الموعد',
        'after the appointment has been ended' => 'بعد إنتهاء الموعد',
        'No permission!' => 'لا يوجد إذن!',
        'Cannot delete ticket appointment!' => 'لا يمكن حذف موعد التذكرة!',
        'No permissions!' => 'لا توجد أذونات!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s أكثر',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'تاريخ العملاء',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'لم يتم إعطاء RecipientField!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'لا يوجد مثل هذا التكوين ل %s',
        'Statistic' => 'إحصائية',
        'No preferences for %s!' => 'لا توجد إعدادات ل %s!',
        'Can\'t get element data of %s!' => 'يتعذر الحصول على بيانات عنصر %s!',
        'Can\'t get filter content data of %s!' => 'يتعذر الحصول على بيانات محتوى عامل التصفية ل %s!',
        'Customer Name' => 'اسم العميل',
        'Customer User Name' => 'اسم مستخدم العميل',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'تحتاج إلى SourceObject و SourceKey!',
        'You need ro permission!' => 'أنت بحاجة إلى إذن ro!',
        'Can not delete link with %s!' => 'لا يمكن حذف الارتباط مع %s!',
        '%s Link(s) deleted successfully.' => '%s تم حذف الارتباط (الارتباطات) بنجاح.',
        'Can not create link with %s! Object already linked as %s.' => 'لا يمكن إنشاء إرتباط مع %s! تم ربط الكائن بالفعل ك %s.',
        'Can not create link with %s!' => 'لا يمكن إنشاء إرتباط مع %s!',
        '%s links added successfully.' => '%s الارتباطات المضافة بنجاح.',
        'The object %s cannot link with other object!' => 'يتعذر على الكائن %s الارتباط بكائن آخر!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'المعلمة "المجموعة" مطلوبة!',
        'This feature is not available.' => 'هذه الميزة غير متوفرة.',
        'Updated user preferences' => 'تم تحديث إعدادات المستخدم',
        'System was unable to deploy your changes.' => 'تعذر على النظام نشر التغييرات.',
        'Setting not found!' => 'لم يتم العثور على الإعداد!',
        'System was unable to reset the setting!' => 'تعذر على النظام إعادة تعيين الإعداد!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'عملية التذكرة',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'المعلمة %s مفقودة.',
        'Invalid Subaction.' => 'إجراء فرعي غير صالح.',
        'Statistic could not be imported.' => 'تعذر إستيراد الإحصائيات.',
        'Please upload a valid statistic file.' => 'الرجاء تحميل ملف إحصائي صالح.',
        'Export: Need StatID!' => 'التصدير: StatID مطلوب!',
        'Delete: Get no StatID!' => 'حذف: لم يتم تلقي StatID!',
        'Need StatID!' => 'أحتاج إلى StatID!',
        'Could not load stat.' => 'تعذر تحميل الحالة.',
        'Add New Statistic' => 'إضافة إحصائية جديدة',
        'Could not create statistic.' => 'تعذر إنشاء إحصائيات.',
        'Run: Get no %s!' => 'تشغيل: لم يتم تلقي %s!',

        # Perl Module: Kernel/Modules/AgentStatisticsReports.pm
        'Got no %s!' => '%s غير موجودة!',
        'Add New Statistics Report' => 'إضافة تقرير إحصائيات جديد',
        'This name is already in use, please choose a different one.' => 'هذا الاسم قيد الاستخدام بالفعل، الرجاء إختيار اسم آخر.',
        'Could not create report.' => 'تعذر إنشاء تقرير.',
        'Need StatsReportID!' => 'مطلوب StatsReportID!',
        'Edit Statistics Report' => 'تحرير تقرير الإحصائيات',
        'Could not find report.' => 'تعذر العثور على التقرير.',
        'Please provide a valid cron entry.' => 'يرجى توفير إدخال cron صالح.',
        'Could not update report.' => 'تعذر تحديث التقرير.',
        'View Statistics Report' => 'عرض تقرير الإحصائيات',
        'Delete: Got no StatsReportID!' => 'حذف: لم يتم الحصول على StatsReportID!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'لم يتم إعطاء TicketID!',
        'Loading draft failed!' => 'فشل تحميل المسودة!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'عذرا، يجب أن تكون مالك التذكرة لتنفيذ هذا الإجراء.',
        'Please change the owner first.' => 'الرجاء تغيير المالك أولا.',
        'FormDraft functionality disabled!' => 'لم يتم تنشيط وظيفة المسودة!',
        'Draft name is required!' => 'اسم المسودة مطلوب!',
        'FormDraft name %s is already in use!' => 'تم تعيين الاسم %s بالفعل!',
        'Could not perform validation on field %s!' => 'تعذر إجراء التحقق من الصحة على الحقل %s!',
        'No subject' => 'لا يوجد عنوان',
        'Could not delete draft!' => 'تعذر حذف المسودة!',
        'Previous Owner' => 'المالك السابق',
        'wrote' => 'كتب',
        'Message from' => 'رسالة من',
        'End message' => 'نهاية الرسالة',

        # Perl Module: Kernel/Modules/AgentTicketArticleEdit.pm
        'No ArticleID is given!' => 'لا يوجد ArticleID!',

        # Perl Module: Kernel/Modules/AgentTicketArticleStatus.pm
        'Can\'t set this Ticket option, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s مطلوب!',
        'Plain article not found for article %s!' => 'لم يتم العثور على نسخة نصية فقط للمقالة %s!',
        'Article does not belong to ticket %s!' => 'لا تنتمي المقالة إلى التذكرة %s!',
        'Can\'t bounce email!' => 'لا يمكن رفض البريد الإلكتروني!',
        'Can\'t send email!' => 'لا يمكن إرسال البريد الإلكتروني!',
        'Wrong Subaction!' => 'إجراء فرعي غير صحيح!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'لا يمكن قفل التذاكر، لا يتم إعطاء TicketIDs!',
        'Ticket (%s) is not unlocked!' => 'لم يتم إلغاء تأمين التذكرة (%s)!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'تم تجاهل التذاكر التالية لأنها مؤمنة بواسطة وكيل آخر أو ليس لديك حق الوصول للكتابة إلى التذاكر: %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'تم تجاهل التذكرة التالية لأنها مؤمنة بواسطة عميل آخر أو ليس لديك حق الوصول للكتابة إلى التذكرة: %s.',
        'You need to select at least one ticket.' => 'يجب تحديد تذكرة واحدة على الأقل.',
        'Bulk feature is not enabled!' => 'لم يتم تنشيط ميزة معالجة الدفعات!',
        'No selectable TicketID is given!' => 'لم يتم توفير TicketID قابل للتحديد!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'إما أنك لم تقم بتحديد تذكرة أو التذاكر فقط التي تم تأمينها بواسطة وكلاء آخرين.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'تم تجاهل التذاكر التالية لأنها مؤمنة بواسطة وكيل آخر أو ليس لديك حق الوصول للكتابة إلى هذه التذاكر: %s.',
        'The following tickets were locked: %s.' => 'تم تأمين التذاكر التالية: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            'سيكون موضوع المقالة فارغا إذا كان الموضوع يحتوي على Ticket-Hook فقط!',
        'Address %s replaced with registered customer address.' => 'تم إستبدال العنوان %s بعنوان عميل مسجل.',
        'Customer user automatically added in Cc.' => 'تمت إضافة مستخدم العميل تلقائيا في Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'البطاقة "%s" أنشئت!',
        'No Subaction!' => 'لا يوجد إجراء فرعي!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'لم تحصل على TicketID!',
        'System Error!' => 'خطأ في النظام!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'الأسبوع القادم',
        'Ticket Escalation View' => 'طريقة عرض تصعيد التذكرة',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'تعذر العثور على المقالة %s!',
        'Forwarded message from' => 'رسالة تمت إعادة توجيهها من',
        'End forwarded message' => 'نهاية الرسالة المعاد توجيهها',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'لا يمكن إظهار السجل، لم يتم استلام TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'لا يمكن تأمين التذكرة، لا يتم إعطاء TicketID!',
        'Sorry, the current owner is %s!' => 'عذرا، المالك الحالي هو %s!',
        'Please become the owner first.' => 'من فضلك كن المالك أولا.',
        'Ticket (ID=%s) is locked by %s!' => 'تم تأمين التذكرة (ID=%s) بواسطة %s!',
        'Change the owner!' => 'تغيير المالك!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'مقالة جديدة',
        'Pending' => 'تحت الإنتظار',
        'Reminder Reached' => 'تم الوصول إلى التذكير',
        'My Locked Tickets' => 'تذاكري المقفلة',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'لا يمكن دمج التذكرة مع نفسها!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'تحتاج إلى أذونات النقل!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'الدردشة غير نشطة.',
        'No permission.' => 'لا يوجد إذن.',
        '%s has left the chat.' => '%s غادر المحادثة.',
        'This chat has been closed and will be removed in %s hours.' => 'تم إغلاق هذه المحادثة وسيتم إزالتها خلال %s ساعة/ساعات.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'تم تأمين التذكرة.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'لا يوجد ArticleID!',
        'This is not an email article.' => 'هذه ليست مقالة بريد إلكتروني.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'لا يمكن قراءة مقال النص العادي. قد لا يكون إصدار النص العادي موجودًا. الرجاء قراءة الرسالة الخلفية.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'بحاجة إلى TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'تعذر العثور على ActivityDialogEntityID %s!',
        'No Process configured!' => 'لم يتم تكوين أي عملية!',
        'The selected process is invalid!' => 'العلملية التي تم إختيارها غير صحيحة!',
        'Process %s is invalid!' => 'العملية %s غير صالحة!',
        'Subaction is invalid!' => 'الإجراء الفرعي غير صالح!',
        'Parameter %s is missing in %s.' => 'المعلمة %s مفقودة في %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'لا يوجد مربع حوار نشاط ل %s المحدد في _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'لم يتم الحصول على Start ActivityEntityID أو Start ActivityDialogEntityID للعملية: %s في _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'تعذر الحصول على تذكرة ل TicketID: %s في _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'تعذر تعريف ActivityEntityID. حقل ديناميكي أو تكوين غير صحيح!',
        'Process::Default%s Config Value missing!' => 'العملية: القيمة الافتراضية%s للتكوين مفقودة!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'لم يتم الحصول على ProcessEntityID أو TicketID و ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'يتعذر الحصول على StartActivityDialog لمعرف ProcessEntityID %s!',
        'Can\'t get Ticket "%s"!' => 'لا يمكن الحصول على تذكرة "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'يتعذر الحصول على ProcessEntityID أو ActivityEntityID للتذكرة "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'يتعذر العثور على تكوين النشاط ل "ActivityEntityID "%s!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'يتعذر العثور على تكوين مربع حوار النشاط ل ActivityDialogEntityID %s!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'لا يمكن الحصول على بيانات للحقل "%s" في مربع حوار النشاط "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'لا يمكن استخدام وقت الانتظار إلا إذا تم تكوين الحالة أو معرّف الحالة لمربع حوار النشاط. مربع حوار النشاط: %s!',
        'Pending Date' => 'انتظر حتى',
        'for pending* states' => 'حالة الإنتظار*',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID مفقود!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'تعذر تحديد تكوين ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => 'تعذر إستخدام CustomerID كحقل غير مرئي.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'ProcessEntityID مفقود، الرجاء التحقق من ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'لم يتم تكوين StartActivityDialog أو StartActivityDialog للعملية "%s"!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'لم يتم تكوين StartActivityDialog للعملية "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'تعذر تعيين معرف ProcessEntityID "%s" للتذكرة "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'تعذر تعيين ActivityEntityID "%s" على التذكرة "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'تعذر حفظ مربع حوار النشاط، معرف تذكرة غير صالح: %s!',
        'Invalid TicketID: %s!' => 'معرف التذكرة غير صالح: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'ActivityEntityID مفقود للتذكرة %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'لم تعد هذه الخطوة جزءا من نشاط العملية الحالي للتذكرة \'%s%s%s\'! قام مستخدم آخر بتغيير التذكرة في غضون ذلك. الرجاء إغلاق هذه النافذة وإعادة تحميل التذكرة.',
        'Missing ProcessEntityID in Ticket %s!' => 'ProcessEntityID مفقود للتذكرة %s!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'تعذر توفير وقت الانتظار%s لمعرّف التذكرة %s في مربع حوار النشاط "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'تكوين حقل غير صحيح في مربع حوار النشاط: لا يمكن أن تحتوي %s على القيمة 1 (= إظهار الحقل) للعرض. يرجى تغيير التكوين إلى عرض = > 0 (لا تظهر الحقل) أو عرض = > 2 (إظهار كحقل إلزامي)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'تعذر تعيين %s للتذكرة ذات المعرف "%s" في ActivityDialog"%s"!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'تعذر حفظ الحقل الديناميكي "%s" لمعرف التذكرة "%s" في مربع حوار النشاط "%s"!',
        'Default Config for Process::Default%s missing!' => 'التكوين الافتراضي ل Process::Default%s مفقود!',
        'Default Config for Process::Default%s invalid!' => 'التكوين الافتراضي ل Process::Default%s غير صالح!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'التذاكر المتوفرة',
        'including subqueues' => 'تضمين قوائم الانتظار الفرعية',
        'excluding subqueues' => 'إستثناء قوائم الانتظار الفرعية',
        'QueueView' => 'عرض قائمة الانتظار',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'تذاكر مسؤوليتي',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'آخر بحث',
        'Untitled' => 'بدون عنوان',
        'Ticket Number' => 'رقم التذكرة',
        'Ticket' => 'التذكرة',
        'printed by' => 'طبع بواسطة',
        'CustomerID (complex search)' => 'رقم العميل (بحث معقد)',
        'CustomerID (exact match)' => 'رقم العميل (مطابق تماما)',
        'Invalid Users' => 'مستخدمون غير صالحين',
        'Normal' => 'عَادِيٌّ',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'في أكثر من ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'لم يتم تمكين الميزة!',
        'Service View' => 'عرض حسب الخدمات',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'عرض حسب الحالة',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'التذاكر المرصودة لي',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'الميزة غير نشطة',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'تم حذف الارتباط',
        'Ticket Locked' => 'التذكرة مقفلة',
        'Pending Time Set' => 'تعيين وقت الانتظار',
        'Dynamic Field Updated' => 'تم تحديث الحقل الديناميكي',
        'Outgoing Email (internal)' => 'البريد الإلكتروني الصادر (داخلي)',
        'Ticket Created' => 'تم إنشاء التذكرة',
        'Type Updated' => 'تم تحديث النوع',
        'Escalation Update Time In Effect' => 'تم تفعيل تصعيد "وقت التحديث"',
        'Escalation Update Time Stopped' => 'تم إيقاف وقت تحديث التصعيد',
        'Escalation First Response Time Stopped' => 'تم إيقاف وقت الاستجابة الأولى للتصعيد',
        'Customer Updated' => 'تم تحديث العميل',
        'Internal Chat' => 'الدردشة (داخلية)',
        'Automatic Follow-Up Sent' => 'تم إرسال الاستعلام التلقائي',
        'Note Added' => 'تمت إضافة الملاحظة',
        'Note Added (Customer)' => 'تمت إضافة الملاحظة (العميل)',
        'SMS Added' => 'تم إضافة رسائل SMS',
        'SMS Added (Customer)' => 'SMS المضافة (العميل)',
        'State Updated' => 'تم تحديث الحالة',
        'Outgoing Answer' => 'إجابة صادرة',
        'Service Updated' => 'تم تحديث الخدمة',
        'Link Added' => 'تمت إضافة الارتباط',
        'Incoming Customer Email' => 'البريد الإلكتروني الوارد (العميل)',
        'Incoming Web Request' => 'طلب ويب وارد',
        'Priority Updated' => 'تم تحديث الأولوية',
        'Ticket Unlocked' => 'تم إلغاء تأمين التذكرة',
        'Outgoing Email' => 'البريد الإلكتروني الصادر',
        'Title Updated' => 'تم تحديث العنوان',
        'Ticket Merged' => 'تم دمج التذكرة',
        'Outgoing Phone Call' => 'مكالمة هاتفية صادرة',
        'Forwarded Message' => 'رسالة تمت إعادة توجيهها',
        'Removed User Subscription' => 'تمت إزالة اشتراك المستخدم',
        'Time Accounted' => 'الوقت المحسوب',
        'Incoming Phone Call' => 'مكالمة هاتفية واردة',
        'System Request.' => 'طلب النظام.',
        'Incoming Follow-Up' => 'استفسار وارد',
        'Automatic Reply Sent' => 'تم إرسال الرد التلقائي',
        'Automatic Reject Sent' => 'تم إرسال الرفض التلقائي',
        'Escalation Solution Time In Effect' => 'التصعيد "وقت الحل" نشط',
        'Escalation Solution Time Stopped' => 'توقف التصعيد في وقت الحل',
        'Escalation Response Time In Effect' => 'التصعيد في وقت الاستجابة نشط',
        'Escalation Response Time Stopped' => 'توقف التصعيد في وقت الاستجابة',
        'SLA Updated' => 'تم تحديث إتفاقية مستوى الخدمة',
        'External Chat' => 'الدردشة (خارجية)',
        'Queue Changed' => 'تم تغيير قائمة الانتظار',
        'Notification Was Sent' => 'تم إرسال الإخطار',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'هذه التذكرة غير موجودة أو ليس لديك الإذن للوصول إلى هذه التذكرة في حالتها الحالية.',
        'Missing FormDraftID!' => 'FormDraftID مفقود!',
        'Can\'t get for ArticleID %s!' => 'تعذر الحصول على معرّف العنصر %s!',
        'Article filter settings were saved.' => 'تم حفظ إعدادات عامل تصفية المقالات.',
        'Event type filter settings were saved.' => 'تم حفظ إعدادات عامل تصفية نوع الحدث.',
        'Forward article via mail' => 'إعادة توجيه المقالة عبر البريد الإلكتروني',
        'Forward' => 'إعادة توجيه',
        'Fields with no group' => 'حقول بدون مجموعة',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'تعذر فتح المقالة! ربما يكون على صفحة مقالة أخرى؟',
        'Show one article' => 'إظهار مقالة واحدة',
        'Show all articles' => 'إظهار كافة المقالات',
        'Show Ticket Timeline View' => 'عرض الجدول الزمني للتذكرة',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'FormID مفقود.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'خطأ: تعذر حذف الملف بشكل صحيح. الرجاء الاتصال بالمسؤول (مفقود FileID).',

        # Perl Module: Kernel/Modules/BasePassword.pm
        'Can`t remove SessionID.' => 'لا يمكن إزالة SessionID.',

        # Perl Module: Kernel/Modules/CustomerDashboardCommon.pm
        'Registration for tile %s of CustomerDashboard is invalid! Either Module or Template needed.' =>
            'تعذر تسجيل المربع %s في لوحة معلومات العميل! الوحدة النمطية أو القالب مفقود.',
        'Registration for tile %s of CustomerDashboard is invalid! Order needs to be a unique number.' =>
            'التسجيل في المربع %s من لوحة معلومات العميل غير صالح! يجب أن يكون الطلب رقمًا فريدًا.',

        # Perl Module: Kernel/Modules/CustomerGenericContent.pm
        'Need Key!' => 'بحاجة الى مفتاح!',
        'Invalid Key!' => 'مفتاح غير صالح!',
        'Failed to load Content!' => 'فشل تحميل المحتوى!',
        'Destination unknown.' => 'الوجهة غير معروفة.',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'مطلوب معرف المقالة!',
        'No TicketID for ArticleID (%s)!' => 'لا يوجد معرف تذكرة لمعرف المقالة (%s)!',
        'HTML body attachment is missing!' => 'مرفق نص HTML مفقود!',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'يلزم وجود معرف الملف ومعرف المقالة!',
        'No such attachment (%s)!' => 'لم يتم العثور على المرفق (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'تحقق من إعدادات التكوين ل‮‮ ‫‏‎%s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'تحقق من إعدادات التكوين ل ‏‎ %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            'ليس لديك أذونات كافية لإنشاء بطاقة في قائمة الانتظار الافتراضية.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'تحتاج إلى معرف العميل!',
        'My Tickets' => 'تذاكري',
        'Company Tickets' => 'تذاكر الشركة',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'اسم العميل',
        'Created within the last' => 'تم إنشاؤه في آخر',
        'Created more than ... ago' => 'تم إنشاؤه قبل أكثر من ...',
        'Please remove the following words because they cannot be used for the search:' =>
            'الرجاء إزالة الكلمات التالية لأنه لا يمكن إستخدامها للبحث:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Could not load process module.' => 'تعذر تحميل وحدة العملية.',
        'Can\'t reopen ticket, not possible in this queue!' => 'تعذر إعادة فتح التذكرة. غير ممكن في قائمة الانتظار هذه!',
        'Create a new ticket!' => 'إنشاء تذكرة جديدة!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'الوضع الآمن نشط!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'إذا كنت ترغب في إعادة تشغيل برنامج التثبيت، فقم بتعطيل الوضع الآمن "SecureMode" في إعدادات التكوين "SysConfig".',
        'Directory "%s" doesn\'t exist!' => 'الدليل ‎"%s"‎ غير موجود!',
        'Configure "Home" in Kernel/Config.pm first!' => 'قم أولا بتكوين "الصفحة الرئيسية" في Kernel/Config.pm!',
        'File "%s/Kernel/Config.pm" not found!' => 'تعذر العثور على الملف ‎"%s/Kernel/Config.pm"‎!',
        'Directory "%s" not found!' => 'الدليل "‎‎%s" غير موجود!',
        'Install OTOBO' => 'تثبيت OTOBO',
        'Intro' => 'مقدمة',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm غير قابل للكتابة!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'إذا كنت ترغب في إستخدام المثبت، فتأكد من أن مستخدم خادم الويب قابل للكتابة على Kernel/Config.pm!',
        'Database Selection' => 'اختيار قاعدة البيانات',
        'Unknown Check!' => 'فحص غير معروف!',
        'The check "%s" doesn\'t exist!' => 'التحقق "‎%s" غير موجود!',
        'Enter the password for the database user.' => 'ادخل كلمة المرور لمستخدم قاعدة البيانات.',
        'Configure MySQL' => 'تكوين MySQL',
        'Database %s' => 'قاعدة البيانات ‎%s',
        'Enter the password for the administrative database user.' => 'ادخل كلمة المرور المستخدم المسؤول لقاعدة البيانات.',
        'Configure PostgreSQL' => 'تكوين PostgreSQL',
        'Configure Oracle' => 'تكوين Oracle',
        'Unknown database type "%s".' => 'نوع قاعدة البيانات غير معروف "‎%s".',
        'Please go back.' => 'من فضلك ارجع.',
        'Create Database' => 'إنشاء قاعدة بيانات',
        'Install OTOBO - Error' => 'تثبيت OTOBO - خطأ',
        'File "%s/%s.xml" not found!' => 'لم يتم العثور على الملف "‎%s/%s.xml"!',
        'Contact your Admin!' => 'اتصل بالمسؤول!',
        'Execution of SQL statement failed: ' => 'فشل تنفيذ جملة SQL: ',
        'https' => 'https',
        'http' => 'http',
        'System Settings' => 'إعدادات النظام',
        'Syslog' => 'سجل النظام (Syslog)',
        'Configure Mail' => 'ضبط اعدادات البريد الإلكتروني',
        'Mail Configuration' => 'اعدادات البريد الإلكتروني',
        'Unknown Subaction %s!' => 'إجراء فرعي غير معروف ‎%s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'يتعذر الاتصال بقاعدة البيانات، لم يتم تثبيت وحدة Perl النمطية ‎DBD::%s!',
        'Can\'t connect to database, read comment!' => 'يتعذر الاتصال بقاعدة البيانات، الرجاء قراءة الملاحظة!',
        'Database already contains data - it should be empty!' => 'تحتوي قاعدة البيانات بالفعل على بيانات، على الرغم من أنها يجب أن تكون فارغة!',
        'Error: database version requirement not satisfied. Have version: %s Want version: %s' =>
            '',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'خطأ: الرجاء التأكد من قبول قاعدة البيانات للحزم التي يزيد حجمها عن ‎%s ميغابايت (تقبل حاليا الحزم حتى ‎%s ميغابايت فقط). الرجاء تعديل إعداد max_allowed_packet لقاعدة البيانات لتجنب الأخطاء.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'خطأ: الرجاء تعيين قيمة INNODB_log_file_size في قاعدة البيانات إلى ‎%s ميغابايت على الأقل (الحالي: ‎%s ميغابايت، مستحسن: ‎%s ميغابايت). لمزيد من المعلومات، الرجاء إلقاء نظرة على ‎%s.',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            'إذا كنت تريد تشغيل أداة الترحيل MigrateFromOTRS مرة أخرى، فقم بتعطيل الوضع الآمن "SecureMode" في إعدادات التكوين (SysConfig).',
        'OTRS to OTOBO migration' => 'ترحيل OTRS إلى OTOBO',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'لا ‎%s!',
        'No such user!' => 'لم يتم العثور على مستخدم!',
        'Invalid calendar!' => 'تقويم غير صالح!',
        'Invalid URL!' => 'عنوان URL غير صحيح!',
        'There was an error exporting the calendar!' => 'حدث خطأ أثناء تصدير التقويم!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'تحتاج التكوين Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'فشلت المصادقة من ‎%s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'دردشة',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleDelete.pm
        'Delete this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleEdit.pm
        'Edit this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleRestore.pm
        'Restore this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'إعادة توجيه العناصر عن طريق البريد الإلكتروني',
        'Bounce' => 'إعادة توجيه',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'الرد على الكل',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'إعادة إرسال هذه المقالة',
        'Resend' => 'إرسال مرة أخرى',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'عرض سجل الرسائل لهذا العنصر',
        'Message Log' => 'سجل الرسائل',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'الرد على الملاحظة',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'تقسيم هذه المقالة',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'عرض مصدر هذه المقالة',
        'Plain Format' => 'طريقة عرض غير منسقة',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'طباعة هذه المقالة',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at hello@otobo.io' => 'اكتب لنا على hello@otobo.io',
        'Get Help' => 'الحصول على المساعدة',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkArticleSeenUnseen.pm
        'Mark article as unseen' => '',
        'Mark as unseen' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'حَدَّدَ',
        'Unmark' => 'أحذف التحديد',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'إعادة تثبيت الحزمة',
        'Re-install' => 'إعادة التثبيت',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'مشفر',
        'Sent message encrypted to recipient!' => 'إرسال رسالة مشفرة إلى المستلم!',
        'Signed' => 'وَقَّعَ',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'تم العثور على رأس ‏"PGP SIGNED MESSAGE"، ولكن غير صالح!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        'Internal error during verification!' => 'خطأ داخلي أثناء التحقق!',
        'Impossible to decrypt: private key not found!' => 'تعذر فك التشفير: لم يتم العثور على المفتاح الخاص!',
        'Impossible to decrypt: private key for email was not found!' => 'تعذر فك التشفير: لم يتم العثور على المفتاح الخاص للبريد الإلكتروني!',
        'Successful decryption' => 'فك التشفير بنجاح',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'لا تتوفر مفاتيح تشفير للعناوين: ‏\'‎%s\'. ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'لا توجد مفاتيح تشفير محددة للعناوين: ‏\'‎%s\'. ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'يتعذر إستخدام مفاتيح التشفير المنتهية الصلاحية للعناوين: \'‎%s\'. ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'يتعذر إستخدام مفاتيح التشفير الملغاة للعناوين: \'‎%s\'. ',
        'Encrypt' => 'تَشْفَير',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'سيتم إظهار المفاتيح/الشهادات فقط للمستلمين الذين لديهم أكثر من مفتاح/شهادة. سيتم تحديد أول مفتاح/شهادة تم العثور عليها مسبقا. الرجاء التأكد من تحديد الخيار الصحيح.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'أمان البريد الإلكتروني',
        'PGP sign' => 'توقيع PGP',
        'PGP sign and encrypt' => 'توقيع وتشفير PGP',
        'PGP encrypt' => 'تشفير PGP',
        'SMIME sign' => 'توقيع SMIME',
        'SMIME sign and encrypt' => 'توقيع وتشفير SMIME',
        'SMIME encrypt' => 'تشفير SMIME',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'لا يمكن إستخدام مفتاح التوقيع المنتهي الصلاحية: \'‎%s\'. ',
        'Cannot use revoked signing key: \'%s\'. ' => 'لا يمكن إستخدام مفتاح التوقيع الملغى: \'‎%s\'. ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'لا تتوفر مفاتيح توقيع للعناوين \'‎%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'لا توجد مفاتيح توقيع محددة للعناوين \'‏‎%s\'.',
        'Sign' => 'وَقَّعَ',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'سيتم إظهار المفاتيح/الشهادات فقط للمرسل الذي لديه أكثر من مفتاح/شهادة. سيتم تحديد أول مفتاح/شهادة تم العثور عليها مسبقا. الرجاء التأكد من تحديد الخيار الصحيح.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'عرض',
        'Refresh (minutes)' => 'تحديث (دقائق)',
        'off' => 'مُطْفَأٌ',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'أرقام العملاء المعروضة',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'مستخدمو العملاء المعروضون',
        'Offline' => 'غير متصل',
        'User is currently offline.' => 'المستخدم غير متصل حاليا.',
        'User is currently active.' => 'المستخدم نشط حاليا.',
        'Away' => 'غَائِبٌ',
        'User was inactive for a while.' => 'كان المستخدم غير نشط لفترة من الوقت.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'تم تعيين وقت بدء التذكرة إلى وقت ما بعد وقت الانتهاء!',

        # Perl Module: Kernel/Output/HTML/Dashboard/MyLastChangedTickets.pm
        'Shown Tickets' => 'التذاكر المعروضة',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'يتعذر الاتصال بخادم أخبار OTOBO!',
        'Can\'t get OTOBO News from server!' => 'يتعذر الحصول على أخبار OTOBO من الخادم!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'يتعذر الاتصال بخادم أخبار المنتج!',
        'Can\'t get Product News from server!' => 'يتعذر الحصول على أخبار المنتج من الخادم!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'يتعذر الاتصال ب ‎%s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Columns' => 'الأعمدة المعروضة',
        'filter not active' => 'عامل التصفية غير نشط',
        'filter active' => 'عامل تصفية نشط',
        'This ticket has no title or subject' => 'هذه التذكرة ليس لها عنوان أو موضوع',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'إحصاءات 7 أيام',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'قام المستخدم بتعيين حالته إلى "غير متوفر".',
        'Unavailable' => 'غير متوفر',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'قياسي',
        'The following tickets are not updated: %s.' => 'لم يتم تحديث التذاكر التالية: ‎%s.',
        'h' => 'ح',
        'm' => 'م',
        'd' => 'د',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'هذه التذكرة غير موجودة، أو ليس لديك أذونات للوصول إليها في حالتها الحالية. يمكنك إتخاذ أحد الإجراءات التالية:',
        'Year' => 'السنة',
        'Hours' => 'ساعات',
        'Minutes' => 'دقائق',
        'Check to activate this date' => 'حدد لتمكين هذا التاريخ',
        '%s TB' => '‎%s تيرابايت (TB)',
        '%s GB' => '‎%s غيغابايت (GB)',
        '%s MB' => '‎%s ميغابايت (MB)',
        '%s KB' => '‎%s كيلوبايت (KB)',
        '%s B' => '‎%s بايت (B)',
        'No Permission!' => 'لا توجد صلاحيات!',
        'No Permission' => 'لا توجد صلاحيات',
        'Show Tree Selection' => 'عرض الاختيار الشجري',
        'Split Quote' => 'تقسيم الاقتباس',
        'Remove Quote' => 'إزالة الاقتباس',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'مرتبط ك',
        'Search Result' => 'نتيجة البحث',
        'Linked' => 'مرتبط',
        'Bulk' => 'إجراء جمع',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'سَهْل',
        'Unread article(s) available' => 'تتوفر مقالة (مقالات) غير مقروءة',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'موعد',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'البحث في الأرشيف',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'المشغلون المتواجدون حالياً : %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'تتوفر العديد من التذاكر المتصاعدة!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'الرجاء تحديد منطقة زمنية في إعداداتك والتأكيد بالنقر فوق زر حفظ.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'العميل متصل الان : ‎%s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'صيانة النظام نشطة!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'ستبدأ فترة صيانة النظام في: ‎%s ومن المتوقع أن تتوقف في: ‎%s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO Daemon لا يعمل.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'تم تمكين "خارج المكتب"، هل تريد تعطيله؟',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'تم نشر ‎%s إعداد (إعدادات) غير صالحة. انقر هنا لإظهار إعدادات غير صالحة.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'هناك إعدادات لم يتم تشغيلها بعد. هل ترغب في بدء تشغيل الآن؟',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'يتم تحديث التكوين، يرجى التحلي بالصبر...',
        'There is an error updating the system configuration!' => 'حدث خطأ أثناء تحديث تكوين النظام!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'الرجاء عدم إستخدام حساب المستخدم المتميز في ‎%s! الرجاء إنشاء عملاء جدد واستخدامهم.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'الرجاء التأكد من إختيار أسلوب نقل واحد على الأقل للإخطارات الإلزامية.',
        'Preferences updated successfully!' => 'تم تحديث الإعدادات بنجاح!',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'الرجاء تحديد تاريخ انتهاء بعد تاريخ البدء.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'التحقق من كلمة المرور',
        'The current password is not correct. Please try again!' => 'كلمة المرور الحالية غير صحيحة. الرجاء المحاولة مرة أخرى!',
        'Please supply your new password!' => 'الرجاء تأكيد كلمة المرور الجديدة!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            'يتعذر تحديث كلمة المرور! كلمات المرور التي تم إدخالها مختلفة.',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'تم حظر كلمة المرور هذه من قبل تكوين النظام الحالي. الرجاء الاتصال بالمسؤول إذا كانت لديك أسئلة إضافية.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'يتعذر تحديث كلمة المرور. يجب أن يكون طوله ‎%s على الأقل!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'لا يمكن تحديث كلمة المرور، يجب أن تحتوي على 2 أحرف صغيرة على الأقل وحرفين كبيرة!',
        'Can\'t update password, it must contain at least 1 digit!' => 'يتعذر تحديث كلمة المرور. يجب أن يحتوي على رقم واحد على الأقل!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'يتعذر تحديث كلمة المرور. يجب أن يحتوي على حرفين على الأقل!',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            'يتعذر تحديث كلمة المرور. يجب أن تحتوي على ٣ من ٤ فئات حروف على الأقل (حروف صغيرة، حروف كبيرة، أرقام، حروف خاصة)!',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'تم تحديث المنطقة الزمنية بنجاح!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'غير فعال',
        'valid' => 'فعال',
        'No (not supported)' => 'لا (غير مدعوم)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'لم يتم تحديد فترة نسبية.',
        'The selected time period is larger than the allowed time period.' =>
            'الفترة الزمنية المحددة أكبر من الفترة الزمنية المسموح بها.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'لا يتوفر أي مقياس زمني لقيمة مقياس الوقت على المحور X المحدد حاليًا.',
        'The selected date is not valid.' => 'التاريخ المحدد غير صالح.',
        'The selected end time is before the start time.' => 'وقت الانتهاء المحدد قبل وقت البدء.',
        'There is something wrong with your time selection.' => 'الرجاء التحقق من تحديد الوقت.',
        'Please select only one element or allow modification at stat generation time.' =>
            'يرجى تحديد عنصر واحد فقط أو السماح بالتحرير في وقت إنشاء الإحصاءات.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'يرجى تحديد عنصر واحد فقط أو السماح بالتحرير في وقت إنشاء الإحصاءات.',
        'Please select one element for the X-axis.' => 'الرجاء تحديد عنصر واحد للمحور X.',
        'You can only use one time element for the Y axis.' => 'يمكنك استخدام عنصر وقت واحد فقط للمحور Y.',
        'You can only use one or two elements for the Y axis.' => 'يمكنك فقط استخدام عنصر واحد أو عنصرين للمحور Y.',
        'Please select at least one value of this field.' => 'الرجاء تحديد قيمة واحدة على الأقل في هذا الحقل.',
        'Please provide a value or allow modification at stat generation time.' =>
            'الرجاء إدخال قيمة أو السماح بالتحرير في وقت إنشاء الإحصائيات.',
        'Please select a time scale.' => 'يرجى تحديد جدول زمني.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'الفترة المحددة صغيرة جدا، الرجاء إستخدام مقياس زمني أكبر.',
        'second(s)' => 'ثانية/ثواني',
        'quarter(s)' => 'ربع (أرباع)',
        'half-year(s)' => 'نصف سنة',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'الرجاء إزالة الكلمات التالية لأنه لا يمكن إستخدامها لتقييد التذاكر: ‎%s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'إلغاء التحرير وإلغاء تأمين هذا الإعداد',
        'Reset this setting to its default value.' => 'إعادة تعيين هذا الإعداد إلى قيمته الافتراضية.',
        'Unable to load %s!' => 'يتعذر تحميل ‎%s!',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'إلغاء التأمين لإعادته إلى قائمة الانتظار',
        'Lock it to work on it' => 'قفل للتحرير',

        # Perl Module: Kernel/Output/HTML/TicketMenu/ShowHideDeletedArticles.pm
        'Hide deleted articles' => '',
        'Click to hide deleted articles' => '',
        'Show deleted articles' => '',
        'Click to show deleted articles' => '',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'إلغاء المراقبة',
        'Remove from list of watched tickets' => 'إزالة من قائمة التذاكر المراقبة',
        'Watch' => 'مُرَاقَبَةٌ',
        'Add to list of watched tickets' => 'إضافة إلى قائمة التذاكر المراقبة',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'ترتيب حسب',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'التذاكر المقفلة جديدة',
        'Locked Tickets Reminder Reached' => 'تم الوصول إلى تذكير بالتذاكر المؤمنة',
        'Locked Tickets Total' => 'إجمالي التذاكر المقفلة',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'تذاكر مسؤولة جديدة',
        'Responsible Tickets Reminder Reached' => 'تم الوصول إلى تذكير بالتذاكر المسؤولة',
        'Responsible Tickets Total' => 'إجمالي التذاكر المسؤولة',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'التذاكر المراقبة جديدة',
        'Watched Tickets Reminder Reached' => 'تم الوصول إلى تذكير التذاكر المراقبة',
        'Watched Tickets Total' => 'إجمالي التذاكر المراقبة',

        # Perl Module: Kernel/Output/PDF/StatisticsReports.pm
        '%s Report' => '‎%s تقرير',
        'Error: this graph could not be generated: %s.' => 'خطأ: تعذر إنشاء هذا الرسم البياني: ‎%s.',
        'Table of Contents' => 'جدول المحتويات',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'الحقول الديناميكية للتذكرة',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'تعذر قراءة ملف تكوين ACL. الرجاء التأكد من صحة الملف.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'لا يمكن تسجيل الدخول في الوقت الحالي نظراً لإجراء الصيانة المجدولة للنظام.',

        # Perl Module: Kernel/System/Auth/OpenIDConnect.pm
        'Authentication error. Please contact the administrator.' => '',
        'Authentication error.' => '',
        'Invalid response from the authentication server. Maybe the process took too long. Please retry once.' =>
            'إستجابة غير صالحة من خادم المصادقة. ربما استغرقت العملية وقتا طويلا. الرجاء المحاولة مرة أخرى.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Please note that the session limit is almost reached.' => 'يرجى ملاحظة أنه تم الوصول إلى الحد الأقصى للجلسة تقريبا.',
        'Session limit reached! Please try again later.' => 'تم الوصول إلى الحد الأقصى للجلسة! يرجى إعادة المحاولة لاحقا.',
        'Session per user limit reached!' => 'تم الوصول إلى الحد الأقصى للجلسة لكل مستخدم!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'الجلسة غير صالحة. يرجى تسجيل الدخول مرة أخرى.',
        'Session has timed out. Please log in again.' => 'انتهت مهلة الجلسة. يرجى تسجيل الدخول مرة أخرى.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'توقيع PGP فقط',
        'PGP encrypt only' => 'تشفير PGP فقط',
        'SMIME sign only' => 'توقيع S/MIME فقط',
        'SMIME encrypt only' => 'تشفير S/MIME فقط',
        'PGP and SMIME not enabled.' => 'لم يتم تمكين PGP و S/MIME.',
        'Skip notification delivery' => 'تخطي تسليم الإشعارات',
        'Send unsigned notification' => 'إرسال إشعار غير موقع',
        'Send unencrypted notification' => 'إرسال إشعار غير مشفر',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'مرجع خيارات التكوين',
        'This setting can not be changed.' => 'لا يمكن تغيير هذا الإعداد.',
        'This setting is not active by default.' => 'هذا الإعداد غير نشط بشكل افتراضي.',
        'This setting can not be deactivated.' => 'لا يمكن إلغاء تنشيط هذا الإعداد.',
        'This setting is not visible.' => 'هذا الإعداد غير مرئي.',
        'This setting can be overridden in the user preferences.' => 'يمكن تجاوز هذا الإعداد في إعدادات المستخدم.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'يمكن تجاوز هذا الإعداد في إعدادات المستخدم، ولكنه غير نشط بشكل افتراضي.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'مستخدم العميل "‎%s" موجود بالفعل.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'عنوان البريد الإلكتروني هذا قيد الاستخدام بالفعل لمستخدم عميل آخر.',

        # Perl Module: Kernel/System/DynamicField/Driver/Agent.pm
        'Group of the agents' => '',
        'Select the group of the agents' => '',
        'External-source key' => '',
        'When set via an external source (e.g. web service or import / export), the value will be interpreted as this attribute.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'قبل/بعد',
        'between' => 'بين',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseReference.pm
        'Referenced object type' => '',
        'Select the type of the referenced object' => '',
        'Input mode of edit field' => '',
        'Select the input mode for the edit field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseScript.pm
        'e.g. Text or Te*t' => 'على سبيل المثال، Text أو Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'تجاهل هذا الحقل.',

        # Perl Module: Kernel/System/DynamicField/Driver/CustomerCompany.pm
        'Attribute which will be searched on autocomplete' => '',
        'Select the attribute which customer companies will be searched by' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/RichText.pm
        'This field is required or' => 'هذا الحقل مطلوب أو',
        'The field content is too long!' => 'محتوى الحقل طويل جداً!',
        'Maximum size is %s characters.' => 'الحجم الأقصى %s حرف.',
        'Full %s Text' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Ticket.pm
        'Queue of the ticket' => '',
        'Select the queue of the ticket' => '',
        'Type of the ticket' => '',
        'Select the type of the ticket' => '',
        'Select the attribute which tickets will be searched by' => '',
        'Attribute which is displayed for values' => '',
        'Select the type of display' => '',

        # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
        'Column Separator' => '',
        'Tabulator (TAB)' => '',
        'Semicolon (;)' => '',
        'Colon (:)' => '',
        'Dot (.)' => '',
        'Comma (,)' => '',
        'Charset' => '',
        'Include Column Headers' => '',
        'Column' => '',

        # Perl Module: Kernel/System/ImportExport/FormatBackend/JSON.pm
        'Pretty print the exported concatenated JSON' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/CloneDB/Backend.pm
        'Sanity checks for database.' => 'التحقق من معقولية قاعدة البيانات.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOACLDeploy.pm
        'Deploy the ACL configuration.' => 'نشر تكوين ACL.',
        'Deployment completed, perfect!' => 'اكتمل النشر، تهانينا!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOAutoResponseTemplatesMigrate.pm
        'Migrate database table auto_responses.' => 'ترحيل جدول قاعدة بيانات "auto_responses".',
        'Migration failed.' => 'فشل الترحيل.',
        'Migrate database table auto_response.' => 'ترحيل جدول قاعدة بيانات "auto_response".',
        'Migration completed, perfect!' => 'اكتمل الترحيل. تهانينا!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCacheCleanup.pm
        'OTOBO Cache cleanup.' => 'مسح ذاكرة التخزين المؤقت ل OTOBO.',
        'Completed.' => 'اكتمل.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCopyFilesFromOTRS.pm
        'Need OTRSData->%s!' => 'OTRSData->‎%s المطلوب!',
        'Can\'t access OTRS Home: %s!' => 'يتعذر الوصول إلى الصفحة الرئيسية ل OTRS: ‎%s!',
        'All needed files copied and migrated, perfect!' => 'تم نسخ كافة الملفات وترحيلها. تهانينا!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBODatabaseMigrate.pm
        'Copy database.' => 'نسخ قاعدة البيانات.',
        'Skipped...' => 'تخطي ...',
        'System was unable to connect to OTRS database.' => 'تعذر على النظام الاتصال بقاعدة بيانات OTRS.',
        'System was unable to complete data transfer.' => 'تعذر على النظام إكمال نقل البيانات.',
        'Data transfer completed.' => 'اكتمل نقل البيانات.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOFrameworkVersionCheck.pm
        'Check if OTOBO version is correct.' => 'تحقق مما إذا كان إصدار OTOBO صحيحا.',
        'Check if OTOBO and OTRS connect is possible.' => 'تحقق مما إذا كان اتصال OTOBO و OTRS ممكنا.',
        'Can\'t open RELEASE file from OTRSHome: %s!' => 'يتعذر فتح ملف RELEASE في OTRSHome: ‎%s!',
        'Check if OTOBO and OTRS version is correct.' => 'تحقق مما إذا كان إصدار OTOBO و OTRS صحيحا.',
        '%s does not exist!' => '‎%s غير موجود!',
        'No OTOBO system found!' => 'لم يتم العثور على نظام OTOBO!',
        'You are trying to run this script on the wrong framework version %s!' =>
            'أنت تحاول تشغيل البرنامج النصي في الإصدار الخطأ من framework ‎%s!',
        'OTOBO Version is correct: %s.' => 'إصدار OTOBO صحيح: ‎%s.',
        'Check if OTRS version is correct.' => 'تحقق مما إذا كان إصدار OTRS صحيحا.',
        'OTRS RELEASE file %s does not exist!' => 'ملف إصدار OTRS ‎%s غير موجود!',
        'Can\'t read OTRS RELEASE file: %s' => 'يتعذر قراءة ملف إصدار OTRS: ‎%s',
        'No OTRS system found!' => 'لم يتم العثور على نظام OTRS!',
        'Unknown PRODUCT found in OTRS RELASE file: %s. Expected values are %s.' =>
            'تم العثور على منتج غير معروف في ملف OTRS RELEASE: ‎%s. القيم المتوقعة: ‎%s.',
        'OTRS Version is correct: %s.' => 'إصدار OTRS صحيح: ‎%s.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOItsmTablesMigrate.pm
        'Migrate ITSM database tables.' => 'ترحيل جداول قاعدة بيانات ITSM.',
        'Nothing to do, as the the table \'%s\' does not exist.' => 'لا شيء للقيام به، لأن الجدول \'‎%s\' غير موجود.',
        'UPDATE of the table \'%s\' failed.' => 'فشل تحديث الجدول \'‎%s\'.',
        'Migration completed.' => 'اكتمل الترحيل.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => 'ترحيل إعدادات التكوين.',
        'An error occured during SysConfig data migration or no configuration exists.' =>
            'حدث خطأ أثناء ترحيل بيانات SysConfig أو لا يوجد تكوين.',
        'An error occured during SysConfig migration when writing XML to DB.' =>
            'حدث خطأ أثناء ترحيل SysConfig عند كتابة XML إلى DB.',
        'SysConfig data migration completed.' => 'اكتمل ترحيل بيانات SysConfig.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateWebServiceConfiguration.pm
        'Migrate web service configuration.' => 'ترحيل تكوين خدمة ويب.',
        'Failed - see the log!' => 'فشل - راجع السجل!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBONotificationMigrate.pm
        'Migrate database table notification.' => 'ترحيل جدول قاعدة البيانات "إخطار".',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSConnectionCheck.pm
        'Can\'t open Kernel/Config.pm file from OTRSHome: %s!' => 'يتعذر فتح ملف Kernel/Config.pm من OTRSHome: ‎%s!',
        'Check if Kernel/Config.pm exists in OTOBO home.' => 'تحقق مما إذا كان هناك ملف Kernel/Config.pm في OTOBO Home.',
        'Kernel/Config.pm exists in OTOBO home' => 'Kernel/Config.pm متوفر في OTOBO',
        'Check if we are able to connect to OTRS Home.' => 'يتحقق مما إذا كان يمكن إنشاء اتصال ب OTRS Home.',
        'Can\'t connect to OTRS file directory.' => 'يتعذر الاتصال بدليل ملفات OTRS.',
        'Connect to OTRS file directory is possible.' => 'الاتصال بدليل ملف OTRS ممكن.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSDBCheck.pm
        'Try database connect and sanity checks.' => 'جرب الاتصال بقاعدة البيانات وفحوصات السلامة.',
        'Could not create database object.' => 'تعذر إنشاء كائن قاعدة البيانات.',
        'Database connect and sanity checks completed.' => 'تم الانتهاء من الاتصال بقاعدة البيانات وفحوصات السلامة.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageCheck.pm
        'Check if all necessary packages are installed.' => 'تحقق مما إذا كانت جميع الحزم الضرورية مثبتة.',
        'The following packages are only installed in OTRS:' => 'يتم تثبيت الحزم التالية فقط في OTRS:',
        'Please install (or uninstall) the packages before migration. If a package doesn\'t exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution.' =>
            'يرجى تثبيت (أو إلغاء تثبيت) الحزم قبل الترحيل. إذا لم تكن الحزمة متاحة بعد ل OTOBO، فيرجى الاتصال بفريق OTOBO عبر bugs\@otobo.org. سنجد حلا.',
        'The same packages are installed on both systems, perfect!' => 'يتم تثبيت نفس الحزم على كلا النظامين ، جيد جدا!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPackageSpecifics.pm
        'Package specific tasks' => 'المهام المتعلقة بالحزمة',
        'Done -' => 'اكتمل -',
        'Failed at -' => 'فشل في -',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => 'تحقق مما إذا كانت جميع وحدات Perl المطلوبة قد تم تثبيتها.',
        '%s script does not exist.' => '‎%s البرنامج النصي غير موجود.',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            'هناك وحدة أو أكثر من وحدات Perl المطلوبة مفقودة. الرجاء تثبيتها كما هو موصى به، ثم تشغيل البرنامج النصي للترحيل مرة أخرى.',
        'All required Perl modules have been installed, perfect!' => 'لقد تم تثبيت جميع وحدات Perl المطلوبة، مُمْتاز!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPostmasterFilterMigrate.pm
        'Migrate postmaster filter.' => 'ترحيل عامل تصفية مسؤول البريد.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => 'نشر تكوين إدارة العملية.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => 'ترحيل جدول قاعدة بيانات "response_template".',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => 'ترحيل جدول قاعدة البيانات "التحية" ("salutation").',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => 'ترحيل جدول قاعدة بيانات "signature".',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOStatsMigrate.pm
        'Migrate statistics.' => 'ترحيل الإحصائيات.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'تعذر قراءة ملف تكوين الإشعار. يرجى التأكد من صحة الملف.',
        'Imported notification has body text with more than 4000 characters.' =>
            'يحتوي الإخطار المدرج على نص أساسي يتكون من أكثر من 4000 حرف.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'غير مثبت',
        'installed' => 'تم التثبيت بنجاح',
        'Unable to parse repository index document.' => 'يتعذر قراءة مستند الفهرس الخاص بالدليل.',
        'File is not installed!' => 'لم يتم تثبيت الملف!',
        'File is different!' => 'الملف مختلف!',
        'Can\'t read file!' => 'لا يمكن قراءة الملف!',
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '<p>يمكن للحزم الإضافية تحسين OTOBO مع الكثير من الميزات المفيدة. ومع ذلك ، تأكد من أن أصل هذه الحزمة جدير بالثقة ، حيث يمكنه تعديل OTOBO بأي طريقة ممكنة. </p>',
        'Package not verified by the OTOBO community!' => 'لم يتم التحقق من الحزمة من قبل مجتمع OTOBO!',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "Package::AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p> يتم تعطيل تثبيت الحزم التي لم يتم التحقق منها افتراضيًا. يمكنك تمكينهم باستخدام إعداد "Package::AllowNotVerifiedPackages" في تكوين النظام. </p>',
        'Verification not possible (e.g. no internet connection)!' => 'التحقق غير ممكن (على سبيل المثال لا يوجد اتصال بالإنترنت)!',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'تم استيراد العملية "‎%s" وجميع بياناتها بنجاح.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'غير نشط',
        'FadeAway' => 'أخفَى',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'لايمكن الإتصال بخادم التسجيل. الرجاء المحاولة لاحقاً.',
        'No content received from registration server. Please try again later.' =>
            'لم يتم استلام أية محتوى من خادم التسجيل. الرجاء المحاولة لاحقاً.',
        'Can\'t get Token from sever' => 'لا يمكن الحصول على رمز مميز (Token) من الخادم',
        'Username and password do not match. Please try again.' => 'ليس هناك تطابق بين إسم المستخدم وكلمة المرور. الرجاء المحاولة مرة أخرى.',
        'Problems processing server result. Please try again later.' => 'يوجد مشاكل في معالجة نتائج الخادم. الرجاء المحاولة لاحقاً.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'إجماليّ',
        'week' => 'أسبوع',
        'quarter' => 'ربع سنوي',
        'half-year' => 'نصف سنوي',

        # Perl Module: Kernel/System/Stats/Dynamic/ArticleList.pm
        'unlimited' => 'غير محدود',
        'Attributes to be printed' => 'السمات المراد طباعتها',
        'Sort sequence' => 'تسلسل الفرز',
        'State Historic' => 'تاريخ الحالة',
        'State Type' => 'نوع الحالة',
        'State Type Historic' => 'تاريخ نوع الحالة',
        'Created Priority' => 'تم إنشاؤها بأولوية',
        'Created State' => 'تم إنشاؤه بالحالة',
        'Create Time' => 'وقت الإنشاء',
        'Article Create Time' => '',
        'Pending until time' => 'فترة الانتظار',
        'Close Time' => 'وقت إقفال البطاقة',
        'Historic Time Range' => 'النطاق الزمني التاريخي',
        'Escalation' => 'التصعيد',
        'Escalation - First Response Time' => 'التصعيد - وقت الاستجابة الأول',
        'Escalation - Update Time' => 'التصعيد - وقت التحديث',
        'Escalation - Solution Time' => 'التصعيد - وقت الحل',
        'Agent/Owner' => 'الوكيل/المالك',
        'Created by Agent/Owner' => 'تم الإنشاء بواسطة الوكيل/المالك',
        'Assigned to Customer User Login' => 'مخصص لتسجيل دخول المستخدم للعميل',
        'Last Changed' => 'آخر تعديل',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'تقييم بواسطة',
        'Ticket/Article Accounted Time' => 'التذكرة/العنصر - الوقت المحسوب',
        'Ticket Create Time' => 'وقت إنشاء التذكرة',
        'Ticket Close Time' => 'وقت إغلاق التذكرة',
        'Accounted time by Agent' => 'الوقت المعين من قبل الوكيل',
        'Total Time' => 'الوقت الإجمالي',
        'Ticket Average' => 'متوسط الوقت لكل تذكرة',
        'Ticket Min Time' => 'الحد الأدنى لوقت التذكرة',
        'Ticket Max Time' => 'الحد الأقصى لوقت التذكرة',
        'Number of Tickets' => 'عدد التذاكر',
        'Article Average' => 'متوسط الوقت لكل عنصر(مقالة)',
        'Article Min Time' => 'الحد الأدنى لوقت المقالة',
        'Article Max Time' => 'الحد الأقصى لوقت المقالة',
        'Number of Articles' => 'عدد المقالات',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'متوسط وقت الحل',
        'Solution Min Time' => 'الحد الأدنى من وقت الحل',
        'Solution Max Time' => 'الحد الأقصى لوقت الحل',
        'Solution Average (affected by escalation configuration)' => 'متوسط وقت الحل (يتأثر بتكوين التصعيد)',
        'Solution Min Time (affected by escalation configuration)' => 'الحد الأدنى لوقت الحل (يتأثر بتكوين التصعيد)',
        'Solution Max Time (affected by escalation configuration)' => 'الحد الأقصى لوقت الحل (يتأثر بتكوين التصعيد)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'متوسط وقت عمل الحل (يتأثر بتكوين التصعيد)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'الحد الأدنى لوقت عمل الحل (يتأثر بتكوين التصعيد)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'الحد الأقصى لوقت عمل الحل (يتأثر بتكوين التصعيد)',
        'First Response Average (affected by escalation configuration)' =>
            'متوسط وقت الاستجابة الأولية (يتأثر بتكوين التصعيد)',
        'First Response Min Time (affected by escalation configuration)' =>
            'الحد الأدنى لوقت الاستجابة الأولية (يتأثر بتكوين التصعيد)',
        'First Response Max Time (affected by escalation configuration)' =>
            'الحد الأقصى لوقت الاستجابة الأولية (يتأثر بتكوين التصعيد)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'متوسط وقت الاستجابة الأولية (يتأثر بتكوين التصعيد)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'الحد الأدنى لوقت العمل للاستجابة الأولى (متأثر بتكوين التصعيد)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'الحد الأقصى لوقت العمل للاستجابة الأولى (متأثر بتكوين التصعيد)',
        'Number of Tickets (affected by escalation configuration)' => 'عدد التذاكر (متأثرة بتكوين التصعيد)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'أيام',
        'Queues / Tickets' => 'قوائم الانتظار / التذاكر',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'جداول قديمة',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'تم العثور على جداول قديمة في قاعدة البيانات. يمكن إزالتها إذا كانت فارغة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'فحص وجود الجداول',
        'Internal Error: Could not open file.' => 'خطأ داخلي: تعذر فتح الملف.',
        'Table Check' => 'التحقق من حالة الجدول',
        'Internal Error: Could not read file.' => 'خطأ داخلي: تعذر قراءة الملف.',
        'Tables found which are not present in the database.' => 'توجد جداول مفقودة من قاعدة البيانات.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'حجم قاعدة البيانات',
        'Could not determine database size.' => 'تعذر تحديد حجم قاعدة البيانات.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'إصدار قاعدة البيانات',
        'Could not determine database version.' => 'تعذر تحديد إصدار قاعدة البيانات.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'مجموعة معلومات اتصال العميل',
        'Setting character_set_client needs to be utf8.' => 'يجب أن يكون \'utf8\' تعيين charter_set_client.',
        'Server Database Charset' => 'مجموعة أحرف خادم قاعدة البيانات',
        'Please convert your database to the character set \'utf8mb4\'.' =>
            'الرجاء تحويل قاعدة البيانات إلى مجموعة الأحرف \'utf8mb4\'.',
        'Table Charset' => 'مجموعة أحرف الجدول',
        'There were tables found which do not have \'utf8mb4\' as charset.' =>
            'تم العثور على الجداول باستخدام مجموعة أحرف أخرى غير \'utf8mb4\'.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'حجم ملف سجل InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'يجب ألا يقل حجم الإعداد innodb_log_file_size عن 256 ميغابايت.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'قيم افتراضية غير صالحة',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            'تم العثور على جداول ذات قيم افتراضية غير صالحة. لإصلاحها تلقائيا ، يرجى تنفيذ الأمر التالي: bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'الحد الأقصى لحجم الطلب',
        'The setting \'max_allowed_packet\' must be 64 MB or higher.' => 'اضبط "max_allowed_packet" على 64 ميغابايت أو أكثر.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'حجم ذاكرة التخزين المؤقت للاستعلام (للطلب)',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'يجب استخدام إعداد query_cache_size (أكثر من 10 ميغابايت ولكن ليس أكثر من 512 ميغابايت).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'محرك التخزين الافتراضي',
        'Table Storage Engine' => 'محرك تخزين الجدول',
        'Tables with a different storage engine than the default engine were found.' =>
            'تم العثور على الجداول التي لا تستخدم المحرك الافتراضي.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'مطلوب MySQL 5.x أو أعلى.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'إعداد NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'يجب تعيين NLS_LANG إلى al32utf8 (على سبيل المثال، GERMAN_GERMANY. AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'إعداد NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'يجب تعيين NLS_DATE_FORMAT إلى \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'إعداد NLS_DATE_FORMAT فحص SQL',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'سلاسل المفاتيح الأساسية والمشغلات',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'تم العثور على التسلسلات و/أو المشغلات التالية التي قد تكون أسماء غير صحيحة. الرجاء تغيير الأسماء يدويا.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'يجب أن يكون إعداد client_encoding UNICODE أو UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'يجب أن يكون الإعداد server_encoding UNICODE أو UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'تنسيق التاريخ',
        'Setting DateStyle needs to be ISO.' => 'يجب أن يكون إعداد DateStyle هو ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'تسلسلات المفاتيح الأساسية',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            'تم العثور على التسلسلات التالية التي قد تكون أسماء غير صحيحة. الرجاء تغيير الأسماء يدويا.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'مطلوب PostgreSQL 9. 2 أو أعلى.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Certificates.pm
        'Certificate check' => 'التحقق من الشهادة',
        'Found obsolete cryptographic function.' => 'تم العثور على وظيفة تشفير قديمة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'قسم القرص الثابت ل OTOBO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'تخصيص أقسام القرص الصلب',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'تَوْزِيعٌ',
        'Could not determine distribution.' => 'لا يمكن تحديد التوزيع.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'إصدار النواة (Kernel)',
        'Could not determine kernel version.' => 'تعذر تحديد إصدار النواة (kernel).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'حمل النظام (load)',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'يجب أن يكون حمل النظام في الحد الأقصى لعدد وحدات المعالجة المركزية (CPU) الموجودة في النظام (على سبيل المثال، لا بأس بحمل يبلغ 8 أو أقل على نظام يحتوي على 8 وحدات معالجة مركزية (CPU)).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'وحدات بيرل (Perl)',
        'Not all required Perl modules are correctly installed.' => 'لم يتم تثبيت جميع وحدات Perl المطلوبة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'تدقيق وحدة بيرل (Perl)',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN :: ذكرت المراجعة أن واحدة أو أكثر من وحدات Perl المثبتة بها نقاط ضعف معروفة. يرجى ملاحظة أنه قد تكون هناك إيجابيات خاطئة للتوزيعات التي تقوم بتصحيح وحدات Perl دون تغيير رقم الإصدار الخاص بها.',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            'CPAN::لم يبلغ التدقيق عن أي ثغرات أمنية معروفة في وحدات Perl المثبتة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'مساحة التبادل الحرة (%)',
        'No swap enabled.' => 'لم يتم تمكين التبديل.',
        'Used Swap Space (MB)' => 'المساحة المتبادلة المستخدمة (ميغابايت)',
        'There should be more than 60% free swap space.' => 'يجب أن يكون هناك أكثر من 60% من مساحة المبادلة المتاحة.',
        'There should be no more than 200 MB swap space used.' => 'يجب ألا تكون هناك مساحة تبادل أكثر من 200 ميغابايت مستخدمة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => 'حالة فهرس البحث عن التذاكر',
        'Indexed Articles' => 'المقالات المفهرسة',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'مقالات لكل قناة اتصال',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => 'الاتصالات الواردة',
        'Outgoing communications' => 'الاتصالات الصادرة',
        'Failed communications' => 'الاتصالات الفاشلة',
        'Average processing time of communications (s)' => 'متوسط وقت معالجة الاتصالات (المراسلات)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'حالة حساب سجل الاتصالات (آخر 24 ساعة)',
        'No connections found.' => 'لم يتم العثور على إتصالات.',
        'ok' => 'OK',
        'permanent connection errors' => 'أخطاء الاتصال المستمرة',
        'intermittent connection errors' => 'خطأ اتصال مؤقت',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'إعدادات التكوين',
        'Could not determine value.' => 'تعذر تحديد القيمة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => 'البرنامج (Daemon) قيد التشغيل.',
        'Daemon is not running.' => 'البرنامج (Daemon) لا يعمل.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'إدخالات قاعدة البيانات',
        'Ticket History Entries' => 'إدخالات محفوظات التذاكر',
        'Articles' => 'مقالة',
        'Attachments (DB, Without HTML)' => 'المرفقات (في قاعدة البيانات، بدون HTML)',
        'Customers With At Least One Ticket' => 'العملاء الذين لديهم تذكرة واحدة على الأقل',
        'Dynamic Field Values' => 'القيم في الحقول الديناميكية',
        'Invalid Dynamic Fields' => 'الحقول الديناميكية غير صالحة',
        'Invalid Dynamic Field Values' => 'القيم في الحقول الديناميكية غير صحيحة',
        'GenericInterface Webservices' => 'خدمات ويب ل GenericInterface',
        'Process Tickets' => 'تذاكر العمليات',
        'Months Between First And Last Ticket' => 'شهور بين التذكرة الأولى والأخيرة',
        'Tickets Per Month (avg)' => 'التذاكر في الشهر (متوسط)',
        'Open Tickets' => 'تذاكر مفتوحة',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'كلمة مرور المسؤول الافتراضية',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'خطر الأمان: لا يزال حساب الوكيل root@localhost يحتوي على كلمة المرور الافتراضية. الرجاء تغييره أو إبطال الحساب.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'قائمة انتظار إرسال البريد الإلكتروني',
        'Emails queued for sending' => 'تم وضع رسائل البريد الإلكتروني في قائمة الانتظار لإرسالها',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (اسم domain)',
        'Please configure your FQDN setting.' => 'الرجاء تكوين إعداد FQDN.',
        'Domain Name' => 'اسم Domain',
        'Your FQDN setting is invalid.' => 'إعداد FQDN غير صالح.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'نظام الملفات قابل للكتابة',
        'The file system on your OTOBO partition is not writable.' => 'نظام الملفات الموجود على قسم OTOBO غير قابل للكتابة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'النسخ الاحتياطية للتهيئة القديمة',
        'No legacy configuration backup files found.' => 'لم يتم العثور على ملفات النسخ الاحتياطي للتكوين القديم.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            'تم العثور على ملفات النسخ الاحتياطي للتكوين القديم في مجلد Kernel/Config/Backup، ولكن قد تظل مطلوبة من قبل بعض الحزم.',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            'لم تعد هناك حاجة لملفات النسخ الاحتياطي للتكوين القديم للحزم المثبتة، الرجاء إزالتها من مجلد Kernel/Config/Backup.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'حالة تثبيت الحزمة',
        'Some packages have locally modified files.' => 'تحتوي بعض الحزم على ملفات معدلة محليا.',
        'Some packages are not correctly installed.' => 'لم يتم تثبيت بعض الحزم بشكل صحيح.',
        'Package Verification Status' => 'حالة التحقق من الحزمة',
        'Some packages are not verified by the OTOBO Team.' => 'لم يتم التحقق من بعض الحزم من قبل فريق OTOBO.',
        'Package Framework Version Status' => 'حالة إصدار إطار الحزمة',
        'Some packages are not allowed for the current framework version.' =>
            'بعض الحزم غير ملائمة للنسخة الحالية من الإطار.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'قائمة الحزم',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => 'إعدادات تكوين الجلسة',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'رسائل البريد الإلكتروني التي سيتم إرسالها',
        'There are emails in var/spool that OTOBO could not process.' => 'يحتوي var/spool على رسائل بريد إلكتروني تعذر على OTOBO معالجتها.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'إعداد SystemID الخاص بك غير صالح، يجب أن يحتوي على أرقام فقط.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'نوع التذكرة الافتراضي',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'نوع التذكرة الافتراضي الذي تم تكوينه غير صالح أو مفقود. يرجى تغيير الإعداد Ticket::Type::Default وتحديد نوع تذكرة صالح.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'وحدة فهرس التذاكر',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'لديك أكثر من 60,000 تذكرة ويجب أن تستخدم StaticDB backend. يرجى الرجوع إلى دليل المدير (تحسين الأداء).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'مستخدم غير صالح بتذاكر مؤمنة',
        'There are invalid users with locked tickets.' => 'هناك مستخدمون غير صالحين لديهم تذاكر مؤمنة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'يجب ألا يكون لديك أكثر من 8,000 تذكرة مفتوحة في نظامك.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'وحدة فهرس البحث في التذكرة',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'تفرض عملية الفهرسة تخزين نص المقالة الأصلي في فهرس البحث عن المقالات، بدون تنفيذ عوامل التصفية أو تطبيق قوائم كلمات التوقف. سيؤدي ذلك إلى زيادة حجم فهرس البحث وبالتالي قد يؤدي إلى إبطاء عمليات البحث عن النص الكامل.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'إعدادات الوقت',
        'Server time zone' => 'المنطقة الزمنية للخادم',
        'OTOBO time zone' => 'المنطقة الزمنية ل OTOBO',
        'OTOBO time zone is not set.' => 'لم يتم تعيين المنطقة الزمنية ل OTOBO.',
        'User default time zone' => 'المنطقة الزمنية الافتراضية للمستخدم',
        'User default time zone is not set.' => 'لم يتم تعيين المنطقة الزمنية الافتراضية للمستخدم.',
        'Calendar time zone is not set.' => 'لم يتم تعيين المنطقة الزمنية للتقويم.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => 'الوكلاء الذين يستخدمون ترتيب القائمة الرئيسية المخصصة',
        'Agents using favourites for the admin overview' => 'العملاء الذين يستخدمون المفضلة لنظرة عامة المسؤول',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'خادم ويب',
        'Loaded Apache Modules' => 'وحدات الأباتشي المحملة (Apache)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'نموذج MPM',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'يتطلب OTOBO تشغيل apache باستخدام نموذج ‎\'prefork\' MPM.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'إستخدام مسرع CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'يجب عليك إستخدام FastCGI أو mod_perl لزيادة أدائك.',
        'mod_deflate Usage' => 'إستخدام mod_delve',
        'Please install mod_deflate to improve GUI speed.' => 'الرجاء تثبيت mod_deflate لتحسين سرعة واجهة المستخدم الرسومية.',
        'mod_filter Usage' => 'إستخدام mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'الرجاء تثبيت mod_filter في حالة إستخدام mod_delve.',
        'mod_headers Usage' => 'إستخدام mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'الرجاء تثبيت mod_heads لزيادة السرعة.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'جمع بيانات الدعم',
        'Support data could not be collected from the web server.' => 'تعذر تحديد بيانات الدعم من خادم ويب.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/PSGIEnv.pm
        'PSGI Environment' => 'بيئة PSGI',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/RunsUnderPSGI.pm
        'Runs under PSGI' => 'يعمل تحت PSGI',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'إصدار خادم الويب',
        'Could not determine webserver version.' => 'تعذر تحديد إصدار خادم ويب.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'تفاصيل المستخدمين المتزامنين',
        'Concurrent Users' => 'المستخدمين المتزامنين',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '',
        'Problem' => 'مُشْكِلة',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'الإعداد ‎%s غير موجود!',
        'Setting %s is not locked to this user!' => 'لم يتم تأمين الإعداد ‎%s لهذا المستخدم!',
        'Setting value is not valid!' => 'قيمة الإعدادت غير صالحة!',
        'Could not add modified setting!' => 'تعذر إضافة إعدادات تم تغييرها!',
        'Could not update modified setting!' => 'تعذر تحديث الإعدادات التي تم تغييرها!',
        'Setting could not be unlocked!' => 'تعذر إلغاء تأمين الإعداد!',
        'Missing key %s!' => 'المفتاح المفقود ‎%s!',
        'Invalid setting: %s' => 'إعداد غير صالح: ‎%s',
        'Could not combine settings values into a perl hash.' => 'تعذر دمج قيم الإعدادات في تجزئة perl.',
        'Can not lock the deployment for UserID \'%s\'!' => 'يتعذر تأمين النشر ل \'‎UserID \'%s!',
        'All Settings' => 'كافة الإعدادات',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'افتراضي',
        'Value is not correct! Please, consider updating this field.' => 'القيمة غير صحيحة! الرجاء، النظر في تحديث هذا الحقل.',
        'Value doesn\'t satisfy regex (%s).' => 'لا تفي القيمة بالقيمة regex (‎%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'نَشَّطَ',
        'Disabled' => 'غير مُفَعّل',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            'تعذر حساب تاريخ المستخدم في المنطقة الزمنية OTOBO!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            'تعذر حساب تاريخ المستخدم ووقته في المنطقة الزمنية ل OTOBO!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'القيمة غير صحيحة! الرجاء، النظر في تحديث هذه الوحدة النمطية.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'القيمة غير صحيحة. الرجاء التحقق من هذا الإعداد.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'إعادة تعيين وقت إلغاء التأمين.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'المشاركون في الدردشة',
        'Chat Message Text' => 'نص رسالة الدردشة',

        # Perl Module: Kernel/System/Ticket/Mask.pm
        'Base structure is not valid. Please provide an array with data in YAML format.' =>
            '',
        'Error parsing dynamic fields.' => '',
        'No dynamic field "%s".' => '',
        'Dynamic field "%s" not valid.' => '',
        'Dynamic field "%s" already in use in a Set.' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => 'العديد من الإدخالات الفاشلة، الرجاء المحاولة مرة أخرى في ‎%s s.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'فشل في تسجيل الدخول! تم إدخال اسم المستخدم أو كلمة المرور بشكل خاطيء.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'نجحت المصادقة، ولكن لم يتم العثور على سجل بيانات مستخدم في قاعدة البيانات. الرجاء الاتصال بالمسؤول.',
        'Logout successful.' => 'تم تسجيل الخروج بنجاح.',
        'Feature not active!' => 'الخاصية غير مفعلة!',
        'Sent password reset instructions. Please check your email.' => 'تم ارسال تعليمات إعادة تعيين كلمة المرور. يرجى التحقق من بريدك الإلكتروني.',
        'Invalid Token!' => 'رمز (Token) غير صالح!',
        'Sent new password to %s. Please check your email.' => 'تم إرسال كلمة المرور الجديدة إلى %s. فضلاً افحص بريدك الإلكتروني.',
        'Error: invalid session.' => 'خطأ: جلسة عمل غير صالحة.',
        'No Permission to use this frontend module!' => 'ليس لديك الإذن لاستخدام هذه الوحدة!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'نجحت المصادقة، ولكن لم يتم العثور على سجل عميل في الطرف الخلفي للعميل. الرجاء الاتصال بالمسؤول.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'لم يتم إعادة تعيين كلمة المرور بنجاح. الرجاء الاتصال بالمسؤول.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'عنوان البريد الإلكتروني المدخل موجود بالفعل. فضلاً قم بتسجيل الدخول أو إعادة تعيين كلمة المرور.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'غير مسموح لعنوان البريد الإلكتروني هذا بالتسجيل. فضلاً اتصل بموظفي الدعم.',
        'Added via Customer Panel (%s)' => 'تمت الإضافة من خلال لوحة العميل (‎%s)',
        'Customer user can\'t be added!' => 'لا يمكن إضافة مستخدم العميل!',
        'Can\'t send account info!' => 'يتعذر إرسال معلومات الحساب!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'تم إنشاء حساب جديد. تم ارسال معلومات الدخول إلى %s. فضلاً افحص بريدك الإلكتروني.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'If you want to re-run installer.pl, then disable the SecureMode in the SysConfig.' =>
            'إذا أردت إعادة تشغيل installer.pl، فقم بتعطيل SecureMode في SysConfig.',
        'Action "%s" not found!' => 'لم يتم العثور على الإجراء "‎%s"!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run migration.pl, then disable the SecureMode in the SysConfig.' =>
            'إذا كنت ترغب في إعادة تشغيل migration.pl، فقم بتعطيل SecureMode في SysConfig.',

        # Perl Module: Kernel/System/Web/InterfacePublic.pm
        'Could not connect to the database.' => 'تعذر الاتصال بقاعدة البيانات.',

        # Database XML / SOPM Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'غير فعال مؤقتاً',
        'Group for default access.' => 'مجموعة الوصول الافتراضية.',
        'Group of all administrators.' => 'مجموعة كافة المسؤولين.',
        'Group for statistics access.' => 'مجموعة الوصول إلى الإحصائيات.',
        'new' => 'جديد',
        'All new state types (default: viewable).' => 'جميع أنواع الحالات الجديدة (الافتراضي: مرئي).',
        'open' => 'فتح',
        'All open state types (default: viewable).' => 'جميع أنواع الحالات المفتوحة (الافتراضي: قابلة للعرض).',
        'closed' => 'تم إقفاله',
        'All closed state types (default: not viewable).' => 'جميع أنواع الحالات المغلقة (الافتراضي: غير قابل للعرض).',
        'pending reminder' => 'في انتظار التذكير',
        'All \'pending reminder\' state types (default: viewable).' => 'جميع أنواع الحالات "قيد الانتظار" (الافتراضي: مرئي).',
        'pending auto' => 'قيد الانتظار',
        'All \'pending auto *\' state types (default: viewable).' => 'جميع أنواع حالات "انتظار تلقائي *" (افتراضي: قابل للعرض).',
        'removed' => 'أزاله',
        'All \'removed\' state types (default: not viewable).' => 'جميع أنواع الحالات "التي تمت إزالتها" (الإعداد التلقائي: غير قابل للعرض).',
        'merged' => 'مُنْدَمِج',
        'State type for merged tickets (default: not viewable).' => 'نوع الحالة للتذاكر المدمجة (الافتراضي: غير قابل للعرض).',
        'New ticket created by customer.' => 'تم إنشاء تذكرة جديدة بواسطة العميل.',
        'closed successful' => 'أغلقت بنجاح',
        'Ticket is closed successful.' => 'تم إغلاق التذكرة بنجاح.',
        'closed unsuccessful' => 'لم يتم الإغلاق بنجاح',
        'Ticket is closed unsuccessful.' => 'لم يتم إغلاق التذكرة بنجاح.',
        'Open tickets.' => 'تذاكر مفتوحة.',
        'Customer removed ticket.' => 'قام العميل بإزالة التذكرة.',
        'Ticket is pending for agent reminder.' => 'التذكرة معلقة لتذكير الوكيل.',
        'pending auto close+' => 'في انتظار الإغلاق الناجح',
        'Ticket is pending for automatic close.' => 'التذكرة في انتظار الإغلاق التلقائي.',
        'pending auto close-' => 'في انتظار إغلاق غير ناجح',
        'State for merged tickets.' => 'حالة التذاكر المدمجة.',
        'system standard salutation (en)' => 'التحية القياسية للنظام (EN)',
        'Standard Salutation.' => 'التحية القياسية.',
        'system standard signature (en)' => 'التوقيع القياسي للنظام (EN)',
        'Standard Signature.' => 'التوقيع القياسي.',
        'Standard Address.' => 'العنوان الافتراضي.',
        'possible' => 'ممكن',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'الأسئلة عن التذاكر المغلقة ممكنة. سيتم إعادة فتح التذاكر.',
        'reject' => 'رفض',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'الاستفسارات عن التذاكر المغلقة غير ممكنة. لن يتم إنشاء تذاكر جديدة.',
        'new ticket' => 'تذكرة جديدة',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'الاستفسار عن التذاكر المغلقة غير ممكن. سيتم إنشاء تذكرة جديدة.',
        'Postmaster queue.' => 'قائمة الانتظار الرئيسية للبريد.',
        'All default incoming tickets.' => 'جميع التذاكر الوارده.',
        'All junk tickets.' => 'جميع التذاكر غير الهامة.',
        'All misc tickets.' => 'جميع التذاكر المتنوعة.',
        'auto reply' => 'رد تلقائي',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'سيتم إرسال رد تلقائي بعد إنشاء تذكرة جديدة.',
        'auto reject' => 'رفض تلقائي',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'يتم إرسال الرفض التلقائي بعد رفض الرد (في حالة "رفض" خيار متابعة قائمة الانتظار).',
        'auto follow up' => 'الاستعلام التلقائي',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'يتم إرسال التأكيد التلقائي بعد تلقي الرد على تذكرة (إذا تم تعيين إعداد قائمة الانتظار للردود على "ممكن").',
        'auto reply/new ticket' => 'الرد التلقائي/ تذكرة جديدة',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'الرد التلقائي الذي يتم إرساله بعد رفض الرد وإنشاء تذكرة جديدة (إذا تم تعيين إعداد قائمة الانتظار للردود على "تذكرة جديدة").',
        'auto remove' => 'إزالة تلقائية',
        'Auto remove will be sent out after a customer removed the request.' =>
            'يتم إرسال "الإزالة التلقائية" بعد أن يزيل المستخدم العميل الطلب.',
        'default reply (after new ticket has been created)' => 'الاستجابة الافتراضية (بعد إنشاء تذكرة جديدة)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'الرفض القياسي (بعد تلقي الرد على تذكرة مغلقة ورفضه)',
        'default follow-up (after a ticket follow-up has been added)' => 'الاستجابة الافتراضية (بعد تلقي رد على تذكرة)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'الرفض الافتراضي/إنشاء تذكرة جديدة (بعد تلقي رد على تذكرة مغلقة وإنشاء تذكرة جديدة)',
        'Unclassified' => 'غير مصنف',
        '1 very low' => '1 منخفض جداً',
        '2 low' => '2 منخفض',
        '3 normal' => '3 عادي',
        '4 high' => '4 مرتفع',
        '5 very high' => '5 مرتفع جداً',
        'unlock' => 'إعادة فتح',
        'lock' => 'إقفال',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'وكيل',
        'system' => 'النظام',
        'customer' => 'عميل',
        'Ticket create notification' => 'الإخطار بتذكرة جديدة',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'سوف تتلقى إشعارا عند إنشاء تذكرة في قوائم الانتظار أو الخدمات المحددة تحت "قوائم الانتظار الخاصة بي" أو "الخدمات الخاصة بي".',
        'Ticket follow-up notification (unlocked)' => 'إخطار إجراءات المتابعة (تذكرة غير مقفلة)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'سوف تتلقى إخطارا إذا أرسل العميل متابعة لتذكرة غير مؤمنة موجودة في "قوائم الانتظار الخاصة بي" أو "خدماتي".',
        'Ticket follow-up notification (locked)' => 'إخطار متابعة التذكرة (مؤمن)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'سوف تتلقى إشعارا عندما يرسل العميل رسالة مرتدة إلى تذكرة تكون أنت المالك أو المسؤول عنها.',
        'Ticket lock timeout notification' => 'تنبيه إنتهاء وقت تأمين التذكرة',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'سوف تتلقى إشعارا عندما يتم إلغاء تأمين تذكرة خاصة بك تلقائيا.',
        'Ticket owner update notification' => 'إشعار بتغيير مالك التذكرة',
        'Ticket responsible update notification' => 'إشعار تحديث مسؤول التذاكر',
        'Ticket new note notification' => 'الإخطار بملاحظة جديدة',
        'Ticket queue update notification' => 'الإخطار بتغييرات قائمة الانتظار',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'ستتلقى إخطارا إذا تم نقل تذكرة إلى إحدى "قوائم الانتظار الخاصة بي".',
        'Ticket pending reminder notification (locked)' => 'التذكرة بانتظار إخطار التذكير (مؤمن)',
        'Ticket pending reminder notification (unlocked)' => 'إشعار عند الوصول إلى وقت التذكير (غير مؤمن)',
        'Ticket escalation notification' => 'الإخطار بتصعيد التذاكر',
        'Ticket escalation warning notification' => 'الإخطار بالتصعيد الوشيك للتذاكر',
        'Ticket service update notification' => 'الإخطار بتغييرات الخدمة',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'ستتلقى إشعارا إذا تم تغيير خدمة التذكرة إلى إحدى "خدماتي".',
        'Appointment reminder notification' => 'الإخطار عند الوصول إلى وقت التذكير بالمواعيد',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'ستتلقى إشعارا في كل مرة يتم فيها الوصول إلى وقت تذكير لأحد مواعيدك.',
        'Ticket email delivery failure notification' => 'إشعار فشل تسليم البريد الإلكتروني للتذكرة',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'خطأ أثناء اتصال AJAX. الحالة: ‎%s، خطأ: ‎%s',
        'This window must be called from compose window.' => 'يجب إستدعاء هذه النافذة من نافذة تحرير التذاكر.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'إضافة الكل',
        'An item with this name is already present.' => 'يوجد بالفعل عنصر بهذا الاسم.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'لا يزال هذا العنصر يحتوي على عناصر فرعية. هل أنت متأكد من أنك تريد إزالة هذا العنصر بما في ذلك العناصر الفرعية الخاصة به؟',

        # JS File: Core.Agent.Admin.About
        'Do you really want to delete this language?' => 'هل تريد حقًا حذف هذه اللغة؟',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'أكثر',
        'Less' => 'أقل',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'اضغط على Ctrl+C (Cmd+C) للنسخ إلى الحافظة',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'حذف هذا المرفق',
        'Deleting attachment...' => 'جارٍ حذف المرفق ...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'حدث خطأ أثناء حذف المرفق. الرجاء التحقق من السجلات للحصول على مزيد من المعلومات.',
        'Attachment was deleted successfully.' => 'تمت إزالة المرفق بنجاح.',

        # JS File: Core.Agent.Admin.CustomerDashboardInfoTile
        'Do you really want to delete this customer dashboard info tile entry?' =>
            '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'هل تريد حقا حذف هذا الحقل الديناميكي؟ سيتم فقدان جميع البيانات المرتبطة!',
        'Delete field' => 'حذف الحقل',
        'Deleting the field and its data. This may take a while...' => 'حذف الحقل والبيانات الخاصة به. قد يستغرق هذا بعض الوقت...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => 'إزالة هذا الحقل الديناميكي',
        'Remove selection' => 'إزالة التحديد',
        'Do you really want to delete this generic agent job?' => 'هل أنت متأكد من أنك تريد حذف وظيفة GenericAgent هذه؟',
        'Delete this Event Trigger' => 'حذف مشغل الحدث هذا',
        'Duplicate event.' => 'حدث مكرر.',
        'This event is already attached to the job, Please use a different one.' =>
            'هذا الحدث مرفق بالفعل بالوظيفة، يرجى استخدام حدث آخر.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'حدث خطأ أثناء الاتصال.',
        'Request Details' => 'تفاصيل الطلب',
        'Request Details for Communication ID' => 'تفاصيل الطلب لمعرف الاتصال',
        'Show or hide the content.' => 'إظهار المحتوى أو إخفاؤه.',
        'Clear debug log' => 'مسح سجل التصحيح',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'إزالة وحدة معالجة الأخطاء',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'من غير الممكن إضافة مشغل حدث جديد بسبب عدم تعيين الحدث.',
        'Delete this Invoker' => 'حذف هذا الاستدعاء (Invoker)',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'عذرا، لا يمكن إزالة الشرط الوحيد الموجود.',
        'Sorry, the only existing field can\'t be removed.' => 'عذرا، لا يمكن إزالة الحقل الوحيد الموجود.',
        'Delete conditions' => 'حذف الشروط',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'تعيين المفتاح %s',
        'Mapping for Key' => 'تعيين المفتاح',
        'Delete this Key Mapping' => 'حذف تعيين المفتاح',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'حذف هذه العملية',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'استنساخ خدمة الويب',
        'Delete operation' => 'حذف العملية',
        'Delete invoker' => 'حذف الاستدعاء',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'تنبيه: إذا قمت بتغيير اسم مجموعة "المسؤول" دون إجراء التعديلات المناسبة أولا في SysConfig، فستفقد الوصول إلى منطقة المسؤول! في هذه الحالة، يجب عليك إعادة تعيين اسم المجموعة في قاعدة البيانات.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'حذف حساب البريد الإلكتروني',
        'Deleting the mail account and its data. This may take a while...' =>
            'سيتم حذف حساب البريد الإلكتروني والبيانات. قد يستغرق هذا بعض الوقت...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'هل تريد بالتأكيد حذف لغة الإعلام هذه؟',
        'Do you really want to delete this notification?' => 'هل تريد حقا حذف هذا الإشعار؟',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => 'هل تريد حقا حذف هذا المفتاح؟',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'عملية تحديث الحزمة جارية حاليا. انقر هنا للحصول على معلومات الحالة.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'تم الانتهاء مؤخرا من ترقية الحزمة. انقر هنا لمشاهدة النتائج.',
        'No response from get package upgrade result.' => 'لا توجد إستجابة من الحصول على نتيجة ترقية الحزمة.',
        'Update all packages' => 'تحديث كافة الحزم',
        'Dismiss' => 'رفض',
        'Update All Packages' => 'تحديث كافة الحزم',
        'No response from package upgrade all.' => 'لا يوجد إستجابة من ترقية الحزمة كلها.',
        'Currently not possible' => 'غير ممكن حاليا',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'تم تعطيل هذا حاليا بسبب ترقية الحزمة الجارية.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'هذا الخيار معطل حاليًا لأن OTOBO Daemon لا يعمل.',
        'Are you sure you want to update all installed packages?' => 'هل تريد بالتأكيد تحديث كافة الحزم المثبتة؟',
        'No response from get package upgrade run status.' => 'لا توجد إستجابة من الحصول على حالة تشغيل ترقية الحزمة.',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'حذف عامل تصفية PostMasterFilter هذا',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'حذف عامل تصفية مسؤول البريد وبياناته. قد يستغرق هذا بعض الوقت...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => '',
        'No TransitionActions assigned.' => 'لم يتم تعيين إجراءات انتقالية.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'لم يتم تعيين مربعات حوار بعد. فقط أختر مربع حوار نشاط من القائمة الموجودة على اليسار واسحبه إلى هنا.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'لا يمكن حذف هذا النشاط لأنه نشاط البدء.',
        'Remove the Transition from this Process' => 'إزالة الانتقال من هذه العملية',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'بمجرد إستخدام هذا الزر أو الارتباط، ستغادر هذه الشاشة وسيتم حفظ حالتها الحالية تلقائيا. هل تريد المتابعة؟',
        'Delete Entity' => 'حذف الكيان',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'هذا النشاط مستخدم بالفعل في العملية. لا يمكنك إضافته مرتين!',
        'Error during AJAX communication' => 'خطأ أثناء اتصال AJAX',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'هناك انتقال غير متصل على سطح الرسم. الرجاء توصيل هذا الانتقال أولا قبل وضع عملية انتقال أخرى.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'هذا الانتقال مستخدم بالفعل لهذا النشاط. لا يمكنك إستخدامه مرتين!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'هذا الإجراء الانتقالي مستخدم بالفعل في هذا المسار. لا يمكنك إضافته مرة أخرى!',
        'Hide EntityIDs' => 'إخفاء EntityIDs',
        'Edit Field Details' => 'تحرير تفاصيل الحقل',
        'Customer interface does not support articles not visible for customers.' =>
            'لا تدعم واجهة العميل المقالات غير المرئية للعملاء.',
        'Sorry, the only existing parameter can\'t be removed.' => 'عذرا، لا يمكن إزالة المعلمة الوحيدة الموجودة.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => 'هل تريد حقا حذف هذه الشهادة؟',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'جاري إرسال التحديث. . .',
        'Support Data information was successfully sent.' => 'تم إرسال معلومات بيانات الدعم بنجاح.',
        'Was not possible to send Support Data information.' => 'لم يكن من الممكن إرسال معلومات بيانات الدعم.',
        'Update Result' => 'نتيجة التحديث',
        'Generating...' => 'تم الإنشاء...',
        'It was not possible to generate the Support Bundle.' => 'تعذر إنشاء حزمة الدعم.',
        'Generate Result' => 'نتيجة التوليد',
        'Support Bundle' => 'حزمة الدعم',
        'The mail could not be sent' => 'تعذر إرسال البريد الإلكتروني',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'لا يمكن إبطال هذا الإدخال حتى يتم تعديل كافة التكوينات المتأثرة وفقا لذلك.',
        'Cannot proceed' => 'لا يمكن المتابعة',
        'Update manually' => 'التحديث يدويا',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'يمكنك إما تحديث الإعدادات المتأثرة تلقائيا لتعكس التغييرات التي قمت بها للتو أو القيام بذلك بنفسك من خلال الضغط على "التحديث يدويا".',
        'Save and update automatically' => 'حفظ وتحديث تلقائي',
        'Don\'t save, update manually' => 'عدم الحفظ، التحديث يدويا',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'الإدخال الذي تبحث عنه حاليا هو جزء من إعداد التكوين الذي لم يتم تنشيطه حتى الآن وبالتالي فهو غير قابل للتعديل حاليا. الرجاء الانتظار حتى يتم تشغيل الإعداد. إذا لم تكن متأكدا مما يجب عليك القيام به بعد ذلك، الرجاء الاتصال بمسؤول النظام.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'جاري التحميل...',
        'Search the System Configuration' => 'البحث في تكوين النظام',
        'Please enter at least one search word to find anything.' => 'الرجاء إدخال مصطلح بحث واحد على الأقل.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'للأسف، النشر غير ممكن حاليًا، ربما بسبب نشر وكيل آخر بالفعل. الرجاء معاودة المحاولة في وقت لاحق.',
        'Deploy' => 'نشر',
        'The deployment is already running.' => 'النشر قيد التشغيل بالفعل.',
        'Deployment successful. You\'re being redirected...' => 'تم النشر بنجاح. تتم إعادة توجيهك ...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'حدث خطأ. الرجاء حفظ كافة الإعدادات التي تقوم بتحريرها حاليا والتحقق من السجلات للحصول على مزيد من المعلومات.',
        'Reset option is required!' => 'خيار إعادة التعيين مطلوب!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'باستعادة هذا النشر، سيتم إرجاع كافة الإعدادات إلى القيمة التي كانت موجودة في وقت النشر. هل تريد حقا المتابعة؟',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'لا يمكن إعادة تسمية المفتاح الذي يحتوي على قيم. الرجاء إزالة زوج المفتاح/القيمة هذا وإضافته مرة أخرى.',
        'Unlock setting.' => 'إلغاء تأمين الإعداد.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => 'هل أنت متأكد أنك تريد تجاهل كافة تغييرات المستخدم؟',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'هل تريد حقًا حذف صيانة النظام المجدولة؟',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'حذف هذا القالب',
        'Deleting the template and its data. This may take a while...' =>
            'حذف القالب وبياناته. قد يستغرق هذا بعض الوقت...',

        # JS File: Core.Agent.Admin.Translations
        'Missing Translations' => '',
        'At least one translation must be filled!' => '',
        'All translations must be filled!' => '',
        'Close' => 'إغلاق',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'تخطي',
        'Timeline Month' => 'شهر المخطط الزمني',
        'Timeline Week' => 'أسبوع المخطط الزمني',
        'Timeline Day' => 'يوم المخطط الزمني',
        'Previous' => 'رجوع',
        'Resources' => 'موارد',
        'Su' => 'الأَحَدِ',
        'Mo' => 'الاثْنَيْنِ',
        'Tu' => 'الثُّلاَثَاءِ',
        'We' => 'َالأَرْبِعَاءِ',
        'Th' => 'الْخَمِيسِ',
        'Fr' => 'الْجُمُعَةِ',
        'Sa' => 'السَّبْتِ',
        'This is a repeating appointment' => 'هذا موعد متكرر',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'هل تريد تعديل هذا الموعد فقط أم كافة المواعيد؟',
        'All occurrences' => 'كل التكرارات',
        'Just this occurrence' => 'هذا الحدث فقط',
        'Too many active calendars' => 'عدد كبير جدا من التقويمات النشطة',
        'Please either turn some off first or increase the limit in configuration.' =>
            'يرجى إما إيقاف تشغيل البعض أولا أو زيادة الحد الأقصى في التكوين.',
        'Restore default settings' => 'استعادة الإعدادات الافتراضية',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'هل تريد بالتأكيد حذف هذا التاريخ؟ ولا يمكن عكس هذا التغيير.',

        # JS File: Core.Agent.ArticleFeatures
        'Article Delete' => '',
        'Are you sure you want to delete this article?' => '',
        'Article deleted successfully!' => '',
        'Article already marked as deleted.' => '',
        'Article Restore' => '',
        'Are you sure you want to restore this article?' => '',
        'Article restored successfully!' => '',
        'Article not available for restoring.' => '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'حدد أولاً مستخدم العميل. يمكنك بعد ذلك تخصيص التذكرة لرقم عميل.',
        'Duplicated entry' => 'إدخال مكرر',
        'It is going to be deleted from the field, please try again.' => 'سيتم حذفه من الحقل، الرجاء المحاولة مرة أخرى.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'الرجاء إدخال مصطلح بحث واحد على الأقل أو * للبحث عن كل شيء.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'معلومات حول OTOBO Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'الرجاء التحقق من الحقول التي تم وضع علامة عليها بالأحمر من أجل إدخالات صالحة.',
        'month' => 'شهر',
        'Remove active filters for this widget.' => 'قم بإزالة الفلاتر النشطة لهذه الأداة.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => 'تم بالفعل تحديد هذا الحقل الديناميكي من نوع قاعدة البيانات.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'الرجاء الانتظار...',
        'Searching for linkable objects. This may take a while...' => 'البحث عن الكائنات ذات الصلة. قد يستغرق هذا بعض الوقت...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'هل أنت متأكد من أنك تريد حذف هذا الرابط؟',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'هل تستخدم ملحق مستعرض مثل AdBlock أو AdBlockPlus؟ قد يتسبب ذلك في حدوث العديد من المشكلات ونحن نوصيك بشدة بإضافة إستثناء لهذا المجال.',
        'Do not show this warning again.' => 'لا تظهر هذا التحذير مرة أخرى.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'عذرا، ولكن لا يمكنك تعطيل جميع طرق الإشعارات التي تم وضع علامة عليها على أنها إلزامية.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'عذرا، ولكن لا يمكنك تعطيل كافة الأساليب الخاصة بهذا الإخطار.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'الرجاء ملاحظة أن واحدا على الأقل من الإعدادات التي قمت بتغييرها يتطلب إعادة تحميل صفحة. انقر هنا لإعادة تحميل الشاشة الحالية.',
        'An unknown error occurred. Please contact the administrator.' =>
            'حدث خطأ غير معروف. الرجاء الاتصال بالمسؤول.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'التبديل إلى وضع سطح المكتب',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'الرجاء إزالة الكلمات التالية من البحث حيث لا يمكن البحث عنها:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'إنشاء',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'يحتوي هذا العنصر على عناصر فرعية ولا يمكن إزالته حاليًا.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'هل تريد حقًا حذف هذه الإحصائية؟',

        # JS File: Core.Agent.StatisticsReports
        'Do you really want to delete this report?' => 'هل تريد حقا حذف هذا التقرير؟',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'حدد رقم العميل الذي تريد تعيينه لهذه التذكرة',
        'Do you really want to continue?' => 'هل تريد حقا المتابعة؟',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' ... و ‎%s أكثر',
        ' ...show less' => ' ... أظهر أقل',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'إضافة مسودة جديدة',
        'Delete draft' => 'حذف المسودة',
        'There are no more drafts available.' => 'لا تتوفر أي مسودات أخرى.',
        'It was not possible to delete this draft.' => 'لم يكن من الممكن حذف المسودة.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'عامل تصفية المقالة',
        'Apply' => 'تطبيق',
        'Event Type Filter' => 'عامل تصفية نوع الحدث',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'تحريك شريط التنقل',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'الرجاء إيقاف تشغيل وضع التوافق في Internet Explorer!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'التبديل إلى وضع الهاتف الجوال',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'خطأ: فشل فحص المتصفح!',
        'Reload page' => 'إعادة تحميل الصفحة',
        'Reload page (%ss)' => 'إعادة تحميل الصفحة (‎%ss)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'تعذر تهيئة مساحة الاسم ‏%s، نظرا لتعذر العثور على ‎%s.',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            'حدث خطأ! يرجى التحقق من سجل أخطاء المتصفح لمزيد من التفاصيل!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'حدث خطأ واحد أو أكثر!',

        # JS File: Core.Installer
        'Mail check successful.' => 'تم التحقق من البريد بنجاح.',
        'Error in the mail settings. Please correct and try again.' => 'خطأ في إعدادات البريد. يرجى التصحيح والمحاولة مرة أخرى.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => 'افتح هذه العقدة في نافذة جديدة',
        'Please add values for all keys before saving the setting.' => 'الرجاء إضافة قيم لكل المفاتيح قبل حفظ الإعداد.',
        'The key must not be empty.' => 'يجب ألا يكون المفتاح فارغًا.',
        'A key with this name (\'%s\') already exists.' => 'يوجد مفتاح بهذا الاسم (\'‎%s\') بالفعل.',
        'Do you really want to revert this setting to its historical value?' =>
            'هل أنت متأكد أنك تريد إعادة تعيين هذا الإعداد إلى قيمته الأصلية؟',

        # JS File: Core.UI.CodeMirrorEditor
        'Error trying to create CodeMirror instance, please check configuration!' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'فتح تحديد التاريخ',
        'Invalid date (need a future date)!' => 'تاريخ غير صالح (التاريخ مطلوب في المستقبل)!',
        'Invalid date (need a past date)!' => 'تاريخ غير صالح (التاريخ المطلوب في الماضي)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'غير متوفر',
        'and %s more...' => 'و ‎%s أكثر...',
        'Show current selection' => 'إظهار التحديد الحالي',
        'Current selection' => 'التحديد الحالي',
        'Clear all' => 'مسح الكل',
        'Filters' => 'عوامل التصفية',
        'Clear search' => 'مسح البحث',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'إذا غادرت هذه الصفحة الآن، سيتم إغلاق جميع النوافذ المنبثقة المفتوحة أيضا!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'النافذة المنبثقة مفتوحة بالفعل على هذه الشاشة. هل تريد إغلاقه وفتحه بدلا من ذلك؟',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'تعذر فتح النوافذ المنبثقة. الرجاء تعطيل كافة برامج حظر النافذة المنبثقة لهذا التطبيق.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'ترتيب تصاعدي مطبق، ',
        'Descending sort applied, ' => 'تطبيق الفرز تنازلي ، ',
        'No sort applied, ' => 'لم يتم تطبيق أي فرز، ',
        'sorting is disabled' => 'الفرز معطل',
        'activate to apply an ascending sort' => 'تنشيط لتطبيق فرز تصاعدي',
        'activate to apply a descending sort' => 'تنشيط لتطبيق فرز تنازلي',
        'activate to remove the sort' => 'تنشيط لإزالة الفرز',

        # JS File: Core.UI.Table
        'Remove the filter' => 'إزالة عامل التصفية',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'لا توجد حاليا أي عناصر متوفرة للتحديد منها.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'الرجاء تحديد ملف واحد فقط للتحميل.',
        'Sorry, you can only upload one file here.' => 'عذرا، يمكنك تحميل ملف واحد فقط هنا.',
        'Sorry, you can only upload %s files.' => 'عذرا، يمكنك تحميل ملفات ‎%s فقط.',
        'Please only select at most %s files for upload.' => 'الرجاء تحديد حد أقصى من ‎%s مِلَفّ (ملفات) للتحميل.',
        'The following files are not allowed to be uploaded: %s' => 'يجب عدم تعديل الملفات التالية: ‎%s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'تتجاوز الملفات التالية الحد الأقصى للحجم لكل ملف (‎%s) ولم يتم تحديثها: ‎%s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'تم تحميل الملفات التالية بالفعل ولم تتم معالجتها مرة أخرى: ‎%s',
        'No space left for the following files: %s' => 'لا تتوفر مساحة للملفات التالية: ‎%s',
        'Available space %s of %s.' => 'المساحة المتوفرة ‎%s من ‎%s.',
        'Upload information' => 'تحميل المعلومات',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'حدث خطأ غير معروف عند حذف المرفق. الرجاء المحاولة مرة أخرى. إذا استمر الخطأ، الرجاء الاتصال بمسؤول النظام.',

        # JS File: ITSM.Admin.ImportExport
        'Deleting template...' => '',
        'There was an error deleting the template. Please check the logs for more information.' =>
            '',
        'Template was deleted successfully.' => '',

        # JS File: Core.Language.UnitTest
        'yes' => 'نعم',
        'no' => 'لا',
        'This is %s' => 'هذا ‎%s',
        'Complex %s with %s arguments' => 'معقد ‎%s مع ‎%s وسيطات',

        # JS File: OTOBOLineChart
        'No Data Available.' => 'لا تتوفر بيانات.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'جُمِّعَ',
        'Stacked' => 'مُكَدَّس',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'سَلِس',
        'Expanded' => 'واسع النَطاق',

        # SysConfig
        '
            Show optional parameters in parameter list, too. If disabled, the optional parameters are only shown
            in an extra table
        ' => '
            إظهار المعلمات الاختيارية في قائمة المعلمات أيضا. في حالة تعطيل هذا الخيار، يتم عرض المعلمات الاختيارية فقط
في جدول اضافي
        ',
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
عزيزي الزبون،

لسوء الحظ لم نتمكن من اكتشاف رقم تذكرة صحيح
في موضوعك، لذا لا يمكن معالجة هذا البريد الإلكتروني.

الرجاء إنشاء تذكرة جديدة عبر لوحة العملاء.

شكرا على مساعدتك!

فريق الدعم
',
        ' (work units)' => ' (وحدات العمل)',
        ' 2 minutes' => ' دقيقتان',
        ' 5 minutes' => ' 5 دقائق',
        ' 7 minutes' => ' 7 دقائق',
        '"Slim" skin which tries to save screen space for power users.' =>
            'Slim"-Skin", مما يتطلب مساحة أقل على الشاشة لعرض المعلومات.',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(تسجيل دخول المستخدم) الاسم الأول اسم العائلة',
        '(UserLogin) Lastname Firstname' => '(تسجيل دخول المستخدم) اسم العائلة الاسم الأول',
        '(UserLogin) Lastname, Firstname' => '(تسجيل دخول المستخدم) اسم العائلة ، الاسم الأول',
        '*** out of office until %s (%s d left) ***' => '*** ليس في المكتب حتى %s (%s الأيام المتبقية) ***',
        '0 - Disabled' => '0 - معطل',
        '1 - Available' => '1 - متوفر',
        '1 - Enabled' => '١ - منشط',
        '10 Minutes' => '10 دقائق',
        '100 (Expert)' => '100 (خبير)',
        '15 Minutes' => '15 دقيقة',
        '2 - Enabled and required' => '2 - مفعل وإلزامي',
        '2 - Enabled and shown by default' => '2 - ممكن ويظهر افتراضيا',
        '2 - Enabled by default' => '2 - ممكّن افتراضيًا',
        '2 Minutes' => 'دقيقتان',
        '200 (Advanced)' => '200 (مُتَقَدِّمٌ)',
        '30 Minutes' => '30 دقيقة',
        '300 (Beginner)' => '300 (مبتدئ)',
        '5 Minutes' => '5 دقائق',
        'A TicketWatcher Module.' => 'وحدة مراقبة التذاكر.',
        'A Website' => 'موقع ويب',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'قائمة بالحقول الديناميكية التي تم دمجها في التذكرة الرئيسية أثناء عملية الدمج. سيتم تعيين الحقول الديناميكية الفارغة في التذكرة الرئيسية فقط.',
        'A picture' => 'صورة',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'تسمح وحدة قائمة التحكم في الوصول (ACL) بإغلاق تذاكر الأصل فقط في حالة إغلاق كافة التذاكر التابعة بالفعل ( تظهر "الحالة" أي حالات غير متوفرة للتذكرة الأصلية حتى يتم إغلاق كافة تذاكر التابعة).',
        'Access Control Lists (ACL)' => 'قوائم التحكم في الوصول (ACL)',
        'AccountedTime' => 'الوقت المحسوب',
        'Activate Elasticsearch.' => 'تنشيط البحث المرن (Elasticsearch).',
        'Activate the customer frontend.' => 'تنشيط الواجهة الأمامية للعميل.',
        'Activate the public frontend.' => 'تنشيط الواجهة العامة.',
        'Activates Rendering of DynamicFields outside of the DynamicField block.' =>
            'يتيح عرض الحقل الديناميكي خارج كتلة الحقل الديناميكية.',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'تمكين آلية إرتباط لقائمة الانتظار التي تحتوي على التذكرة الأقدم.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'تمكين ميزة "نسيت كلمة المرور" للوكلاء في واجهة الوكيل.',
        'Activates lost password feature for customers.' => 'تمكين وظيفة "كلمة المرور المنسية" للعملاء.',
        'Activates support for customer and customer user groups.' => 'تمكين الدعم لمجموعات العملاء والمستخدمين.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'ينشط مرشح المقالة في عرض التكبير/التصغير لتحديد المقالات التي يجب عرضها.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'ينشط السمات المتاحة على النظام. القيمة 1 تعني نشط، 0 تعني غير نشط.',
        'Activates the ticket archive system search in the customer interface.' =>
            'ينشط البحث في نظام أرشيف التذاكر في واجهة العميل.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'تنشيط نظام أرشيف التذاكر للحصول على نظام أسرع عن طريق نقل بعض التذاكر خارج النطاق اليومي. للبحث عن هذه التذاكر، يجب تمكين علامة الأرشيف في البحث عن التذاكر.',
        'Activates time accounting.' => 'تنشيط حساب الوقت.',
        'ActivityID' => 'معرف النشاط (ActivityID)',
        'Add a note to this ticket' => 'إضافة ملاحظة إلى هذه التذكرة',
        'Add an inbound phone call to this ticket' => 'إضافة مكالمة هاتفية واردة إلى هذه التذكرة',
        'Add an outbound phone call to this ticket' => 'إضافة مكالمة هاتفية صادرة إلى هذه التذكرة',
        'Added %s time unit(s), for a total of %s time unit(s).' => 'تمت إضافة %s وحدة (وحدات) الوقت، إجمالي الوحدة (الوحدات) %s.',
        'Added email. %s' => 'تمت إضافة البريد الإلكتروني. %s',
        'Added follow-up to ticket [%s]. %s' => 'تمت إضافة المتابعة إلى التذكرة [%s]. %s',
        'Added link to ticket "%s".' => 'تمت إضافة رابط إلى التذكرة "%s".',
        'Added note (%s).' => 'تمت إضافة ملاحظة (%s).',
        'Added phone call from customer.' => 'تمت إضافة مكالمة هاتفية من العميل.',
        'Added phone call to customer.' => 'تمت إضافة مكالمة هاتفية إلى العميل.',
        'Added subscription for user "%s".' => 'تمت إضافة اشتراك للمستخدم "%s".',
        'Added system request (%s).' => 'تمت إضافة طلب النظام (%s).',
        'Added web request from customer.' => 'تمت إضافة طلب العميل عبر واجهة الويب.',
        'Adds a suffix with the actual year and month to the OTOBO log file. A logfile for every month will be created.' =>
            'إضافة لاحقة مع السنة والشهر الفعليين إلى ملف سجل OTOBO. سيتم إنشاء ملف سجل لكل شهر.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'يضيف عنوان البريد الإلكتروني للعملاء إلى المستلمين في واجهة "TicketCompose" لواجهة الوكيل. لن تتم إضافة عنوان البريد الإلكتروني للعملاء إذا كان نوع المقالة هو البريد الإلكتروني الداخلي.',
        'Adds the one time vacation days for the indicated calendar.' => 'إضافة أيام الإجازة لمرة واحدة للتقويم المشار إليه.',
        'Adds the one time vacation days.' => 'يضيف أيام الإجازة لمرة واحدة.',
        'Adds the permanent vacation days for the indicated calendar.' =>
            'إضافة أيام الإجازة الدائمة للتقويم المشار إليه.',
        'Adds the permanent vacation days.' => 'يضيف أيام الإجازة الدائمة.',
        'Admin' => 'المسؤول',
        'Admin Area.' => 'منطقة المسؤول.',
        'Admin Contact With Data' => 'جهة اتصال المسؤول بالبيانات',
        'Admin Notification' => 'تنبيهات المسؤول',
        'Admin area navigation for the agent interface.' => 'التنقل في واجهة المسؤول لواجهة الوكيل.',
        'Admin contact with data.' => 'تفاصيل الاتصال بمنطقة المسؤول.',
        'Admin modules overview.' => 'نظرة عامة على وحدة المسؤول.',
        'Admin.' => 'المسؤول.',
        'Administration' => 'الإدارة',
        'Agent Contact With Data Search' => 'اتصال الوكيل بالبحث عن البيانات',
        'Agent Customer Search' => 'البحث عن عملاء الوكيل',
        'Agent Customer Search.' => 'البحث عن عميل الوكيل.',
        'Agent Dynamic Field Database Detailed Search' => 'البحث التفصيلي لقاعدة بيانات الحقل الديناميكي للعامل',
        'Agent Dynamic Field Database Details' => 'تفاصيل قاعدة بيانات الحقل الديناميكي للوكيل',
        'Agent Dynamic Field Database Search' => 'بحث قاعدة بيانات الحقل الديناميكي للوكيل',
        'Agent Name' => 'اسم الوكيل',
        'Agent Name + FromSeparator + System Address Display Name' => 'اسم الوكيل + من الفاصل (FromSeparator) + اسم عرض عنوان النظام',
        'Agent Preferences.' => 'إعدادات الوكيل.',
        'Agent Reference Dynamic Field With Data Search' => '',
        'Agent Statistics.' => 'إحصائيات الوكيل.',
        'Agent User Search' => 'بحث مستخدم الوكيل',
        'Agent User Search.' => 'بحث مستخدم الوكيل.',
        'Agent contact with data search.' => 'اتصال الوكيل بالبحث عن البيانات.',
        'Agent dynamic field database detailed search.' => 'قاعدة بيانات الحقل الديناميكي للعامل بحث مفصل.',
        'Agent dynamic field database details.' => 'تفاصيل قاعدة بيانات الحقل الديناميكي للوكيل.',
        'Agent dynamic field database search.' => 'البحث في قاعدة بيانات الحقل الديناميكي للعامل.',
        'Agent frontend module registration (disable \'Edit contacts with data\' link if if there is no source field configured).' =>
            'تسجيل الوحدة النمطية للواجهة الأمامية للوكيل (تعطيل الارتباط "تحرير بيانات الاتصال" في حالة عدم تكوين حقل مصدر).',
        'Agent interface article notification module to check PGP.' => 'وحدة إعلام المقالة التي تقوم بالتحقق من PGP في واجهة الوكيل.',
        'Agent interface article notification module to check S/MIME.' =>
            'وحدة إعلام المادة التي تقوم بإجراء التحقق من S/MIME في واجهة العميل.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'الوحدة التي تتحكم في الوصول إلى بحث CIC من خلال شريط التنقل في واجهة العميل. يمكن التحكم في الوصول التكميلي (عرض أو إخفاء الارتباط) باستخدام مفتاح "مجموعة" والمحتوى مثل "rw:group1;move_into:group2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'وحدة واجهة الوكيل للوصول إلى البحث عن النص الكامل عبر شريط التنقل. يمكن إجراء تحكم إضافي في الوصول لإظهار أو عدم إظهار هذا الرابط باستخدام مفتاح "المجموعة" والمحتوى مثل "rw:group1;move_into:group2".',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'وحدة تحكم في الوصول إلى ملفات تعريف البحث من خلال شريط التنقل في واجهة العميل. يمكن التحكم في الوصول التكميلي (عرض أو إخفاء الارتباط) باستخدام مفتاح "مجموعة" والمحتوى مثل "rw:group1;move_into:group2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'الوحدة النمطية التي تتحقق من رسائل البريد الإلكتروني الواردة في TicketZoom "طريقة عرض تكبير/تصغير التذاكر" بحثا عن مفاتيح S/MIME الحالية والصالحة في واجهة الوكيل.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'وحدة إعلام واجهة الوكيل لمعرفة عدد التذاكر المؤمنة. يمكن إجراء تحكم وصول إضافي لإظهار هذا الارتباط أو عدم إظهاره باستخدام المفتاح "مجموعة" والمحتوى مثل "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'وحدة إعلام واجهة الوكيل لمعرفة عدد التذاكر التي يكون الوكيل مسؤولا عنها. يمكن إجراء تحكم إضافي في الوصول لإظهار أو عدم إظهار هذا الرابط باستخدام مفتاح "المجموعة" والمحتوى مثل "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'وحدة إعلام واجهة الوكيل لمعرفة عدد التذاكر في خدماتي. يمكن إجراء تحكم إضافي في الوصول لإظهار أو عدم إظهار هذا الرابط باستخدام مفتاح "المجموعة" والمحتوى مثل "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'وحدة الإخطار التي تتحكم في عرض عدد التذاكر المراقبة في واجهة الوكيل. يمكن تنفيذ التحكم الإضافي في الوصول (إظهار الارتباط أو إخفاؤه) باستخدام مفتاح "المجموعة" ومحتوى مثل "rw:group1;move_into:group2".',
        'Agent reference dynamic field with data search.' => '',
        'AgentTicketZoom widget that displays Contact with data dynamic field in the side bar.' =>
            'عنصر واجهة مستخدم AgentTicketZoom الذي يعرض الحقل الديناميكي \'بيانات الاتصال\' في الشريط الجانبي.',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            'عنصر واجهة مستخدم AgentTicketZoom الذي يعرض حقل "الاتصال مع البيانات الديناميكية" في الشريط الجانبي.',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            'عنصر واجهة مستخدم AgentTicketZoom الذي يعرض معلومات العميل للتذكرة في الشريط الجانبي.',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            'عنصر واجهة مستخدم AgentTicketZoom الذي يعرض بيانات التذكرة في الشريط الجانبي.',
        'Agents ↔ Groups' => 'وكلاء ↔ مجموعات (Agents ↔ Groups)',
        'Agents ↔ Roles' => 'الوكلاء ↔ الأدوار (Agents ↔ Roles)',
        'All CustomerIDs of a customer user.' => 'جميع أرقام العملاء الخاصة بمستخدم العميل.',
        'All closed tickets.' => 'جميع التذاكر المغلقة.',
        'All customer users of a CustomerID' => 'جميع مستخدمي العملاء لرقم العميل',
        'All escalated tickets' => 'جميع التذاكر المتصاعدة',
        'All new tickets, these tickets have not been worked on yet' => 'جميع التذاكر الجديدة، هذه التذاكر لم يتم العمل عليها بعد',
        'All open tickets, these tickets have already been worked on.' =>
            'جميع التذاكر المفتوحة، هذه التذاكر قد تم العمل عليها بالفعل.',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'كافة التذاكر التي تم تعيين تذكير بها حيث تم الوصول إلى تاريخ التذكير',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'يتيح لك إضافة ملاحظات في قناع "إقفال التذاكر" في واجهة العميل. يمكن أن يتم تجاوزها ب Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'يسمح بإضافة ملاحظات في شاشة "تصنيف التذكرة" في واجهة الوكيل. يمكن تجاوزها بواسطة Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'يسمح بإضافة ملاحظات في قناع "الملاحظة" في واجهة الوكيل. يمكن تجاوزها بواسطة Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'يسمح لمالك التذكرة بإضافة ملاحظات في عرض TicketZoom في واجهة الوكيل. يمكن تجاوزها بواسطة Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'يسمح بإضافة ملاحظات في شاشة "في انتظار . . . " في TicketZoom في واجهة الوكيل. يمكن تجاوزها بواسطة Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'يسمح بإضافة ملاحظات في شاشة "الأولوية" في TicketZoom في واجهة الوكيل. يمكن تجاوزها بواسطة Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'يسمح لمدير التذاكر بإضافة ملاحظات في واجهة الوكيل. يمكن تجاوزها بواسطة Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'يسمح للعملاء بتبادل محاور الإحصائيات عند إنشاء الإحصائيات.',
        'Allows agents to generate individual-related stats.' => 'يسمح للوكلاء بإنشاء إحصاءات فردية.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'يتيح لك الاختيار بين عرض مرفقات التذكرة في المتصفح (مضمنة) أو ببساطة تقديمها كتنزيل (مرفق).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'يسمح لك بتحديد حالة الإنشاء التالية لتذكرة العميل في واجهة العميل.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'يسمح للعملاء بتغيير أولوية التذكرة في واجهة العميل.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'السماح للعملاء بتعيين إتفاقية مستوى الخدمة (SLA) الخاصة بالتذاكر في واجهة العميل.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'السماح للعملاء بتعيين أولوية التذكرة في واجهة العميل.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            'يسمح للعملاء بتعيين قائمة انتظار التذاكر في واجهة العميل. في حالة عدم تمكين هذا الخيار، يجب تكوين QueueDefault.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'السماح للعملاء بتعيين خدمة التذاكر في واجهة العميل.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            'السماح للعملاء بتعيين نوع التذكرة في واجهة العميل. في حالة عدم تمكين هذا الخيار، يجب تكوين TicketTypeDefault.',
        'Allows default services to be selected also for non existing customers.' =>
            'السماح بتحديد الخدمات الافتراضية أيضا للعملاء غير الموجودين.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'يسمح بتحديد الخدمات و SLA للتذاكر (مثل البريد الإلكتروني، سطح المكتب، الشبكة، ...) وسمات التصعيد ل SLA (في حالة تمكين ميزة خدمة التذاكر/SLA).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'السماح بشروط البحث الموسعة في البحث عن تذاكر واجهة الوكيل. مع هذه الميزة يمكنك البحث على سبيل المثال عن عنوان تذكرة مع هذا النوع من الشروط مثل "(*key1*&&*key2*)" أو (*key1*||*key2*)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'السماح بشروط البحث الموسعة في البحث عن تذاكر واجهة العميل. مع هذه الميزة يمكنك البحث على سبيل المثال عن عنوان تذكرة مع هذا النوع من الشروط مثل "(*key1*&&*key2*)" أو "(*key1*||*key2*)".',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'يسمح بشروط البحث الموسعة في البحث عن التذاكر لواجهة الوكيل العامة. باستخدام هذه الميزة، يمكنك البحث على سبيل المثال عن عنوان التذكرة باستخدام هذا النوع من الشروط مثل "(*key1*&&*key2*)" أو "(*key1*||*key2*)".',
        'Allows generic agent to execute custom modules.' => 'يسمح ل GenericAgent بتشغيل وحدات مخصصة.',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'يسمح بنظرة عامة على التذكرة مع بعض معلومات التذاكر (العميل = > 1 - يعرض أيضا معلومات العميل).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'تمكن من استخدام نظرة عامة على التذكرة الصغيرة (معلومات العميل (CustomerInfo) => 1 - تعرض أيضًا معلومات العميل).',
        'Allows invalid agents to generate individual-related stats.' => 'يسمح للوكلاء غير الصالحين (invalid) بإنشاء إحصاءات فردية.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'السماح للمسؤولين بتسجيل الدخول كعملاء آخرين، من خلال لوحة إدارة المستخدم الخاص بالعميل.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'السماح للمسؤولين بتسجيل الدخول كمستخدمين آخرين، من خلال لوحة إدارة المستخدمين.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            'يسمح بحفظ العمل الحالي كمسودة في شاشة إغلاق التذكرة لواجهة الوكيل.',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            'يسمح بحفظ العمل الحالي كمسودة في شاشة البريد الإلكتروني الصادرة لواجهة الوكيل.',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            'يسمح بحفظ العمل الحالي كمسودة في شاشة إنشاء التذاكر لواجهة الوكيل.',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            'يسمح لك بحفظ حالة المعالجة الحالية في قناع "إعادة التوجيه" في واجهة الوكيل.',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            'يسمح بحفظ حالة المعالجة الحالية في مربع الحوار "تصنيف التذكرة" في واجهة الوكيل.',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            'يسمح لك بحفظ حالة المعالجة الحالية في مربع الحوار "نقل" في واجهة الوكيل.',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            'يسمح لك بحفظ الحالة الحالية كمسودة في شاشة الملاحظات الخاصة بمنطقة الوكيل.',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            'يسمح بحفظ العمل الحالي كمسودة في شاشة مالك التذكرة لواجهة الوكيل.',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            'يسمح لك بحفظ الحالة الحالية كمسودة في شاشة الانتظار في منطقة الوكيل.',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            'يسمح لك بحفظ الحالة الحالية كمسودة في شاشة المكالمة الواردة لمنطقة الوكيل.',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            'يسمح بحفظ العمل الحالي كمسودة في شاشة الهاتف الصادرة لواجهة الوكيل.',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            'يسمح بحفظ العمل الحالي كمسودة في شاشة أولوية التذكرة لواجهة الوكيل.',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            'يسمح بحفظ العمل الحالي كمسودة في الشاشة المسؤولة عن التذكرة لواجهة الوكيل.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'السماح بتعيين حالة تذكرة جديدة في شاشة تذاكر النقل الخاصة بواجهة الوكيل.',
        'Always show RichText if available' => 'استخدم النص المنسق دائما عند توفره',
        'Answer' => 'إِجَابَة',
        'Appointment Calendar overview page.' => 'صفحة نظرة عامة على تقويم المواعيد.',
        'Appointment Notifications' => 'إشعارات المواعيد',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            'الوحدة النمطية لحدث تقويم المواعيد التي تعد إدخالات الإشعارات للمواعيد.',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            'الوحدة النمطية لحدث تقويم المواعيد التي تقوم بتحديث التذكرة ببيانات من موعد التذكرة.',
        'Appointment edit screen.' => 'شاشة تحرير المواعيد.',
        'Appointment list' => 'قائمة المواعيد',
        'Appointment list.' => 'قائمة المواعيد.',
        'Appointment notifications' => 'إشعارات المواعيد',
        'Appointments' => 'المواعيد',
        'Arabic (Saudi Arabia)' => 'العربية (المملكة العربية السعودية)',
        'Article ID: %s was deleted by "%s" (%s)' => '',
        'Article ID: %s was edited by "%s" (%s)' => '',
        'Article ID: %s was restored by "%s" (%s)' => '',
        'Article Version View' => '',
        'Article attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            'سمات المقالة التي يجب أن تكون متاحة في الواجهة الأمامية لتكوين استدعاء التذاكر (0 = مرئي / قابل للتحديد، 1 = افتراضي / محدد مسبقا).',
        'ArticleTree' => 'شجرة المقالة',
        'As soon as the move queue option dropdown is enabled for example in the AgentTicketZoom dialogue, it is possible to move tickets locked to other agents to another queue by activating this option.' =>
            '',
        'Attachment Name' => 'اسم المرفق',
        'Automated line break in text messages after x number of chars.' =>
            'فاصل تلقائي للسطر في الرسائل النصية بعد x من الحروف.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            'تغيير حالة التذكرة تلقائيا مع مالك غير صالح بمجرد إلغاء تأمينها. إنشاء حالة التذكرة الجديدة وفقا لنوع الحالة.',
        'Automatically generate statistics reports and email them to the specified recipients.' =>
            'إنشاء تقارير الإحصائيات تلقائيا وإرسال بريد إلكتروني إليها إلى المستلمين المحددين.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'قفل المالك وتعيينه تلقائيا على الوكيل الحالي بعد فتح شاشة تذكرة النقل لواجهة الوكيل.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'قفل المالك وتعيينه تلقائيا إلى العامل الحالي بعد تحديد إجراء مجمع.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'تعيين مالك التذكرة كمسؤول عنها تلقائيا (إذا تم تمكين ميزة مسؤول التذكرة). سيعمل هذا فقط من خلال الإجراءات اليدوية للمستخدم الذي قام بتسجيل الدخول. لا يعمل مع الإجراءات التلقائية مثل GenericAgent أو Postmaster أو GenericInterface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'تعيين مدير التذاكر تلقائيا (إذا لم يتم تعيينه بعد) بعد تحديث المالك الأول.',
        'Avatar' => 'الصورة الرمزية (Avatar)',
        'Balanced white skin by Felix Niklas (slim version).' => 'متوازن White-Skin von Felix Niklas (slim version).',
        'Balanced white skin by Felix Niklas.' => 'Balanced white skin by Felix Niklas.',
        'Based on global RichText setting' => 'استنادا إلى إعداد النص المنسق العام',
        'Basic fulltext index settings. Execute "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            'إعدادات فهرس النص الكامل الأساسية. نفذ "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" لإنشاء فهرس جديد.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'يحظر جميع رسائل البريد الإلكتروني الواردة التي لا تحتوي على رقم تذكرة صالح في الموضوع باستخدام عنوان من: @example.com.',
        'Bounced to "%s".' => 'تم الإرسال إلى "%s".',
        'Bulgarian' => 'بلغارية',
        'Bulk Action' => 'تنفيذ جماعي',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'إعداد مثال CMD. تجاهل رسائل البريد الإلكتروني حيث يقوم CMD الخارجي بإرجاع بعض الإخراج على STDOUT (سيتم تمرير البريد الإلكتروني عبر بروتوكول STDIN الخاص ببعض.bin).',
        'CSV Separator' => 'فواصل بيانات CSV',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'ذاكرة التخزين المؤقت بالثواني لمصادقة الوكيل في GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'ذاكرة التخزين المؤقت بالثواني لمصادقة العميل في GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'ذاكرة التخزين المؤقت بالثواني للخلفية DB ACL.',
        'Cache time in seconds for the DB process backend.' => 'ذاكرة التخزين المؤقت بالثواني للخلفية الخلفية لعملية قاعدة البيانات.',
        'Cache time in seconds for the SSL certificate attributes.' => 'ذاكرة التخزين المؤقت بالثواني لسمات شهادة SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'ذاكرة التخزين المؤقت في الثواني لوحدة إخراج شريط التنقل لعملية التذاكر.',
        'Cache time in seconds for the web service config backend.' => 'ذاكرة التخزين المؤقت في الثواني لمنتهى خلفي تكوين خدمة ويب.',
        'Calendar manage screen.' => 'شاشة إدارة التقويم.',
        'Cancel whole escalation if ticket is in configured suspend state (EscalationSuspendStates). Ticket will not escalate at all in configured suspend state. No escalation times are shown. Ticket will not be shown in escalation view.' =>
            'إلغاء التصعيد بالكامل إذا كانت التذكرة في حالة الإيقاف المؤقت المكونة (EscalationSuspendStates). لن يتم تصعيد التذكرة على الإطلاق في حالة الإيقاف المؤقت المكونة. لم يتم إظهار أوقات التصعيد. ولم يتم إدراج التذكرة في قائمة التذاكر المتصاعدة.',
        'Catalan' => 'الكتالانية',
        'Categories used in ticket presentation. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            'الفئات المستخدمة في عرض التذاكر. إذا لم يتم إعطاء لون افتراضي، لن يتم إظهار العنصر إذا لم يتم تعريف التحديد في تجزئة اللون. إختياريا، يمكن إضافة السمة Text لتجاوز قيمة الحقل، ويمكن إستخدام أساليب إنشاء القوالب (على سبيل المثال، "Text" => "[% Data.Value | remove(\'^.+::\') %]"). يمكن إستخدام الارتباط بنفس الطريقة.',
        'Categories used in ticket presentation. Order is only used to determine the starting position before size arrangement. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            'الفئات المستخدمة في عرض التذاكر. يتم إستخدام الأمر فقط لتحديد موضع البدء قبل ترتيب الحجم. إذا لم يتم إعطاء لون افتراضي، لن يتم إظهار العنصر إذا لم يتم تعريف التحديد في تجزئة اللون. إختياريا، يمكن إضافة السمة Text لتجاوز قيمة الحقل، ويمكن إستخدام أساليب إنشاء القوالب (على سبيل المثال: "Text" => "[% Data.Value | remove(\'^.+::\') %]"). يمكن إستخدام الارتباط بنفس الطريقة.',
        'Change Ticket' => 'تغيير التذكرة',
        'Change Ticket information' => 'تغيير معلومات التذكرة',
        'Change queue!' => 'تغيير قائمة الانتظار!',
        'Change the customer for this ticket' => 'تغيير عميل التذاكر',
        'Change the owner for this ticket' => 'تغيير مالك هذه التذكرة',
        'Change the priority for this ticket' => 'تغيير أولوية هذه التذكرة',
        'Change the responsible for this ticket' => 'تغيير المسؤول عن هذه التذكرة',
        'Change your avatar image.' => 'تغيير الصورة الرمزية.',
        'Change your password and more.' => 'تغيير كلمة المرور وغيرها.',
        'Changed SLA to "%s" (%s).' => 'تم تغيير SLA إلى ‎"%s" (%s).',
        'Changed archive state to "%s".' => 'تم تغيير حالة الأرشيف إلى "%s".',
        'Changed customer to "%s".' => 'تم تغيير العميل إلى "%s".',
        'Changed dynamic field %s from "%s" to "%s".' => 'تم تغيير الحقل الديناميكي %s من "%s" إلى "%s".',
        'Changed owner to "%s" (%s).' => 'تم تغيير المالك إلى "%s" (%s).',
        'Changed pending time to "%s".' => 'تم تغيير وقت الانتظار إلى "%s".',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'تم تغيير الأولوية من "%s" (%s) إلى "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => 'تم تغيير قائمة الانتظار إلى "%s" (%s) من "%s" (%s).',
        'Changed responsible to "%s" (%s).' => 'تم تغيير المسؤول إلى "%s" (%s).',
        'Changed service to "%s" (%s).' => 'تم تغيير الخدمة إلى "%s" (%s).',
        'Changed state from "%s" to "%s".' => 'تم تغيير الحالة من "%s" إلى "%s".',
        'Changed title from "%s" to "%s".' => 'تم تغيير العنوان من "%s" إلى "%s".',
        'Changed type from "%s" (%s) to "%s" (%s).' => 'تم تغيير النوع من "%s" (%s). إلى "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'تغيير مالك التذكرة إلى الكل (مفيد ل ASP). في العادة، سيتم عرض العملاء الذين لديهم أذونات rw فقط على قائمة الانتظار.',
        'Chat communication channel.' => 'قناة اتصال الدردشة.',
        'Checkbox' => 'خانة الاختيار',
        'Checks for articles that needs to be updated in the article search index.' =>
            'يتحقق من المقالات التي تحتاج إلى تحديث في فهرس البحث عن المقالات.',
        'Checks for communication log entries to be deleted.' => 'التحقق من حذف إدخالات سجل الاتصالات.',
        'Checks for queued outgoing emails to be sent.' => 'تحقق من رسائل البريد الصادرة لإرسالها.',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'التحقق مما إذا كان البريد الإلكتروني عبارة عن متابعة لتذكرة موجودة من خلال البحث عن رقم تذكرة صالح.',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            'التحقق مما إذا كان البريد الإلكتروني عبارة عن متابعة لتذكرة موجودة برقم تذكرة خارجي يمكن العثور عليه بواسطة وحدة عامل تصفية ExternalTicketNumberRecognition.',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            'يتحقق من SystemID في اكتشاف رقم التذكرة للمتابعة. إذا لم يتم تمكينه ، فسيتم تغيير SystemID بعد استخدام النظام.',
        'Child' => 'فرع',
        'Chinese (Simplified)' => 'صيني (مبسط)',
        'Chinese (Traditional)' => 'الصينية (التقليدية)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            'حدد نوع تغييرات الموعد التي تريد إستلام الإعلامات لها.',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'حدد تغييرات التذاكر التي تريد أن يتم إعلامك بها. يرجى ملاحظة أنه لا يمكنك إيقاف تشغيل الإشعارات التي تم وضع علامة عليها على أنها إلزامية تماما.',
        'Choose which notifications you\'d like to receive.' => 'أختر الإخطارات التي تريد تلقيها.',
        'Christmas Eve' => 'عشية عيد الميلاد',
        'Close this ticket' => 'أغلق هذه التذكرة',
        'Closed Tickets' => 'التذاكر المغلقة',
        'Closed tickets (customer user)' => 'التذاكر المغلقة (مستخدمون الزبائن)',
        'Closed tickets (customer)' => 'التذاكر المغلقة (العميل)',
        'Cloud Services' => 'الخدمات السحابية',
        'Cloud service admin module registration for the transport layer.' =>
            'تسجيل وحدة مسؤول الخدمة السحابية لطبقة النقل.',
        'Collect support data for asynchronous plug-in modules.' => 'تجميع بيانات الدعم لوحدات المكونات الإضافية غير المتزامنة.',
        'Color definitions for Agent interface highcontrast skin.' => '',
        'Color definitions for Customer Interface highcontrast skin.' => '',
        'Color definitions for the agent interface (default skin). MainDark, -Light and Hover are the navigation background, buttons and some other main elements. Highlight are e.g. icons and selected elements in the navbar. BG- and Text colors are various background, and text colors. Hover colors are used in selections and tables. Notify colors are the background of notifications.' =>
            '',
        'Color definitions for the customer interface.' => 'تعريفات الألوان لواجهة العميل.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'عمود عامل تصفية التذاكر لعرض التذاكر من النوع "صغير".',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'أعمدة قابلة للطباعة في العرض ذي الصلة لمساحة العميل. ملاحظة: يتم السماح بسمات التذاكر فقط والحقول الديناميكية (DynamicField_NameX) وسمات العملاء (مثل CustomerUserPhone و CustomerCompanyName).',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'أعمدة قابلة للطباعة في العرض ذي الصلة لمساحة العميل. ملاحظة: يتم السماح بسمات التذاكر فقط والحقول الديناميكية (DynamicField_NameX) وسمات العملاء (مثل CustomerUserPhone و CustomerCompanyName).',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'الأعمدة التي يمكن تصفيتها في طريقة عرض قائمة الانتظار لواجهة العامل. ملاحظة: يسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) وسمات العميل (مثل CustomerUserPhone و CustomerCompanyName و...).',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'الأعمدة التي يمكن تصفيتها في طريقة العرض المسؤولة لواجهة العامل. ملاحظة: يسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) وسمات العميل (مثل CustomerUserPhone و CustomerCompanyName و...).',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'الأعمدة التي يمكن تصفيتها في طريقة عرض الخدمة لواجهة الوكيل. ملاحظة: يسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) وسمات العميل (مثل CustomerUserPhone و CustomerCompanyName و...).',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'الأعمدة التي يمكن تصفيتها في طريقة عرض الحالة لواجهة العامل. ملاحظة: يسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) وسمات العميل (مثل CustomerUserPhone و CustomerCompanyName و...).',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'الأعمدة التي يمكن تصفيتها في طريقة عرض نتائج البحث عن التذكرة لواجهة العامل. ملاحظة: يسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) وسمات العميل (مثل CustomerUserPhone و CustomerCompanyName و...).',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'الأعمدة التي يمكن تصفيتها في طريقة عرض المراقبة لواجهة العامل. ملاحظة: يسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) وسمات العميل (مثل CustomerUserPhone و CustomerCompanyName و...).',
        'Comment for new history entries in the customer interface.' => 'التعليق على إدخالات المحفوظات الجديدة في واجهة العميل.',
        'Comment2' => 'التعليق 2',
        'Communication' => 'التواصل',
        'Communication & Notifications' => 'الاتصالات والإخطارات',
        'Communication Log GUI' => 'مستخدم سجل الاتصالات',
        'Communication log limit per page for Communication Log Overview.' =>
            'الحد الأقصى لإدخالات السجل لكل صفحة في نظرة عامة على جميع بروتوكولات الاتصال.',
        'CommunicationLog Overview Limit' => 'نظرة عامة على سجل الاتصال المحدود',
        'Company Status' => 'حالة الشركة',
        'Company Tickets.' => 'تذاكر الشركة.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'اسم الشركة، الذي يجب تعيينه X-Header في رسائل البريد الإلكتروني الصادرة.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'وحدة انتقال AgentZoom إلى AgentTicketZoom.',
        'Complex' => 'معقد',
        'Compose' => 'كَتَبَ',
        'Configure Processes.' => 'تكوين العمليات.',
        'Configure and manage ACLs.' => 'تكوين قوائم التحكم في الوصول (ACL) وإدارتها.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'قم بتكوين أية قواعد بيانات متطابقة إضافية للقراءة فقط تريد استخدامها.',
        'Configure sending of support data to OTOBO Team for improved support.' =>
            'تكوين إرسال بيانات الدعم إلى فريق OTOBO لتحسين الدعم.',
        'Configure the About information.' => 'أدخل حول النص / بصمة.',
        'Configure the privacy policy.' => 'تحرير سياسة الخصوصية.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'تكوين الواجهة التي سيتم عرضها بعد إنشاء تذكرة جديدة.',
        'Configure your own log text for PGP.' => 'قم بتكوين نص السجل الخاص بك ل PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otobo.org/), chapter "Ticket Event Module".' =>
            'تكوين إعداد TicketDynamicField افتراضي. يعرف "الاسم" الحقل الديناميكي الذي يجب إستخدامه، و"القيمة" هي البيانات التي سيتم تعيينها، و"الحدث" يحدد حدث المشغل. يرجى التحقق من دليل المطور (/‎https://doc.otobo.org)، الفصل "Ticket Event Module".',
        'Controls how to display the ticket history entries as readable values.' =>
            'يتحكم في كيفية عرض إدخالات محفوظات التذاكر كقيم قابلة للقراءة.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            'يحدد ما إذا كان يتم تعيين عنوان المرسل تلقائيا كرقم عميل للعملاء غير المعروفين.',
        'Controls if CustomerID is read-only in the agent interface.' => 'تحديد ما إذا كان رقم العميل في منطقة العميل معروض كمقروء فقط.',
        'Controls if customers have the ability to sort their tickets.' =>
            'تحديد ما إذا كان بإمكان العملاء فرز التذاكر.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'يتحقق مما إذا كان يمكن تحديد أكثر من إدخال واحد في تذكرة هاتف جديدة.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'تحقق مما إذا كان المسؤول مسموح له باستيراد تكوين نظام محفوظ في SysConfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'تم التحقق من أن المسؤول لديه الإذن لإجراء تغييرات على قاعدة البيانات باستخدام AdminSelectBox.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            'التحكم في ما إذا كان سيتم إستخدام حقل الإكمال التلقائي لتحديد معرف العميل في واجهة AdminCustomerUser.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'التحكم في حالة إزالة علامات التذاكر والمقالة التي تم عرضها عند أرشفة التذكرة.',
        'Converts HTML mails into text messages.' => 'تحويل رسائل بريد HTML إلى رسائل نصية.',
        'Create New process ticket.' => 'إنشاء تذكرة عملية جديدة.',
        'Create Templates for AdminDynamicFieldTitle.' => 'إنشاء قوالب ل AdminDynamicFieldTitle.',
        'Create Ticket' => 'إنشاء تذكرة',
        'Create a new calendar appointment linked to this ticket' => 'إنشاء موعد تقويم جديد مرتبط بهذه التذكرة',
        'Create and manage Service Level Agreements (SLAs).' => 'إنشاء إتفاقيات مستوى الخدمة وإدارتها (SLA).',
        'Create and manage advanced definitions for ticket masks.' => '',
        'Create and manage agents.' => 'إنشاء الوكلاء وإدارتها.',
        'Create and manage appointment notifications.' => 'إنشاء وإدارة إشعارات المواعيد.',
        'Create and manage attachments.' => 'إنشاء المرفقات وإدارتها.',
        'Create and manage calendars.' => 'إنشاء التقاويم وإدارتها.',
        'Create and manage custom translations.' => '',
        'Create and manage customer users.' => 'إنشاء وإدارة مستخدمي العملاء.',
        'Create and manage customers.' => 'إنشاء العملاء وإدارتهم.',
        'Create and manage dynamic fields.' => 'إنشاء الحقول الديناميكية وإدارتها.',
        'Create and manage groups.' => 'إنشاء المجموعات وإدارتها.',
        'Create and manage queues.' => 'إنشاء قوائم الانتظار وإدارتها.',
        'Create and manage responses that are automatically sent.' => 'إنشاء الاستجابات التي يتم إرسالها تلقائيا وإدارتها.',
        'Create and manage roles.' => 'إنشاء الأدوار وإدارتها.',
        'Create and manage salutations.' => 'إنشاء التحية وإدارتها.',
        'Create and manage services.' => 'إنشاء الخدمات وإدارتها.',
        'Create and manage signatures.' => 'إنشاء التواقيع وإدارتها.',
        'Create and manage templates.' => 'إنشاء القوالب وإدارتها.',
        'Create and manage ticket notifications.' => 'إنشاء وإدارة إشعارات التذاكر.',
        'Create and manage ticket priorities.' => 'إنشاء أولويات التذاكر وإدارتها.',
        'Create and manage ticket states.' => 'إنشاء حالات التذاكر وإدارتها.',
        'Create and manage ticket types.' => 'إنشاء أنواع التذاكر وإدارتها.',
        'Create and manage web services.' => 'إنشاء خدمات ويب وإدارتها.',
        'Create new Ticket.' => 'إنشاء تذكرة جديدة.',
        'Create new appointment.' => 'إنشاء موعد جديد.',
        'Create new email ticket and send this out (outbound).' => 'قم بإنشاء تذكرة بريد إلكتروني جديدة وأرسلها (صادرة).',
        'Create new email ticket.' => 'إنشاء تذكرة بريد إلكتروني جديدة.',
        'Create new phone ticket (inbound).' => 'إنشاء تذكرة هاتف جديدة (واردة).',
        'Create new phone ticket.' => 'إنشاء تذكرة هاتف جديدة.',
        'Create new process ticket.' => 'إنشاء تذكرة عملية جديدة.',
        'Create tickets.' => 'إنشاء تذاكر.',
        'Create your first ticket' => 'أنشئ أول تذكرة لك',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            'تم إنشاء التذكرة [%s في "%s" مع الأولوية "%s" والحالة "%s".',
        'Croatian' => 'الكرواتية',
        'Custom CSS styles for RichText articles.' => '',
        'Custom RSS Feed' => 'موجز RSS المخصص',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'نص مخصص للعملاء الذين ليس لديهم تذاكر (إذا كنت تريد ترجمة لهذا النص، قم بإضافة الترجمة في وحدة ترجمة منفصلة).',
        'Customer Administration' => 'إدارة العملاء',
        'Customer Companies' => 'عملاء',
        'Customer Dashboard' => 'لوحة معلومات العميل',
        'Customer Dynamic Field Database Detailed Search' => 'البحث التفصيلي لقاعدة بيانات الحقل الديناميكي للعميل',
        'Customer Dynamic Field Database Details' => 'تفاصيل قاعدة بيانات الحقل الديناميكي للعميل',
        'Customer Dynamic Field Database Search' => 'بحث قاعدة بيانات الحقل الديناميكي للعميل',
        'Customer IDs' => 'معرفات العميل',
        'Customer Information Center Search.' => 'البحث في مركز معلومات العملاء.',
        'Customer Information Center search.' => 'البحث في مركز معلومات العملاء.',
        'Customer Information Center.' => 'مركز معلومات العملاء.',
        'Customer Password.' => 'كلمة مرور العميل.',
        'Customer Reference Dynamic Field With Data Search' => '',
        'Customer Ticket Print Module.' => 'وحدة طباعة تذاكر العملاء.',
        'Customer User Administration' => 'إدارة مستخدم العميل',
        'Customer User Information' => 'معلومات مستخدم العميل',
        'Customer User Information Center Search.' => 'البحث في مركز معلومات المستخدم للعميل.',
        'Customer User Information Center search.' => 'البحث في مركز معلومات مستخدم العميل.',
        'Customer User Information Center.' => 'مركز معلومات المستخدم للعملاء.',
        'Customer Users ↔ Customers' => 'المستخدمون العملاء ↔ العملاء',
        'Customer Users ↔ Groups' => 'المستخدمون العملاء ↔ المجموعات',
        'Customer Users ↔ Services' => 'مستخدمي العملاء ↔ الخدمات',
        'Customer dynamic field database detailed search.' => 'البحث التفصيلي لقاعدة بيانات الحقل الديناميكي للعميل.',
        'Customer dynamic field database details.' => 'تفاصيل قاعدة بيانات الحقل الديناميكي للعميل.',
        'Customer dynamic field database search.' => 'البحث في حقل قاعدة البيانات الديناميكية في منطقة العميل.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'عنصر العميل (الأيقونة) الذي يظهر التذاكر المغلقة لهذا العميل ككتلة معلومات. تعيين CustomerUserLogin إلى 1 عمليات بحث عن التذاكر استنادا إلى اسم تسجيل الدخول بدلا من معرف العميل.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'عنصر العميل (الأيقونة) الذي يظهر التذاكر المفتوحة لهذا العميل ككتلة معلومات. تعيين CustomerUserLogin إلى 1 عمليات بحث عن التذاكر استنادا إلى اسم تسجيل الدخول بدلا من معرف العميل.',
        'Customer preferences.' => 'إعدادات العملاء.',
        'Customer reference dynamic field with data search.' => '',
        'Customer ticket overview' => 'نظرة عامة على تذكرة العميل',
        'Customer ticket search.' => 'البحث عن تذكرة العميل.',
        'Customer ticket zoom' => 'طريقة عرض تذكرة العميل',
        'Customer user search' => 'بحث مستخدم العميل',
        'CustomerCompany' => '',
        'CustomerDashboard Info Tile' => '',
        'CustomerID search' => 'بحث عن رقم العميل',
        'CustomerName' => 'اسم العميل',
        'CustomerUser' => 'مستخدم العميل',
        'Customers ↔ Groups' => 'العملاء ↔ المجموعات',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'كلمات إيقاف قابلة للتخصيص لفهرس النص الكامل. ستتم إزالة هذه الكلمات من فهرس البحث.',
        'Czech' => 'التشيكية',
        'Danish' => 'دانماركي',
        'Dashboard overview.' => 'نظرة عامة على لوحة المعلومات.',
        'Data used to export the search result in CSV format.' => 'البيانات المستخدمة لتصدير نتيجة البحث بتنسيق CSV.',
        'Date / Time' => 'التاريخ / الوقت',
        'Default (Slim)' => 'افتراضي (نحيف)',
        'Default ACL values for ticket actions.' => 'قيم ACL الافتراضية لإجراءات التذكرة.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'بادئات الكيان الافتراضية لإدارة العملية لمعرفات الكيانات التي يتم إنشاؤها تلقائيا.',
        'Default agent name' => 'اسم الوكيل الافتراضي',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'البيانات الافتراضية المطلوب إستخدامها على السمة لشاشة البحث عن التذكرة. مثال: "‏TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'البيانات الافتراضية المطلوب إستخدامها على السمة لشاشة البحث عن التذكرة. مثال: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'نوع العرض الافتراضي لأسماء المستلمين (إلى، نسخة (To,Cc)) في AgentTicketZoom و CustomerTicketZoom.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'نوع العرض الافتراضي لأسماء المرسل (من (From)) في AgentTicketZoom و CustomerTicketZoom.',
        'Default loop protection module.' => 'وحدة "Loop Protection" الافتراضية.',
        'Default queue ID used by the system in the agent interface.' => 'معرف قائمة الانتظار الافتراضي المستخدم من قبل OTOBO في واجهة الوكيل.',
        'Default skin for the agent interface (slim version).' => 'واجهة الوكيل الافتراضية (الإصدار النحيف).',
        'Default skin for the agent interface.' => 'الجلد (skin) القياسي لواجهة الوكيل.',
        'Default skin for the customer interface.' => 'الجلد (skin) القياسي لواجهة العميل.',
        'Default ticket ID used by the system in the agent interface.' =>
            'معرف التذكرة القياسي الذي يستخدمه OTOBO في واجهة الوكيل.',
        'Default ticket ID used by the system in the customer interface.' =>
            'معرف التذكرة الافتراضي المستخدم من قبل OTOBO في واجهة العميل.',
        'Default value for NameX' => 'القيمة الافتراضية ل NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'تعريف العمليات التي يجب أن يتوفر بها زر الإعدادات في ودجة كائن الرابط (LinkObject::ViewMode = "complex"). الرجاء ملاحظة أنه يجب تسجيل ملفات JS و CSS التالية لهذه الإجراءات: Core.CustomList.css، Core.UI.AllocationList.js، Core.UI.Table.Sort.js، Core.Agent.TableFilter.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'يحدد عامل تصفية لإخراج HTML بإضافة روابط خلف سلسلة محددة. يسمح هذا العنصر بنوعين من الإدخال. الأول هو اسم صورة (على سبيل المثال faq.png). في هذه الحالة، يتم إستخدام مسار صورة OTOBO. الخيار الثاني هو إدراج الرابط إلى الصورة.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            'يحدد التعيين بين المتغيرات إلى بيانات مستخدم العميل (المفاتيح) والحقول الديناميكية للتذكرة (القيم). يتيح لك ذلك تخزين بيانات مستخدم العميل للتذكرة في الحقول الديناميكية. يجب أن تكون هذه الحقول الديناميكية موجودة في النظام ويجب تمكينها ل AgentTicketFreeText بحيث يمكن تعريفها / تحديثها يدويا بواسطة الوكيل. يجب عدم تمكينها ل AgentTicketPhone و AgentTicketEmail و AgentTicketCustomer. إذا فعلوا ذلك، فإنهم يأخذون الأسبقية على القيم المحددة تلقائيا. لاستخدام هذا التعيين، يجب أيضا تمكين إعداد تذكرة Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser.',
        'Define a result field for the TicketID of the invoker response per web service (WebserviceID => DynamicFieldName).' =>
            'حدد حقل نتيجة ل TicketID لاستجابة المستحضر (Invoker) عبر خدمة ويب (WebserviceID => DynamicFieldName).',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'تعريف اسم الحقل الديناميكي لوقت الانتهاء. يجب إضافة هذا الحقل يدويا إلى النظام كتذكرة: "التاريخ / الوقت" ويجب تنشيطه في شاشات إنشاء التذكرة و/أو في أي شاشات أخرى لإجراءات التذكرة.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'تعريف اسم الحقل الديناميكي لوقت البدء. يجب إضافة هذا الحقل يدويا إلى النظام كتذكرة: "التاريخ / الوقت" ويجب تنشيطه في شاشات إنشاء التذكرة و/أو في أي شاشات أخرى لإجراءات التذكرة.',
        'Define possible namespaces for dynamic fields. Must only contain alphanumeric characters. A namespace must not be longer than 64 characters. Namespace plus dynamic field name must not exceed 190 characters.' =>
            '',
        'Define the max depth of queues.' => 'حدد الحد الأقصى لعمق قوائم الانتظار.',
        'Define the queue comment 2.' => 'يحدد تعليق قائمة الانتظار 2.',
        'Define the service comment 2.' => 'حدد تعليق الخدمة 2.',
        'Define the sla comment 2.' => 'تعريف تعليق (sla) إتفاقية مستوى الخدمة 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'حدد يوم بدء الأسبوع لمنتقي التاريخ للتقويم المشار إليه.',
        'Define the start day of the week for the date picker.' => 'حدد يوم بدء الأسبوع لمنتقي التاريخ.',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'حدد الصورة الرمزية الافتراضية التي يجب استخدامها لعرض المقالة إذا لم يتم تعيين صورة رمزية لعنوان البريد. تحقق من https://gravatar.com/site/implement/images/ للحصول على مزيد من المعلومات.',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'حدد الصورة الرمزية الافتراضية التي يجب استخدامها للوكيل الحالي إذا لم يتم تعيين gravatar لعنوان البريد الخاص بالوكيل. تحقق من https://gravatar. com/site/implement/images/ للحصول على مزيد من المعلومات.',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            'حدد محرك الصور الرمزية الذي يجب إستخدامه للعامل أفاتار الموجود في الرأس وصور المرسل في AgentTicketZoom. في حالة تحديد \'بلا\'، سيتم عرض الأحرف الأولى بدلا من ذلك. الرجاء ملاحظة أن تحديد أي شيء بخلاف "لا شيء" سينقل عنوان البريد الإلكتروني المشفر للمستخدم المحدد إلى خدمة خارجية.',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'تحديد الأعمدة التي تظهر في عنصر واجهة مستخدم الموعد المرتبط (LinkObject::ViewMode = "معقد"). الإعدادات المحتملة: 0 = معطل، 1 = متوفر، 2 = ممكن بشكل افتراضي.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'تحديد الأعمدة التي تظهر في عنصر واجهة مستخدم التذاكر المرتبطة (LinkObject::ViewMode = "معقد"). ملاحظة: يسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) ل DefaultColumns.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'يعرف عنصر العميل الذي يضيف رمز LinkedIn في نهاية معلومات العميل.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'تحديد عنصر عميل، يقوم بإنشاء رمز XING في نهاية حظر معلومات العميل.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'تعريف عنصر عميل، الذي يقوم بإنشاء أيقونة Google في نهاية كتلة معلومات العميل.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'يعرف عنصر العميل الذي يضيف أيقونة خرائط جوجل في نهاية معلومات العميل.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'يحدد عامل تصفية لمخرجات html لإضافة إرتباطات خلف أرقام CVE. تتيح صورة العنصر نوعين من أنواع الإدخال. في الحال اسم صورة ما (مثل faq.png). في هذه الحالة سيتم إستخدام مسار صورة OTOBO. الاحتمال الثاني هو إدخال الرابط إلى الصورة.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'يحدد عامل تصفية لمخرجات html لإضافة إرتباطات خلف أرقام MSBulletin. تتيح صورة العنصر نوعين من أنواع الإدخال. في الحال اسم صورة ما (مثل faq.png). في هذه الحالة سيتم إستخدام مسار صورة OTOBO. الاحتمال الثاني هو إدخال الرابط إلى الصورة.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'تحديد عامل تصفية لإخراج html لإضافة إرتباطات خلف سلسلة معرفة. تتيح صورة العنصر نوعين من أنواع الإدخال. في الحال اسم صورة ما (مثل faq.png). في هذه الحالة سيتم إستخدام مسار صورة OTOBO. الاحتمال الثاني هو إدخال الرابط إلى الصورة.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'يحدد عامل تصفية لمخرجات html لإضافة إرتباطات خلف أرقام bugtraq. تتيح صورة العنصر نوعين من أنواع الإدخال. في الحال اسم صورة ما (مثل faq.png). في هذه الحالة سيتم إستخدام مسار صورة OTOBO. الاحتمال الثاني هو إدخال الرابط إلى الصورة.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'تحديد عامل تصفية لتجميع أرقام CVE من نصوص المقالات في AgentTicketZoom. ستظهر النتائج في مربع تعريف بجوار المقالة. قم بتعبئة مراجعة URLPreview إذا كنت ترغب في رؤية معاينة عند تحريك مؤشر الماوس فوق عنصر الارتباط. يمكن أن يكون عنوان URL نفسه كما في عنوان URL، ولكن أيضا عنوان بديل. يرجى ملاحظة أن بعض مواقع الويب تنفي عرضها ضمن إطار iframe (مثل Google) وبالتالي لن تعمل مع وضع المعاينة.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'يحدد عامل تصفية لمعالجة النص في المقالات، من أجل إبراز الكلمات الأساسية المعرفة مسبقا.',
        'Defines a permission context for customer to group assignment.' =>
            'يحدد سياق الإذن للعميل لتعيين المجموعة.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'تعريف تعبير عادي يستبعد بعض العناوين من فحص بناء الجملة (إذا تم تعيين "CheckEmailAddresses" إلى "نعم"). الرجاء إدخال تغيير في هذا الحقل لعناوين البريد الإلكتروني، التي لا تكون صالحة صناعيا، ولكنها ضرورية للنظام (أي "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'تعريف تعبير عادي يقوم بتصفية كافة عناوين البريد الإلكتروني التي يجب عدم إستخدامها في التطبيق.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'يحدد فترة زمنية، بالميكروثانية، للانتظار بين معالجة التذاكر.',
        'Defines a useful module to load specific user options or to display news.' =>
            'تعريف وحدة نمطية مفيدة لتحميل خيارات مستخدم معينة أو لعرض الأخبار.',
        'Defines all the X-headers that should be scanned.' => 'يحدد جميع رؤوس X المراد التحقق منها.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'تعريف كافة اللغات المتوفرة للتطبيق. حدد فقط أسماء اللغات باللغة الإنجليزية هنا.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'يحدد جميع اللغات المتاحة للتطبيق. أدخل أسماء اللغات الأصلية فقط.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'يحدد كافة المعلمات لكائن RefreshTime في إعدادات العميل لواجهة العميل.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'يحدد كافة المعلمات لكائن ShownTickets في إعدادات العميل لواجهة العميل.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'تحديد كافة المعلمات لهذا العنصر في إعدادات العميل.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'تعيين كافة المعلمات لهذا العنصر في إعدادات العميل. يمكن تعيين كلمات مرور \'PasswordRegExp\' في تعبير عادي. باستخدام \'PasswordMinSize\'، فإنك تعرف الحد الأدنى من طول كلمات المرور. حدد ما إذا كان يجب أن تحتوي كلمة المرور على حرفين صغيرين على الأقل وحرفين كبيرين بتعيين الخيار المرادف ل \'١\'. يحدد PasswordMin٢Chards أنه يلزم وجود حرفين على الأقل. \'PasswordNeedDigit\' يحدد أن كلمة المرور يجب أن تحتوي على رقم واحد على الأقل.',
        'Defines all the parameters for this notification transport.' => 'يتحكم في جميع المعلمات لنقل الإشعارات هذا.',
        'Defines all the possible stats output formats.' => 'يحدد جميع تنسيقات إخراج الإحصائيات الممكنة.',
        'Defines an alternate URL, where the login link refers to.' => 'يحدد عنوان URL بديلا يشير إليه رابط تسجيل الدخول.',
        'Defines an alternate URL, where the logout link refers to.' => 'يحدد عنوان URL بديلا يشير إليه ارتباط تسجيل الخروج.',
        'Defines an alternate login URL for the customer panel.' => '',
        'Defines an alternate logout URL for the customer panel.' => 'يحدد عنوان URL بديل لتسجيل الخروج لواجهة العميل التي يشير إليها ارتباط تسجيل الخروج.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'يعرف الاتصال الخارجي بقاعدة بيانات العميل (على سبيل المثال: \'http://yourhost/customer.php?CID=[٪ Data.CustomerID٪] أو \'\').',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            'يصف رمزا يحتوي على رابط إلى موقع خرائط Google على الويب مع الموقع الحالي كوجهة مقابلة في واجهة معالجة المواعيد.',
        'Defines an overview module to show the address book view of a customer user list.' =>
            'يحدد وحدة نمطية للنظرة العامة تعرض طريقة عرض دفتر عناوين لقائمة مستخدمي العملاء.',
        'Defines available article actions for Chat articles.' => 'يضبط إجراءات العناصر المتوفرة لعناصر الدردشة.',
        'Defines available article actions for Email articles.' => 'تعيين إجراءات المقالة المتاحة لعناصر البريد الإلكتروني.',
        'Defines available article actions for Internal articles.' => 'تعريف إجراءات المقالات المتاحة للمقالات الداخلية.',
        'Defines available article actions for Phone articles.' => 'تعريف إجراءات المقالات المتاحة لمقالات الهاتف.',
        'Defines available article actions for invalid articles.' => 'تعريف إجراءات المقالة المتوفرة للمقالات غير الصالحة.',
        'Defines available groups for the admin overview screen.' => 'تعيين المجموعات المتوفرة لنظرة عامة على المسؤول.',
        'Defines chat communication channel.' => 'يحدد قناة اتصال الدردشة.',
        'Defines default headers for outgoing emails.' => 'يضبط الرؤوس الافتراضية لرسائل البريد الإلكتروني الصادرة.',
        'Defines email communication channel.' => 'يحدد قناة اتصال البريد الإلكتروني.',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'تحديد سمات التذاكر التي يمكن للوكيل تحديد ترتيب النتائج منها.',
        'Defines groups for preferences items.' => 'يحدد المجموعات للإعدادات الشخصية.',
        'Defines how many deployments the system should keep.' => 'تحديد عدد عمليات النشر التي يجب على النظام الاحتفاظ بها.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'يحدد الشكل الذي يجب أن يبدو عليه الحقل "من:" في رسائل البريد الإلكتروني (المرسلة من الردود وتذاكر البريد الإلكتروني).',
        'Defines if CSV-mappings are re-created on next package reinstallation or upgrade if already existent.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'تحديد ما إذا كان يجب فرز عرض قائمة الانتظار مسبقا حسب الأولوية.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'تحديد ما إذا كان يجب إجراء الفرز المسبق حسب الأولوية في طريقة عرض الخدمة.',
        'Defines if a ticket lock is required for the quick close.' => 'تحديد ما إذا كان تأمين التذكرة مطلوبا للإغلاق السريع أم لا.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تحديد ما إذا كان تأمين التذكرة مطلوبا في شاشة تذكرة الإغلاق الخاصة بواجهة الوكيل (إذا لم تكن التذكرة مؤمنة بعد، يتم تأمين التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تحديد ما إذا كان تأمين التذكرة مطلوبا في شاشة البريد الإلكتروني الصادرة لواجهة الوكيل (إذا لم تكن التذكرة مؤمنة بعد، يتم تأمين التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تحديد ما إذا كان تأمين التذكرة مطلوبا في شاشة إعادة إرسال البريد الإلكتروني لواجهة العميل (إذا لم تكن التذكرة مؤمنة بعد، يتم تأمين التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب حظر التذكرة. يتم حظر التذكرة (إذا لزم الأمر) ويتم تعيين الوكيل الحالي كمالك.',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تحديد ما إذا كان تأمين التذكرة مطلوبا في شاشة تكوين التذكرة لواجهة الوكيل (إذا لم تكن التذكرة مؤمنة بعد، يتم تأمين التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تحديد ما إذا كان تأمين التذكرة مطلوبا في الشاشة الأمامية للتذكرة الخاصة بواجهة الوكيل (إذا لم تكن التذكرة مؤمنة بعد، يتم تأمين التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تحديد ما إذا كان تأمين التذكرة مطلوبا في شاشة النص الحر للتذكرة الخاصة بواجهة الوكيل (إذا لم تكن التذكرة مؤمنة بعد، يتم تأمين التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب قفل التذكرة. سيتم حظر التذكرة (إذا لزم الأمر) وسيتم تعيين الوكيل الحالي كمالك.',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كان قفل التذكرة مطلوبا في شاشة ملاحظة التذكرة لواجهة الوكيل (إذا لم تكن التذكرة مقفلة بعد، قفل التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب قفل التذكرة. سيتم حظر التذكرة (إذا لزم الأمر) وسيتم تعيين الوكيل الحالي كمالك.',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تحديد ما إذا كان تأمين التذكرة مطلوبا في شاشة التذكرة المعلقة في واجهة الوكيل (إذا لم تكن التذكرة مؤمنة بعد، يتم تأمين التذكرة وسيتم تعيين الوكيل الحالي تلقائيا كمالك لها).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب قفل التذكرة. سيتم حظر التذكرة (إذا لزم الأمر) وسيتم تعيين الوكيل الحالي كمالك.',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب قفل التذكرة. سيتم حظر التذكرة (إذا لزم الأمر) وسيتم تعيين الوكيل الحالي كمالك.',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب قفل التذكرة. سيتم حظر التذكرة (إذا لزم الأمر) وسيتم تعيين الوكيل الحالي كمالك.',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب قفل التذكرة. سيتم حظر التذكرة (إذا لزم الأمر) وسيتم تعيين الوكيل الحالي كمالك.',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'يحدد ما إذا كانت هذه الشاشة في واجهة الوكيل تتطلب قفل التذكرة. سيتم حظر التذكرة (إذا لزم الأمر) وسيتم تعيين الوكيل الحالي كمالك.',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'يتحكم في ما إذا كان الوكلاء الذين لم يخزنوا سرًا مشتركًا في إعداداتهم وبالتالي لا يستخدمون المصادقة الثنائية مسموح لهم بتسجيل الدخول إلى النظام.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'يتحكم في ما إذا كان يُسمح للعملاء الذين لم يخزنوا سرًا مشتركًا في إعداداتهم وبالتالي لا يستخدمون المصادقة الثنائية بتسجيل الدخول إلى النظام.',
        'Defines if parent-child translations for queues and services should be generated automatically.' =>
            '',
        'Defines if the communication between this system and the servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as support data sending, Package Verify™ and product News dashboard widgets, among others.' =>
            'يحدد ما إذا كان هذا النظام يمكنه الاتصال بالخوادم التي تقدم خدمات سحابية. إذا قمت بإلغاء تنشيط الخدمات السحابية هنا، فستفقد بعض الوظائف مثل إرسال بيانات الدعم والتحقق™ من الحزمة وأداة لوحة معلومات "أخبار المنتج".',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            'يحدد ما إذا كان يجب إستخدام الوضع المتقدم (تمكين إستخدام الجدول، الاستبدال، الكتابة السفلية، الإعداد، العمق، إدخال الكلمات، إلخ) في واجهة العميل.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'تحديد ما إذا كان يجب إستخدام الوضع المتقدم (تمكين إستخدام الجدول، البحث والاستبدال، الحفر، الإعداد، الإدراج من Word، إلخ.).',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            'تحديد ما إذا كان يجب عرض أول عنصر مرئي للعميل عند فتح عرض النظرة العامة. إذا لم يتم تحديد أي شيء، سيتم عرض أحدث مقال.',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            'تحديد ما إذا كانت الرسالة الموجودة في شاشة البريد الإلكتروني الصادرة لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            'تحديد ما إذا كانت الرسالة في شاشة إعادة إرسال البريد الإلكتروني لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            'يحدد ما إذا كانت الرسالة في شاشة إنشاء التذاكر لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            'يحدد ما إذا كانت الرسالة في شاشة إعادة توجيه التذكرة لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            'يحدد ما إذا كانت الملاحظة الموجودة في شاشة إغلاق التذكرة لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            'يشير إلى ما إذا كان يجب أن تكون الملاحظة مرئية للعميل في شاشة معالجة مجموعة التذاكر الخاصة بلوحة الوكيل بشكل افتراضي.',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            'تحديد ما إذا كانت الملاحظة الموجودة في شاشة النص الحر للتذكرة الخاصة بواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            'تحديد ما إذا كانت الملاحظة الموجودة في شاشة إشعار التذكرة لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            'تحديد ما إذا كانت الملاحظة الموجودة في شاشة مالك التذكرة الخاصة بواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            'يحدد ما إذا كانت الملاحظة الموجودة في شاشة انتظار التذكرة لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            'تحديد ما إذا كانت الملاحظة الموجودة في شاشة أولوية التذكرة لواجهة الوكيل مرئية للعميل بشكل افتراضي.',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            'يحدد ما إذا كانت الملاحظة الموجودة في شاشة مسؤول التذكرة لواجهة الوكيل مرئية للعميل افتراضيا.',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'تحديد ما إذا كان يجب قبول الرمز المميز الصالح سابقا للمصادقة. وهذا الأمر أقل أمانا بعض الشيء ولكنه يمنح المستخدمين 30 ثانية إضافية من الوقت لإدخال كلمة المرور مرة واحدة.',
        'Defines if the ticket info widget is displayed permanently on the left below the article list or is available via click on the \'Information\' button.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'تحديد ما إذا كان سيتم إسترداد قيم المرشح من كافة التذاكر المتوفرة أم لا. عند التمكين، تكون القيم المستخدمة حاليا في أي تذكرة فقط متاحة للتصفية. الرجاء ملاحظة: سيتم دائما إسترداد قائمة العملاء بهذه الطريقة.',
        'Defines if time accounting is mandatory in the agent interface, if a note is entered.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'تحديد ما إذا كان يجب تعيين حساب الوقت إلى كافة التذاكر قيد الإجراء المجمع.',
        'Defines if user can modify all possible values/labels of dynamic fields in one data table.' =>
            '',
        'Defines internal communication channel.' => 'يحدد قناة الاتصال الداخلية.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'يعرف قوالب الرسائل "ليس في المكتب". تتوفر معلمات سلسلة (%s): تاريخ الانتهاء وعدد الأيام المتبقية.',
        'Defines phone communication channel.' => 'يحدد قناة الاتصال الهاتفي.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'يحدد قوائم الانتظار التي تستخدم التذاكر لعرضها كأحداث تقويم.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'يحدد اسم مضيف HTTP لجمع بيانات الدعم باستخدام الوحدة النمطية العامة "PublicSupportDataCollector" (على سبيل المثال المستخدمة من OTOBO Daemon).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'يحدد التعبيرات العادية لعناوين IP للوصول إلى المستودع المحلي. يجب تمكين هذه الإعدادات للوصول إلى المستودع المحلي الخاص بك، ويجب أيضا تثبيت حزمة package::RepositoryList على المضيف البعيد.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            'تعريف رأس PostMaster الذي سيتم إستخدامه على عامل التصفية للاحتفاظ بالحالة الحالية للتذكرة.',
        'Defines the URL CSS path.' => 'يعرف مسار URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'تعريف المسار الأساسي ل URL الخاص بالأيقونات و CSS و Java Script.',
        'Defines the URL image path of icons for navigation.' => 'تعريف مسار صورة عنوان URL الخاص بالأيقونات للتنقل.',
        'Defines the URL java script path.' => 'يعرف عنوان URL لمسار JavaScript.',
        'Defines the URL rich text editor path.' => 'تعريف مسار محرر نص URL المنسق.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'تعريف عنوان خادم DNS مخصص، إذا لزم الأمر، لعمليات البحث "CheckMXRecord".',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'تعريف مفتاح تفضيلات الوكيل حيث يتم تخزين المفتاح السري المشترك.',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            'يضبط الخطوات المتوفرة في حقول تحديد الوقت. حدد "دقائق" لتحديد كل دقيقة من ساعة واحدة من ١-٥٩. أختر "٣٠ دقيقة" لتحديد ساعات كاملة ونصف فقط.',
        'Defines the body for the quick close action, which gets used for ticket history in the agent interface.' =>
            'يحدد النص الأساسي لإجراء "الإغلاق الفوري"، والذي يستخدم في سجل التذاكر في منطقة الوكيل.',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            'يعرف النص الموجود في قسم رسائل البريد الإلكتروني الخاصة بالإخطار إلى العملاء فيما يتعلق بكلمة المرور الجديدة.',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            'يحدد نص البريد الإلكتروني للإعلام المرسل إلى الوكلاء عند تقديم طلب كلمة مرور.',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'يحدد النص الموجود في النص الأساسي لرسائل البريد الإلكتروني للإشعارات المرسلة إلى العملاء حول حساب جديد.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            'يحدد النص الموجود في النص الأساسي لرسائل البريد الإلكتروني للإشعارات للعملاء فيما يتعلق بكلمة المرور الجديدة.',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            'يعرف نص رسائل البريد الإلكتروني للإخطار مع الرمز المميز لكلمة المرور الجديدة التي يتم إرسالها إلى العملاء.',
        'Defines the body text for rejected emails.' => 'يحدد النص الأساسي لرسائل البريد الإلكتروني المرفوضة.',
        'Defines the calendar width in percent. Default is 95%.' => 'تعريف عرض التقويم بالنسبة المئوية. الافتراضي هو 95٪.',
        'Defines the close state for quick close.' => 'يعرف حالة الإغلاق ل "إغلاق فوري".',
        'Defines the column to store the keys for the preferences table.' =>
            'يعرف العمود الذي يجب أن يتم فيه تخزين مفاتيح الجدول مع الإعدادات.',
        'Defines the communication chanel for the quick close article action.' =>
            'يحدد قناة الاتصال لإجراء العنصر "إغلاق فوري".',
        'Defines the config options for the autocompletion feature.' => 'تعريف خيارات التكوين لميزة الإكمال التلقائي.',
        'Defines the config parameters available in the preferences view. The default redirect URL from SysConfig \'MarkTicketSeenRedirectDefaultURL\' is used if no selection is made by the agent.' =>
            '',
        'Defines the config parameters available in the preferences view. The default redirect URL from SysConfig \'MarkTicketUnseenRedirectDefaultURL\' is used if no selection is made by the agent.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'تعريف معلمات التكوين لهذا العنصر، ليتم عرضها في إعدادات المستخدم.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'يحدد معلمات التكوين للعنصر الذي يتم عرضه في إعداد المستخدم. يسمح لك PasswordRegExp بالتحقق من كلمات المرور مقابل التعبير العادي. اضبط الحد الأدنى لطول كلمة المرور باستخدام "PasswordMinSize". حدد ما إذا كان يجب أن تحتوي كلمة المرور على حرفين صغيرين على الأقل وحرفين كبيرين عن طريق تعيين الخيار المقابل على "1". يحدد "PasswordMin2Characters" أن هناك حاجة إلى حرفين على الأقل (القيم المحتملة هي "0" أو "1"). يحدد "PasswordNeedDigit" ما إذا كان يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (القيم المحتملة هي "0" أو "1"). يسمح "PasswordMaxLoginFailed" للوكيل بأن يكون غير صالح مؤقتا عند الوصول إلى الحد الأقصى لعدد عمليات تسجيل الدخول الفاشلة. يرجى ملاحظة: إذا تم تعيين "نشط" على 0، فهذا يمنع الوكلاء فقط من تغيير إعداد هذه المجموعة في إعداداتهم الشخصية. لا يزال بإمكان المسؤول تغيير هذه الإعدادات نيابة عن المستخدمين. استخدم "PreferenceGroup" للتحكم في المنطقة التي يتم فيها عرض هذه الإعدادات في واجهة المستخدم.',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'يحدد معلمات التكوين للعنصر الذي يتم عرضه في إعداد المستخدم. يرجى ملاحظة: إذا تم تعيين "نشط" على 0، فهذا يمنع الوكلاء فقط من تغيير إعداد هذه المجموعة في إعداداتهم الشخصية. لا يزال بإمكان المسؤول تغيير هذه الإعدادات نيابة عن المستخدمين. استخدم "PreferenceGroup" للتحكم في المنطقة التي يتم فيها عرض هذه الإعدادات في واجهة المستخدم.',
        'Defines the connections for http/ftp, via a proxy.' => 'تعريف الاتصالات ل http/ftp، عبر وكيل.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'يعرف حقل إعدادات العميل حيث يتم تخزين المفتاح السري المشترك.',
        'Defines the data objects avaliable to be translated.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            'يعرف تنسيق إدخال التاريخ المستخدم في النماذج (حقول الخيار أو الإدخال).',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            'يحدد اسم الوكيل الافتراضي في عرض تفاصيل التذاكر لواجهة العميل.',
        'Defines the default auto response type of the article for this operation.' =>
            'يحدد نوع الاستجابة التلقائية الافتراضي للعنصر لهذه العملية.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'يحدد المحتوى الافتراضي للملاحظة في شاشة النص الحر للتذكرة الخاصة في واجهة الوكيل.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            'يحدد حقول التصفية الافتراضية في البحث في دفتر عناوين مستخدم العميل (مستخدم عميل أو شركة عميل). بالنسبة لحقول CustomerCompany، يجب إضافة بادئة "CustomerCompany_".',
        'Defines the default frontend (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otobo.org/.' =>
            '',
        'Defines the default frontend language. All the possible values are determined by the available language files on the system. These values are listed as the keys in the setting \'DefaultUsedLanguages\'.' =>
            '',
        'Defines the default history type in the customer interface.' => 'يحدد نوع المحفوظات الافتراضي في واجهة العميل.',
        'Defines the default interface. Unknown pathes below the script alias are redirected to the selected interface.' =>
            'يحدد الواجهة الافتراضية. تتم إعادة توجيه المسارات غير المعروفة أسفل الاسم المستعار للبرنامج النصي إلى الواجهة المحددة.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'يعرف الحد الأقصى الافتراضي للسمات لمحور x للمحور الزمني.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'يتحكم في الحد الأقصى لعدد الإحصائيات المعروضة لكل صفحة في النظرة العامة.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'تحديد الحالة التالية الافتراضية للتذكرة بعد متابعة العميل في واجهة العميل.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إضافة ملاحظة، في شاشة إغلاق التذكرة لواجهة الوكيل.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إضافة ملاحظة، في شاشة النص الحر للتذكرة لواجهة الوكيل.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إضافة ملاحظة، في شاشة ملاحظة التذكرة لواجهة الوكيل.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إضافة ملاحظة إلى شاشة المالك في واجهة العميل.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إضافة ملاحظة، في شاشة التذكرة المعلقة لتذكرة مكبرة في واجهة الوكيل.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إضافة ملاحظة لها إلى شاشة الأولوية في واجهة الوكيل.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إضافة ملاحظة، في شاشة مسؤول التذكرة لواجهة الوكيل.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'تعيين حالة التسلسل للتذاكر التي تحتوي على ملاحظة مضافة إلى شاشة إعادة التوجيه في واجهة العميل.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة التي تمت إضافة ملاحظة لها إلى شاشة إعادة التوجيه في واجهة الوكيل.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة بعد إرسال الرسالة، في شاشة البريد الإلكتروني الصادر لواجهة الوكيل.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'يحدد الحالة التالية الافتراضية للتذكرة إذا تم تكوينها / الرد عليها في شاشة تكوين التذكرة لواجهة الوكيل.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'يحدد الحالة الافتراضية التالية للتذكرة، في شاشة التذاكر المجمعة لواجهة الوكيل.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'يحدد النص الأساسي الافتراضي للملاحظة لتذاكر الهاتف في شاشة هاتف التذاكر الواردة لواجهة الوكيل.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'يحدد الإعداد الافتراضي لمربع نص تذكرة الهاتف على شاشة المكالمة الصادرة في واجهة الوكيل.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'يتحكم في أولوية المتابعة للتذاكر التي تم استلام طلب العميل عليها في منطقة العميل.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'يحدد الأولوية الافتراضية لتذاكر العملاء الجدد في واجهة العميل.',
        'Defines the default priority of new tickets.' => 'يحدد الأولوية الافتراضية للتذاكر الجديدة.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'يحدد قائمة الانتظار الافتراضية لتذاكر العملاء الجدد في واجهة العميل.',
        'Defines the default queue for new tickets in the agent interface.' =>
            'تحديد قائمة الانتظار الافتراضية للتذاكر الجديدة في واجهة الوكيل.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'يحدد التحديد الافتراضي في التحديد الفردي للكائنات الديناميكية (النموذج: مواصفات أكثر دقة).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'يعرف التحديد الافتراضي في القائمة المنسدلة الأذونات (نموذج المواصفات العامة).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'يحدد التحديد الافتراضي في القائمة المنسدلة لتنسيق الإحصائيات (النموذج: المواصفات العامة). الرجاء إدراج مفتاح التنسيق (انظر الإحصائيات::التنسيق).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'يضبط نوع المرسل الافتراضي لتذاكر الهاتف في عرض التذاكر الواردة في واجهة الوكيل.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'تحديد نوع المرسل الافتراضي لتذاكر الهاتف في شاشة الصادر لهاتف التذكرة لواجهة الوكيل.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'يحدد نوع المرسل الافتراضي للتذاكر في شاشة تكبير/تصغير التذاكر لواجهة الوكيل.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'يحدد سمات البحث عن التذاكر التي يتم عرضها افتراضيًا للبحث عن التذاكر.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'يحدد سمات البحث الافتراضية للبحث عن التذاكر مثال: يجب أن يحتوي "المفتاح" على اسم الحقل الديناميكي، وفي هذه الحالة "X"، يجب أن يحتوي "المحتوى" على قيمة الحقل الديناميكي، اعتمادا على نوع الحقل، النص: "نص"، القائمة المنسدلة: "1"، التاريخ / الوقت: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week;.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'تحديد معايير الفرز الافتراضية لكل قوائم الانتظار المعروضة في عرض قائمة الانتظار.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'تحديد معايير الفرز الافتراضية لكافة الخدمات المعروضة في عرض الخدمة.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'يحدد ترتيب الفرز الافتراضي لكل قوائم الانتظار في طريقة عرض قائمة الانتظار، بعد فرز الأولوية.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'يحدد ترتيب الفرز الافتراضي لكافة الخدمات في طريقة عرض الخدمة، بعد فرز الأولوية.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'تحديد الحالة الافتراضية لتذاكر العملاء الجديدة في واجهة العميل.',
        'Defines the default state of new tickets.' => 'يحدد الحالة الافتراضية للتذاكر الجديدة.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'يحدد الموضوع الافتراضي لتذاكر الهاتف في عرض تذاكر الهاتف الواردة في واجهة الوكيل.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'يحدد الموضوع الافتراضي لتذاكر الهاتف في شاشة هاتف التذاكر الصادرة لواجهة الوكيل.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'يحدد الموضوع الافتراضي للملاحظة في شاشة النص الحر للتذكرة لواجهة الوكيل.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'يحدد عدد الثواني (بناءً على الوقت الحالي) التي يجب بعدها إعادة جدولة مهمة الواجهة العامة الفاشلة.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'يحدد سمة التذكرة الافتراضية لفرز التذاكر في البحث عن التذاكر في واجهة العميل.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'تعيين سمة التذاكر الافتراضية لفرز التذاكر في شاشة التصعيد في واجهة الوكيل.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'تعريف سمة التذكرة الافتراضية لفرز التذكرة في طريقة عرض التذكرة المقفلة لواجهة الوكيل.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'يحدد سمة التذكرة الافتراضية لفرز التذاكر في العرض المسؤول في واجهة الوكيل.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'يحدد سمة التذكرة الافتراضية لفرز التذاكر في عرض الحالة في واجهة الوكيل.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'يضبط سمة التذاكر الافتراضية لفرز التذاكر في عرض المراقبة في واجهة الوكيل.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'تعريف سمة التذكرة الافتراضية لفرز التذكرة لنتيجة البحث عن التذكرة في واجهة الوكيل.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'يحدد سمة التذكرة الافتراضية لفرز التذاكر في نتيجة البحث في التذاكر لهذه العملية.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'يحدد الإشعار الافتراضي للتذاكر المعاد توجيهها للعملاء/المرسلين في شاشة إعادة التوجيه لواجهة الوكيل.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'يتحكم في حالة التذكرة بعد إضافة ملاحظة من شاشة "مكالمة صادرة" في منطقة الوكيل.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'يحدد الحالة التالية للتذكرة الافتراضية بعد إضافة ملاحظة هاتفية في شاشة هاتف التذاكر الصادرة لواجهة الوكيل.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'يحدد ترتيب التذاكر الافتراضي (بعد فرز الأولوية) في طريقة عرض التصعيد لواجهة الوكيل. أعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'يحدد ترتيب التذكرة الافتراضي (بعد فرز الأولوية) في عرض الحالة لواجهة الوكيل. للأعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'يحدد ترتيب التذاكر الافتراضي (بعد فرز الأولوية) في عرض الحالة لواجهة العامل. أعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'يحدد ترتيب التذاكر الافتراضي في طريقة عرض تأمين التذكرة لواجهة الوكيل. أعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'يحدد ترتيب التذاكر الافتراضي في نتيجة البحث عن التذاكر لواجهة الوكيل. أعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'يحدد ترتيب التذاكر الافتراضي في نتيجة البحث عن التذاكر لهذه العملية. أعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'يتحكم في فرز التذاكر الافتراضي في طريقة عرض المراقبة لواجهة الوكيل. أعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'يحدد ترتيب التذاكر الافتراضي لنتيجة بحث في واجهة العميل. أعلى: الأقدم في الأعلى. أسفل: الأحدث في الأعلى.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'يحدد أولوية التذكرة الافتراضية في واجهة "إغلاق" في واجهة الوكيل.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'يحدد أولوية التذكرة الافتراضية في واجهة "الإجراء المجمع" في واجهة الوكيل.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'تحدد أولوية التذكرة الافتراضية في لوحة "الحقول الحرة" في واجهة الوكيل.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'يحدد أولوية التذكرة الافتراضية في واجهة "ملاحظة" في واجهة الوكيل.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'يحدد أولوية التذكرة الافتراضية في واجهة "المالك" في TicketZoom في واجهة الوكيل.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'يحدد أولوية التذكرة الافتراضية في واجهة "الانتظار" في TicketZoom في واجهة الوكيل.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'يحدد أولوية التذكرة الافتراضية في واجهة "الأولوية" في TicketZoom في واجهة الوكيل.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'يحدد أولوية التذكرة الافتراضية في واجهة "المسؤول" في TicketZoom في واجهة الوكيل.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'يحدد نوع التذكرة الافتراضي لتذاكر العملاء الجدد في واجهة العميل.',
        'Defines the default ticket type.' => 'يحدد النوع الافتراضي للتذكرة.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'يحدد وحدة الواجهة الأمامية المستخدمة افتراضيًا في واجهة الوكيل إذا لم يتم تمرير أي معلمة إجراء في عنوان URL.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'يحدد وحدة الواجهة الأمامية المستخدمة افتراضيًا في واجهة العميل إذا لم يتم تمرير أي معلمة إجراء في عنوان URL.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'يحدد القيمة الافتراضية لمعلمة الإجراء للواجهة الأمامية العامة. يتم استخدام معلمة الإجراء في البرامج النصية للنظام.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'يحدد أنواع المرسلين المرئيين الافتراضية للتذكرة (الافتراضي: العميل).',
        'Defines the default visibility of the article to customer for this operation.' =>
            'يحدد الرؤية الافتراضية للمقالة للعميل لهذه العملية.',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            'يحدد النمط المعروض بواسطة الحقل "من" في الملاحظات المرئية للعملاء. يمكن تعريف اسم الوكيل الافتراضي في إعداد ‎Ticket::Frontend::CustomerTicketZoom###DefaultAgentName.',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'يحدد الحقول الديناميكية المستخدمة لعرض أحداث التقويم.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            'تحديد أنواع كائن الحدث التي تتم معالجتها عبر AdminAppointmentNotificationEvent.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'يحدد المسار الاحتياطي لفتح ثنائي جلب البريد. ملاحظة: يجب أن يكون اسم الثنائي "fetchmail"، إذا كان مختلفا، فيرجى استخدام رابط رمزي.',
        'Defines the filter that processes the HTML templates.' => 'تعريف عامل التصفية الذي يعالج قوالب HTML.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'يحدد عامل التصفية الذي يعالج النص في المقالات، من أجل تسليط الضوء على عناوين URL.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'يتحكم في تنسيق الإجابات في شاشة إنشاء التذاكر في منطقة العميل ([% Data.OrigFrom | html %] يتوافق تماما مع المرسل، [% Data.OrigFromName | html %] يحتوي على الاسم الحقيقي للمرسل فقط).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTOBO_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'يحدد اسم المجال المؤهل بالكامل للنظام. يتم استخدام هذا الإعداد كمتغير، OTOBO_CONFIG_FQDN الموجود في جميع أشكال الرسائل التي يستخدمها التطبيق ، لإنشاء روابط للتذاكر داخل نظامك.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            'يتحكم في المجموعات التي تريد أن يكون مستخدم العميل فيها بشكل افتراضي (إذا تم تمكين CustomerGroupSupport ولا تريد التحكم في كل علاقة مجموعة للمستخدمين بشكل فردي).',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            'يتحكم في المجموعات التي تريد أن يكون العميل فيها بشكل افتراضي (إذا تم تمكين CustomerGroupSupport ولا تريد التحكم في كل علاقة مجموعة للعملاء بشكل فردي).',
        'Defines the headers which will be shown to generic content for the requested key.' =>
            'يحدد الرؤوس التي يتم عرضها للمحتوى العام للقيمة المطلوبة.',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'يتحكم في ارتفاع مكون محرر النص المنسق. أدخل رقمًا (للارتفاع بالبكسل) أو نسبة مئوية (لارتفاع نسبي).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'يتحكم في تعليق محفوظات إجراءات إغلاق التذاكر في واجهة الوكيل.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'يتحكم في تعليق المحفوظات لتذاكر البريد الإلكتروني في واجهة الوكيل.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'يتحكم في تعليق المحفوظات لتذكرة الهاتف في واجهة الوكيل.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'يتحكم في تعليق المحفوظات لإجراء النص الحر في واجهة الوكيل.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق المحفوظات لإجراء شاشة ملاحظة التذاكر، والذي يتم استخدامه لمحفوظات التذاكر في واجهة الوكيل.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق المحفوظات لإجراء "مالك التذكرة" الذي يتم عرضه في محفوظات التذكرة في واجهة الوكيل.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق المحفوظات لإجراء "انتظار التذكير"، والذي يتم عرضه في سجل التذاكر في واجهة الوكيل.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق المحفوظات لإجراء "مكالمة هاتفية واردة"، والذي يتم عرضه في محفوظات التذاكر في واجهة الوكيل.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق المحفوظات لإجراء "مكالمة هاتفية صادرة"، والذي يتم عرضه في محفوظات التذاكر في واجهة الوكيل.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق المحفوظات لإجراء "أولوية التذكرة"، والذي يتم عرضه في محفوظات التذاكر في واجهة الوكيل.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق السجل لإجراء "مالك التذكرة"، والذي يتم عرضه في سجل التذاكر في واجهة الوكيل.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'يحدد تعليق المحفوظات لإجراء "انتظار التذكير"، والذي يتم عرضه في سجل التذاكر في واجهة الوكيل.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'يحدد تعليق المحفوظات لهذه العملية المستخدمة لتاريخ التذاكر في واجهة العميل.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'يعرف نوع المحفوظات للإجراء "إقفال التذاكر"، المستخدم لتاريخ التذاكر في واجهة العميل.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "تذكرة بريد إلكتروني جديدة"، والذي يتم استخدامه لمحفوظات التذاكر في واجهة الوكيل.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "تذكرة هاتف جديدة"، والذي يتم استخدامه لمحفوظات التذاكر في واجهة الوكيل.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'يحدد نوع السجل لإجراء "Ticket FreeText" ، والذي يتم استخدامه لتاريخ التذاكر في واجهة العميل.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "ملاحظة التذكرة"، والذي يستخدم لتاريخ التذاكر في واجهة العميل.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "مالك التذكرة"، والذي يتم استخدامه لسجل التذاكر في واجهة الوكيل.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "انتظار التذكير"، والذي يتم استخدامه لمحفوظات التذاكر في واجهة الوكيل.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "مكالمة هاتفية واردة"، والذي يتم استخدامه لسجل التذاكر في واجهة الوكيل.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "مكالمة هاتفية صادرة"، والذي يتم استخدامه لتاريخ التذاكر في واجهة العميل.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لإجراء "أولوية التذكرة"، والذي يتم استخدامه لمحفوظات التذاكر في واجهة الوكيل.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'يعرف نوع المحفوظات للإجراء "مسؤولية التذاكر"، الذي يتم إستخدامه لتاريخ التذاكر في واجهة العميل.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'يحدد نوع سجل إجراءات تكبير التذاكر المستخدم لسجل التذاكر في واجهة العميل.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'يحدد نوع السجل لهذه العملية، والذي يتم استخدامه لمحفوظات التذكرة في واجهة الوكيل.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'يحدد ساعات وأيام الأسبوع من التقويم المحدد لقياس وقت العمل.',
        'Defines the hours and week days to count the working time.' => 'يحدد فترة وأيام الأسبوع التي يتم احتسابها كوقت عمل.',
        'Defines the initial height in pixels for the rich text editor component for this screen.' =>
            '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'يحدد المفتاح الذي تم تحديده باستخدام الوحدة النمطية Kernel::Modules::AgentInfo. إذا كان مفتاح تفضيلات المستخدم هذا "صحيح"، فسيتم قبول الرسالة من قبل النظام.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'تحديد المفتاح المراد التحقق منه مع CustomerAccept. إذا كان مفتاح تفضيلات المستخدم هذا صحيحا، فسيتم قبول الرسالة من قبل النظام.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'يحدد نوع الرابط "عادي". إذا كان اسم المصدر هو نفس اسم الوجهة، فإن الرابط الناتج هو رابط غير اتجاهي؛ خلاف ذلك، فإن النتيجة هي ارتباط اتجاهي.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'يحدد نوع الارتباط "ParentChild". إذا كان اسمي المصدر والهدف يحتويان على نفس القيمة، يكون الارتباط غير اتجاهي. خلاف ذلك، فإن النتيجة هي ارتباط اتجاهي.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'تعريف مختلف خيارات الربط. أنواع الارتباط من نفس المجموعة حصرية بشكل متبادل. على سبيل المثال، إذا كانت التذكرة "أ" مرتبطة بالنوع "عادي" بالتذكرة "ب"، فلا يمكن ربط هاتين التذاكر بنوع "ParentChild".',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'تعريف قائمة المستودعات عبر الإنترنت. يمكن إستخدام عمليات تثبيت أخرى كمستودع، على سبيل المثال: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" و Content="Some Name".',
        'Defines the list of params that can be passed to ticket search function.' =>
            'يحدد قائمة المعلمات التي يمكن تمريرها إلى وظيفة البحث عن التذاكر.',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'يحدد قائمة إجراءات المتابعة المحتملة في عرض الأخطاء. باستخدام مسار كامل، يمكنك إدراج روابط خارجية إذا لزم الأمر.',
        'Defines the list of types for templates.' => 'يحدد قائمة الأنواع للقوالب.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'تحديد عنوان قائمة المستودع عبر الإنترنت للحزم الإضافية. سيتم إستخدام النتيجة الأولى المتوفرة.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'يحدد وحدة السجل للنظام. يكتب "ملف" جميع الرسائل إلى ملف السجل المحدد، ويستخدم "SysLog" البرنامج الخفي لسجل النظام، على سبيل المثال syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTOBO instance to stop working (probably any mask which takes input from the user).' =>
            'يحدد الحد الأقصى للحجم (بالبايت) لتحميل الملفات باستخدام المستعرض. انتباه: إذا اخترت الحجم صغيرا جدا، فلن تتمكن العديد من أقنعة الإدخال من العمل في مثيل OTOBO الخاص بك (من المفترض أن يكون أي قناع يتوقع إدخال المستخدم).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'يحدد الحد الأقصى لوقت الصلاحية (بالثواني) لمعرف الجلسة.',
        'Defines the maximum number of affected tickets per job.' => 'تحديد الحد الأقصى لعدد التذاكر المتأثرة لكل وظيفة.',
        'Defines the maximum number of pages per PDF file.' => 'يحدد الحد الأقصى لعدد الصفحات لكل ملف PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'يضبط الحد الأقصى لعدد الصفوف المقتبسة التي تمت إضافتها إلى الإجابات.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'يحدد الحد الأقصى لعدد المهام المتزامنة.',
        'Defines the maximum size (in MB) of the log file.' => 'يحدد الحد الأقصى لحجم ملف السجل (بالميغابايت).',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'يحدد الحد الأقصى للحجم بالكيلو بايت من استجابات GenericInterface التي يتم تسجيلها في الجدول gi_debugger_entry_content.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'يحدد الوحدة النمطية التي تعرض جميع الوكلاء الذين قاموا بتسجيل الدخول حاليا في واجهة الوكيل.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            'يحدد الوحدة النمطية التي تعرض جميع العملاء الذين قاموا بتسجيل الدخول حاليا في منطقة الوكيل.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            'يحدد الوحدة النمطية التي تعرض جميع الوكلاء الذين قاموا بتسجيل الدخول حاليا إلى منطقة العميل.',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            'يحدد الوحدة النمطية التي تعرض جميع العملاء الذين قاموا بتسجيل الدخول حاليا في منطقة العميل.',
        'Defines the module to authenticate customers.' => 'يحدد الوحدة النمطية لمصادقة العملاء.',
        'Defines the module to display a notification in the agent interface if the OTOBO Daemon is not running.' =>
            'يحدد الوحدة النمطية التي تعرض إعلاما في منطقة العامل عندما لا يكون OTOBO Daemon قيد التشغيل.',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            'تحديد الوحدة النمطية التي تعرض إخطارا في منطقة العميل إذا لم تتم مزامنة تكوين النظام.',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            'يحدد الوحدة النمطية التي تعرض إخطارا في منطقة العميل إذا لم يقم الوكيل بعد بتعيين منطقة زمنية.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'يعرف الوحدة النمطية التي تعرض إخطارا في واجهة البرنامج العميل عند تسجيل دخول العميل أثناء تنشيط وظيفة "خارج المكتب".',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'يحدد الوحدة النمطية التي تعرض إعلاما في واجهة العامل عند تسجيل دخول وكيل أثناء تنشيط صيانة النظام.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            'يعرف الوحدة النمطية التي تعرض إخطارا في منطقة العميل عند الوصول إلى الحد الأقصى لجلسة عمل الوكيل.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'تحديد الوحدة النمطية التي تعرض إخطارا في منطقة العميل عند إستخدام النظام مع مستخدم مسؤول (عادة لا يجب عليك العمل كمسؤول).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            'تعريف الوحدة النمطية لعرض إعلام في واجهة الوكيل، في حالة نشر إعدادات التكوين غير صالحة.',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            'يحدد الوحدة النمطية التي تعرض إعلاما في منطقة العامل عند ضبط إعدادات التكوين ولكن لم يتم تشغيلها بعد.',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            'يحدد الوحدة النمطية التي تعرض إشعارا في منطقة العميل عند تسجيل دخول العميل أثناء صيانة النظام.',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            'تحديد الوحدة التي تعرض إخطارا في منطقة العميل إذا لم يقم العميل بعد بتعيين منطقة زمنية.',
        'Defines the module to display a notification in the customer interface. UseMarquee options: 1/0. NotifyPriority options: Notice/Error/Success/Info.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            'يعرف الوحدة النمطية لإنشاء التعليمات البرمجية عند إعادة تحميل الصفحات بشكل دوري.',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            'يحدد الوحدة النمطية لإرسال رسائل البريد الإلكتروني. "DoNotSendEmail" لا يرسل أي رسائل بريد إلكتروني على الإطلاق. تستخدم كل آلية من آليات "SMTP" خادم بريد (خارجي) محدد. يستخدم "Sendmail" مباشرة ثنائي sendmail لنظام التشغيل الخاص بك. لا يرسل "اختبار" رسائل البريد الإلكتروني، ولكنه يكتبها إلى $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ لأغراض الاختبار.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'يحدد الوحدة النمطية التي سيتم استخدامها لتخزين بيانات جلسة العمل. باستخدام "DB" ، يمكن تشغيل خادم العرض بشكل منفصل عن خادم DB. "FS" أسرع.',
        'Defines the modules in Kernel/Output/HTML/GenericContent/ which provide the inner content to the chosen key.' =>
            'يحدد الوحدات النمطية في Kernel/Output/HTML/GenericContent/ التي توفر المحتوى التابع للقيمة المحددة.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'يحدد اسم التطبيق الذي يتم عرضه في واجهة الويب وعلامات التبويب وشريط العنوان لمستعرض الويب.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'يحدد اسم العمود الذي يتم تخزين البيانات تحته في جدول الخصائص.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'يحدد اسم العمود لتخزين معرف المستخدم في جدول التفضيلات.',
        'Defines the name of the indicated calendar.' => 'يحدد اسم التقويم المعروض.',
        'Defines the name of the key for customer sessions.' => 'يحدد اسم المفتاح لجلسات العميل.',
        'Defines the name of the session key. E.g. Session, SessionID or OTOBO.' =>
            'يحدد اسم مفتاح الجلسة. على سبيل المثال: الجلسة أو معرف الجلسة أو OTOBO.',
        'Defines the name of the table where the user preferences are stored.' =>
            'تحديد اسم الجدول الذي يتم تخزين إعدادات المستخدم فيه.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'يحدد الحالة المحتملة التالية بعد إنشاء / الرد على تذكرة في شاشة الإنشاء في واجهة الوكيل.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'يحدد الحالات المحتملة التالية بعد إعادة توجيه تذكرة في شاشة إعادة توجيه التذكرة لواجهة الوكيل.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'يحدد الحالات التالية القابلة للتحديد بعد إرسال رسالة بريد إلكتروني صادرة.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'يحدد الحالات المحتملة التالية للتذاكر من العملاء في واجهة العميل.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'يحدد حالة التذكرة التالية بعد إضافة ملاحظة في عرض "إغلاق التذكرة" لواجهة الوكيل.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'يحدد الحالة التالية للتذكرة بعد إضافة ملاحظة، في شاشة النص الحر للتذكرة لواجهة الوكيل.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'يحدد حالة التذكرة التالية بعد إضافة ملاحظة في عرض "ملاحظة التذكرة" لواجهة الوكيل.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'يحدد حالة التذكرة التالية بعد إضافة ملاحظة في عرض "مالك التذكرة" لواجهة الوكيل.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'يحدد حالة التذكرة التالية بعد إضافة ملاحظة في عرض "الانتظار للتذكير" لواجهة الوكيل.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'يحدد حالة التذكرة التالية بعد إضافة ملاحظة في عرض "أولوية التذكرة" لواجهة الوكيل.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'يحدد حالة التذكرة التالية بعد إضافة ملاحظة في عرض "مسؤول التذكرة" لواجهة الوكيل.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'لتعيين حالة المتابعة للتذكرة المعاد توجيهها من شاشة إعادة التوجيه لمنطقة الوكيل.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'تحديد حالة التذاكر التالية بعد الانتقال إلى قائمة انتظار أخرى في عرض "قائمة انتظار التذاكر" لواجهة العميل.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'يحدد حالة المتابعة لتذكرة، في شاشة معالجة الدفعات في واجهة الوكيل.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'تعيين عدد الأحرف لكل سطر لاستبدال معاينة المقالة في TemplateGenerator ل EventNotifications.',
        'Defines the number of days to keep the daemon log files.' => 'يحدد عدد الأيام للاحتفاظ بملفات السجل الخفي(Daemon log files).',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'يضبط عدد حقول الرأس في الوحدات النمطية للواجهة الأمامية لإضافة / تحديث عوامل تصفية مدير مكتب البريد. إمكانية تصل إلى 99 مجالًا.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            'يحدد عدد الساعات التي يجب تخزين الاتصال فيها، بغض النظر عن حالته.',
        'Defines the number of hours a successful communication will be stored.' =>
            'تحديد عدد الساعات التي يجب حفظ الاتصال الناجح بها.',
        'Defines the number of tickets shown in the widget.' => 'يعرف عدد التذاكر المعروضة في الودجة.',
        'Defines the parameters for the customer preferences table.' => 'تحديد معلمات الجدول بإعدادات العميل.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Only works if DashboardBackend::AllowCmdOutput is enabled in Config.pm.' =>
            'يحدد معلمات النظرة العامة. يستخدم "Cmd" لتحديد أمر مع المعلمات. يتم استخدام "المجموعة" لتقييد الوصول إلى المكون الإضافي (على سبيل المثال Group: admin;group1;group2;). يشير "Default" إلى ما إذا كان المكون الإضافي قد تم تنشيطه افتراضيا أو ما إذا كان يتعين على المستخدم تنشيطه يدويا. يعرض "CacheTTL" وقت انتهاء صلاحية ذاكرة التخزين المؤقت للمكون الإضافي بالدقائق. يحدد "Mandatory" ما إذا كان يمكن دائما عرض المكون الإضافي وعدم إزالته بواسطة الوكلاء. سيعمل فقط إذا تم تمكين DashboardBackend :: AllowCmdOutput في ملف Config. pm.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'يضبط المعلمات للواجهة الخلفية للوحة القيادة. تقيد "المجموعة" الوصول إلى البيانات المعنية (على سبيل المثال، المجموعة: Group: admin;group1;group2;). تحدد "افتراضي" ما إذا كانت dashlet نشطة بشكل افتراضي أو يجب تنشيطها يدويًا بواسطة المستخدم. يحدد "CacheTTL" وقت التخزين المؤقت ل dashlet بالدقائق. باستخدام "Mandatory"، يمكن تكوين dashlet بحيث لا يتمكن المستخدمون من إخفائها.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'يضبط المعلمات للواجهة الخلفية للوحة القيادة. يحدد "الحد" عدد الإدخالات التي يتم عرضها افتراضيًا. تقيد "المجموعة" الوصول إلى البيانات المعنية (على سبيل المثال: Group: admin;group1;group2;). تحدد "Default" ما إذا كانت dashlet نشطة بشكل افتراضي أو يجب تنشيطها يدويًا بواسطة المستخدم. يحدد "CacheTTL" وقت التخزين المؤقت ل dashlet بالدقائق. باستخدام "Mandatory"، يمكن تكوين dashlet بحيث لا يتمكن المستخدمون من إخفائها.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'يضبط المعلمات للواجهة الخلفية للوحة القيادة. يحدد "الحد" عدد الإدخالات التي يتم عرضها افتراضيًا. تقيد "المجموعة" الوصول إلى البيانات المعنية (على سبيل المثال: Group: admin;group1;group2;). تحدد "افتراضي" ما إذا كانت dashlet نشطة بشكل افتراضي أو يجب تنشيطها يدويًا بواسطة المستخدم. يحدد "CacheTTLLocal" وقت التخزين المؤقت ل dashlet بالدقائق. باستخدام "Mandatory"، يمكن تكوين dashlet بحيث لا يتمكن المستخدمون من إخفائها.',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'يحدد المسار وملف TTF للتعامل مع الخطوط الغامقة والمائلة أحادية المسافة في مستندات PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'يعرف المسار وملف TTF لمعالجة الخط النسبي الغامق والمائل في وثائق PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'يعرف المسار وملف TTF لمعالجة الخط الغامق غير المتناسب (أحادي المسافة) في وثائق PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'يحدد المسار وملف TTF للتعامل مع الخطوط المتناسبة الغامقة في مستندات PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'يعرف المسار وملف TTF لمعالجة الخط المائل غير النسبي (أحادي الوتيرة) في وثائق PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'يحدد المسار وملف TTF لمعالجة الخطوط المتناسبة المائلة في مستندات PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'يحدد المسار وملف TTF لمعالجة الخطوط غير المتناسبة (أحادية المسافة) في مستندات PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'يعرف المسار وملف TTF لمعالجة الخط التناسبي في وثائق PDF.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'يحدد مسار ملف المعلومات المعروض، الموجود في Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.',
        'Defines the path to PGP binary.' => 'يضبط المسار إلى ملف PGP الثنائي.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'يحدد المسار إلى open ssl binary. قد يتطلب HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the path to the Google Chrome or Chromium binary. If set, this binary will be used instead of PhantomJS::Bin.' =>
            'يحدد المسار إلى Google Chrome أو Chromium Binary. عند تحديده، يتم استخدام binary بدلاً من PhantomJS::Bin.',
        'Defines the path to the PhantomJS binary. You can use a static build from http://phantomjs.org/download.html for an easy installation process.' =>
            'يحدد المسار إلى ملف PhantomJS binary. يمكنك استخدام إصدار ثابت من http://phantomjs.org/download.html لعملية تثبيت سهلة.',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'يضبط مقدار الوقت، بالدقائق، قبل وضع علامة على الوكيل على أنه "بالخارج" بسبب عدم النشاط (على سبيل المثال، في widget "المستخدمون الذين قاموا بتسجيل الدخول" أو في الدردشة).',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'يضبط مقدار الوقت، بالدقائق، قبل وضع علامة على العميل على أنه "بالخارج" بسبب عدم النشاط (على سبيل المثال، في widget "المستخدمون الذين قاموا بتسجيل الدخول" أو في الدردشة).',
        'Defines the postmaster default queue.' => 'يحدد قائمة انتظار الافتراضية لمسؤول البريد.',
        'Defines the priority in which the information is logged and presented.' =>
            'يحدد الأولوية التي يتم فيها تسجيل المعلومات وتقديمها.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'يحدد نوع المستلم لتذاكر الهاتف والمرسل لتذاكر البريد الإلكتروني في منطقة الوكيل ("قائمة الانتظار" تعرض جميع قوائم الانتظار، "عنوان النظام" جميع عناوين النظام).',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'يحدد نوع المستلم للتذاكر في منطقة العميل (تعرض "قائمة الانتظار" جميع قوائم الانتظار، و "عنوان النظام" فقط قوائم الانتظار التي تم تعيينها لعناوين النظام).',
        'Defines the redirect URL for setting a ticket article to \'seen\'.' =>
            '',
        'Defines the redirect URL for setting a ticket article to \'unseen\'.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'يحدد الإذن اللازم لعرض تذكرة في طريقة عرض التصعيد لواجهة الوكيل.',
        'Defines the search limit for the stats.' => 'يحدد الحد الأقصى لنتائج البحث للإحصائيات.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            'تعيين معلمات البحث لشاشة AgentCustomerUserAddressBook. يسمح لك إعداد \'CustomerTictTextField\' لتحديد قيم حقل المستلم.',
        'Defines the sender for rejected emails.' => 'يحدد عنوان الإرسال لرسائل البريد الإلكتروني المرفوضة.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'يحدد الفاصل بين الاسم الحقيقي للوكيل وعنوان البريد الإلكتروني المحدد لقائمة الانتظار.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            'تعيين الأعمدة المعروضة وموضعها لشاشة النتائج الخاصة ب AgentCustomerUserAddressBook.',
        'Defines the shown links in the footer area of the customer interface of this OTOBO system. The value in "Key" is the external URL, the value in "Content" is the shown label. <OTOBO_CONFIG_HttpType>, <OTOBO_CONFIG_FQDN> and <OTOBO_CONFIG_ScriptAlias> will be substituted.' =>
            'يحدد الروابط المعروضة في منطقة تذييل بوابة عملاء OTOBO. في حقل "المفتاح"، أدخل عنوان URL الخارجي، ونص الرابط الذي سيتم عرضه ك "محتوى". <OTOBO_CONFIG_HttpType>وسيتم <OTOBO_CONFIG_FQDN> <OTOBO_CONFIG_ScriptAlias> استبدالها.',
        'Defines the source dynamic field for storing historical data.' =>
            'يحدد حقل المصدر الديناميكي لتخزين البيانات التاريخية.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'يحدد الأذونات الافتراضية المتاحة للعملاء داخل التطبيق. إذا كانت هناك حاجة إلى مزيد من الأذونات، فيمكن إدخالها هنا. يجب أن تكون الأذونات مشفرة بشكل ثابت ليكون لها أي تأثير. عند إنشاء أذونات جديدة، يرجى التأكد من أن "rw" يظل دائما آخر إدخال.',
        'Defines the standard size of PDF pages.' => 'يضبط الحجم الافتراضي لصفحات PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'يحدد حالة التذكرة إذا حصلت على متابعة وكانت التذكرة مغلقة بالفعل.',
        'Defines the state of a ticket if it gets a follow-up.' => 'يحدد حالة التذكرة عند تلقي المتابعة.',
        'Defines the state type of the reminder for pending tickets.' => 'يحدد نوع حالة التذكير للتذاكر التي تم تعيينها على "انتظار".',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'يحدد موضوع رسائل البريد الإلكتروني الخاصة بالإشعارات المرسلة إلى الوكلاء للحصول على كلمة مرور جديدة.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'يضبط موضوع البريد الإلكتروني للإخطار الذي يتم إرساله إلى الوكلاء في حالة طلب كلمة مرور.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'تحديد الموضوع لرسائل البريد الإلكتروني التي يتم إرسالها إلى العملاء للحصول على حساب جديد.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'تعريف الموضوع لرسائل البريد الإلكتروني التي يتم إرسالها إلى العملاء لكلمة مرور جديدة.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'تعيين موضوع رسالة البريد الإلكتروني للإخطار التي يتم إرسالها إلى العملاء في حالة طلب كلمة مرور.',
        'Defines the subject for rejected emails.' => 'يحدد موضوع رسائل البريد الإلكتروني المرفوضة.',
        'Defines the subject for the quick close action, which gets used for ticket history in the agent interface.' =>
            'يحدد موضوع إجراء الإغلاق السريع، والذي يتم استخدامه في سجل التذكرة في واجهة الوكيل.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'يحدد عنوان البريد الإلكتروني لمسؤول النظام. يتم عرضه في رسائل الخطأ.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTOBO).' =>
            'يحدد معرف النظام. يحتوي كل رقم تذكرة وجلسة HTTP على هذا المعرف. هذا يضمن أن التذاكر التي تنتمي إلى نظام التذاكر الخاص بك فقط هي التي يتم تضمينها في نظام التذاكر (مفيد عند الاتصال بين مثيلين من OTOBO).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'تحدد السمة "الهدف" لارتباط إلى قاعدة بيانات العملاء الخارجيين. على سبيل المثال، "AsPopup PopupType_TicketAction".',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'تحديد السمة المستهدفة للإرتباط بقاعدة بيانات العميل الخارجية. على سبيل المثال، \'target="cdb"\'.',
        'Defines the target dynamic fields for storing historical data.' =>
            'يحدد الحقول المستهدفة الديناميكية لتخزين البيانات التاريخية.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            'يصف نوع الواجهة الخلفية لموعد التذكرة للتاريخ/الوقت من خلال الحقول الديناميكية.',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            'يحدد الواجهة الخلفية لنوع موعد التذكرة لوقت تصعيد التذاكر.',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            'يصف نوع الواجهة الخلفية لموعد التذكرة لأوقات انتظار التذكرة.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'يضبط خصائص التذاكر التي سيتم عرضها في أحداث التقويم. يحدد "المفتاح" الحقل أو سمة التذاكر، ويحدد "المحتوى" الاسم المراد عرضه.',
        'Defines the ticket plugin for calendar appointments.' => 'يضبط ملحق التذكرة للمواعيد.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'يحدد المنطقة الزمنية للتقويم المعروض، والتي يمكن تعيينها لاحقا إلى قائمة انتظار معينة.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'يضبط المهلة بالثواني لجمع بيانات الدعم من الوحدة العامة \'PublicSupportDataCollector\'، والتي على سبيل المثال. مستخدم من قبل OTOBO Daemon (دقيقة ٢٠ ثانية).',
        'Defines the two-factor module to authenticate agents.' => 'يحدد الوحدة النمطية للمصادقة الثنائية للوكلاء.',
        'Defines the two-factor module to authenticate customers.' => 'يحدد الوحدة النمطية للمصادقة الثنائية للعملاء.',
        'Defines the type of protocol that is used by the web server to serve the application. If the webserver uses HTTP instead of of HTTPS, then \'http\' must be specified here. The setting of \'HttpType\' has no affect on the web server\'s settings or behavior. Specifically, it will not change the method of access to the application. If the setting is wrong, it will not prevent you from logging into the application. This setting is used mainly via the template variable OTOBO_CONFIG_HttpType. This variable is found in all forms of messaging used by the application. It is used to build links to the tickets within your system. Another effect of keeping \'HttpType\' set to \'https\' is that the session management cookie will only be set for secure connections.' =>
            'يحدد البروتوكول الذي يستخدمه خادم الويب للاتصال بالتطبيق. إذا كان خادم الويب يستخدم HTTP بدلا من HTTPS، فيجب تحديد "http" هنا. إعداد HttpType ليس له أي تأثير على إعدادات أو سلوك ملقم ويب. على وجه الخصوص، لن يغير كيفية الوصول إلى التطبيق. إذا كان الإعداد غير صحيح، فلن يمنعك من الوصول إلى التطبيق. يتم استخدام الإعداد بشكل أساسي عبر متغير القالب OTOBO_CONFIG_HttpType. يمكن العثور على هذا المتغير في جميع نماذج الإشعارات الخاصة بالتطبيق. يتم استخدامه لبناء روابط للتذاكر في نظامك. تأثير آخر لترك "HttpType" في "https" هو أن ملف تعريف ارتباط الجلسة يتم تعيينه فقط للاتصالات الآمنة.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'يضبط الحرف المستخدم لعلامات التنصيص في رسائل البريد الإلكتروني النصية العادية في شاشة المؤلف من جزء الوكالات. إذا كان الحقل فارغا أو لم يتم تمكين الإعداد، فلن يتم اقتباس البريد الإلكتروني الأصلي، بل سيتم إلحاقه بالإجابة.',
        'Defines the user identifier for the customer panel.' => 'يحدد معرف المستخدم لواجهة العميل.',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'تعريف أفاتار المستخدمين. الرجاء ملاحظة: سيؤدي تعيين \'Active\' إلى 0 فقط إلى منع الوكلاء من تحرير إعدادات هذه المجموعة في تفضيلاتهم الشخصية، ولكنه سيسمح للمسؤولين بتحرير إعدادات نيابة عن مستخدم آخر. أستخدم \'PreferenceGroup\' للتحكم في المنطقة التي يجب إظهار هذه الإعدادات في واجهة المستخدم.',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            'يحدد أنواع الحالة الصالحة للتذكرة. إذا كانت التذكرة في حالة لها نوع حالة من هذا الإعداد، اعتبار هذه التذكرة مفتوحة، وإلا يتم إغلاقها.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'يحدد حالة التذاكر غير المؤمنة. لإلغاء تأمين التذاكر، يمكنك إستخدام البرنامج النصي bin/otobo.Console.pl Maint::Tict::UnlockingTimeout.',
        'Defines the value of the SameSite attribute of the OTOBO session cookies. Used in otobo.psgi.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            'يحدد أنواع القفل المرئي للتذكرة. ملاحظة: يرجى التأكد من مسح ذاكرة التخزين المؤقت عند تغيير هذا الإعداد.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'يحدد عرض مكون محرر النص المنسق. أدخل رقمًا (بكسل) أو نسبة مئوية (نسبي).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'يحدد عرض مكون محرر النص المنسق. أدخل رقمًا (بكسل) أو نسبة مئوية (نسبي).',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            'تحديد الوقت بالدقائق منذ آخر تعديل للمسودات من النوع المحدد قبل اعتبارها منتهية الصلاحية.',
        'Defines whether to index archived tickets for fulltext searches.' =>
            'يحدد ما إذا كان يجب وضع التذاكر المحفوظة في فهرس البحث النصي الكامل.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'يحدد أنواع مرسلي العناصر التي يجب عرضها في معاينة التذكرة.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'يحدد المصطلحات المتاحة ل "إجراء" في المستوى الثالث من بنية قائمة التحكم في الوصول (ACL).',
        'Defines which items are available in first level of the ACL structure.' =>
            'يحدد المصطلحات المتوفرة في المستوى الأول من بنية قائمة التحكم بالوصول (ACL).',
        'Defines which items are available in second level of the ACL structure.' =>
            'تحديد المصطلحات المتاحة في المستوى الثاني لبنية قائمة التحكم في الوصول (ACL).',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'يحدد الحالة التي يتم تعيينها تلقائيا (المحتوى) بعد الوصول إلى وقت انتظار الحالة (المفتاح).',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'يحدد أنه لا ينبغي عرض التذاكر ذات حالات التذاكر المحددة على التذاكر المرتبطة.',
        'Delete expired cache from core modules.' => 'يمسح ذاكرة التخزين المؤقت منتهية الصلاحية للوحدات الأساسية.',
        'Delete expired form cache hourly.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => 'يحذف ذاكرة التخزين المؤقت للمحمل منتهية الصلاحية أسبوعيا (صباح الأحد).',
        'Delete expired sessions.' => 'حذف جلسات المستخدم منتهية الصلاحية.',
        'Delete expired ticket draft entries.' => 'حذف مسودات التذاكر القديمة.',
        'Delete expired upload cache hourly.' => 'احذف ذاكرات التخزين المؤقت للتحميل القديمة كل ساعة.',
        'Delete this ticket' => 'حذف هذه التذكرة',
        'Deleted link to ticket "%s".' => 'تم حذف الارتباط ب "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'حذف الجلسة إذا تم استخدام معرف الجلسة مع عنوان IP غير صالح.',
        'Deletes requested sessions if they have timed out.' => 'حذف الجلسة المطلوبة إذا انتهت المهلة.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'يوفر معلومات تصحيح أخطاء متقدمة حول أخطاء AJAX في الواجهة الأمامية، إذا تم تمكينها.',
        'DeploymentHistory' => 'محفوظات النشر',
        'Detached' => 'مُنْفَصِلٌ',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            'يحدد ما إذا كان يجب أن يظهر زر حذف بجوار كل رابط في كل قناع تكبير/تصغير.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'يحدد ما إذا كانت قائمة قوائم الانتظار المحتملة التي يمكن نقل التذكرة إليها معروضة كقائمة منسدلة أو في نافذة جديدة. إذا تم تعيين "نافذة جديدة"، يمكنك إضافة ملاحظة نقل إلى التذكرة.',
        'Determines if the statistics module may generate article lists.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            'تحديد ما إذا كان من الممكن أن تقوم الوحدة النمطية للإحصاءات بإنشاء قوائم تذاكر.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'يحدد حالة التذكرة المحتملة التالية بعد إنشاء تذكرة بريد إلكتروني جديدة في واجهة الوكيل.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'يحدد حالة التذكرة المحتملة التالية بعد إنشاء تذكرة هاتف جديدة في واجهة الوكيل.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'تحدد حالة التذكرة المحتملة التالية لتذاكر العملية في واجهة الوكيل.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            'تحديد حالة تذكرة المتابعة المحتملة لتذاكر العملية في منطقة العميل.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'يحدد الشاشة التالية بعد تذكرة العميل في واجهة العميل.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'يحدد الشاشة التي سيتم استدعاؤها بعد المتابعة من عرض تفاصيل التذكرة في منطقة العميل.',
        'Determines the next screen after the process screen of a zoomed ticket in the customer interface.' =>
            'يحدد الشاشة التي يتم عرضها بعد قناع العملية للتذكرة في واجهة العميل.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'يحدد النافذة التالية التي يتم بعدها نقل التذكرة. يتم تبديل نظرة عامة على LastScreenOverview إلى صفحة النظرة العامة الأخيرة. يتحول TicketZoom إلى عرض تفاصيل التذكرة.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'يحدد الحالات المحتملة لتذكرة غير مكتملة غيرت حالتها بعد الوصول إلى حد المهلة.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'تحديد السلاسل المستخدمة كأجهزة استقبال (إلى:) من تذكرة الهاتف وكمرسل (من:) من تذكرة بريد إلكتروني في واجهة الوكيل. بالنسبة لقائمة الانتظار ك NewQueueSelectionType، يعرض "" اسم <Queue>قائمة الانتظار، وبالنسبة لعنوان النظام<Realname>، يعرض "<<Email>>" اسم المستلم وعنوان بريده الإلكتروني.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'يحدد السلاسل التي سيتم عرضها كمستلم (إلى:) من التذكرة في واجهة العميل. بالنسبة لقائمة الانتظار ك CustomerPanelSelectionType، يعرض <Queue>أسماء قوائم الانتظار، وبالنسبة لعنوان النظام،<Realname> يعرض "<<Email>>" اسم المستلم وبريده الإلكتروني.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'يحدد طريقة عرض الكائنات المرتبطة في كل قناع تكبير/تصغير.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'يحدد الخيارات الصالحة للمستلم (تذكرة الهاتف) والمرسل (تذكرة البريد الإلكتروني) في واجهة الوكيل.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'يحدد قوائم الانتظار الصالحة لمستلمي التذاكر في واجهة العميل.',
        'Dialog to show after marking a ticket as seen' => '',
        'Dialog to show after marking a ticket as unseen' => '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'إذا تم تعطيل رأس HTTP "سياسة أمان المحتوى Content-Security-Policy"، فيمكن تحميل البرامج النصية الخارجية. هذه ثغرة أمنية! لذلك، يجب تعطيل هذا الإعداد فقط إذا كنت على دراية بالعواقب!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTOBO to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'إذا تم إيقاف تشغيل رأس HTTP "X-Frame-Options: SAMEORIGIN"، فيمكن دمج OTOBO في مواقع الويب الأخرى ك IFrame. هذه ثغرة أمنية! لذلك، يجب تعطيل هذا الإعداد فقط إذا كنت على دراية بالعواقب!',
        'Disable autocomplete in the login screen.' => 'تعطيل الإكمال التلقائي في قناع تسجيل الدخول.',
        'Disable cloud services' => 'تعطيل الخدمات السحابية',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            'يمنع إرسال التذكيرات إلى الشخص المسؤول عن التذكرة (يجب تفعيل Ticket::Responsible).',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            'تعطيل إعادة التوجيه إلى آخر نظرة عامة / لوحة معلومات بعد إغلاق تذكرة.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'يعرض تحذيرا ويمنع البحث إذا تم إدخال كلمات إيقاف في البحث الكامل للنص.',
        'Display communication log entries.' => 'عرض الإدخالات في سجل الاتصال.',
        'Display settings to override defaults for Process Tickets.' => 'عرض الإعدادات لتجاوز القيم الافتراضية لتذاكر العملية.',
        'Display settings to override defaults for dynamic field widget for Tickets.' =>
            '',
        'Displayable via click' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'يعرض الوقت المحسوب لمقال في عرض تكبير التكبير/التصغير.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            'يعرض عدد جميع التذاكر بنفس رقم العميل الموجود في عرض "تكبير/تصغير التذاكر".',
        'Dropdown' => 'اختيار واحد',
        'Dutch' => 'هولندي',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'كلمات التوقف الهولندية لفهرس النص الكامل. تتم إزالة هذه الكلمات من فهرس البحث.',
        'Dynamic Field Contents' => '',
        'Dynamic Field Information' => '',
        'Dynamic Field Labels' => '',
        'Dynamic Field Set' => '',
        'Dynamic Field Set Backend GUI' => '',
        'Dynamic Fields Checkbox Backend GUI' => 'واجهة الحقول الديناميكية لمربعات الاختيار',
        'Dynamic Fields Contact Data Backend GUI' => 'واجهة الحقول الديناميكية لحقول بيانات جهة الاتصال',
        'Dynamic Fields Database Backend GUI' => 'واجهة الحقول الديناميكية لحقول قاعدة البيانات',
        'Dynamic Fields Date Time Backend GUI' => 'واجهة الحقول الديناميكية لحقول التاريخ والوقت',
        'Dynamic Fields Drop-down Backend GUI' => 'واجهة الحقول الديناميكية لمربعات الاختيار',
        'Dynamic Fields GUI' => 'واجهة الحقول الديناميكية',
        'Dynamic Fields Lens Backend GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => 'واجهة الحقول الديناميكية لمربعات التحديد المتعدد',
        'Dynamic Fields Overview Limit' => 'نظرة عامة على حدود الحقول الديناميكية',
        'Dynamic Fields Reference Backend GUI' => '',
        'Dynamic Fields Text Backend GUI' => 'واجهة الحقول الديناميكية لمربعات النص',
        'Dynamic Fields Web Service Backend GUI' => 'واجهة الحقول الديناميكية لحقول خدمة الويب',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'الحقول الديناميكية التي سيتم إخراجها بتنسيق CSV عند تصدير نتيجة البحث.',
        'Dynamic field event module that deletes script field events if a dynamic field of type script gets deleted.' =>
            '',
        'Dynamic field event module that updates PartOfSet attributes of fields which are included in a set.' =>
            '',
        'Dynamic fields groups for dynamic field widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'مجموعات الحقول الديناميكية لعنصر واجهة المستخدم العملية. المفتاح هو اسم المجموعة، القيمة تحتوي على الحقول المراد عرضها. مثال: "Key => My Group"، "Content: NameX، NameY".',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => 'الحد الأقصى لعدد الحقول الديناميكية لكل صفحة في صفحة نظرة عامة للحقول الديناميكية.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة إنشاء تذكرة في منطقة العميل. ملاحظة: إذا كنت تريد أيضا عرض هذه الحقول في عرض تفاصيل التذكرة، فيرجى تمكينها في إعداد CustomerTicketZoom # # #DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            'الحقول الديناميكية المراد إدخالها عند الرد على البطاقة في منطقة العميل.',
        'Dynamic fields shown in the dynamic field widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة البريد الإلكتروني الصادر لمنطقة الوكيل.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            'الحقول الديناميكية المعروضة في عنصر واجهة مستخدم العملية في طريقة عرض تفاصيل التذاكر في لوحة الوكيل.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            'الحقول الديناميكية المعروضة في الشريط الجانبي في عرض تفاصيل التذكرة لمنطقة الوكيل.',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة إغلاق التذكرة في منطقة الوكيل.',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة إنشاء تذكرة في منطقة الوكيل.',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة تذكرة البريد الإلكتروني لمنطقة الوكيل.',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            'الحقول الديناميكية للدخول في شاشة إرسال التذكرة في لوحة الوكيل.',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            'الحقول الديناميكية لإدخالها في شاشة حقول النص الحر في منطقة الوكيل.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            'يتم عرض الحقول الديناميكية في العرض المتوسط لقوائم التذاكر في منطقة الوكيل.',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة نقل التذكرة في منطقة الوكيل.',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة إنشاء ملاحظة في منطقة الوكيل.',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            'الحقول الديناميكية المعروضة في نظرة عامة على التذاكر لمنطقة العميل.',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة تبديل المالك في منطقة الوكيل.',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            'قم بتعيين الحقول الديناميكية لإدخالها في شاشة وقت الانتظار في منطقة الوكيل.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة الاتصال الواردة لمنطقة الوكيل.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة الاتصال الصادرة لمنطقة الوكيل.',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            'الحقول الديناميكية المراد إدخالها في شاشة تذكرة الهاتف في منطقة الوكيل.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            'الحقول الديناميكية المعروضة في طريقة العرض الكبيرة لقوائم التذاكر في منطقة الوكيل.',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            'الحقول الديناميكية المعروضة في طريقة عرض طباعة التذكرة في منطقة الوكيل.',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            'الحقول الديناميكية المعروضة في طريقة عرض طباعة التذكرة في منطقة العميل.',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            'قم بتعيين الحقول الديناميكية للإدخال في شاشة الأولوية لمنطقة الوكيل.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            'قم بتعيين الحقول الديناميكية للإدخال في شاشة المسؤول في منطقة الوكيل.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            'الحقول الديناميكية المعروضة في عرض نتائج البحث للبحث عن التذاكر في منطقة العميل.',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            'الحقول الديناميكية المعروضة في نتيجة البحث لعمليات البحث عن التذاكر في منطقة الوكيل.',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            'الحقول الديناميكية المعروضة في نتيجة البحث لعمليات البحث عن التذاكر في منطقة العميل.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            'الحقول الديناميكية المعروضة في العرض الصغير لقوائم التذاكر في منطقة الوكيل.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            'الحقول الديناميكية المعروضة في عرض تفاصيل التذكرة في منطقة العميل.',
        'DynamicField' => 'الحقل الديناميكي',
        'DynamicField backend registration.' => 'تسجيل الواجهة الخلفية للحقول الديناميكية.',
        'DynamicField object registration.' => 'حقل تسجيل الكائن الديناميكي.',
        'DynamicFieldScreen' => 'DynamicFieldScreen',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => 'البريد الإلكتروني الصادر',
        'Edit Customer Companies.' => 'معالجة شركات العملاء.',
        'Edit Customer Users.' => 'تحرير مستخدمي العملاء.',
        'Edit appointment' => 'تعديل الموعد',
        'Edit contacts with data' => 'تحرير جهة الاتصال',
        'Edit contacts with data.' => 'تحرير بيانات جهة الاتصال.',
        'Edit customer company' => 'تحرير شركة العميل',
        'Elasticsearch quick result module.' => 'المعاينة الديناميكية لنتائج البحث Elasticesearch.',
        'Email Addresses' => 'عناوين البريد الإلكتروني',
        'Email Outbound' => 'البريد الإلكتروني الصادر',
        'Email Resend' => 'إعادة إرسال البريد الإلكتروني',
        'Email communication channel.' => 'قناة الاتصال بالبريد الإلكتروني.',
        'Enable highlighting queues based on ticket age.' => 'تمكين تمييز قوائم الانتظار حسب عمر التذكرة.',
        'Enable keep-alive connection header for SOAP responses.' => 'تفعيل رؤوس الاتصال المستمرة لاستجابات SOAP.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'قم بتمكين هذا الإعداد إذا كنت تثق في جميع مفاتيح PGP العامة والخاصة، حتى إذا لم يتم توقيعها بتوقيع موثوق به.',
        'Enabled filters.' => 'تم تمكين الفلتر.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTOBO user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'تمكن دعم PGP. إذا تم تشغيل دعم PGP لتوقيع وتشفير رسائل البريد، يوصى بشدة بتشغيل خادم الويب تحت مستخدم OTOBO. خلاف ذلك، ستحدث مشكلات الأذونات عند الوصول إلى دليل .gnupg.',
        'Enables S/MIME support.' => 'تمكين دعم S/MIME.',
        'Enables customers to create their own accounts.' => 'يسمح للعملاء بإنشاء حساباتهم الخاصة.',
        'Enables fetch S/MIME from CustomerUser backend support.' => 'تمكين دعم S/MIME لطلب الخلفيات لمستخدم العميل.',
        'Enables file upload in the package manager frontend.' => 'يسمح بتحميل الملف في مدير الحزم.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'تبديل التخزين المؤقت للقالب أو إيقاف تشغيله. تحذير: لا تقم بتعطيل التخزين المؤقت للقالب على أنظمة الإنتاج، لأن ذلك قد يتسبب في تدهور الأداء بشكل كبير. يجب إيقاف تشغيل هذا الإعداد فقط لاستكشاف الأخطاء وإصلاحها!',
        'Enables or disables the debug mode for translations module.' => '',
        'Enables or disables the debug mode over frontend interface.' => 'تمكين أو تعطيل وضع التصحيح (debug) للواجهة الأمامية.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'تمكين ميزة "مراقبة التذاكر" أو تعطيلها التي تتيح لك مشاهدة التذاكر دون أن تكون مالكها أو مسئولة عنها.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'تمكين سجل الأداء من تسجيل أوقات إستجابة الصفحة. يؤثر هذا الإعداد على الأداء الكلي للنظام. Frontend::Module###AdminPerformanceLog يجب تمكين الوحدة.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'تمكين الحد الأدنى لحجم عدادات التذاكر (عند تحديد التاريخ ك TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'ينشط ميزة معالجة الدُفعات في منطقة الوكيل، مما يسمح بمعالجة تذاكر متعددة في نفس الوقت.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'تمكين ميزة معالجة الدفعات للمجموعات المسجلة فقط.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'لتمكين ميزة "المسؤول" التي تسمح بتتبع التذاكر ذات الصلة.',
        'Enables ticket type feature.' => 'تمكين أنواع التذاكر.',
        'Enables ticket watcher feature only for the listed groups.' => 'تمكين ميزة تذكرة المراقبة فقط للمجموعات المسجلة.',
        'Enabling SecureMode disables the web installer (http://yourhost.example.com/otobo/installer.pl) and the migrations. This is done in order to prevent the system from being hijacked. When SecureMode is not enabled the system can be reinstalled. In this case the current basic configuration will be used to pre-populate the questions within the installer script. Enabling SecureMode also enables GenericAgent, PackageManager and SQL Box.' =>
            'يؤدي تنشيط SecureMode إلى تعطيل مثبت الويب (http://yourhost.example.com/otobo/installer.pl) والترحيل. وهذا يتم لمنع النظام من الاختطاف. في حالة عدم تمكين SecureMode، يمكن إعادة تثبيت النظام في أي وقت. في هذه الحالة، يتم إستخدام التكوين الأساسي الحالي لإعداد البرنامج النصي المثبت. يؤدي تنشيط SecureMode أيضا إلى تمكين GenericAgent و PackageManager و SQL Box.',
        'English (Canada)' => 'الإنجليزية (كندا)',
        'English (United Kingdom)' => 'الإنجليزية (المملكة المتحدة)',
        'English (United States)' => 'الإنجليزية (الولايات المتحدة)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'كلمات التوقف الإنجليزية لفهرس النص الكامل. تتم إزالة هذه الكلمات من الفهرس.',
        'Enroll process for this ticket' => 'يبدأ عملية لهذه التذكرة',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            'أدخل "السر المشترك" لتمكين المصادقة الثنائية. تحذير: تأكد من إضافة "السر المشترك" إلى تطبيق المولد الخاص بك وسيعمل التطبيق بشكل جيد. خلاف ذلك، لن تتمكن من تسجيل الدخول بدون الرمز المميز ذي العاملين.',
        'Escalated Tickets' => 'تذاكر متصاعدة',
        'Escalation view' => 'عرض التصعيد',
        'EscalationTime' => 'مدة التصعيد',
        'Estonian' => 'الإستونية',
        'Evaluate all script fields.' => '',
        'Event module registration (store historical data in dynamic fields).' =>
            'تسجيل وحدة الحدث (تخزين البيانات التاريخية في الحقول الديناميكية).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'تسجيل وحدة الحدث للحصول على أداء أعلى، يمكنك تحديد حدث المشغل (مثل: الحدث (Event) => TictCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'تسجيل وحدة الحدث للحصول على أداء أعلى، يمكنك تحديد حدث المشغل (مثل: الحدث => TictCreate). يكون هذا ممكنا فقط إذا كانت كافة حقول التذاكر الديناميكية تتطلب نفس الحدث.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'الوحدة النمطية للأحداث التي تنفذ بيان تحديث على TicketIndex لإعادة تسمية قائمة الانتظار (إذا لزم الأمر وإذا تم استخدام StaticDB).',
        'Event module that updates customer company object name for dynamic fields.' =>
            'وحدة الحدث التي تقوم بتحديث اسم كائن شركة العميل للحقول الديناميكية.',
        'Event module that updates customer user object name for dynamic fields.' =>
            'الوحدة النمطية للأحداث التي تقوم بتحديث اسم كائن مستخدم العميل للحقول الديناميكية.',
        'Event module that updates customer user search profiles if login changes.' =>
            'وحدة الحدث التي تقوم بتحديث ملفات تعريف بحث العملاء عند تغيير أسماء تسجيل الدخول.',
        'Event module that updates customer user service membership if login changes.' =>
            'وحدة الأحداث التي تقوم بتحديث تعيينات الخدمة للعملاء عند تغيير أسماء تسجيل الدخول.',
        'Event module that updates customer users after an update of the Customer.' =>
            'وحدة الحدث التي تقوم بتحديث مستخدمي العميل بعد تحديث العميل.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'وحدة الحدث التي تقوم بتحديث تذكرة بعد تحديث مستخدم العميل.',
        'Event module that updates tickets after an update of the Customer.' =>
            'وحدة الحدث التي تقوم بتحديث تذكرة بعد تحديث العميل.',
        'Events Ticket Calendar' => 'تقويم حدث التذاكر',
        'Example package autoload configuration.' => 'مثال على تكوين التحميل التلقائي للحزم.',
        'Execute SQL statements.' => 'تنفيذ أوامر SQL.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'يشغل أمرًا مخصصًا أو وحدة نمطية. ملاحظة: إذا تم استخدام وحدة نمطية، فيجب أن تكون الوظيفة متاحة.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'يقوم بإجراء فحوصات متابعة على رؤوس الرسائل الواردة في الرد أو المراجع التي لا يحتوي موضوعها على رقم تذكرة.',
        'Executes follow-up checks on OTOBO Header \'X-OTOBO-Bounce\'.' =>
            'يقوم بإجراء فحوصات متابعة X-OTOBO-Bounce\' OTOBO Header\'.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'يقوم بإجراء فحوصات متابعة على مرفقات رسائل البريد الإلكتروني التي لا يحتوي موضوعها على رقم تذكرة.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'يقوم بإجراء فحوصات متابعة على نص رسائل البريد الإلكتروني التي لا يحتوي موضوعها على رقم تذكرة.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'يقوم بإجراء فحوصات متابعة على الكود المصدري لرسائل البريد الإلكتروني التي لا يحتوي موضوعها على رقم تذكرة.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'تصدير شجرة المقالة الكاملة في نتيجة البحث (قد يؤثر على أداء النظام).',
        'External' => 'خَارِجِيّ',
        'External Link' => 'رابط خارجي',
        'Fetch emails via fetchmail (using SSL).' => 'يتلقى رسائل البريد الإلكتروني من خلال Fetchmail (مع SSL).',
        'Fetch emails via fetchmail.' => 'إستلام رسائل البريد الإلكتروني من خلال fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'استرداد رسائل البريد الإلكتروني الواردة من حسابات البريد التي تم تكوينها.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'تنزيل الحزم من خلال وكيل (proxy). يلغي "WebUserAgent :: Proxy".',
        'Fields of the customer company index, used for the company fulltext search. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'حقول فهرس العملاء المستخدمة للبحث عن النص الكامل للشركة. يتم أيضا حفظ الحقول، ولكنها غير مطلوبة للوظائف العامة.',
        'Fields of the ticket index, used for the ticket fulltext search. Fields are also stored, but are not mandatory for the overall functionality. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'حقول فهرس التذاكر المستخدمة في البحث عن النص الكامل للتذكرة. يتم أيضًا حفظ الحقول، ولكنها ليست مطلوبة للوظيفة العامة. إذا تمت إضافة الحقول التي يمكن تحديثها (خاصة الحقول الديناميكية)، فيجب إضافة حدث التحديث المقابل إلى مُدعو TicketManagement لخدمة الويب Elasticsearch!',
        'Fields stored in the customer company index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'الحقول المخزنة في فهرس العميل والمستخدمة لأغراض أخرى بجانب البحث الكامل في النص. كافة الحقول مطلوبة للوظائف العامة.',
        'Fields stored in the customer user index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'الحقول المخزنة في فهرس مستخدم العميل والمستخدمة لأغراض أخرى غير البحث عن نص كامل. جميع الحقول مطلوبة للوظيفة العامة.',
        'Fields stored in the ticket index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'تستخدم حقول فهرس التذاكر لأغراض أخرى غير البحث عن نص كامل. جميع الحقول مطلوبة للوظيفة العامة. إذا تمت إضافة الحقول التي يمكن تحديثها (خاصة الحقول الديناميكية)، فيجب إضافة حدث التحديث المقابل إلى مُدعو TicketManagement لخدمة الويب Elasticsearch!',
        'Fields to be searched in ticket index. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'الحقول المراد البحث فيها في فهرس التذكرة. يتم حفظ الحقول أيضا، ولكنها غير مطلوبة للوظائف العامة.',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'الملف المستخدم في وحدة Kernel::Modules::AgentInfo إذا كان موجودًا في Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'مرشحات لتصحيح أخطاء قوائم التحكم في الوصول (ACLs). ملاحظة: يمكن إضافة سمات تذكرة إضافية بالتنسيق <OTOBO_TICKET_Attribute> (على سبيل المثال<OTOBO_TICKET_Priority>).',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'عوامل تصفية لتصحيح الانتقالات. ملاحظة: يمكن إضافة عوامل تصفية أخرى في تنسيق <OTOBO_TICKET_Attribute> (مثل <OTOBO_TICKET_Priority>).',
        'Filter incoming emails.' => 'تصفية رسائل البريد الإلكتروني الواردة.',
        'Finnish' => 'الفنلندية',
        'First Christmas Day' => 'اليوم الأول من عيد الميلاد',
        'First Queue' => 'قائمة الانتظار الأولى',
        'First response time' => 'وقت الاستجابة الأولى',
        'FirstLock' => 'فترة الحجب الأولية',
        'FirstResponse' => 'وقت الاستجابة الأولي',
        'FirstResponseDiffInMin' => 'فرق وقت الاستجابة الأولي بالدقائق',
        'FirstResponseInMin' => 'وقت الاستجابة الأولي بالدقائق',
        'Firstname Lastname' => 'الاسم الأول اسم العائلة',
        'Firstname Lastname (UserLogin)' => 'الاسم الأول اسم العائلة (تسجيل دخول المستخدم)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            'يتم شطب التذاكر ذات الأنواع المحددة هنا في جدول الكائنات المرتبطة.',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'يفرض تخزين محتوى المقالة الأصلي في فهرس بحث المقالة دون تطبيق عوامل التصفية وإيقاف الكلمات. يؤدي ذلك إلى زيادة حجم فهرس البحث، مما قد يؤدي إلى إبطاء عمليات البحث عن النص الكامل.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'يفرض تشفير رسائل البريد الإلكتروني الصادرة (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'يفرض إعداد حالة تذكرة تختلف عن الحالة الحالية بعد حظر التذكرة. قم بتعيين الحالة الحالية كمفتاح والحالة الجديدة كمحتوى.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'تم إلغاء تأمين التذاكر بعد الانتقال إلى قائمة انتظار أخرى.',
        'Format of Creation date shown for tickets. As an example \'%Y-%m-%d %H:%M:%S\' would be interpreted as \'2020-01-22 18:07:23\'. Please refer to http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.' =>
            'تنسيق تاريخ الإنشاء المحدد للتذاكر. مثال: يتم عرض "%Y-%m-%d %H:%M:%S\' ك \'2020-01-22 18:07:23\'. لمزيد من المعلومات، راجع \'http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns\'.',
        'Format to be ingested.' => 'تنسيق للقراءة.',
        'Forwarded to "%s".' => 'إعادة التوجيه إلى "%s".',
        'French' => 'فرنسي',
        'French (Canada)' => 'الفرنسية (كندا)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'كلمات التوقف الفرنسية لفهرس النص الكامل. يتم إزالة هذه الكلمات من فهرس البحث.',
        'Frontend' => 'واجهة أمامية',
        'Frontend module for dashboard info tile in customer interface.' =>
            '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            'تسجيل وحدة الواجهة الأمامية (قم بإزالة ارتباط AgentTicketService إذا كانت ميزة الخدمة غير نشطة).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'تسجيل الوحدة النمطية الأمامية (قم بإزالة ارتباط الشركة إذا كانت ميزة الشركة غير نشطة).',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'تسجيل وحدة الواجهة الأمامية (إخفاء عمليات التذاكر في حالة عدم توفر عملية).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            'تسجيل الوحدة النمطية للواجهة الأمامية (عرض المفضلة الشخصية كقائمة فرعية لعنصر "Admin").',
        'Frontend module registration for the admin interface.' => 'تسجيل وحدة الواجهة الأمامية في منطقة الوكيل.',
        'Frontend module registration for the agent interface.' => 'تسجيل الوحدة النمطية الأمامية في واجهة الوكيل.',
        'Frontend module registration for the customer interface.' => 'تسجيل وحدة الواجهة الأمامية لمنطقة العميل.',
        'Frontend module registration for the public interface.' => 'تسجيل وحدة الواجهة الأمامية للواجهة العامة.',
        'Full value' => 'القيمة الكاملة',
        'Fulltext index regex filters to remove parts of the text.' => 'مرشح Regex لفهرس النص الكامل لإزالة أجزاء من النص.',
        'Fulltext search' => 'بحث كامل في النص',
        'Fulltext search using Elasticsearch.' => 'بحث النص الكامل مع بحث Elasticsearch.',
        'FulltextES' => 'FulltextES',
        'Galician' => 'الجاليكية',
        'General Label' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            'عرض بيانات التذاكر العامة في لمحات عامة عن التذاكر (احتياطي). لاحظ أنه لا يمكن إيقاف تشغيل رقم التذكرة.',
        'Generate HTML comment hooks for the specified blocks so that filters can use them.' =>
            'إنشاء تعليقات HTML للكتل المحددة بحيث يمكن لعوامل التصفية إستخدامها.',
        'Generate dashboard statistics.' => 'إنشاء إحصائيات لوحة المعلومات.',
        'Generic Info module.' => 'وحدة المعلومات العامة.',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => 'واجهة مصحح أخطاء GenericInterface',
        'GenericInterface ErrorHandling GUI' => 'واجهة مستخدم معالجة أخطاء GenericInterface',
        'GenericInterface Invoker Event GUI' => 'واجهة المستخدم الرسومية لحدث GenericInterface Invoker',
        'GenericInterface Invoker GUI' => 'واجهة مستخدم GenericInterface Invoker',
        'GenericInterface Operation GUI' => 'واجهة مستخدم GenericInterface Operation',
        'GenericInterface TransportHTTPREST GUI' => 'GenericInterface TransportHTTPREST واجهة المستخدم',
        'GenericInterface TransportHTTPSOAP GUI' => 'واجهة مستخدم GenericInterface TransportHTTPSOAP',
        'GenericInterface Web Service GUI' => 'واجهة مستخدم خدمات ويب GenericInterface',
        'GenericInterface Web Service History GUI' => 'واجهة مستخدم سجل خدمة ويب GenericInterface',
        'GenericInterface Web Service Mapping GUI' => 'واجهة مستخدم تعيين خدمة الويب (Web Service Mapping) GenericInterface',
        'GenericInterface module registration for an error handling module.' =>
            'تسجيل الوحدة النمطية ل GenericInterface لوحدة معالجة الأخطاء.',
        'GenericInterface module registration for the PassThrough invoker layer.' =>
            'تسجيل الوحدة النمطية GenericInterface لطبقة استدعاء Passthrough.',
        'GenericInterface module registration for the TicketCreate invoker layer.' =>
            'تسجيل وحدة GenericInterface لطبقة استدعاء TicketCreate-Invoker.',
        'GenericInterface module registration for the TicketUpdate invoker layer.' =>
            'تسجيل الوحدة النمطية GenericInterface لطبقة استدعاء TicketUpdate.',
        'GenericInterface module registration for the invoker layer.' => 'تسجيل الوحدة النمطية لطبقة المدعو من GenericInterface.',
        'GenericInterface module registration for the mapping layer.' => 'تسجيل الوحدة النمطية لتعيين طبقات GenericInterface.',
        'GenericInterface module registration for the operation layer.' =>
            'تسجيل الوحدة النمطية لطبقة التشغيل ل GenericInterface.',
        'GenericInterface module registration for the transport layer.' =>
            'تسجيل الوحدة النمطية لطبقة النقل ل GenericInterface.',
        'German' => 'ألماني',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'كلمات التوقف الألمانية لفهرس النص الكامل. ستتم إزالة هذه الكلمات من فهرس البحث.',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            'يمنح العملاء حق الوصول إلى التذاكر من زبائن العميل نفسه على أساس المجموعة (رقم العميل للتذكرة هو رقم العميل الخاص بمستخدم العميل).',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'يمنح المستخدم النهائي القدرة على تحديد الحرف الفاصل لملفات CSV في ملف الترجمة. يرجى ملاحظة: إذا تم تعيين "Active" على 0، فهذا يمنع الوكلاء فقط من تغيير إعداد هذه المجموعة في إعداداتهم الشخصية. لا يزال بإمكان المسؤول تغيير هذه الإعدادات باسم المستخدمين. استخدم "PreferenceGroup" للتحكم في المنطقة التي يتم فيها عرض هذه الإعدادات في واجهة المستخدم.',
        'Global Search Module.' => 'وحدة البحث العالمية (Global).',
        'Go to dashboard!' => 'انتقل إلى النظرة العامة!',
        'Good PGP signature.' => 'توقيع PGP صالح.',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => 'الرسم البياني: مخطط شريطي',
        'Graph: Line Chart' => 'الرسم البياني: مخطط خطي',
        'Graph: Stacked Area Chart' => 'الرسم البياني: المستويات المكدسة',
        'Greek' => 'اليونانية',
        'Hebrew' => 'العبرية',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            'يساعد على توسيع فهرس البحث عن نص كامل لمقالتك (من، إلى، نسخة، الموضوع والبحث عن النص). يقوم بإنشاء فهرس بعد إنشاء المقالة، مما يزيد من سرعة البحث عن النص الكامل بحوالي 50٪. استخدم "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" لإنشاء فهرس أولي.',
        'High Contrast' => 'تباين عالي',
        'High contrast skin for visually impaired users.' => 'سطح (skin) عالي التباين للمستخدمين الذين يعانون من ضعف البصر.',
        'Hindi' => 'الهندية',
        'Hungarian' => 'الهنغارية (المجرية)',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'في حالة تحديد"DB" ك Customer::AuthModule، يمكن تعريف برنامج تشغيل قاعدة البيانات هنا. وإلا فسيتم تحديد برنامج التشغيل المطلوب تلقائيا.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'إذا تم تحديد "DB" ك Customer::AuthModule، فيمكن تخزين كلمة مرور هنا للاتصال بقاعدة البيانات.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'إذا تم تحديد "DB" ك Customer::AuthModule، فيمكن تخزين اسم مستخدم هنا للاتصال بقاعدة البيانات.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'إذا تم تحديد "DB" ك Customer::AuthModule، فيجب تخزين DSN هنا للاتصال بقاعدة البيانات.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'إذا تم تحديد "DB" ك Customer::AuthModule، فيجب تخزين اسم العمود الذي يحتوي على كلمة مرور العميل هنا.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            'إذا تم تحديد "DB" ك Customer::AuthModule، فيجب تخزين نوع تشفير كلمات المرور هنا.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'إذا تم تحديد "DB" ك Customer::AuthModule، فيجب تخزين اسم العمود الذي يحتوي على CustomerKey هنا.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'إذا تم تحديد "DB" ك Customer::AuthModule، فيجب تخزين اسم الجدول الذي سيتم تخزين بيانات العميل فيه هنا.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'إذا تم تحديد "DB" ك SessionModule، فيجب تخزين اسم الجدول الذي سيتم تخزين بيانات الجلسة فيه هنا.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'إذا تم تحديد "FS" ك SessionModule، فيجب تخزين اسم الدليل الذي سيتم تخزين بيانات الجلسة فيه هنا.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'إذا تم تحديد "HTTPBasicAuth" ك Customer::AuthModule، فيمكن تعريف تعبير عادي (باستخدام RegExp) هنا لإزالة أجزاء من REMOTE_USER (على سبيل المثال للمجالات المرفقة "domains"). ملاحظة: يحتوي 1 دولار على اسم تسجيل الدخول الجديد.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'إذا تم تحديد "HTTPBasicAuth" على أنها Customer::AuthModule، يمكنك تحديد ما إذا كنت تريد إزالة الأجزاء الموجودة في بداية اسم المستخدم (على سبيل المثال: لإزالة domains من أسماء المستخدمين مثل example_domain\user).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'إذا تم تحديد "LDAP" ك Customer::AuthModule وتريد إضافة لاحقة (Suffix) إلى اسم تسجيل دخول كل عميل، فيمكنك تعيين هذا هنا (على سبيل المثال، إذا كان "اسم المستخدم" موجودا ك "اسم المستخدم@domain" في LDAP).',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'إذا تم تحديد "LDAP" ك Customer::AuthModule وكانت المعلمات الخاصة مطلوبة لوحدة Perl Net::LDAP، فيمكنك تحديدها هنا. استخدم "perldoc Net::LDAP" لمزيد من المعلومات حول المعلمات.',
        'If "LDAP" was selected for Customer::AuthModule and you wish to use TLS security to communicate with the LDAP server, the "verify" parameter can be specified here. See Net::LDAP::start_tls for more information about the parameter.' =>
            'إذا تم تحديد "LDAP" ك Customer::AuthModule وسيتم استخدام TLS للاتصال الآمن بخادم LDAP، يمكنك تحديد معلمة "verify" هنا. لمزيد من المعلومات، راجع Net::LDAP::start_tls.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'إذا تم تحديد "LDAP" ك Customer::AuthModule وكان لدى المستخدمين وصول مجهول فقط إلى شجرة LDAP، ولكنك تريد البحث في البيانات، فيمكنك القيام بذلك باستخدام مستخدم خاص يمكنك إدخال كلمة المرور الخاصة به هنا.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'إذا تم تحديد LDAP باعتباره Customer::AuthModule وكان لدى المستخدمين فقط حق الوصول المجهول إلى شجرة LDAP، ولكنك تريد البحث في البيانات، يمكنك إجراء ذلك باستخدام مستخدم خاص يمكنك تحديد اسم المستخدم الخاص به هنا.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'إذا تم تحديد "LDAP" على أنه Customer::AuthModule، يجب تحديد BaseDN هنا.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'إذا تم تحديد "LDAP" على أنه Customer::AuthModule، يمكن تحديد مضيف LDAP هنا.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'إذا تم تحديد "LDAP" على أنه Customer::AuthModule، يجب تحديد معرف المستخدم هنا(User-Identifier).',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'إذا تم تحديد "LDAP" ك Customer::AuthModule، يمكن تحديد سمات المستخدم هنا. استخدم UID ل LDAP-posixGroups، وهو الاسم المميز الكامل للمستخدم لغير LDAP-posixGroups.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'إذا تم تحديد "LDAP" ك Customer::AuthModule، فيمكن تحديد سمات الوصول هنا.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'إذا تم تحديد "LDAP" على أنه Customer::AuthModule، يمكنك هنا تحديد ما إذا كان يجب إيقاف التطبيقات في حالة تعذر إنشاء الاتصال بالخادم على سبيل المثال بسبب مشاكل في الشبكة.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTOBO. Specify the group, who may access the system.' =>
            'إذا تم تحديد "LDAP" ك Customer::AuthModule، يمكنك التحقق مما إذا كان المستخدم مخولا بالمصادقة بسبب عضويته في posixGroup (على سبيل المثال، إذا كان يجب أن يكون المستخدم عضوا في المجموعة xyz حتى يسمح له باستخدام OTOBO). قم بتعيين هذه المجموعة هنا.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'إذا تم اختيار "LDAP" ك Customer::AuthModule، يمكنك ضبط الفلاتر لكل طلب LDAP هنا، على سبيل المثال (*=mail) أو (objectclass=user) أو (objectclass=computer!).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'إذا تم تحديد "Radius" ك Customer::AuthModule، فيجب تخزين كلمة المرور هنا للمصادقة مع مضيف Radius.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'إذا تم تحديد "Radius" على أنه Customer::AuthModule، يجب تخزين مضيف (host) Radius هنا.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'إذا تم تحديد "Radius" على أنه Customer::AuthModule، يمكنك هنا تحديد ما إذا كان يجب إيقاف التطبيقات إذا تعذر على سبيل المثال إنشاء الاتصال بالخادم بسبب مشاكل في الشبكة.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'إذا تم تكوين "Sendmail" على أنه SendmailModule، فيجب تخزين المسار إلى sendmail binary والخيارات المطلوبة هنا.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'إذا تم تكوين "SysLog" ك LogModule، فيمكن تحديد فئة منفصلة (منشأة facility) هنا.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'إذا تم تكوين "SysLog" ك LogModule، فيمكن تحديد مجموعة الأحرف التي سيتم استخدامها للتسجيل هنا.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            'إذا تم تحديد "bcrypt" على أنها CryptType، فسيتم استخدام معلمة التكلفة التي تم إدخالها هنا للحساب.الحد الأقصى للقيمة المدعومة هو 31.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'إذا تم تكوين "ملف" ك LogModule، فيجب تخزين ملف السجل هنا. إذا لم يكن الملف موجودا، فسيقوم النظام بإنشائه تلقائيًا.',
        'If activated, a clicked activity button will be hidden in the customer ticket zoom frontend.' =>
            '',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'عند تمكين هذا الخيار، قد لا تتطابق أي من التعبيرات المعتادة المعرفة هنا مع عنوان البريد الإلكتروني للمستخدم الذي يرغب في التسجيل.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'في حالة التمكين، يجب أن يتطابق واحد على الأقل من التعبيرات العادية المحددة هنا مع عنوان البريد الإلكتروني للمستخدم الذي يريد التسجيل.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'إذا تم تحديد إحدى آليات SMTP على أنها SendmailModule وكان الخادم يتطلب المصادقة، فيجب تحديد كلمة مرور هنا.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'إذا تم تحديد إحدى آليات SMTP على أنها SendmailModule وكان الخادم يتطلب المصادقة، فيجب تحديد اسم مستخدم هنا.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'إذا تم تحديد إحدى آليات SMTP على أنها SendmailModule، فيجب تحديد مضيف البريد (mailhost) الذي يرسل الرسائل هنا.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'إذا تم تحديد إحدى آليات SMTP ك SendmailModule، فيجب تحديد المنفذ الذي يستمع إليه خادم البريد للاتصالات الواردة هنا.',
        'If enabled debugging information for ACLs is logged.' => 'عند تمكين هذا الخيار، يتم تسجيل معلومات تصحيح أخطاء قوائم التحكم في الوصول(ACLs).',
        'If enabled debugging information for transitions is logged.' => 'عند التمكين، يتم تسجيل معلومات تصحيح الأخطاء للانتقالات في تذاكر العملية.',
        'If enabled defines the preselected state for customer follow-up in the customer interface.' =>
            'تحديد الحالة المحددة مسبقا لمتابعة العميل عند تنشيطه في منطقة العميل.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'تمكين لإعادة توجيه إخراج الخطأ من daemon إلى ملف سجل.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'تمكين لإعادة توجيه الإخراج الافتراضي ل daemon إلى ملف سجل.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTOBOHome>/var/run/ can not be used.' =>
            'عند تمكين هذا الخيار، يستخدم المراقب (daemon) هذا الدليل لإنشاء ملفاته PID. ملاحظة: الرجاء إيقاف البرنامج قبل التغيير واستخدام هذا الإعداد فقط في حالة عدم إمكانية إستخدام <$OTOBOHome>/var/run/.',
        'If enabled, OTOBO will deliver all CSS files in minified form.' =>
            'عند تمكين هذا الخيار، سيقوم OTOBO بإرجاع ملفات CSS في نموذج مصغر.',
        'If enabled, OTOBO will deliver all JavaScript files in minified form.' =>
            'عند التمكين، سوف يوفر OTOBO ملفات JavaScript في نموذج مصغر.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'عند تنشيطه، يتم فتح TicketPhone و TicketEmail في نوافذ جديدة.',
        'If enabled, the OTOBO version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            'عند تمكين هذا الخيار، يتم إزالة معلومات إصدار OTOBO من الواجهة ورؤوس HTTP ورؤوس X. ملاحظة: بعد تغيير هذا الخيار، يجب حذف ذاكرة التخزين المؤقت.',
        'If enabled, the cache data be held in memory.' => 'عند تمكين هذا الخيار، يتم الاحتفاظ ببيانات التخزين المؤقت في الذاكرة.',
        'If enabled, the cache data will be stored in cache backend.' => 'عند تمكين هذا الخيار، يتم تخزين بيانات ذاكرة التخزين المؤقت في نهاية خلفية التخزين المؤقت.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'عند التمكين، يمكن للعملاء البحث عن التذاكر مع جميع الخدمات (بغض النظر عن الخدمات التي يتم تعيينها لكل عميل).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'إذا كان هذا الخيار محددا، سيتم تحديث صفحات نظرة عامة مختلفة (لوحة المعلومات، LockedView، عرض قائمة الانتظار) تلقائيا بعد الوقت المحدد.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'في حالة التنشيط، يتم فتح المستوى الأول من القائمة الرئيسية عند التمرير فوق الماوس (بدلا من النقر فقط).',
        'If enabled, the quick close action will create an article.' => 'إذا تم تنشيط المعلمة، يتم إنشاء مقالة بواسطة إجراء "إغلاق فوري".',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTOBOTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            'في حالة التمكين، سيتم إخطار المستخدمين الذين لم يختاروا منطقة زمنية بعد للقيام بذلك. ملاحظة: لن يتم عرض الإشعار إذا (1) لم يحدد المستخدم منطقة زمنية بعد، و (2) OTOBOTimeZone و UserDefaultTimeZone متماثلان، و (3) لم يتم تعيينهما على UTC.',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'إذا لم يتم تعريف SendmailNotificationEnvelopeFrom، فإن هذا الإعداد يسمح لك باستخدام عنوان مرسل البريد الإلكتروني بدلا من مرسل مغلف فارغ (مطلوب بواسطة بعض تكوينات خادم البريد).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            'إذا تم تعيينه، استخدام هذا العنوان كرأس مرسل مغلف في إشعارات البريد الصادر. إذا لم يتم تحديد أي عنوان، يتم ترك الرأس فارغا (ما لم يتم تعيين SendmailNotificationEnvelopeFrom::FallbackToEmailFrom).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'إذا تم تعيينه، استخدام هذا العنوان كرأس مرسل المغلف في الرسائل الصادرة (وليس الإشعارات، انظر أدناه). إذا لم يتم تحديد عنوان، فإن مرسل المغلف (envelope) يتوافق مع عنوان البريد الإلكتروني المخزن في قائمة الانتظار.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            'إذا تم تنشيط هذا الخيار، إرسال رد تلقائي للتذاكر التي تم إنشاؤها عبر الواجهة الخارجية أو واجهة الوكيل، بشرط تعيين ذلك في تكوين قائمة الانتظار. إذا لم يتم تنشيط هذا الخيار، فلن يتم إرسال أي ردود تلقائية.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'في حالة تطبيق هذا التعبير النمطي(regex)، فلن يتم إرسال أي رسالة بواسطة المجيب الآلي.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTOBO Team. These packages could threaten your whole system!' =>
            'إذا تم تمكين هذا الإعداد، فيمكن أيضا تثبيت الحزم التي لم يتم التحقق منها بواسطة فريق OTOBO. يمكن أن تعرض هذه الحزم النظام بأكمله للخطر!',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            'إذا كان الإعداد نشطا، فلن يتم عرض التغييرات المحلية في إدارة الحزم وتحليل بيانات الدعم كأخطاء.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'يبلغ المستخدمين الآخرين بالفترة المحددة لغيابهم.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            'لا يتم وضع علامة على أنواع مقالات النظام (مثل الردود التلقائية أو إعلامات البريد الإلكتروني) كمقالات غير مقروءة في AgentTicketZoom أو لا يتم توسيعها تلقائيا في لمحات عامة كبيرة.',
        'Ignores not ticket related attributes.' => 'يتجاهل السمات غير المتعلقة بالتذاكر.',
        'Import and export object information.' => '',
        'Import appointments screen.' => 'واجهة استيراد المواعيد.',
        'Import/Export' => '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'قم بتضمين التذاكر تلقائيا من قوائم الانتظار الفرعية عند تحديد قائمة انتظار.',
        'Include unknown customers in ticket filter.' => 'قم بتضمين العملاء غير المعروفين في مرشحات التذاكر.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'يتضمن أوقات إنشاء المقالة في البحث في التذاكر في منطقة الوكيل.',
        'Incoming Phone Call.' => 'مكالمة هاتفية واردة.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator: اختيار وحدة الواجهة الخلفية لوحدة TicketViewAccelerator. يقوم "RuntimeDB" بإنشاء عرض كل قائمة انتظار ديناميكيا من جدول التذاكر (لا توجد مشاكل في الأداء تصل إلى حوالي 60.000 تذكرة في المجموع و 6.000 تذكرة مفتوحة في النظام). "StaticDB" هي أقوى وحدة، فهي تستخدم جدولا إضافيا لفهرس التذاكر، والذي يعمل كنظرة عامة (موصى به من أكثر من 80.000 تذكرة في المجموع و 6.000 تذكرة مفتوحة في النظام). استخدم الأمر "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" لبناء الفهرس الأولي.',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            'يحدد ما إذا كان يجب دائما التعامل مع البريد الإلكتروني المرتد كمتابعة عادية.',
        'Indonesian' => 'الأندونيسية',
        'Inline' => 'مضمنه',
        'Input' => 'إدْخَالٌ',
        'Interface language' => 'لغة الواجهة',
        'Internal communication channel.' => 'قناة الاتصال الداخلية.',
        'International Workers\' Day' => 'يوم العمال العالمي',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'من الممكن تكوين أشكال مختلفة (skins)، على سبيل المثال للتمييز بين العوامل المختلفة بناء على المجال المعني. يمكنك التحقق من المجالات باستخدام التعبيرات العادية باستخدام أزواج المفاتيح / القيم. يجب أن يتضمن محتوى "المفتاح" التحقق من المجال، ومحتوى "القيمة" اسم الجلد المراد تحديده لهذا المجال (domain). يرجى الرجوع إلى الإدخالات مع أمثلة على التعبيرات العادية الصحيحة.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'من الممكن تكوين أشكال مختلفة (skins)، على سبيل المثال للتمييز بين العملاء المختلفين بناء على المجال المعني. يمكنك التحقق من المجالات باستخدام التعبيرات العادية باستخدام أزواج المفاتيح / القيم. يجب أن يتضمن محتوى "المفتاح" التحقق من المجال، ومحتوى "القيمة" اسم الجلد المراد تحديده لهذا المجال (domain). يرجى الرجوع إلى الإدخالات مع أمثلة على التعبيرات العادية الصحيحة.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'من الممكن تكوين سمات مختلفة، على سبيل المثال للتمييز بين الوكلاء والعملاء المختلفين بناء على المجال المعني. يمكنك التحقق من المجالات باستخدام التعبيرات العادية باستخدام أزواج المفاتيح/القيم. يجب أن يتضمن محتوى "المفتاح" التحقق من المجال (domain)، ومحتوى "القيمة" اسم الموضوع المراد تحديده لهذا المجال. يرجى الرجوع إلى الإدخالات مع أمثلة على التعبيرات العادية الصحيحة.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            'تعذر التحقق من توقيع PGP. الأسباب المحتملة هي الافتقار إلى المفاتيح العامة أو الخوارزمية غير المدعومة.',
        'Italian' => 'الإيطالية',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'كلمات الإيقاف الإيطالية لفهرس النص الكامل. يتم إزالة هذه الكلمات من فهرس البحث.',
        'Ivory' => 'عَاج',
        'Ivory (Slim)' => 'العاج (قليل السمك)',
        'Japanese' => 'اليابانية',
        'JavaScript function for the search frontend.' => 'وظيفة JavaScript لواجهة البحث.',
        'Jump to OTOBO!' => 'رابط إلى OTOBO!',
        'Korean' => 'الكورية',
        'Languages' => '',
        'Large' => 'كبير',
        'Last Screen Overview' => 'نظرة عامة على الشاشة الأخيرة',
        'Last customer subject' => 'آخر موضوع للعميل',
        'Lastname Firstname' => 'اسم العائلة الاسم الأول',
        'Lastname Firstname (UserLogin)' => 'اسم العائلة الاسم الأول (تسجيل دخول المستخدم)',
        'Lastname, Firstname' => 'اسم العائلة، الاسم الأول',
        'Lastname, Firstname (UserLogin)' => 'الاسم الأخير ، الاسم الأول (تسجيل دخول المستخدم)',
        'LastnameFirstname' => 'اسم العائلةالاسم الأول',
        'Latvian' => 'اللاتفية',
        'Lax' => '',
        'Left' => 'يسار',
        'Lens' => '',
        'Link Object' => 'كائن الارتباط',
        'Link Object.' => 'كائن الارتباط.',
        'Link agents to groups.' => 'تعيين وكلاء للمجموعات.',
        'Link agents to roles.' => 'تعيين وكلاء للأدوار (roles).',
        'Link customer users to customers.' => 'تعيين مستخدمي العملاء إلى العملاء.',
        'Link customer users to groups.' => 'تعيين مستخدمي العملاء إلى مجموعات.',
        'Link customer users to services.' => 'تعيين مستخدمي العملاء إلى الخدمات.',
        'Link customers to groups.' => 'تعيين العملاء إلى مجموعات.',
        'Link queues to auto responses.' => 'تعيين ردود تلقائية لقوائم الانتظار.',
        'Link roles to groups.' => 'تعيين الأدوار للمجموعات.',
        'Link templates to attachments.' => 'ربط القوالب بالمرفقات.',
        'Link templates to queues.' => 'تعيين قوالب لقوائم الانتظار.',
        'Link this ticket to other objects' => 'ربط هذه التذكرة بكائنات أخرى',
        'Links 2 tickets with a "Normal" type link.' => 'يربط 2 تذاكر مع نوع الارتباط "عادي".',
        'Links 2 tickets with a "ParentChild" type link.' => 'ربط تذكرتين مع نوع الارتباط "الوالدين والطفل".',
        'Links appointments and tickets with a "Normal" type link.' => 'ربط المواعيد والتذاكر برابط "عادي".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'قائمة ملفات CSS التي يجب تحميلها دائما في واجهة الوكيل.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'قائمة ملفات CSS التي يجب تحميلها دائما في واجهة العميل.',
        'List of JS files to always be loaded for the agent interface.' =>
            'قائمة ملفات JavaScript التي يجب تحميلها دائما في واجهة الوكيل.',
        'List of JS files to always be loaded for the customer interface.' =>
            'قائمة ملفات JavaScript التي يجب تحميلها دائما في واجهة العميل.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'قائمة بجميع أحداث العملاء التي سيتم عرضها في واجهة المستخدم الرسومية.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'قائمة بجميع أحداث مستخدم العميل التي سيتم عرضها في واجهة المستخدم الرسومية.',
        'List of all DynamicField events to be displayed in the GUI.' => 'قائمة بجميع أحداث الحقل الديناميكي ليتم عرضها في واجهة المستخدم الرسومية.',
        'List of all LinkObject events to be displayed in the GUI.' => 'قائمة بجميع أحداث LinkObject لعرضها في واجهة المستخدم الرسومية.',
        'List of all Package events to be displayed in the GUI.' => 'قائمة بجميع أحداث الحزم التي سيتم عرضها في واجهة المستخدم الرسومية.',
        'List of all appointment events to be displayed in the GUI.' => 'قائمة بجميع أحداث المواعيد التي يتم عرضها في واجهة المستخدم.',
        'List of all article events to be displayed in the GUI.' => 'قائمة بجميع أحداث المقالة التي سيتم عرضها في واجهة المستخدم الرسومية.',
        'List of all calendar events to be displayed in the GUI.' => 'قائمة بجميع أحداث التقويم التي سيتم عرضها في واجهة المستخدم الرسومية.',
        'List of all queue events to be displayed in the GUI.' => 'قائمة بجميع أحداث قائمة الانتظار ليتم عرضها في واجهة المستخدم الرسومية.',
        'List of all ticket events to be displayed in the GUI.' => 'قائمة بجميع أحداث التذاكر التي سيتم عرضها في واجهة المستخدم الرسومية.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            'قائمة الألوان في hexadecimal RGB، والتي يتم تعيينها لتقويمات مستخدم مختلفة. تأكد من أن الألوان داكنة بما يكفي لعرض نص أبيض عليها. إذا تجاوز عدد التقويمات عدد الألوان المتاحة، استخدام هذه القائمة مرة أخرى من البداية.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'قائمة القوالب القياسية التي سيتم تعيينها لقوائم الانتظار الجديدة تلقائيا بعد الإنشاء.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'قائمة ملفات CSS سريعة الاستجابة لتحميلها دائما في منطقة الوكيل.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'قائمة ملفات CSS سريعة الاستجابة التي يجب تحميلها دائما في منطقة العميل.',
        'List of states for which escalations should be suspended.' => 'قائمة بجميع الحالات التي سيتم تعليق التصعيد من أجلها.',
        'List of ticket masks which can be altered using AdminTicketMask.' =>
            '',
        'List view' => 'طريقة عرض القائمة',
        'Lithuanian' => 'الليتوانية',
        'Loader module for dashboard info tile in customer interface.' =>
            '',
        'Loader module registration for the agent interface.' => 'تسجيل وحدة اللودر (Loader) لواجهة الوكيل.',
        'Loader module registration for the customer interface.' => 'تسجيل وحدة اللودر (Loader) لواجهة العميل.',
        'Lock / unlock this ticket' => 'إقفال / إلغاء تأمين هذه التذكرة',
        'Locked Tickets' => 'تذاكر مقفلة',
        'Locked Tickets.' => 'تذاكر مقفلة.',
        'Locked ticket.' => 'تذكرة مؤمنة.',
        'Logged in users.' => 'المستخدمون الذين قاموا بتسجيل الدخول.',
        'Logged-In Users' => 'المستخدمون المسجلون',
        'Logout of customer panel.' => 'تسجيل الخروج من منطقة العملاء.',
        'Look into a ticket!' => 'ألق نظرة فاحصة على التذكرة!',
        'Loop protection: no auto-response sent to "%s".' => 'الحماية من التكرار (Loop protection)! لم يتم إرسال أي رد تلقائي إلى "%s".',
        'Macedonian' => 'المقدونية',
        'Mail Accounts' => 'حسابات البريد الإلكتروني',
        'MailQueue configuration settings.' => 'إعدادات تكوين قائمة انتظار البريد.',
        'Main menu for the agent interface.' => 'القائمة الرئيسية في منطقة الوكيل.',
        'Main menu item registration.' => 'تسجيل عنصر القائمة الرئيسية.',
        'Main menu registration.' => 'تسجيل القائمة الرئيسية.',
        'Makes the application block external content loading.' => 'يسمح للتطبيق بحظر تحميل المحتوى الخارجي.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'يتحقق من إدخال MX لعنوان البريد الإلكتروني قبل إرسال بريد إلكتروني أو إرسال تذكرة هاتف.',
        'Makes the application check the syntax of email addresses.' => 'يتحقق من بناء جملة عناوين البريد الإلكتروني (syntax).',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'يستخدم ملفات تعريف الارتباط HTML لإدارة الجلسة. إذا تم تعطيل ملفات تعريف ارتباط HTML أو تعطيل ملفات تعريف ارتباط HTML في المتصفح، فإن النظام يعمل كالمعتاد ويلحق معرف الجلسة والروابط.',
        'Malay' => 'ماليزية',
        'Manage Customer Dashboard Info Tile Entries' => '',
        'Manage OTOBO Team cloud services.' => 'إدارة الخدمات السحابية لفريق OTOBO.',
        'Manage PGP keys for email encryption.' => 'إدارة مفاتيح PGP لتشفير البريد الإلكتروني.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'إدارة حسابات POP3 أو IMAP لاسترداد البريد الإلكتروني.',
        'Manage S/MIME certificates for email encryption.' => 'إدارة شهادات S/MIME لتشفير البريد الإلكتروني.',
        'Manage System Configuration Deployments.' => 'إدارة تشغيل تكوينات النظام.',
        'Manage different calendars.' => 'إدارة التقويمات المختلفة.',
        'Manage dynamic field in screens.' => 'إدارة الحقول الديناميكية في الواجهات.',
        'Manage existing sessions.' => 'إدارة الجلسات.',
        'Manage support data.' => 'إدارة بيانات الدعم.',
        'Manage system registration.' => 'إدارة سجل النظام.',
        'Manage tasks triggered by event or time based execution.' => 'إدارة المهام القائمة على الحدث أو الوقت.',
        'Manage ticket state pre-selections for response templates.' => '',
        'Mark as Spam!' => 'حددها كرساله غير مرغوب فيها (Spam)!',
        'Mark this ticket as junk!' => 'ضع علامة على هذه التذكرة كغير هامة!',
        'Mark ticket as seen' => '',
        'Mark ticket as unseen' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'الحد الأقصى لحجم (الحروف) لمعلومات العميل (الهاتف والبريد الإلكتروني) في واجهة التسجيل.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'الحد الأقصى للحجم (في صفوف) لمربع "إبلاغ الوكلاء" في واجهة الوكيل.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'الحد الأقصى للحجم (في صفوف) لمربع "الوكلاء المعنيون" في واجهة الوكيل.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'الحد الأقصى لطول الموضوع في الرد بالبريد الإلكتروني وفي بعض شاشات النظرة العامة.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'الحد الأقصى لعدد استجابات البريد الإلكتروني التلقائية لعنوان البريد الإلكتروني الخاص بك في اليوم (الحماية من التكرار).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            'الحد الأقصى لعدد استجابات البريد الإلكتروني التلقائية لعنوان البريد الإلكتروني الخاص بك في اليوم (الحماية من التكرار).',
        'Maximal number of results returned by ES per field.' => 'الحد الأقصى لعدد نتائج إخراج ES لكل حقل.',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'الحد الأقصى للحجم بالكيلوبايت لرسائل البريد الإلكتروني المستلمة عبر POP3/POP3S/IMAP/IMAPS (بالكيلوبايت).',
        'Maximum Number of a calendar shown in a dropdown.' => 'الحد الأقصى لعدد التقويمات المعروضة في قوائم التحديد.',
        'Maximum file size for the ingest plugin.' => 'الحد الأقصى لحجم الملف لاستيعاب المكون الإضافي.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'الحد الأقصى للطول (بالأحرف) للحقل الديناميكي في مقالة عرض تكبير التكبير/التصغير للتذكرة.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'الحد الأقصى للطول (بالأحرف) للحقل الديناميكي في الشريط الجانبي لعرض تكبير/تصغير التذاكر.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            'الحد الأقصى لعدد التقويمات النشطة في شاشات النظرة العامة. يرجى ملاحظة أن عددا كبيرا من التقويمات النشطة يمكن أن يكون له تأثير على الأداء على الخادم الخاص بك بسبب العديد من الاستعلامات المتزامنة.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'الحد الأقصى لعدد التذاكر التي سيتم عرضها في نتيجة البحث الخاصة بواجهة الوكيل.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'الحد الأقصى لعدد التذاكر التي سيتم عرضها في نتيجة البحث الخاصة بواجهة العميل.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'الحد الأقصى لعدد التذاكر التي سيتم عرضها نتيجة لهذا الإجراء.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'الحد الأقصى لعدد الأحرف لجدول معلومات العميل في عرض تكبير التذاكر.',
        'Medium' => 'وسط',
        'Merge this ticket and all articles into another ticket' => 'ادمج هذه التذكرة وجميع المقالات في تذكرة أخرى',
        'Merged Ticket (%s/%s) to (%s/%s).' => 'تم دمج التذكرة (‎%s/%s) مع (‎%s/%s).',
        'Merged Ticket <OTOBO_TICKET> to <OTOBO_MERGE_TO_TICKET>.' => 'تم دمج التذكرة <OTOBO_TICKET> في <OTOBO_MERGE_TO_TICKET>.',
        'Minute' => 'دقيقة',
        'Miscellaneous' => 'مُتَنَوِّع',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'وحدة لتحديد "إلى" في شاشة إنشاء تذكرة في منطقة العميل.',
        'Module to check if a incoming e-mail message is bounce.' => 'وحدة التحقق لاكتشاف ما إذا كان البريد الإلكتروني الوارد هو بريد إلكتروني مرفوض.',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            'وحدة للتحقق مما إذا كان يجب وضع علامة على رسائل البريد الإلكتروني الواردة على أنها داخلية بسبب بريد إلكتروني داخلي تمت إعادة توجيهه مسبقا. يقوم IsVisibleForCustomer و SenderType بتعيين قيم البريد الإلكتروني/العنصر الوارد.',
        'Module to check the group permissions for customer access to tickets.' =>
            'وحدة للتحقق من أذونات المجموعة لوصول العملاء إلى التذاكر.',
        'Module to check the group permissions for the access to tickets.' =>
            'الوحدة النمطية للتحقق من أذونات المجموعة للوصول إلى التذاكر.',
        'Module to compose signed messages (PGP or S/MIME).' => 'وحدة لإنشاء الرسائل الموقعة (PGP أو S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            'وحدة لتحديد خيار أمان البريد الإلكتروني المستخدم (PGP أو S/MIME).',
        'Module to encrypt composed messages (PGP or S/MIME).' => 'وحدة لإنشاء رسائل مشفرة (PGP أو S/MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            'وحدة لتحديد شهادات SMIME الخاصة بمستخدم العميل للرسائل الواردة.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'وحدة نمطية لتصفية الرسائل الواردة ومعالجتها. حظر/تجاهل كافة رسائل البريد الإلكتروني العشوائي بعنوان من: noreply@.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'وحدة لتصفية وتعديل الرسائل الواردة. على سبيل المثال، استخرج رقما مكونا من أربعة أرقام من الموضوع (SomeNumber: 1234) وقم بتخزينه في حقل ديناميكي عن طريق إنشاء مفتاح "Subject" بالتعبير العادي "SomeNumber:(\d\d\d\d\d)" في "Match" ومفتاح "X-OTOBO-DynamicField-Name" بقيمة "[***]" في "Set".',
        'Module to filter encrypted bodies of incoming messages.' => 'وحدة لتصفية النصوص المشفرة على الرسائل الواردة.',
        'Module to generate accounted time ticket statistics.' => 'وحدة لتوليد الإحصاءات لوقت المعالجة المطلوب.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'وحدة لإنشاء ملف تعريف HTML OpenSearch للبحث السريع عن التذكرة في منطقة الوكيل.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'وحدة لإنشاء ملف تعريف HTML OpenSearch للبحث السريع عن التذاكر في منطقة العميل.',
        'Module to generate ticket solution and response time statistics.' =>
            'وحدة نمطية لإنشاء إحصاءات الحلول ووقت الاستجابة.',
        'Module to generate ticket statistics.' => 'وحدة لإنشاء إحصاءات التذاكر.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            'الوحدة النمطية لمنح حق الوصول إذا كان معرف العميل الخاص بالعميل لديه أذونات المجموعة اللازمة.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'وحدة لمنح حق الوصول إذا كان معرف العميل الخاص بالتذكرة يتطابق مع معرف العميل الخاص بالعميل.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'وحدة لمنح حق الوصول إذا كان CustomerUserID للتذكرة يتطابق مع CustomerUserID للعميل.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'وحدة للسماح بالوصول لأي وكيل شارك في أي وقت مضى في تذكرة (بناء على الإدخالات في سجل التذاكر).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'وحدة للسماح بالوصول إلى تذكرة من قبل الوكيل المسؤول.',
        'Module to grant access to the creator of a ticket.' => 'وحدة للسماح بالوصول إلى تذكرة من قبل الوكيل الذي أنشأ التذكرة في الأصل.',
        'Module to grant access to the owner of a ticket.' => 'وحدة للسماح بالوصول إلى تذكرة من قبل الوكيل الذي يملك التذكرة.',
        'Module to grant access to the watcher agents of a ticket.' => 'وحدة للسماح بالوصول إلى تذكرة من قبل الوكلاء الذين يراقبون التذكرة.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'وحدة لإظهار الإخطارات والتصعيد (ShownMax: الحد الأقصى للتصعيد المعروض، EscalationInMinutes: إظهار التذكرة التي سيتم تصعيدها، CacheTime: ذاكرة التخزين المؤقت للتصعيد المحسوب بالثواني).',
        'Module to use database filter storage.' => 'الوحدة النمطية لاستخدام قاعدة بيانات تخزين المرشح.',
        'Module used to detect if attachments are present.' => 'وحدة للتحقق من وجود المرفقات.',
        'My Queues' => 'قوائم الانتظار الخاصة بي',
        'My Services' => 'خدماتي',
        'My last changed tickets' => 'التذاكر المعدلة مؤخرا',
        'MyLastChangedTickets dashboard widget.' => 'أداة لوحة معلومات التذاكر المعدلة مؤخرا.',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'تعيين مجموعة قائمة الانتظار الشخصية الخاصة بك. "قوائم الانتظار الخاصة بي" عبارة عن تجميع لقوائم الانتظار المفضلة لديك، والتي يمكن تهيئتها في الإعدادات الشخصية.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'تعيين مجموعة الخدمات الشخصية الخاصة بك. "خدماتي" هي مجموعة من الخدمات المفضلة التي يمكن تهيئتها في الإعدادات الشخصية.',
        'NameX' => 'NameX',
        'New Tickets' => 'تذاكر جديدة',
        'New Window' => 'نافذة جديدة',
        'New Year\'s Day' => 'عيد رأس السنة',
        'New Year\'s Eve' => 'ليلة رأس السنة الجديدة',
        'New process ticket' => 'تذكرة عملية جديدة',
        'News about OTOBO.' => 'أخبار عن OTOBO.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'حالات المتابعة المحتملة للتذاكر بعد إضافة ملاحظة هاتفية من شاشة المكالمة الواردة في لوحة الوكيل.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'حالات المتابعة المحتملة للتذاكر بعد إضافة ملاحظة هاتفية من شاشة المكالمة الصادرة في لوحة الوكيل.',
        'No public key found.' => 'لم يتم العثور على مفتاح عام.',
        'No valid OpenPGP data found.' => 'لم يتم العثور على بيانات OpenPGP صالحة.',
        'None' => 'لا شَيْء',
        'Norwegian' => 'النرويجية',
        'Notification Settings' => 'إعدادات الإخطار',
        'Notified about response time escalation.' => 'تم الإخطار بتصعيد وقت الاستجابة.',
        'Notified about solution time escalation.' => 'تم الإخطار بتصعيد وقت الحل.',
        'Notified about update time escalation.' => 'تم الإخطار بتصعيد وقت التحديث.',
        'Number of displayed tickets' => 'عدد التذاكر المعروضة',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'عدد الصفوف (لكل تذكرة) التي يتم عرضها عبر أداة البحث في منطقة الوكيل.',
        'Number of shards (NS), replicas (NR) and fields limit for the index \'ticket\'.' =>
            'عدد الأجزاء (shards) (NS) والنسخ المتماثلة (NR) والحد الأقصى للحقل لفهرس "التذكرة".',
        'Number of shards (NS), replicas (NR) and fields limit for the index. Note: \'Elasticsearch::ArticleIndexCreationSettings\' is deprecated. For upwards compatibility use \'Elasticsearch::IndexSettings###Default\' instead.' =>
            'عدد الأجزاء (NS) والنسخ المتماثلة (NR) وحد الحقل للفهرس. ملاحظة: لم يعد يتم استخدام "Elasticsearch::ArticleIndexCreationSettings". بدلا من ذلك، استخدم "Elasticsearch::IndexSettings###Default" لضمان التوافق مع الإصدارات الأحدث.',
        'Number of shards (NS), replicas (NR) and fields limit for the indices. This replaces \'Elasticsearch::ArticleIndexCreationSettings\' in future versions. If both are present and not equal this one has priority. Use \'Elasticsearch::IndexSettings###...\' if you want to define special settings for single indices.\'...\' may be one of \'Customer\', \'CustomerUser\', \'Ticket\' or \'ConfigItem\'.' =>
            'عدد الأجزاء (NS) والنسخ المتماثلة (NR) وحد الحقل للفهارس. يحل هذا الإعداد محل "Elasticsearch::ArticleIndexCreationSettings" في الإصدارات الأحدث. إذا كان كلا الإعدادين موجودين ويختلفان، تحديد أولوياتهما. استخدم "Elasticsearch::IndexSettings###... " لتحديد إعدادات محددة للفهارس الفردية. \'. . . \' يمكن أن تكون إحدى القيم التالية: "Customer" أو "CustomerUser" أو "Ticket" أو "ConfigItem".',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'عدد التذاكر لكل صفحة في نتائج البحث في منطقة الوكيل.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'عدد التذاكر المراد عرضها لكل صفحة في نتيجة بحث في واجهة العميل.',
        'OTOBO News' => 'أخبار من OTOBO',
        'OTOBO Team Services' => 'خدمات فريق OTOBO',
        'OTOBO can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'يمكن ل OTOBO استخدام قاعدة بيانات متطابقة واحدة أو أكثر للعمليات المعقدة مثل عمليات البحث عن النص الكامل أو إنشاء الإحصاءات. هنا يمكنك تخزين DSN لقاعدة بيانات النسخة المتطابقة الأولى.',
        'OTOBO doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            'لا يدعم OTOBO المواعيد المتكررة بدون تاريخ انتهاء أو عدد التكرارات. أثناء عملية الاستيراد، قد يحدث أن يحتوي ملف ICS على مثل هذه المواعيد. بدلا من ذلك، يقوم النظام بإنشاء جميع المواعيد في الماضي، بالإضافة إلى المواعيد للأشهر N التالية (120 شهرا / 10 سنوات افتراضيا).',
        'Object backend module registration for the import/export module.' =>
            '',
        'Objects to search for, how many entries and which attributs to show.' =>
            'يحدد الكائنات التي سيتم البحث عنها، وعدد الإدخالات، والسمات التي سيتم عرضها.',
        'Objects to search for, how many entries and which attributs to show. Ticket attributes, except queue, have to explicitely be stored via Elasticsearch.' =>
            'يحدد الكائنات التي سيتم البحث عنها، وعدد الإدخالات، والسمات التي سيتم عرضها. يجب تخزين جميع سمات التذاكر باستثناء قائمة الانتظار بشكل صريح في Elasticsearch.',
        'Open an external link!' => 'افتح الرابط الخارجي!',
        'Open the OTOBO home page in a new window' => 'يفتح صفحة OTOBO الرئيسية في نافذة جديدة',
        'Open tickets (customer user)' => 'التذاكر المفتوحة (مستخدمو العملاء)',
        'Open tickets (customer)' => 'التذاكر المفتوحة (العميل)',
        'Option' => 'خيار',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'تقييد اختياري لقوائم الانتظار لوحدة إذن CreatorCheck. إذا تم تعيينها، يتم منح الإذن فقط للتذاكر في قوائم الانتظار المحددة هنا.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'قيود اختيارية على قوائم الانتظار لوحدة أذونات InvolvedCheck. إذا تم تعيينها، يتم منح الإذن فقط للتذاكر في قوائم الانتظار المحددة هنا.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'قيود اختيارية على قوائم الانتظار لوحدة إذن التحقق من المالك. إذا تم تعيينها، يتم منح الإذن فقط للتذاكر في قوائم الانتظار المحددة هنا.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'تقييد اختياري لقوائم الانتظار لوحدة إذن Responsible Check. إذا تم تعيينها، يتم منح الإذن فقط للتذاكر في قوائم الانتظار المحددة هنا.',
        'Other Customers' => 'عملاء آخرون',
        'Out Of Office' => 'حاليا ليس في المكتب',
        'Out Of Office Time' => 'مدة الغياب',
        'Out of Office users.' => 'المستخدمين الغائبين.',
        'Outbound request headers not allowed to be used in frontend configuration.' =>
            'رؤوس الطلبات الصادرة التي يجب عدم استخدامها في تكوين الواجهة الأمامية.',
        'Outbound response headers not allowed to be used in frontend configuration.' =>
            'رأس (headers) الردود الصادرة التي يجب عدم استخدامها في تكوين الواجهة الأمامية.',
        'Output filter to inject the necessary Dynamic field names in hidden input.' =>
            'مُصفِّي النتائج لإخفاء أسماء الحقول الديناميكية المطلوبة.',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'يعيد تحميل الوظائف الموجودة في Kernel::System::Ticket (إعادة تعريف). يمكن استخدامه لإجراء التعديلات بأكبر سهولة ممكنة.',
        'Overview Escalated Tickets.' => 'نظرة عامة على التذاكر المتصاعدة.',
        'Overview Refresh Time' => 'أوقات التحديث للنظرة العامة',
        'Overview of all Tickets per assigned Queue.' => 'نظرة عامة على جميع التذاكر حسب قائمة الانتظار المُعيَّنة.',
        'Overview of all appointments.' => 'نظرة عامة على جميع المواعيد.',
        'Overview of all escalated tickets.' => 'نظرة عامة على جميع التذاكر المتصاعدة.',
        'Overview of all open Tickets.' => 'نظرة عامة على جميع التذاكر المفتوحة.',
        'Overview of all open tickets.' => 'نظرة عامة على جميع التذاكر المفتوحة.',
        'Overview of customer tickets.' => 'نظرة عامة على تذاكر العملاء.',
        'PGP Key' => 'مفتاح PGP',
        'PGP Key Management' => 'إدارة مفاتيح PGP',
        'PGP Keys' => 'مفتاح PGP',
        'Package event module file a scheduler task for update registration.' =>
            'الوحدة النمطية لجدولة تحديث سجل النظام تلقائيا.',
        'Package event module trigger package reinstall in containers.' =>
            'وحدة لتنشيط إعادة تثبيت الحزمة تلقائيًا في الحاويات.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'المعلمة الخاصة بكائن CreateNextMask في إعدادات المستخدمين في واجهة الوكلاء. يُرجى ملاحظة: عند تعيين \'Active\' على 0، فإن ذلك يمنع فقط الوكلاء من تغيير إعدادات هذه المجموعة في إعداداتهم الشخصية. يمكن للمسؤول متابعة تعديل هذه الإعدادات باسم المستخدمين. استخدم \'PreferenceGroup\' للتحكم في المجال الذي يتم عرض هذه الإعدادات في واجهة المستخدم.',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'معاملات كائن CustomQueue في إعدادات المستخدمين في واجهة الوكلاء. يُرجى ملاحظة: عند تعيين \'Active\' على 0، فإن ذلك سيمنع الوكلاء فقط من تعديل إعدادات هذه المجموعة في تفضيلاتهم الشخصية، ولكن سيسمح للمسؤولين بتعديل إعدادات مستخدم آخر بالنيابة عنه. استخدم \'PreferenceGroup\' للتحكم في المجال الذي يجب عرض هذه الإعدادات في واجهة المستخدم.',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'معاملات كائن CustomService في واجهة إعدادات واجهة الوكلاء. يُرجى ملاحظة: عند تعيين \'Active\' على 0، فإن ذلك سيمنع الوكلاء فقط من تعديل إعدادات هذه المجموعة في تفضيلاتهم الشخصية، ولكن سيسمح للمسؤولين بتعديل إعدادات مستخدم آخر بالنيابة عنه. استخدم \'PreferenceGroup\' للتحكم في المجال الذي يجب عرض هذه الإعدادات في واجهة المستخدم.',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'معاملات كائن RefreshTime في واجهة إعدادات واجهة الوكلاء. يُرجى ملاحظة: عند تعيين \'Active\' على 0، فإن ذلك سيمنع الوكلاء فقط من تعديل إعدادات هذه المجموعة في تفضيلاتهم الشخصية، ولكن سيسمح للمسؤولين بتعديل إعدادات مستخدم آخر بالنيابة عنه. استخدم \'PreferenceGroup\' للتحكم في المجال الذي يجب عرض هذه الإعدادات في واجهة المستخدم.',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'معاملات مرشحات الأعمدة لنظرة عامة عن تذاكر Small-Ticket. يُرجى ملاحظة: عند تعيين \'Active\' على 0، فإن ذلك سيمنع الوكلاء فقط من تعديل إعدادات هذه المجموعة في تفضيلاتهم الشخصية، ولكن سيسمح للمسؤولين بتعديل إعدادات مستخدم آخر بالنيابة عنه. استخدم \'PreferenceGroup\' للتحكم في المجال الذي يجب عرض هذه الإعدادات في واجهة المستخدم.',
        'Parameters for the dashboard backend of the closed tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'معلمات الواجهة الخلفية للوحة المعلومات لنظرة عامة عن التذاكر المغلقة في واجهة الوكلاء. "Limit" هو عدد الإدخالات المعروضة بشكل افتراضي. يُستخدم "Group" لتقييد الوصول إلى المكون الإضافي (مثال: Group: admin;group1;group2;). "Default" يحدد ما إذا كان يجب تمكين المكون الإضافي تلقائيًا كإعداد افتراضي أو يجب على المستخدم تمكينه يدويًا. "CacheTTLLocal" هو وقت التخزين المؤقت بالدقائق للمكون الإضافي. ملاحظة: يُسمح فقط بسمات التذاكر والحقول الديناميكية (DynamicField_NameX) كأعمدة افتراضية (DefaultColumns).',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'يحدد المعلمات لواجهة الخلفية للوحة المعلومات. "Group" يحد من الوصول إلى الوحدة الصغيرة المعينة (مثال: Group: admin;group1;group2). "Default" يحدد ما إذا كانت الوحدة الصغيرة مفعّلة افتراضيًا أو يجب تفعيلها يدويًا بواسطة المستخدم. "CacheTTLLocal" يحدد فترة التخزين المؤقت للوحدة الصغيرة بالدقائق.',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Limit" يحدد عدد العناصر التي يتم عرضها افتراضيًا. "Group" يحد من الوصول إلى الداشليت المحدد (مثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي الداشليت مفعلًا افتراضيًا أم يجب تفعيله يدويًا بواسطة المستخدم. "CacheTTLLocal" يحدد مدة التخزين المؤقت للداشليت بالدقائق.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات لعنصر واجهة عرض حالة رقم العميل في منطقة الوكلاء. باستخدام "Group" يمكن تقييد الوصول إلى المكون الإضافي (على سبيل المثال: Group: admin;group1;group2;). يحدد "Default" ما إذا كان المكون الإضافي يجب تمكينه تلقائيًا أم يجب على المستخدم تمكينه يدويًا. يحدد "CacheTTLLocal" مدة التخزين المؤقت للمكون الإضافي بالدقائق.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (مثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي يجب أن يكون نشطًا افتراضيًا أو يجب على المستخدم تفعيله يدويًا. "CacheTTLLocal" يحدد مدة التخزين المؤقت للمكوّن الإضافي بالدقائق.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'معاملات واجهة الخلفية لوحة المعلومات لعنصر عرض قائمة العملاء في منطقة الوكلاء. "Limit" يحدد عدد العناصر المعروضة افتراضيًا. يمكن استخدام "Group" لتقييد الوصول إلى المكون الإضافي (على سبيل المثال: Group: admin;group1;group2;). "Default" يحدد ما إذا كان المكون الإضافي يجب تمكينه تلقائيًا أم يجب على المستخدم تمكينه يدويًا. "CacheTTLLocal" يحدد مدة تشغيل ذاكرة التخزين المؤقت للمكون الإضافي بالدقائق.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Limit" يحدد عدد العناصر التي يتم عرضها افتراضيًا. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (مثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي يجب أن يكون نشطًا افتراضيًا أو يجب على المستخدم تفعيله يدويًا. "CacheTTLLocal" يحدد مدة التخزين المؤقت للمكوّن الإضافي بالدقائق. يمكن استخدام "Mandatory" لتكوين المكوّن الإضافي بحيث لا يمكن للمستخدمين إخفاؤه.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'تحدد المعلمات لوحة التحكم الخلفية. يحدد "الحد" عدد العناصر المعروضة افتراضيًا. "المجموعة" يحدد الوصول إلى اللوحة الخاصة به (مثال: المجموعة: admin;group1;group2). "الافتراضي" يحدد ما إذا كانت اللوحة مفعلة افتراضيًا أم يجب تفعيلها يدويًا من قبل المستخدم. "CacheTTLLocal" يحدد مدة التخزين المؤقت للوحة التحكم في الدقائق. ملاحظة: يُسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) ل DefaultColumns.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'تحدد المعلمات لوحة التحكم الخلفية. "الحد" يحدد عدد العناصر التي يتم عرضها افتراضيًا. "المجموعة" يحدد الوصول إلى اللوحة الفرعية المعينة (مثال: المجموعة: admin;group1;group2). "الافتراضي" يحدد ما إذا كانت اللوحة الفرعية نشطة افتراضيًا أم يجب تنشيطها يدويًا من قبل المستخدم. "CacheTTLLocal" يحدد مدة التخزين المؤقت للوحة الفرعية في الدقائق. يمكن استخدام "Mandatory" لتكوين اللوحة الفرعية بحيث لا يمكن للمستخدمين إخفاؤها. ملاحظة: يُسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) ل DefaultColumns.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'يحدد المعلمات لوحة التحكم الخلفية. يحدد "الحد" عدد الإدخالات التي يتم عرضها افتراضيًا. يحدد "المجموعة" الوصول إلى اللوحة الجانبية المعينة (مثال: المجموعة: admin;group1;group2). يحدد "الافتراضي" ما إذا كانت اللوحة الجانبية مفعلة افتراضيًا أم يجب تفعيلها يدويًا بواسطة المستخدم. يحدد "CacheTTLLocal" مدة التخزين المؤقت للوحة الجانبية بالدقائق. ملاحظة: يُسمح فقط بسمات التذكرة والحقول الديناميكية (DynamicField_NameX) ل DefaultColumns.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'يحدد المعلمات لوحة التحكم الخلفية. "الحد" يحدد عدد الإدخالات التي يتم عرضها افتراضيًا. "المجموعة" يحدد الوصول إلى لوحة التحكم المعينة (على سبيل المثال: المجموعة: admin;group1;group2). "QueuePermissionGroup" يحدد (عند التمكين) أنه يتم سرد الطوابير التي تنتمي إلى مجموعة الصلاحيات المقابلة. "الحالات" هي قائمة من الحالات، حيث يكون المفتاح هو ترتيب الفرز للحالة في العنصر البياني. "الافتراضي" يحدد ما إذا كانت لوحة التحكم مفعلة افتراضيًا أم يجب تفعيلها يدويًا بواسطة المستخدم. "CacheTTLLocal" يحدد مدة التخزين المؤقت للوحة التحكم بالدقائق.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Limit" يحدد عدد العناصر التي يتم عرضها افتراضيًا. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (على سبيل المثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي يجب أن يكون نشطًا افتراضيًا أم يجب على المستخدم تفعيله يدويًا. "CacheTTLLocal" يحدد مدة التخزين المؤقت للمكوّن الإضافي بالدقائق. بواسطة "Mandatory" يمكن تكوين المكوّن الإضافي بحيث يتعذر على المستخدمين إخفاؤه.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Limit" يحدد عدد العناصر التي سيتم عرضها افتراضيًا. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (على سبيل المثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي سيكون نشطًا افتراضيًا أم يجب على المستخدم تفعيله يدويًا. "CacheTTLLocal" يحدد مدة التخزين المؤقت للمكوّن الإضافي بالدقائق. يمكن تكوين المكوّن الإضافي بواسطة "Mandatory" بحيث يتعذر على المستخدمين إخفاؤه. ملاحظة: يمكن استخدام DefaultColumns فقط لسمات التذاكر والحقول الديناميكية (DynamicField_NameX).',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Limit" يحدد عدد العناصر التي ستظهر افتراضيًا. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (مثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي سيكون نشطًا افتراضيًا أم يجب على المستخدم تفعيله يدويًا. "CacheTTLLocal" يحدد مدة التخزين المؤقت للمكوّن الإضافي بالدقائق. ملاحظة: يسمح فقط بسمات التذاكر والحقول الديناميكية (DynamicField_NameX) كعمود افتراضي (DefaultColumns).',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'معلمات واجهة الخلفية لوحة معلومات مراجعة تصعيد التذاكر في واجهة الوكيل. "Limit" هو عدد الإدخالات التي يتم عرضها افتراضيًا. "Group" يستخدم لتقييد الوصول إلى المكون الإضافي (على سبيل المثال: Group: admin;group1;group2;). "Default" يحدد ما إذا كان المكون الإضافي مفعلًا افتراضيًا أم يجب على المستخدم تمكينه يدويًا. "CacheTTLLocal" هو وقت التخزين المؤقت بالدقائق للمكون الإضافي. ملاحظة: يُسمح فقط بسمات التذاكر والحقول الديناميكية (DynamicField_NameX) كأعمدة افتراضية (DefaultColumns).',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Limit" يحدد عدد العناصر التي ستظهر افتراضيًا. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (على سبيل المثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي سيكون نشطًا افتراضيًا أم يجب على المستخدم تفعيله يدويًا. "CacheTTLLocal" يحدد مدة التخزين المؤقت للمكوّن الإضافي بالدقائق. يمكن استخدام "Mandatory" لتكوين المكوّن الإضافي بحيث يتعذر على المستخدمين إخفاؤه.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'تحدد المعلمات لواجهة الخلفية لوحة المعلومات. "Limit" يحدد عدد العناصر التي ستعرض افتراضيًا. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (على سبيل المثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي سيكون نشطًا افتراضيًا أم يجب على المستخدم تمكينه يدويًا. "CacheTTLLocal" يحدد مدة تخزين الذاكرة المؤقتة للمكوّن الإضافي بالدقائق. يمكن استخدام "Mandatory" لتكوين المكوّن الإضافي بحيث لا يمكن للمستخدمين إخفاؤه. ملاحظة: يُسمح فقط بسمات التذاكر والحقول الديناميكية (DynamicField_NameX) كأعمدة افتراضية (DefaultColumns).',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'يحدد المعلمات لواجهة الخلفية لوحة المعلومات. يحدد "Limit" عدد العناصر التي يتم عرضها افتراضيًا. "Group" يحد من الوصول إلى المكوّن الإضافي المحدد (مثال: Group: admin;group1;group2). "Default" يحدد ما إذا كان المكوّن الإضافي يجب أن يكون نشطًا افتراضيًا أم يجب على المستخدم تفعيله يدويًا. "CacheTTLLocal" يحدد مدة التخزين المؤقت للمكوّن الإضافي بالدقائق. ملاحظة: يُسمح فقط بسمات التذاكر والحقول الديناميكية (DynamicField_NameX) كأعمدة افتراضية (DefaultColumns).',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Parent' => 'أساس',
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path to CKEditor content CSS file. Changes to this setting will only consistently apply after deleting the OTOBO Cache via the Maint::Cache::Delete command!' =>
            '',
        'Path to CKEditor editor CSS file. Changes to this setting will only consistently apply after deleting the OTOBO Cache via the Maint::Cache::Delete command!' =>
            '',
        'Pending time' => '',
        'People' => '',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permanent' => '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => '',
        'Phone Call Inbound' => '',
        'Phone Call Outbound' => '',
        'Phone Call.' => '',
        'Phone call' => 'مكالمة هاتفية',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'بطاقة-هاتف',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => '',
        'Please click the button below to create your first ticket.' => '',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Print this ticket' => '',
        'Priorities' => 'أولوية',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Processes & Automation' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Protection against brute force attacks. MaxAttempt: How many login attempts are allowed before a ban. BanDuration: Duration of the ban. KeepCacheDuration: How long failed attempts are remembered.' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '',
        'Public Interface' => '',
        'Public calendar.' => '',
        'Queue view' => '',
        'Queues ↔ Auto Responses' => '',
        'Quick Close' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Rebuilds Elasticsearch indices. Can be used for example, if CustomerUsers are authenticated via LDAP. Highly inefficient however, as the whole index is rebuild every time.' =>
            '',
        'Rebuilds the ACL preselection cache.' => '',
        'Rebuilds the escalation index.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Redis server address. Example: 127.0.0.1:6379.' => '',
        'Refresh interval' => '',
        'Registers a link in the ticket menu of ticket overviews to mark all articles of the ticket as seen.' =>
            '',
        'Registers a link in the ticket menu of ticket overviews to mark all articles of the ticket as unseen.' =>
            '',
        'Registers a link in the ticket menu to mark a ticket as seen.' =>
            '',
        'Registers a link in the ticket menu to mark a ticket as unseen.' =>
            '',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Registration of the CSV format backend module for the ImportExport feature.' =>
            '',
        'Registration of the JSON format backend module for the ImportExport feature.' =>
            '',
        'Reminder Tickets' => '',
        'Removed subscription for user "%s".' => 'Removed subscription for user "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use quick close in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Richtext' => '',
        'Right' => '',
        'Roles ↔ Groups' => '',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing contacts with data when accessing the AdminContactWD module.' =>
            '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'يُشغِّل بحثًا أوليًا باستخدام الرموز البارزة لشركة العميل الحالية عند الوصول إلى وحدة AdminCustomerCompany.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => '',
        'S/MIME Certificates' => '',
        'SLAs' => '',
        'Salutations' => 'تحايا',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTOBO user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used. "S3" is experimental.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen after new ticket' => 'الشاشة بعد إنشاء بطاقة جديدة',
        'Script (Template Toolkit)' => '',
        'Search Customer' => 'البحث عن عميل',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => '',
        'Second Christmas Day' => '',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the algorithm used for encryption. Fallback is aes256. Try "/usr/bin/openssl enc -ciphers" to get a list of ciphers supported by your system (written without the leading \'-\').' =>
            '',
        'Select the main interface language.' => '',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTOBO.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => '',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to Rother OSS.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '',
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '',
        'Sent auto reject to "%s".' => '',
        'Sent auto reply to "%s".' => '',
        'Sent email to "%s".' => '',
        'Sent email to customer.' => '',
        'Sent notification to "%s".' => '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service Level Agreements' => '',
        'Service view' => '',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for quick close action in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of split tickets in the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the preferred digest to be used for PGP binary.' => '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTOBO_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the time zone being used internally by OTOBO to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTOBO time zone and the user\'s time zone.' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Settings for the customer login screen.' => '',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show command line output.' => '',
        'Show or Hide deleted articles.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Show the ticket history' => '',
        'Show various content.' => '',
        'ShowHideDeletedArticles' => '',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to quick close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to quick close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to show/hide deleted articles in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTOBO Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '',
        'Signature data.' => '',
        'Signatures' => 'التوقيعات',
        'Simple' => '',
        'Skin' => '',
        'Slovak' => '',
        'Slovenian' => '',
        'Small' => 'صغير',
        'Software Package Manager.' => '',
        'Solution time' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com). You can use the OTOBO_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward and bounce. Make sure that "rw" is always the last registered permission, as rw automatically grants all additional permissions.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => '',
        'State pre-selection for Templates' => '',
        'States' => 'الحالة',
        'Statistics overview.' => '',
        'Statistics reports.' => '',
        'Status view' => '',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strict' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Suspend already escalated tickets.' => '',
        'Swahili' => '',
        'Swedish' => '',
        'Switch deleted article status view' => '',
        'Switch deleted article status view.' => '',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Configuration Setting History' => '',
        'System Maintenance' => '',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '',
        'Textarea' => '',
        'Thai' => '',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for sync with S3.' => '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The daemon registration for the system configuration deployment sync manager.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo and signet shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server. The signet will be scaled to 32px*32px, the logo to 196px*32px. (In the mobile setup both have a height of 24px with variable length.)' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'The value of the From field' => '',
        'Theme' => 'الثيم',
        'This configuration defines all possible screens to enable or disable default columns.' =>
            '',
        'This configuration defines all possible screens to enable or disable dynamic fields.' =>
            '',
        'This configuration defines if only valids or all (invalids) dynamic fields should be shown.' =>
            '',
        'This configuration defines the number of iterations that should be performed at max for calculating the WorkingTime for a Ticket. Attention: Setting this configuration to high can lead to performance issues.' =>
            '',
        'This configuration registers an OutputFilter module that injects the javascript functionality to remove PendingTime.' =>
            '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is being used to extend the password policy.' => '',
        'This module is part of the admin area of OTOBO.' => '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This option sets additional quick date buttons to pending dates. For ordering purposes one hash entry per array segment has to be set. The key is the button name, value is the value, where a single number n sets the date to n days from now, +n adds n days to the currently set date, and -n subtracts them.' =>
            '',
        'This option will deny the access to customer company tickets, which are not created by the customer user. Please also deactivate "CustomerFrontend::Navigation###CustomerTicketOverview###002-Ticket" so that the button is no longer visible.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'This setting is deprecated. Set OTOBOTimeZone instead.' => '',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '',
        'Ticket Close' => '',
        'Ticket Close.' => '',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => '',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => '',
        'Ticket Lock.' => '',
        'Ticket Masks' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => '',
        'Ticket Notifications' => '',
        'Ticket Outbound Email.' => '',
        'Ticket Overview "Medium" Limit' => '',
        'Ticket Overview "Preview" Limit' => '',
        'Ticket Overview "Small" Limit' => '',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => '',
        'Ticket Responsible.' => '',
        'Ticket States' => '',
        'Ticket Types' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => '',
        'Ticket overview' => '',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket state pre-selection for response templates' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets in the following queues will not be stored on the Elasticsearch server. To apply this to existing tickets, the ticket migration has to be run via console, after changing this option.' =>
            '',
        'Tickets.' => '',
        'Tile registration for the CustomerDashboard. Module is required.' =>
            '',
        'Tile registration for the CustomerDashboard. Module is required. Optionally, an order for items can be set. The order must have the name of the item as key and the desired position as integer value.' =>
            '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'To view HTML attachments.' => '',
        'Toggles display of OTOBO FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Translate the country names in the country selection. The CLDR country codes will be stored in the database. Requires that Locale::CLDR and the relevant language packs are installed.' =>
            '',
        'Translate the language names in the language selection. Requires that Locale::CLDR and the relevant language packs are installed.' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => '',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => '',
        'Type of daemon log rotation to use: Choose \'OTOBO\' to let OTOBO system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'التاريخ::إعادة فتح',
        'Upcoming Events' => 'الأحداث القادمة',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update time' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use Redis::Fast instead of Redis.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use specified Redis logical database.' => '',
        'User Profile' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => '',
        'View performance benchmark results.' => '',
        'View stored article version.' => '',
        'Watch this ticket' => '',
        'Watched Tickets' => 'البطاقات المراقبة',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'We have changed the default ticket unlock behaviour in OTOBO 10.1. Now, the ticket is not only unlocked, but also handed over to the system user again. Thus, the behaviour is clearer, but it is no longer possible to read out who last edited the ticket. Please deactivate this option to restore the behaviour of OTRS versions 2 to 6 and OTOBO version 10.0.' =>
            '',
        'Web Service' => '',
        'Web Services' => '',
        'Welcome text for the dashboard header. Name will be inserted to %s of the WelcomeText. "UserTitle", "UserFirstname", "UserLastname", "UserEmail" and "UserLogin" will be substituted.' =>
            '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether extended customer information is shown in the ticket print screen of the customer interface.' =>
            '',
        'Whether fields should be automatically filled (1), and in that case also be hidden from ticket formulars (2).' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether the execution of TicketACL can be avoided by checking cached field dependencies. This can improve loading times of ticket formulars, but has to be disabled, if ACLModules are to be used for Ticket- and Form-ReturnTypes.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTOBO_TICKET>" is bounced to "<OTOBO_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your email with ticket number "<OTOBO_TICKET>" is merged to "<OTOBO_MERGE_TO_TICKET>".' =>
            'بريدك مع رقم البطاقة  "<OTOBO_TICKET>" دمجت مع "<OTOBO_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'تكبير',
        'attachment' => 'مُرْفَقٌ',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'normal' => 'عادي',
        'notice' => 'مُلاحَظَة',
        'pending' => 'مُعَلّق',
        'phone' => 'رقم الهاتف',
        'responsible' => '',
        'reverse' => 'عكس',
        'stats' => 'إحصائيات',

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
        'All translations must be filled!',
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
        'Are you sure you want to delete this article?',
        'Are you sure you want to remove all user values?',
        'Are you sure you want to restore this article?',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article Delete',
        'Article Restore',
        'Article already marked as deleted.',
        'Article deleted successfully!',
        'Article display',
        'Article filter',
        'Article not available for restoring.',
        'Article restored successfully!',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'At least one translation must be filled!',
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
        'Close',
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
        'Delete this template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting template...',
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
        'Do you really want to delete this customer dashboard info tile entry?',
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
        'Error trying to create CodeMirror instance, please check configuration!',
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
        'Information',
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
        'Missing Translations',
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
        'Template was deleted successfully.',
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
        'There was an error deleting the template. Please check the logs for more information.',
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
