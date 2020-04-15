# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2010-2011 Kaz Kamimura <kamypus at yahoo.co.jp>
# Copyright (C) 2011/12/08 Kaoru Hayama TIS Inc.
# Copyright (C) 2014 Norihiro Tanaka NTT Data Intellilink Corp.
# Copyright (C) 2014 Toshihiro Takehara Cloud ASIA Co., Ltd.
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::ja;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y/%M/%D %T';
    $Self->{DateFormatLong}      = '%Y/%M/%D - %T';
    $Self->{DateFormatShort}     = '%Y/%M/%D';
    $Self->{DateInputFormat}     = '%Y/%M/%D';
    $Self->{DateInputFormatLong} = '%Y/%M/%D - %T';
    $Self->{Completeness}        = 0.774093511450382;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = '.';
    $Self->{ThousandSeparator} = ',';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL管理',
        'Actions' => '操作',
        'Create New ACL' => '新しいACLを作成',
        'Deploy ACLs' => 'ACLをデプロイ',
        'Export ACLs' => 'ACLをエクスポート',
        'Filter for ACLs' => 'ACLでフィルタ',
        'Just start typing to filter...' => 'フィルタリングするには入力してください...',
        'Configuration Import' => '設定のインポート',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'ここにACLをインポートするための設定ファイルをアップロードできます。ファイルはACLエディタモジュールによってエクスポートされるような.ymlフォーマットである必要があります。',
        'This field is required.' => 'この領域は必須です。',
        'Overwrite existing ACLs?' => '既存のACLを上書きしますか？',
        'Upload ACL configuration' => 'ACL設定を更新',
        'Import ACL configuration(s)' => 'ACL設定をインポート',
        'Description' => '説明',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '新規のACLは、他のシステムからエクスポートしたACLをインポートするか、完全に新規で作成するかのいずれかの方法で作成できます。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'ここでのACLの変更はACLをデプロイした後に反映されます。デプロイにより新規の変更は設定に書き込まれます。',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'このテーブルはACLの実行順序に影響を与えます。もし実行順序を変更したい場合には、ACLの名前を変更して下さい。',
        'ACL name' => 'ACL名',
        'Comment' => 'コメント',
        'Validity' => '有効/無効',
        'Export' => 'エクスポート',
        'Copy' => 'コピー',
        'No data found.' => 'データがありません',
        'No matches found.' => '一致しませんでした。',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACLの %s を編集',
        'Edit ACL' => 'ACLを編集',
        'Go to overview' => '一覧に戻る',
        'Delete ACL' => 'ACLを削除',
        'Delete Invalid ACL' => '無効なACLを削除',
        'Match settings' => '条件設定',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'ACLでマッチする対象を指定します。\'Properties\'の場合現在画面に表示されている値を、\'PropertiesDatabase\'の場合、DBに保存されている値を使用します。',
        'Change settings' => '変更設定',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'マッチした対象をどのように絞り込むかを指定します。\'Possible\'はホワイトリスト、\'PossibleNot\'はブラックリストです。',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => '内容の表示・非表示',
        'Edit ACL Information' => 'ACL情報を編集',
        'Name' => '名前',
        'Stop after match' => '一致後に停止',
        'Edit ACL Structure' => 'ACL構造を修正',
        'Save ACL' => 'ACLの保存',
        'Save' => '保存',
        'or' => 'または',
        'Save and finish' => '保存して終了',
        'Cancel' => '取消',
        'Do you really want to delete this ACL?' => 'このACLを本当に削除しますか？',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'フォームを送信することにより、新規にACLを作成する事ができます。ACLを作成後、編集モードより構成アイテムを追加することができます。',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'カレンダー管理',
        'Add Calendar' => 'カレンダーの登録',
        'Edit Calendar' => 'カレンダーを編集',
        'Calendar Overview' => 'カレンダー表示',
        'Add new Calendar' => 'カレンダーの登録',
        'Import Appointments' => '予約のインポート',
        'Calendar Import' => 'カレンダーをインポート',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'ここでカレンダーの設定ファイルをアップロードすることができます。ファイルはカレンダー管理モジュールがエクスポートした".yml"フォーマットである必要があります。',
        'Overwrite existing entities' => '存在するエンティティを上書き',
        'Upload calendar configuration' => 'カレンダー設定をアップロードする',
        'Import Calendar' => 'カレンダーをインポート',
        'Filter for Calendars' => 'カレンダーでフィルター',
        'Filter for calendars' => 'カレンダーでフィルター',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'グループフィールド毎のユーザーに許可レベルに応じて、システムはカレンダーへのアクセスを許可します。',
        'Read only: users can see and export all appointments in the calendar.' =>
            '読み取り専用：ユーザーはカレンダー内の全ての予定を表示およびエクスポートできます。',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '移動先：ユーザーは予定表の予定を変更することなく、予定表の予定を変更できます。',
        'Create: users can create and delete appointments in the calendar.' =>
            '作成: ユーザーはカレンダーにアポイントメントを作成/削除できます。',
        'Read/write: users can manage the calendar itself.' => '読み書き可能：ユーザーはカレンダー自体を管理できます。',
        'Group' => 'グループ',
        'Changed' => '変更日時',
        'Created' => '作成',
        'Download' => 'ダウンロード',
        'URL' => 'URL',
        'Export calendar' => 'カレンダーのエクスポート',
        'Download calendar' => 'カレンダーのダウンロード',
        'Copy public calendar URL' => '公開カレンダーのURLをコピーする',
        'Calendar' => 'カレンダー',
        'Calendar name' => 'カレンダー名',
        'Calendar with same name already exists.' => '同じ名前のカレンダーは既に存在します。',
        'Color' => '色',
        'Permission group' => '権限グループ',
        'Ticket Appointments' => 'チケットの予約',
        'Rule' => 'ルール',
        'Remove this entry' => '登録を削除',
        'Remove' => '削除',
        'Start date' => '開始日',
        'End date' => '終了日時',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '以下のオプションを使用して、チケットの予定が自動的に作成される範囲を絞り込みます。',
        'Queues' => 'キュー',
        'Please select a valid queue.' => '有効なキューを選択して下さい。',
        'Search attributes' => '検索属性',
        'Add entry' => '登録を追加',
        'Add' => '追加',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'チケットデータに基づいてこのカレンダーで自動予定を作成するためのルールを定義します。',
        'Add Rule' => 'ルールを追加',
        'Submit' => '送信',

        # Template: AdminAppointmentImport
        'Appointment Import' => '予約のインポート',
        'Go back' => '戻る',
        'Uploaded file must be in valid iCal format (.ics).' => 'アップロードするファイルはiCalフォーマット(拡張子.ics)である必要があります。',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'もし意図したカレンダーが表示されていない場合、自身に作成権限が付与されていることを確認してください。',
        'Upload' => 'アップロード',
        'Update existing appointments?' => '既存の予定を更新しますか？',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'カレンダー内に同じユニークIDを持つ既存の予定はすべて上書きされます。',
        'Upload calendar' => 'カレンダーをアップロード',
        'Import appointments' => '予約のインポート',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '予約通知の管理',
        'Add Notification' => '通知の追加',
        'Edit Notification' => '通知の編集',
        'Export Notifications' => '通知をエクスポート',
        'Filter for Notifications' => '通知でフィルター',
        'Filter for notifications' => '通知でフィルター',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'ここでカレンダー通知の設定ファイルをアップロードすることができます。ファイルはカレンダー管理モジュールがエクスポートした".yml"フォーマットである必要があります。',
        'Overwrite existing notifications?' => '存在する通知を上書きしますか。',
        'Upload Notification configuration' => '通知設定のアップロード',
        'Import Notification configuration' => '通知の設定をインポート',
        'List' => 'リスト',
        'Delete' => '削除',
        'Delete this notification' => 'この通知を削除',
        'Show in agent preferences' => '担当者のプリファレンスに表示',
        'Agent preferences tooltip' => '担当者プリファレンスツールチップ',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'このメッセージはこの通知に対するツールチップとして担当者プリファレンス画面に表示されます。',
        'Toggle this widget' => 'このウィジェットを切り替え',
        'Events' => 'イベント',
        'Event' => 'イベント',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '予約のフィルター',
        'Type' => 'タイプ',
        'Title' => 'タイトル',
        'Location' => 'ロケーション',
        'Team' => 'チーム',
        'Resource' => 'リソース',
        'Recipients' => '受信者',
        'Send to' => '送信先',
        'Send to these agents' => 'これらの担当者に送信',
        'Send to all group members (agents only)' => 'グループ内の全面バーに送信（担当者のみ）',
        'Send to all role members' => 'ロールの全てのメンバーに送付',
        'Send on out of office' => '外出中の担当者に送信',
        'Also send if the user is currently out of office.' => '現在外出中のユーザーにも送付する。',
        'Once per day' => '一日に一度',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '選択された通知方法を使って1つの予約に対して1日に1度だけユーザーに通知します。',
        'Notification Methods' => '通知方法',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => 'この通知方法を有効化',
        'Transport' => 'トランスポート',
        'At least one method is needed per notification.' => '通知ごとに最低1つの通知方法が必要です。',
        'Active by default in agent preferences' => '担当者の環境設定ではデフォルトで有効になります。',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'これは、全ての担当者の個々の環境設定に通知にチェックが入ります。そして通知されます。',
        'This feature is currently not available.' => 'この機能は現在利用できません。',
        'Upgrade to %s' => '%s にアップグレードする。',
        'Please activate this transport in order to use it.' => '使用するには、このトランスポートを有効にしてください。',
        'No data found' => 'データがありません。',
        'No notification method found.' => '通知方法が見つかりませんでした。',
        'Notification Text' => '通知文書',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'この言語は存在しないか有効化されていません。必要が無いのであればこの通知文を削除できます。',
        'Remove Notification Language' => '通知する言語の削除',
        'Subject' => '表題',
        'Text' => '本文',
        'Message body' => 'メッセージボディー',
        'Add new notification language' => '新規通知言語を追加',
        'Save Changes' => '変更を保存',
        'Tag Reference' => 'タグリファレンス',
        'Notifications are sent to an agent.' => '通知は担当者へ送信されます。',
        'You can use the following tags' => '次のタグを使用できます',
        'To get the first 20 character of the appointment title.' => 'アポイントの表題から最初の20文字を取得',
        'To get the appointment attribute' => '予定の属性を取得すること',
        ' e. g.' => '例',
        'To get the calendar attribute' => 'カレンダーの属性を取得すること',
        'Attributes of the recipient user for the notification' => '',
        'Config options' => '設定オプション',
        'Example notification' => '通知例',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '追加の受信者のメールアドレス',
        'This field must have less then 200 characters.' => 'このフィールドへの入力文字数は200文字未満でなければなりません。',
        'Article visible for customer' => '顧客が閲覧可能な記事',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '顧客または追加のメールアドレスに通知が送られる際に記事が作成されます。',
        'Email template' => 'メールテンプレート',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '完全なメールを生成するためにこのテンプレートを使う。(HTMLメールに対してのみ)',
        'Enable email security' => 'メールセキュリティを有効にする',
        'Email security level' => 'メールのセキュリティレベル',
        'If signing key/certificate is missing' => 'もし署名された鍵/証明書が存在しない場合',
        'If encryption key/certificate is missing' => 'もし暗号化された鍵/証明書が存在しない場合',

        # Template: AdminAttachment
        'Attachment Management' => '添付ファイル管理',
        'Add Attachment' => '添付ファイルを追加',
        'Edit Attachment' => '添付ファイルを編集',
        'Filter for Attachments' => '添付ファイルでフィルタ',
        'Filter for attachments' => '添付ファイルのフィルター',
        'Filename' => 'ファイル名',
        'Download file' => 'ダウンロードファイル',
        'Delete this attachment' => 'この添付ファイルを削除',
        'Do you really want to delete this attachment?' => '本当にこの添付ファイルを削除してよろしいですか？',
        'Attachment' => '添付ファイル',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自動応答管理',
        'Add Auto Response' => '自動応答追加',
        'Edit Auto Response' => '自動応答編集',
        'Filter for Auto Responses' => '自動応答でフィルタ',
        'Filter for auto responses' => '自動応答でフィルター',
        'Response' => '応答',
        'Auto response from' => '自動応答差出人',
        'Reference' => '用例',
        'To get the first 20 character of the subject.' => '表題の最初の20文字を取得',
        'To get the first 5 lines of the email.' => 'メールの最初の5行を取得',
        'To get the name of the ticket\'s customer user (if given).' => 'チケットの顧客ユーザー名を取得(可能な場合)',
        'To get the article attribute' => '記事の属性を取得',
        'Options of the current customer user data' => '現在の顧客ユーザーデータのオプション',
        'Ticket owner options' => 'チケット所有者オプション',
        'Ticket responsible options' => 'チケット責任者オプション',
        'Options of the current user who requested this action' => '操作を要求された現在のユーザーのオプション',
        'Options of the ticket data' => 'チケットデータのオプション',
        'Options of ticket dynamic fields internal key values' => 'チケットのダイナミック・フィールドの内部キー値のオプション',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'チケットのダイナミック・フィールドの表示値のオプション。ドロップダウンまたは複数選択領域で利用可能・',
        'Example response' => '応答例',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'クラウドサービス管理',
        'Support Data Collector' => 'サポート情報コレクター',
        'Support data collector' => 'サポート情報コレクター',
        'Hint' => 'ヒント',
        'Currently support data is only shown in this system.' => '現在サポートしているデーターはこのシステムでのみ表示されています。',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => '設定',
        'Send support data' => 'サポート情報の送信',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => '更新',
        'System Registration' => 'システム登録',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'このシステムをサポート登録する',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'システムのサポート登録機能が無効になっています。設定をご確認ください。',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'OTOBO クラウドサービスのご利用には、システムの登録が必要となりますのでご注意ください。',
        'Register this system' => 'このシステムをサポート登録する',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '利用可能なクラウドサービス',

        # Template: AdminCommunicationLog
        'Communication Log' => 'コミュニケーション・ログ',
        'Time Range' => '時間の範囲',
        'Show only communication logs created in specific time range.' =>
            '特定の時間範囲で作成された通信ログのみを表示します。',
        'Filter for Communications' => '',
        'Filter for communications' => 'コミュニケーションでフィルター',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'この画面では、着信および発信コミュニケーションの概要を確認できます。',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '',
        'Status for: %s' => 'ステータス: %s',
        'Failing accounts' => '失敗したアカウント',
        'Some account problems' => 'いくつかのアカウントの問題',
        'No account problems' => 'アカウントの問題はありません',
        'No account activity' => 'アカウントのアクティビティはありません',
        'Number of accounts with problems: %s' => '問題のあるアカウントの数: %s',
        'Number of accounts with warnings: %s' => '警告のあるアカウント数: %s',
        'Failing communications' => 'コミュニケーションのフィルター',
        'No communication problems' => 'コミュニケーション上の問題はありません',
        'No communication logs' => 'コミュニケーション・ログがない',
        'Number of reported problems: %s' => '報告された問題の数：%s',
        'Open communications' => 'コミュニケーションを開く',
        'No active communications' => '有効なコミュニケーションがありません',
        'Number of open communications: %s' => '開いているコミュニケーションの数：%s',
        'Average processing time' => '平均処理時間',
        'List of communications (%s)' => 'コミュニケーションのリスト (%s)',
        'Settings' => '設定',
        'Entries per page' => '1ページあたりのエントリ数',
        'No communications found.' => 'コミュニケーション・ログが存在しません。',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'アカウントのステータス',
        'Back to overview' => '一覧に戻る',
        'Filter for Accounts' => 'アカウントでフィルター',
        'Filter for accounts' => 'アカウントでフィルター',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '列ヘッダーをクリックすると、列の並べ替えや順序を変更できます。',
        'Account status for: %s' => 'アカウントステータス：%s',
        'Status' => 'ステータス',
        'Account' => 'アカウント',
        'Edit' => '編集',
        'No accounts found.' => 'アカウントが存在しません。',
        'Communication Log Details (%s)' => 'コミュニケーション・ログの詳細(%s)',
        'Direction' => '方向',
        'Start Time' => 'スタート時間',
        'End Time' => '終了時間',
        'No communication log entries found.' => 'コミュニケーション・ログのエントリが見つかりません。',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '期間',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => '優先度',
        'Module' => 'モジュール',
        'Information' => '情報',
        'No log entries found.' => 'ログ・エントリは見つかりませんでした。',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '詳細ビューは%sから%sのコミュニケーションが開始されました。',
        'Filter for Log Entries' => 'ログエントリーでフィルター',
        'Filter for log entries' => 'ログエントリーでフィルター',
        'Show only entries with specific priority and higher:' => '',
        'Communication Log Overview (%s)' => 'コミュニケーション・ログ一覧（%s）',
        'No communication objects found.' => 'コミュニケーション・オブジェクトが見つかりませんでした。',
        'Communication Log Details' => 'コミュニケーション・ログの詳細',
        'Please select an entry from the list.' => 'リストから項目を選択して下さい。',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => 'データと接続',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => '検索結果に戻る',
        'Select' => '選択',
        'Search' => '検索',
        'Wildcards like \'*\' are allowed.' => 'ワイルドカード（*）が使用できます。',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => '有効',

        # Template: AdminCustomerCompany
        'Customer Management' => '顧客管理',
        'Add Customer' => '顧客を追加',
        'Edit Customer' => '顧客を編集',
        'List (only %s shown - more available)' => '一覧 ( %s 件のみ表示、他候補あり)',
        'total' => '合計',
        'Please enter a search term to look for customers.' => '顧客を検索するための条件を入力してください',
        'Customer ID' => '顧客ID',
        'Please note' => '注意',
        'This customer backend is read only!' => 'この顧客情報は読み取り専用です！',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => '顧客-グループ関連性管理',
        'Notice' => '通知',
        'This feature is disabled!' => 'この機能は無効にされています。',
        'Just use this feature if you want to define group permissions for customers.' =>
            '顧客のグループ権限を設定する場合のみこの機能を使用できます。',
        'Enable it here!' => '有効にする',
        'Edit Customer Default Groups' => '顧客の規定グループの編集',
        'These groups are automatically assigned to all customers.' => 'このグループは自動的にすべての顧客に割り当てられます。',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '設定の"CustomerGroupCompanyAlwaysGroups"で設定することができます',
        'Filter for Groups' => 'グループでフィルタ',
        'Select the customer:group permissions.' => '顧客：グループ権限を選択',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '何も選択しない場合、このグループは権限がありません (チケットは顧客が使用できません)',
        'Search Results' => '検索結果',
        'Customers' => '顧客',
        'Groups' => 'グループ',
        'Change Group Relations for Customer' => '顧客に対するグループの関連性を変更',
        'Change Customer Relations for Group' => 'グループに対する顧客の関連性を変更',
        'Toggle %s Permission for all' => '%s の全権限を切り替え',
        'Toggle %s permission for %s' => '%s の %s 権限を切り替え',
        'Customer Default Groups:' => '顧客の規定グループ:',
        'No changes can be made to these groups.' => '変更はこれらのグループに行うことができます。',
        'ro' => '読取り',
        'Read only access to the ticket in this group/queue.' => 'このグループ／キューのチケットを読み取り専用にします。',
        'rw' => '読書き',
        'Full read and write access to the tickets in this group/queue.' =>
            'このグループ／キューのチケットに読み書きを含めた全権限を付与します。',

        # Template: AdminCustomerUser
        'Customer User Management' => '顧客ユーザー管理',
        'Add Customer User' => '顧客ユーザーを追加',
        'Edit Customer User' => '顧客ユーザーを編集',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '顧客ユーザーは顧客履歴の使用と顧客パネルからログインするために必要です。',
        'List (%s total)' => '一覧 (全 %s 件)',
        'Username' => 'ユーザー名',
        'Email' => 'メール',
        'Last Login' => '最終ログイン',
        'Login as' => 'このアドレスとしてログイン',
        'Switch to customer' => '顧客に切り替え',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'この顧客情報は読み取り専用ですが、顧客ユーザー設定は変更可能です！',
        'This field is required and needs to be a valid email address.' =>
            'ここは必須領域で、有効なメールアドレスである必要があります。',
        'This email address is not allowed due to the system configuration.' =>
            'このメールアドレスはシステム設定により許可されていません。',
        'This email address failed MX check.' => 'このメールアドレスのMXレコード検査に失敗しました',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS上の問題が発生しました。設定とエラーログを確認してください。',
        'The syntax of this email address is incorrect.' => 'このメールアドレスは正しい形式ではありません',
        'This CustomerID is invalid.' => '顧客IDが不正です。',
        'Effective Permissions for Customer User' => '顧客ユーザーに対する有効な権限',
        'Group Permissions' => 'グループの権限',
        'This customer user has no group permissions.' => 'この顧客ユーザーはグループ権限を保有していません。',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上の表は、顧客ユーザーに対して有効なグループ権限を示します。 マトリックスは、すべての継承されたアクセス許可（たとえば、顧客グループを介したもの）を考慮に入れます。注：この表は、フォーム内の未送信分を考慮していません。',
        'Customer Access' => '顧客アクセス',
        'Customer' => '顧客',
        'This customer user has no customer access.' => 'この顧客ユーザーには顧客アクセス権がありません。',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上の表は、パーミッションコンテキストによって 顧客ユーザー に許可された顧客アクセスを示します。 マトリックスは、すべての継承されたアクセス許可（たとえば、顧客グループを介したもの）を考慮に入れます。注：この表は、フォーム内の未送信分を考慮していません。',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '顧客ユーザー - 顧客の関係を管理',
        'Select the customer user:customer relations.' => '顧客ユーザー - 顧客の関係を選択',
        'Customer Users' => '顧客ユーザー',
        'Change Customer Relations for Customer User' => '顧客ユーザーと顧客の関係を変更',
        'Change Customer User Relations for Customer' => '顧客ユーザーと顧客の関係を変更',
        'Toggle active state for all' => 'すべての有効なステータスを切り替え',
        'Active' => '有効',
        'Toggle active state for %s' => '有効なステータス %s を切り替え',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '顧客ユーザー - グループの関係を管理',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '顧客ユーザー のグループ権限を設定する場合のみこの機能を使用できます。',
        'Edit Customer User Default Groups' => '顧客ユーザーのデフォルトグループの編集',
        'These groups are automatically assigned to all customer users.' =>
            'これらのグループは自動的に全顧客ユーザーに設定されます。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '設定の"CustomerGroupAlwaysGroups"で設定することができます',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '顧客ユーザーを選択 - グループ・パーミッション',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '何も選択しない場合、このグループは権限がありません (チケットは 顧客ユーザー が使用できません)',
        'Customer User Default Groups:' => '顧客ユーザーのデフォルト・グループ',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => '既定のサービス編集',
        'Filter for Services' => 'サービスでフィルタ',
        'Filter for services' => 'サービスでフィルター',
        'Services' => 'サービス',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'ダイナミック・フィールド の管理',
        'Add new field for object' => 'オブジェクトに新規領域を追加',
        'Filter for Dynamic Fields' => 'ダイナミック・フィールドでフィルター',
        'Filter for dynamic fields' => 'ダイナミック・フィールドでフィルター',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'データベース',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '外部データベースをこの ダイナミック・フィールド の構成データソースとして使用します。',
        'Web service' => 'ウェブサービス',
        'External web services can be configured as data sources for this dynamic field.' =>
            '外部Webサービスをこの ダイナミック・フィールド のデータソースとして設定できます。',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '新しいフィールドを追加するには、オブジェクトのリストの1つからフィールドタイプを選択します。オブジェクトはフィールドの境界を定義し、フィールドの作成後は変更できません。',
        'Dynamic Fields List' => 'ダイナミック・フィールド 一覧',
        'Dynamic fields per page' => 'ページ毎の ダイナミック・フィールド',
        'Label' => 'ラベル',
        'Order' => '順序',
        'Object' => '対象',
        'Delete this field' => 'この領域を削除',

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
        'Dynamic Fields' => 'ダイナミック・フィールド',
        'Go back to overview' => '一覧に戻る',
        'General' => 'ジェネラル',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'この領域は必須であり、値はアルファベットと数値のみでなければなりません。',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '一意でなければならず、アルファベットと数値のみ受け付けます。',
        'Changing this value will require manual changes in the system.' =>
            'この値の変更はシステム内で手動で行う必要があります。',
        'This is the name to be shown on the screens where the field is active.' =>
            'これは領域がアクティブである画面で表示される名前です。',
        'Field order' => '領域の順序',
        'This field is required and must be numeric.' => 'この領域は必須かつ数値でなければなりません。',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'これはこの領域がアクティブである画面で表示される順序です。',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => '領域タイプ',
        'Object type' => 'オブジェクトタイプ',
        'Internal field' => '内部領域',
        'This field is protected and can\'t be deleted.' => 'この領域は保護されており、削除できません。',
        'This dynamic field is used in the following config settings:' =>
            'このダイナミック・フィールドは、次の設定で使用されます。',
        'Field Settings' => '領域設定',
        'Default value' => 'デフォルト値',
        'This is the default value for this field.' => 'これはこの領域に対するデフォルト値です。',

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
        'Value' => '値',
        'Remove value' => '値を削除',
        'Add Field' => '',
        'Add value' => '値を追加',
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
        'Translatable values' => '翻訳可能な値',
        'If you activate this option the values will be translated to the user defined language.' =>
            'このオプションを有効にすると、値がユーザーの定義した言語に翻訳されます。',
        'Note' => 'メモ',
        'You need to add the translations manually into the language translation files.' =>
            '翻訳を手動で言語翻訳ファイルに追加する必要があります。',

        # Template: AdminDynamicFieldDB
        'Possible values' => '選択肢',
        'Datatype' => '',
        'Filter' => 'フィルター',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'リンクを表示',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',
        'Example' => '例',
        'Link for preview' => 'プレビュー用のリンク',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Port',
        'Table / View' => '',
        'User' => 'ユーザー',
        'Password' => 'パスワード',
        'Identifier' => '識別子',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Multiselect',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'デフォルトの日時差',
        'This field must be numeric.' => 'この領域は数値でなければなりません。',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '領域のデフォルト値を計算するための現時点との時間差  (秒単位)。  （例: 3600, -60）',
        'Define years period' => '年の期間を定義',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '過去の年数',
        'Years in the past to display (default: 5 years).' => '表示する過去の年数(デフォルト:5年)。',
        'Years in the future' => '未来の年数',
        'Years in the future to display (default: 5 years).' => '表示する未来の年数(デフォルト:5年)。',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => '日付入力の制限',
        'Here you can restrict the entering of dates of tickets.' => '本項目でチケットの日付入力の制限できます',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => '値を追加',
        'Add empty value' => '空の値の追加',
        'Activate this option to create an empty selectable value.' => '本項目を有効にすれば空の選択可能項目が作成できます。',
        'Tree View' => 'ツリー表示',
        'Activate this option to display values as a tree.' => '本項目を有効にすれば、値をツリー形式で表示できます。',

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
        'Fields' => '領域',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => '一覧',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'このリストの表示順序はドラッグアンドドロップで変更することが出来ます。',
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
        'Reset' => 'リセット',

        # Template: AdminDynamicFieldText
        'Number of rows' => '行数',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '編集画面におけるこの領域の高さ(列数)を指定します。',
        'Number of cols' => '列数',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '編集画面におけるこの領域の幅(文字数)を指定します。',
        'Check RegEx' => '正規表現をチェック',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '本項目で入力値に対する正規表現を設定可能です。　正規表現は モディファイXMSとともに実行されます。',
        'RegEx' => '正規表現',
        'Invalid RegEx' => '無効な正規表現',
        'Error Message' => 'エラーメッセージ',
        'Add RegEx' => '正規表現を追加',

        # Template: AdminDynamicFieldTitle
        'Template' => 'テンプレート',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'サイズ',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'このフィールドは必須です',
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
        'Admin Message' => '管理者メッセージ',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '本モジュールにて、管理者からエージェント、グループ、ロールメンバーへメッセージを送信することが可能です。',
        'Create Administrative Message' => '管理者メッセージを作成',
        'Your message was sent to' => '送信されたメッセージ',
        'From' => '差出人',
        'Send message to users' => 'ユーザーにメッセージを送信',
        'Send message to group members' => 'グループのメンバーにメッセージを送信',
        'Group members need to have permission' => 'グループのメンバーは権限を持っている必要があります',
        'Send message to role members' => 'ロールのメンバーにメッセージを送信',
        'Also send to customers in groups' => 'さらにグループの顧客にも送信',
        'Body' => '本文',
        'Send' => '送信',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => '最終実行',
        'Run Now!' => '今すぐ実行！',
        'Delete this task' => 'このタスクを削除',
        'Run this task' => 'このタスクを実行',
        'Job Settings' => 'ジョブ設定',
        'Job name' => 'ジョブ名',
        'The name you entered already exists.' => '入力された名前は既に存在します。',
        'Automatic Execution (Multiple Tickets)' => '自動実行(複数チケット)',
        'Execution Schedule' => '実行スケジュール',
        'Schedule minutes' => 'スケジュール 分',
        'Schedule hours' => 'スケジュール 時',
        'Schedule days' => 'スケジュール 日',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            '現在この一般担当者のジョブは自動実行されません。',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '自動実行を有効にするには、分、時間、日から少なくとも1つの値を選択して下さい。',
        'Event Based Execution (Single Ticket)' => 'イベント実行(単一チケット)',
        'Event Triggers' => 'イベントトリガー',
        'List of all configured events' => '設定された全てのイベントの一覧',
        'Delete this event' => 'このイベントを削除',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'このイベントトリガーを本当に削除しますか？',
        'Add Event Trigger' => 'イベントトリガーを追加',
        'To add a new event select the event object and event name' => '新しいイベントを追加するには、イベントオブジェクトとイベント名を選択します。',
        'Select Tickets' => 'チケットを選択',
        '(e. g. 10*5155 or 105658*)' => '(例 10*5144 または 105658*)',
        '(e. g. 234321)' => '(例 234321)',
        'Customer user ID' => '顧客ユーザーID',
        '(e. g. U5150)' => '(例 U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '記事内全文検索 (例 "Mar*in" または "Baue*")',
        'To' => '宛先',
        'Cc' => 'Cc',
        'Service' => 'サービス',
        'Service Level Agreement' => 'サービスレベル契約（SLA）',
        'Queue' => 'キュー',
        'State' => 'ステータス',
        'Agent' => '担当者',
        'Owner' => '所有者',
        'Responsible' => '責任者',
        'Ticket lock' => 'チケットロック',
        'Dynamic fields' => 'ダイナミック・フィールド',
        'Add dynamic field' => '',
        'Create times' => '作成日時',
        'No create time settings.' => '作成日時を指定しない',
        'Ticket created' => 'チケットを作成したのが',
        'Ticket created between' => 'チケットを作成したのがこの期間内',
        'and' => '-',
        'Last changed times' => '最終変更時間',
        'No last changed time settings.' => '最終変更時間を指定しない',
        'Ticket last changed' => 'チケットが最終更新された',
        'Ticket last changed between' => 'チケットの最終更新がこの期間内',
        'Change times' => '変更時間',
        'No change time settings.' => '変更時間設定を指定しない',
        'Ticket changed' => 'チケットを変更しました',
        'Ticket changed between' => 'チケットの変更がこの期間の間',
        'Close times' => 'クローズ時間',
        'No close time settings.' => 'クローズ時間を指定しない',
        'Ticket closed' => 'チケットをクローズしたのが',
        'Ticket closed between' => 'チケットをクローズしたのがこの期間内',
        'Pending times' => '保留時間',
        'No pending time settings.' => '保留時間を指定しない',
        'Ticket pending time reached' => '保留期限切れが',
        'Ticket pending time reached between' => '保留期限切れがこの期間内',
        'Escalation times' => 'エスカレーション時間',
        'No escalation time settings.' => 'エスカレーション時間を指定しない',
        'Ticket escalation time reached' => 'エスカレーション時間到達が',
        'Ticket escalation time reached between' => 'エスカレーション時間がこの期間内',
        'Escalation - first response time' => 'エスカレーション - 初回応答期限',
        'Ticket first response time reached' => 'チケット初回応答期限が',
        'Ticket first response time reached between' => 'チケット初回応答期限がこの期間内',
        'Escalation - update time' => 'エスカレーション - 更新期限',
        'Ticket update time reached' => 'チケット更新期限が',
        'Ticket update time reached between' => 'チケット更新期限がこの期間内',
        'Escalation - solution time' => 'エスカレーション - 解決期限',
        'Ticket solution time reached' => 'チケット解決期限が',
        'Ticket solution time reached between' => 'チケット解決期限がこの期間内',
        'Archive search option' => 'アーカイブ検索オプション',
        'Update/Add Ticket Attributes' => 'チケット属性の更新/追加',
        'Set new service' => '新しいサービスを設定',
        'Set new Service Level Agreement' => '新しいサービスレベル契約（SLA）を設定',
        'Set new priority' => '新しい優先度を設定',
        'Set new queue' => '新しいキューを設定',
        'Set new state' => '新しいステータスを設定',
        'Pending date' => '保留日時',
        'Set new agent' => '新しい担当者を設定',
        'new owner' => '新しい所有者',
        'new responsible' => '新しい責任者',
        'Set new ticket lock' => '新しいチケットロックを設定',
        'New customer user ID' => '新しい顧客ユーザーID',
        'New customer ID' => '新しい顧客ID',
        'New title' => '新しいタイトル',
        'New type' => '新しいタイプ',
        'Archive selected tickets' => '選択されたアーカイブ・チケット',
        'Add Note' => 'メモを追加',
        'Visible for customer' => '顧客が閲覧可能な記事',
        'Time units' => '時間の単位',
        'Execute Ticket Commands' => 'チケットコマンドを実行',
        'Send agent/customer notifications on changes' => '変更を担当者／顧客に通知する',
        'CMD' => 'コマンド',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'このコマンドが実行されます。チケット番号は ARG[0] 、チケットIDは ARG[1] です。',
        'Delete tickets' => 'チケット削除',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告: 影響を受ける全てのチケットがデータベースから削除されます。復元することはできません。',
        'Execute Custom Module' => 'カスタムモジュールを実行',
        'Param %s key' => 'パラメータキー %s',
        'Param %s value' => 'パラメータ値 %s',
        'Results' => '検索結果',
        '%s Tickets affected! What do you want to do?' => '%s チケットは影響を受けます。どうしますか？',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告: 削除オプションを使用します。削除された全てのチケットは消失します。',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '注意: 影響を受けるチケットは %s 件ありますが、変更を行うことのできるのは1ジョブあたり %s 件のみとなります！',
        'Affected Tickets' => '影響を受けるチケット',
        'Age' => '経過時間',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'ジェネリックインターフェース・Webサービス管理',
        'Web Service Management' => 'ウェブサービスの管理',
        'Debugger' => 'デバッガー',
        'Go back to web service' => 'Webサービスに戻る',
        'Clear' => 'クリア',
        'Do you really want to clear the debug log of this web service?' =>
            'このWEBサービスのデバッグログを本当にクリアしますか。',
        'Request List' => 'リクエストリスト',
        'Time' => '時間',
        'Communication ID' => 'コミュニケーションID',
        'Remote IP' => 'リモートIP',
        'Loading' => '読み込み中...',
        'Select a single request to see its details.' => '詳細情報を表示するためには一つのリクエストを選択してください。',
        'Filter by type' => 'タイプでフィルタ',
        'Filter from' => '送信元でフィルタ',
        'Filter to' => '送信先でフィルタ',
        'Filter by remote IP' => 'リモートIPでフィルタ',
        'Limit' => '制限',
        'Refresh' => '自動更新',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'エラー処理の追加',
        'Edit ErrorHandling' => 'エラー処理の修正',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'すべての設定情報は失われます',
        'General options' => '一般的なオプション',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Webサービスの名称として一意の名前を指定してください。',
        'Error handling module backend' => 'エラー処理モジュールのバックエンド',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => '処理中オプション',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '操作フィルター',
        'Only execute error handling module for selected operations.' => '選択したオペレーションに対してのみ、エラー処理モジュールを実行します。',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => 'API実行元をフィルター',
        'Only execute error handling module for selected invokers.' => '選択したAPI実行元に対してのみ、エラー処理モジュールを実行します。',
        'Error message content filter' => 'エラーメッセージコンテンツフィルター',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => 'エラーステージフィルター',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => 'エラーコード',
        'An error identifier for this error handling module.' => 'このエラー処理モジュールのエラー識別子',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => 'エラーメッセージ',
        'An error explanation for this error handling module.' => 'このエラー処理モジュールのエラーの説明',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'このメッセージは、XSLT-Mapping画面およびデバッガ出力でのみ利用可能です。',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'このモジュールでは、失敗した要求をスケジュールされた時刻に再試行し、構成できます。',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => 'リクエストを再試行するオプション',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => 'スケジュール・リトライ',
        'Should requests causing an error be triggered again at a later time?' =>
            'エラーの原因となったリクエストを、後で再送信する必要がありますか？',
        'Initial retry interval' => '初期のリトライ間隔',
        'Interval after which to trigger the first retry.' => '最初のリトライするトリガーの間隔',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '注：これ以降のすべての再試行間隔は、最初のリクエストに対するエラー処理モジュールの実行時間に基づいています。',
        'Factor for further retries' => 'さらなる再試行の要因',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '例: トリガーを 10:00 、インターバルを1分間隔にあらかじめ設定している場合に、リトライファクターを”２”とすると、次の要領でトリガーが機能します。
10:01(1分後)→10:03(１x２=2分後)→10:07(２x２=4分後)→10:15(４x２=8分後)…※以降、間隔は2倍になります',
        'Maximum retry interval' => '最大リトライ間隔',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'リトライファクターとして"1.5"ないし"2"が選択されている場合、最大リトライ間隔を別途定義することで、意図せず望ましくない間隔が設定されることを防止できます。',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'リトライ間隔を算出した結果が最大リトライ間隔を超過した場合は、自動的に短縮されます。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '例: トリガーを 10:00 、インターバルを1分間隔にあらかじめ設定している場合に、リトライファクターを”２”、最大リトライ間隔を”5分”とすると、次の要領でトリガーが機能します。
10:01(1分後)→10:03(2分後)→10:07(4分後)→10:12(8分後⇒5分後に修正)→10:17…',
        'Maximum retry count' => '最大リトライ間隔',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '最大リトライ回数は、処理要求が失敗してもリトライを行う最大の回数です。但し、初回分はカウントしません。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '例: トリガーを 10:00 、インターバルを1分間隔にあらかじめ設定している場合に、リトライファクターを”２”、最大リトライ回数を”２”とすると、10:01および10:02にリトライ機能が呼び出されます。',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '再試行の最大期間',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'API実行元を追加',
        'Edit Invoker' => 'API実行元を修正',
        'Do you really want to delete this invoker?' => 'このAPI実行元を本当に削除しますか。',
        'Invoker Details' => 'API実行元の詳細',
        'The name is typically used to call up an operation of a remote web service.' =>
            'この名称は、一般的にリモートWebサービスの呼び出しに用いられます。',
        'Invoker backend' => 'API実行元のバックエンド',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'このOTOBOのAPI実行元のバックエンドモジュールは、リモートシステムに送信されるデータを準備し、その応答データを処理するために呼び出されます。',
        'Mapping for outgoing request data' => '送信要求データのマッピング',
        'Configure' => '設定',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'OTOBOのAPI実行元からのデータは、このマッピングによって処理され、リモートシステムが予期している種類のデータに変換されます。',
        'Mapping for incoming response data' => '着信応答データのマッピング',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'レスポンスデータをこのマッピングにのっとって OTOBO のAPI実行元が期待するデータの種類に変換します。',
        'Asynchronous' => '非同期',
        'Condition' => '条件',
        'Edit this event' => 'このイベントを修正',
        'This invoker will be triggered by the configured events.' => 'このAPI実行元は予め設定されたトリガーによって実行されます。',
        'Add Event' => 'イベントを追加',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '新しいイベントを追加するには、イベントオブジェクトをイベント名を選択してから"+"ボタンをクリックしてください',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '非同期型イベントトリガーは、OTOBOスケジューラー・デーモンによってバックグラウンドで実行されます（推奨）。',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同期型イベントトリガーは直接Web画面上のリクエストから実行されます。',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'に戻る',
        'Delete all conditions' => '全ての条件を削除',
        'Do you really want to delete all the conditions for this event?' =>
            '本当にこのイベントのすべての条件を削除してよろしいですか？',
        'General Settings' => '一般的な設定',
        'Event type' => 'イベントタイプ',
        'Conditions' => '条件',
        'Conditions can only operate on non-empty fields.' => '条件は空白でないフィールドに対してのみ使用可能です。',
        'Type of Linking between Conditions' => '条件間のリンクのタイプ',
        'Remove this Condition' => 'この条件を削除',
        'Type of Linking' => 'リンクのタイプ',
        'Add a new Field' => '新しい領域を追加',
        'Remove this Field' => 'この領域を削除',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => '新しい条件を追加',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'マッピング シンプル',
        'Default rule for unmapped keys' => 'アンマップドキーのデフォルトルール',
        'This rule will apply for all keys with no mapping rule.' => '本ルールはマッピングルールが指定されていないすべてのキーに適用されます。',
        'Default rule for unmapped values' => 'アンマップドバリューのデフォルトルール',
        'This rule will apply for all values with no mapping rule.' => '本ルールはマッピングルールが指定されていないすべてのバリューに適用されます。',
        'New key map' => '新しいキー割り当て',
        'Add key mapping' => 'キー割り当ての追加',
        'Mapping for Key ' => 'キーの割り当て',
        'Remove key mapping' => 'キー割り当ての削除',
        'Key mapping' => 'キー割り当て',
        'Map key' => 'キーの割り当て',
        'matching the' => '一致',
        'to new key' => 'へ新しいキーを割り当てる',
        'Value mapping' => '値のマッピング',
        'Map value' => '値の割り当て',
        'to new value' => 'へ新しい値を割り当てる',
        'Remove value mapping' => '割り当てた値の削除',
        'New value map' => '新しい値の割り当て',
        'Add value mapping' => '値の割り当てを追加',
        'Do you really want to delete this key mapping?' => 'このキー割り当てを削除しますか？',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '一般的なショートカット',
        'MacOS Shortcuts' => 'MacOSのショートカット',
        'Comment code' => 'コメント・コード',
        'Uncomment code' => 'コードのコメントを解除する',
        'Auto format code' => '自動フォーマットコード',
        'Expand/Collapse code block' => 'コードブロックを展開/折りたたみ',
        'Find' => '探す',
        'Find next' => '次を探す',
        'Find previous' => '前の検索',
        'Find and replace' => '検索と置換',
        'Find and replace all' => '全ての検索して置き換える',
        'XSLT Mapping' => 'XSLTマッピング',
        'XSLT stylesheet' => 'XSLTスタイルシート',
        'The entered data is not a valid XSLT style sheet.' => '入力されたXSLTスタイルシートの形式が不正です。',
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
        'Regular expressions' => '正規表現',
        'Replace' => '置換',
        'Remove regex' => '正規表現の削除',
        'Add regex' => '正規表現の追加',
        'These filters can be used to transform keys using regular expressions.' =>
            'これらのフィルタは、正規表現を使用してキーを変換するために使用できます。',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '例1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '例2:  Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '例3: Search = \'^(?1\d+) (?2.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'Perlでの正規表現についての情報は、こちらをご覧ください：',
        'Perl regular expressions tutorial' => 'Perl正規表現のチュートリアル',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'オペレーションを追加',
        'Edit Operation' => 'オペレーションを修正',
        'Do you really want to delete this operation?' => 'このオペレーションを本当に削除しますか？',
        'Operation Details' => 'オペレーションの詳細',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'この名称は、一般的にリモートシステムからのWebサービスの呼び出しに用いられます。',
        'Operation backend' => 'オペレーション・バックエンド',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for incoming request data' => '受信したデータのマッピング',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            '',
        'Mapping for outgoing response data' => '送信データのマッピング',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Include Ticket Data' => 'チケットデータを含む',
        'Include ticket data in response.' => '応答のテキスト内に、チケットのデータを含める',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'ネットワーク・トランスポート',
        'Properties' => '項目',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'メッセージの最長値',
        'This field should be an integer number.' => 'この領域は整数値である必要があります。',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            '',
        'Send Keep-Alive' => 'Keep-Aliveを送信',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Additional response headers' => '応答ヘッダーを追加',
        'Add response header' => '応答ヘッダーを追加する',
        'Endpoint' => 'エンドポイント',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'タイムアウト',
        'Timeout value for requests.' => '',
        'Authentication' => '認証',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => 'ベーシック認証のユーザー',
        'The user name to be used to access the remote system.' => 'リモート・システムにアクセスするときに用いるユーザー名',
        'BasicAuth Password' => 'ベーシック認証のパスワード',
        'The password for the privileged user.' => '特権ユーザー用パスワード',
        'Use Proxy Options' => 'プロキシオプションを使用する',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'プロキシサーバ',
        'URI of a proxy server to be used (if needed).' => 'プロキシサーバのURI (任意)',
        'e.g. http://proxy_hostname:8080' => '例… http://proxy_hostname:8080',
        'Proxy User' => 'Proxy ユーザー',
        'The user name to be used to access the proxy server.' => 'プロキシサーバへ接続する際のユーザー名',
        'Proxy Password' => 'Proxy パスワード',
        'The password for the proxy user.' => 'プロキシユーザーのパスワード',
        'Skip Proxy' => 'プロキシーをスキップ',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'SSLオプションを利用する',
        'Show or hide SSL options to connect to the remote system.' => 'リモートシステムに接続するためのSSLオプションの表示/非表示を切替えます。',
        'Client Certificate' => 'クライアント証明書',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'SSLクライアント証明書ファイルの完全パスと名前（PEM、DERまたはPKCS＃12形式である必要があります）。',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => '例 /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'クライアント認証キー',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'SSLクライアント証明書キーファイルの完全パスと名前（まだ証明書ファイルに含まれていない場合）。',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => '例 /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'クライアント認証キーのパスワード',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => '例… /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => '例… /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'API実行元に対するコントローラ・マッピング',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '呼び出し元に対する有効な要求コマンド',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'この呼び出し元のリクエストに使用する、特定のHTTPコマンド(オプション)',
        'Default command' => 'デフォルトコマンド',
        'The default HTTP command to use for the requests.' => '要求に使用される標準のHTTPコマンド',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '例. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'SOAPアクションを設定',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '「いいえ」に設定すると、空のSOAPActionヘッダーが送信されます。',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => 'SOAPアクション・スキーム',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'SOAPアクション・セパレータ',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => 'SOAPアクション・フリーテキスト',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => '名前空間',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '例… urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '実際の呼び出し元/操作名の例として \'FunctionName\'が使用されています。',
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
            '',
        'Encoding' => 'エンコーディング',
        'The character encoding for the SOAP message contents.' => 'SOAPメッセージコンテントの文字エンコード',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '例… utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'Sort options' => '並べ替えオプション',
        'Add new first level element' => '',
        'Element' => '要素',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Webサービスを追加',
        'Edit Web Service' => 'Webサービスを修正',
        'Clone Web Service' => 'Webサービスをクローン',
        'The name must be unique.' => '名前は一意である必要があります。',
        'Clone' => '複製',
        'Export Web Service' => 'Webサービスをエクスポート',
        'Import web service' => 'ウェブサービスのインポート',
        'Configuration File' => '設定ファイル',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'インポート',
        'Configuration History' => '設定履歴',
        'Delete web service' => 'ウェブサービスの削除',
        'Do you really want to delete this web service?' => '本当にこのWebサービスを削除しますか？',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Remote system' => 'リモートシステム',
        'Provider transport' => '供給者のトランスポート',
        'Requester transport' => '依頼者のトランスポート',
        'Debug threshold' => 'デバックの閾値',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'Provider(供給者)モードでは、OTOBOは他の外部システムにウェブサービスを提供します。',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'Requester(要求者)モードでは、OTOBOは他の外部システのウェブサービスを使用します。',
        'Network transport' => 'ネットワーク・トランスポート',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => 'バックエンド',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => 'コントローラー',
        'Inbound mapping' => 'インバウンド・マッピング',
        'Outbound mapping' => 'アウトバウンド・マッピング',
        'Delete this action' => 'このアクションを削除',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => '履歴',
        'Go back to Web Service' => 'Webサービスに戻る',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '設定履歴一覧',
        'Version' => 'バージョン',
        'Create time' => '作成日時',
        'Select a single configuration version to see its details.' => '詳細を表示するには、1つのバージョンのみを選択します。',
        'Export web service configuration' => 'サービス設定のエクスポート',
        'Restore web service configuration' => 'サービス設定の復元',
        'Do you really want to restore this version of the web service configuration?' =>
            'このバージョンのウェブ・サービス設定を復旧します。よろしいですか？',
        'Your current web service configuration will be overwritten.' => '現在のWebサービス設定は上書きされます。',

        # Template: AdminGroup
        'Group Management' => 'グループ管理',
        'Add Group' => 'グループ追加',
        'Edit Group' => 'グループ編集',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '管理グループは管理エリアで取得します。統計グループは統計エリアを取得します',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '統計グループは統計エリアを取得します。異なるエージェントグループへのアクセス許可を操作するには、グループを新規作成してください。（例：購買部、サポート部、営業部等）',
        'It\'s useful for ASP solutions. ' => 'ASPソリューションが便利です',

        # Template: AdminLog
        'System Log' => 'システムログ',
        'Here you will find log information about your system.' => 'ここではシステムに関するログ情報が表示されます。',
        'Hide this message' => 'このメッセージを隠す',
        'Recent Log Entries' => '最近のログ一覧',
        'Facility' => 'ファシリティ',
        'Message' => 'メッセージ',

        # Template: AdminMailAccount
        'Mail Account Management' => 'メールアカウント管理',
        'Add Mail Account' => 'メールアカウント追加',
        'Edit Mail Account for host' => 'ホストのメールアカウントを編集',
        'and user account' => 'ユーザーアカウントと',
        'Filter for Mail Accounts' => 'メールアカウントでフィルター',
        'Filter for mail accounts' => 'メールアカウントでフィルター',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '1つのアカウントを持つ全ての受信Eメールは、選択されたキューにディスパッチされます。',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => 'システム設定',
        'Host' => 'ホスト',
        'Delete account' => 'アカウント削除',
        'Fetch mail' => 'メールを取得',
        'Do you really want to delete this mail account?' => '本当にこのメールアカウントを削除しますか？',
        'Example: mail.example.com' => '例: mail.example.com',
        'IMAP Folder' => 'IMAPフォルダー',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'INBOX以外のフォルダからメールを取得したい場合にのみ修正して下さい。',
        'Trusted' => '信頼済',
        'Dispatching' => '振り分け処理',
        'Edit Mail Account' => 'メールアカウント編集',

        # Template: AdminNavigationBar
        'Administration Overview' => '管理一覧',
        'Filter for Items' => 'アイテムをフィルター',
        'Favorites' => 'お気に入り',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '右側のアイテムにカーソルを合わせてスターアイコンをクリックすると、お気に入りを追加できます。',
        'Links' => 'リンク',
        'View the admin manual on Github' => 'Githubの管理マニュアルを表示',
        'No Matches' => 'マッチなし',
        'Sorry, your search didn\'t match any items.' => '申し訳ありませんが、あなたの検索はどのアイテムにも一致しませんでした。',
        'Set as favorite' => 'お気に入りに指定',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'チケット通知管理',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'チケットフィルター',
        'Lock' => 'ロック',
        'SLA' => 'SLA',
        'Customer User ID' => '顧客ユーザーID',
        'Article Filter' => '記事フィルター',
        'Only for ArticleCreate and ArticleSend event' => 'ArticleCreateおよびArticleSendイベントに対してのみ',
        'Article sender type' => '記事送信者タイプ',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Customer visibility' => '顧客の参照',
        'Communication channel' => 'コミュニケーション・チャネル',
        'Include attachments to notification' => '通知が添付ファイルを含む',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '選択された通知方法を使って1つのチケットにつき1度だけユーザーに通知する。',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => '通知は担当者、顧客に送信されます。',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '表題の最初の20文字を取得 (最新の担当者記事)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '本文から最初の5行を取得 (最新の担当者記事)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '表題の最初の20文字を取得 (最新の顧客記事)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '本文から最初の5行を取得 (最新の顧客記事)',
        'Attributes of the current customer user data' => '現在の顧客ユーザの属性',
        'Attributes of the current ticket owner user data' => '現在のチケット所有者の属性',
        'Attributes of the current ticket responsible user data' => '現在の責任者の属性',
        'Attributes of the current agent user who requested this action' =>
            '現在操作を要求している担当者の属性',
        'Attributes of the ticket data' => 'チケットデータの属性',
        'Ticket dynamic fields internal key values' => 'チケットのダイナミック・フィールドの内部用キー値',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'チケットのダイナミック・フィールドの表示値。ドロップダウンまたは複数選択領域で利用可能',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '<OTOBO_TICKET_DynamicField_...> を指定することで、現在のチケットの値を参照することができます。',

        # Template: AdminPGP
        'PGP Management' => 'PGP管理',
        'Add PGP Key' => 'PGP鍵を追加',
        'PGP support is disabled' => 'PGPサポート機能は無効化されています',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'OTOBOでPGPを使用するにはまず有効にする必要があります。',
        'Enable PGP support' => 'PGPサポートの有効化',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGPサポート機能は有効化されましたが、関連する設定にエラーがあります。以下の設定を確認して下さい。',
        'Configure it here!' => 'ここで設定してください！',
        'Check PGP configuration' => 'PGP設定の確認',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'この方法で直接システム設定からキーリング設定を編集できます。',
        'Introduction to PGP' => 'PGPの導入',
        'Bit' => 'ビット',
        'Fingerprint' => 'フィンガープリント',
        'Expires' => '期限切れ',
        'Delete this key' => 'この鍵を削除',
        'PGP key' => 'PGPキー',

        # Template: AdminPackageManager
        'Package Manager' => 'パッケージ管理',
        'Uninstall Package' => 'パッケージをアンインストール',
        'Uninstall package' => 'パッケージをアンインストール',
        'Do you really want to uninstall this package?' => 'このパッケージを本当にアンインストールしますか？',
        'Reinstall package' => 'パッケージを再インストール',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'このパッケージを本当に再インストールしますか？ 全ての手動変更点は失われます。',
        'Go to updating instructions' => '',
        'Go to the OTOBO customer portal' => 'OTOBOのカスタマーポータルへアクセス',
        'package information' => 'パッケージ情報',
        'Package installation requires a patch level update of OTOBO.' =>
            '',
        'Package update requires a patch level update of OTOBO.' => '',
        'Please note that your installed OTOBO version is %s.' => 'インストールされているOTOBOのバージョンは%sです。',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'このパッケージをインストールするには、OTOBOのバージョンを%s以上にアップデートする必要があります。',
        'This package can only be installed on OTOBO version %s or older.' =>
            'このパッケージはOTOBOのバージョンが%sかそれより古い必要があります。',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'このパッケージをインストールするにはOTOBOのバージョンが%sかそれより新しい必要があります。',
        'Why should I keep OTOBO up to date?' => 'OTOBOのバージョンを最新に保つことが必要な理由',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTOBO issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => 'パッケージをインストール',
        'Update Package' => 'パッケージを更新',
        'Continue' => '続ける',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'インストール',
        'Update repository information' => 'リポジトリ情報を更新',
        'Cloud services are currently disabled.' => 'クラウドサービスは現在無効化されています',
        'OTOBO Verify can not continue!' => 'OTOBO Verify️が継続できません！',
        'Enable cloud services' => 'クラウドサービスの有効化',
        'Update all installed packages' => 'インストールされているパッケージを全て更新する',
        'Online Repository' => 'オンラインリポジトリ',
        'Vendor' => 'ベンダー',
        'Action' => '操作',
        'Module documentation' => 'モジュールの書類',
        'Local Repository' => 'ローカルリポジトリ',
        'This package is verified by OTOBOverify (tm)' => 'このパッケージはOTOBOVerify(tm)によって確認されています',
        'Uninstall' => 'アンインストール',
        'Package not correctly deployed! Please reinstall the package.' =>
            'パッケージが正しくデプロイされません。再インストールしてください。',
        'Reinstall' => '再インストール',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => 'パッケージ情報',
        'Download package' => 'パッケージをダウンロード',
        'Rebuild package' => 'パッケージを再構成',
        'Metadata' => 'メタデータ',
        'Change Log' => '変更履歴',
        'Date' => '日付',
        'List of Files' => 'ファイル一覧',
        'Permission' => '権限',
        'Download file from package!' => 'パッケージからファイルをダウンロードしてください。',
        'Required' => '必要項目',
        'Primary Key' => '主キー',
        'Auto Increment' => '自動カウントアップ',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'ファイル%sの差分',
        'File differences for file %s' => '%s ファイルが違います',

        # Template: AdminPerformanceLog
        'Performance Log' => 'パフォーマンスログ',
        'Range' => '範囲',
        'last' => '以内',
        'This feature is enabled!' => 'この機能を有効にする。',
        'Just use this feature if you want to log each request.' => 'この機能は各要求をログに記録したい場合のみ利用してください。',
        'Activating this feature might affect your system performance!' =>
            'この機能を有効にするとシステムのパフォーマンスに影響が出る可能性があります。',
        'Disable it here!' => '無効にする。',
        'Logfile too large!' => 'ログファイルが大きすぎます',
        'The logfile is too large, you need to reset it' => 'ログファイルが大きすぎます。初期化してください。',
        'Interface' => 'インターフェイス',
        'Requests' => '要求',
        'Min Response' => '最少応答',
        'Max Response' => '最大応答',
        'Average Response' => '平均応答',
        'Period' => '期間',
        'minutes' => '分',
        'Min' => '最少',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'ポストマスター・フィルター管理',
        'Add PostMaster Filter' => 'ポストマスター・フィルターを追加',
        'Edit PostMaster Filter' => 'ポストマスター・フィルターを削除',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '振り分けやメールヘッダを元に受信メールをフィルタします。正規表現を使用できます。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'メールアドレスのみを一致させたい場合、EMAILADDRESS:info@example.comを差出人、宛先、Ccに使用してください。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '正規表現を使う場合、設定で一致する値を[***]として使用できます。',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'このフィルタを削除',
        'Do you really want to delete this postmaster filter?' => '本当にこのポストマスター・フィルターを削除しますか？',
        'A postmaster filter with this name already exists!' => 'この名前のポストマスター・フィルターは既に存在します！',
        'Filter Condition' => 'フィルター条件',
        'AND Condition' => 'AND条件',
        'Search header field' => 'ヘッダーフィールドの検索',
        'for value' => '価値観',
        'The field needs to be a valid regular expression or a literal word.' =>
            'このフィールドは有効な正規表現またはリテラル値で入力する必要があります。',
        'Negate' => '否定条件',
        'Set Email Headers' => 'メールヘッダを設定',
        'Set email header' => 'メールヘッダを設定',
        'with value' => '価値のある',
        'The field needs to be a literal word.' => 'このフィールドはリテラル値で入力する必要があります。',
        'Header' => 'ヘッダー',

        # Template: AdminPriority
        'Priority Management' => '優先度管理',
        'Add Priority' => '優先度を追加',
        'Edit Priority' => '優先度を編集',
        'Filter for Priorities' => '優先度でフィルター',
        'Filter for priorities' => '優先度でフィルター',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'プロセス管理',
        'Filter for Processes' => 'プロセスでフィルター',
        'Filter for processes' => '',
        'Create New Process' => '新しいプロセスを追加',
        'Deploy All Processes' => 'すべてのプロセスをデプロイ',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'ここでプロセスの設定ファイルをアップロードすることができます。ファイルは.プロセス管理モジュールがエクスポートしたyamlフォーマットである必要があります。',
        'Upload process configuration' => 'プロセスの設定を更新',
        'Import process configuration' => 'プロセスの設定をインポート',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '新規プロセスを作成するには他システムでエクスポートしたプロセスをインポートするか新規に作成してください。',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '変更はプロセスデータを同期させた場合にのみ反映されます。同期により、行われた変更は実際の設定に反映されます。',
        'Processes' => 'プロセス',
        'Process name' => 'プロセス名',
        'Print' => '印刷',
        'Export Process Configuration' => 'プロセスの設定をエクスポート',
        'Copy Process' => 'プロセスをコピー',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '中止して閉じる',
        'Go Back' => '戻る',
        'Please note, that changing this activity will affect the following processes' =>
            '変更は以下のプロセスに影響を与えます',
        'Activity' => 'アクティビティ',
        'Activity Name' => 'アクティビティ名',
        'Activity Dialogs' => 'アクティビティダイアログ',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '左側のリストから右側のリストへドラッグすることでアクティビティ・ダイアログをアクティビティに関連付けすることが出来ます。',
        'Filter available Activity Dialogs' => '利用可能なアクティビティダイアログをフィルタ',
        'Available Activity Dialogs' => '利用可能なアクティビティダイアログ',
        'Name: %s, EntityID: %s' => '名前: %s, エンティティID: %s',
        'Create New Activity Dialog' => '新規アクティビティダイアログを作成',
        'Assigned Activity Dialogs' => '割り当てられたアクティビティダイアログ',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'このアクティビティ・ダイアログに対する変更は以下のアクティビティに影響を与えます',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '顧客は次のフィールドを参照することは出来ませんので注意して下さい: 所有者, 責任者, ロック, 保留時間, 顧客ID',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '顧客の場合、キューはチケットの新規作成時にのみ使用できます。',
        'Activity Dialog' => 'アクティビティダイアログ',
        'Activity dialog Name' => 'アクティビティダイアログ名',
        'Available in' => 'インターフェース',
        'Description (short)' => '説明（概略）',
        'Description (long)' => '説明（詳細）',
        'The selected permission does not exist.' => '選択された権限は存在しません。',
        'Required Lock' => 'ロックをする',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => 'サブミットボタンのアドバイステキスト',
        'Submit Button Text' => 'サブミットボタン名',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'マウスで左から右にドラッグ・アンド・ドロップすることで、アクティビティ・ダイアログにフィールドを関連付けることが出来ます',
        'Filter available fields' => '利用可能な領域をフィルタ',
        'Available Fields' => '利用可能な領域',
        'Assigned Fields' => '割り当てられた領域',
        'Communication Channel' => 'コミュニケーション・チャネル',
        'Is visible for customer' => '顧客が閲覧可能',
        'Display' => '表示',

        # Template: AdminProcessManagementPath
        'Path' => 'パス',
        'Edit this transition' => 'この遷移を編集',
        'Transition Actions' => '遷移動作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'マウスで左から右にドラッグ・アンド・ドロップすることで、推移アクションをこの推移に関連付けることができます。',
        'Filter available Transition Actions' => '利用可能な遷移動作をフィルタ',
        'Available Transition Actions' => '利用可能な遷移動作',
        'Create New Transition Action' => '新しい遷移アクションを作成',
        'Assigned Transition Actions' => '割り当てられた遷移動作',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'アクティビティ',
        'Filter Activities...' => 'アクティビティの絞り込み',
        'Create New Activity' => '新しいアクティビティを作成',
        'Filter Activity Dialogs...' => 'アクティビティ・ダイアログの絞り込み',
        'Transitions' => '遷移',
        'Filter Transitions...' => '遷移の絞り込み',
        'Create New Transition' => '新しい遷移を作成',
        'Filter Transition Actions...' => '遷移アクションの絞り込み',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'プロセスを編集',
        'Print process information' => 'プロセス情報を印刷',
        'Delete Process' => 'プロセスを削除',
        'Delete Inactive Process' => '非アクティブなプロセスを削除',
        'Available Process Elements' => '有効なプロセス要素',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'サイドバー上の要素はドラッグ・アンド・ドロップによりキャンバス上に配置することができます。',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'アクティビティをキャンバスに配置することでアクティビティをプロセスと関連付けることができます。',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'アクティビティ・ダイアログをアクティビティに関連付けるには、サイドバーからキャンバス上のアクティビティにドラッグ・アンド・ドロップして下さい。',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => 'プロセスの情報を編集',
        'Process Name' => 'プロセス名',
        'The selected state does not exist.' => '選択されたステータスは存在しません。',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'アクティビティ、アクティビティダイアログ、遷移を追加、編集',
        'Show EntityIDs' => 'エンティティIDを表示',
        'Extend the width of the Canvas' => 'キャンバスの幅を広げる',
        'Extend the height of the Canvas' => 'キャンバスの高さを拡大する',
        'Remove the Activity from this Process' => 'このプロセスからアクティビティを削除',
        'Edit this Activity' => 'このアクティビティを編集',
        'Save Activities, Activity Dialogs and Transitions' => 'クティビティ、アクティビティダイアログ、遷移を保存',
        'Do you really want to delete this Process?' => 'このプロセスを本当に削除しますか？',
        'Do you really want to delete this Activity?' => 'このアクティビティを本当に削除しますか？',
        'Do you really want to delete this Activity Dialog?' => 'このアクティビティダイアログを本当に削除しますか？',
        'Do you really want to delete this Transition?' => 'この遷移を本当に削除しますか？',
        'Do you really want to delete this Transition Action?' => 'この遷移動作を本当に削除しますか？',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '本当にこのアクティビティをキャンバス上から削除してもよろしいですか？保存せずにこの画面から移動する場合を除いてこの操作の取り消しはできません。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '本当にこの遷移をキャンバス上から削除してもよろしいですか？保存せずにこの画面から移動する場合を除いてこの操作の取り消しはできません。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'この画面では、新規プロセスを作成することが出来ます。作成したプロセスを使用できるようにするには、ステータスを「有効」にした後に変更を同期してください。',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'キャンセルして閉じる',
        'Start Activity' => 'アクティビティを開始',
        'Contains %s dialog(s)' => '%sのダイアログが含まれています',
        'Assigned dialogs' => '割り当てられたダイアログ',
        'Activities are not being used in this process.' => 'アクティビティはこのプロセスで使用されていません。',
        'Assigned fields' => '割り当てられたフィールド',
        'Activity dialogs are not being used in this process.' => 'アクティビティダイアログはこのプロセスで使用されていません。',
        'Condition linking' => '条件リンク',
        'Transitions are not being used in this process.' => '遷移はこのプロセスで使用されていません。',
        'Module name' => 'モジュール名',
        'Transition actions are not being used in this process.' => '遷移アクションはこのプロセスで使用されていません。',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'この推移に対する変更は以下のプロセスに影響を与えます',
        'Transition' => '遷移',
        'Transition Name' => '遷移名',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'この推移アクションに対する変更は、以下のプロセスに影響を与えます',
        'Transition Action' => '遷移動作',
        'Transition Action Name' => '遷移動作名',
        'Transition Action Module' => '遷移動作モジュール',
        'Config Parameters' => 'パラメータの設定',
        'Add a new Parameter' => '新規パラメータを追加',
        'Remove this Parameter' => 'このパラメータを削除',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'キューを追加',
        'Edit Queue' => 'キューを編集',
        'Filter for Queues' => 'キューでフィルター',
        'Filter for queues' => 'キューのフィルター',
        'A queue with this name already exists!' => '同じ名前のキューが既に存在しています！',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => '親キュー',
        'Unlock timeout' => 'ロックの解除期限',
        '0 = no unlock' => '0 = ロック解除しない',
        'hours' => '時間',
        'Only business hours are counted.' => '勤務時間のみ計算されます',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '担当者がチケットロック後、ロック期限切れ前にクローズしていない場合、ロックは解除され、他の担当者がチケットを担当できるようになります。',
        'Notify by' => '通知する時間',
        '0 = no escalation' => '0 = エスカレーションしない',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'ここで定義された時間の前に、新規チケットに顧客連絡先が追加されていないか、メール送信、電話などの連絡を取っていない場合、チケットがエスカレーションされます。',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'メールでのフォローアップやカスタマーポータルに追加された記事があれば、エスカレーション更新期限はリセットされます。ここで定義された時間内に顧客からの外部メールや電話の記録が追加されない場合、チケットがエスカレーションされます。',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'ここで定義された時間の前にチケットがクローズしない場合、チケットがエスカレーションされます。',
        'Follow up Option' => 'フォローアップ・オプション',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'クローズしたチケットにフォローアップしたい場合、チケットを再度対応中にするか、拒否して新規チケットにするかを指定します。',
        'Ticket lock after a follow up' => 'フォローアップ後にチケットをロック',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'チケットがクローズした後に顧客がチケットにフォローアップする場合、旧所有者にロックされます。',
        'System address' => 'システムアドレス',
        'Will be the sender address of this queue for email answers.' => 'このキューでのメール回答はこの送信者アドレスになります。',
        'Default sign key' => '既定のサインキー',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => '挨拶文',
        'The salutation for email answers.' => 'メール回答の挨拶文',
        'Signature' => '署名',
        'The signature for email answers.' => 'メール回答の署名',
        'This queue is used in the following config settings:' => 'このキューは、次の設定で使用されます。',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'キュー-自動応答の関連性の管理',
        'Change Auto Response Relations for Queue' => 'キューに対する自動応答の関連性を変更',
        'This filter allow you to show queues without auto responses' => 'このフィルターを使用すると、自動応答なしでキューを表示できます',
        'Queues without Auto Responses' => '自動応答のないキュー',
        'This filter allow you to show all queues' => 'このフィルターを使用すると、全てのキューを表示できます。',
        'Show All Queues' => '全てのキューを表示',
        'Auto Responses' => '自動応答',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'テンプレート-キューの関連性の管理',
        'Filter for Templates' => 'テンプレートでフィルター',
        'Filter for templates' => '',
        'Templates' => 'テンプレート',

        # Template: AdminRegistration
        'System Registration Management' => 'システム登録管理',
        'Edit System Registration' => 'システム登録を修正',
        'System Registration Overview' => 'システム登録一覧',
        'Register System' => '登録システム',
        'Validate OTOBO-ID' => 'OTOBO-IDの検証',
        'Deregister System' => 'システム登録',
        'Edit details' => '詳細を編集',
        'Show transmitted data' => '送信されたデータを表示',
        'Deregister system' => 'システムを未登録に戻す',
        'Overview of registered systems' => '登録されたシステムの概要',
        'This system is registered with OTOBO Team.' => 'このシステムはOTRS社もしくは関連する会社に登録されています。',
        'System type' => 'システム種別',
        'Unique ID' => 'ユニークID',
        'Last communication with registration server' => '登録管理サーバに対する最後のアクセス',
        'System Registration not Possible' => 'システム登録ができない',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            '注意：OTOBOデーモンが起動していないと、システムの登録が正常に行えません。',
        'Instructions' => '指示',
        'System Deregistration not Possible' => 'システムの登録解除ができない',
        'OTOBO-ID Login' => 'OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'OTRSグループへのシステムのサポート登録により、多くのメリットが提供されます。',
        'Read more' => '続きを読む',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'システムを登録するには、OTOBO-IDでログインする必要があります。',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'OTOBO-IDはOTOBO.comのウェブページでサインアップに用いたE-Mailアドレスです。',
        'Data Protection' => 'データ保護',
        'What are the advantages of system registration?' => 'システムを登録することのメリット',
        'You will receive updates about relevant security releases.' => '',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTOBO without being registered?' => '登録せずにOTOBOを利用できますか？',
        'System registration is optional.' => 'システムへの登録は任意です。',
        'You can download and use OTOBO without being registered.' => 'OTOBOは、登録することなくダウンロード・利用することができます。',
        'Is it possible to deregister?' => '',
        'You can deregister at any time.' => '',
        'Which data is transfered when registering?' => '',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            '',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => '',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTOBO system send updates?' => '',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            '',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'まだ OTOBO-ID をお持ちではありませんか？',
        'Sign up now' => '新規登録する',
        'Forgot your password?' => 'パスワードを忘れましたか？',
        'Retrieve a new one' => '',
        'Next' => '次へ',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => '属性',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBOバージョン',
        'Operating System' => 'オペレーションシステム',
        'Perl Version' => 'Perl バージョン',
        'Optional description of this system.' => '',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'この操作は、システムによる OTOBO Team への追加サポート情報の送信を許可します。',
        'Register' => '登録',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => '登録解除',
        'You can modify registration settings here.' => '',
        'Overview of Transmitted Data' => '送信されたデータの 概要',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => 'システム登録データ',
        'Support Data' => 'サポートデータ',

        # Template: AdminRole
        'Role Management' => 'ロール管理',
        'Add Role' => 'ロールを追加',
        'Edit Role' => 'ロールを編集',
        'Filter for Roles' => 'ロールでフィルター',
        'Filter for roles' => 'ロールでフィルター',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'ロールを作成してグループを追加後、ユーザーにロールを追加してください。',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '未定義のロールがあります。新しいロールを作成し、追加ボタンを押してください。',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'ロール-グループの関連性管理',
        'Roles' => 'ロール',
        'Select the role:group permissions.' => 'ロール：グループ権限を選択。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '何も選択しなかった場合は、そのグループへ付与される許可はありません（ロールに関してチケットは利用できません）',
        'Toggle %s permission for all' => '全ての %s の権限を切り替え',
        'move_into' => '移転',
        'Permissions to move tickets into this group/queue.' => 'このグループ／キューにチケットの移転権限を付与',
        'create' => '作成',
        'Permissions to create tickets in this group/queue.' => 'このグループ／キューにチケットの作成権限を付与',
        'note' => 'メモ',
        'Permissions to add notes to tickets in this group/queue.' => 'このグループ／キューにチケットへメモ追加権限を付与',
        'owner' => '所有者',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'このグループ／キューにチケットへ所有者変更権限を付与',
        'priority' => '優先度（priority）',
        'Permissions to change the ticket priority in this group/queue.' =>
            'このグループ／キューにチケットの優先度変更権限を付与',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '担当者-ロールの関連性管理',
        'Add Agent' => '担当者の追加',
        'Filter for Agents' => '担当者でフィルター',
        'Filter for agents' => '',
        'Agents' => '担当者',
        'Manage Role-Agent Relations' => 'ロール-担当者の関連性管理',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Edit SLA' => 'SLAを編集',
        'Add SLA' => 'SLAを追加',
        'Filter for SLAs' => 'SLAでフィルター',
        'Please write only numbers!' => '数値しか入力できません。',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add Certificate' => '証明書を追加',
        'Add Private Key' => '秘密鍵を追加',
        'SMIME support is disabled' => 'SMIMEのサポートが無効になっています',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            '',
        'Enable SMIME support' => 'SMIMEサポートを有効にする',
        'Faulty SMIME configuration' => '無効なSMIME設定',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME機能が有効化されましたが関連する設定にエラーがあります。ボタンを押して設定を確認してください。',
        'Check SMIME configuration' => 'SMIME設定の確認',
        'Filter for Certificates' => '証明書でフィルター',
        'Filter for certificates' => '証明書でフィルタ',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => '参照',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'この方法で直接認証と秘密鍵を編集できます。',
        'Hash' => 'ハッシュ',
        'Create' => '作成',
        'Handle related certificates' => '関連付けられた証明書を利用する',
        'Read certificate' => '証明書を読む',
        'Delete this certificate' => 'この証明書を削除',
        'File' => 'ファイル',
        'Secret' => '秘密',
        'Related Certificates for' => '証明書を関連付ける',
        'Delete this relation' => 'この関係を削除する',
        'Available Certificates' => '利用可能な証明書',
        'Filter for S/MIME certs' => 'S/MIME証明書でフィルター',
        'Relate this certificate' => 'この証明書を関連付ける',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME証明書',
        'Certificate Details' => '証明書の詳細',
        'Close this dialog' => 'このダイアログを閉じる',

        # Template: AdminSalutation
        'Salutation Management' => '挨拶文管理',
        'Add Salutation' => '挨拶文を追加',
        'Edit Salutation' => '挨拶文を編集',
        'Filter for Salutations' => '挨拶文でフィルター',
        'Filter for salutations' => '挨拶文でフィルター',
        'e. g.' => '例',
        'Example salutation' => '挨拶文の例',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'セキュアモードを有効にしてください。',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '初回インストール完了後、セキュアモード (通常) に設定されます',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'セキュアモードが無効の場合、アプリケーションが既に実行されているため、SysConfigを介して有効にします。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQLボックス',
        'Filter for Results' => '結果でフィルター',
        'Filter for results' => '結果でフィルター',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'ここではアプリケーションデータベースに直接送るSQLを入力することができます。表の定義を変更することはできません。選択問合せのみ可能です。',
        'Here you can enter SQL to send it directly to the application database.' =>
            'ここではアプリケーションデータベースに直接送るSQLを入力することができます。',
        'Options' => 'オプション',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQLクエリの構文に誤りがあります。確認してください。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => '結果の書式',
        'Run Query' => 'クエリー実行',
        '%s Results' => '%s結果',
        'Query is executed.' => 'クエリは実行されました。',

        # Template: AdminService
        'Service Management' => 'サービス管理',
        'Add Service' => 'サービスの追加',
        'Edit Service' => 'サービスの編集',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'サービス名は、(サブサービス名を含めて) 半角200文字以内にする必要があります。',
        'Sub-service of' => '親サービス',

        # Template: AdminSession
        'Session Management' => 'セッション管理',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => '全てのセッション',
        'Agent sessions' => '担当者のセッション',
        'Customer sessions' => '顧客のセッション',
        'Unique agents' => '一意の担当者',
        'Unique customers' => '一意の顧客',
        'Kill all sessions' => '全てのセッションを切断',
        'Kill this session' => '現在のセッションを切断',
        'Filter for Sessions' => 'セッションでフィルター',
        'Filter for sessions' => 'セッションでフィルター',
        'Session' => 'セッション',
        'Kill' => '切断',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => '署名管理',
        'Add Signature' => '署名を追加',
        'Edit Signature' => '署名を編集',
        'Filter for Signatures' => '署名でフィルター',
        'Filter for signatures' => '署名でフィルター',
        'Example signature' => '署名の例',

        # Template: AdminState
        'State Management' => 'ステータス管理',
        'Add State' => 'ステータスを追加',
        'Edit State' => 'ステータスを編集',
        'Filter for States' => 'ステータスでフィルター',
        'Filter for states' => 'ステータスでフィルター',
        'Attention' => '注意',
        'Please also update the states in SysConfig where needed.' => 'また、必要に応じてシステム設定のステータスを更新して下さい。',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'このステータスはシステム設定の設定にあり、新しいタイプを指すように設定を更新する必要があります！',
        'State type' => 'ステータスのタイプ',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => 'このステータスは、次の設定で使用されます。',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'OTOBO Team へのサポートデータの送信ができません！',
        'Enable Cloud Services' => 'クラウドサービスを有効にする',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'このデータは定期的にOTRSグループに送られます。 このデータの送信を停止するには、システム登録を更新して下さい。',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '手動でこのボタンを押すことにより、サポートデータを送信することができます。',
        'Send Update' => '更新を送信',
        'Currently this data is only shown in this system.' => 'このデータは現在このシステム上で表示されています。',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'より良いサポートを提供するために、このデータをOTRSグループにお送りいただくことを強くお勧めします。',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'データ送信を有効にするために、OTOBO Team へのシステムの登録・更新をお願いします (併せて「サポート情報の送信」のチェックを有効にするのを忘れずに)。',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'このボタンを押すとサポートバンドル(システム登録情報、サポートに必要なデータ、インストールされているパッケージリスト、変更されているソース)が作成されます。',
        'Generate Support Bundle' => 'サポートバンドルの生成',
        'The Support Bundle has been Generated' => 'サポートバンドルが生成されました',
        'Please choose one of the following options.' => '次のいずれかのオプションを選択して下さい。',
        'Send by Email' => 'Eメールで送信',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'サポートバンドルをメールで送信するには大きすぎたため、このオプションは無効化されました。',
        'The email address for this user is invalid, this option has been disabled.' =>
            'このユーザーのメールアドレスは無効です。このオプションは無効になっています。',
        'Sending' => '送信者',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'サポートバンドルはOTRSグループに電子メールで自動的に送信されます。',
        'Download File' => 'ファイルのダウンロード',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'サポートバンドルを含むファイルをダウンロードします。ファイルを保存しOTRSグループに他の手段で送信してください。',
        'Error: Support data could not be collected (%s).' => 'エラー：サポートデータを収集できませんでした。（%s）',
        'Details' => '詳細',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'システムメールアドレスの管理',
        'Add System Email Address' => 'システムメールアドレスの追加',
        'Edit System Email Address' => 'システムメールアドレスの編集',
        'Add System Address' => 'システムアドレスを追加',
        'Filter for System Addresses' => 'システムアドレスでフィルター',
        'Filter for system addresses' => 'システムアドレスでフィルター',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '宛先かCcにこのアドレスを持つ全てのメールは選択されたキューに振り分けられます。',
        'Email address' => 'メールアドレス',
        'Display name' => '表示名',
        'This email address is already used as system email address.' => 'このメールアドレスは、すでにシステム用メールアドレスとして利用されています。',
        'The display name and email address will be shown on mail you send.' =>
            '表示名、メールアドレスは送信メールに表示されます。',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'オンライン管理者向けドキュメント',
        'System configuration' => 'システム設定',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '左側のナビゲーションボックスのツリーを使用して、使用可能な設定をナビゲートします。',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '下の検索フィールドまたは上のナビゲーションの検索アイコンを使用して、特定の設定を見つけます。',
        'Find out how to use the system configuration by reading the %s.' =>
            '%sを読んでシステム設定を使い方を確認して下さい。',
        'Search in all settings...' => '全ての設定で検索...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '変更のデプロイ',
        'Help' => 'ヘルプ',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'デフォルトでは、あなた自身が行った変更点のみに対してデプロイを行うことができます。もし、あなたが他のユーザーが行った変更点に対してもデプロイを行いたい場合は、画面上部に表示されているリンクをクリックしてアドバンスド・デプロイメント・モードに切り替えてください。',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'デプロイメントが復元され、影響を受けるすべての設定が、選択したデプロイメントの状態に差し戻されています。',
        'Please review the changed settings and deploy afterwards.' => '変更された設定を確認し、その後にデプロイして下さい。',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '変更差分のリストが空であるということは、影響を受けるであろう現状の設定と復元された設定の間に差異がないことを示します。',
        'Changes Overview' => '変更一覧',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            'この実行でデプロイされる変更された設定%sがあります。',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => 'デプロイする設定はありません。',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '拡張モードに切り替えて、他のユーザーが変更したデプロイ設定を確認します。',
        'Deploy selected changes' => '選択された変更をデプロイ',

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
            'このグループには設定が含まれていません。 サブグループの1つに移動してみて下さい。',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'インポート&エクスポート',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'システムにインポートするファイル（システム設定からエクスポートされたYML形式）をアップロードします。',
        'Upload system configuration' => 'システム設定をアップロード',
        'Import system configuration' => 'システム設定をインポート',
        'Download current configuration settings of your system in a .yml file.' =>
            '現在のシステム設定のファイル（YML形式）をダウンロードして下さい。',
        'Include user settings' => 'ユーザー設定を含める',
        'Export current configuration' => '現在の設定をエクスポート',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '検索する',
        'Search for category' => 'カテゴリを検索',
        'Settings I\'m currently editing' => '現在編集中の設定',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'カテゴリ "%s"の "%s"の検索結果が返されませんでした。',
        'Your search for "%s" in category "%s" returned one result.' => 'カテゴリ "%s"の "%s"の検索結果が1つ返されました。',
        'Your search for "%s" in category "%s" returned %s results.' => 'カテゴリ "%s"の "%s"の検索結果が%s件の結果を返しました。',
        'You\'re currently not editing any settings.' => '現在、設定を編集していません。',
        'You\'re currently editing %s setting(s).' => 'あなたは現在%sの設定を編集しています。',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => '区分',
        'Run search' => '検索を実行',

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
        'View a custom List of Settings' => 'カスタム設定の一覧を表示',
        'View single Setting: %s' => '単一の設定を表示：%s',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'システムメンテナンス管理',
        'Schedule New System Maintenance' => '新しいシステムメンテナンスをスケジュール',
        'Filter for System Maintenances' => 'システムメンテナンスでフィルター',
        'Filter for system maintenances' => 'システムメンテナンスでフィルター',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'このシステムメンテナンスが開始する前に、ユーザはシステムメンテナンスが行われることについてアナウンスする各画面上で通知を受け取ります。',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Stop date' => '終了日',
        'Delete System Maintenance' => 'システムメンテナンスを削除',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'システムメンテナンスを修正',
        'Edit System Maintenance Information' => 'システムメンテナンス情報を修正',
        'Date invalid!' => '日時が無効です。',
        'Login message' => 'ログインメッセージ',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'ログインメッセージを表示',
        'Notify message' => '通知メッセージ',
        'Manage Sessions' => 'セッションの管理',
        'All Sessions' => '全てのセッション',
        'Agent Sessions' => '担当者のセッション',
        'Customer Sessions' => '顧客のセッション',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'テンプレートを追加',
        'Edit Template' => 'テンプレートを編集',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'テンプレートは担当者による高速なチケット作成、回答または転送を支援するデフォルトの本文です。',
        'Don\'t forget to add new templates to queues.' => '新しいテンプレートにキューを追加してください。',
        'Attachments' => '添付ファイル',
        'Delete this entry' => 'この登録を削除',
        'Do you really want to delete this template?' => '本当にこのテンプレートを削除してよろしいですか？',
        'A standard template with this name already exists!' => '',
        'Create type templates only supports this smart tags' => '作成するタイプテンプレートはこのスマートタグのみをサポートします。',
        'Example template' => 'テンプレート例',
        'The current ticket state is' => '現在のチケットのステータスは',
        'Your email address is' => 'あなたのメールアドレスは',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => '全てを有効に切り替え',
        'Link %s to selected %s' => '%s を選択された %s へリンク',

        # Template: AdminType
        'Type Management' => 'タイプ管理',
        'Add Type' => 'タイプの追加',
        'Edit Type' => 'タイプの編集',
        'Filter for Types' => 'タイプでフィルター',
        'Filter for types' => 'タイプでフィルター',
        'A type with this name already exists!' => 'この名前のタイプは既に存在します!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => '担当者管理',
        'Edit Agent' => '担当者の編集',
        'Edit personal preferences for this agent' => 'この担当者の個人設定を編集',
        'Agents will be needed to handle tickets.' => '担当者はチケットを処理するために必要です。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '新規担当者をグループまたはロールに追加してください。',
        'Please enter a search term to look for agents.' => '担当者を検索するための条件を入力してください。',
        'Last login' => '最終ログイン',
        'Switch to agent' => '担当者を切り替え',
        'Title or salutation' => 'タイトルまたは挨拶文',
        'Firstname' => '姓',
        'Lastname' => '名',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '空白のままにした場合、自動的に生成されます。',
        'Mobile' => '携帯電話',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => 'この担当者にはグループ権限はありません。',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '担当者 - グループの関連性の管理',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'アジェンダ表示',
        'Manage Calendars' => 'カレンダー管理',
        'Add Appointment' => '予約の登録',
        'Today' => '本日',
        'All-day' => '終日',
        'Repeat' => '繰り返し',
        'Notification' => '通知',
        'Yes' => 'はい',
        'No' => 'いいえ',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'カレンダーは見つかりませんでした。 まずカレンダーの管理ページを使用してカレンダーを追加して下さい。',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '予約の登録',
        'Calendars' => 'カレンダー',

        # Template: AgentAppointmentEdit
        'Basic information' => '基本情報',
        'Date/Time' => '日にち/時間',
        'Invalid date!' => '無効な日付です。',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => 'これは繰り返しの予定です。',
        'Click here to see the parent appointment.' => '親の予定を見るには、ここをクリックして下さい。',
        'Click here to edit the parent appointment.' => '親の予定を修正するには、ここをクリックして下さい。',
        'Frequency' => '頻度',
        'Every' => '全て',
        'day(s)' => '日',
        'week(s)' => '週',
        'month(s)' => '月',
        'year(s)' => '年',
        'On' => 'オン',
        'Monday' => '月曜日',
        'Mon' => '月',
        'Tuesday' => '火曜日',
        'Tue' => '火',
        'Wednesday' => '水曜日',
        'Wed' => '水',
        'Thursday' => '木曜日',
        'Thu' => '木',
        'Friday' => '金曜日',
        'Fri' => '金',
        'Saturday' => '土曜日',
        'Sat' => '土',
        'Sunday' => '日曜日',
        'Sun' => '日',
        'January' => '1月',
        'Jan' => '1月',
        'February' => '2月',
        'Feb' => '2月',
        'March' => '3月',
        'Mar' => '3月',
        'April' => '4月',
        'Apr' => '4月',
        'May_long' => '5月',
        'May' => '5月',
        'June' => '6月',
        'Jun' => '6月',
        'July' => '7月',
        'Jul' => '7月',
        'August' => '8月',
        'Aug' => '8月',
        'September' => '9月',
        'Sep' => '9月',
        'October' => '10月',
        'Oct' => '10月',
        'November' => '11月',
        'Nov' => '11月',
        'December' => '12月',
        'Dec' => '12月',
        'Relative point of time' => '',
        'Link' => 'リンク',
        'Remove entry' => '登録を削除',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '顧客情報センター',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '顧客ユーザー',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意: 顧客が無効です。',
        'Start chat' => 'チャットを開始する。',
        'Video call' => 'ビデオ通話',
        'Audio call' => '音声通話',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '顧客ユーザーのアドレス帳',
        'Search for recipients and add the results as \'%s\'.' => '受信者を検索し、結果を \'%s\'として追加します。',
        'Search template' => '検索テンプレート',
        'Create Template' => 'テンプレート作成',
        'Create New' => '新規作成',
        'Save changes in template' => '変更したテンプレートを保存',
        'Filters in use' => '使用中のフィルター',
        'Additional filters' => '追加のフィルター',
        'Add another attribute' => '属性を追加',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'XX(顧客)という表記は、顧客企業のデータです。',
        '(e. g. Term* or *Term*)' => '(例 Term *または* Term *）',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => '全選択',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => 'この顧客ユーザーを選択',
        'Add selected customer user to' => '選択した顧客ユーザーを追加する',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => '検索オプション変更',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '顧客ユーザー情報センター',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            '',
        'Starting the OTOBO Daemon' => 'OTOBO デーモンを起動しています。',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            '',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'ダッシュボード',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '予約の登録',
        'Tomorrow' => '翌日',
        'Soon' => 'すぐに',
        '5 days' => '5日',
        'Start' => '開始',
        'none' => 'なし',

        # Template: AgentDashboardCalendarOverview
        'in' => '＞',

        # Template: AgentDashboardCommon
        'Save settings' => '設定を保存',
        'Close this widget' => 'このウィジェットを閉じる',
        'more' => '続き',
        'Available Columns' => '利用可能な列',
        'Visible Columns (order by drag & drop)' => '表示する列 (ドラッグ&ドロップで並び替えできます)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '顧客関係を変更',
        'Open' => '対応中',
        'Closed' => 'クローズ',
        '%s open ticket(s) of %s' => '%sのオープンチケット%s',
        '%s closed ticket(s) of %s' => '%sのクローズチケット%s',
        'Edit customer ID' => '顧客IDを編集',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'エスカレーション済チケット',
        'Open tickets' => '対応中チケット',
        'Closed tickets' => 'クローズ・チケット',
        'All tickets' => '全てのチケット',
        'Archived tickets' => 'アーカイブされたチケット',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '注意: 顧客ユーザーが無効です。',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '顧客ユーザー情報',
        'Phone ticket' => '電話チケット',
        'Email ticket' => 'メールチケット',
        'New phone ticket from %s' => '%sからの新規電話チケット',
        'New email ticket to %s' => '%s宛の新規メールチケット',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s が利用できます。',
        'Please update now.' => '更新してください',
        'Release Note' => 'リリースノート',
        'Level' => 'レベル',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '%s の前の投稿',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'このレポート・ウィジェットの設定にエラーがあります。設定を確認して下さい。',
        'Download as SVG file' => 'SVGファイルとしてダウンロード',
        'Download as PNG file' => 'PNGファイルとしてダウンロード',
        'Download as CSV file' => 'CSVファイルとしてダウンロード',
        'Download as Excel file' => 'Excelファイルとしてダウンロード',
        'Download as PDF file' => 'PDFファイルとしてダウンロード',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'このウィジェットの設定で有効なグラフ出力形式を選択して下さい。',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'このレポートの内容はあなたのために用意されています。',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'このレポートは、レポート管理者が設定を修正する必要があるため、現在は使用できません。',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '顧客ユーザーに割り当てられた',
        'Accessible for customer user' => '顧客ユーザーにアクセス可能',
        'My locked tickets' => 'ロックチケット',
        'My watched tickets' => '監視チケット',
        'My responsibilities' => '責任チケット',
        'Tickets in My Queues' => '担当キュー内チケット',
        'Tickets in My Services' => '担当サービス内チケット',
        'Service Time' => 'サービス時間',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '計',

        # Template: AgentDashboardUserOnline
        'out of office' => '外出中',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '〜まで',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => '戻る',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentElasticsearchQuickResult
        'Ticketnumber' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'ニュース、ライセンスなどの変更を受け付ける。',
        'Yes, accepted.' => 'はい、受け入れます。',

        # Template: AgentLinkObject
        'Manage links for %s' => '%sのリンクを管理',
        'Create new links' => '新しいリンクを作成',
        'Manage existing links' => '既存のリンクを管理',
        'Link with' => 'リンク先',
        'Start search' => '検索',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '現在、リンクはありません。 このアイテムを他のオブジェクトにリンクするには、上部にある[新しいリンクを作成]をクリックしてください。',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'パスワード変更',
        'Current password' => '現在のパスワード',
        'New password' => '新しいパスワード',
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
        'Edit your preferences' => '個人設定を編集',
        'Personal Preferences' => '個人設定',
        'Preferences' => '個人設定',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => 'このエージェントの編集に戻る',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'あなたの個人的な好みを設定してください。 右のチェックマークをクリックして各設定を保存します。',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '以下のナビゲーションツリーを使用して、特定のグループの設定のみを表示することができます。',
        'Dynamic Actions' => 'ダイナミック・アクション',
        'Filter settings...' => 'フィルターを設定中...',
        'Filter for settings' => '設定でフィルター',
        'Save all settings' => 'すべての設定を保存',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'アバターイメージを変更するには、%sにあなたのメールアドレス(%s)を登録して下さい。キャッシュの影響により新しいアバターが利用可能になるまでには時間がかかることがあります。',
        'Off' => 'オフ',
        'End' => '終了',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => 'この設定は現在保存できません。',
        'Save this setting' => 'この設定を保存',
        'Did you know? You can help translating OTOBO at %s.' => 'ご存じですか? %sにてOTOBOの翻訳にご協力ください。',

        # Template: SettingsList
        'Reset to default' => 'デフォルトにリセットする',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '右側のグループから選択して、変更したい設定を見つけて下さい。',
        'Did you know?' => 'ご存知ですか？',
        'You can change your avatar by registering with your email address %s on %s' =>
            '%sで、あなたの電子メールアドレス%sを登録することによって、あなたのアバターに変更することができます。',

        # Template: AgentSplitSelection
        'Target' => 'ターゲット',
        'Process' => 'プロセス',
        'Split' => '分割',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'レポート管理',
        'Add Statistics' => 'レポートを追加',
        'Read more about statistics in OTOBO' => 'OTOBOのレポートについて詳細を読む',
        'Dynamic Matrix' => '集計',
        'Each cell contains a singular data point.' => '各セルには特異点が含まれています。',
        'Dynamic List' => '一覧',
        'Each row contains data of one entity.' => '各行には1つのエンティティのデータが含まれています。',
        'Static' => '静的',
        'Non-configurable complex statistics.' => '構成できない複雑なレポート',
        'General Specification' => '一般仕様',
        'Create Statistic' => 'レポートを作成',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'レポートを編集',
        'Run now' => '今すぐ実行',
        'Statistics Preview' => 'レポートのプレビュー',
        'Save Statistic' => 'レポートを保存',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'レポートをインポート',
        'Import Statistics Configuration' => 'レポート設定をインポート',

        # Template: AgentStatisticsOverview
        'Statistics' => 'レポート',
        'Run' => '実行',
        'Edit statistic "%s".' => 'レポート"%s"を修正',
        'Export statistic "%s"' => 'レポート"%s"をエクスポート',
        'Export statistic %s' => 'レポート"%s"をエクスポート',
        'Delete statistic "%s"' => 'レポート"%s"を削除',
        'Delete statistic %s' => 'レポート"%s"を削除',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'レポート一覧',
        'View Statistics' => '統計を閲覧',
        'Statistics Information' => 'レポート情報',
        'Created by' => '作成者',
        'Changed by' => '変更者',
        'Sum rows' => '行の合計',
        'Sum columns' => '列の合計',
        'Show as dashboard widget' => 'ダッシュボードウィジェットとして表示',
        'Cache' => 'キャッシュ',
        'This statistic contains configuration errors and can currently not be used.' =>
            'このレポートには構成エラーがあり、現在は使用できません。',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '%s%s%sのフリーテキストを変更',
        'Change Owner of %s%s%s' => '%s%s%sの所有者を変更',
        'Close %s%s%s' => '%s%s%sを閉じる',
        'Add Note to %s%s%s' => '%s%s%sにメモを追加',
        'Set Pending Time for %s%s%s' => '%s%s%sの保留時間を設定',
        'Change Priority of %s%s%s' => '%s%s%sの優先度を変更',
        'Change Responsible of %s%s%s' => '%s%s%sの責任者を変更',
        'The ticket has been locked' => 'チケットはロック済です',
        'Undo & close' => '元に戻して閉じる',
        'Ticket Settings' => 'チケット設定',
        'Queue invalid.' => '無効なキューです。',
        'Service invalid.' => '無効なサービスです',
        'SLA invalid.' => 'SLAが無効です。',
        'New Owner' => '新しい所有者',
        'Please set a new owner!' => '新規所有者を設定してください。',
        'Owner invalid.' => '所有者が無効です。',
        'New Responsible' => '新しい責任者',
        'Please set a new responsible!' => '新しい責任者を設定して下さい！',
        'Responsible invalid.' => '責任者が無効です。',
        'Next state' => 'ステータス',
        'State invalid.' => 'ステータスが無効です。',
        'For all pending* states.' => '全ての保留ステータスに対して有効',
        'Add Article' => '記事を追加',
        'Create an Article' => '記事を作成',
        'Inform agents' => '担当者に通知する',
        'Inform involved agents' => '関係する担当者に通知する',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'ここでは、新しい記事に関する通知を受け取るべき担当者をを選択することができます。',
        'Text will also be received by' => 'このテキストは、次の方も閲覧可能です',
        'Text Template' => '本文テンプレート',
        'Setting a template will overwrite any text or attachment.' => 'テンプレートを設定すると作成中の本文または添付ファイルは上書きされます。',
        'Invalid time!' => '無効な時間です。',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '%s%s%sをバウンス',
        'Bounce to' => 'バウンスto',
        'You need a email address.' => 'メールアドレスが必要です',
        'Need a valid email address or don\'t use a local email address.' =>
            '有効なメールアドレスを使用するか、ローカルなメールアドレスを使用しないでください。',
        'Next ticket state' => 'ステータス',
        'Inform sender' => '送信者に知らせる',
        'Send mail' => 'メール送信！',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'チケット一括処理',
        'Send Email' => 'Eメールの送信',
        'Merge' => '結合',
        'Merge to' => 'これと結合',
        'Invalid ticket identifier!' => '無効なチケット識別子です。',
        'Merge to oldest' => '古いものへ結合',
        'Link together' => '一緒にリンク',
        'Link to parent' => '親へリンク',
        'Unlock tickets' => 'チケットのロック解除',
        'Execute Bulk Action' => '一括処理を実行',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '%s%s%sの返信を作成',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => '受信者を少なくとも1人は含めるようにして下さい。',
        'Select one or more recipients from the customer user address book.' =>
            '顧客ユーザーのアドレス帳から1人以上の受信者を選択します。',
        'Customer user address book' => '顧客ユーザーのアドレス帳',
        'Remove Ticket Customer' => 'チケットの顧客を削除',
        'Please remove this entry and enter a new one with the correct value.' =>
            'このエントリーを削除し、正しい値で新しいエントリーを追加してください。',
        'This address already exists on the address list.' => 'この住所はすでにアドレスリストに存在します。',
        'Remove Cc' => 'Ccを削除',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Bccを削除',
        'Date Invalid!' => '日時が無効です。',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '%s%s%sの顧客を変更',
        'Customer Information' => '顧客情報',
        'Customer user' => '顧客ユーザー',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '新規メールチケットの作成',
        'Example Template' => 'テンプレート例',
        'To customer user' => '宛先顧客ユーザー',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => 'チケットの顧客ユーザーを削除',
        'From queue' => 'キューから',
        'Get all' => '全てを取得',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '%s%s%sの送信メール',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '%s%s%sのメールを再送信',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '%s%s%sを転送',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '%s%s%sの履歴',
        'Filter for history items' => '履歴アイテムをフィルター',
        'Expand/collapse all' => 'すべて展開/折りたたむ',
        'CreateTime' => '作成日時',
        'Article' => '記事',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '%s%s%sをマージ',
        'Merge Settings' => 'マージ設定',
        'You need to use a ticket number!' => '使用するチケット番号が必要です。',
        'A valid ticket number is required.' => '有効なチケット番号が必要です。',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '送信者を通知',
        'Need a valid email address.' => '有効なメールアドレスが必要です。',

        # Template: AgentTicketMove
        'Move %s%s%s' => '%s%s%sを移転',
        'New Queue' => '新規キュー',
        'Move' => '移転',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'チケットデータがありません',
        'Open / Close ticket action menu' => 'チケットアクションメニューを開く/閉じる',
        'Select this ticket' => 'このチケットを選択',
        'Sender' => '送信者',
        'First Response Time' => '初回応答期限',
        'Update Time' => '更新期限',
        'Solution Time' => '解決期限',
        'Move ticket to a different queue' => '別のキューへチケットを移転',
        'Change queue' => 'キュー変更',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'この画面のアクティブなフィルターを削除します。',
        'Tickets per page' => 'ページ毎のチケット数',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'チャンネルがありません。',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '一覧のリセット',
        'Column Filters Form' => 'カラム・フィルター・フォーム',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '新規電話チケットに分割',
        'Save Chat Into New Phone Ticket' => 'チャットを新規チケットに保存する。',
        'Create New Phone Ticket' => '新規電話チケットの作成',
        'Please include at least one customer for the ticket.' => 'チケットには少なくとも1名のお客様を含めるようにして下さい。',
        'To queue' => 'キュー',
        'Chat protocol' => 'チャットプロトコル',
        'The chat will be appended as a separate article.' => 'チャットは新規記事として追加されます。',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '%s%s%sの受話',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '%s%s%sの電子メールを表示',
        'Plain' => '書式なし',
        'Download this email' => 'このメールをダウンロード',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '新しいプロセスチケットを作成',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'チケットをプロセスに登録する',

        # Template: AgentTicketSearch
        'Profile link' => 'プロファイル・リンク',
        'Output' => '出力',
        'Fulltext' => '全文',
        'Customer ID (complex search)' => 'Customer ID (複合検索)',
        '(e. g. 234*)' => '(例 234*)',
        'Customer ID (exact match)' => 'Customer ID (完全一致)',
        'Assigned to Customer User Login (complex search)' => '顧客ユーザーのログインに割り当てられた（複合検索）',
        '(e. g. U51*)' => '(例 U51*)',
        'Assigned to Customer User Login (exact match)' => '顧客のユーザーログインに割り当てられた（完全一致）',
        'Accessible to Customer User Login (exact match)' => '顧客のログインにアクセス可能（完全一致）',
        'Created in Queue' => 'キューで作成された',
        'Lock state' => 'ロックの状態',
        'Watcher' => '監視者',
        'Article Create Time (before/after)' => '記事作成日時 (以前/以後)',
        'Article Create Time (between)' => '記事作成日時 (期間指定)',
        'Please set this to value before end date.' => '終了日より前の値を設定して下さい。',
        'Please set this to value after start date.' => '終了日より後の値を設定して下さい。',
        'Ticket Create Time (before/after)' => 'チケット作成日時 (以前/以後)',
        'Ticket Create Time (between)' => 'チケット作成日時 (期間指定)',
        'Ticket Change Time (before/after)' => 'チケット変更時間 (以前/以後)',
        'Ticket Change Time (between)' => 'チケット変更日時 (期間指定)',
        'Ticket Last Change Time (before/after)' => 'チケット最終変更時間 (以前/以後)',
        'Ticket Last Change Time (between)' => 'チケット最終変更日時 (期間指定)',
        'Ticket Pending Until Time (before/after)' => 'ある時間帯(以前/以後)のチケットを保留中',
        'Ticket Pending Until Time (between)' => 'ある時間帯のチケットを保留中',
        'Ticket Close Time (before/after)' => 'チケット・クローズ時間 (以前/以後)',
        'Ticket Close Time (between)' => 'チケットのクローズ日時 (期間指定)',
        'Ticket Escalation Time (before/after)' => 'チケットエスカレーション時間 (以前/以後)',
        'Ticket Escalation Time (between)' => 'チケットエスカレーション日時 (期間指定)',
        'Archive Search' => 'アーカイブ検索',

        # Template: AgentTicketZoom
        'Sender Type' => '送信者タイプ',
        'Save filter settings as default' => 'デフォルトのフィルター設定を保存',
        'Event Type' => 'イベントタイプ',
        'Save as default' => 'ドラフトとして保存',
        'Drafts' => '下書き',
        'Change Queue' => 'キューを変更',
        'There are no dialogs available at this point in the process.' =>
            'このプロセスは完了しました。',
        'This item has no articles yet.' => 'このチケットにはまだ記事がありません。',
        'Ticket Timeline View' => 'チケットのタイムラインビュー',
        'Article Overview - %s Article(s)' => '記事一覧 - %s件',
        'Page %s' => '%sページ',
        'Add Filter' => 'フィルターを追加',
        'Set' => '設定',
        'Reset Filter' => 'フィルターをリセット',
        'No.' => '番号',
        'Unread articles' => '未読記事',
        'Via' => '経由',
        'Important' => '重要',
        'Unread Article!' => '未読記事があります。',
        'Incoming message' => '受信メッセージ',
        'Outgoing message' => '送信メッセージ',
        'Internal message' => '内部メッセージ',
        'Sending of this message has failed.' => 'このメッセージの送信に失敗しました。',
        'Resize' => 'リサイズ',
        'Mark this article as read' => 'この記事を既読にして下さい。',
        'Show Full Text' => '全文を表示する',
        'Full Article Text' => '全ての記事テキスト',
        'No more events found. Please try changing the filter settings.' =>
            '',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => '%s経由',
        'by %s' => '%sによって',
        'Toggle article details' => '記事の詳細を切り替える',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '次の記事でリンクを開くには、CtrlキーまたはCmdキーまたはShiftキーを押しながらリンクをクリックする必要があります（ブラウザとOSによって異なります）。',
        'Close this message' => 'このメッセージを閉じる',
        'Image' => '画像',
        'PDF' => 'PDF',
        'Unknown' => 'アンノウン',
        'View' => 'ビュー',

        # Template: LinkTable
        'Linked Objects' => 'オブジェクトをリンク',

        # Template: TicketInformation
        'Archive' => 'アーカイブ',
        'This ticket is archived.' => 'このチケットはアーカイブされています。',
        'Note: Type is invalid!' => '',
        'Pending till' => '保留時間',
        'Locked' => 'ロック状態',
        '%s Ticket(s)' => '%sチケット',
        'Accounted time' => '作業時間',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'ブロックされた内容を読み込み。',

        # Template: Breadcrumb
        'Home' => 'ホーム',
        'Back to admin overview' => '管理一覧に戻る',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'この機能にはクラウドサービスが必要',
        'You can' => '次のことができます: ',
        'go back to the previous page' => '直前のページに戻る',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '全てのCustomer IDから',
        'From assigned Customer IDs' => '割り当てられた顧客IDから',

        # Template: CustomerDashboard
        'Ticket Search' => '',
        'New Ticket' => '新規チケット',

        # Template: CustomerError
        'An Error Occurred' => 'エラーが発生しました。',
        'Error Details' => 'エラーの詳細',
        'Traceback' => 'トレースバック',

        # Template: CustomerFooter
        'Powered by %s' => 'powered by %s',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScriptが有効になっていません。',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'ブラウザの警告',
        'The browser you are using is too old.' => 'ご利用のブラウザは古すぎます。',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            '詳細はマニュアルを参照するか、管理者にお問い合わせください。',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'An Internet Explorer compatible version will soon be released nonetheless.' =>
            '',
        'One moment please, you are being redirected...' => '',
        'Login' => 'ログイン',
        'Your user name' => 'ユーザー名',
        'User name' => 'ユーザー名',
        'Your password' => 'パスワード',
        'Forgot password?' => 'パスワードを忘れましたか？',
        'Your 2 Factor Token' => '',
        '2 Factor Token' => '',
        'Log In' => 'ログイン',
        'Request Account' => '',
        'Request New Password' => '新規パスワードを申請',
        'Your User Name' => 'ユーザー名',
        'A new password will be sent to your email address.' => '登録されたメールアドレスに新しいパスワードを送信します。',
        'Create Account' => 'アカウント作成',
        'Please fill out this form to receive login credentials.' => '下記のフォームにログイン時に必要となる事項を入力してください。',
        'How we should address you' => '',
        'Your First Name' => 'あなたの姓',
        'Your Last Name' => 'あなたの名字',
        'Your email address (this will become your username)' => 'あなたの電子メールアドレス (ユーザー名になります)',

        # Template: CustomerNavigationBar
        'Logout' => 'ログアウト',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'ようこそ！',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'サービスレベル契約 (SLA)',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'ページ',
        'Tickets' => 'チケット',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'プロファイル',
        'e. g. 10*5155 or 105658*' => '例: 10*5155 または 105658*',
        'CustomerID' => '顧客ID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'チケットにおける全文検索（例えば、「John * n」または「Will *」）',
        'Types' => 'タイプ',
        'Time Restrictions' => '時間制限',
        'No time settings' => '時間設定なし',
        'All' => '全て',
        'Specific date' => '特定の日付',
        'Only tickets created' => '作成されたチケットのみ',
        'Date range' => '日付の範囲',
        'Only tickets created between' => 'この期間に作成されたチケットのみ',
        'Ticket Archive System' => 'チケット・アーカイブシステム',
        'Save Search as Template?' => 'テンプレートとして検索を保存しますか？',
        'Save as Template?' => 'テンプレートを保存しますか？',
        'Save as Template' => 'テンプレートとして保存',
        'Template Name' => 'テンプレート名',
        'Pick a profile name' => 'テンプレート名',
        'Output to' => '出力: ',

        # Template: CustomerTicketSearchResultShort
        'of' => '/',
        'Search Results for' => '検索結果: ',
        'Remove this Search Term.' => 'この検索語を削除して下さい。',

        # Template: CustomerTicketZoom
        'Reply' => '返信',
        'Discard' => '',
        'Ticket Information' => 'チケット情報',
        'Categories' => '',

        # Template: Chat
        'Expand article' => '記事を展開',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => '警告',

        # Template: Tile_NewTicket
        'Issue<br/>a ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'イベント情報',
        'Ticket fields' => 'チケット・フィールド',

        # Template: Error
        'Send a bugreport' => 'バグ報告を送信',
        'Expand' => '展開',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => '下書きを更新',
        'Save as new draft' => '新しい下書きとして保存',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '下書き"%s"を読み込んでいます。',
        'You have loaded the draft "%s". You last changed it %s.' => '下書き"%s"を読み込んでいます。 あなたは最後に%sを変更しました。',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'ドラフト"%s"を読み込んでいます。 %sによって%sが最後に変更されました。',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'このドラフトは、このドラフトが作成されてから改訂されたため、古くなっています。',

        # Template: Header
        'Edit personal preferences' => '個人設定の編集',
        'Personal preferences' => '個人設定',
        'You are logged in as' => 'ログイン中: ',

        # Template: Installer
        'JavaScript not available' => 'JavaScriptが利用できません。',
        'Step %s' => 'ステップ %s',
        'License' => 'ライセンス',
        'Database Settings' => 'データベース設定',
        'General Specifications and Mail Settings' => '共通仕様とメール設定',
        'Finish' => '完了',
        'Welcome to %s' => '%s にようこそ',
        'Germany' => '',
        'Phone' => '電話',
        'Switzerland' => '',
        'Web site' => 'Webサイト',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '送信メール設定',
        'Outbound mail type' => '送信メールタイプ',
        'Select outbound mail type.' => '送信メールタイプを選択',
        'Outbound mail port' => '送信メールポート',
        'Select outbound mail port.' => '送信メールポートを選択',
        'SMTP host' => 'SMTPホスト',
        'SMTP host.' => 'SMTPホスト名',
        'SMTP authentication' => 'SMTP認証',
        'Does your SMTP host need authentication?' => 'SMTP認証の必要はありますか？',
        'SMTP auth user' => 'SMTP認証ユーザー',
        'Username for SMTP auth.' => 'SMTP認証で使用するユーザー名',
        'SMTP auth password' => 'SMTP認証パスワード',
        'Password for SMTP auth.' => 'SMTP認証で使用するパスワード',
        'Configure Inbound Mail' => '受信メール設定',
        'Inbound mail type' => '受信メールタイプ',
        'Select inbound mail type.' => '受信メールタイプを選択',
        'Inbound mail host' => '受信メールホスト',
        'Inbound mail host.' => '受信メールホスト名',
        'Inbound mail user' => '受信メールユーザー',
        'User for inbound mail.' => 'メールを受信するユーザー',
        'Inbound mail password' => '受信メールパスワード',
        'Password for inbound mail.' => '受信メールのパスワード',
        'Result of mail configuration check' => 'メール設定チェックの結果',
        'Check mail configuration' => 'メール設定チェック',
        'Skip this step' => 'この手順を飛ばす',

        # Template: InstallerDBResult
        'Done' => '完了',
        'Error' => 'エラー',
        'Database setup successful!' => 'データベース　設定成功',

        # Template: InstallerDBStart
        'Install Type' => 'インストールタイプ',
        'Create a new database for OTOBO' => '新規にOTOBOデータベースを作成する',
        'Use an existing database for OTOBO' => '既存のOTOBOデータベースを使用する',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'データベースのrootパスワードを設定した場合、この領域を入力しなければなりません。そうでない場合は、この領域を空のままにしてください。',
        'Database name' => 'データベース名',
        'Check database settings' => 'データベース設定をチェック',
        'Result of database check' => 'データベースチェックの結果',
        'Database check successful.' => 'データベースチェックに成功しました。',
        'Database User' => 'データベース・ユーザー',
        'New' => '新規',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'このOTOBOシステム用に限られた権限の新規データベースユーザーが作成されます。',
        'Repeat Password' => 'パスワードを再度入力',
        'Generated password' => 'パスワードを生成しました。',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'パスワードが一致しません',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTOBOを使用するには、rootでコマンドライン上 (ターミナル／シェル) から次の行を入力する必要があります。',
        'Restart your webserver' => 'Webサーバを再起動してください。',
        'After doing so your OTOBO is up and running.' => 'その後、OTOBOの起動を実行してください。',
        'Start page' => 'スタートページ',
        'Your OTOBO Team' => 'Your OTOBO Team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'ライセンスに同意しない',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => 'システムID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'システムの識別子。各チケット番号とHTTPセッションIDはこの番号が含まれます。',
        'System FQDN' => 'システムのFQDN',
        'Fully qualified domain name of your system.' => 'システムのFQDN',
        'AdminEmail' => '管理者メール',
        'Email address of the system administrator.' => 'システム管理者のメールアドレス',
        'Organization' => '組織',
        'Log' => 'ログ',
        'LogModule' => 'ログモジュール',
        'Log backend to use.' => 'ログバックエンドを使用するには',
        'LogFile' => 'ログファイル',
        'Webfrontend' => 'Webフロントエンド',
        'Default language' => '既定の言語',
        'Default language.' => '既定の言語。',
        'CheckMXRecord' => 'MXレコードのチェック',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '入力されたメールアドレスがDNSのMXレコードと照合されます。利用しているDNSが遅い場合、または公開アドレスが解決できない場合はこのオプションを使用しないでください。',

        # Template: LinkObject
        'Delete link' => 'リンクを削除',
        'Delete Link' => 'リンクを削除',
        'Object#' => '対象の番号',
        'Add links' => 'リンクを追加',
        'Delete links' => 'リンクを削除',

        # Template: Login
        'Lost your password?' => 'パスワードを忘れた方',
        'Back to login' => 'ログイン画面に戻る',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => 'プレビューを閉じる',
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
        'Message of the Day' => '今日のメッセージ',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => '権限がありません',
        'Back to the previous page' => '前のページに戻る。',

        # Template: Alert
        'Alert' => 'アラート',
        'Powered by' => 'Powered by',

        # Template: Pagination
        'Show first page' => '最初のページを表示',
        'Show previous pages' => '前のページを表示',
        'Show page %s' => '%s ページを表示',
        'Show next pages' => '次のページを表示',
        'Show last page' => '最後のページを表示',

        # Template: PictureUpload
        'Need FormID!' => 'フォームIDの入力が必要です！',
        'No file found!' => 'ファイルがありません！',
        'The file is not an image that can be shown inline!' => '',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '\'%s\' の通知メッセージを、転送方法 \'%s\' で受信します。',

        # Template: ActivityDialogHeader
        'Process Information' => 'プロセス情報',
        'Dialog' => 'ダイアログ',

        # Template: Article
        'Inform Agent' => '担当者に知らせる',

        # Template: PublicDefault
        'Welcome' => 'ようこそ',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '権限',
        'You can select one or more groups to define access for different agents.' =>
            '担当者ごとに、複数のグループを同時選択することもできます。',
        'Result formats' => '出力フォーマット',
        'Time Zone' => 'タイムゾーン（時間帯）',
        'The selected time periods in the statistic are time zone neutral.' =>
            'レポートの中で選択された期間は、時間帯にナチュラルです。',
        'Create summation row' => '合計行を追加',
        'Generate an additional row containing sums for all data rows.' =>
            '全てのデータ行の合計を含む追加の行を生成します。',
        'Create summation column' => '合計列を追加',
        'Generate an additional column containing sums for all data columns.' =>
            '全てのデータ列の合計を含む追加の列を生成します。',
        'Cache results' => 'キャッシュ結果',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'レポート結果データをキャッシュに保存して、同じ設定で後続のビューで使用するようにしました（少なくとも1つの選択された時間フィールドが必要です）。',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '担当者が自らのダッシュボードでアクティブにできるウィジェットとして統計を利用できます。',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'ダッシュボードウィジェットを有効にすると、ダッシュボードでこの統計のキャッシュが有効化されます。',
        'If set to invalid end users can not generate the stat.' => '無効なエンドユーザーに設定されている場合、統計を生成できません。',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'このレポート情報の設定には問題があります。',
        'You may now configure the X-axis of your statistic.' => 'レポートのX軸を設定できます。',
        'This statistic does not provide preview data.' => 'このレポートはプレビューデータを提供しません。',
        'Preview format' => 'プレビュー形式',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'プレビュー画面ではランダムデータを利用しており、またデータ・フィルタを考慮していませんので、ご留意願います。',
        'Configure X-Axis' => 'X軸の設定',
        'X-axis' => 'X軸',
        'Configure Y-Axis' => 'Y軸の設定',
        'Y-axis' => 'Y軸',
        'Configure Filter' => 'フィルタの設定',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '選択する項目を1つのみにするか、「固定値」をオフにしてください。',
        'Absolute period' => '絶対値',
        'Between %s and %s' => '%sと%sの間',
        'Relative period' => '相対値',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            'レポートが生成されたときにこの要素に変更を許可しないで下さい。',

        # Template: StatsParamsWidget
        'Format' => '書式',
        'Exchange Axis' => '縦横軸の交換',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => '要素が選択されていません。',
        'Scale' => '目盛',
        'show more' => 'もっと見せる',
        'show less' => 'あまり見せない',

        # Template: D3
        'Download SVG' => 'SVG画像のダウンロード',
        'Download PNG' => 'PNG画像のダウンロード',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '選択した期間は、このレポートがデータを収集するためのデフォルトの時間枠を定義します。',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Y軸の目盛はX軸の目盛より大きくする必要があります (例: X軸=>月、Y軸=>年)',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'この設定は無効です。',
        'This setting is fixed but not deployed yet!' => 'この設定は確定しましたが、まだデプロイされていません！',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => 'この設定の詳細オプションを切り替えます。',
        'Disable this setting, so it is no longer effective' => 'この設定を無効にすると無効になります。',
        'Disable' => '無効',
        'Enable this setting, so it becomes effective' => 'この設定を有効にすると有効になります',
        'Enable' => '有効',
        'Reset this setting to its default state' => 'この設定をデフォルトのステータスにリセットする',
        'Reset setting' => 'リセット設定',
        'Allow users to adapt this setting from within their personal preferences' =>
            'ユーザーが個人設定内からこの設定を変更できるようにする。',
        'Allow users to update' => 'ユーザーに更新を許可する',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'ユーザーが個人設定からこの設定を変更するのを許可しないようにする。',
        'Forbid users to update' => 'ユーザーの更新を禁止する',
        'Show user specific changes for this setting' => 'この設定のユーザー固有の変更を表示する',
        'Show user settings' => 'ユーザー設定を表示する',
        'Copy a direct link to this setting to your clipboard' => 'この設定への直接リンクをクリップボードにコピーする',
        'Copy direct link' => 'ダイレクトリンクをコピーする',
        'Remove this setting from your favorites setting' => 'この設定をお気に入り設定から削除',
        'Remove from favourites' => 'お気に入りから削除',
        'Add this setting to your favorites' => 'お気に入りにこの設定を追加',
        'Add to favourites' => 'お気に入りに追加',
        'Cancel editing this setting' => 'この設定の編集をキャンセルする',
        'Save changes on this setting' => 'この設定の変更を保存する',
        'Edit this setting' => 'この設定を編集',
        'Enable this setting' => 'この設定を有効にする',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'このグループには設定が含まれていません。 サブグループの1つまたは別のグループに移動してみて下さい。',

        # Template: SettingsListCompare
        'Now' => '今',
        'User modification' => 'ユーザーの更新',
        'enabled' => '有効',
        'disabled' => '無効',
        'Setting state' => 'ステータスを設定します',

        # Template: Actions
        'Edit search' => '検索を修正',
        'Go back to admin: ' => '管理に戻る：',
        'Deployment' => 'デプロイ',
        'My favourite settings' => '私のお気に入りの設定',
        'Invalid settings' => '無効な設定',

        # Template: DynamicActions
        'Filter visible settings...' => '表示フィルタリングの設定をしています...',
        'Enable edit mode for all settings' => '全ての設定に対して編集モードを有効にする',
        'Save all edited settings' => '編集した全ての設定を保存する',
        'Cancel editing for all settings' => '全ての設定の編集をキャンセルする',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'このウィジェットからのすべてのアクションは、右の表示される設定にのみ適用されます。',

        # Template: Help
        'Currently edited by me.' => '現在私によって編集されています。',
        'Modified but not yet deployed.' => '変更されましたが、まだデプロイされていません。',
        'Currently edited by another user.' => '現在、別のユーザーが編集しています。',
        'Different from its default value.' => 'デフォルト値とは異なります。',
        'Save current setting.' => '現在の設定を保存します。',
        'Cancel editing current setting.' => '現在の設定の編集をキャンセルします。',

        # Template: Navigation
        'Navigation' => 'ナビゲーション',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO テストページ',
        'Unlock' => 'ロック解除',
        'Welcome %s %s' => 'ようこそ %s %s',
        'Counter' => 'カウンター',

        # Template: Warning
        'Go back to the previous page' => '前のページへ戻る',

        # JS Template: CalendarSettingsDialog
        'Show' => '表示',

        # JS Template: FormDraftAddDialog
        'Draft title' => '下書きタイトル',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '記事の表示',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '本当に"%s"を削除しますか？',
        'Confirm' => '確認',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '読み込み中です。お待ち下さい...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => 'クリックしてファイルを選択するか、ここにドロップして下さい。',
        'Click to select a file or just drop it here.' => 'クリックしてファイルを選択するか、ここにドロップします。',
        'Uploading...' => 'アップロード中...',

        # JS Template: MigrationState
        'Time needed' => '',

        # JS Template: PackageResolve
        'Package' => '',
        'Uninstall from OTOBO' => '',
        'Ignore' => '',
        'Migrate' => '',

        # JS Template: InformationDialog
        'Process state' => 'プロセス・ステータス',
        'Running' => '実行中',
        'Finished' => '終了しました',
        'No package information available.' => '利用可能なパッケージ情報はありません。',

        # JS Template: AddButton
        'Add new entry' => '新しい登録を追加',

        # JS Template: AddHashKey
        'Add key' => '鍵を追加',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'デプロイ・コメント...',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => 'デプロイしています。暫くお待ち下さい...',
        'Preparing to deploy, please wait...' => 'デプロイ中です。お待ち下さい...',
        'Deploy now' => '今すぐデプロイ',
        'Try again' => '再試行する',

        # JS Template: DialogReset
        'Reset options' => 'リセットオプション',
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
        'Database Backend' => 'データベース・バックエンド',
        'CustomerIDs' => '顧客ID',
        'Fax' => 'Fax',
        'Street' => '建物名',
        'Zip' => '郵便番号',
        'City' => '住所',
        'Country' => '国',
        'Mr.' => '様',
        'Mrs.' => '様',
        'Address' => 'アドレス',
        'View system log messages.' => 'システム・ログ・メッセージを見る。',
        'Edit the system configuration settings.' => 'システム設定の編集',
        'Update and extend your system with software packages.' => 'このシステムのソフトウェアパッケージの更新と展開',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'データベースから取得したACLの情報はシステム設定と同期していません。全てのACLをデプロイしてください。',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '次のACLは、無事に追加されました。: %s',
        'The following ACLs have been updated successfully: %s' => '次のACLは、無事に更新されました。: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '次のACLを追加/更新するときにエラーが発生しました。: %s
詳細は、ログファイルを参照してください。',
        'There was an error creating the ACL' => 'ACLデータの作成時にエラーが発生しました。',
        'Need ACLID!' => 'ACL IDの入力が必要です！',
        'Could not get data for ACLID %s' => 'ACL ID %s の値を取得できませんでした',
        'There was an error updating the ACL' => 'ACLの更新時にエラーが発生しました。',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => 'ACL間の同期処理中にエラーが発生しました。',
        'ACL %s could not be deleted' => 'ACL %s は削除できません',
        'There was an error getting data for ACL with ID %s' => '',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'スーパーユーザー・アカウント（UserID 1）ではACLの制限が無視されることに注意して下さい。',
        'Exact match' => '完全一致',
        'Negated exact match' => '完全に否定一致',
        'Regular expression' => '正規表現',
        'Regular expression (ignore case)' => '正規表現 (大文字・小文字を無視する)',
        'Negated regular expression' => '否定正規表現',
        'Negated regular expression (ignore case)' => '否定された正規表現（大文字と小文字を区別しない）',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'システムがカレンダーを作成できませんでした！',
        'Please contact the administrator.' => '管理者に連絡してください。',
        'No CalendarID!' => 'CalendarIDがない!',
        'You have no access to this calendar!' => 'あなたはこのカレンダーにアクセスできません！',
        'Error updating the calendar!' => 'カレンダーの更新中にエラーが発生しました!',
        'Couldn\'t read calendar configuration file.' => 'カレンダー設定ファイルを読み込めませんでした。',
        'Please make sure your file is valid.' => 'あなたのファイルが有効であることを確認して下さい。',
        'Could not import the calendar!' => 'カレンダーをインポートできませんでした!',
        'Calendar imported!' => 'カレンダーをインポート!',
        'Need CalendarID!' => 'CalendarIDが必要!',
        'Could not retrieve data for given CalendarID' => '指定されたCalendarIDのデータを取得できませんでした。',
        'Successfully imported %s appointment(s) to calendar %s.' => '%sの予定をカレンダー%sに正常にインポートしました。',
        '+5 minutes' => '+5分',
        '+15 minutes' => '+15分',
        '+30 minutes' => '+30分',
        '+1 hour' => '+1時間',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '権限がない!',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '',
        'Notification added!' => '通知が追加されました！',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => '',
        '%s (copy)' => '',
        'There was an error creating the Notification' => '',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '次の通知が正常に追加されました：%s',
        'The following Notifications have been updated successfully: %s' =>
            '次の通知が正常に更新されました：%s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => '',
        'Agent (resources), who are selected within the appointment' => '予定内で選択された担当者（リソース）',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '添付ファイルを追加しました。',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '自動応答が追加されました！',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => '全てのコミュニケーション',
        'Last 1 hour' => '過去1時間',
        'Last 3 hours' => '過去3時間',
        'Last 6 hours' => '過去6時間',
        'Last 12 hours' => '過去12時間',
        'Last 24 hours' => '過去24時間',
        'Last week' => '先週',
        'Last month' => '先月',
        'Invalid StartTime: %s!' => '',
        'Successful' => '成功',
        'Processing' => '処理中',
        'Failed' => '失敗',
        'Invalid Filter: %s!' => 'フィルターが不正です: %s',
        'Less than a second' => '1秒未満',
        'sorted descending' => '降順に並べ替え',
        'sorted ascending' => '昇順に並べ替え',
        'Trace' => 'トレース',
        'Debug' => 'Debug',
        'Info' => '情報',
        'Warn' => '警告',
        'days' => '日',
        'day' => '日',
        'hour' => '時間',
        'minute' => '分',
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
        'Customer company updated!' => '顧客企業を更新しました。',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '顧客企業 %s は、既に存在します！',
        'Customer company added!' => '顧客企業を追加しました。',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '顧客を更新しました。',
        'New phone ticket' => '新規電話チケットの作成',
        'New email ticket' => '新規メールチケットの作成',
        'Customer %s added' => '顧客 %s を追加しました',
        'Customer user updated!' => '顧客ユーザーが更新されました！',
        'Same Customer' => '同じ顧客',
        'Direct' => '直接',
        'Indirect' => '間接',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '顧客ユーザーをサービスに割り当てる',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'ダイナミック・フィールドのオーダー定義を初期化できませんでした。詳細はエラーログを参照願います。',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '未定義のサブアクションです。',
        'Need %s' => '%s の入力が必要です。',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => 'ValidIDが必要です',
        'Could not create the new field' => '新しいフィールドを作成できませんでした。',
        'Need ID' => 'IDが必要',
        'Could not get data for dynamic field %s' => 'ダイナミック・フィールド %s の値を取得できませんでした',
        'Change %s field' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '現在の',
        'Unchecked' => '未選択',
        'Checked' => '選択済み',

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
        'Setting is locked by another user!' => '設定は他のユーザーによってロックされています！',
        'System was not able to reset the setting!' => 'システムが設定をリセットできませんでした！',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => '分',
        'hour(s)' => '時間',
        'Time unit' => '時間の単位',
        'within the last ...' => '以内(前)',
        'within the next ...' => '以内(後)',
        'more than ... ago' => '... 以前',
        'Unarchived tickets' => 'アーカイブされていないチケット',
        'archive tickets' => 'アーカイブ・チケット',
        'restore tickets from archive' => 'アーカイブからチケットを復元する',
        'Need Profile!' => 'プロファイルの入力が必要です！',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebサービスIDの入力が必要です！',
        'Could not get data for WebserviceID %s' => 'WebサービスID %s の値を取得できませんでした',
        'ascending' => '昇順',
        'descending' => '降順',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'コミュニケーション・タイプが必要です！',
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
        'Invoker deleted' => 'API実行元を削除',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0秒',
        '15 seconds' => '15秒',
        '30 seconds' => '30秒',
        '45 seconds' => '45秒',
        '1 minute' => '1分',
        '2 minutes' => '2分',
        '3 minutes' => '3分',
        '4 minutes' => '4分',
        '5 minutes' => '5分',
        '10 minutes' => '10 分',
        '15 minutes' => '15 分',
        '30 minutes' => '30分',
        '1 hour' => '1時間',
        '2 hours' => '2時間',
        '3 hours' => '3時間',
        '4 hours' => '4時間',
        '5 hours' => '5時間',
        '6 hours' => '6時間',
        '12 hours' => '12時間',
        '18 hours' => '18時間',
        '1 day' => '1日',
        '2 days' => '2日',
        '3 days' => '3日',
        '4 days' => '4日',
        '6 days' => '6日',
        '1 week' => '1週',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'API実行元%sの設定を判別できませんでした。',
        'InvokerType %s is not registered' => 'API実行元%sは登録されていません。',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'API実行元が必要です!',
        'Need Event!' => 'イベントが必要！',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => '文字列',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
        'Keep (leave unchanged)' => '保持 (変更せずに終了する)',
        'Ignore (drop key/value pair)' => '無視 (キー/値のペアを破棄する)',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '必要なライブラリ%sを見つけることができませんでした。',
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
        'Need valid Subaction!' => '有効なサブアクションが必要です!',
        'This field should be an integer.' => 'この領域は整数である必要があります。',
        'File or Directory not found.' => 'ファイルまたはディレクトリがみつかりません。',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '同名の別のWebサービスがあります。',
        'There was an error updating the web service.' => 'Webサービスの更新時にエラーが発生しました。',
        'There was an error creating the web service.' => 'Webサービスの作成時にエラーが発生しました。',
        'Web service "%s" created!' => 'Webサービス "%s" を作成しました。',
        'Need Name!' => '名前の入力が必要です！',
        'Need ExampleWebService!' => 'ExampleWebServiceが必要です！',
        'Could not load %s.' => '',
        'Could not read %s!' => '%s を読み込めません！',
        'Need a file to import!' => 'インポートするファイルを指定してください！',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            '',
        'Web service "%s" deleted!' => 'Webサービス "%s" を削除しました。',
        'OTOBO as provider' => 'プロバイダーとしてのOTOBO',
        'Operations' => 'オペレーション',
        'OTOBO as requester' => 'リクエスターとしてのOTOBO',
        'Invokers' => 'API実行元',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'グループを更新しました。',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'メールアカウントを追加しました。',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'メールの宛先で振り分け',
        'Dispatching by selected Queue.' => '選択したキューで振り分け',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'チケットを作成した担当者',
        'Agent who owns the ticket' => 'チケットを保有する担当者',
        'Agent who is responsible for the ticket' => 'チケットの責任者',
        'All agents watching the ticket' => 'チケットを監視しているすべての担当者',
        'All agents with write permission for the ticket' => 'チケット編集可能権限を持つすべての担当者',
        'All agents subscribed to the ticket\'s queue' => 'チケットのキューを購読しているすべての担当者',
        'All agents subscribed to the ticket\'s service' => 'チケットのサービスを購読しているすべての担当者',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'チケットのキュー及びサービスを購読しているすべての担当者',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '最初の記事の全ての受信者',
        'All recipients of the last article' => '最後の記事の全ての受信者',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP 機構が動作していません。詳しくはログをご覧ください！',
        'Need param Key to delete!' => '削除するには、キーを入力する必要があります！',
        'Key %s deleted!' => 'キー %s を削除しました。',
        'Need param Key to download!' => 'ダウンロードを行うには、キーを入力する必要があります！',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            '',
        'No such package!' => 'そのようなパッケージはありません！',
        'No such file %s in package!' => 'パッケージ内にファイル %s はありません！',
        'No such file %s in local file system!' => 'ローカルファイルシステム内にファイル %s はありません！',
        'Can\'t read %s!' => '%s を読み込めません！',
        'File is OK' => 'ファイルは正常です',
        'Package has locally modified files.' => 'パッケージにはローカルに変更されたファイルがあります。',
        'Package not verified by the OTOBO Team! It is recommended not to use this package.' =>
            'パッケージはOTRSグループによって検証されていません。このパッケージの利用を推奨しません。',
        'Not Started' => '始まっていない',
        'Updated' => '更新しました',
        'Already up-to-date' => 'すでに最新版です。',
        'Installed' => 'インストールしました',
        'Not correctly deployed' => '正しくデプロイされませんでした',
        'Package updated correctly' => 'パッケージの更新は正常に終了しました。',
        'Package was already updated' => 'パッケージはすでに更新済みです。',
        'Dependency installed correctly' => '依存するモジュールは正常にインストールされました。',
        'The package needs to be reinstalled' => 'パッケージを再インストールする必要があります',
        'The package contains cyclic dependencies' => 'このパッケージとの依存関係が循環状態にあります。',
        'Not found in on-line repositories' => 'オンライン・リポジトリからは見つかりませんでした。',
        'Required version is higher than available' => '現在お使いのものより新しいバージョンが必要です。',
        'Dependencies fail to upgrade or install' => '依存関係解消のためのインストールまたは更新に失敗しました。',
        'Package could not be installed' => 'パッケージをインストールできませんでした',
        'Package could not be upgraded' => 'パッケージを更新できませんでした',
        'Repository List' => 'リポジトリ・リスト',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'OTOBOアドオンリストサーバーに接続できませんでした！',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'OTOBO アドオンリストをサーバーから取得できませんでした！',
        'Can\'t get OTOBO Feature Add-on from server!' => 'OTOBO アドオンをサーバーから取得できませんでした！',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'そのようなフィルターはありません: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '優先度を追加しました。',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'データベースから取得したプロセス管理情報はシステム設定と同期していません。全てのプロセスを同期させてください。',
        'Need ExampleProcesses!' => 'プロセス例が必要!',
        'Need ProcessID!' => 'ProcessIDが必要!',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '非アクティブなステータスのStateEntityIDは存在しません',
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
        'Could not get %s' => '%sの値が取得できません!',
        'Need %s!' => '%s の入力が必要です!',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => 'ActivityIDが必要!',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => 'Activityが見つかりません!',
        'ActivityDialog not found!' => 'ActivityDialogが見つかりません!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => 'このサブアクションは有効ではありません',
        'Edit Activity "%s"' => 'アクティビティ "%s" を編集',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => 'アクティビティ・ダイアログを作成する際にエラーが発生しました',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => 'アクティビティ・ダイアログIDが必要です！',
        'Could not get data for ActivityDialogID %s' => 'アクティビティ・ダイアログID %s の値を取得できませんでした',
        'There was an error updating the ActivityDialog' => 'アクティビティ・ダイアログの更新時にエラーが発生しました。',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '担当者インターフェース',
        'Customer Interface' => '顧客インターフェース',
        'Agent and Customer Interface' => '担当者と顧客のインターフェース',
        'Do not show Field' => 'フィールドを表示しない',
        'Show Field' => 'フィールドを表示する',
        'Show Field As Mandatory' => 'フィールドを必須として表示する',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'パスを修正',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'この遷移にエンティティIDを割り当てる際にエラーが発生しました。',
        'There was an error creating the Transition' => '遷移の作成時にエラーが発生しました。',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '遷移IDの入力が必要です！',
        'Could not get data for TransitionID %s' => '遷移ID %s の値を取得できませんでした',
        'There was an error updating the Transition' => '遷移の更新時にエラーが発生しました。',
        'Edit Transition "%s"' => '遷移 "%s" を編集する',
        'Transition validation module' => '遷移有効化モジュール',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'この遷移動作にエンティティID割り当てる際にエラーが発生しました',
        'There was an error creating the TransitionAction' => '遷移動作の作成時にエラーが発生しました。',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '遷移動作IDを入力してください！',
        'Could not get data for TransitionActionID %s' => '遷移アクションID %s の値を取得できませんでした',
        'There was an error updating the TransitionAction' => '遷移動作の更新時にエラーが発生しました。',
        'Edit Transition Action "%s"' => '遷移動作 "%s" の編集',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'キューを更新しました。',
        'Don\'t use :: in queue name!' => 'キューの名称に"::"を使わないでください！',
        'Click back and change it!' => 'クリックして変更してください！',
        '-none-' => '-なし-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '自動応答が設定されていないキュー',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'テンプレートに対するキューの関連性を変更',
        'Change Template Relations for Queue' => 'キューに対するテンプレートの関連性を変更',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '生産',
        'Test' => 'テスト',
        'Training' => 'トレーニング',
        'Development' => 'デプロイ',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'ロールを更新しました。',
        'Role added!' => 'ロールを追加しました。',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'ロールに対するグループの関連性を変更',
        'Change Role Relations for Group' => 'グループに対するロールの関連性を変更',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'ロール',
        'Change Role Relations for Agent' => '担当者に対するロールの関連性を変更',
        'Change Agent Relations for Role' => 'ロールに対する担当者の関連性を変更',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '最初に %s を有効にしてください。',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME環境は動作していません。ログを確認して下さい！',
        'Need param Filename to delete!' => '削除するにはパラメータとしてファイル名が必要です！',
        'Need param Filename to download!' => 'ダウンロードするにはパラメータとしてファイル名が必要です！',
        'Needed CertFingerprint and CAFingerprint!' => '認証局のフィンガープリントとCA局のフィンガープリントが必要です！',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '関係が存在します！',
        'Relation added!' => '関係が追加されました！',
        'Impossible to add relation!' => '関係を追加することはできません！',
        'Relation doesn\'t exists' => '関係は存在しません',
        'Relation deleted!' => '関係が削除されました！',
        'Impossible to delete relation!' => '関係を削除することはできません！',
        'Certificate %s could not be read!' => '証明書 %s を読み込めませんでした！',
        'Needed Fingerprint' => 'フィンガープリントが必要です',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '挨拶文を追加しました！',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '署名を更新しました。',
        'Signature added!' => '署名を追加しました。',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'ステータスを追加しました。',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'ファイル %s を読み込めませんでした！',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'システムメールアドレスを追加しました。',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '無効な設定',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'インポートは許可されていません!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            '',
        'Category Search' => 'カテゴリ検索',

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
        'Missing setting name!' => '設定名がありません！',
        'Missing ResetOptions!' => 'リセット・オプションが不足しています！',
        'System was not able to lock the setting!' => 'システムは設定をロックできませんでした！',
        'System was unable to update setting!' => 'システムが設定を更新できませんでした！',
        'Missing setting name.' => '設定名がありません。',
        'Setting not found.' => '設定が見つかりません。',
        'Missing Settings!' => '設定がありません！',

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
        'Start date shouldn\'t be defined after Stop date!' => '停止日の後に開始日を定義しないで下さい！',
        'There was an error creating the System Maintenance' => 'システムメンテナンスを作成する際にエラーが発生しました',
        'Need SystemMaintenanceID!' => 'システムメンテナンスIDが必要です',
        'Could not get data for SystemMaintenanceID %s' => 'システムメンテナンスID  %sから日付を取得できませんでした',
        'System Maintenance was added successfully!' => 'システムメンテナンスが正常に追加されました！',
        'System Maintenance was updated successfully!' => 'システムメンテナンスが正常に更新されました！',
        'Session has been killed!' => 'セッションは削除されました！',
        'All sessions have been killed, except for your own.' => '貴方自身のセッション以外のセッションは切断されました。',
        'There was an error updating the System Maintenance' => 'システムメンテナンス更新時にエラーが発生しました',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'システムメンテナンス %sは削除できませんでした！',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'テンプレートを更新しました！',
        'Template added!' => 'テンプレートを追加しました！',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'テンプレートに対する添付ファイルの関連性を変更',
        'Change Template Relations for Attachment' => '添付ファイルに対するテンプレートの関連性を変更',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'タイプが必要です！',
        'Type added!' => 'タイプを追加しました。',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '担当者が更新されました。',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => '担当者に対するグループの関連性を変更',
        'Change Agent Relations for Group' => 'グループに対する担当者の関連性を変更',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => '月',
        'Week' => '週',
        'Day' => '日',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '全ての予約',
        'Appointments assigned to me' => '私に割り当てられた予定',
        'Showing only appointments assigned to you! Change settings' => 'あなたに割り当てられた予約だけを表示する！ 設定を変更して下さい。',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '予約が見つかりません！',
        'Never' => 'なし',
        'Every Day' => '毎日',
        'Every Week' => '毎週',
        'Every Month' => '毎月',
        'Every Year' => '毎年',
        'Custom' => 'カスタム',
        'Daily' => '毎日',
        'Weekly' => '毎週',
        'Monthly' => '毎月',
        'Yearly' => '毎年',
        'every' => '全て',
        'for %s time(s)' => 'for %s time(s)',
        'until ...' => '〜まで',
        'for ... time(s)' => 'for ... time(s)',
        'until %s' => '%s まで',
        'No notification' => '通知なし',
        '%s minute(s) before' => '%s 分前',
        '%s hour(s) before' => '%s 時間前',
        '%s day(s) before' => '%s 日前',
        '%s week before' => '%s 週間前',
        'before the appointment starts' => '予定の開始前',
        'after the appointment has been started' => '予定の開始後',
        'before the appointment ends' => '予定の終了前',
        'after the appointment has been ended' => '予定の終了後',
        'No permission!' => '権限がない!',
        'Cannot delete ticket appointment!' => 'チケット予約を削除できません！',
        'No permissions!' => '権限がない!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => '顧客履歴',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '設定項目 %s は存在しません',
        'Statistic' => 'レポート',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => '顧客名',
        'Customer User Name' => '顧客ユーザー名',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'ソース・オブジェクトとソース・キーが必要です！',
        'You need ro permission!' => 'ro許可が必要です！',
        'Can not delete link with %s!' => '%sに対するリンクが削除できませんでした！',
        '%s Link(s) deleted successfully.' => '%sリンク(複数)が正常に削除されました。',
        'Can not create link with %s! Object already linked as %s.' => 'オブジェクト%sに対するリンクを作成できませんでした！ %sに対するリンクが既に存在します。',
        'Can not create link with %s!' => '%sに対するリンクが作成できませんでした！',
        '%s links added successfully.' => '%sリンクが正常に追加されました。',
        'The object %s cannot link with other object!' => 'オブジェクト%sは他のオブジェクトにリンクできません！',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'パラメータ Groupが必要です！',
        'This feature is not available.' => '',
        'Updated user preferences' => 'ユーザー設定を更新しました',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '設定が見つかりません！',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'プロセスチケット',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'パラメータ %sが存在しません。',
        'Invalid Subaction.' => '不正なサブアクションです。',
        'Statistic could not be imported.' => 'レポートをインポートできませんでした。',
        'Please upload a valid statistic file.' => '有効なレポート・ファイルをアップロードして下さい。',
        'Export: Need StatID!' => 'エクスポート: StatIDが必要です！',
        'Delete: Get no StatID!' => '削除: StatIDが存在しません！',
        'Need StatID!' => 'StatIDが必要です！',
        'Could not load stat.' => '統計を読み込めませんでした。',
        'Add New Statistic' => '新しいレポートを追加',
        'Could not create statistic.' => 'レポートを作成できませんでした。',
        'Run: Get no %s!' => '実行: %sが存在しません！',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'TicketIDが存在しません！',
        'You need %s permissions!' => '許可 %sが必要です！',
        'Loading draft failed!' => '下書きのロードに失敗しました！',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'この操作を行うには担当者または責任者になる必要があります。',
        'Please change the owner first.' => '最初に担当者を変更してください。',
        'FormDraft functionality disabled!' => 'Form下書き機能が無効になっています！',
        'Draft name is required!' => '下書き名は必須です！',
        'FormDraft name %s is already in use!' => 'FormDraft名%sは既に使用中です！',
        'Could not perform validation on field %s!' => '',
        'No subject' => '件名なし',
        'Could not delete draft!' => '下書きを削除できませんでした。',
        'Previous Owner' => '以前の所有者',
        'wrote' => 'wrote',
        'Message from' => 'Message from',
        'End message' => 'End message',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%sが必要です！',
        'Plain article not found for article %s!' => '%sの記事では一般的な記事が見つかりません！',
        'Article does not belong to ticket %s!' => '記事はチケット%sに属していません！',
        'Can\'t bounce email!' => 'メールをバウンスできません！',
        'Can\'t send email!' => 'メールを送信できません！',
        'Wrong Subaction!' => '不正なサブアクションです！',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'チケットIDが存在しないため、チケットをロックできませんでした！',
        'Ticket (%s) is not unlocked!' => 'チケット(%s)はアンロックされていません！',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '少なくとも1件のチケットを選択する必要があります。',
        'Bulk feature is not enabled!' => '一括機能が有効になっていません！',
        'No selectable TicketID is given!' => '選択可能なチケットIDが存在しません！',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'チケットを選択していないか、他の担当者によってロックされているチケットしか選択していません。',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'アドレス %s は登録された顧客のアドレスに置換されました。',
        'Customer user automatically added in Cc.' => '顧客ユーザーが自動的にCcに追加されました。',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'チケット "%s" を作成しました。',
        'No Subaction!' => 'サブアクションが存在しません！',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'チケットIDが取得できませんでした！',
        'System Error!' => 'システム・エラー！',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'ArticleIDは指定されていません！',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '翌週',
        'Ticket Escalation View' => 'チケット・エスカレーション・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '記事%sが見つかりませんでした！',
        'Forwarded message from' => 'Forwarded message from',
        'End forwarded message' => 'End forwarded message',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'チケットIDが与えられていないため、履歴を表示できませんでした',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'チケットIDが与えられていないため、ロックできませんでした',
        'Sorry, the current owner is %s!' => '現在の所有者は%sです！',
        'Please become the owner first.' => '先に所有者となる必要があります。',
        'Ticket (ID=%s) is locked by %s!' => 'チケット(ID=%s)は%sによってロックされています！',
        'Change the owner!' => '所有者の変更！',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => '新しい記事',
        'Pending' => '保留中',
        'Reminder Reached' => '保留期限切れ',
        'My Locked Tickets' => '担当のロック済チケット',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'チケットは自分自身に対して結合することはできません！',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'move許可が必要です！',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'チャットはアクティブではありません。',
        'No permission.' => '権限がありません！',
        '%s has left the chat.' => '%s はチャットから退出しました。',
        'This chat has been closed and will be removed in %s hours.' => 'このチャットは既にクローズしています。%s 時間後に削除されます。',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'チケットがロックされました。',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '記事IDが存在しません！',
        'This is not an email article.' => 'これは電子メールの記事ではありません。',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'チケットID の入力してください！',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => 'プロセスが作成されていません！',
        'The selected process is invalid!' => '選択されたプロセスは正しくありません。',
        'Process %s is invalid!' => 'プロセス %sは不正です！',
        'Subaction is invalid!' => 'サブアクションが不正です！',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'ActivityEntityIDを特定できませんでした。 ダイナミック・フィールドまたはコンフィグが正しく設定されていません。',
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
        'Pending Date' => '保留期間',
        'for pending* states' => 'ステータス:保留にする',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID が入力されていません！',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '非表示フィールドとして顧客IDを使用できませんでした。',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'ProcessEntityID "%s" を TicketID "%s" に設定できませんでした！',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'ActivityEntityID "%s" を TicketID "%s" に設定できませんでした！',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => 'チケット %s の ActivityEntityID が入力されていません！',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => 'チケット %sの ProcessEntityID が入力されていません！',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'ActivityDialog "％s"のID "％s"を持つチケットの％sのダイナミック・フィールドの値を設定できませんでした！',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'ActivityDialog "%s"にID "%s"のチケットのPendingTimeを設定できませんでした！',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => 'Process::Default%s のデフォルト値が未指定となっています！',
        'Default Config for Process::Default%s invalid!' => 'Process::Default%s のデフォルト値が未指定となっています！',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => '利用可能チケット',
        'including subqueues' => 'サブキューを含む',
        'excluding subqueues' => 'サブキューを除く',
        'QueueView' => 'キュー・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => '担当の責任者チケット',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => '最終検索',
        'Untitled' => '',
        'Ticket Number' => 'チケット番号',
        'Ticket' => 'チケット',
        'printed by' => 'printed by',
        'CustomerID (complex search)' => '顧客ID (複合検索)',
        'CustomerID (exact match)' => '顧客ID (完全一致)',
        'Invalid Users' => '無効なユーザー',
        'Normal' => '標準',
        'CSV' => 'CSV',
        'Excel' => 'エクセル',
        'in more than ...' => '以後',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'サービス・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'ステータス・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => '担当の監視チケット',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'リンクが削除されました',
        'Ticket Locked' => 'チケットがロックされました',
        'Pending Time Set' => '保留時間を設定',
        'Dynamic Field Updated' => 'ダイナミック・フィールドを更新しました',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'チケット作成済み',
        'Type Updated' => 'タイプが更新されました',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => 'エスカレーション更新期限タイマーが停止されました',
        'Escalation First Response Time Stopped' => 'エスカレーション初回応答期限タイマーが停止されました',
        'Customer Updated' => '顧客が更新されました',
        'Internal Chat' => '内部チャット',
        'Automatic Follow-Up Sent' => '自動フォローアップの送信',
        'Note Added' => '注釈作成済み',
        'Note Added (Customer)' => '注釈作成済み(顧客)',
        'SMS Added' => '追加されたSMS',
        'SMS Added (Customer)' => '追加されたSMS（顧客）',
        'State Updated' => 'ステータスが更新されました',
        'Outgoing Answer' => '回答',
        'Service Updated' => 'サービスが更新されました',
        'Link Added' => 'リンクが追加されました',
        'Incoming Customer Email' => '顧客からのメール',
        'Incoming Web Request' => '受信Webリクエスト',
        'Priority Updated' => '優先度が更新されました',
        'Ticket Unlocked' => 'チケットのロックが解除されました',
        'Outgoing Email' => '送信メール',
        'Title Updated' => 'タイトルが更新されました',
        'Ticket Merged' => 'チケットが結合されました',
        'Outgoing Phone Call' => '架電',
        'Forwarded Message' => '転送されたメッセージ',
        'Removed User Subscription' => '削除されたユーザーサブスクリプション',
        'Time Accounted' => 'アカウンテッドタイム',
        'Incoming Phone Call' => '入電',
        'System Request.' => 'システム要求',
        'Incoming Follow-Up' => 'フォローアップがあります',
        'Automatic Reply Sent' => '自動返信送信',
        'Automatic Reject Sent' => '自動拒否送信済み',
        'Escalation Solution Time In Effect' => 'エスカレーションソリューションの有効期間',
        'Escalation Solution Time Stopped' => 'エスカレーション解決期限タイマーが停止されました',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => 'エスカレーション応答期限タイマーが停止されました',
        'SLA Updated' => 'SLA 更新済み',
        'External Chat' => '外部チャット',
        'Queue Changed' => 'キューが変更されました',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => 'FormDraftIDがありません！',
        'Can\'t get for ArticleID %s!' => 'ArticleID%sを取得できません！',
        'Article filter settings were saved.' => '記事フィルタの設定が保存されました。',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => 'ArticleIDが必要です！',
        'Invalid ArticleID!' => 'ArticleIDが無効です！',
        'Forward article via mail' => 'メール経由で記事を転送',
        'Forward' => '転送',
        'Fields with no group' => '',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',
        'Show one article' => '一つの記事を閲覧',
        'Show all articles' => '全ての記事を閲覧',
        'Show Ticket Timeline View' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => 'HTMLボディの添付ファイルがありません！',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileIDとArticleIDが必要です！',
        'No such attachment (%s)!' => 'そのような添付ファイル( %s )はありません！',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '%s::QueueDefault の設定値をご確認ください。',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '%s::TicketTypeDefault の設定値をご確認ください。',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '顧客IDの入力が必要です！',
        'My Tickets' => '担当チケット',
        'Company Tickets' => '企業チケット',
        'Untitled!' => '無題！',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '顧客ユーザの氏名',
        'Created within the last' => '以内に作成された',
        'Created more than ... ago' => '以前に作成された',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'このキューにあるチケットは再オープンできません！',
        'Create a new ticket!' => '新規チケットを作成！',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureModeが有効です！',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => 'ディレクトリ "%s" は存在しません！',
        'Configure "Home" in Kernel/Config.pm first!' => 'まず、 ”Kernel/Config.pm” ファイルの "Home" を設定してください！',
        'File "%s/Kernel/Config.pm" not found!' => '"%s/Kernel/Config.pm" ファイルが見つかりません！',
        'Directory "%s" not found!' => 'ディレクトリ "%s" が見つかりません！',
        'Install OTOBO' => 'OTOBOをインストール',
        'Intro' => 'イントロ',
        'Kernel/Config.pm isn\'t writable!' => '"Kernel/Config.pm" ファイルに書き込み権限がありません！',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'インストーラーをご利用の場合は、”Kernel.Config.pm” ファイルにWebサーバ実行ユーザによる書き込み権限を付与してください！',
        'Database Selection' => 'データベース選択',
        'Unknown Check!' => '原因不明な障害です！',
        'The check "%s" doesn\'t exist!' => 'チェック "%s"は存在しません！',
        'Enter the password for the database user.' => 'データベースユーザーのパスワードを入力してください。',
        'Database %s' => 'データベース %s',
        'Configure MySQL' => 'MySQLの設定',
        'Enter the password for the administrative database user.' => '管理権限を持つデータベースユーザーのパスワードを入力してください。',
        'Configure PostgreSQL' => 'PostgreSQLの設定',
        'Configure Oracle' => 'Oracleの設定',
        'Unknown database type "%s".' => '"%s"は不明なデータベース形式です。',
        'Please go back.' => '戻って下さい。',
        'Create Database' => 'データベース作成',
        'Install OTOBO - Error' => 'OTOBOをインストール － エラーが発生しました',
        'File "%s/%s.xml" not found!' => 'ファイル "%s/%s.xml" が見つかりません！',
        'Contact your Admin!' => '管理者に連絡してください！',
        'System Settings' => 'システム設定',
        'Syslog' => 'シスログ',
        'Configure Mail' => 'メール設定',
        'Mail Configuration' => 'メール設定',
        'Can\'t write Config file!' => '設定ファイルに書き込み出来ません！',
        'Unknown Subaction %s!' => '不明なサブアクション%s！',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Perlモジュール DBD::%sがインストールされていないため、DBに接続できませんでした。',
        'Can\'t connect to database, read comment!' => 'データベースに接続できません、コメントを読んで下さい！',
        'Database already contains data - it should be empty!' => '既にデータベースにデータが含まれている場合、空にしなければなりません。',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'innodb_log_file_sizeの設定を少なくとも%s MB以上にしてください(現在: %s MB, 推奨: %s MB)。詳細は%sを参照して下さい。',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '%sがありません！',
        'No such user!' => 'そのようなユーザーはありません！',
        'Invalid calendar!' => '無効なカレンダー',
        'Invalid URL!' => '無効なURL',
        'There was an error exporting the calendar!' => 'カレンダーのエクスポート中にエラーが発生しました。',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Package::RepositoryAccessRegExp の設定が必要です',
        'Authentication failed from %s!' => '%s からの認証が失敗しました！',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'チャット',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '異なるメールアドレスに記事をバウンス',
        'Bounce' => 'バウンス',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => '全員に返信',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'この記事を再送信',
        'Resend' => '再送信',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'この記事のメッセージログの詳細を表示する。',
        'Message Log' => 'メッセージ・ログ',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'メモに返信',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'この記事を分割',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'この記事の原文を参照する',
        'Plain Format' => '書式なし',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'この記事を印刷',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'sales@otrs.comまでご連絡下さい。',
        'Get Help' => 'ヘルプを得る',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'マーク',
        'Unmark' => 'マーク解除',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'パッケージを再インストールする',
        'Re-install' => '再インストール',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => '暗号化済',
        'Sent message encrypted to recipient!' => '',
        'Signed' => '署名済',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '不正な\'PGP SIGNED MESSAGE\'ヘッダが見つかりました！',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '不正な \'S/MIME SIGNED MESSAGE\'ヘッダが見つかりました！',
        'Ticket decrypted before' => '復号前のチケット',
        'Impossible to decrypt: private key for email was not found!' => 'このメールに対応する秘密鍵が存在しないため、復号できませんでした。',
        'Successful decryption' => '復号に成功しました',

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
        'Sign' => '署名',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => '表示',
        'Refresh (minutes)' => '更新 (分)',
        'off' => 'オフ',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '顧客ユーザーを表示',
        'Offline' => 'オフライン',
        'User is currently offline.' => 'ユーザーは現在オフラインです。',
        'User is currently active.' => 'ユーザーは現在活動中です。',
        'Away' => '離席',
        'User was inactive for a while.' => 'ユーザーはしばらくインアクティブです',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'OTOBOニュースサーバーに接続できませんでした！',
        'Can\'t get OTOBO News from server!' => 'OTOBO Newsをサーバから取得できませんでした！',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '製品ニュースサーバーに接続できませんでした！',
        'Can\'t get Product News from server!' => '製品ニュースをサーバーから取得できませんでした！',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '%sに接続できませんでした！',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'チケットを表示',
        'Shown Columns' => '列を表示',
        'filter not active' => 'フィルターは有効化されていません',
        'filter active' => 'フィルターを有効化',
        'This ticket has no title or subject' => 'このチケットにはタイトルもしくはテーマが入力されていません',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '週間統計',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '利用できません',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'スタンダード',
        'The following tickets are not updated: %s.' => '',
        'h' => '時間',
        'm' => '分',
        'd' => '日',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'これは',
        'email' => 'メール',
        'click here' => 'ここをクリック',
        'to open it in a new window.' => '新規ウィンドウを開く',
        'Year' => '年',
        'Hours' => '時間',
        'Minutes' => '分',
        'Check to activate this date' => 'この日付を活性化する場合はチェック',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => '権限がありません。',
        'No Permission' => '権限がありません',
        'Show Tree Selection' => 'ツリーセレクターを表示する',
        'Split Quote' => '見積を分割',
        'Remove Quote' => '見積を削除',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'リンク先',
        'Search Result' => '検索結果',
        'Linked' => 'リンク済',
        'Bulk' => '一括',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'ライト',
        'Unread article(s) available' => '未読の記事があります',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '予約',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'アーカイブの検索',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'オンラインの担当者: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '更にエスカレーションされたチケットがあります。',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'このボタンをクリックして、あなたのプレファレンスにタイムゾーンを選択して下さい。',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'オンラインの顧客: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBOデーモンが起動していません。',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '外出中が有効になっています。無効にしますか？',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'デプロイされていない設定があります。デプロイしますか？',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '設定は更新されておりますので、ご安心ください。',
        'There is an error updating the system configuration!' => 'システム設定の更新時にエラーが発生しました。',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '%sの利用は、スーパーユーザー・アカウント（UserID 1）を使用しないで下さい！ 新しい担当者を作成し、そのアカウントで作業して下さい。',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',
        'Preferences updated successfully!' => '個人設定を更新しました',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(処理中)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => '新しいパスワード(確認用)',
        'The current password is not correct. Please try again!' => 'パスワードが正しくありません。再入力してください。',
        'Please supply your new password!' => '新しいパスワードを入力して下さい！',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'パスワードを更新できません。%s文字以上必要です。',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'パスワードを更新できません。英語の大文字小文字がそれぞれ2文字ずつ以上必要です。',
        'Can\'t update password, it must contain at least 1 digit!' => 'パスワードを更新できません。数字が1文字以上必要です。',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'パスワードを更新できません。アルファベットが2文字以上必要です。',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'タイムゾーンが正常に更新されました！',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => '無効',
        'valid' => '有効',
        'No (not supported)' => 'いいえ(サポートされていません)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '現在選択されているタイム・スケールの値にX軸のタイム・スケールの値は利用できません。',
        'The selected date is not valid.' => '選択した日付は不正です。',
        'The selected end time is before the start time.' => '選択した終了時刻は開始時刻より前です。',
        'There is something wrong with your time selection.' => '時刻の選択が間違っています。',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => 'X軸の要素を1つ選択してください。',
        'You can only use one time element for the Y axis.' => 'Y軸には時刻の要素は1つだけ指定可能です。',
        'You can only use one or two elements for the Y axis.' => 'Y軸には1つもしくは2つの要素が指定可能です。',
        'Please select at least one value of this field.' => '少なくとも値を1つは選択して下さい。',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => 'タイム・スケールを選択してください',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'レポートする間隔が小さすぎます。間隔をあけてください。',
        'second(s)' => '秒',
        'quarter(s)' => '四半期',
        'half-year(s)' => '半期',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'この設定の編集をキャンセルしてアンロックする',
        'Reset this setting to its default value.' => 'この設定をデフォルトの値にリセットする',
        'Unable to load %s!' => '%sを読み込めません！',
        'Content' => '内容',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'キューに戻すためチケットをロック解除',
        'Lock it to work on it' => '作業するためチケットをロック',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => '監視解除',
        'Remove from list of watched tickets' => '監視チケットリストから削除',
        'Watch' => '監視',
        'Add to list of watched tickets' => '監視チケットリストに追加',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '順序',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'ロック済チケット新規',
        'Locked Tickets Reminder Reached' => 'ロック済チケット時間切れ',
        'Locked Tickets Total' => 'ロック済チケット合計',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => '責任者チケット新規',
        'Responsible Tickets Reminder Reached' => '責任者チケット時間切れ',
        'Responsible Tickets Total' => '責任者チケット合計',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => '監視チケット新規',
        'Watched Tickets Reminder Reached' => '監視チケット時間切れ',
        'Watched Tickets Total' => '監視チケット合計',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'チケットのダイナミック・フィールド',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '予定されていたメンテナンスのため、只今の時間はログインを行うことができません。',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'セッションが無効です。再ログインしてください。',
        'Session has timed out. Please log in again.' => 'セッションがタイムアウトしました。再ログインしてください。',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'PGP署名のみ',
        'PGP encrypt only' => 'PGP暗号化のみ',
        'SMIME sign only' => 'SMIME署名のみ',
        'SMIME encrypt only' => 'SMIME暗号化のみ',
        'PGP and SMIME not enabled.' => 'PGPとSMIMEが有効化されていません。',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '署名せずに通知を送信',
        'Send unencrypted notification' => '暗号化せずに通知を送信',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '構成オプションリファレンス',
        'This setting can not be changed.' => 'この設定を変更することは出来ません。',
        'This setting is not active by default.' => 'この設定は標準では有効ではありません。',
        'This setting can not be deactivated.' => 'この設定は無効化することはできません。',
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
        'before/after' => '前／後',
        'between' => '期間中',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '例: Text または Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'この領域は必須です。または、',
        'The field content is too long!' => 'その領域の内容が長すぎます。',
        'Maximum size is %s characters.' => '最大サイズは%s文字です。',

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
        'not installed' => '未インストール',
        'installed' => 'インストール済',
        'Unable to parse repository index document.' => 'リポジトリインデックスドキュメントを解析できません。',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'このリポジトリ中でご利用のフレームワークのバージョンに対するパッケージが見つかりません。他のフレームワークのバージョンに対するパッケージのみ含まれます。',
        'File is not installed!' => 'ファイルがインストールされていません！',
        'File is different!' => '',
        'Can\'t read file!' => 'ファイルを読み込めません！',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTOBO service contracts.</p>' =>
            '<p>このパッケージのインストールを継続すると、以下の問題が発生するかもしれません。</p><ul><li>&nbsp;-セキュリティ上の問題</li><li>&nbsp;-安定性の問題</li><li>&nbsp;-パフォーマンスの問題</li></ul><p>このパッケージを動作させることによって引き起こされた問題はOTOBOサービス契約の対象外ですのでご注意ください。</p>',
        '<p>The installation of packages which are not verified by the OTOBO Team is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '無効',
        'FadeAway' => '未使用',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '登録サーバに接続できません。しばらくしてから再試行してください。',
        'No content received from registration server. Please try again later.' =>
            '登録サーバから受信した内容がありません。しばらくしてから再試行してください。',
        'Can\'t get Token from sever' => 'サーバーからトークンを取得できませんでした',
        'Username and password do not match. Please try again.' => 'ユーザー名とパスワードが一致しません。再試行してください。',
        'Problems processing server result. Please try again later.' => 'サーバから受信した内容を処理しているときに問題が発生しました。再試行してください。',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '合計',
        'week' => '週',
        'quarter' => '四半期',
        'half-year' => '半期',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'ステータス・タイプ',
        'Created Priority' => '作成時の優先度',
        'Created State' => '作成されたステータス',
        'Create Time' => '作成日時',
        'Pending until time' => 'ある時間まで保留中',
        'Close Time' => 'クローズ時間',
        'Escalation' => 'エスカレーション',
        'Escalation - First Response Time' => 'エスカレーション - 第1の応答時間',
        'Escalation - Update Time' => 'エスカレーション - 更新期限',
        'Escalation - Solution Time' => 'エスカレーション - 解決時間',
        'Agent/Owner' => '担当者／所有者',
        'Created by Agent/Owner' => '作成した担当者／所有者',
        'Assigned to Customer User Login' => '顧客ユーザログインに割り当てられました。',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '評価',
        'Ticket/Article Accounted Time' => 'チケット／記事の作業時間',
        'Ticket Create Time' => 'チケット作成日時',
        'Ticket Close Time' => 'チケット・クローズ時間',
        'Accounted time by Agent' => '担当者の作業時間',
        'Total Time' => '合計時間',
        'Ticket Average' => 'チケット平均',
        'Ticket Min Time' => 'チケット最少時間',
        'Ticket Max Time' => 'チケット最大時間',
        'Number of Tickets' => 'チケットの数',
        'Article Average' => '記事平均',
        'Article Min Time' => '記事最少時間',
        'Article Max Time' => '記事最大時間',
        'Number of Articles' => '記事の数',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '無制限',
        'Attributes to be printed' => '印刷する属性',
        'Sort sequence' => '並べ替え順序',
        'State Historic' => 'ステータスの履歴',
        'State Type Historic' => 'ステータス・タイプの履歴',
        'Historic Time Range' => '',
        'Number' => '番号',
        'Last Changed' => '最終変更日時',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '平均解決時間',
        'Solution Min Time' => '最少解決時間',
        'Solution Max Time' => '最大解決時間',
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
        'Table Presence' => 'テーブル プレゼンス',
        'Internal Error: Could not open file.' => 'インターナルエラー: ファイルをオープンすることができません',
        'Table Check' => 'テーブルチェック',
        'Internal Error: Could not read file.' => 'インターナルエラー: ファイルが読み込めませんでした',
        'Tables found which are not present in the database.' => 'データベースに存在しないテーブルが見つかりました',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'データーベースサイズ',
        'Could not determine database size.' => 'データーベースサイズが特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'データベースのバージョン',
        'Could not determine database version.' => 'データベースのバージョンが特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'クライアントコネクションのキャラクターセット',
        'Setting character_set_client needs to be utf8.' => 'character_set_client は utf8 に設定する必要があります',
        'Server Database Charset' => 'データーベースサーバーのキャラクターセット',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Table キャラクターセット',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDBログのファイルサイズ',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'innodb_log_file_size 設定は最低でも256MBにする必要があります。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'デフォルト値は不正です',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '最大クエリサイズ',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'クエリキャッシュサイズ',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'query_cache_size の設定を行ってください (設定値は10MB以上512MB以下に設定する必要があります)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'デフォルトのストレージエンジン',
        'Table Storage Engine' => 'ストレージエンジン',
        'Tables with a different storage engine than the default engine were found.' =>
            'デフォルトのストレージエンジンと違うストレージエンジン設定の Table が見つかりました',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '動作要件は MySQL 5.x 以上になっています ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG 設定',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANGはal32utf8に設定する必要があります(例: ja_JP.AL32UTF8)。',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT 設定',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT は YYYY-MM-DD HH24:MI:SS に設定されている必要があります',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT 設定 SQL チェック',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => ' client_encodingはユニコードまたはUTF8 に設定する必要があります',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'server_encodingはユニコードまたはUTF8 に設定する必要があります',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'データーフォーマット',
        'Setting DateStyle needs to be ISO.' => '日付の設定はISOフォーマットに従ってください',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO ディスクパーティション',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'ディスク利用率',
        'The partition where OTOBO is located is almost full.' => 'OTOBO がインストールされているディスクパーティションがもうすぐいっぱいになります',
        'The partition where OTOBO is located has no disk space problems.' =>
            'OTOBO がインストールされているディスクパーティションはディスクスペースの問題は起こっていません',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'OTRS ディスクパーティション使用率',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'ディストリビューション',
        'Could not determine distribution.' => 'ディストリビューションを特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'カーネルバージョン',
        'Could not determine kernel version.' => 'カーネルバージョンを特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'システムロード',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'CPUの最大値はシステムの最大値を超えて読み込むことはできません(例. 8または8以下のCPUを　8 CPUのシステムで読み込むことは可能です).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl モジュール',
        'Not all required Perl modules are correctly installed.' => '必要な Perl モジュールが一部インストールされていません ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '未使用の Swap 領域 (%)',
        'No swap enabled.' => 'スワップが存在していません。',
        'Used Swap Space (MB)' => '利用 Swap 領域 (MB) ',
        'There should be more than 60% free swap space.' => '未利用のSwap領域が少なくとも 60 % 必要です',
        'There should be no more than 200 MB swap space used.' => '200MB 以上のSwap 領域が存在してはいけない',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => '記事検索インデックスのステータス',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'コミュニケーション・チャンネルごとの記事',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => '着信コミュニケーション',
        'Outgoing communications' => '発信コミュニケーション',
        'Failed communications' => 'コミュニケーションの失敗',
        'Average processing time of communications (s)' => 'コミュニケーションの平均処理時間(s)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'コミュニケーション・ログのアカウント・ステータス（24時間以内）',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Config 設定',
        'Could not determine value.' => 'value を特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'デーモン',
        'Daemon is running.' => 'デーモンは稼働中です。',
        'Daemon is not running.' => 'デーモンは稼働していません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'データーベースレコード',
        'Ticket History Entries' => 'チケット履歴エントリ',
        'Articles' => '記事',
        'Attachments (DB, Without HTML)' => '添付(DB, HTML以外)',
        'Customers With At Least One Ticket' => '一つ以上のチケットがある顧客',
        'Dynamic Field Values' => 'ダイナミック・フィールドの値',
        'Invalid Dynamic Fields' => '不正なダイナミック・フィールドです',
        'Invalid Dynamic Field Values' => 'ダイナミック・フィールドの値は不正です',
        'GenericInterface Webservices' => 'ジェネリックインターフェース・Webサービス',
        'Process Tickets' => 'プロセス・チケット',
        'Months Between First And Last Ticket' => '最初と最後のチケットとの間には月間',
        'Tickets Per Month (avg)' => '月毎のチケット数(平均)',
        'Open Tickets' => '対応中チケット',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'デフォルトのSOAPユーザ名とパスワード',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'セキュリティーリスク: SOAP::User 及び SOAP::Password のデフォルト設定を利用しています、変更を行ってください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => '管理者のデフォルトパスワード',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'セキュリティーリスク: エージェントアカウント root@localhost はいまだにデフォルトパスワードを利用しています、変更を行ってください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'Eメール送信キュー',
        'Emails queued for sending' => '送信待ちのEメール',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (ドメインネーム)',
        'Please configure your FQDN setting.' => 'FQDNの設定を確認して下さい。',
        'Domain Name' => 'ドメインネーム',
        'Your FQDN setting is invalid.' => 'FQDNの設定が不正です',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => '書き込み可能なファイルシステム',
        'The file system on your OTOBO partition is not writable.' => 'OTOBOパーティション上のファイルシステムは書き込み可能ではありません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '従来構成のバックアップ',
        'No legacy configuration backup files found.' => '従来構成のバックアップファイルは見つかりませんでした。',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'パッケージの導入状態',
        'Some packages have locally modified files.' => 'いくつかのパッケージがローカルで修正されています。',
        'Some packages are not correctly installed.' => '正常にインストールされていないパッケージが存在します',
        'Package Verification Status' => 'パッケージの検証結果',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            'いくつかのパッケージはOTRS社で認証されていません。これらのパッケージの使用は推奨しません。',
        'Package Framework Version Status' => 'パッケージフレームワークバージョン',
        'Some packages are not allowed for the current framework version.' =>
            'いくつかのパッケージは現在のフレームワークのバージョンに対応していません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'パッケージリスト',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'スプールされたメール',
        'There are emails in var/spool that OTOBO could not process.' => 'OTOBOが処理できなかったメールがvar/spool以下に存在しています。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'あなたのSystemID設定は不正です。数字以外は利用できません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '標準のチケットタイプ',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '設定された標準のチケットタイプは不正か存在していません。Ticket::Type::Default設定を確認し、正しいチケットタイプを指定してください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'チケットインデクスモジュール',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'システムにチケットが60,000以上あるため、バックエンドにはStaticDBを利用するべきです。詳細は管理者マニュアル(パフォーマンスチューニング)を参照してください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'システム内にチケットが 8,000以上オープンにしないでください',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'チケット検索インデックス・モジュール',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'ticket_lock_indexテーブルに孤立したレコード',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'テーブル ticket_lock_indexに孤立したレコードが存在しています。 StaticDBのインデックスを正しくするためにbin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup"を実行してください。',
        'Orphaned Records In ticket_index Table' => 'ticket_indexテーブルに孤立したレコード',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'テーブル ticket_indexに孤立したレコードが存在しています。 StaticDBのインデックスを正しくするためにbin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" を実行してください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => '時刻設定',
        'Server time zone' => 'サーバのタイムゾーン',
        'OTOBO time zone' => 'OTOBOのタイムゾーン',
        'OTOBO time zone is not set.' => 'OTOBOのタイムゾーンが設定されていません。',
        'User default time zone' => 'ユーザーのデフォルトタイムゾーン',
        'User default time zone is not set.' => 'ユーザーのデフォルトのタイムゾーンが設定されていません。',
        'Calendar time zone is not set.' => 'カレンダーのタイムゾーンが設定されていません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - 担当者スキンの使用状況',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - 担当者のテーマ使用状況',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - 特殊レポート',
        'Agents using custom main menu ordering' => 'カスタムメインメニューのオーダーを使用する担当者',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webサーバー',
        'Loaded Apache Modules' => 'ロードされたApacheモジュール',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPMモデル',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBOはapacheがMPMモデルがpreforkで実行されている必要があります。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGIアクセラレータの有無',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'パフォーマンス向上のためFastCGIまたはmod_perlの使用を推奨します。',
        'mod_deflate Usage' => 'mod_deflateの有無',
        'Please install mod_deflate to improve GUI speed.' => 'GUIのパフォーマンス向上のためmod_deflateをインストールしてください。',
        'mod_filter Usage' => 'mod_filter の有無',
        'Please install mod_filter if mod_deflate is used.' => 'moddeflateを利用する場合は、mod_filterをインストールしてください。',
        'mod_headers Usage' => 'mod_headersの有無',
        'Please install mod_headers to improve GUI speed.' => 'GUIのパフォーマンス向上のためmod_headersをインストールしてください。',
        'Apache::Reload Usage' => 'Apache::Reloadモジュール使用',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            ' PerlModuleとしてApache::Reload あるいは Apache2::Reload が利用され、インストールあるいはモジュールのアップグレード中のWebサーバー再起動を防ぐために、PerlInitHandlerが利用されるべきです',
        'Apache2::DBI Usage' => 'Apache2::DBIモジュール使用',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '既存DBコネクションを有効に利用するため、Apache2::DBIを使用するとより良いパフォーマンスを得ることが出来ます。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '環境変数',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webサイトバージョン',
        'Could not determine webserver version.' => 'WEBサーバのバージョンを決定できません。',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '同時接続ユーザー詳細',
        'Concurrent Users' => '同時実行ユーザー',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => '問題',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '設定 %s は存在しません！',
        'Setting %s is not locked to this user!' => 'Setting %s is not locked to this user!',
        'Setting value is not valid!' => '設定された値は無効です！',
        'Could not add modified setting!' => '変更した設定を追加できませんでした！',
        'Could not update modified setting!' => '変更した設定を更新できませんでした！',
        'Setting could not be unlocked!' => '設定はアンロックされていません！',
        'Missing key %s!' => 'キー %s がありません！',
        'Invalid setting: %s' => '設定が不正です: %s',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => '全ての設定',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'デフォルト',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '有効',
        'Disabled' => '無効',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            'システムはユーザー日付をOTOBOTimeZoneから算出できませんでした！',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            'システムはユーザー日時をOTOBOTimeZoneから算出できませんでした！',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '正常な値ではありません！確認の上、この設定を修正してください。',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'アンロック時間のリセット',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => 'チャットメッセージ本文',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many fail attempts, please retry again later' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'ログインできません。ユーザー名またはパスワードを確認してください。',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => 'セッションIDを削除できません。',
        'Logout successful.' => 'ログアウトしました。',
        'Feature not active!' => '機能が有効になっていません。',
        'Sent password reset instructions. Please check your email.' => 'パスワードを初期化する手順を送信しました。メールを確認してください。',
        'Invalid Token!' => '無効なトークンです',
        'Sent new password to %s. Please check your email.' => '新しいパスワードを %s に送信しました。メールを確認してください。',
        'Error: invalid session.' => 'エラー: セッションが無効な値です。',
        'No Permission to use this frontend module!' => 'このフロントエンドモジュールを使用する権限がありません',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '承認に成功しましたが、該当する顧客情報が存在しませんでした。管理者に連絡してください。',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'パスワードのリセットができませんでした。管理者に連絡してください。',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'このe-mailアドレスはすでに存在します。ログインまたはパスワードのリセットを行ってください。',
        'This email address is not allowed to register. Please contact support staff.' =>
            'このemailアドレスの登録は認められていません。サポートにお問い合わせください。',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '顧客ユーザーが追加できませんでした。',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            '新規アカウントを作成しました。ログイン情報を %s に送信しました。メールを確認してください。',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => '無効-暫定',
        'Group for default access.' => '一般ユーザ用のデフォルトグループ',
        'Group of all administrators.' => '管理者用グループ',
        'Group for statistics access.' => 'レポート・レポート操作用のグループ',
        'new' => '新規',
        'All new state types (default: viewable).' => '全ての新規ステータス・タイプ（デフォルト：表示可能）',
        'open' => '対応中',
        'All open state types (default: viewable).' => '全ての対応中ステータス・タイプ（デフォルト：表示可能）',
        'closed' => 'クローズ',
        'All closed state types (default: not viewable).' => '全ての完了ステータス・タイプ（デフォルト：表示可能）',
        'pending reminder' => '保留中 (期限付)',
        'All \'pending reminder\' state types (default: viewable).' => '全ての \'ペンディング・リマインダー\' ステータス・タイプ（デフォルト：表示可能）',
        'pending auto' => '保留中 (自動)',
        'All \'pending auto *\' state types (default: viewable).' => '全ての保留中 (自動) ステータス・タイプ（デフォルト：表示可能）',
        'removed' => '削除',
        'All \'removed\' state types (default: not viewable).' => '全ての削除ステータス・タイプ（デフォルト：表示不可能）',
        'merged' => '結合済',
        'State type for merged tickets (default: not viewable).' => 'マージされたチケットのステータス・タイプ (デフォルト：表示不可)',
        'New ticket created by customer.' => '顧客が作成した新規チケット',
        'closed successful' => 'クローズ (成功)',
        'Ticket is closed successful.' => 'チケットは成功としてクローズされました。',
        'closed unsuccessful' => 'クローズ (不成功)',
        'Ticket is closed unsuccessful.' => 'チケットは不成功としてクローズされました。',
        'Open tickets.' => '対応中チケット',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '担当者のリマインダーのチケットは保留中です。',
        'pending auto close+' => '保留 (自動クローズ＋)',
        'Ticket is pending for automatic close.' => 'チケットは自動クローズ設定月で保留されました。',
        'pending auto close-' => '保留 (自動クローズ－)',
        'State for merged tickets.' => 'マージされたチケットのステータス',
        'system standard salutation (en)' => 'システム標準の挨拶文 (日本語)',
        'Standard Salutation.' => '標準の挨拶文',
        'system standard signature (en)' => 'システム標準の署名 (日本語)',
        'Standard Signature.' => '標準の署名',
        'Standard Address.' => '標準のアドレス',
        'possible' => '可能',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'クローズ・チケットに対するフォローアップが可能です。チケットは再オープンされます。',
        'reject' => '拒否',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'クローズ・チケットへのフォローアップはできません。新規チケットも作成されません。',
        'new ticket' => '新規チケット',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'ポストマスター・キュー',
        'All default incoming tickets.' => 'デフォルトでは全てのチケットが入ります。',
        'All junk tickets.' => '全てのジャンクチケット',
        'All misc tickets.' => '全ての未分類チケット',
        'auto reply' => '自動返答',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => '自動リジェクト',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => '自動フォローアップ',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => '自動返答/新規チケット',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => '自動除去',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '未分類',
        '1 very low' => '1 最低',
        '2 low' => '2 低',
        '3 normal' => '3 中',
        '4 high' => '4 高',
        '5 very high' => '5 最高',
        'unlock' => 'ロック解除',
        'lock' => 'ロック',
        'tmp_lock' => '',
        'agent' => '担当者',
        'system' => 'システム',
        'customer' => '顧客',
        'Ticket create notification' => '新規作成通知',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '"My Queues"および"My Services"に新しいチケットが作成されると、通知を受信します。',
        'Ticket follow-up notification (unlocked)' => 'チケット・フォローアップ通知 (ロック解除)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => 'チケット・フォローアップ通知 (ロック)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'ロック期限切れチケット通知',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => 'チケットの所有者変更通知',
        'Ticket responsible update notification' => 'チケットの責任者変更通知',
        'Ticket new note notification' => 'チケットのノート追加通知',
        'Ticket queue update notification' => 'チケット・キュー更新通知',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '"My Queues"で指定しているキューにチケットが移動された際に通知されます。',
        'Ticket pending reminder notification (locked)' => 'チケットのペンディングリマインダー通知(ロック中)',
        'Ticket pending reminder notification (unlocked)' => 'チケットのペンティングリマインダー通知(未ロック)',
        'Ticket escalation notification' => 'チケットのエスカレーション通知',
        'Ticket escalation warning notification' => 'チケットのエスカレーション警告通知',
        'Ticket service update notification' => 'チケット・サービス更新通知',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'My Servidesに登録しているチケットのサービスが変更された場合に通知されます。',
        'Appointment reminder notification' => '予約リマインダーの通知',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => 'チケット送信失敗通知',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '全てを追加',
        'An item with this name is already present.' => 'この名前の項目は既に存在します。',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'このアイテムは、配下にサブアイテムを保有しています。このアイテムをサブアイテムと共に削除してもよろしいですか？',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'もっと多く',
        'Less' => 'もっと少なく',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'クリップボードにコピーするにはCtrl+C(Cmd+C)を押してください。',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'この添付ファイルを削除',
        'Deleting attachment...' => '添付ファイルを削除しています...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '添付ファイル削除時にエラーが発生しました。詳細はログを確認してください。',
        'Attachment was deleted successfully.' => '添付ファイルが正常に削除されました。',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'このダイナミック・フィールドを本当に削除しますか？全てのデータが失われます。',
        'Delete field' => 'ダイナミックフィールド',
        'Deleting the field and its data. This may take a while...' => 'フィールドとそれに属するデータを削除します。これには少々時間が掛かることがあります。',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '選択項目を削除',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'このイベントトリガーを削除',
        'Duplicate event.' => 'イベントを複製',
        'This event is already attached to the job, Please use a different one.' =>
            'このイベントはすでにジョブにアタッチされています。ほかのイベントをご利用ください。',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'コミュニケーション中にエラーが発生しました。',
        'Request Details' => '要求の詳細',
        'Request Details for Communication ID' => 'Communication IDの要求の詳細',
        'Show or hide the content.' => 'コンテンツの表示・非表示',
        'Clear debug log' => 'デバッグログを削除',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'このAPI実行元を削除',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'このキー割り当ての削除',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'このオペレーションを削除',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'ウェブサービスの複製',
        'Delete operation' => 'オペレーションを削除',
        'Delete invoker' => 'API実行元を削除',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告: あなたの名前を変更するグループの管理者はシステム設定の中で適切な変更を行う前にあなたの管理者パネルはロックアウトされます。この問題が発生した場合、管理するSQLステートメントごとにグループを元に戻してください',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'この言語での通知を本当に削除しますか？',
        'Do you really want to delete this notification?' => 'この通知を本当に削除しますか？',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'パッケージのアップグレードが最近終了しました。 結果を見るにはここをクリックして下さい。',
        'No response from get package upgrade result.' => '',
        'Update all packages' => 'パッケージを全て更新する',
        'Dismiss' => '非表示',
        'Update All Packages' => 'パッケージを全て更新する',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '現在は未対応です',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'こちらは現在パッケージの更新中のため無効化されています。',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'こちらは現在 OTOBO デーモンが停止中のため無効化されています。',
        'Are you sure you want to update all installed packages?' => '全てのパッケージを更新します。よろしいですか？',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'このポストマスター・フィルターを削除',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'ポストマスターフィルターを削除します。この処理には時間がかかる場合があります。',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'キャンバスからエンティティを削除',
        'No TransitionActions assigned.' => '推移アクションが関連付けられていません。',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'ダイアログが関連付けられていません。適切なダイアログを左から個々にドラッグしてください。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'このアクティビティは開始アクティビティであるため削除できません。',
        'Remove the Transition from this Process' => 'このプロセスから遷移を削除',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'このボタンもしくはリンクを選択すると即座にこの画面を離れ、現在の状態が自動的に保存されます。続行しますか？',
        'Delete Entity' => 'エンティティを削除',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'このアクティビティは既にプロセスで使用されています。2度追加できません。',
        'Error during AJAX communication' => 'AJAX通信時にエラーが発生しました',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '接続されていない推移がキャンバス上に存在します。他の推移を配置する前に接続してください。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'この遷移は既にこのアクティビティに対して使用されています。2度使用できません。',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'の遷移動作は既にこのパスで使用されています。2度使用できません。',
        'Hide EntityIDs' => 'エンティティIDを隠す',
        'Edit Field Details' => '領域の詳細を編集',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '申し訳ありませんが、最後に残された選択肢は削除できません。',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '更新を送信中…',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => 'OTOBO Team へのサポートデータを送信できませんでした。',
        'Update Result' => 'アップデート結果',
        'Generating...' => '作成中...',
        'It was not possible to generate the Support Bundle.' => 'サポートバンドルが生成できませんでした。',
        'Generate Result' => '生成結果',
        'Support Bundle' => 'サポートバンドル',
        'The mail could not be sent' => 'メールが送信できませんでした',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '手動アップデート',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => '読み込み中...',
        'Search the System Configuration' => 'システム設定の検索',
        'Please enter at least one search word to find anything.' => '何かを見つけるために少なくとも1つの検索単語を入力してください。',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => 'デプロイ',
        'The deployment is already running.' => 'デプロイメントはすでに実行中です。',
        'Deployment successful. You\'re being redirected...' => 'デプロイに成功しました。 ',
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
            'このスケジュールされたシステムメンテナンスを本当に削除しますか？',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'テンプレートを削除',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'カレンダー',
        'Timeline Month' => '月間タイムライン',
        'Timeline Week' => '週間タイムライン',
        'Timeline Day' => '日中タイムライン',
        'Previous' => '過去',
        'Resources' => 'リソース',
        'Su' => '日',
        'Mo' => '月',
        'Tu' => '火',
        'We' => '水',
        'Th' => '木',
        'Fr' => '金',
        'Sa' => '土',
        'This is a repeating appointment' => 'これは繰り返しの予定です。',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'この発生またはすべて発生だけを編集しますか？',
        'All occurrences' => '全ての発生',
        'Just this occurrence' => 'この発生時点',
        'Too many active calendars' => '有効化されたカレンダーが多すぎます',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => 'デフォルト値に戻す',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => '重複した登録',
        'It is going to be deleted from the field, please try again.' => '',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '少なくとも検索したい単語を１つ（なんでもいい時は*を）入力してください。',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'OTOBO デーモンの紹介',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '',
        'month' => '月',
        'Remove active filters for this widget.' => 'このウィジットに対するアクティブ・フィルターを除去',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'しばらくお待ちください..',
        'Searching for linkable objects. This may take a while...' => 'リンク可能なオブジェクトを検索しています。 これは時間がかかる場合があります...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'AdBlockやAdBlockPlus等、広告ブロックプラグインが検出されました。これらのプラグインの使用に起因する問題が報告されていますので、このドメインを除外対象にすることを推奨します。',
        'Do not show this warning again.' => 'この警告を再表示しない',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '申し訳ありません。必須とマークされている通知は無効化することはできません。',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '申し訳ありません。この通知を無効化することはできません。',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            'エラーが発生しました。管理者に連絡してください。',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'デスクトップモードへ',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'この要素は子供が存在するため削除できません。',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'このレポートを削除してよろしいですか？',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'チケットに割り当てる顧客IDを選択してください',
        'Do you really want to continue?' => '本当にこの操作を継続してよろしいですか？',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '...あまり見せない',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '新しい下書きを追加',
        'Delete draft' => '下書きを削除',
        'There are no more drafts available.' => '下書きがありません',
        'It was not possible to delete this draft.' => 'この下書きは削除できません',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => '記事フィルタ',
        'Apply' => '適用',
        'Event Type Filter' => 'イベントタイプ・フィルター',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'ナビゲーションバーを操作してください',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Internet Explorerの互換モードを無効にして下さい。',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'モバイルモードへ',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'エラー:ブラウザチェックに失敗しました',
        'Reload page' => 'ページの再読み込み',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => '一つ以上のエラーが発生しました。',

        # JS File: Core.Installer
        'Mail check successful.' => 'メールチェックに成功しました。',
        'Error in the mail settings. Please correct and try again.' => 'メール設定中にエラーが発生しました。再設定してください。',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '新規ウィンドウで注釈を開く',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => 'キーは必須です',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '対応開始日を選択',
        'Invalid date (need a future date)!' => '無効な日付です。 (未来の日付が必要)',
        'Invalid date (need a past date)!' => '',

        # JS File: Core.UI.InputFields
        'Not available' => '',
        'and %s more...' => '他%sつ',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'すべてクリア',
        'Filters' => 'フィルター',
        'Clear search' => '検索条件をクリア',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'このページから移動します。全てのポップアップウィンドウを閉じてもよろしいですか？',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '既にポップアップウィンドウを開いています。開いているウィンドウを閉じて新しく開きますか？',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'ポップアップウィンドウを開けませんでした。アプリケーションのポップアップブロッカーを無効にしてください。',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => 'フィルターを削除',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => '現在選択可能な要素はありません。',

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
        'yes' => 'はい',
        'no' => 'いいえ',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => '',
        'Stacked' => '',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'ストリーム',
        'Expanded' => '展開',

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
