# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ko;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = [];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '';
    $Self->{DateFormatLong}      = '';
    $Self->{DateFormatShort}     = '';
    $Self->{DateInputFormat}     = '';
    $Self->{DateInputFormatLong} = '';
    $Self->{Completeness}        = 0.939782823297137;

    # csv separator
    $Self->{Separator}         = '';

    $Self->{DecimalSeparator}  = '';
    $Self->{ThousandSeparator} = '';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL 관리',
        'Actions' => '행동',
        'Create New ACL' => '새 ACL',
        'Deploy ACLs' => 'ACL 배포',
        'Export ACLs' => 'ACL 내보내기',
        'Filter for ACLs' => 'ACL 필터',
        'Just start typing to filter...' => '필터링을 시작하는 중...',
        'Configuration Import' => '설정 Import',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 ACL을 가져올 수 있습니다. ACL 편집기 모듈에서 내 보낸 파일은 .yml 형식이어야합니다.',
        'This field is required.' => '이 항목은 필수입니다.',
        'Overwrite existing ACLs?' => '존재하는 ACL을 덮어쓰시겠습니까?',
        'Upload ACL configuration' => 'ACL 설정 업로드',
        'Import ACL configuration(s)' => 'ACL 설정 Import',
        'Description' => '설명',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '새 ACL을 만들려면 다음에서 내 보낸 ACL을 가져올 수 있습니다.다른 시스템을 만들거나 완전한 새 시스템을 만드십시오.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '이후 ACL 데이터를 배포하는 경우 여기에서 ACL을 변경하면 시스템의 동작에만 영향을줍니다. ACL 데이터를 배포하면 새로 변경된 내용이 구성에 기록됩니다.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '이 테이블은 ACL의 실행 순서를 나타냅니다. ACL이 실행되는 순서를 변경해야하는 경우 영향을받는 ACL의 이름을 변경하십시오',
        'ACL name' => 'ACL 명',
        'Comment' => '의견',
        'Validity' => '정당함',
        'Export' => '내보내기',
        'Copy' => '복사',
        'No data found.' => '데이터가 없음',
        'No matches found.' => '일치하는 것을 찾을 수 없음',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACL 수정 %s',
        'Edit ACL' => 'ACL 수정',
        'Go to overview' => '오버뷰로 가기',
        'Delete ACL' => 'ACL 삭제',
        'Delete Invalid ACL' => '비정상 ACL 삭제',
        'Match settings' => '일치 설정',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '이 ACL에 대한 일치 기준을 설정하십시오. \'Properties\'를 사용하여 현재 화면을 일치 시키거나 \'PropertiesDatabase\'를 사용하여 데이터베이스에있는 현재 티켓의 속성과 일치시킵니다.',
        'Change settings' => '설정 변경',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '기준이 일치하면 변경하려는 항목을 설정하십시오. Possible \'은 흰색 목록이고\'PossibleNot \'은 검은 색 목록입니다.',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => '내용 보여주기/가리기',
        'Edit ACL Information' => 'ACL 정보 수정',
        'Name' => '이름',
        'Stop after match' => '다음 매칭을 중지',
        'Edit ACL Structure' => 'ACL 구조 수정',
        'Save ACL' => 'ACL 저장',
        'Save' => '저장',
        'or' => '또는',
        'Save and finish' => '저장 후 종료',
        'Cancel' => '취소',
        'Do you really want to delete this ACL?' => '정말로 이 ACL을 지우시겠습니까?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '양식 데이터를 제출하여 새 ACL을 작성하십시오. ACL을 생성 한 후 편집 모드에서 구성 항목을 추가 할 수 있습니다',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '캘린더 관리',
        'Add Calendar' => '캘린더 추가',
        'Edit Calendar' => '캘린더 수정',
        'Calendar Overview' => '캘린더 개요',
        'Add new Calendar' => '새 캘린더 추가',
        'Import Appointments' => '예약 Import',
        'Calendar Import' => '캘린더 Import',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 달력을 가져올 수 있습니다. 캘린더 관리 모듈에서 내 보낸 파일은 .yml 형식이어야합니다.',
        'Overwrite existing entities' => '덮어쓰시겠습니까?',
        'Upload calendar configuration' => '캘린더 설정 업로드',
        'Import Calendar' => '캘린더 Import',
        'Filter for Calendars' => '',
        'Filter for calendars' => '캘린터 필터',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '그룹 필드에 따라 시스템에서 권한 수준에 따라 사용자가 캘린더에 액세스 할 수 있습니다.',
        'Read only: users can see and export all appointments in the calendar.' =>
            '읽기 전용 : 사용자는 캘린더의 모든 약속을보고 내보낼 수 있습니다.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '다음으로 이동 : 사용자는 캘린더에서 약속을 수정할 수 있지만 캘린더 선택은 변경하지 않습니다.',
        'Create: users can create and delete appointments in the calendar.' =>
            '만들기 : 사용자는 달력에서 약속을 만들고 삭제할 수 있습니다.',
        'Read/write: users can manage the calendar itself.' => '읽기 / 쓰기 : 사용자는 캘린더 자체를 관리 할 수 ​​있습니다.',
        'Group' => '그룹',
        'Changed' => '변경됨',
        'Created' => '생성됨',
        'Download' => '다운로드',
        'URL' => 'URL',
        'Export calendar' => '캘린더 Export',
        'Download calendar' => '캘린더 다운로드',
        'Copy public calendar URL' => '퍼블릭 캘린더 URL 복사',
        'Calendar' => '캘린더',
        'Calendar name' => '캘린더 이름',
        'Calendar with same name already exists.' => '같은 이름의 캘린더가 존재합니다.',
        'Color' => '색깔',
        'Permission group' => '권한 그룹',
        'Ticket Appointments' => '티켓 예약',
        'Rule' => '규칙',
        'Remove this entry' => '이것을 삭제',
        'Remove' => '삭제',
        'Start date' => '시작일',
        'End date' => '종료일',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '아래의 옵션을 사용하여 티켓 예약이 자동으로 생성되도록 범위를 좁 힙니다.',
        'Queues' => '대기열',
        'Please select a valid queue.' => '올바른 대기열을 선택하십시오.',
        'Search attributes' => '검색 속성',
        'Add entry' => '항목 추가',
        'Add' => '추가',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '티켓 데이터를 기반으로이 달력에 자동 약속을 만들기위한 규칙을 정의하십시오.',
        'Add Rule' => '규칙 추가',
        'Submit' => '제출',

        # Template: AdminAppointmentImport
        'Appointment Import' => '약속 가져오기',
        'Go back' => '뒤로',
        'Uploaded file must be in valid iCal format (.ics).' => '업로드 된 파일은 유효한 iCal 형식 (.ics)이어야합니다.',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '원하는 캘린더가 여기에 표시되지 않으면 \'만들기\'권한이 있는지 확인하십시오.',
        'Upload' => '업로드',
        'Update existing appointments?' => '기존 약속을 업데이트 하시겠습니까?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '동일한 UniqueID를 가진 달력의 기존 약속은 모두 덮어 쓰여집니다.',
        'Upload calendar' => '캘린터 업로드',
        'Import appointments' => '약속 Import',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '약속 알림 관리',
        'Add Notification' => '알림 추가',
        'Edit Notification' => '알림 수정',
        'Export Notifications' => '알림 Export',
        'Filter for Notifications' => '알림 필터',
        'Filter for notifications' => '알림 필터',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '여기서 구성 파일을 업로드하여 약속 알림을 시스템에 가져올 수 있습니다. 파일은 약속 알림 모듈에서 내 보낸 .yml 형식이어야합니다.',
        'Overwrite existing notifications?' => '존재하는 알림을 덮어쓰시겠습니까?',
        'Upload Notification configuration' => '알림 설정을 업로드하시겠습니까?',
        'Import Notification configuration' => '알림 설정 Import',
        'List' => '목록',
        'Delete' => '삭제',
        'Delete this notification' => '이 알림 삭제',
        'Show in agent preferences' => '상담원 환경설정에서 보기',
        'Agent preferences tooltip' => '상담원 환경설정 툴팁',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '이 메시지는 상담원 기본 설정 화면에이 알림에 대한 툴팁으로 표시됩니다.',
        'Toggle this widget' => '이 위젯을 토글',
        'Events' => '이벤트',
        'Event' => '이벤트',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '여기에서이 알림을 실행할 이벤트를 선택할 수 있습니다. 추가 기준 필터를 적용하여 특정 기준에 대한 약속 만 보낼 수 있습니다.',
        'Appointment Filter' => '약속 필터',
        'Type' => '타입',
        'Title' => '제목',
        'Location' => '위치',
        'Team' => '팀',
        'Resource' => '자원',
        'Recipients' => '접수자',
        'Send to' => '보내기',
        'Send to these agents' => '선택 상담원들에게 보내기',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => '모든 역할 멤버들에게 보내기',
        'Send on out of office' => '부재중인 사람들에게 보내기',
        'Also send if the user is currently out of office.' => '사용자가 현재 부재중인 경우에도 보내기',
        'Once per day' => '하루 한번',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '선택한 날짜를 사용하여 약속을 하루에 한 번만 알립니다.',
        'Notification Methods' => '알림 방법',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '이러한 알림을 각받는 사람에게 보내는 데 사용할 수있는 방법입니다. 아래에서 하나 이상의 방법을 선택하십시오.',
        'Enable this notification method' => '알림 방법 사용',
        'Transport' => '전송',
        'At least one method is needed per notification.' => '알림 당 하나 이상의 메소드가 필요합니다.',
        'Active by default in agent preferences' => '에이전트 환경 설정에서 기본적으로 활성화 됨',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '이것은 자신의 환경 설정에서이 통지에 대해 아직 선택하지 않은 할당 된 수신자 에이전트의 기본값입니다. 이 상자가 활성화되면 해당 에이전트에 알림이 전송됩니다.',
        'This feature is currently not available.' => '현재 이 기능을 사용할 수 없습니다.',
        'Upgrade to %s' => '%s (으)로 업그레이드',
        'Please activate this transport in order to use it.' => '사용하려면이 운송을 활성화하십시오.',
        'No data found' => '데이터가 없습니다.',
        'No notification method found.' => '알림 방법이 없습니다.',
        'Notification Text' => '알림 내용',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '이 언어는 시스템에 없거나 사용 가능하지 않습니다. 이 알림 텍스트는 더 이상 필요하지 않은 경우 삭제할 수 있습니다.',
        'Remove Notification Language' => '알림 언어 삭제',
        'Subject' => '제목',
        'Text' => '본문',
        'Message body' => '메시지 본문',
        'Add new notification language' => '새 알림 언어 추가',
        'Save Changes' => '변경 저장',
        'Tag Reference' => '태그 참조',
        'Notifications are sent to an agent.' => '통지는 에이전트로 전송됩니다.',
        'You can use the following tags' => '다음 태그를 사용할 수 있습니다.',
        'To get the first 20 character of the appointment title.' => '약속 제목의 처음 20자를 얻습니다.',
        'To get the appointment attribute' => '약속 특성을 얻으려면',
        ' e. g.' => 'e. g.',
        'To get the calendar attribute' => '달력 속성을 가져 오려면',
        'Attributes of the recipient user for the notification' => '알림에 대한 수신자 사용자의 속성',
        'Config options' => '구성 옵션',
        'Example notification' => '알림 예',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '추가받는 사람 전자 메일 주소',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '고객이 볼 수있는 기사',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '알림이 고객에게 발송되거나 추가 이메일 주소 인 경우 기사가 생성됩니다.',
        'Email template' => '이메일 템플릿',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '이 템플릿을 사용하여 전체 전자 메일을 생성합니다 (HTML 전자 메일 만 해당).',
        'Enable email security' => '이메일 보안 사용',
        'Email security level' => '이메일 보안 수준',
        'If signing key/certificate is missing' => '서명 키 / 인증서가 누락 된 경우',
        'If encryption key/certificate is missing' => '암호화 키 / 인증서가 누락 된 경우',

        # Template: AdminAttachment
        'Attachment Management' => '첨부파일 관리',
        'Add Attachment' => '첨부파일 추가',
        'Edit Attachment' => '첨부파일 편집',
        'Filter for Attachments' => '첨부파일 필터링',
        'Filter for attachments' => '첨부파일 필터링',
        'Filename' => '파일 이름',
        'Download file' => '파일 다운로드',
        'Delete this attachment' => '첨부파일 삭제',
        'Do you really want to delete this attachment?' => '첨부 파일을 정말로 삭제 하시겠습니까?',
        'Attachment' => '부착',

        # Template: AdminAutoResponse
        'Auto Response Management' => '자동 응답 관리',
        'Add Auto Response' => '자동 응답 추가',
        'Edit Auto Response' => '자동 응답 수정',
        'Filter for Auto Responses' => '자동 응답 필터링',
        'Filter for auto responses' => '자동 응답 필터링',
        'Response' => '응답',
        'Auto response from' => '님의 자동 응답',
        'Reference' => '참고',
        'To get the first 20 character of the subject.' => '주제의 처음 20자를 얻습니다.',
        'To get the first 5 lines of the email.' => '전자 메일의 처음 5 줄을 가져옵니다.',
        'To get the name of the ticket\'s customer user (if given).' => '티켓의 고객 사용자 이름을 알려주는 것입니다 (주어진 경우).',
        'To get the article attribute' => '기사 속성을 얻으려면',
        'Options of the current customer user data' => '현재 고객 사용자 데이터의 옵션',
        'Ticket owner options' => '티켓 소유자 옵션',
        'Ticket responsible options' => '티켓 책임 옵션',
        'Options of the current user who requested this action' => '이 작업을 요청한 현재 사용자의 옵션',
        'Options of the ticket data' => '티켓 데이터의 옵션',
        'Options of ticket dynamic fields internal key values' => '티켓 동적 필드 내부 키 값의 옵션',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '티켓 동적 필드의 옵션은 드롭 다운 및 다중선택 필드에 유용한 값을 표시합니다.',
        'Example response' => '응답 예',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '클라우드 서비스 관리',
        'Support Data Collector' => '지원 데이터 수집기',
        'Support data collector' => '지원 데이터 수집기',
        'Hint' => '힌트',
        'Currently support data is only shown in this system.' => '현재 지원되는 데이터는이 시스템에만 표시됩니다.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => '구성',
        'Send support data' => '지원 데이터 보내기',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => '최신 정보',
        'System Registration' => '시스템 등록',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '이 시스템 등록',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '시스템 등록은 시스템에서 사용할 수 없습니다. 구성을 확인하십시오.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'OTOBO 클라우드 서비스를 사용하려면 시스템을 등록해야합니다.',
        'Register this system' => '이 시스템 등록',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '%s와 안전하게 통신 할 수있는 클라우드 서비스를 구성 할 수 있습니다.',
        'Available Cloud Services' => '사용가능한 클라우드 서비스',

        # Template: AdminCommunicationLog
        'Communication Log' => '통신 로그',
        'Time Range' => '',
        'Show only communication logs created in specific time range.' =>
            '특정 시간 범위에서 생성 된 통신 로그 만 표시합니다.',
        'Filter for Communications' => '',
        'Filter for communications' => '통신용 필터',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '이 화면에서 들어오고 나가는 통신에 대한 개요를 볼 수 있습니다.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '열 머리글을 클릭하여 열의 정렬 및 순서를 변경할 수 있습니다.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '다른 항목을 클릭하면 메시지에 대한 세부 화면으로 리디렉션됩니다.',
        'Status for: %s' => '상태 : %s',
        'Failing accounts' => '실패한 계정',
        'Some account problems' => '일부 계정 문제',
        'No account problems' => '계정 문제 없음',
        'No account activity' => '계정 활동 없음',
        'Number of accounts with problems: %s' => '문제가있는 계정 수 : %s',
        'Number of accounts with warnings: %s' => '경고가있는 계정 수 : %s',
        'Failing communications' => '통신 실패',
        'No communication problems' => '통신 문제 없음',
        'No communication logs' => '통신 로그 없음',
        'Number of reported problems: %s' => '보고 된 문제 수 : %s',
        'Open communications' => '열린 커뮤니케이션',
        'No active communications' => '활성 통신 없음',
        'Number of open communications: %s' => '열린 통신의 수 : %s',
        'Average processing time' => '평균 처리 시간',
        'List of communications (%s)' => '통신 목록 (%s)',
        'Settings' => '설정',
        'Entries per page' => '페이지당 갯수',
        'No communications found.' => '통신이 없습니다.',
        '%s s' => '%s 개',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '계정 상태',
        'Back to overview' => '',
        'Filter for Accounts' => '',
        'Filter for accounts' => '계정 필터링',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '옆 머리글을 클릭하여 해당 열의 정렬 및 순서를 변경할 수 있습니다. ',
        'Account status for: %s' => '다음 계정 상태 : %s',
        'Status' => '상태',
        'Account' => '계정',
        'Edit' => '수정',
        'No accounts found.' => '계정이 없습니다.',
        'Communication Log Details (%s)' => '통신 로그 정보 (%s)',
        'Direction' => '방향',
        'Start Time' => '시작 시간',
        'End Time' => '종료 시간',
        'No communication log entries found.' => '통신 로그 항목을 찾을 수 없습니다.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '지속',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => '우선순위',
        'Module' => '기준 치수',
        'Information' => '정보',
        'No log entries found.' => '로그 항목을 찾을 수 없습니다.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '%s에서 시작된 %s 통신에 대한 상세보기',
        'Filter for Log Entries' => '로그 항목 필터링',
        'Filter for log entries' => '로그 항목 필터링',
        'Show only entries with specific priority and higher:' => '특정 우선 순위 이상의 항목만 표시:',
        'Communication Log Overview (%s)' => '통신 로그 개요 (%s)',
        'No communication objects found.' => '통신 개체를 찾을 수 없습니다.',
        'Communication Log Details' => '통신 로그 세부 정보',
        'Please select an entry from the list.' => '목록에서 항목을 선택하십시오.',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => '데이터 연락처',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => '검색 결과로 돌아가기',
        'Select' => '선택',
        'Search' => '검색',
        'Wildcards like \'*\' are allowed.' => '\'*\'와 같은 와일드 카드는 허용됩니다.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => '유효한',

        # Template: AdminCustomerCompany
        'Customer Management' => '고객 관리',
        'Add Customer' => '고객 추가',
        'Edit Customer' => '고객 편집',
        'List (only %s shown - more available)' => '목록 ( %s 보여짐 - 더있음)',
        'total' => '총',
        'Please enter a search term to look for customers.' => '고객을 찾으려면 검색어를 입력하십시오.',
        'Customer ID' => '고객 ID',
        'Please note' => '주의 사항',
        'This customer backend is read only!' => '이 고객 백엔드는 읽기전용입니다!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => '고객-그룹 관계 관리',
        'Notice' => '공지',
        'This feature is disabled!' => '부가기능이 불가능으로 설정됨!',
        'Just use this feature if you want to define group permissions for customers.' =>
            '고객에 대한 그룹 권한을 정의하려면 이 기능을 사용하십시오.',
        'Enable it here!' => '여기에서 사용하도록 설정하십시오!',
        'Edit Customer Default Groups' => '고객 기본 그룹 편집',
        'These groups are automatically assigned to all customers.' => '이 그룹은 모든 고객에게 자동으로 할당됩니다.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '"CustomerGroupCompanyAlwaysGroups "구성 설정을 통해 이러한 그룹을 관리 할 수 ​​있습니다.',
        'Filter for Groups' => '그룹 필터링',
        'Select the customer:group permissions.' => '고객 : 그룹 권한을 선택하십시오.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '아무 것도 선택하지 않으면이 그룹에 사용 권한이 없습니다 (티켓 고객에게 제공되지 않습니다).',
        'Search Results' => '검색결과',
        'Customers' => '고객',
        'Groups' => '그룹',
        'Change Group Relations for Customer' => '고객과 그룹의 관계를 변경',
        'Change Customer Relations for Group' => '그룹과 고객의 관계를 변경',
        'Toggle %s Permission for all' => '%s 토글 모든 권한',
        'Toggle %s permission for %s' => '%s에 대한 %s 권한을 토글합니다.',
        'Customer Default Groups:' => '고객 기본 그룹 :',
        'No changes can be made to these groups.' => '이 그룹은 변경할 수 없습니다.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => '이 그룹/대기열에 있는 티켓에 대한 읽기 전용 액세스.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            '이 그룹/대기열의 티켓에 대한 전체 읽기 및 쓰기 액세스',

        # Template: AdminCustomerUser
        'Customer User Management' => '고객 사용자 관리',
        'Add Customer User' => '고객 사용자 추가',
        'Edit Customer User' => '고객 사용자 편집',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '고객 사용자는 고객 기록을 보유하고 고객 패널을 통해 로그인해야 합니다.',
        'List (%s total)' => '목록 (%s 총)',
        'Username' => '사용자 이름',
        'Email' => '이메일',
        'Last Login' => '마지막 로그인',
        'Login as' => '다음 계정으로 로그인',
        'Switch to customer' => '고객 전환',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '이 고객 백엔드는 읽기 전용이지만 고객 사용자 기본 설정은 변경할 수 있습니다!',
        'This field is required and needs to be a valid email address.' =>
            '이 필드는 필수이며 올바른 이메일 주소여야 합니다.',
        'This email address is not allowed due to the system configuration.' =>
            '이 이메일 주소는 시스템 구성으로 인해 허용되지 않습니다.',
        'This email address failed MX check.' => '이 이메일 주소는 mx 확인에 실패했습니다.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS 문제, 구성 및 오류로그를 확인하십시오.',
        'The syntax of this email address is incorrect.' => '이 전자 메일 주소의 구문이 잘못되었습니다.',
        'This CustomerID is invalid.' => '이 CustomerID는 유효하지 않습니다.',
        'Effective Permissions for Customer User' => '고객 사용자를 위한 효과적인 권한',
        'Group Permissions' => '그룹 사용 권한',
        'This customer user has no group permissions.' => '이 고객 사용자에게는 그룹 권한이 없습니다.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '위의 표는 고객 사용자에 대한 효과적인 그룹 권한을 보여줍니다. 매트릭스는 모든 상속 된 권한 (예 : 고객 그룹을 통해)을 고려합니다. 참고 :이 표는 제출하지 않고이 양식의 변경 사항을 고려하지 않습니다.',
        'Customer Access' => '고객 엑세스',
        'Customer' => '고객',
        'This customer user has no customer access.' => '이 고객 사용자에게는 고객 액세스 권한이 없습니다.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '위의 표는 권한 컨텍스트를 통해 고객 사용자에 대해 부여 된 고객 액세스를 보여줍니다. 행렬은 모든 상속 된 액세스 (예 : 고객 그룹을 통해)를 고려합니다. 참고 :이 표는 제출하지 않고이 양식의 변경 사항을 고려하지 않습니다',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '고객 사용자 - 고객 관계 관리',
        'Select the customer user:customer relations.' => '고객 사용자 : 고객 관계를 선택하십시오.',
        'Customer Users' => '고객 사용자',
        'Change Customer Relations for Customer User' => '고객 사용자를 위한 고객관계 변경',
        'Change Customer User Relations for Customer' => '고객의 고객 사용자 관계 변경',
        'Toggle active state for all' => '모든 사용자의 활성 상태를 토글합니다.',
        'Active' => '유효한',
        'Toggle active state for %s' => '%s의 활성 상태 토글',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '고객 사용자 - 그룹 관계 관리',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '고객 사용자에 대한 그룹 권한을 정의하려면 이 기능을 사용하십시오.',
        'Edit Customer User Default Groups' => '고객 사용자 기본 그룹 편집',
        'These groups are automatically assigned to all customer users.' =>
            '이 그룹은 모든 고객 사용자에게 자동으로 할당됩니다.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '"CustomerGroupAlwaysGroups"구성 설정을 통해 이러한 그룹을 관리 할 수 ​​있습니다.',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '고객 사용자 - 그룹 권한을 선택하십시오.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '아무 것도 선택하지 않으면이 그룹에 권한이 없습니다 (티켓을 고객 사용자가 사용할 수 없음).',
        'Customer User Default Groups:' => '고객 사용자 기본 그룹 : ',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => '기본 서비스 수정',
        'Filter for Services' => '서비스 필터링',
        'Filter for services' => '서비스 필터링',
        'Services' => '서비스',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '동적 필드 관리',
        'Add new field for object' => '객체에 대한 새 필드 추가',
        'Filter for Dynamic Fields' => '동적 필드 필터링',
        'Filter for dynamic fields' => '동적 필드 필터링',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => '데이터베이스',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '이 동적 필드에 대해 외부 데이터베이스를 구성 가능한 데이터 소스로 사용하십시오.',
        'Web service' => '웹 서비스',
        'External web services can be configured as data sources for this dynamic field.' =>
            '외부 웹 서비스는 이 동적 필드의 데이터 소스로 구성될 수 있습니다.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '이 기능을 사용하면 데이터가 있는 연락처를 티켓에 추가 할 수 있습니다.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '새 필드를 추가하려면 객체 목록 중 하나에서 필드 유형을 선택하십시오. 객체는 필드의 경계를 정의하며 필드 작성 후에는 변경할 수 없습니다.',
        'Dynamic Fields List' => '동적 필드 목록',
        'Dynamic fields per page' => '페이지 당 동적 필드',
        'Label' => '상표',
        'Order' => '주문',
        'Object' => '목적',
        'Delete this field' => '이 입력란을 삭제하십시오.',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '동적 필드',
        'Go back to overview' => '개요로 돌아가기',
        'General' => '일반',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '이 필드는 필수이며 값은 영숫자여야 합니다.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '고유해야하며 영문자의 숫자만 사용할 수 있습니다.',
        'Changing this value will require manual changes in the system.' =>
            '이 값을 변경하면 시스템에서 수동으로 변경해야 합니다.',
        'This is the name to be shown on the screens where the field is active.' =>
            '필드가 활성화된 화면에 표시할 이름 입니다.',
        'Field order' => '필드 주문',
        'This field is required and must be numeric.' => '이 필드는 필수이며 숫자여야 합니다.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '이 필드가 활성화 된 화면에 표시되는 순서입니다.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '이 항목을 무효화 할 수 없으므로 모든 구성 설정을 미리 변경해야 합니다.',
        'Field type' => '필드 유형',
        'Object type' => '객체 유형',
        'Internal field' => '내부 필드',
        'This field is protected and can\'t be deleted.' => '이 필드는 보호되어 있으며 삭제할 수 없습니다.',
        'This dynamic field is used in the following config settings:' =>
            '이 동적 필드는 다음 구성 설정에서 사용됩니다.',
        'Field Settings' => '필드 설정',
        'Default value' => '기본값',
        'This is the default value for this field.' => '이 필드의 기본값입니다.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => '키',
        'Value' => '값',
        'Remove value' => '값 삭제',
        'Add Field' => '',
        'Add value' => '값 추가',
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
        'Translatable values' => '번역 가능한 값',
        'If you activate this option the values will be translated to the user defined language.' =>
            '이 옵션을 활성화하면 값이 사용자 정의 언어로 변환됩니다.',
        'Note' => '노트',
        'You need to add the translations manually into the language translation files.' =>
            '언어 변환 파일에 수동으로 번역을 추가해야 합니다.',

        # Template: AdminDynamicFieldDB
        'Possible values' => '가능한 값',
        'Datatype' => '',
        'Filter' => '필터',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => '링크 표시',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '개요 및 확대 / 축소 화면에서 필드 값에 대한 선택적 HTTP 링크를 지정할 수 있습니다.',
        'Example' => '예',
        'Link for preview' => '미리보기 링크',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '입력되면이 URL은 미리보기로 사용되며이 링크는 티켓 확대시 표시됩니다. 이 기능을 사용하려면 위의 일반 URL 입력란도 채워야합니다.',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => '포트',
        'Table / View' => '',
        'User' => '사용자',
        'Password' => '암호',
        'Identifier' => '식별자',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => '다중선택',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '기본 날짜 차이',
        'This field must be numeric.' => '이 필드는 숫자여야 합니다.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '필드 기본값 (예 : 3600 또는 -60)을 계산하는 NOW와의 차이 (초)입니다.',
        'Define years period' => '년 기간 정의',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '이 기능을 활성화하여 필드의 연도 부분에 표시 할 고정 된 미래 범위 (미래 및 과거)를 정의합니다.',
        'Years in the past' => '과거의 세월',
        'Years in the past to display (default: 5 years).' => '과거의 연도 (기본값 : 5 년).',
        'Years in the future' => '미래의 해',
        'Years in the future to display (default: 5 years).' => '장래에 표시 할 연도 (기본값 : 5 년).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => '날짜 입력 제한',
        'Here you can restrict the entering of dates of tickets.' => '여기에서 티켓 날짜 입력을 제한할 수 있습니다.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => '값 추가',
        'Add empty value' => '빈 값 추가',
        'Activate this option to create an empty selectable value.' => '빈 선택 가능 값을 작성하려면 이 옵션을 활성화 하십시오.',
        'Tree View' => '트리 보기',
        'Activate this option to display values as a tree.' => '값을 트리로 표시하려면 이 옵션을 활성화 하십시오.',

        # Template: AdminDynamicFieldText
        'Number of rows' => '행 수',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '편집 모드에서이 필드의 높이를 (줄 단위로) 지정하십시오.',
        'Number of cols' => '열 수',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '편집 모드에서이 필드의 너비 (문자)를 지정하십시오.',
        'Check RegEx' => 'RegEx 확인',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '여기서 정규 표현식을 지정하여 값을 확인할 수 있습니다. 정규 표현식은 xms 수정 자로 실행됩니다.',
        'RegEx' => '정규 표현식',
        'Invalid RegEx' => '정규식이 잘못되었습니다.',
        'Error Message' => '에러 메시지',
        'Add RegEx' => '정규 표현식 추가',

        # Template: AdminDynamicFieldTitle
        'Template' => '템플릿',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => '크기',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => '이 필드는 필수 항목입니다.',
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
        'Admin Message' => '관리자 메시지',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '이 모듈을 사용하여 관리자는 에이전트, 그룹 또는 역할 구성원에게 메시지를 보낼 수 있습니다.',
        'Create Administrative Message' => '관리 메시지 작성',
        'Your message was sent to' => '귀하의 메시지를 보냈습니다.',
        'From' => '에서',
        'Send message to users' => '사용자에게 메시지 보내기',
        'Send message to group members' => '그룹 회원에게 메시지 보내기',
        'Group members need to have permission' => '그룹 회원은 허가를 받아야합니다.',
        'Send message to role members' => '역할 멤버에게 메시지 보내기',
        'Also send to customers in groups' => '또한 그룹으로 고객에게 보내기',
        'Body' => '신체',
        'Send' => '보내다',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => '마지막 실행',
        'Run Now!' => '지금 실행!',
        'Delete this task' => '이 작업 삭제',
        'Run this task' => '이 작업 실행',
        'Job Settings' => '작업 설정',
        'Job name' => '작업 이름',
        'The name you entered already exists.' => '입렵한 이름이 이미 있습니다.',
        'Automatic Execution (Multiple Tickets)' => '자동 실행 (다중 티켓)',
        'Execution Schedule' => '실행 일정',
        'Schedule minutes' => '분 일정',
        'Schedule hours' => '시간 계획',
        'Schedule days' => '하루 일정',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            '현재 이 일반 에이전트 작업은 자동으로 실행되지 않습니다.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '자동 실행을 사용하려면 분, 시간 및 일 중 적어도 하나의 값을 선택하십시오!',
        'Event Based Execution (Single Ticket)' => '이벤트 기반 실행 (단일 티켓)',
        'Event Triggers' => '이벤트 트리거',
        'List of all configured events' => '구성된 모든 이벤트 목록',
        'Delete this event' => '이 일정 삭제',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '주기적 실행에 추가적으로 또는 대신에 이 작업을 트리거 할 티켓 이벤트를 정의할 수 있습니다.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '티켓 이벤트가 발생하면 티켓이 일치하는지 확인하기 위해 티켓 필터가 적용됩니다. 그런 다음에 만 해당 티켓에서 작업이 실행됩니다.',
        'Do you really want to delete this event trigger?' => '이 이벤트 트리거를 정말로 삭제 하시겠습니까?',
        'Add Event Trigger' => '이벤트 트리거 추가',
        'To add a new event select the event object and event name' => '새 이벤트를 추가하려면 이벤트 객체와 이벤트 이름을 선택하십시오.',
        'Select Tickets' => '티켓 선택',
        '(e. g. 10*5155 or 105658*)' => '(예를 들어, 10 * 5155 또는 105658 *)',
        '(e. g. 234321)' => '(예를 들어, 234321)',
        'Customer user ID' => '고객 사용자 ID',
        '(e. g. U5150)' => '(예를 들어, U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '기사에서 전체 텍스트 검색 (예 : "Mar * in"또는 "Baue *").',
        'To' => '수신',
        'Cc' => '참조',
        'Service' => '서비스',
        'Service Level Agreement' => '서비스 레벨 동의',
        'Queue' => '대기열',
        'State' => '상태',
        'Agent' => '상담원',
        'Owner' => '소유자',
        'Responsible' => '책임있는',
        'Ticket lock' => '티켓 잠금',
        'Dynamic fields' => '동적 필드',
        'Add dynamic field' => '',
        'Create times' => '생성시간',
        'No create time settings.' => '생성 시간이 설정되지 않았습니다.',
        'Ticket created' => '티켓이 생성되었습니다.',
        'Ticket created between' => '티켓 생성됨, 기간',
        'and' => '그리고',
        'Last changed times' => '최종 변경 시간',
        'No last changed time settings.' => '마지막으로 변경된 시간 설정이 없습니다.',
        'Ticket last changed' => '마지막으로 변경된 티켓',
        'Ticket last changed between' => '마지막으로 변경된 티켓',
        'Change times' => '시간 변경',
        'No change time settings.' => '변경 시간 설정이 없습니다.',
        'Ticket changed' => '티켓 변경됨',
        'Ticket changed between' => '티켓 변경 사이',
        'Close times' => '끝나는 시간',
        'No close time settings.' => '가까운 시간 설정이 없습니다.',
        'Ticket closed' => '티켓이 폐쇄되었습니다.',
        'Ticket closed between' => '사이에 폐쇄된 티켓',
        'Pending times' => '보류 시간',
        'No pending time settings.' => '대기중인 시간 설정이 없습니다.',
        'Ticket pending time reached' => '티켓 대기 시간에 도달했습니다.',
        'Ticket pending time reached between' => '티켓 대기 시간 사이',
        'Escalation times' => '에스컬레이션 시간',
        'No escalation time settings.' => '에스컬레이션 시간 설정이 없습니다.',
        'Ticket escalation time reached' => '티켓 확대 시간 도달',
        'Ticket escalation time reached between' => '티켓 이관 시간에 도달했습니다.',
        'Escalation - first response time' => '에스컬레이션 - 첫 번째 응답 시간',
        'Ticket first response time reached' => '첫 번째 응답 시간에 도달한 티켓',
        'Ticket first response time reached between' => '첫 번째 응답 시간은 다음 사이에 도달했습니다.',
        'Escalation - update time' => '이관 - 업데이트 시간',
        'Ticket update time reached' => '티켓 업데이트 시간에 도달했습니다.',
        'Ticket update time reached between' => '티켓 업데이트 시간이 사이에 도달했습니다.',
        'Escalation - solution time' => '에스컬레이션 - 솔루션 시간',
        'Ticket solution time reached' => '티켓 솔루션 시간 도달',
        'Ticket solution time reached between' => '티켓 솔루션 시간이 ~ 사이에 도달했습니다.',
        'Archive search option' => '아카이브 검색 옵션',
        'Update/Add Ticket Attributes' => '티켓 속성 업데이트 / 추가',
        'Set new service' => '새 서비스 설정',
        'Set new Service Level Agreement' => '새로운 서비스 수준 계약 설정',
        'Set new priority' => '새로운 우선 순위 설정',
        'Set new queue' => '새 대기열 설정',
        'Set new state' => '새 상태 설정',
        'Pending date' => '대기 중인 날짜',
        'Set new agent' => '새 에이전트 설정',
        'new owner' => '새 주인',
        'new responsible' => '새로운 책임',
        'Set new ticket lock' => '새 티켓 잠금 설정',
        'New customer user ID' => '신규 고객 사용자 ID',
        'New customer ID' => '신규 고객 ID',
        'New title' => '새 직함',
        'New type' => '새로운 유형',
        'Archive selected tickets' => '선택한 티켓 보관 처리',
        'Add Note' => '메모 추가',
        'Visible for customer' => '고객에게 공개',
        'Time units' => '시간 단위',
        'Execute Ticket Commands' => '티켓 명령 실행',
        'Send agent/customer notifications on changes' => '변경 사항에 대한 상담원 / 고객 알림 보내기',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            '이 명령이 실행됩니다. ARG [0]이 티켓 번호입니다. ARG [1] 티켓 ID.',
        'Delete tickets' => '티켓 삭제',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '경고 : 영향을받는 모든 티켓이 데이터베이스에서 제거되어 복원 할 수 없습니다!',
        'Execute Custom Module' => '사용자 정의 모듈 실행',
        'Param %s key' => 'Param %s 키',
        'Param %s value' => '매개 변수 %s 값',
        'Results' => '결과',
        '%s Tickets affected! What do you want to do?' => '영향을받은 티켓 %s 개! 뭐하고 싶어?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '경고 : DELETE 옵션을 사용했습니다. 삭제 된 티켓은 모두 삭제됩니다!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '경고 : %s개의 티켓이 영향을 받지만, 한 번의 작업 실행 중에 %s의 수정 만있을 수 있습니다!',
        'Affected Tickets' => '영향받은 티켓',
        'Age' => '생성이후',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface 웹 서비스 관리',
        'Web Service Management' => '웹서비스 관리',
        'Debugger' => '디버거',
        'Go back to web service' => '웹서비스로 돌아가기',
        'Clear' => '제거',
        'Do you really want to clear the debug log of this web service?' =>
            '이 웹 서비스의 디버그 로그를 정말로 지우시겠습니까?',
        'Request List' => '요청 목록',
        'Time' => '시간',
        'Communication ID' => '통신 ID',
        'Remote IP' => '원격 IP',
        'Loading' => '로딩중',
        'Select a single request to see its details.' => '세부 정보를 보려면 단일 요청을 선택하십시오.',
        'Filter by type' => '유형별 필터링',
        'Filter from' => '필터 : ',
        'Filter to' => '~에 필터링',
        'Filter by remote IP' => '원격 IP로 필터링',
        'Limit' => '한도',
        'Refresh' => '새롭게 하다',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'ErrorHandling 추가',
        'Edit ErrorHandling' => 'ErrorHandling 편집',
        'Do you really want to delete this error handling module?' => '이 오류 처리 모듈을 정말로 삭제 하시겠습니까?',
        'All configuration data will be lost.' => '모든 구성 데이터가 손실됩니다.',
        'General options' => '일반 옵션',
        'The name can be used to distinguish different error handling configurations.' =>
            '이 이름은 다른 오류 처리 구성을 구분하는데 사용할 수 있습니다.',
        'Please provide a unique name for this web service.' => '이 웹 서비스에 고유한 이름을 입력하십시오.',
        'Error handling module backend' => '오류 처리 모듈 백엔드',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            '이 OTOBO 오류 처리 백엔드 모듈은 내부적으로 호출되어 오류 처리 메커니즘을 처리합니다.',
        'Processing options' => '처리 옵션',
        'Configure filters to control error handling module execution.' =>
            '오류 처리 모듈 실행을 제어하는 필터를 구성합니다.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '모든 구성된 필터 (있는 경우)와 일치하는 요청 만 모듈 실행을 트리거합니다.',
        'Operation filter' => '작동 필터',
        'Only execute error handling module for selected operations.' => '선택한 작업에 대해서만 오류 처리 모듈을 실행하십시오.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '주 : 들어오는 요청 데이터를 수신하는 중 발생한 오류에 대해서는 조작이 결정되지 않습니다. 이 오류 단계와 관련된 필터는 작동 필터를 사용하지 않아야합니다.',
        'Invoker filter' => '호출자 필터',
        'Only execute error handling module for selected invokers.' => '선택한 호출자에 대해서만 오류 처리 모듈을 실행하십시오.',
        'Error message content filter' => '오류 메시지 내용 필터',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '오류 처리 모듈을 실행할 오류 메시지를 제한하는 정규 표현식을 입력하십시오.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '오류 메시지 제목과 데이터 (디버거 오류 항목에서 볼 수 있음)는 일치하는 것으로 간주됩니다.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '오류 단계 필터',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '특정 처리 단계에서 발생하는 오류에 대해서만 오류 처리 모듈을 실행하십시오.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '예 : 나가는 데이터에 대한 매핑을 적용 할 수없는 오류 만 처리하십시오.',
        'Error code' => '에러 코드',
        'An error identifier for this error handling module.' => '이 오류 처리 모듈의 오류 식별자입니다.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '이 식별자는 XSLT-Mapping에서 사용할 수 있으며 디버거 출력에 표시됩니다.',
        'Error message' => '에러 메시지',
        'An error explanation for this error handling module.' => '이 오류 처리 모듈에 대한 오류 설명.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '이 메시지는 XSLT-Mapping에서 사용할 수 있으며 디버거 출력에 표시됩니다.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '모듈이 실행 된 후 처리가 중단되어야하는지, 남은 모듈을 모두 건너 뛰는 지 또는 같은 백엔드의 모듈 만 건너 뛰는지를 정의하십시오.',
        'Default behavior is to resume, processing the next module.' => '기본 동작은 다음 모듈을 다시 시작하여 처리하는 것입니다.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '이 모듈을 사용하여 실패한 요청에 대한 스케줄 된 재시도를 구성할 수 있습니다.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'GenericInterface 웹 서비스의 기본 동작은 각 요청을 정확히 한 번 보내고 오류가 발생하면 다시 예약하지 않는 것입니다.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '개별 요청에 대해 재시도 일정을 설정할 수있는 둘 이상의 모듈이 실행되면 마지막으로 실행 된 모듈이 신뢰할 수 있고 재시도 일정이 결정됩니다',
        'Request retry options' => '재시도 옵션 요청',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '재 시도 옵션은 요청이 오류 처리 모듈 실행을 유발할 때 (처리 옵션에 따라) 적용됩니다.',
        'Schedule retry' => '일정 다시 시도',
        'Should requests causing an error be triggered again at a later time?' =>
            '오류가 발생한 요청을 나중에 다시 트리거해야 합니까?',
        'Initial retry interval' => '초기 재시도 간격',
        'Interval after which to trigger the first retry.' => '첫 번째 다시 시도를 트리거할 간격입니다.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '주 :이 W 모든 재 시도 간격은 초기 요청에 대한 오류 핸들링 모듈 실행 시간으로합니다. ',
        'Factor for further retries' => '추가 재시도를 위한 요인',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '첫 번째 재 시도 후에도 요청이 오류를 리턴하면 후속 재시도가 동일한 간격 또는 증가 간격으로 트리거되는지 정의하십시오.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '예 : 초기 간격이 \'1 분\'이고 재시도 비율이 \'2\'인 요청을 초기에 10:00에 실행하면 재시도는 10:01 (1 분), 10:03 (2 * 1 = 2 분), 10:07 (2 * 2 = 4 분), 10:15 (2 * 4 = 8 분), ...',
        'Maximum retry interval' => '최대 재시도 간격',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '재 시도 간격 계수 \'1.5\'또는 \'2\'가 선택되면, 허용되는 최대 간격을 정의하여 바람직하지 않게 긴 간격을 방지 할 수 있습니다.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '최대 재시도 간격을 초과하도록 계산 된 간격은 그에 따라 자동으로 단축됩니다.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '예 : 초기 간격이 \'1 분\'인 요청을 10:00에 시작하고 \'2\'에서 다시 시도하고 \'5 분\'에서 최대 간격을 재 시도하면 재시도가 10:01 (1 분), 10 : 03 (2 분), 10:07 (4 분), 10:12 (8 => 5 분), 10:17, ',
        'Maximum retry count' => '최대 재시도 횟수',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '초기 요청을 계산하지 않고 실패한 요청을 버리기 전에 최대 재시도 횟수.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '예 : 초기 간격이 \'1 분\'인 요청을 10:00에 처음 시작하고 \'2\'에서 재시도 계수를, \'2\'에서 최대 재시도 계수를 재 시도하면 재시도가 10시 01 분 및 10시 02 분에만 트리거됩니다.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '참고 : 최대 재시도 횟수가 최대로 설정되고 이전에 도달하면 최대 재시도 횟수에 도달하지 못할 수도 있습니다.',
        'This field must be empty or contain a positive number.' => '이 필드는 비어 있거나 양수를 포함해야 합니다.',
        'Maximum retry period' => '최대 재시도 기간',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '실패한 요청이 재 시도되기 전까지의 최대 재 시도 시간 (초기 요청에 대한 오류 처리 모듈 실행 시간에 기반).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '최대 기간이 경과 한 후 (재시도 간격 계산에 따라) 일반적으로 트리거되는 재시도는 자동으로 최대 기간에 자동으로 트리거됩니다.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '예 : 초기 간격이 \'1 분\'인 요청을 10:00에 시작하고 \'2\'에서 재시도 계수를, \'30 분 \'에서 최대 재시도 기간을 시작하면 재시도가 10:01, 10:03, 10시 07 분, 10시 15 분 그리고 마침내 10시 31 분 => 10시 30 분.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '참고 : 최대 재시도 횟수가 구성되어 있고 이전에 도달 한 경우 최대 재시도 기간에 도달하지 못할 수 있습니다.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '호출자 추가',
        'Edit Invoker' => '호출자 편집',
        'Do you really want to delete this invoker?' => '이 호출자를 정말로 삭제 하시겠습니까?',
        'Invoker Details' => '호출자 세부 정보',
        'The name is typically used to call up an operation of a remote web service.' =>
            '이름은 일반적으로 원격 웹 서비스의 작업을 호출하는데 사용됩니다.',
        'Invoker backend' => '호출자 백엔드',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '이 OTOBO 호출자 백엔드 모듈은 원격 시스템에 전송할 데이터를 준비하고 응답 데이터를 처리하기 위해 호출됩니다.',
        'Mapping for outgoing request data' => '나가는 요청 데이터 매핑',
        'Configure' => '구성',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'OTOBO 호출자의 데이터는이 매핑에 의해 처리되어 원격 시스템이 예상하는 종류의 데이터로 변환됩니다.',
        'Mapping for incoming response data' => '들어오는 응답 데이터 매핑',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            '응답 데이터는이 매핑에 의해 처리되어 OTOBO의 호출자가 예상하는 종류의 데이터로 변환됩니다.',
        'Asynchronous' => '비동기식',
        'Condition' => '조건',
        'Edit this event' => '이 일정 수정',
        'This invoker will be triggered by the configured events.' => '이 호출자는 구성된 이벤트에 의해 트리거됩니다.',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '새 이벤트를 추가하려면 이벤트 객체와 이벤트 이름을 선택하고 "+"버튼을 클릭하십시오.',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '비동기 이벤트 트리거는 백그라운드에서 OTOBO Scheduler Daemon에 의해 처리됩니다 (권장).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '동기 이벤트 트리거는 웹 요청 중에 직접 처리됩니다.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '웹 서비스 %s의 GenericInterface Invoker 이벤트 설정',
        'Go back to' => '돌아가기',
        'Delete all conditions' => '모든 조건 삭제',
        'Do you really want to delete all the conditions for this event?' =>
            '이 이벤트의 모든 조건을 정말로 삭제하시겠습니까?',
        'General Settings' => '일반 설정',
        'Event type' => '이벤트 유형',
        'Conditions' => '조건',
        'Conditions can only operate on non-empty fields.' => '조건은 비어있지 않은 필드에서만 작동할 수 있습니다.',
        'Type of Linking between Conditions' => '조건 간 연결 유형',
        'Remove this Condition' => '이 조건 삭제',
        'Type of Linking' => '연결 유형',
        'Fields' => '전지',
        'Add a new Field' => '새 필드 추가',
        'Remove this Field' => '이 필드 삭제',
        'And can\'t be repeated on the same condition.' => '그리고 같은 조건에서 반복될 수는 없습니다.',
        'Add New Condition' => '새 조건 추가',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => '단순 매핑',
        'Default rule for unmapped keys' => '맵핑되지 않은 키의 기본 규칙',
        'This rule will apply for all keys with no mapping rule.' => '이 규칙은 매핑 규칙이없는 모든 키에 적용됩니다.',
        'Default rule for unmapped values' => '매핑되지 않은 값의 기본 규칙',
        'This rule will apply for all values with no mapping rule.' => '이 규칙은 매핑 규칙이없는 모든 값에 적용됩니다.',
        'New key map' => '새 키 맵',
        'Add key mapping' => '키 매핑 추가',
        'Mapping for Key ' => '키 매핑',
        'Remove key mapping' => '키 매핑 제거',
        'Key mapping' => '키 매핑',
        'Map key' => '키 지도',
        'matching the' => '일치하는',
        'to new key' => '새로운 열쇠에',
        'Value mapping' => '값 매핑',
        'Map value' => '지도 값',
        'to new value' => '새로운 가치로',
        'Remove value mapping' => '값 매핑 제거',
        'New value map' => '새로운 가치지도',
        'Add value mapping' => '값 매핑 추가',
        'Do you really want to delete this key mapping?' => '이 키 매핑을 정말로 삭제 하시겠습니까?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '일반 단축키',
        'MacOS Shortcuts' => 'MacOS 단축키',
        'Comment code' => '주석 코드',
        'Uncomment code' => '코드 주석 처리 해제',
        'Auto format code' => '자동 형식 코드',
        'Expand/Collapse code block' => '확장 / 축소 코드 블록',
        'Find' => '찾기',
        'Find next' => '다음 찾기',
        'Find previous' => '이전 찾기',
        'Find and replace' => '찾기 및 바꾸기',
        'Find and replace all' => '모두 찾기 및 바꾸기',
        'XSLT Mapping' => 'XSLT 매핑',
        'XSLT stylesheet' => 'XSLT 스타일 시트',
        'The entered data is not a valid XSLT style sheet.' => '입력 한 데이터가 유효한 XSLT 스타일 시트가 아닙니다.',
        'Here you can add or modify your XSLT mapping code.' => '여기에서 XSLT 매핑 코드를 추가하거나 수정할 수 있습니다.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '편집 필드에서는 자동 서식 지정, 창 크기 조정, 태그 및 대괄호 완성과 같은 다른 기능을 사용할 수 있습니다.',
        'Data includes' => '데이터 포함',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '이전 요청 / 응답 단계에서 생성 된 하나 이상의 데이터 집합을 표시 가능한 데이터에 포함되도록 선택합니다.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '이러한 세트는 \'/ DataInclude / 1\'의 데이터 구조에 표시됩니다 (자세한 내용은 실제 요청의 디버거 출력 참조).',
        'Data key regex filters (before mapping)' => '데이터 키 정규식 필터 (매핑 전)',
        'Data key regex filters (after mapping)' => '데이터 키 정규식 필터 (매핑 후)',
        'Regular expressions' => '정규 표현식',
        'Replace' => '바꾸다',
        'Remove regex' => '정규식 제거',
        'Add regex' => '정규 표현식 추가',
        'These filters can be used to transform keys using regular expressions.' =>
            '이러한 필터는 정규식을 사용하여 키를 변환하는 데 사용할 수 있습니다.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '데이터 구조는 재귀 적으로 탐색되고 구성된 모든 정규 표현식이 모든 키에 적용됩니다.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '사용 사례는 예 : 원하지 않는 키 접 두부를 제거하거나 유효하지 않은 키 요소를 XML 요소 이름으로 수정합니다.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '예 1 : Search = \'^ jira :\'/ Replace = \'\'는 \'jira : element\'를 \'element\'로 변환합니다.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '예 2 : Search = \'^\'/ Replace = \'_\'는 \'16x16\'을 \'_16x16\'으로 바꿉니다.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            'Perl의 정규 표현식에 대한 정보는 다음을 참조하십시오 :',
        'Perl regular expressions tutorial' => '펄 정규 표현식 튜토리얼',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '수정자가 필요한 경우 정규 표현식 자체 내에서 지정해야합니다.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '여기에 정의 된 정규 표현식은 XSLT 매핑 전에 적용됩니다.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '여기에 정의 된 정규 표현식은 XSLT 매핑 후에 적용됩니다.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '작업 추가',
        'Edit Operation' => '조작 편집',
        'Do you really want to delete this operation?' => '정말로 이 작업을 삭제 하시겠습니까?',
        'Operation Details' => '작업 세부 정보',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '이름은 일반적으로 원격 시스템에서이 웹 서비스 조작을 호출하는 데 사용됩니다.',
        'Operation backend' => '작업 백엔드',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            '이 OTOBO 연산 백엔드 모듈은 내부적으로 호출되어 요청을 처리하고 응답 데이터를 생성합니다.',
        'Mapping for incoming request data' => '들어오는 요청 데이터 매핑',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            '요청 데이터는이 매핑에 의해 처리되어 OTOBO가 예상하는 종류의 데이터로 변환됩니다.',
        'Mapping for outgoing response data' => '발신 응답 데이터 매핑',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '응답 데이터는이 매핑에 의해 처리되어 원격 시스템이 예상하는 종류의 데이터로 변환합니다.',
        'Include Ticket Data' => '티켓 데이터 포함',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '네트워크 전송',
        'Properties' => '속성',
        'Route mapping for Operation' => '운영을 위한 경로 매핑',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '이 작업에 매핑되어야하는 경로를 정의하십시오. \':\'로 표시된 변수는 입력 된 이름에 매핑되고 다른 변수와 함께 매핑에 전달됩니다. (예 : / Ticket / : TicketID).',
        'Valid request methods for Operation' => 'Operation에 대한 유효한 요청 메소드',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '이 작동을 특정 요청 방법으로 제한하십시오. 메서드를 선택하지 않으면 모든 요청이 수락됩니다.',
        'Maximum message length' => '최대 메시지 길이',
        'This field should be an integer number.' => '이 필드는 정수여야 합니다.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            '여기서 OTOBO가 처리 할 REST 메시지의 최대 크기 (바이트)를 지정할 수 있습니다.',
        'Send Keep-Alive' => 'Keep-Alive 보내기',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '이 구성은 들어오는 연결이 닫히거나 살아 있어야 하는지를 정의합니다.',
        'Additional response headers' => '추가 응답 헤더',
        'Add response header' => '응답 헤더 추가',
        'Endpoint' => '종점',
        'URI to indicate specific location for accessing a web service.' =>
            '웹 서비스에 액세스하기위한 특정 위치를 나타내는 URI.',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '제한시간',
        'Timeout value for requests.' => '요청에 대한 시간 초과값 입니다.',
        'Authentication' => '입증',
        'An optional authentication mechanism to access the remote system.' =>
            '원격 시스템에 액세스하기 위한 선택적인 인증 메커니즘.',
        'BasicAuth User' => 'BasicAuth 사용자',
        'The user name to be used to access the remote system.' => '원격 시스템에 액세스하는 데 사용할 사용자 이름.',
        'BasicAuth Password' => 'BasicAuth 비밀번호',
        'The password for the privileged user.' => '권한있는 사용자의 암호입니다.',
        'Use Proxy Options' => '프록시 옵션 사용',
        'Show or hide Proxy options to connect to the remote system.' => '원격 시스템에 연결하기위한 프록시 옵션 표시 또는 숨기기.',
        'Proxy Server' => '프록시 서버',
        'URI of a proxy server to be used (if needed).' => '사용할 프록시 서버의 URI (필요한 경우).',
        'e.g. http://proxy_hostname:8080' => '예 : http://proxy_hostname:8080',
        'Proxy User' => '프록시 사용자',
        'The user name to be used to access the proxy server.' => '프록시 서버에 액세스하는 데 사용할 사용자 이름입니다.',
        'Proxy Password' => '프록시 비밀번호',
        'The password for the proxy user.' => '프록시 사용자의 암호입니다.',
        'Skip Proxy' => '프록시 건너 뛰기',
        'Skip proxy servers that might be configured globally?' => '전 세계적으로 구성될 수 있는 프록시 서버를 건너 뛰십시오.',
        'Use SSL Options' => 'SSL 옵션 사용',
        'Show or hide SSL options to connect to the remote system.' => '원격 시스템에 연결할 SSL 옵션을 표시하거나 숨 깁니다.',
        'Client Certificate' => '클라이언트 인증서',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'SSL 클라이언트 인증서 파일의 전체 경로 및 이름 (PEM, DER 또는 PKCS # 12 형식이어야 함).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => '예 : /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => '클라이언트 인증서 키',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'SSL 클라이언트 인증서 키 파일의 전체 경로 및 이름 (아직 인증서 파일에 포함되어 있지 않은 경우).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => '예 : /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => '클라이언트 인증서 키 암호',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '키가 암호화 된 경우 SSL 인증서를 여는 암호입니다.',
        'Certification Authority (CA) Certificate' => '인증 기관 (CA) 인증서',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'SSL 인증서의 유효성을 검사하는 인증 기관 인증서 파일의 전체 경로 및 이름입니다.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => '예 : /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '인증 기관 (CA) 디렉토리',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'CA 인증서가 파일 시스템에 저장되는 인증 기관 디렉토리의 전체 경로입니다.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => '예 : / opt / otobo / var / certificates / SOAP / CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => '호출자에 대한 컨트롤러 매핑',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '호출자가 요청을 보내야하는 컨트롤러. \':\'로 표시된 변수는 데이터 값으로 대체되고 요청과 함께 전달됩니다. (예 : / Ticket / : TicketID? UserLogin = : UserLogin & Password = : Password).',
        'Valid request command for Invoker' => '호출자에 대한 유효한 요청 명령',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '이 Invoker (선택 사항)로 요청에 사용할 특정 HTTP 명령입니다.',
        'Default command' => '기본 명령',
        'The default HTTP command to use for the requests.' => '요청에 사용할 기본 HTTP 명령입니다.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '예 : https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'SOAPAction 설정',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '채워진 SOAPAction 헤더를 보내려면 "Yes"로 설정하십시오.',
        'Set to "No" in order to send an empty SOAPAction header.' => '빈 SOAPAction 헤더를 보내려면 "아니오"로 설정하십시오.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '수신 된 SOAPAction 헤더를 확인하려면 "예"로 설정하십시오 (비어 있지 않은 경우).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '수신 된 SOAPAction 헤더를 무시하려면 "아니오"로 설정하십시오.',
        'SOAPAction scheme' => 'SOAPAction 체계',
        'Select how SOAPAction should be constructed.' => 'SOAPAction을 구성하는 방법을 선택하십시오.',
        'Some web services require a specific construction.' => '일부 웹 서비스에는 특정 구성이 필요합니다.',
        'Some web services send a specific construction.' => '일부 웹 서비스는 특정 구성을 보냅니다.',
        'SOAPAction separator' => 'SOAPAction 구분 기호',
        'Character to use as separator between name space and SOAP operation.' =>
            '이름 공간과 SOAP 조작 간의 단락 문자로서 사용하는 캐릭터.',
        'Usually .Net web services use "/" as separator.' => '일반적으로 .Net 웹 서비스는 구분 기호로 "/"를 사용합니다.',
        'SOAPAction free text' => 'SOAPAction 자유 텍스트',
        'Text to be used to as SOAPAction.' => 'SOAPAction로서 사용되는 텍스트.',
        'Namespace' => '네임 스페이스',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI는 SOAP 메소드에 컨텍스트를 제공하여 모호성을 줄입니다.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '예 : urn : otobo-com : soap : 함수 또는 http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '요청 이름 체계',
        'Select how SOAP request function wrapper should be constructed.' =>
            'SOAP 요청 함수 랩퍼를 구성하는 방법을 선택하십시오.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\'은 실제 호출자 / 작업 이름의 예제로 사용됩니다.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\'는 실제 설정된 값의 예입니다.',
        'Request name free text' => '요청 이름 자유 텍스트',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '함수 래퍼 이름 접미사 또는 대체로 사용할 텍스트입니다.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'XML 요소 이름 지정 제한 사항을 고려하십시오 (예 : \'<\'및 \'&\').',
        'Response name scheme' => '응답 이름 체계',
        'Select how SOAP response function wrapper should be constructed.' =>
            'SOAP 응답 함수 랩퍼를 구성하는 방법을 선택하십시오.',
        'Response name free text' => '응답 이름 자유 텍스트',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            '여기서 OTOBO가 처리 할 SOAP 메시지의 최대 크기 (바이트)를 지정할 수 있습니다.',
        'Encoding' => '부호화',
        'The character encoding for the SOAP message contents.' => 'SOAP 메시지 내용의 문자 인코딩입니다.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '예를 들어 utf-8, latin1, iso-8859-1, cp1250 등',
        'Sort options' => '정렬 옵션',
        'Add new first level element' => '새로운 첫번째 레벨 요소 추가',
        'Element' => '요소',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'xml 필드에 대한 아웃 바운드 정렬 순서 (함수 이름 래퍼 아래에서 시작하는 구조) - SOAP 전송에 대한 설명서를 참조하십시오.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '웹 서비스 추가',
        'Edit Web Service' => '웹 서비스 편집',
        'Clone Web Service' => '웹 서비스 복제',
        'The name must be unique.' => '이름은 고유해야 합니다.',
        'Clone' => '클론',
        'Export Web Service' => '웹 서비스 내보내기',
        'Import web service' => '웹 서비스 가져오기',
        'Configuration File' => '구성 파일',
        'The file must be a valid web service configuration YAML file.' =>
            '파일은 유효한 웹 서비스 구성 YAML파일이어야 합니다.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '여기서 웹 서비스의 이름을 지정할 수 있습니다. 이 필드가 비어 있으면 구성 파일의 이름이 이름으로 사용됩니다.',
        'Import' => '수입',
        'Configuration History' => '구성 기록',
        'Delete web service' => '웹 서비스 삭제',
        'Do you really want to delete this web service?' => '이 웹 서비스를 정말로 삭제 하시겠습니까?',
        'Ready2Adopt Web Services' => 'Ready2Adopt 웹 서비스',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '여기 %s의 일부인 모범 사례를 보여주는 Ready2Adopt 웹 서비스를 활성화 할 수 있습니다.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '이 웹 서비스는 특정 %s 계약 수준에서만 사용 가능한 다른 모듈에 의존 할 수 있습니다 (가져올 때 자세한 내용이있는 알림이 있음).',
        'Import Ready2Adopt web service' => 'Ready2Adopt 웹 서비스 가져 오기',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '전문가가 만든 웹 서비스의 혜택을 원하십니까? 일부 정교한 Ready2Adopt 웹 서비스를 가져 오려면 %s로 업그레이드하십시오.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '구성을 저장하면 편집 화면으로 다시 이동합니다.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '개요로 돌아가려면 \'개요로 이동\'버튼을 클릭하십시오.',
        'Remote system' => '원격 시스템',
        'Provider transport' => '공급자 전송',
        'Requester transport' => '요청자 전송',
        'Debug threshold' => '디버그 임계 값',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            '공급자 모드에서 OTOBO는 원격 시스템에서 사용되는 웹 서비스를 제공합니다.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            '요청자 모드에서 OTOBO는 원격 시스템의 웹 서비스를 사용합니다.',
        'Network transport' => '네트워크 전송',
        'Error Handling Modules' => '오류 처리 모듈',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '오류 처리 모듈은 통신 중 오류가 발생했을 때 반응하는 데 사용됩니다. 이러한 모듈은 특정 순서로 실행되며 끌어서 놓기로 변경할 수 있습니다.',
        'Backend' => '백엔드',
        'Add error handling module' => '오류 처리 모듈 추가',
        'Operations are individual system functions which remote systems can request.' =>
            '운영은 원격 시스템이 요청할 수있는 개별 시스템 기능입니다.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invoker는 원격 웹 서비스에 대한 요청 데이터를 준비하고 응답 데이터를 처리합니다.',
        'Controller' => '제어 장치',
        'Inbound mapping' => '인바운드 매핑',
        'Outbound mapping' => '아웃 바운드 매핑',
        'Delete this action' => '이 작업 삭제',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '하나 이상의 %s 컨트롤러가 활성화되지 않았거나 존재하지 않습니다. 컨트롤러 등록을 확인하거나 %s를 삭제하십시오',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => '역사',
        'Go back to Web Service' => '웹 서비스로 돌아 가기',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '여기서 현재 웹 서비스 구성의 이전 버전을 보거나 내보내거나 복원 할 수 있습니다.',
        'Configuration History List' => '구성 기록 목록',
        'Version' => '번역',
        'Create time' => '시간을 창조하십시오',
        'Select a single configuration version to see its details.' => '세부 사항을 보려면 단일 구성 버전을 선택하십시오.',
        'Export web service configuration' => '웹 서비스 구성 내보내기',
        'Restore web service configuration' => '웹 서비스 구성 복원',
        'Do you really want to restore this version of the web service configuration?' =>
            '이 버전의 웹 서비스 구성을 정말로 복원 하시겠습니까?',
        'Your current web service configuration will be overwritten.' => '현재 웹 서비스 구성을 덮어 씁니다.',

        # Template: AdminGroup
        'Group Management' => '그룹 관리',
        'Add Group' => '그룹 추가',
        'Edit Group' => '그룹 편집',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '관리자 그룹은 관리 영역과 통계 그룹을 가져 와서 통계 영역을 얻는 것입니다.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '서로 다른 에이전트 그룹 (예 : 구매 부서, 지원 부서, 판매 부서 등)에 대한 액세스 권한을 처리 할 새 그룹을 만듭니다.',
        'It\'s useful for ASP solutions. ' => 'ASP 솔루션에 유용합니다.',

        # Template: AdminLog
        'System Log' => '시스템 로그',
        'Here you will find log information about your system.' => '여기서 시스템에 대한 로그 정보를 찾을 수 있습니다.',
        'Hide this message' => '이 메시지 숨기기',
        'Recent Log Entries' => '최근 로그 항목',
        'Facility' => '쉬움',
        'Message' => '메시지',

        # Template: AdminMailAccount
        'Mail Account Management' => '메일 계정 관리',
        'Add Mail Account' => '메일 계정 추가',
        'Edit Mail Account for host' => '호스트용 메일 계정 편집',
        'and user account' => '및 사용자 계정',
        'Filter for Mail Accounts' => '메일 계정 필터링',
        'Filter for mail accounts' => '메일 계정 필터링',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '하나의 계정을 가진 모든 수신 이메일은 선택된 대기열에 발송됩니다.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '계정이 신뢰할 수있는 것으로 표시되면 도착 시간 (예 : 우선 순위 등)에 이미 존재하는 X-OTOBO 헤더가 보존되어 사용됩니다 예 : PostMaster 필터',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '나가는 이메일은 %s의 Sendmail * 설정을 통해 구성 할 수 있습니다.',
        'System Configuration' => '시스템 설정',
        'Host' => '호스트',
        'Delete account' => '계정 삭제',
        'Fetch mail' => '메일 가져오기',
        'Do you really want to delete this mail account?' => '정말로 이 메일 계정을 삭제 하시겠습니까?',
        'Example: mail.example.com' => '예 : mail.example.com',
        'IMAP Folder' => 'IMAP 폴더',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'INBOX가 아닌 다른 폴더에서 메일을 가져와야하는 경우에만 수정하십시오.',
        'Trusted' => '신뢰할 수 있는',
        'Dispatching' => '파견',
        'Edit Mail Account' => '메일 계정 편집',

        # Template: AdminNavigationBar
        'Administration Overview' => '관리 개요',
        'Filter for Items' => '항목 필터링',
        'Favorites' => '즐겨찾기',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '오른쪽에있는 항목 위로 커서를 이동하고 별 모양 아이콘을 클릭하여 즐겨 찾기를 추가 할 수 있습니다.',
        'Links' => '링크',
        'View the admin manual on Github' => 'Github에서 관리자 매뉴얼보기',
        'No Matches' => '일치하지 않는다.',
        'Sorry, your search didn\'t match any items.' => '죄송합니다. 검색 결과와 일치하지 않습니다.',
        'Set as favorite' => '즐겨찾기로 설정',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '티켓 알림 관리',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 티켓 알림을 가져올 수 있습니다. 티켓 알림 모듈에서 내 보낸 파일은 .yml 형식이어야합니다.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '여기에서이 알림을 실행할 이벤트를 선택할 수 있습니다. 아래에 추가 티켓 필터를 적용하여 특정 기준에 맞는 티켓 만 보낼 수 있습니다.',
        'Ticket Filter' => '티켓 필터',
        'Lock' => '잠금',
        'SLA' => 'SLA',
        'Customer User ID' => '고객 사용자 ID',
        'Article Filter' => '기사 필터',
        'Only for ArticleCreate and ArticleSend event' => 'ArticleCreate 및 ArticleSend 이벤트에만 해당',
        'Article sender type' => '기사 발신자 유형',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'ArticleCreate 또는 ArticleSend가 트리거 이벤트로 사용되면 기사 필터를 지정해야합니다. 기사 필터 입력란 중 하나 이상을 선택하십시오.',
        'Customer visibility' => '고객 가시성',
        'Communication channel' => '통신 채널',
        'Include attachments to notification' => '알림 첨부파일 포함',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '선택한 전송을 사용하는 단일 티켓에 대해 하루에 한 번 사용자에게 알립니다.',
        'This field is required and must have less than 4000 characters.' =>
            '이 필드는 필수이며 4000 자 미만이어야합니다.',
        'Notifications are sent to an agent or a customer.' => '통지는 상담원 또는 고객에게 전송됩니다.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '(최신 에이전트 기사의) 제목의 처음 20자를 가져옵니다.',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '(최신 에이전트 기사의) 본문의 처음 5 줄을 가져 오려면.',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '(최신 고객 기사의) 제목의 처음 20자를 얻으려면.',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '(최신 고객 기사의) 본문의 첫 번째 5 줄을 가져옵니다.',
        'Attributes of the current customer user data' => '현재 고객 사용자 데이터의 속성',
        'Attributes of the current ticket owner user data' => '현재 티켓 소유자 사용자 데이터의 속성',
        'Attributes of the current ticket responsible user data' => '현재 티켓 책임 사용자 데이터의 속성',
        'Attributes of the current agent user who requested this action' =>
            '이 작업을 요청한 현재 상담원 사용자의 속성',
        'Attributes of the ticket data' => '티켓 데이터의 속성',
        'Ticket dynamic fields internal key values' => '동적 필드 내부 키 값 티켓 ',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '티켓 동적 필드는 드롭 다운 및 Multiselect 필드에 유용한 값을 표시합니다. ',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '<OTOBO_TICKET_DynamicField _...>와 같은 OTOBO 태그를 사용하여 현재 티켓의 값을 삽입 할 수 있습니다.',

        # Template: AdminPGP
        'PGP Management' => 'PGP 관리',
        'Add PGP Key' => 'PGP 키 추가',
        'PGP support is disabled' => 'PGP 지원이 비활성화되었습니다.',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'OTOBO에서 PGP를 사용하려면 먼저 PGP를 활성화해야합니다.',
        'Enable PGP support' => 'PGP 지원 사용',
        'Faulty PGP configuration' => 'PGP 구성 오류',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP 지원이 활성화되었지만 관련 구성에 오류가 있습니다. 아래 단추를 ​​사용하여 구성을 확인하십시오.',
        'Configure it here!' => '여기에서 구성하십시오!',
        'Check PGP configuration' => 'PGP 구성 확인',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '이 방법으로 SysConfig에서 구성된 키 링을 직접 편집 할 수 있습니다.',
        'Introduction to PGP' => 'PGP 소개',
        'Bit' => '비트',
        'Fingerprint' => '지문',
        'Expires' => '만료',
        'Delete this key' => '이 키 삭제',
        'PGP key' => 'PGP 키',

        # Template: AdminPackageManager
        'Package Manager' => '패키지 관리자',
        'Uninstall Package' => '패키지 제거',
        'Uninstall package' => '패키지 제거',
        'Do you really want to uninstall this package?' => '이 패키지를 정말로 제거 하시곘습니까?',
        'Reinstall package' => '패키지 다시 설치',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '이 패키지를 정말로 다시 설치 하시겠습니까? 수동으로 변경하면 손실됩니다.',
        'Go to updating instructions' => '',
        'Go to the OTOBO customer portal' => 'OTOBO 고객 포털로 이동하십시오.',
        'package information' => '패키지 정보',
        'Package installation requires a patch level update of OTOBO.' =>
            '패키지를 설치하려면 OTOBO의 패치 레벨 업데이트가 필요합니다. ',
        'Package update requires a patch level update of OTOBO.' => '패키지 업데이트에는 OTOBO의 패치 수준 업데이트가 필요합니다. ',
        'Please note that your installed OTOBO version is %s.' => '설치된 OTOBO 버전은 %s입니다.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            '이 패키지를 설치하려면 OTOBO를 버전 %s 이상으로 업데이트해야합니다.',
        'This package can only be installed on OTOBO version %s or older.' =>
            '이 패키지는 OTOBO 버전 %s 또는 그 이상에서만 설치할 수 있습니다.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'This package can only be installed on OTOBO version %s or newer.',
        'Why should I keep OTOBO up to date?' => '왜 OTOBO를 최신 상태로 유지해야합니까?',
        'You will receive updates about relevant security issues.' => '관련 보안 문제에 대한 업데이트가 제공됩니다.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            '다른 모든 관련 OTOBO 문제에 대한 업데이트가 제공됩니다.',
        'How can I do a patch level update if I don’t have a contract?' =>
            '계약이 없다면 어떻게 패치 레벨 업데이트를 할 수 있습니까?',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            '혹시 더 궁금한 점이 있으시면 답변 해드리겠습니다.',
        'Please visit our customer portal and file a request.' => '고객 포털을 방문하여 요청을 제출하십시오.',
        'Install Package' => '패키지 설치',
        'Update Package' => '패키지 업데이트',
        'Continue' => '계속하다',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '데이터베이스가 %s 크기 이상의 패키지를 수락하는지 확인하십시오 (현재 패키지는 최대 %s MB 만 허용). 오류를 피하기 위해 데이터베이스의 max_allowed_packet 설정을 조정하십시오.',
        'Install' => '설치',
        'Update repository information' => '저장소 정보 업데이트',
        'Cloud services are currently disabled.' => '클라우드 서비스는 현재 사용할 수 없습니다.',
        'OTOBO Verify can not continue!' => 'OTOBO Verify를 계속할 수 없습니다!',
        'Enable cloud services' => '클라우드 서비스 사용',
        'Update all installed packages' => '설치된 모든 패키지를 업데이트 하십시오.',
        'Online Repository' => '온라인 저장소',
        'Vendor' => '공급 업체',
        'Action' => '동작',
        'Module documentation' => '모듈 문서',
        'Local Repository' => '로컬 저장소',
        'This package is verified by OTOBOverify (tm)' => '이 패키지는 OTOBOverify (tm)에 의해 검증됩니다.',
        'Uninstall' => '제거',
        'Package not correctly deployed! Please reinstall the package.' =>
            '패키지가 올바르게 배치되지 않았습니다! 패키지를 다시 설치하십시오.',
        'Reinstall' => '재설치',
        'Features for %s customers only' => '%s 고객 전용 기능',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '%s를 사용하면 다음과 같은 옵션 기능을 활용할 수 있습니다. 더 자세한 정보가 필요하시면 %s로 연락하십시오.',
        'Package Information' => '패키지 정보',
        'Download package' => '패키지 다운로드',
        'Rebuild package' => '패키지 다시 빌드',
        'Metadata' => '메타 데이터',
        'Change Log' => '변경 로그',
        'Date' => '날짜',
        'List of Files' => '파일 목록',
        'Permission' => '허가',
        'Download file from package!' => '패키지에서 파일을 다운로드 하십시오!',
        'Required' => '필수',
        'Primary Key' => '기본 키',
        'Auto Increment' => '자동 증가',
        'SQL' => 'SQL',
        'File Differences for File %s' => '파일 %s의 파일 차이점',
        'File differences for file %s' => '파일 %s의 파일 차이점',

        # Template: AdminPerformanceLog
        'Performance Log' => '성능 로그',
        'Range' => '범위',
        'last' => '마지막',
        'This feature is enabled!' => '이 기능을 사용할 수 있습니다!',
        'Just use this feature if you want to log each request.' => '각 요청을 기록하려면 이 기능을 사용하십시오.',
        'Activating this feature might affect your system performance!' =>
            '이 기능을 활성화하면 시스템 성능에 영향을 줄 수 있습니다!',
        'Disable it here!' => '여기에서 사용 중지 하십시오!',
        'Logfile too large!' => '로그파일이 너무 큽니다!',
        'The logfile is too large, you need to reset it' => '로그 파일이 너무 커서 재설정해야 합니다.',
        'Reset' => '리셋',
        'Overview' => '개요',
        'Interface' => '인터페이스',
        'Requests' => '요청',
        'Min Response' => '최소 응답',
        'Max Response' => '최대 응답',
        'Average Response' => '평균 응답',
        'Period' => '기간',
        'minutes' => '분',
        'Min' => '최소',
        'Max' => '최대',
        'Average' => '평균',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster 필터 관리',
        'Add PostMaster Filter' => 'PostMaster 필터 추가',
        'Edit PostMaster Filter' => '포스트 마스터 필터 편집',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '전자 메일 헤더를 기반으로 수신 전자메일을 발송하거나 필터링합니다. 정규표현식을 사용하여 일치시킬 수도 있습니다.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '이메일 주소 만 일치 시키려면 From, To 또는 Cc에서 EMAILADDRESS : info@example.com을 사용하십시오.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '정규 표현식을 사용하는 경우 \'Set\'동작에서 ()의 일치 값을 [***]로 사용할 수도 있습니다.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '이름이 지정된 캡처를 %s사용할 수도 있고 \'설정\'작업 %s의 이름 (예 : 정규 표현식 : %s, 작업 설정 : %s)을 사용할 수 있습니다. 일치하는 EMAILADDRESS의 이름은 \'%s\'입니다.',
        'Delete this filter' => '이 필터 삭제',
        'Do you really want to delete this postmaster filter?' => '이 포스트 마스터 필터를 정말로 삭제 하시겠습니까?',
        'A postmaster filter with this name already exists!' => '이 이름을 가진 전자메일 관리자 필터가 이미 있습니다!',
        'Filter Condition' => '필터 조건',
        'AND Condition' => '조건',
        'Search header field' => '헤더 필드 검색',
        'for value' => '가치관',
        'The field needs to be a valid regular expression or a literal word.' =>
            '필드는 유효한 정규표현식 또는 문자 그대로의 단어여야 합니다.',
        'Negate' => '부정하다',
        'Set Email Headers' => '이메일 헤더 설정',
        'Set email header' => '이메일 헤더 설정',
        'with value' => '가치있는',
        'The field needs to be a literal word.' => '필드는 문자 그대로의 단어여야 합니다.',
        'Header' => '머리글',

        # Template: AdminPriority
        'Priority Management' => '우선 순위 관리',
        'Add Priority' => '우선 순위 추가',
        'Edit Priority' => '우선 순위 편집',
        'Filter for Priorities' => '우선 순위에 대한 필터링',
        'Filter for priorities' => '우선 순위에 대한 필터링',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '이 우선 순위는 SysConfig 설정에 있으며 새로운 우선 순위를 가리 키도록 설정을 업데이트해야합니다!',
        'This priority is used in the following config settings:' => '이 우선 순위는 다음 구성 설정에서 사용됩니다.',

        # Template: AdminProcessManagement
        'Process Management' => '공정 관리',
        'Filter for Processes' => '프로세스 필터링',
        'Filter for processes' => '',
        'Create New Process' => '새 프로세스 만들기',
        'Deploy All Processes' => '모든 프로세스 배포',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 프로세스를 가져올 수 있습니다. 파일은 프로세스 관리 모듈에서 내 보낸 .yml 형식이어야합니다.',
        'Upload process configuration' => '업로드 프로세스 구성',
        'Import process configuration' => '프로세스 구성 가져오기',
        'Ready2Adopt Processes' => 'Ready2Adopt 프로세스',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '여기에서 우수 사례를 보여주는 Ready2Adopt 프로세스를 활성화 할 수 있습니다. 추가 구성이 필요할 수 있습니다.',
        'Import Ready2Adopt process' => 'Ready2Adopt 프로세스 가져 오기',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '새 프로세스를 만들려면 다른 시스템에서 내 보낸 프로세스를 가져 오거나 완전히 새로운 프로세스를 생성 할 수 있습니다.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '여기에서 프로세스 변경은 프로세스 데이터를 동기화 할 경우에만 시스템의 동작에 영향을 미칩니다. 프로세스를 동기화함으로써 새로 변경된 변경 사항이 구성에 기록됩니다.',
        'Processes' => '프로세스',
        'Process name' => '프로세스 이름',
        'Print' => '인쇄',
        'Export Process Configuration' => '프로세스 구성 내보내기',
        'Copy Process' => '프로세스 복사',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '취소 및 닫기',
        'Go Back' => '돌아가기',
        'Please note, that changing this activity will affect the following processes' =>
            '이 활동을 변경하면 다음 프로세스에 영향을 미칩니다.',
        'Activity' => '활동',
        'Activity Name' => '활동명',
        'Activity Dialogs' => '활동 대화상자',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '마우스로 요소를 왼쪽 목록에서 오른쪽 목록으로 드래그하여 활동 대화 상자를 이 활동에 지정할 수 있습니다.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '드래그 앤 드롭을 사용하여 목록 내의 요소를 정렬 할 수도 있습니다.',
        'Filter available Activity Dialogs' => '사용 가능한 필터 대화상자',
        'Available Activity Dialogs' => '사용 가능한 활동 대화상자',
        'Name: %s, EntityID: %s' => '이름 : %s, EntityID : %s',
        'Create New Activity Dialog' => '새 활동 만들기 대화 상자',
        'Assigned Activity Dialogs' => '할당된 활동 대화상자',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '이 활동 대화상자를 변경하면 다음 활동에 영향을 미칩니다.',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '고객 사용자는 Owner, Responsible, Lock, PendingTime 및 CustomerID 필드를 보거나 사용할 수 없습니다.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '대기열 필드는 새 티켓을 작성할 때 고객이 사용할 수 있습니다.',
        'Activity Dialog' => '활동 대화상자',
        'Activity dialog Name' => '활동 대화 상자 이름',
        'Available in' => '가능',
        'Description (short)' => '설명 (짧다)',
        'Description (long)' => '설명 (길다)',
        'The selected permission does not exist.' => '선택한 권한이 없습니다.',
        'Required Lock' => '필수 잠금',
        'The selected required lock does not exist.' => '선택한 필수 잠금이 없습니다.',
        'Submit Advice Text' => 'Submit Advice Text',
        'Submit Button Text' => '제출 버튼 텍스트',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '마우스로 요소를 왼쪽 목록에서 오른쪽 목록으로 끌어서이 활동 대화 상자에 필드를 할당 할 수 있습니다.',
        'Filter available fields' => '사용 가능한 필드 필터링',
        'Available Fields' => '사용 가능한 필드',
        'Assigned Fields' => '할당된 필드',
        'Communication Channel' => '통신 채널',
        'Is visible for customer' => '고객에게 표시됩니다.',
        'Display' => '다스플레이',

        # Template: AdminProcessManagementPath
        'Path' => '통로',
        'Edit this transition' => '이 전환 편집',
        'Transition Actions' => '전환 액션',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '마우스로 요소를 왼쪽 목록에서 오른쪽 목록으로 드래그하여 전환 동작을이 전환에 지정할 수 있습니다.',
        'Filter available Transition Actions' => '사용 가능한 필터 전환 액션',
        'Available Transition Actions' => '사용 가능한 필터 전환 액션',
        'Create New Transition Action' => '새 전환 액션 만들기',
        'Assigned Transition Actions' => '할당된 전환 액션',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '활동',
        'Filter Activities...' => '활동 필터링...',
        'Create New Activity' => '새 활동 만들기',
        'Filter Activity Dialogs...' => '활동 필터링 대화 상자...',
        'Transitions' => '전환',
        'Filter Transitions...' => '필터 전환',
        'Create New Transition' => '새 전환 만들기',
        'Filter Transition Actions...' => '필터 전환 액션...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '프로세스 편집',
        'Print process information' => '프로세스 정보 인쇄',
        'Delete Process' => '프로세스 삭제',
        'Delete Inactive Process' => '비활성 프로세스 삭제',
        'Available Process Elements' => '사용 가능한 프로세스 요소',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '이 사이드 바에 위에 나열된 요소는 drag\'n\'drop을 사용하여 오른쪽의 캔바스 영역으로 이동할 수 있습니다.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '캔버스 영역에 활동을 배치하여 이 활동을 프로세스에 할당할 수 있습니다.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '액티비티 대화 상자를 액티비티에 할당하려면이 사이드 바의 액티비티 대화 상자 요소를 캔버스 영역에 배치 된 액티비티 위에 놓습니다.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '연결의 시작 활동 위로 전환 요소를 놓음으로써 두 활동 사이의 연결을 시작할 수 있습니다. 그런 다음 화살표의 느슨한 끝을 끝 활동으로 이동할 수 있습니다.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '동작 요소를 전환 레이블에 놓음으로써 동작을 전환에 할당할 수 있습니다.',
        'Edit Process Information' => '프로세스 정보 편집',
        'Process Name' => '프로세스 이름',
        'The selected state does not exist.' => '선택한 상태가 존재하지 않습니다.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '활동, 활동 대화 상자 및 전환 추가 및 편집',
        'Show EntityIDs' => '엔티티 ID 표시',
        'Extend the width of the Canvas' => '캔버스 너비 늘리기',
        'Extend the height of the Canvas' => '캔버스의 높이 늘리기',
        'Remove the Activity from this Process' => '이 프로세스에서 활동 제거',
        'Edit this Activity' => '이 활동 편집',
        'Save Activities, Activity Dialogs and Transitions' => '활동, 활동 대화 상자 및 전환 저장',
        'Do you really want to delete this Process?' => '이 프로세스를 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Activity?' => '이 활동을 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Activity Dialog?' => '이 활동 대화 상자를 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Transition?' => '이 전환을 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Transition Action?' => '이 전환 액션을 정말로 삭제 하시겠습니까?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '이 활동을 캔버스에서 정말로 제거 하시겠습니까? 저장하지 않고이 화면을 나가면 취소 할 수 있습니다.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '이 전환을 캔버스에서 정말로 제거 하시겠습니까? 저장하지 않고이 화면을 나가면 취소 할 수 있습니다.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '이 화면에서 새 프로세스를 만들 수 있습니다. 사용자가 새 프로세스를 사용할 수있게하려면 상태를 \'활성\'으로 설정하고 작업 완료 후 동기화하십시오.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '취소 및 닫기',
        'Start Activity' => '활동 시작',
        'Contains %s dialog(s)' => '%s 대화 상자(s)를 포함합니다.',
        'Assigned dialogs' => '할당된 대화상자',
        'Activities are not being used in this process.' => '활동이 이 프로세스에서 사용되지 않습니다.',
        'Assigned fields' => '지정된 필드',
        'Activity dialogs are not being used in this process.' => '활동 대화상자는 이 프로세스에서 사용되지 않습니다.',
        'Condition linking' => '조건 연결',
        'Transitions are not being used in this process.' => '전환은 이 프로세스에서 사용되지 않습니다.',
        'Module name' => '모듈 이름',
        'Transition actions are not being used in this process.' => '전환 작업은 이 프로세스에서 사용되지 않습니다.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '이 전환을 변경하면 다음 프로세스에 영항을 미칩니다.',
        'Transition' => '전환',
        'Transition Name' => '전환 이름',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '이 전환 작업을 변경하면 다음 프로세스에 영향을 미칩니다.',
        'Transition Action' => '전환 액션',
        'Transition Action Name' => '전환 액션 이름',
        'Transition Action Module' => '전환 액션 모듈',
        'Config Parameters' => '구성 매개 변수',
        'Add a new Parameter' => '새 매개 변수 추가',
        'Remove this Parameter' => '이 매개 변수 제거',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => '대기열 추가',
        'Edit Queue' => '대기열 편집',
        'Filter for Queues' => '대기열 필터링',
        'Filter for queues' => '대기열 필터링',
        'A queue with this name already exists!' => '이 이름을 가진 대기열이 이미 있습니다!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '이 대기열은 SysConfig 설정에 있으며, 새로운 대기열을 가리 키도록 설정을 업데이트해야합니다!',
        'Sub-queue of' => '하위 큐',
        'Unlock timeout' => '제한 시간 잠금 해제',
        '0 = no unlock' => '0 = 잠금 해제 없음',
        'hours' => '시간',
        'Only business hours are counted.' => '영업시간만 계산됩니다.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '에이전트가 티켓을 잠그고 잠금 해제 시간 초과가 지나기 전에 티켓을 닫지 않으면 티켓이 잠금 해제되고 다른 에이전트에서 사용할 수있게됩니다.',
        'Notify by' => '알림',
        '0 = no escalation' => '0 = 에스컬레이션 없음',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '여기에 정의 된 시간이 만료되기 전에 고객 연락처 전자 메일 외부 또는 전화가 새 티켓에 추가되지 않으면 티켓이 에스컬레이트됩니다.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '전자 메일 또는 고객 포털을 통한 후속 조치와 같이 기사가 추가되면 에스컬레이션 업데이트 시간이 재설정됩니다. 여기에 정의 된 시간이 만료되기 전에 고객 연락처 전자 메일 외부 또는 전화가 티켓에 추가되면 티켓이 에스컬레이션됩니다.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '여기에 정의된 시간이 만료되기 전에 티켓이 닫히도록 설정되어 있지 않으면 티켓이 에스컬레이트 됩니다.',
        'Follow up Option' => '후속 옵션',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '폐쇄 된 티켓에 대한 후속 조치가 티켓을 다시 열 것인지, 거절되거나 새로운 티켓으로 이어질지 여부를 지정합니다.',
        'Ticket lock after a follow up' => '후속 조치 후 티켓 잠금',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '티켓이 닫히고 고객이 후속 조치를 보내면 티켓이 이전 소유자에게 고정됩니다.',
        'System address' => '시스템 주소',
        'Will be the sender address of this queue for email answers.' => '전자 메일 응답을 위한 이 큐의 보낸사람 주소가 됩니다.',
        'Default sign key' => '기본 기호 키',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => '인사말',
        'The salutation for email answers.' => '이메일 답변에 대한 인사말.',
        'Signature' => '서명',
        'The signature for email answers.' => '이메일 답변을 위한 서명.',
        'This queue is used in the following config settings:' => '이 대기열은 다음 구성 설정에서 사용됩니다.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '대기열 관리 - 자동 응답 관계 관리',
        'Change Auto Response Relations for Queue' => '대기열에 대한 자동 응답관계 변경',
        'This filter allow you to show queues without auto responses' => '이 필터를 사용하면 자동응답 없이 대기열을 표시할 수 있습니다.',
        'Queues without Auto Responses' => '자동응답이 없는 대기열',
        'This filter allow you to show all queues' => '이 필터를 사용하면 모든 대기열을 표시할 수 있습니다.',
        'Show All Queues' => '모든 대기열 표시',
        'Auto Responses' => '자동 응답',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '템플릿 - 대기열 관계 관리',
        'Filter for Templates' => '템플릿 필터링',
        'Filter for templates' => '',
        'Templates' => '템플릿',

        # Template: AdminRegistration
        'System Registration Management' => '시스템 등록 관리',
        'Edit System Registration' => '시스템 등록 편집',
        'System Registration Overview' => '시스템 등록 개요',
        'Register System' => '시스템 등록',
        'Validate OTOBO-ID' => 'OTOBO-ID 확인',
        'Deregister System' => 'Deregister System',
        'Edit details' => '세부 정보 수정',
        'Show transmitted data' => '전송된 데이터 표시',
        'Deregister system' => 'Deregister system',
        'Overview of registered systems' => '등록된 시스템 개요',
        'This system is registered with OTOBO Team.' => '이 시스템은 OTRS 그룹에 등록되어 있습니다.',
        'System type' => '시스템 유형',
        'Unique ID' => '고유 ID',
        'Last communication with registration server' => '등록 서버와의 마지막 통신',
        'System Registration not Possible' => '시스템 등록이 불가능합니다.',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'OTOBO 데몬이 올바르게 실행되지 않으면 시스템을 등록 할 수 없습니다.',
        'Instructions' => '명령',
        'System Deregistration not Possible' => '시스템 등록 취소가 불가능합니다.',
        'OTOBO-ID Login' => 'OTOBO-ID 로그인',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '시스템 등록은 많은 장점을 제공하는 OTOBO Team의 서비스입니다!',
        'Read more' => '더 많은 것을 읽으십시오',
        'You need to log in with your OTOBO-ID to register your system.' =>
            '시스템을 등록하려면 OTOBO-ID로 로그인해야합니다.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'OTOBO-ID는 OTOBO.com 웹 페이지에 가입 할 때 사용한 이메일 주소입니다.',
        'Data Protection' => '데이터 보호',
        'What are the advantages of system registration?' => '시스템 등록의 이점은 무엇입니까?',
        'You will receive updates about relevant security releases.' => '관련 보안 릴리스에 대한 업데이트가 제공됩니다.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '시스템 등록을 통해 우리는 모든 관련 정보를 이용할 수 있으므로 귀하를 위해 서비스를 개선 할 수 있습니다.',
        'This is only the beginning!' => '이것은 단지 시작일뿐입니다!',
        'We will inform you about our new services and offerings soon.' =>
            '조만간 새로운 서비스와 제품에 대해 알려 드리겠습니다.',
        'Can I use OTOBO without being registered?' => 'OTOBO를 등록하지 않고도 사용할 수 있습니까?',
        'System registration is optional.' => '시스템 등록은 선택 사항입니다.',
        'You can download and use OTOBO without being registered.' => '등록없이 OTOBO를 다운로드하여 사용할 수 있습니다.',
        'Is it possible to deregister?' => '등록 취소가 가능합니까?',
        'You can deregister at any time.' => '언제든지 등록 취소 할 수 있습니다.',
        'Which data is transfered when registering?' => '등록할 때 어떤 데이터가 전송됩니까?',
        'A registered system sends the following data to OTOBO Team:' => '등록 된 시스템은 다음 데이터를 OTRS 그룹에 보냅니다.',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'FQDN (정규화 된 도메인 이름), OTOBO 버전, 데이터베이스, 운영 체제 및 Perl 버전',
        'Why do I have to provide a description for my system?' => '왜 내 시스템에 대한 설명을 제공해야 합니까?',
        'The description of the system is optional.' => '시스템 설명은 선택 사항 입니다.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '지정하는 설명 W 시스템 유형은 등록 된 시스템의 세부 사항을 식별하고 관리하는 데 도움을줍니다.',
        'How often does my OTOBO system send updates?' => 'OTOBO 시스템은 얼마나 자주 업데이트를 보내나요?',
        'Your system will send updates to the registration server at regular intervals.' =>
            '시스템은 일정한 간격으로 등록 서버에 업데이트를 보냅니다.',
        'Typically this would be around once every three days.' => '일반적으로 3일에 1번 정도입니다.',
        'If you deregister your system, you will lose these benefits:' =>
            '시스템 등록을 취소하면 다음과 같은 이점을 잃게 됩니다.',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            '시스템 등록을 취소하려면 OTOBO-ID로 로그인해야합니다.',
        'OTOBO-ID' => 'OTOBO-ID ',
        'You don\'t have an OTOBO-ID yet?' => '아직 OTOBO-ID가 없습니까?',
        'Sign up now' => '지금 등록하세요',
        'Forgot your password?' => '비밀번호를 잊어 버렸습니까?',
        'Retrieve a new one' => '새 항목 가져 오기',
        'Next' => '다음',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '이 시스템을 등록 할 때이 데이터는 OTRS 그룹으로 자주 전송됩니다.',
        'Attribute' => '속성',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'OTOBO 버전',
        'Operating System' => '운영 체제',
        'Perl Version' => '펄 버전',
        'Optional description of this system.' => '이 시스템에 대한 선택적 설명.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '이렇게하면 시스템이 OTRS 그룹에 추가 지원 데이터 정보를 보낼 수 있습니다.',
        'Register' => '기록',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '이 단계를 계속하면 OTRS 그룹의 시스템 등록이 취소됩니다.',
        'Deregister' => '위임자',
        'You can modify registration settings here.' => '여기에서 등록 설정을 수정할 수 있습니다.',
        'Overview of Transmitted Data' => '전송된 데이터의 개요',
        'There is no data regularly sent from your system to %s.' => '시스템에서 %s로 정기적으로 전송되는 데이터는 없습니다.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '다음 데이터는 최소 3 일마다 시스템에서 %s로 전송됩니다.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '데이터는 안전한 https 연결을 통해 JSON 형식으로 전송됩니다.',
        'System Registration Data' => '시스템 등록 데이터',
        'Support Data' => '지원 데이터',

        # Template: AdminRole
        'Role Management' => '역할 관리',
        'Add Role' => '역할 추가',
        'Edit Role' => '역할 편집',
        'Filter for Roles' => '역할 필터링',
        'Filter for roles' => '역할 필터링',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '역할을 만들고 그 안에 그룹을 넣으십시오. 그런 다음 사용자에게 역할을 추가 하십시오.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '정의 된 역할이 없습니다. \'추가\'버튼을 사용하여 새 역할을 만드십시오.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '역할 그룹 관계 관리',
        'Roles' => '역할',
        'Select the role:group permissions.' => '역할 : 그룹 권한을 선택 하십시오.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '아무 것도 선택하지 않으면이 그룹에 권한이 없습니다 (티켓을 역할에 사용할 수 없음).',
        'Toggle %s permission for all' => '모든 사용자에게 %s의 권한을 토글합니다.',
        'move_into' => 'move_into',
        'Permissions to move tickets into this group/queue.' => '이 그룹 / 대기열로 티켓을 이동하는 권한.',
        'create' => '생성',
        'Permissions to create tickets in this group/queue.' => '이 그룹 / 대기열에서 티켓을 만들 수 있는 권한.',
        'note' => '노트',
        'Permissions to add notes to tickets in this group/queue.' => '이 그룹 / 대기열의 티켓에 메모를 추가할 권한.',
        'owner' => '소유자',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '이 그룹 / 대기열에서 티켓 소유자를 변경할 권한.',
        'priority' => '우선 순위',
        'Permissions to change the ticket priority in this group/queue.' =>
            '이 그룹 / 큐에서 티켓 우선 순위를 변경할 권한.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '에이전트 역할 관계 관리',
        'Add Agent' => '상담원 추가',
        'Filter for Agents' => '에이전트 필터링',
        'Filter for agents' => '',
        'Agents' => '에이전트',
        'Manage Role-Agent Relations' => '역할 - 에이전트 관계 관리',

        # Template: AdminSLA
        'SLA Management' => 'SLA 관리',
        'Edit SLA' => 'SLA 편집',
        'Add SLA' => 'SLA 추가',
        'Filter for SLAs' => 'SLA 필터링',
        'Please write only numbers!' => '숫자만 써주세요!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S / MIME 관리',
        'Add Certificate' => '인증서 추가',
        'Add Private Key' => '비공개 키 추가',
        'SMIME support is disabled' => 'SMIME 지원이 비활성화되었습니다.',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'OTOBO에서 SMIME을 사용하려면 먼저 SMIME를 활성화해야합니다.',
        'Enable SMIME support' => 'SMIME 지원 사용',
        'Faulty SMIME configuration' => 'SMIME 구성 오류',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME 지원이 활성화되었지만 관련 구성에 오류가 있습니다. 아래 단추를 ​​사용하여 구성을 확인하십시오.',
        'Check SMIME configuration' => 'SMIME 구성 확인',
        'Filter for Certificates' => '인증서 필터링',
        'Filter for certificates' => '',
        'To show certificate details click on a certificate icon.' => '인증서 세부 사항을 보려면 인증서 아이콘을 클릭 하십시오.',
        'To manage private certificate relations click on a private key icon.' =>
            '개인 인증서 관계를 관리하려면 개인 키 아이콘을 클릭하십시오.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '여기에서 개인 인증서에 관계를 추가 할 수 있습니다.이 인증서는이 인증서를 사용하여 전자 메일에 서명 할 때마다 S / MIME 서명에 포함됩니다.',
        'See also' => '또한 보십시오',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '이 방법으로 파일 시스템의 인증 및 개인 키를 직접 편집할 수 있습니다.',
        'Hash' => '해쉬',
        'Create' => '생성',
        'Handle related certificates' => '관련 인증서 처리',
        'Read certificate' => '인증서 읽기',
        'Delete this certificate' => '이 인증서 삭제',
        'File' => '파일',
        'Secret' => '비밀',
        'Related Certificates for' => '관련 인증서',
        'Delete this relation' => '이 관계 삭제',
        'Available Certificates' => '사용 가능한 인증서',
        'Filter for S/MIME certs' => 'S / MIME 인증서 필터링',
        'Relate this certificate' => '이 인증서 연관',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S / MIME 인증서',
        'Certificate Details' => '인증서 세부 정보',
        'Close this dialog' => '이 대화 상자를 닫습니다.',

        # Template: AdminSalutation
        'Salutation Management' => '인사말 관리',
        'Add Salutation' => '인사말 추가',
        'Edit Salutation' => '인사말 편집',
        'Filter for Salutations' => '인사말 필터링',
        'Filter for salutations' => '인사말 필터링',
        'e. g.' => '예를들면',
        'Example salutation' => '예시 인사말',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '보안 모드가 활성화되어야 합니다!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '보안 모드는 초기 설치가 완료된 후 (일반적으로) 설정됩니다.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '보안 모드가 활성화되어 있지 않으면 응용 프로그램이 이미 실행 중이기 때문에 SysConfig를 통해 활성화하십시오.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL 박스',
        'Filter for Results' => '결과 필터링',
        'Filter for results' => '결과 필터링',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '여기서 SQL을 입력하여 응용 프로그램 데이터베이스로 직접 보낼 수 있습니다. 테이블 내용을 변경할 수 없으며 선택 쿼리 만 허용됩니다.',
        'Here you can enter SQL to send it directly to the application database.' =>
            '여기서 SQL을 입력하여 응용 프로그램 데이터베이스로 직접 보낼 수 있습니다.',
        'Options' => '옵션',
        'Only select queries are allowed.' => '선택 쿼리만 허용됩니다.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL 쿼리 구문에 실수가 있습니다. 그것을 확인하십시오.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '바인딩에 누락 된 매개 변수가 하나 이상 있습니다. 그것을 확인하십시오.',
        'Result format' => '결과 형식',
        'Run Query' => '검색어 실행',
        '%s Results' => '결과 %s개',
        'Query is executed.' => '쿼리가 실행됩니다.',

        # Template: AdminService
        'Service Management' => '서비스 관리',
        'Add Service' => '서비스 추가',
        'Edit Service' => '서비스 편집',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '서비스 이름의 최대 길이는 200 자 (서브 서비스 포함)입니다.',
        'Sub-service of' => '의 서브 서비스',

        # Template: AdminSession
        'Session Management' => '세션 관리',
        'Detail Session View for %s (%s)' => '%s (%s)에 대한 세부 세션보기',
        'All sessions' => '모든 세션',
        'Agent sessions' => '에이전트 세션',
        'Customer sessions' => '고객 세션',
        'Unique agents' => '고유 에이전트',
        'Unique customers' => '고유 고객',
        'Kill all sessions' => '모든 세션을 종료하십시오.',
        'Kill this session' => '이 세션을 종료하십시오.',
        'Filter for Sessions' => '세션 필터링',
        'Filter for sessions' => '세션 필터링',
        'Session' => '세션',
        'Kill' => '종료',
        'Detail View for SessionID: %s - %s' => 'SessionID 세부 정보보기 : %s - %s',

        # Template: AdminSignature
        'Signature Management' => '시그니처 관리',
        'Add Signature' => '시그니처 추가',
        'Edit Signature' => '시그니처 편집',
        'Filter for Signatures' => '시그니처 필터링',
        'Filter for signatures' => '시그니처 필터링',
        'Example signature' => '서명의 예',

        # Template: AdminState
        'State Management' => '주 관리',
        'Add State' => '주 추가',
        'Edit State' => '주 편집',
        'Filter for States' => '주 필터링',
        'Filter for states' => '주 필터링',
        'Attention' => '주의',
        'Please also update the states in SysConfig where needed.' => '필요한 경우 SysConfig의 상태도 업데이트하십시오.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '이 상태는 SysConfig 설정에 있으며, 새 유형을 가리 키도록 설정을 업데이트해야합니다!',
        'State type' => '상태 유형',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '이 상태는 다음 구성 설정에서 사용됩니다.',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'OTRS 그룹에 지원 데이터를 보낼 수 없습니다!',
        'Enable Cloud Services' => '클라우드 서비스 사용',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '이 데이터는 정기적으로 OTRS 그룹에 전송됩니다. 이 데이터의 전송을 중지하려면 시스템 등록을 업데이트하십시오.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '이 버튼을 눌러 Support Data를 수동으로 트리거 할 수 있습니다 :',
        'Send Update' => '업데이트 보내기',
        'Currently this data is only shown in this system.' => '현재 이 데이터는 이 시스템에만 표시됩니다.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '보다 나은 지원을 받으려면이 데이터를 OTRS 그룹에 보내도록하십시오.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '데이터 전송을 활성화하려면 시스템을 OTRS 그룹에 등록하거나 시스템 등록 정보를 업데이트하십시오 ( \'지원 데이터 보내기\'옵션을 활성화하십시오).',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '이 단추를 누르면 지원 번들 (시스템 등록 정보, 지원 데이터, 설치된 패키지 목록 및 모든 로컬로 수정 된 소스 코드 파일 포함)을 생성 할 수 있습니다.',
        'Generate Support Bundle' => '지원 번들 생성',
        'The Support Bundle has been Generated' => '지원 번들이 생성 되었습니다.',
        'Please choose one of the following options.' => '다음 옵션 중 하나를 선택 하십시오.',
        'Send by Email' => '이메일로 보내기',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '지원 번들이 너무 커서 전자 메일로 보낼 수 없으면이 옵션이 비활성화되었습니다.',
        'The email address for this user is invalid, this option has been disabled.' =>
            '이 사용자의 이메일 주소가 유효하지 않습니다.이 옵션은 사용 중지되었습니다.',
        'Sending' => '보내다',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '지원 번들은 이메일을 통해 OTRS 그룹에 자동으로 전송됩니다.',
        'Download File' => '다운로드 파일',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '지원 번들이 들어있는 파일은 로컬 시스템에 다운로드됩니다. 파일을 저장하고 대체 방법을 사용하여 OTRS 그룹에 보내십시오.',
        'Error: Support data could not be collected (%s).' => '오류 : 지원 데이터를 수집 할 수 없습니다 (%s).',
        'Details' => '세부',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '시스템 전자 메일 주소 관리',
        'Add System Email Address' => '시스템 전자 메일 주소 추가',
        'Edit System Email Address' => '시스템 전자 메일 주소 편집',
        'Add System Address' => '시스템 주소 추가',
        'Filter for System Addresses' => '시스템 주소 필터링',
        'Filter for system addresses' => '시스템 주소 필터링',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'To 또는 Cc에이 주소가있는 모든 수신 이메일이 선택된 대기열로 발송됩니다.',
        'Email address' => '이메일 주소',
        'Display name' => '표시 이름',
        'This email address is already used as system email address.' => '이 전자 메일 주소는 이미 시스템 전자 메일 주소로 사용됩니다.',
        'The display name and email address will be shown on mail you send.' =>
            '표시 이름과 이메일 주소가 보내는 메일에 표시됩니다.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '온라인 관리자 문서',
        'System configuration' => '시스템 설정',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '왼쪽에있는 탐색 상자의 트리를 사용하여 사용 가능한 설정을 탐색하십시오.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '아래 검색란을 사용하거나 상단 탐색 메뉴의 검색 아이콘을 사용하여 특정 설정을 찾습니다.',
        'Find out how to use the system configuration by reading the %s.' =>
            '%s를 읽음으로써 시스템 구성을 사용하는 방법을 알아보십시오.',
        'Search in all settings...' => '모든 설정에서 검색...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '현재 사용할 수있는 설정이 없습니다. 소프트웨어를 사용하기 전에 \'otobo.Console.pl Maint :: Config :: Rebuild\'를 실행하십시오. ',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '변경 사항 배포',
        'Help' => '도움',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '이것은 지금 시작하면 배포의 일부가 될 모든 설정에 대한 개요입니다. 오른쪽 상단의 아이콘을 클릭하여 이전 상태와 각 설정을 비교할 수 있습니다.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '배포에서 특정 설정을 제외하려면 설정의 헤더 모음에서 확인란을 클릭합니다.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '기본적으로 사용자가 직접 변경 한 설정 만 배포합니다. 다른 사용자가 변경 한 설정을 배포하려면 화면 상단의 링크를 클릭하여 고급 배포 모드로 전환하십시오.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '배포가 방금 복원 되었습니다. 즉, 영향을 받는 모든 설정이 선택한 배포의 상태로 되돌아 왔음을 의미합니다.',
        'Please review the changed settings and deploy afterwards.' => '변경된 설정을 검토하고 나중에 배포하십시오.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '변경 내용이 비어있는 목록은 영향을 받는 설정의 복원된 상태와 현재 상태간에 차이가 없음을 의미합니다.',
        'Changes Overview' => '변경 개요',
        'There are %s changed settings which will be deployed in this run.' =>
            '이 실행에 배포 될 설정이 %s개 변경되었습니다.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '기본 모드로 전환하면 변경된 설정만 배포됩니다.',
        'You have %s changed settings which will be deployed in this run.' =>
            '이 실행에 배포 할 설정이 %s개 변경되었습니다.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '다른 사용자가 변경한 설정을 배포하려면 고급 모드로 전환하십시오.',
        'There are no settings to be deployed.' => '배포할 설정이 없습니다.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '고급 모드로 전환하면 다른 사용자가 배포 가능한 설정을 변경할 수 있습니다.',
        'Deploy selected changes' => '선택한 변경 사항 배포',

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
        'by' => '으로',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '이 그룹에는 설정이 없습니다. 하위 그룹 중 하나를 탐색 해보십시오.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '수입 수출',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '시스템에 가져올 파일을 업로드하십시오 (시스템 구성 모듈에서 내 보낸 .yml 형식).',
        'Upload system configuration' => '시스템 구성 업로드',
        'Import system configuration' => '시스템 구성 가져오기',
        'Download current configuration settings of your system in a .yml file.' =>
            '.yml 파일에서 시스템의 현재 구성 설정을 다운로드하십시오.',
        'Include user settings' => '사용자 설정 포함',
        'Export current configuration' => '현재 구성 내보내기',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '검색',
        'Search for category' => '카테고리 검색',
        'Settings I\'m currently editing' => '설정 현재 편집 중입니다.',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '"%s"카테고리에서 "%s"로 검색 한 결과가 없습니다.',
        'Your search for "%s" in category "%s" returned one result.' => '"%s"카테고리에서 "%s"로 검색 한 결과가 1 개입니다.',
        'Your search for "%s" in category "%s" returned %s results.' => '"%s" 로 "%s"카테고리에서 검색한 결과 :  %s개',
        'You\'re currently not editing any settings.' => '현재 설정을 수정하지 않으셨습니다.',
        'You\'re currently editing %s setting(s).' => '현재 %s개의 설정 변경 중입니다.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => '범주',
        'Run search' => '검색 실행',

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
        'View a custom List of Settings' => '사용자 정의 설정 목록보기',
        'View single Setting: %s' => '단일보기 설정 : %s',
        'Go back to Deployment Details' => '배치 세부 사항으로 돌아가기',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '시스템 유지 보수 관리',
        'Schedule New System Maintenance' => '새로운 시스템 유지 보수 일정 계획',
        'Filter for System Maintenances' => '시스템 유지 관리를 위한 필터',
        'Filter for system maintenances' => '시스템 유지 관리를 위한 필터',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '상담원과 고객을 알리기 휘한 시스템 유지 보수 기간을 예약하면 일정 기간 시스템이 다운됩니다.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '이 시스템 유지 보수가 시작되기 전에 사용자는 각 화면에서 이 사실을 알리는 알림을 받게 됩니다.',
        'Stop date' => '종료 날짜',
        'Delete System Maintenance' => '시스템 유지 보수 삭제',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '시스템 유지 보수 편집',
        'Edit System Maintenance Information' => '시스템 유지 보수 정보 편집',
        'Date invalid!' => '날짜가 잘못 되었습니다!',
        'Login message' => '로그인 메시지',
        'This field must have less then 250 characters.' => '이 입력란은 250자 미만이어야 합니다.',
        'Show login message' => '로그인 메시지 표시',
        'Notify message' => '알림 메시지',
        'Manage Sessions' => '세션 관리',
        'All Sessions' => '모든 세션',
        'Agent Sessions' => '에이전트 세션',
        'Customer Sessions' => '고객 세션',
        'Kill all Sessions, except for your own' => '자기만의 것을 제외한 모든 세션을 죽이십시오.',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => '템플릿 추가',
        'Edit Template' => '템플릿 편집',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '템플릿은 에이전트가 티켓, 응답 또는 전달을 더 빨리 작성할 수 있도록 도와주는 기본 텍스트입니다.',
        'Don\'t forget to add new templates to queues.' => '대기열에 새 템플릿을 추가하는 것을 잊지 마십시오.',
        'Attachments' => '첨부파일',
        'Delete this entry' => '이 항목 삭제',
        'Do you really want to delete this template?' => '이 템플릿을 정말로 삭제 하시겠습니까?',
        'A standard template with this name already exists!' => '이 이름을 가진 표준 템플릿이 이미 존재합니다!',
        'Create type templates only supports this smart tags' => '만들기 유형 템플릿은 이 스마트 태그만 지원합니다.',
        'Example template' => '템플릿 예제',
        'The current ticket state is' => '현재 티켓 상태는 다음과 같습니다.',
        'Your email address is' => '귀하의 이메일 주소 : ',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => '모든 사용자에게 전환 사용',
        'Link %s to selected %s' => '%s를 선택한 %s에 연결',

        # Template: AdminType
        'Type Management' => '유형 관리',
        'Add Type' => '유형 추가',
        'Edit Type' => '유형 편집',
        'Filter for Types' => '유형 필터',
        'Filter for types' => '유형 필터',
        'A type with this name already exists!' => '이 이름을 가진 유형이 이미 존재합니다!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '이 유형은 SysConfig 설정에 있으며, 새 유형을 가리 키도록 설정을 업데이트해야합니다!',
        'This type is used in the following config settings:' => '이 유형은 다음 구성 설정에서 사용됩니다.',

        # Template: AdminUser
        'Agent Management' => '상담원 관리',
        'Edit Agent' => '상담원 수정',
        'Edit personal preferences for this agent' => '이 상담원의 개인 설정 수정',
        'Agents will be needed to handle tickets.' => '티켓을 처리하려면 상담원이 필요합니다.',
        'Don\'t forget to add a new agent to groups and/or roles!' => '그룹이나 역할에 새 상담원을 추가하는 것을 잊지마세요.',
        'Please enter a search term to look for agents.' => '상담원을 찾으려면 검색어를 입력하십시오.',
        'Last login' => '최종 로그인',
        'Switch to agent' => '상담원으로 변경',
        'Title or salutation' => '제목이나 인사말',
        'Firstname' => '이름',
        'Lastname' => '성',
        'A user with this username already exists!' => '이 사용자 이름을 가진 사용자가 이미 있습니다.',
        'Will be auto-generated if left empty.' => '비워 둘 경우 자동 생성됩니다.',
        'Mobile' => '모바일폰',
        'Effective Permissions for Agent' => '상담원 유효 권한',
        'This agent has no group permissions.' => '상담원이 그룹권한을 가지고 있지 않음',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '위의 표는 에이전트에 대한 효과적인 그룹 사용 권한을 보여줍니다. 행렬은 상속 된 모든 권한 (예 : 역할을 통해)을 고려합니다.',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '상담원-그룹 관계 관리',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Agenda 개요',
        'Manage Calendars' => '캘린더 관리',
        'Add Appointment' => '약속 추가',
        'Today' => '오늘',
        'All-day' => '매일',
        'Repeat' => '반복',
        'Notification' => '알림',
        'Yes' => '예',
        'No' => '아니요',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '캘린더가 없습니다. 먼저 캘린더 관리 페이지를 사용하여 캘린더를 추가하십시오.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '새 약속 추가',
        'Calendars' => '캘린더',

        # Template: AgentAppointmentEdit
        'Basic information' => '기본 정보',
        'Date/Time' => '날짜/시간',
        'Invalid date!' => '잘못된 날짜',
        'Please set this to value before End date.' => '종료일 전으로 선택하세요',
        'Please set this to value after Start date.' => '시작일 이후로 선택하세요',
        'This an occurrence of a repeating appointment.' => '반복 약속 생성',
        'Click here to see the parent appointment.' => '클릭하여 상위 약속 보기',
        'Click here to edit the parent appointment.' => '클릭하여 상위 약속 수정',
        'Frequency' => '주기',
        'Every' => '매',
        'day(s)' => '일',
        'week(s)' => '주',
        'month(s)' => '월',
        'year(s)' => '년',
        'On' => '온',
        'Monday' => '월요일',
        'Mon' => '월',
        'Tuesday' => '화요일',
        'Tue' => '화',
        'Wednesday' => '수요일',
        'Wed' => '수',
        'Thursday' => '목요일',
        'Thu' => '목',
        'Friday' => '금요일',
        'Fri' => '금',
        'Saturday' => '토요일',
        'Sat' => '토',
        'Sunday' => '일요일',
        'Sun' => '일',
        'January' => '1월',
        'Jan' => '1',
        'February' => '2월',
        'Feb' => '2',
        'March' => '3월',
        'Mar' => '3',
        'April' => '4월',
        'Apr' => '4',
        'May_long' => '5월',
        'May' => '5',
        'June' => '6월',
        'Jun' => '6',
        'July' => '7월',
        'Jul' => '7',
        'August' => '8월',
        'Aug' => '8',
        'September' => '9월',
        'Sep' => '9',
        'October' => '10월',
        'Oct' => '10',
        'November' => '11월',
        'Nov' => '11',
        'December' => '12월',
        'Dec' => '12',
        'Relative point of time' => '상대 시간',
        'Link' => '링크',
        'Remove entry' => '삭제',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '고객 정보 센터',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '고객 사용자',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '고객이 바르지 않습니다.',
        'Start chat' => '채팅 시작',
        'Video call' => '비디오 전화',
        'Audio call' => '오디오 전화',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '고객 사용자 주소록',
        'Search for recipients and add the results as \'%s\'.' => '수신자를 검색하고 결과를 \'%s\'로 추가하세요.',
        'Search template' => '템플릿 검색',
        'Create Template' => '템플릿 생성',
        'Create New' => '새로 생성',
        'Save changes in template' => '템플릿의 변경 저장',
        'Filters in use' => '사용중인 필터',
        'Additional filters' => '추가 필터',
        'Add another attribute' => '다른 속성 추가',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '식별자가 \'(Customer)\'인 속성은 고객의 속성입니다',
        '(e. g. Term* or *Term*)' => '(예를 들어, 용어 * 또는 * 용어 *)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => '전체선택',
        'The customer user is already selected in the ticket mask.' => '티켓 마스크에서 고객 사용자가 이미 선택되었습니다.',
        'Select this customer user' => '이 고객 사용자 선택',
        'Add selected customer user to' => '선택한 고객 사용자를 추가',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => '검색 옵션을 변경',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '고객 사용자 정보 센터',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTOBO Daemon은 비동기 작업을 수행하는 데몬 프로세스입니다. 티켓 에스컬레이션 트리거링, 이메일 전송 등',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            '올바른 시스템 작동을 위해서는 실행중인 OTOBO 데몬이 필수입니다.',
        'Starting the OTOBO Daemon' => 'OTOBO Daemon 시작',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            '.dist (확장자없이) \'%s\'파일이 있는지 확인하십시오. 이 cron 작업은 OTOBO 데몬이 실행중인 경우 5 분마다 점검하고 필요한 경우 시작합니다.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            '\'%s start\'를 실행하여 \'otobo\'사용자의 cron 작업이 활성 상태인지 확인하십시오.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            '5 분 후, OTOBO 데몬이 시스템에서 실행 중인지 확인하십시오 ( \'bin / otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => '현황판',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '새 약속',
        'Tomorrow' => '내일',
        'Soon' => '곧',
        '5 days' => '5일',
        'Start' => '시작',
        'none' => '없음',

        # Template: AgentDashboardCalendarOverview
        'in' => '...에서',

        # Template: AgentDashboardCommon
        'Save settings' => '설정 저장',
        'Close this widget' => '이 위젯 닫기',
        'more' => '더',
        'Available Columns' => '가능한 컬럼',
        'Visible Columns (order by drag & drop)' => '보여지는 컬럼(드래그드롭으로 순서정렬 가능)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '고객 관계 변경',
        'Open' => '진행중',
        'Closed' => '종료됨',
        '%s open ticket(s) of %s' => '진행중 티켓 중 %s / %s',
        '%s closed ticket(s) of %s' => '종료된 티켓 중 %s / %s',
        'Edit customer ID' => '고객 ID 수정',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Escalated 티켓',
        'Open tickets' => '진행중 티켓',
        'Closed tickets' => '종료된 티켓',
        'All tickets' => '모든 티켓',
        'Archived tickets' => '보관된 티켓',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '노트: 고객 사용자가 바르지 않습니다.',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '고객 사용자 정보',
        'Phone ticket' => '폰 티켓',
        'Email ticket' => '이메일 티켓',
        'New phone ticket from %s' => '%s로 새 폰 티켓',
        'New email ticket to %s' => '새 이메일 티켓을 %s로',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s 가능',
        'Please update now.' => '업데이트해주세요.',
        'Release Note' => '노트해 주세요.',
        'Level' => '레벨',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '작성한지 %s 지남',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '이 통계 위젯의 구성에 오류가 있습니다. 설정을 검토하십시오.',
        'Download as SVG file' => 'SVG로 다운로드',
        'Download as PNG file' => 'PNG로 다운로드',
        'Download as CSV file' => 'CSV로 다운로드',
        'Download as Excel file' => '엑셀로 다운로드',
        'Download as PDF file' => 'PDF로 다운로드',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '이 위젯의 ​​구성에서 유효한 그래프 출력 형식을 선택하십시오.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '이 통계의 내용이 준비 중입니다. 기다려주십시오.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '이 통계는 통계 관리자가 구성을 수정해야하기 때문에 현재 사용할 수 없습니다.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '고객 사용자에게 할당 됨',
        'Accessible for customer user' => '고객 사용자가 엑세스 가능',
        'My locked tickets' => '내 잠긴 티켓',
        'My watched tickets' => '내가 본 티켓',
        'My responsibilities' => '내 책임',
        'Tickets in My Queues' => '내 대기열의 티켓',
        'Tickets in My Services' => '내 서비스의 티켓',
        'Service Time' => '서비스 시간',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '총',

        # Template: AgentDashboardUserOnline
        'out of office' => '부재중',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '까지',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => '뒤',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => '일부 뉴스, 라이센스 또는 일부 변경 사항을 수락합니다.',
        'Yes, accepted.' => '예, 수락됨',

        # Template: AgentLinkObject
        'Manage links for %s' => '관리하려면 %s',
        'Create new links' => '새로운 링크 생성',
        'Manage existing links' => '링크 관리',
        'Link with' => '연결',
        'Start search' => '검색 시작',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '현재 링크가 없습니다. 이 항목을 다른 개체에 링크하려면 상단의 \'새 링크 만들기\'를 클릭하십시오.',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => '비밀번호 변경',
        'Current password' => '현재 비밀번호',
        'New password' => '새로운 비밀번호',
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
        'Edit your preferences' => '환경설정 수정',
        'Personal Preferences' => '개인 환경 설정',
        'Preferences' => '환경설정',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '참고 : 현재 %s의 환경 설정을 수정 중입니다.',
        'Go back to editing this agent' => '이 에이전트 편집으로 돌아가기',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '개인적인 취향을 설정하십시오. 오른쪽의 체크 표시를 클릭하여 각 설정을 저장 하십시오.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '아래 탐색 트리를 사용하여 특정 그룹의 설정만 표시할 수 있습니다.',
        'Dynamic Actions' => '동적 동작',
        'Filter settings...' => '필터 설정...',
        'Filter for settings' => '설정 필터링',
        'Save all settings' => '모든 설정 저장',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '시스템 관리자는 아바타를 비활성화했습니다. 대신 이니셜을 볼 수 있습니다.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '이메일 주소 %s at %s 에 등록하여 아바타 이미지를 변경할 수 있습니다. 새로운 아바타가 캐싱으로 인해 사용 가능해질 때까지 약간의 시간이 걸릴 수 있습니다.',
        'Off' => '떨어져서',
        'End' => '종료',
        'This setting can currently not be saved.' => '이 설정은 현재 저장할 수 없습니다.',
        'This setting can currently not be saved' => '이 설정은 현재 저장할 수 없습니다.',
        'Save this setting' => '이 설정 저장',
        'Did you know? You can help translating OTOBO at %s.' => '아시나요? OTOBO를 %s에서 번역 할 수 있습니다.',

        # Template: SettingsList
        'Reset to default' => '기본값으로 재설정',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '오른쪽 그룹을 선택하여 변경하려는 설정을 찾으십시오.',
        'Did you know?' => '아시나요?',
        'You can change your avatar by registering with your email address %s on %s' =>
            '%s 에 %s의 이메일 주소로 등록하여 아바타를 변경할 수 있습니다.',

        # Template: AgentSplitSelection
        'Target' => '목적',
        'Process' => '프로세스',
        'Split' => '분리',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '통계 추가',
        'Read more about statistics in OTOBO' => 'OTOBO의 통계에 대해 자세히 알아보십시오.',
        'Dynamic Matrix' => '가변 매트릭스',
        'Each cell contains a singular data point.' => '각 셀에는 단일 데이터 요소가 포함되어 있습니다.',
        'Dynamic List' => '가변 리스트',
        'Each row contains data of one entity.' => '각 행은 하나의 엔티티의 데이터를 포함합니다.',
        'Static' => '정적인',
        'Non-configurable complex statistics.' => '구성할 수없는 복잡한 통계',
        'General Specification' => '일반 사양',
        'Create Statistic' => '통계 생성',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => '지금 실행',
        'Statistics Preview' => '통계 미리보기',
        'Save Statistic' => '통계 저장',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '통계 설정 Import',

        # Template: AgentStatisticsOverview
        'Statistics' => '통계',
        'Run' => '실행',
        'Edit statistic "%s".' => '통계 "%s"을 수정하십시오.',
        'Export statistic "%s"' => '통계 "%s" 내보내기',
        'Export statistic %s' => '통계 "%s" 내보내기',
        'Delete statistic "%s"' => '통계 "%s"  삭제',
        'Delete statistic %s' => '통계 "%s" 삭제',

        # Template: AgentStatisticsView
        'Statistics Overview' => '통계 개요',
        'View Statistics' => '',
        'Statistics Information' => '통계 정보',
        'Created by' => '작성자 : ',
        'Changed by' => '변경자 ',
        'Sum rows' => '행 합계',
        'Sum columns' => '열 합계',
        'Show as dashboard widget' => '대시 보드 위젯으로 표시',
        'Cache' => '저장하다',
        'This statistic contains configuration errors and can currently not be used.' =>
            '이 통계에는 구성 오류가 있으며 현재 사용할 수 없습니다.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '%s%s%s의 자유 텍스트 변경 ',
        'Change Owner of %s%s%s' => '%s%s%s의 소유자 변경',
        'Close %s%s%s' => '닫기 %s%s%s',
        'Add Note to %s%s%s' => '%s%s%s에 메모 추가',
        'Set Pending Time for %s%s%s' => '%s%s%s의 보류 시간 설정',
        'Change Priority of %s%s%s' => '%s%s%s의 우선 순위 변경',
        'Change Responsible of %s%s%s' => '%s%s%s의 책임 변경',
        'The ticket has been locked' => '티켓이 잠겼습니다.',
        'Undo & close' => '실행 취소 및 닫기',
        'Ticket Settings' => '티켓 설정',
        'Queue invalid.' => '대기열이 잘못 되었습니다.',
        'Service invalid.' => '서비스가 유효하지 않습니다.',
        'SLA invalid.' => 'SLA가 유효하지 않습니다.',
        'New Owner' => '신규 소유자',
        'Please set a new owner!' => '새 주인을 설정하십시오!',
        'Owner invalid.' => '소유자가 유효하지 않습니다.',
        'New Responsible' => '새로운 책임',
        'Please set a new responsible!' => '새로운 책임을 설정하십시오!',
        'Responsible invalid.' => '책임지지 않습니다.',
        'Next state' => '다음 상태',
        'State invalid.' => '상태가 유효하지 않습니다.',
        'For all pending* states.' => '모든 보류 * 상태.',
        'Add Article' => '기사 추가',
        'Create an Article' => '기사 작성',
        'Inform agents' => '에이전트에게 알리기',
        'Inform involved agents' => '관련 요원에게 알린다.',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '여기에서 새 기사와 관련된 알림을 받을 추가 상담원을 선택할 수 있습니다.',
        'Text will also be received by' => '다음에 의해 텍스트도 받게 됩니다.',
        'Text Template' => '텍스트 템플릿',
        'Setting a template will overwrite any text or attachment.' => '템플릿을 설정하면 텍스트나 첨부파일을 덮어씁니다.',
        'Invalid time!' => '시간이 잘못 되었습니다!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '바운스 %s%s%s',
        'Bounce to' => '바운스',
        'You need a email address.' => '이메일 주소가 필요합니다.',
        'Need a valid email address or don\'t use a local email address.' =>
            '유효한 전자 메일 주소가 필요하거나 로컬 전자 메일 주소를 사용하지 마십시오.',
        'Next ticket state' => '다음 티켓 상태',
        'Inform sender' => '발신자에게 알리기',
        'Send mail' => '이메일 전송',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '티켓 일괄 작업',
        'Send Email' => '이메일 전송',
        'Merge' => '합침',
        'Merge to' => '합침',
        'Invalid ticket identifier!' => '잘못된 티켓 식별자입니다!',
        'Merge to oldest' => '가장 오래된 병합',
        'Link together' => '함께 연결',
        'Link to parent' => '상위 링크',
        'Unlock tickets' => '티켓 잠금 해제',
        'Execute Bulk Action' => '일괄 작업 실행',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '%s%s%s에 대한 답변 작성',
        'This address is registered as system address and cannot be used: %s' =>
            '이 주소는 시스템 주소로 등록되어 있으므로 사용할 수 없습니다 : %s',
        'Please include at least one recipient' => '수신자를 한 명 이상 포함하십시오.',
        'Select one or more recipients from the customer user address book.' =>
            '고객 사용자 주소록에서 하나 이상의 수신자를 선택하십시오.',
        'Customer user address book' => '고객 사용자 주소록',
        'Remove Ticket Customer' => '티켓 고객 제거',
        'Please remove this entry and enter a new one with the correct value.' =>
            '이 항목을 제거하고 올바른 값으로 새 항목을 입력하십시오.',
        'This address already exists on the address list.' => '이 주소는 이미 주소록에 있습니다.',
        'Remove Cc' => '참조 삭제',
        'Bcc' => '숨은 참조',
        'Remove Bcc' => '숨은 참조 제거',
        'Date Invalid!' => '잘못된 날짜!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '고객을 %s%s%s로 변경하십시오.',
        'Customer Information' => '고객 정보',
        'Customer user' => '고객 사용자',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '새 전자 메일 티켓 만들기',
        'Example Template' => '템플릿 예제',
        'From queue' => '대기열에서',
        'To customer user' => '고객 사용자에게',
        'Please include at least one customer user for the ticket.' => '적어도 한 명의 고객 사용자를 티켓에 포함하십시오.',
        'Select this customer as the main customer.' => '이 고객을 주요 고객으로 선택하십시오.',
        'Remove Ticket Customer User' => '티켓 고객 사용자 제거',
        'Get all' => '모든 것을 가져라',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '%s%s%s의 발신 이메일',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '%s%s%s에게 이메일 다시 보내기',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '티켓 %s: 첫 번째 응답 시간이 끝났습니다 (%s/ %s)!',
        'Ticket %s: first response time will be over in %s/%s!' => '티켓 %s : 첫 번째 응답 시간은 %s/ %s로 끝납니다!',
        'Ticket %s: update time is over (%s/%s)!' => '티켓 %s : 업데이트 시간이 끝났습니다 (%s / %s)!',
        'Ticket %s: update time will be over in %s/%s!' => '티켓 %s: 업데이트 시간이 %s / %s 이상입니다!',
        'Ticket %s: solution time is over (%s/%s)!' => '티켓 %s : 해결 시간이 끝났습니다 (%s / %s)!',
        'Ticket %s: solution time will be over in %s/%s!' => '티켓 %s : 해결 시간은 %s / %s로 끝납니다!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '전달 %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '%s%s%s의 기록',
        'Filter for history items' => '기록 항목 필터링',
        'Expand/collapse all' => '모두 펼치기 / 접기',
        'CreateTime' => 'Created',
        'Article' => '조',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '병합 %s%s%s',
        'Merge Settings' => '병합 설정',
        'You need to use a ticket number!' => '티켓 번호를 사용해야합니다!',
        'A valid ticket number is required.' => '유효한 티켓 번호가 필요합니다.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '티켓 번호 또는 제목의 일부를 입력하여 검색하십시오.',
        'Limit the search to tickets with same Customer ID (%s).' => '같은 고객 ID (%s)의 티켓으로 검색을 제한하십시오.',
        'Inform Sender' => 'Inform Sender',
        'Need a valid email address.' => '유효한 이메일 주소가 필요합니다.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '%s%s%s 로 이동',
        'New Queue' => '새로운 대기열',
        'Move' => '이동',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => '티켓이 없습니다.',
        'Open / Close ticket action menu' => '티켓 열기 / 닫기 액션 메뉴',
        'Select this ticket' => '이 티켓 선택',
        'Sender' => '보낸사람',
        'First Response Time' => '첫 번째 응답 시간',
        'Update Time' => '업데이트 시간',
        'Solution Time' => '솔루션 시간',
        'Move ticket to a different queue' => '티켓을 다른 대기열로 이동',
        'Change queue' => '대기열 변경',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => '이 화면에서 활성 필터를 제거하십시오.',
        'Tickets per page' => '페이지 당 티켓',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '누란된 채널',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '개요 재설정',
        'Column Filters Form' => '열 필터 양식',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '새로운 폰 티켓으로 분리',
        'Save Chat Into New Phone Ticket' => '채팅을 새로운 폰 티켓으로 저장',
        'Create New Phone Ticket' => '새로운 폰 티켓 생성',
        'Please include at least one customer for the ticket.' => '최소한 한 명의 고객을 티켓에 포함하십시오.',
        'To queue' => '대기열에 넣기',
        'Chat protocol' => '채팅 프로토콜',
        'The chat will be appended as a separate article.' => '채팅은 별도의 기사로 추가됩니다.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '%s%s%s 통화 중입니다.',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '%s%s%s에 대한 이메일보기 일반 텍스트',
        'Plain' => '명백한',
        'Download this email' => '이 이메일 다운로드',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '새 프로세스 티켓 만들기',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '티켓을 프로세스에 등록',

        # Template: AgentTicketSearch
        'Profile link' => '프로필 링크',
        'Output' => '산출',
        'Fulltext' => 'Fulltext',
        'Customer ID (complex search)' => '고객 ID (복합 검색)',
        '(e. g. 234*)' => '(예 : 234 *)',
        'Customer ID (exact match)' => '고객 ID (일치 항목)',
        'Assigned to Customer User Login (complex search)' => '고객 사용자 로그인 (복잡한 검색)에 할당 됨',
        '(e. g. U51*)' => '(예컨대, U51 *)',
        'Assigned to Customer User Login (exact match)' => '고객 사용자 로그인 (정확한 일치)에 할당 됨',
        'Accessible to Customer User Login (exact match)' => '고객 사용자 로그인 가능 (완전 일치)',
        'Created in Queue' => '대기열에서 생성됨',
        'Lock state' => '잠금 상태',
        'Watcher' => '참관인',
        'Article Create Time (before/after)' => '기사 작성 시간 (이전 / 이후)',
        'Article Create Time (between)' => '기사 작성 시간 (사이)',
        'Please set this to value before end date.' => '종료일 이전에 값으로 설정하십시오.',
        'Please set this to value after start date.' => '시작일 이후 값으로 설정 하십시오.',
        'Ticket Create Time (before/after)' => '티켓 생성 시간 (이전 / 이후)',
        'Ticket Create Time (between)' => '티켓 생성 시간 (사이)',
        'Ticket Change Time (before/after)' => '티켓 변경 시간 (이전 / 이후)',
        'Ticket Change Time (between)' => '티켓 변경 시간 (사이)',
        'Ticket Last Change Time (before/after)' => '티켓 마지막 변경 시간 (이전 / 이후)',
        'Ticket Last Change Time (between)' => '티켓 마지막 변경 시간 (사이)',
        'Ticket Pending Until Time (before/after)' => '시간 전까지 티켓 보류 중 (이전 / 이후)',
        'Ticket Pending Until Time (between)' => '시간 전까지 티켓 보류 중 (사이)',
        'Ticket Close Time (before/after)' => '티켓 종료 시간 (전후)',
        'Ticket Close Time (between)' => '티켓 종료 시간 (사이) ',
        'Ticket Escalation Time (before/after)' => '티켓 에스컬레이션 시간 (이전 / 이후)',
        'Ticket Escalation Time (between)' => '티켓 에스컬레이션 시간 (사이)',
        'Archive Search' => '아카이브 검색',

        # Template: AgentTicketZoom
        'Sender Type' => '발신자 유형',
        'Save filter settings as default' => '필터 설정을 기본값으로 저장',
        'Event Type' => '이벤트 유형',
        'Save as default' => '기본값으로 저장',
        'Drafts' => '체커',
        'Change Queue' => '대기열 변경',
        'There are no dialogs available at this point in the process.' =>
            '현재 이 과정에서 사용할 수 있는 대화 상자가 없습니다.',
        'This item has no articles yet.' => '이 항목에는 아직 기사가 없습니다.',
        'Ticket Timeline View' => '티켓 타임 라인보기',
        'Article Overview - %s Article(s)' => '기사 개관 - %s건의 기사',
        'Page %s' => '페이지 %s',
        'Add Filter' => '필터 추가',
        'Set' => '세트',
        'Reset Filter' => '필터 재설정',
        'No.' => '아니오.',
        'Unread articles' => '읽지 않은 기사',
        'Via' => '~를 이용해',
        'Important' => '중대한',
        'Unread Article!' => '읽지 않은 기사!',
        'Incoming message' => '수신 메시지 ',
        'Outgoing message' => '보내는 메시지',
        'Internal message' => '내부 메시지',
        'Sending of this message has failed.' => '이 메시지를 보내지 못했습니다.',
        'Resize' => '크기 조정',
        'Mark this article as read' => '이 기사를 읽음으로 표시 하십시오.',
        'Show Full Text' => '전체 텍스트 보기',
        'Full Article Text' => '전체 기사 텍스트',
        'No more events found. Please try changing the filter settings.' =>
            '이벤트가 더이상 없습니다. 필터 설정을 변경하십시오.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => '%s를 통해',
        'by %s' => '%s에 의해',
        'Toggle article details' => '기사 세부 정보 토글',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '이 메시지는 처리 중입니다. 이미 %s의 시간(s)을 보냈습니다. 다음 시도는 %s입니다.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '다음 문서에서 링크를 열려면 Ctrl 또는 Cmd 또는 Shift 키를 누른 상태에서 링크를 클릭해야합니다 (브라우저 및 OS에 따라 다름).',
        'Close this message' => '이 메시지를 닫습니다.',
        'Image' => '이미지',
        'PDF' => 'PDF',
        'Unknown' => '알 수 없는',
        'View' => '전망',

        # Template: LinkTable
        'Linked Objects' => '연결된 개체',

        # Template: TicketInformation
        'Archive' => '아카이브',
        'This ticket is archived.' => '이 티켓은 보관 처리됩니다.',
        'Note: Type is invalid!' => '참고 : 유형이 유효하지 않습니다!',
        'Pending till' => '대기 시간까지',
        'Locked' => '잠김',
        '%s Ticket(s)' => '%s개 티켓',
        'Accounted time' => '소요 시간',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '시스템에서 %s의 채널이 누락되었으므로이 기사의 미리보기를 사용할 수 없습니다.',
        'Please re-install %s package in order to display this article.' =>
            '이 기사를 표시하려면 %s의 패키지를 다시 설치하십시오.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '개인 정보를 보호하기 위해 원격 콘텐츠가 차단되었습니다.',
        'Load blocked content.' => '차단된 콘텐츠를 로드합니다.',

        # Template: Breadcrumb
        'Home' => '홈',
        'Back to admin overview' => '관리자 개요로 돌아가기',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '이 기능에는 클라우드 서비스가 필요합니다.',
        'You can' => '너는 할 수있다.',
        'go back to the previous page' => '이전 페이지로 돌아가기',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '고객 ID는 변경할 수 없으며이 티켓에 다른 고객 ID를 지정할 수 없습니다.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '먼저 고객 사용자를 선택한 다음이 티켓에 지정할 고객ID를 선택할 수 있습니다.',
        'Select a customer ID to assign to this ticket.' => '이 티켓에 지정할 고객 ID를 선택하십시오.',
        'From all Customer IDs' => '모든 고객 ID에서',
        'From assigned Customer IDs' => '할당 된 고객 ID로부터',

        # Template: CustomerDashboard
        'Ticket Search' => '',

        # Template: CustomerError
        'An Error Occurred' => '에러 발생됨',
        'Error Details' => '오류 정보',
        'Traceback' => '역 추적',

        # Template: CustomerFooter
        'Powered by %s' => 'Powered by %s',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '연결이 일시적으로 끊어진 후 다시 설정되었습니다. 이로 인해이 페이지의 요소가 올바르게 작동하지 않을 수 있습니다. 모든 요소를 ​​올바르게 다시 사용할 수있게하려면이 페이지를 다시로드하는 것이 좋습니다.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript를 사용할 수 없음',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '이 소프트웨어를 사용하려면 브라우저에서 JavaScript를 활성화해야합니다.',
        'Browser Warning' => '브라우저 경고',
        'The browser you are using is too old.' => '사용중인 브라우저가 너무 오래되었습니다.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '이 소프트웨어는 거대한 브라우저 목록과 함께 실행됩니다.이 중 하나를 업그레이드하십시오.',
        'Please see the documentation or ask your admin for further information.' =>
            '자세한 내용은 설명서를 참조하거나 관리자에게 문의하십시오.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'An Internet Explorer compatible version will soon be released nonetheless.' =>
            '',
        'One moment please, you are being redirected...' => '잠시만 기다려주십시오. 리디렉션 중입니다...',
        'Login' => '로그인',
        'Your user name' => '사용자 이름',
        'User name' => '사용자 이름',
        'Your password' => '너의 비밀번호',
        'Forgot password?' => '비밀번호를 잊으셨나요?',
        'Your 2 Factor Token' => '당신의 2 팩터 토큰',
        '2 Factor Token' => '2 요소 토큰',
        'Log In' => '로그인',
        'Request Account' => '',
        'Request New Password' => '새 비밀번호 요청',
        'Your User Name' => '사용자 이름',
        'A new password will be sent to your email address.' => '새 비밀번호가 이메일 주소로 전송됩니다.',
        'Create Account' => '계정 만들기',
        'Please fill out this form to receive login credentials.' => '로그인 자격 증명을 받으려면 이 양식을 작성하십시오.',
        'How we should address you' => '우리가 너를 어떻게 대해야하는지',
        'Your First Name' => '당신의 이름',
        'Your Last Name' => '당신의 성',
        'Your email address (this will become your username)' => '귀하의 이메일 주소 (귀하의 사용자 이름이됩니다)',

        # Template: CustomerNavigationBar
        'Logout' => '로그아웃',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => '환영!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => '서비스 수준 계약',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'New Ticket' => '새 티켓',
        'Page' => '페이지',
        'Tickets' => '티켓',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => '프로필',
        'e. g. 10*5155 or 105658*' => '이자형. 지. 10 * 5155 또는 105658 *',
        'CustomerID' => '고객 ID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '티켓에서 전체 텍스트 검색 (예 : "John * n"또는 "Will *")',
        'Types' => '유형',
        'Time Restrictions' => '시간 제한',
        'No time settings' => '시간 설정 없음',
        'All' => '모든',
        'Specific date' => '특정 날짜',
        'Only tickets created' => '생성된 티켓만',
        'Date range' => '날짜 범위',
        'Only tickets created between' => '사이에 생성된 티켓만',
        'Ticket Archive System' => '티켓 보관 시스템',
        'Save Search as Template?' => '검색을 템플릿으로 저장하시겠습니까?',
        'Save as Template?' => '템플릿으로 저장?',
        'Save as Template' => '템플릿으로 저장?',
        'Template Name' => '템플릿 이름',
        'Pick a profile name' => '프로필 이름 선택',
        'Output to' => '출력',

        # Template: CustomerTicketSearchResultShort
        'of' => '의',
        'Search Results for' => '에 대한 검색 결과',
        'Remove this Search Term.' => '이 검색 용어를 제거하십시오.',

        # Template: CustomerTicketZoom
        'Reply' => '댓글',
        'Discard' => '',
        'Ticket Information' => '티켓 정보',
        'Categories' => '',

        # Template: Chat
        'Expand article' => '기사 펼치기',

        # Template: CustomerWarning
        'Warning' => '경고',

        # Template: Tile_NewTicket
        'Issue<br/>a ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '이벤트 정보',
        'Ticket fields' => '타켓 필드',

        # Template: Error
        'Send a bugreport' => 'bugreport 보내기',
        'Expand' => '넓히다',

        # Template: AttachmentList
        'Click to delete this attachment.' => '첨부파일을 삭제하려면 클릭하십시오.',

        # Template: DraftButtons
        'Update draft' => '초안 업데이트',
        'Save as new draft' => '새 초안으로 저장',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '"%s"초안을 로드했습니다.',
        'You have loaded the draft "%s". You last changed it %s.' => '"%s"초안을 로드했습니다. 마지막으로 %s로 변경했습니다.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '"%s"초안을로드했습니다. 마지막으로%s %s변경되었습니다.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '이 초안이 작성된 이후 티켓이 수정되었기 때문에 이 초안은 구식입니다.',

        # Template: Header
        'Edit personal preferences' => '개인 환경 설정 편집',
        'Personal preferences' => '개인 환경설정',
        'You are logged in as' => '귀하는 다음 계정으로 로그인했습니다.',

        # Template: Installer
        'JavaScript not available' => '자바스트립트를 사용할 수 없습니다.',
        'Step %s' => '%s 단계',
        'License' => '특허',
        'Database Settings' => '데이터베이스 설정',
        'General Specifications and Mail Settings' => '일반 사양 및 메일 설정',
        'Finish' => '끝',
        'Welcome to %s' => '%s에 오신 것을 환영합니다.',
        'Germany' => '',
        'Phone' => '전화',
        'Switzerland' => '',
        'Web site' => '웹 사이트',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '아웃 바운드 메일 구성',
        'Outbound mail type' => '발신 메일 유형',
        'Select outbound mail type.' => '아웃바운드 메일 유형을 선택하십시오.',
        'Outbound mail port' => '발신 메일 포트',
        'Select outbound mail port.' => '아웃 바운드 메일 포트를 선택하십시오.',
        'SMTP host' => 'SMTP 호스트',
        'SMTP host.' => 'SMTP 호스트',
        'SMTP authentication' => 'SMTP 인증',
        'Does your SMTP host need authentication?' => 'SMTP 호스트에 인증이 필요합니까?',
        'SMTP auth user' => 'SMTP 인증 사용자',
        'Username for SMTP auth.' => 'SMTP 인증을위한 사용자 이름.',
        'SMTP auth password' => 'SMTP 인증 암호',
        'Password for SMTP auth.' => 'SMTP 인증을위한 암호.',
        'Configure Inbound Mail' => '인바운드 메일 구성',
        'Inbound mail type' => '인바운드 메일 유형',
        'Select inbound mail type.' => '인바운드 메일 유형을 선택하십시오.',
        'Inbound mail host' => '인바운드 메일 호스트',
        'Inbound mail host.' => '인바운드 메일 호스트',
        'Inbound mail user' => '인바운드 메일 사용자',
        'User for inbound mail.' => '인바운드 메일의 사용자입니다.',
        'Inbound mail password' => '인바운드 메일 암호',
        'Password for inbound mail.' => '인바운드 메일의 비밀번호 입니다.',
        'Result of mail configuration check' => '메일 구성 검사 결과',
        'Check mail configuration' => '메일 구성 확인',
        'Skip this step' => '이 단계를 건너뛰기',

        # Template: InstallerDBResult
        'Done' => '끝난',
        'Error' => '오류',
        'Database setup successful!' => '데이터베이스 설정이 설공적으로 완료되었습니다!',

        # Template: InstallerDBStart
        'Install Type' => '설치 유형',
        'Create a new database for OTOBO' => 'OTOBO를위한 새로운 데이터베이스 생성',
        'Use an existing database for OTOBO' => 'OTOBO에 기존 데이터베이스 사용',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '데이터베이스의 루트 암호를 설정 한 경우 여기에 입력해야합니다. 그렇지 않은 경우이 필드를 비워 두십시오.',
        'Database name' => '데이터베이스 이름',
        'Check database settings' => '데이터베이스 설정 확인',
        'Result of database check' => '데이터베이스 검사 결과',
        'Database check successful.' => '데이터베이스 검사에 성공했습니다.',
        'Database User' => '데이터베이스 사용자',
        'New' => '새로운',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            '제한된 권한을 가진 새로운 데이터베이스 사용자가이 OTOBO 시스템에 대해 생성됩니다.',
        'Repeat Password' => '비밀번호 반복',
        'Generated password' => '생성된 암호',

        # Template: InstallerDBmysql
        'Passwords do not match' => '비밀번호가 일치하지 않습니다.',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTOBO를 사용하려면 명령 줄 (터미널 / 쉘)에 다음 행을 루트로 입력해야합니다.',
        'Restart your webserver' => '웹 서버 다시 시작',
        'After doing so your OTOBO is up and running.' => '그렇게하면 OTOBO가 실행됩니다.',
        'Start page' => '시작 페이지',
        'Your OTOBO Team' => 'OTOBO 팀',

        # Template: InstallerLicense
        'Don\'t accept license' => '면허를 받지마라.',
        'Accept license and continue' => '라이센스 수락 및 계속',

        # Template: InstallerSystem
        'SystemID' => '시스템 ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '시스템 식별자. 각 티켓 ​​번호와 각 HTTP 세션 ID에는이 번호가 들어 있습니다.',
        'System FQDN' => '시스템 FQDN',
        'Fully qualified domain name of your system.' => '시스템의 완전한 도메인 이름.',
        'AdminEmail' => 'AdminEmail',
        'Email address of the system administrator.' => '시스템 관리자의 전자 메일 주소입니다.',
        'Organization' => '조직',
        'Log' => '로그',
        'LogModule' => '로그모듈',
        'Log backend to use.' => '사용할 백엔드를 기록하십시오.',
        'LogFile' => '로그파일',
        'Webfrontend' => '웹 프론트 엔드',
        'Default language' => '기본 언어',
        'Default language.' => '기본 언어',
        'CheckMXRecord' => 'CheckMXRecord',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '수동으로 입력 한 전자 메일 주소는 DNS에있는 MX 레코드와 비교하여 검사됩니다. DNS가 느리거나 공개 주소를 확인하지 못하면이 옵션을 사용하지 마십시오.',

        # Template: LinkObject
        'Delete link' => '링크 삭제',
        'Delete Link' => '링크 삭제',
        'Object#' => '목적#',
        'Add links' => '링크 추가',
        'Delete links' => '링크 삭제',

        # Template: Login
        'Lost your password?' => '비밀번호를 잊어 버렸습니까?',
        'Back to login' => '로그인으로 돌아 가기',

        # Template: MetaFloater
        'Scale preview content' => '미리보기 콘텐츠 크기 조정',
        'Open URL in new tab' => '새 탭에서 URL 열기',
        'Close preview' => '미리보기 닫기',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '이 웹 사이트의 미리보기는 삽입할 수 없기 때문에 제공할 수 없습니다.',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '사용할 수없는 기능',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '죄송합니다. 현재 OTOBO의이 기능은 휴대 기기에서 사용할 수 없습니다. 이 기능을 사용하려면 데스크톱 모드로 전환하거나 일반 데스크톱 장치를 사용할 수 있습니다.',

        # Template: Motd
        'Message of the Day' => '오늘의 메시지',
        'This is the message of the day. You can edit this in %s.' => '오늘의 메시지입니다. 이것을 %s에서 편집 할 수 있습니다.',

        # Template: NoPermission
        'Insufficient Rights' => '불충분한 권리',
        'Back to the previous page' => '이전 페이지로 돌아가기',

        # Template: Alert
        'Alert' => '경보',
        'Powered by' => 'Powered by',

        # Template: Pagination
        'Show first page' => '첫 페이지 표시',
        'Show previous pages' => '이전 페이지 보기',
        'Show page %s' => '%s페이지보기',
        'Show next pages' => '다음 페이지보기',
        'Show last page' => '마지막 페이지 표시',

        # Template: PictureUpload
        'Need FormID!' => 'FormID가 필요합니다!',
        'No file found!' => '파일을 찾을 수 없습니다!',
        'The file is not an image that can be shown inline!' => '파일은 인라인으로 표시할 수 있는 이미지가 아닙니다!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '사용자가 구성할 수 있는 알림이 없습니다.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '\'%s\' 알림 메시지를 전송 방법 \'%s\'을 통해 수신합니다.',

        # Template: ActivityDialogHeader
        'Process Information' => '프로세스 정보',
        'Dialog' => '대화',

        # Template: Article
        'Inform Agent' => '에이전트에게 알리기',

        # Template: PublicDefault
        'Welcome' => '환영',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '이것은 OTOBO의 기본 공용 인터페이스입니다! 주어진 행동 매개 변수가 없습니다.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '공용 인터페이스가있는 FAQ 모듈과 같이 (패키지 관리자)를 통해 사용자 정의 공용 모듈을 설치할 수 있습니다.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '권한',
        'You can select one or more groups to define access for different agents.' =>
            '하나 이상의 그룹을 선택하여 다른 에이전트에 대한 엑세스를 정의할 수 있습니다.',
        'Result formats' => '결과 포맷',
        'Time Zone' => '시간대',
        'The selected time periods in the statistic are time zone neutral.' =>
            '통계에서 선택한 기간은 시간대 중립입니다.',
        'Create summation row' => '합계 행 만들기',
        'Generate an additional row containing sums for all data rows.' =>
            '모든 데이터 행에 대한 합계를 포함하는 추가 행을 생성하십시오.',
        'Create summation column' => '합계 열 만들기',
        'Generate an additional column containing sums for all data columns.' =>
            '모든 데이터 열에 대해 합계를 포함하는 추가 열을 생성하십시오.',
        'Cache results' => '결과 캐시',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '동일한 구성으로 후속 뷰에서 사용할 통계 결과 데이터를 캐시에 저장합니다 (적어도 하나의 선택된 시간 필드 필요).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '상담원이 대시 보드에서 활성화 할 수있는 위젯으로 통계를 제공합니다.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '대시 보드 위젯을 활성화하면 대시 보드에서 이 통계에 대한 캐싱이 활성화됩니다.',
        'If set to invalid end users can not generate the stat.' => '무효로 설정된 경우 최종사용자는 통계를 생성할 수 없습니다.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '이 통계 구성에 문제가 있습니다.',
        'You may now configure the X-axis of your statistic.' => '이제 통계의 X 축을 구성 할 수 있습니다.',
        'This statistic does not provide preview data.' => '이 통계는 미리보기 데이터를 제공하지 않습니다.',
        'Preview format' => '미리보기 형식',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '미리보기는 무작위 데이터를 사용하며 데이터 필터는 고려하지 않습니다.',
        'Configure X-Axis' => 'X 축 구성',
        'X-axis' => 'X 축',
        'Configure Y-Axis' => 'Y 축 구성',
        'Y-axis' => 'Y축',
        'Configure Filter' => '필터 구성',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '요소 하나만 선택하거나 \'고정\'버튼을 해제하십시오.',
        'Absolute period' => '절대 기간',
        'Between %s and %s' => '%s에서 %s 사이',
        'Relative period' => '상대 기간',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '과거 %s완료 및 현재 + 다음 완료 %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            '통계가 생성될 때 이 요소에 대한 변경을 허용하지 마십시오.',

        # Template: StatsParamsWidget
        'Format' => '체재',
        'Exchange Axis' => '교환 축',
        'Configurable Params of Static Stat' => '정적 통계의 구성 가능한 매개 변수',
        'No element selected.' => '선택된 요소가 없습니다.',
        'Scale' => '규모',
        'show more' => '자세히보기',
        'show less' => '적은 것을 보여준다',

        # Template: D3
        'Download SVG' => 'SVG 다운로드',
        'Download PNG' => 'PNG 다운로드',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '선택한 기간은 이 통계가 데이터를 수집하는 기본 시간 프레임을 정의합니다.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '선택한 기간을 보고 데이터 요소로 분할하는데 사용할 시간 단위를 정의합니다.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Y 축의 축척은 X 축의 축척보다 커야합니다 (예 : X 축 => 월, Y 축 => 연도).',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => '이 설정은 사용할 수 없습니다.',
        'This setting is fixed but not deployed yet!' => '이 설정은 고정되어 있지만 아직 배포되지 않았습니다!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '이 설정은 현재 %s에서 덮어써지고 있으므로 여기에서 변경할 수 없습니다!',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '%s (%s)가 현재이 설정을 진행 중입니다.',
        'Toggle advanced options for this setting' => '이 설정에 대한 고급 옵션 토글',
        'Disable this setting, so it is no longer effective' => '이 설정을 비활성화하면 더이상 효과적이지 않습니다.',
        'Disable' => '사용 안함',
        'Enable this setting, so it becomes effective' => '이 설정을 사용하면 효과적입니다.',
        'Enable' => '사용',
        'Reset this setting to its default state' => '이 설정을 기본 상태로 재설정하십시오.',
        'Reset setting' => '재설정 설정',
        'Allow users to adapt this setting from within their personal preferences' =>
            '사용자가 개인 환경 설정에서 이 설정을 적용하도록 허용',
        'Allow users to update' => '사용자가 업데이트하도록 허용',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '사용자가 자신의 개인 취향 내에서 이 설정을 더이상 적용할 수 없게 하십시오.',
        'Forbid users to update' => '사용자가 업데이트 하는 것을 금지합니다.',
        'Show user specific changes for this setting' => '이 설정에 대한 사용자별 변경 사항 표시',
        'Show user settings' => '사용자 설정 표시',
        'Copy a direct link to this setting to your clipboard' => '이 설정에 대한 직접 링크를 클립 보드로 복사하십시오.',
        'Copy direct link' => '직접 링크 복사',
        'Remove this setting from your favorites setting' => '즐겨찾기 설정에서 이 설정을 제거하십시오.',
        'Remove from favourites' => '즐겨찾기에서 삭제',
        'Add this setting to your favorites' => '즐겨찾기에 이 설정 추가',
        'Add to favourites' => '즐겨찾기에 추가',
        'Cancel editing this setting' => '이 설정 편집 취소',
        'Save changes on this setting' => '이 설정의 변경사항 저장',
        'Edit this setting' => '이 설정 편집',
        'Enable this setting' => '이 설정 사용',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '이 그룹에는 설정이 없습니다. 하위 그룹 또는 다른 그룹으로 이동해보십시오.',

        # Template: SettingsListCompare
        'Now' => '지금',
        'User modification' => '사용자 수정',
        'enabled' => '사용 가능',
        'disabled' => '불구가 된',
        'Setting state' => '상태 설정 중',

        # Template: Actions
        'Edit search' => '검색 수정',
        'Go back to admin: ' => '관리자에게 돌아가기 : ',
        'Deployment' => '전개',
        'My favourite settings' => '내가 가장 좋아하는 설정',
        'Invalid settings' => '설정이 잘못되었습니다.',

        # Template: DynamicActions
        'Filter visible settings...' => '표시 설정 필터링...',
        'Enable edit mode for all settings' => '모든 설정에 대해 편집 모드 사용',
        'Save all edited settings' => '편집된 모든 설정 저장',
        'Cancel editing for all settings' => '모든 설정에 대한 편집 취소',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '이 위젯의 모든 동작은 오른쪽의 보이는 설정에만 적용됩니다.',

        # Template: Help
        'Currently edited by me.' => '현재 나를 편집했습니다.',
        'Modified but not yet deployed.' => '수정되었지만 아직 배치되지 않았습니다.',
        'Currently edited by another user.' => '다른 사용자가 현재 편집 중입니다.',
        'Different from its default value.' => '기본값과 다릅니다.',
        'Save current setting.' => '현재 설정을 저장하십시오.',
        'Cancel editing current setting.' => '현재 설정 편집 취소.',

        # Template: Navigation
        'Navigation' => '항해',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'OTOBO 테스트 페이지',
        'Unlock' => '잠금해제',
        'Welcome %s %s' => '환영합니다 %s %s',
        'Counter' => '계수기',

        # Template: Warning
        'Go back to the previous page' => '이전 페이지로 돌아가기',

        # JS Template: CalendarSettingsDialog
        'Show' => '보여주다',

        # JS Template: FormDraftAddDialog
        'Draft title' => '초안 제목',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '기사 표시',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '"%s"을 정말로 삭제 하시겠습니까?',
        'Confirm' => '확인',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '로딩 중 기다려주세요...',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '업로드 할 파일을 선택하려면 클릭하십시오.',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => '여기를 클릭하여 파일을 선택하거나 그냥 클릭하십시오.',
        'Click to select a file or just drop it here.' => '클릭하여 파일을 선택하거나 여기에 놓으십시오.',
        'Uploading...' => '업로드 중...',

        # JS Template: InformationDialog
        'Process state' => '프로세스 상태',
        'Running' => '달리는',
        'Finished' => '끝마친',
        'No package information available.' => '사용할 수있는 패키지 정보가 없습니다.',

        # JS Template: AddButton
        'Add new entry' => '새 항목 추가',

        # JS Template: AddHashKey
        'Add key' => '키 추가',

        # JS Template: DialogDeployment
        'Deployment comment...' => '배포 설명...',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '배포 중입니다. 잠시 기다려주십시오...',
        'Preparing to deploy, please wait...' => '배포 준비 중입니다, 기다려주세요...',
        'Deploy now' => '지금 배포',
        'Try again' => '다시 시도하십시오.',

        # JS Template: DialogReset
        'Reset options' => '재설정 옵션',
        'Reset setting on global level.' => '글로벌 수준에서 설정을 다시 설정하십시오.',
        'Reset globally' => '전 세계적으로 재설정',
        'Remove all user changes.' => '모든 사용자 변경 사항을 제거하십시오.',
        'Reset locally' => '로컬로 재설정',
        'user(s) have modified this setting.' => '사용자(S)가 이 설정을 수정했습니다.',
        'Do you really want to reset this setting to it\'s default value?' =>
            '이 설정을 기본값으로 재설정 하시겠습니까?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '범주 선택을 사용하여 아래 탐색 트리를 선택한 범주의 항목으로 제한 할 수 있습니다. 카테고리를 선택하자마자 트리가 다시 빌드됩니다.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '데이터베이스 백엔드',
        'CustomerIDs' => '고객ID',
        'Fax' => '팩스',
        'Street' => '거리',
        'Zip' => 'Postal Code',
        'City' => '시티',
        'Country' => '국가',
        'Mr.' => 'Mr.',
        'Mrs.' => 'Mrs.',
        'Address' => '주소',
        'View system log messages.' => '시스템 로그 메시지를 봅니다.',
        'Edit the system configuration settings.' => '시스템 구성 설정을 편집 하십시오.',
        'Update and extend your system with software packages.' => '소프트웨어 패키지로 시스템을 업데이트하고 확장하십시오.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '데이터베이스의 ACL 정보가 시스템 구성과 일치하지 않습니다. 모든 ACL을 배포하십시오.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '알 수없는 오류로 인해 ACL을 가져올 수 없습니다. 자세한 내용은 OTOBO 로그를 확인하십시오.',
        'The following ACLs have been added successfully: %s' => '다음 ACL이 성공적으로 추가되었습니다 : %s',
        'The following ACLs have been updated successfully: %s' => '다음 ACL이 성공적으로 업데이트되었습니다 : %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '다음 ACL을 추가 / 업데이트 할 때 오류가 발생합니다 : %s. 자세한 정보는 로그 파일을 확인하십시오.',
        'There was an error creating the ACL' => 'ACL을 만드는 중 오류가 발생했습니다.',
        'Need ACLID!' => 'ACLID가 필요합니다!',
        'Could not get data for ACLID %s' => 'ACLID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the ACL' => 'ACL 업데이트 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status.' => '엔티티 동기화 상태를 설정하는 중에 오류가 발생했습니다.',
        'There was an error synchronizing the ACLs.' => 'ACL을 동기화하는 중 오류가 발생했습니다.',
        'ACL %s could not be deleted' => 'ACL %s을 삭제할 수 없습니다.',
        'There was an error getting data for ACL with ID %s' => 'ID가 %s 인 ACL에 대한 데이터를 가져 오는 중 오류가 발생했습니다.',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '수퍼 유저 계정 (UserID 1)에 대한 ACL 제한은 무시됩니다.',
        'Exact match' => '정확히 일치',
        'Negated exact match' => '부정 일치 검색',
        'Regular expression' => '정규식',
        'Regular expression (ignore case)' => '정규식 (대소 문자 무시)',
        'Negated regular expression' => '부정적인 정규 표현식',
        'Negated regular expression (ignore case)' => '부정적 정규 표현식 (대소 문자 무시)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '시스템에서 캘린더를 만들 수 없습니다!',
        'Please contact the administrator.' => '관리자에게 문의하십시오.',
        'No CalendarID!' => 'CalendarID 없음!',
        'You have no access to this calendar!' => '이 캘린더에 액세스 할 수 없습니다.',
        'Error updating the calendar!' => '달력을 업데이트하는 중 오류가 발생했습니다!',
        'Couldn\'t read calendar configuration file.' => '달력 구성 파일을 읽을 수 없습니다.',
        'Please make sure your file is valid.' => '파일이 유효한지 확인하십시오.',
        'Could not import the calendar!' => '캘린더를 가져올 수 없습니다!',
        'Calendar imported!' => '가져온 캘린더!',
        'Need CalendarID!' => 'CalendarID가 필요합니다!',
        'Could not retrieve data for given CalendarID' => '주어진 CalendarID에 대한 데이터를 검색 할 수 없습니다.',
        'Successfully imported %s appointment(s) to calendar %s.' => '%s의 약속을 캘린더 %s에  가져 왔습니다.',
        '+5 minutes' => '+5분',
        '+15 minutes' => '+15분',
        '+30 minutes' => '+30분',
        '+1 hour' => '+1시간',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '권한 없음',
        'System was unable to import file!' => '시스템에서 파일을 가져올 수 없습니다!',
        'Please check the log for more information.' => '자세한 내용은 로그를 확인하십시오.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '알람 이름이 이미 있습니다!',
        'Notification added!' => '알림 추가됨!',
        'There was an error getting data for Notification with ID:%s!' =>
            'ID가 %s 인 알림 데이터를 가져 오는 중 오류가 발생했습니다.',
        'Unknown Notification %s!' => '알 수없는 알림 %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => '알림을 만드는 중 오류가 발생했습니다.',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '알 수없는 오류로 인해 알림을 가져올 수 없습니다. 자세한 내용은 OTOBO 로그를 확인하십시오.',
        'The following Notifications have been added successfully: %s' =>
            '다음 알림이 성공적으로 추가되었습니다 : %s',
        'The following Notifications have been updated successfully: %s' =>
            '다음 알림이 성공적으로 업데이트되었습니다 : %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '다음 알림을 추가 / 업데이트하는 중에 오류가 발생합니다 : %s. 자세한 정보는 로그 파일을 확인하십시오.',
        'Notification updated!' => '알림이 업데이트 되었습니다!',
        'Agent (resources), who are selected within the appointment' => '약속 내에서 선택된 상담원 (리소스)',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '약속 (캘린더)에 대한 (적어도) 읽기 권한이있는 모든 상담원',
        'All agents with write permission for the appointment (calendar)' =>
            '약속 (캘린더)에 대한 쓰기 권한이있는 모든 상담원',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '첨부 파일이 추가되었습니다.',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '자동 응답이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '잘못된 CommunicationID!',
        'All communications' => '모든 통신',
        'Last 1 hour' => '지난 1시간',
        'Last 3 hours' => '지난 3시간',
        'Last 6 hours' => '지난 6시간',
        'Last 12 hours' => '지난 12시간',
        'Last 24 hours' => '지난 24시간',
        'Last week' => '지난주',
        'Last month' => '지난 달',
        'Invalid StartTime: %s!' => '잘못된 시작 시간 : %s!',
        'Successful' => '성공한',
        'Processing' => '가공',
        'Failed' => '실패한',
        'Invalid Filter: %s!' => '잘못된 필터 : %s!',
        'Less than a second' => '1초 미만',
        'sorted descending' => '내림차순 정렬',
        'sorted ascending' => '오름차순으로 정렬된',
        'Trace' => '자취',
        'Debug' => '디버그',
        'Info' => '정보',
        'Warn' => '경고',
        'days' => '일',
        'day' => '일',
        'hour' => '시간',
        'minute' => '분',
        'seconds' => '초',
        'second' => '초',

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
        'Customer company updated!' => '고객 회사가 업데이트 되었습니다!',
        'Dynamic field %s not found!' => '동적 필드 %s을 찾을 수 없습니다!',
        'Unable to set value for dynamic field %s!' => '동적 필드 %s에 대한 값을 설정할 수 없습니다!',
        'Customer Company %s already exists!' => '고객 회사 %s가 이미 존재합니다!',
        'Customer company added!' => '고객 회사가 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '\'CustomerGroupPermissionContext\'에 대한 구성이 없습니다!',
        'Please check system configuration.' => '시스템 구성을 확인하십시오.',
        'Invalid permission context configuration:' => '잘못된 권한 컨텍스트 구성 : ',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '고객 업데이트됨',
        'New phone ticket' => '새로운 폰 티켓',
        'New email ticket' => '새로운 메일 티켓',
        'Customer %s added' => '고객 추가됨 : %s',
        'Customer user updated!' => '고객 사용자 업데이트됨',
        'Same Customer' => '같은 고객',
        'Direct' => '직접',
        'Indirect' => '간접적',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '그룹에 대한 고객 사용자 관계 변경',
        'Change Group Relations for Customer User' => '고객 사용자를 위한 그룹 관계 변경',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '고객 사용자를 서비스에 할당',
        'Allocate Services to Customer User' => '고객 사용자에게 서비스 할당',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '필드 설정이 바르지 않습니다.',
        'Objects configuration is not valid' => '오브젝트 설정이 바르지 않습니다.',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '동적 필드 순서를 제대로 재설정 할 수 없습니다. 자세한 내용은 오류 로그를 확인하십시오.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '지정되지 않은 서브액션',
        'Need %s' => '%s 필요',
        'Add %s field' => '%s 필드 추가',
        'The field does not contain only ASCII letters and numbers.' => '입력란에는 ASCII 문자와 숫자 만 포함되지 않습니다.',
        'There is another field with the same name.' => '같은 이름의 다른 필드가 있습니다.',
        'The field must be numeric.' => '이 필드는 숫자여야 합니다.',
        'Need ValidID' => 'ValidID 필요',
        'Could not create the new field' => '새 필드를 만들지 못했습니다.',
        'Need ID' => '신분증이 필요함',
        'Could not get data for dynamic field %s' => '동적 필드 %s에 대한 데이터를 가져올 수 없습니다.',
        'Change %s field' => '동적 필드 %s에 대한 데이터가 없습니다.',
        'The name for this field should not change.' => '이 입력란의 이름은 변경해서는 안됩니다.',
        'Could not update the field %s' => '%s 필드를 업데이트 할 수 없습니다.',
        'Currently' => '현재',
        'Unchecked' => '선택하지 않았다.',
        'Checked' => '체크됨',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => '이 필드 값은 중복됩니다.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '미래의 날짜 입력 금지',
        'Prevent entry of dates in the past' => '과거 날짜 입력 금지',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '받는 사람을 한 명 이상 선택하십시오.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => '분(s)',
        'hour(s)' => '시간(s)',
        'Time unit' => '시간 단위',
        'within the last ...' => '마지막으로...',
        'within the next ...' => '내에서...',
        'more than ... ago' => '이상...전',
        'Unarchived tickets' => '보관되지 않은 티켓',
        'archive tickets' => '보관 티켓',
        'restore tickets from archive' => '보관에서 티켓을 복원',
        'Need Profile!' => '프로필이 필요',
        'Got no values to check.' => '확인할 가치가 없습니다.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '티켓 선택에 사용할 수 없으므로 다음 단어를 삭제하십시오.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebserviceID가 필요합니다!',
        'Could not get data for WebserviceID %s' => 'WebserviceID %s에 대한 데이터를 가져올 수 없습니다.',
        'ascending' => '오름차순',
        'descending' => '내림차순',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '통신 유형이 필요합니다!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '통신 유형은 \'리퀘 스터\'또는 \'제공자\'여야합니다!',
        'Invalid Subaction!' => '부제가 잘못되었습니다.',
        'Need ErrorHandlingType!' => 'ErrorHandlingType이 필요합니다!',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType %s이 등록되지 않았습니다.',
        'Could not update web service' => '웹 서비스를 업데이트 할 수 없습니다.',
        'Need ErrorHandling' => 'ErrorHandling이 필요함',
        'Could not determine config for error handler %s' => 'Error handler %s에 대한 구성을 결정할 수 없습니다.',
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
        'Operation deleted' => '작업이 삭제되었습니다.',
        'Invoker deleted' => '호출자가 삭제되었습니다.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0초',
        '15 seconds' => '15초',
        '30 seconds' => '30초',
        '45 seconds' => '45초',
        '1 minute' => '1분',
        '2 minutes' => '2분',
        '3 minutes' => '3분',
        '4 minutes' => '4분',
        '5 minutes' => '5분',
        '10 minutes' => '10분',
        '15 minutes' => '15분',
        '30 minutes' => '30분',
        '1 hour' => '1시간',
        '2 hours' => '2시간',
        '3 hours' => '3시간',
        '4 hours' => '4시간',
        '5 hours' => '5시간',
        '6 hours' => '6시간',
        '12 hours' => '12시간',
        '18 hours' => '18시간',
        '1 day' => '1일',
        '2 days' => '2일',
        '3 days' => '3일',
        '4 days' => '4일',
        '6 days' => '6일',
        '1 week' => '1주',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Invoker %s의 구성을 결정할 수 없습니다.',
        'InvokerType %s is not registered' => 'InvokerType %s이 등록되지 않았습니다.',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '호출자가 필요합니다!',
        'Need Event!' => '이벤트가 필요합니다!',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'WebserviceID %s 의 설정을 업데이트 할 수 업습니다.',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => '끈',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Action type %s에 대한 등록 된 구성을 가져올 수 없습니다.',
        'Could not get backend for %s %s' => '%s %s의 백엔드를 가져올 수 없습니다.',
        'Keep (leave unchanged)' => '유지 (변경하지 않음)',
        'Ignore (drop key/value pair)' => '무시 (키 / 값 쌍 삭제)',
        'Map to (use provided value as default)' => '지도에 (제공된 값을 기본값으로 사용)',
        'Exact value(s)' => '정확한 값(들)',
        'Ignore (drop Value/value pair)' => '무시 (값 / 값 쌍 놓기)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '필요한 라이브러리 %s을 찾을 수 없습니다.',
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
        'Could not determine config for operation %s' => '%s Operation에 대한 구성을 결정할 수 없습니다.',
        'OperationType %s is not registered' => 'OperationType %s이 등록되지 않았습니다.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '유효한 서브 액션이 필요합니다!',
        'This field should be an integer.' => '이 필드는 정수여야 합니다.',
        'File or Directory not found.' => '파일 또는 디렉터리를 찾을 수 없음.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '같은 이름의 다른 웹 서비스가 있습니다.',
        'There was an error updating the web service.' => '웹',
        'There was an error creating the web service.' => '웹 서비스를 업데이트 하는 중 오류가 발생했습니다.',
        'Web service "%s" created!' => 'Web service "%s"가 생성되었습니다! ',
        'Need Name!' => '이름이 필요합니다!',
        'Need ExampleWebService!' => 'ExampleWebService가 필요합니다!',
        'Could not load %s.' => '',
        'Could not read %s!' => '%s를 읽을 수 없습니다!',
        'Need a file to import!' => '가져올 파일이 필요합니다!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            '가져온 파일에 유효한 YAML 콘텐츠가 없습니다! 자세한 내용은 OTOBO 로그를 확인하십시오.',
        'Web service "%s" deleted!' => 'Web service "%s"이 삭제되었습니다!',
        'OTOBO as provider' => '공급자 인 OTOBO',
        'Operations' => '운영',
        'OTOBO as requester' => '요청자 인 OTOBO',
        'Invokers' => '인보커',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '웹 서비스 기록 ID가 없습니다!',
        'Could not get history data for WebserviceHistoryID %s' => 'WebserviceHistoryID %s의 기록 데이터를 가져올 수 없습니다.',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => '그룹이 업데이트 되었습니다!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => '메일 계정이 추가되었습니다!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '이메일 계정 가져오기가 이미 다른 프로세스에서 가져왔습니다. 나중에 다시 시도 해주십시오!',
        'Dispatching by email To: field.' => '이메일로 발송 : 수신자 : 필드.',
        'Dispatching by selected Queue.' => '선택한 대기열로 발송.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '티켓을 만든 에이전트',
        'Agent who owns the ticket' => '티켓을 소유한 에이전트',
        'Agent who is responsible for the ticket' => '티켓을 책임지는 요원',
        'All agents watching the ticket' => '티켓을 보고 있는 모든 요원',
        'All agents with write permission for the ticket' => '티켓에 대한 쓰기 권한이 있는 모든 에이전트',
        'All agents subscribed to the ticket\'s queue' => '모든 상담원이 티켓 대기열에 가입합니다.',
        'All agents subscribed to the ticket\'s service' => '티켓의 서비스에 가입한 모든 에이전트',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '티켓의 대기열과 서비스 모두에 가입한 모든 에이전트',
        'Customer user of the ticket' => '티켓의 고객 사용자',
        'All recipients of the first article' => '첫 번째 기사의 모든 수신자',
        'All recipients of the last article' => '마지막 기사의 모든 수신자',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP 환경이 작동하지 않습니다. 자세한 정보는 로그를 확인하십시오!',
        'Need param Key to delete!' => '필요한 param을 삭제하십시오!',
        'Key %s deleted!' => '키 %s 삭제됨!',
        'Need param Key to download!' => '다운로드하려면 param이 필요합니다!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            '죄송합니다, Apache :: Reload는 Apache config 파일의 PerlModule 및 PerlInitHandler로 필요합니다. scripts / apache2-httpd.include.conf도 참조하십시오. 또는 명령 행 도구 bin / otobo.Console.pl을 사용하여 패키지를 설치할 수 있습니다!',
        'No such package!' => '그런 패키지는 없습니다!',
        'No such file %s in package!' => '패키지에 %s 파일이 없습니다!',
        'No such file %s in local file system!' => '로컬 파일 시스템에 %s 파일이 없습니다!',
        'Can\'t read %s!' => '%s를 읽을 수 없습니다!',
        'File is OK' => '파일은 정상입니다.',
        'Package has locally modified files.' => '패키지에 로컬로 수정된 파일이 있습니다.',
        'Package not verified by the OTOBO Team! It is recommended not to use this package.' =>
            '패키지가 OTRS 그룹에 의해 확인되지 않았습니다! 이 패키지를 사용하지 않는 것이 좋습니다.',
        'Not Started' => '시작되지 않음',
        'Updated' => '업데이트 됨',
        'Already up-to-date' => '이미 최신',
        'Installed' => '설치됨',
        'Not correctly deployed' => '올바르게 배치되지 않음',
        'Package updated correctly' => '패키지가 올바르게 업데이트 되었습니다.',
        'Package was already updated' => '패키지가 이미 업데이트 되었습니다.',
        'Dependency installed correctly' => '종속성이 올바르게 설치 되었습니다.',
        'The package needs to be reinstalled' => '패키지를 다시 설치해야 합니다.',
        'The package contains cyclic dependencies' => '패키지에는 순환 종속성이 있습니다.',
        'Not found in on-line repositories' => '온라인 리포지토리에는 없습니다.',
        'Required version is higher than available' => '필수 버전이 사용 가능한 버전보다 큽니다.',
        'Dependencies fail to upgrade or install' => '종속성을 업그레이드 또는 설치하지 못함',
        'Package could not be installed' => '패키지를 설치할 수 없습니다.',
        'Package could not be upgraded' => '패키지를 업그레이드 할 수 없습니다.',
        'Repository List' => '저장소 목록',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '확인 서버와의 통신 문제로 인해 패키지가 확인되지 않았습니다!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'OTOBO 기능 추가 기능 목록 서버에 연결할 수 없습니다!',
        'Can\'t get OTOBO Feature Add-on list from server!' => '서버에서 OTOBO 기능 추가 기능 목록을 가져올 수 없습니다!',
        'Can\'t get OTOBO Feature Add-on from server!' => '서버에서 OTOBO 기능 추가 기능을 가져올 수 없습니다!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '해당 필터 없음 : %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '우선 순위가 추가되었습니다.',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '데이터베이스의 프로세스 관리 정보가 시스템 구성과 동기화되지 않았습니다. 모든 프로세스를 동기화 하십시오.',
        'Need ExampleProcesses!' => 'ExampleProcesses가 필요합니다!',
        'Need ProcessID!' => 'ProcessID가 필요합니다!',
        'Yes (mandatory)' => '예 (필수)',
        'Unknown Process %s!' => '알 수없는 프로세스 %s!',
        'There was an error generating a new EntityID for this Process' =>
            '이 프로세스에 대한 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'The StateEntityID for state Inactive does not exists' => '상태 비활성에 대한 StateEntityID가 없습니다.',
        'There was an error creating the Process' => '프로세스를 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '프로세스 엔티티에 대한 엔티티 동기화 상태를 설정하는 중 오류가 발생했습니다 : %s',
        'Could not get data for ProcessID %s' => 'ProcessID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the Process' => '프로세스를 업데이트 하는 중 오류가 발생했습니다.',
        'Process: %s could not be deleted' => 'Process : %s을 삭제할 수 없습니다.',
        'There was an error synchronizing the processes.' => '프로세스를 동기화하는 중 오류가 발생했습니다.',
        'The %s:%s is still in use' => '%s : %s는 아직 사용 중입니다.',
        'The %s:%s has a different EntityID' => '%s : %s의 EntityID가 다릅니다.',
        'Could not delete %s:%s' => '%s : %s을 삭제할 수 없습니다.',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '엔티티 동기화 상태 설정 오류 : %s, 엔티티 %s',
        'Could not get %s' => '%s를 얻을 수 없음',
        'Need %s!' => '%s 필요!',
        'Process: %s is not Inactive' => 'Process : %s이 비활성 상태가 아닙니다.',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '이 활동에 대한 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the Activity' => '활동을 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Activity 엔티티에 대한 엔티티 동기화 상태를 설정하는 중 오류가 발생했습니다 : %s',
        'Need ActivityID!' => 'ActivityID가 필요합니다!',
        'Could not get data for ActivityID %s' => 'ActivityID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the Activity' => '활동을 업데이트 하는 중 오류가 발생했습니다.',
        'Missing Parameter: Need Activity and ActivityDialog!' => '누락 된 매개 변수 : 필요한 활동 및 ActivityDialog!',
        'Activity not found!' => '활동을 찾을 수 없습니다!',
        'ActivityDialog not found!' => 'ActivityDialog를 찾을 수 없습니다!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog가 이미 Activity에 할당되었습니다. ActivityDialog를 두 번 추가 할 수는 없습니다!',
        'Error while saving the Activity to the database!' => '활동을 데이터베이스에 저장하는 동안 오류가 발생했습니다!',
        'This subaction is not valid' => '이 하위 작업이 유효하지 않습니다.',
        'Edit Activity "%s"' => 'Activity 편집 "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '이 ActivityDialog에 대한 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the ActivityDialog' => 'ActivityDialog를 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'ActivityDialog 엔터티에 대한 엔터티 동기화 상태를 설정하는 중 오류가 발생했습니다 : %s',
        'Need ActivityDialogID!' => 'ActivityDialogID가 필요합니다!',
        'Could not get data for ActivityDialogID %s' => 'ActivityDialogID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the ActivityDialog' => 'ActivityDialog를 업데이트하는 중 오류가 발생했습니다.',
        'Edit Activity Dialog "%s"' => 'Activity Dialog 수정 "%s"',
        'Agent Interface' => '에이전트 인터페이스',
        'Customer Interface' => '고객 인터페이스',
        'Agent and Customer Interface' => '에이전트 및 고객 인터페이스',
        'Do not show Field' => '필드 표시 안 함',
        'Show Field' => '필드 표시',
        'Show Field As Mandatory' => '필수 입력란으로 표시',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '경로 편집',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '이 전환에 대해 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the Transition' => '전환을 만드는 중에 오류가 발생했습니다.',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '전환 엔티티에 대한 엔티티 동기화 상태를 설정하는 중에 오류가 발생했습니다 : %s',
        'Need TransitionID!' => '전환 ID가 필요합니다!',
        'Could not get data for TransitionID %s' => 'TransitionID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the Transition' => '전환을 업데이트 하는 중 오류가 발생했습니다.',
        'Edit Transition "%s"' => '전환 편집 "%s"',
        'Transition validation module' => '전환 유효성 검사 모듈',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '하나 이상의 유효한 config 매개 변수가 필요합니다.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '이 TransitionAction에 대한 새로운 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the TransitionAction' => 'TransitionAction을 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'TransitionAction 항목의 항목 동기화 상태를 설정하는 중에 오류가 발생했습니다 : %s',
        'Need TransitionActionID!' => 'TransitionActionID가 필요합니다!',
        'Could not get data for TransitionActionID %s' => 'TransitionActionID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the TransitionAction' => 'TransitionAction을 업데이트하는 중 오류가 발생했습니다.',
        'Edit Transition Action "%s"' => '전환 Action 편집 "%s"',
        'Error: Not all keys seem to have values or vice versa.' => '오류 : 모든 키가 값을 가진 것처럼 보이지 않거나 그 반대의 경우도 있습니다.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => '대기열이 업데이트 되었습니다.',
        'Don\'t use :: in queue name!' => '큐 이름에 ::를 사용하지 마십시오!',
        'Click back and change it!' => '뒤로 클릭하고 변경하십시오!',
        '-none-' => '- 없음 -',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '대기열 (자동 응답 없음)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '템플릿에 대한 대기열 관계 변경',
        'Change Template Relations for Queue' => '대기열에 대한 템플릿 관계 변경',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '생산',
        'Test' => '테스트',
        'Training' => '훈련',
        'Development' => '개발',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => '역할이 업데이트 되었습니다!',
        'Role added!' => '역할이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => '역할에 대한 그룹 관계 변경',
        'Change Role Relations for Group' => '그룹의 역할 관계 변경',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '역할',
        'Change Role Relations for Agent' => '에이전트의 역할 관계 변경',
        'Change Agent Relations for Role' => '역할에 대한 에이전트 관계 변경',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '먼저 %s를 활성화하십시오!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S / MIME 환경이 작동하지 않습니다. 자세한 정보는 로그를 확인하십시오!',
        'Need param Filename to delete!' => '제거 할 param 파일 이름이 필요합니다!',
        'Need param Filename to download!' => 'param 파일 이름을 다운로드해야합니다!',
        'Needed CertFingerprint and CAFingerprint!' => '필요한 CertFingerprint 및 CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint는 CertFingerprint와 달라야합니다.',
        'Relation exists!' => '관계가 존재합니다!',
        'Relation added!' => '관계가 추가되었습니다!',
        'Impossible to add relation!' => '관계를 추가할 수 없습니다!',
        'Relation doesn\'t exists' => '관계가 존재하지 않습니다.',
        'Relation deleted!' => '관계가 삭제되었습니다!',
        'Impossible to delete relation!' => '관계를 삭제할 수 없습니다!',
        'Certificate %s could not be read!' => '인증서 %s을 읽을 수 없습니다.',
        'Needed Fingerprint' => '필요한 지문',
        'Handle Private Certificate Relations' => '개인 인증서 관계 처리',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '인사말이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '서명이 업데이트 되었습니다!',
        'Signature added!' => '서명이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => '상태가 추가 되었습니다!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '파일 %s을 읽을 수 없습니다!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => '시스템 전자 메일 주소가 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '잘못된 설정',
        'There are no invalid settings active at this time.' => '현재 잘못된 설정이 활성화되어 있지 않습니다.',
        'You currently don\'t have any favourite settings.' => '현재 즐겨찾는 설정이 없습니다.',
        'The following settings could not be found: %s' => '다음 설정을 찾을 수 없습니다 : %s',
        'Import not allowed!' => '가져오기가 허용되지 않습니다!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            '알 수없는 오류로 인해 시스템 구성을 가져올 수 없습니다. 자세한 내용은 OTOBO 로그를 확인하십시오.',
        'Category Search' => '카테고리 검색',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            '일부 가져온 설정은 구성의 현재 상태에 나타나지 않거나 업데이트 할 수 없습니다. 자세한 내용은 OTOBO 로그를 확인하십시오.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '잠금 전에 설정을 활성화해야 합니다!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '%s(%s)가 현재 작업 중이므로이 설정으로 작업 할 수 없습니다.',
        'Missing setting name!' => '설정 이름이 없습니다!',
        'Missing ResetOptions!' => '누락 된 ResetOptions!',
        'Setting is locked by another user!' => '다른 사용자가 설정을 잠갔습니다!',
        'System was not able to lock the setting!' => '시스템이 설정을 잠글 수 없습니다!',
        'System was not able to reset the setting!' => '시스템에서 설정을 재설정 할 수 없었습니다!',
        'System was unable to update setting!' => '시스템이 설정을 업데이트 할 수 없습니다!',
        'Missing setting name.' => '설정 이름이 없습니다.',
        'Setting not found.' => '설정을 찾을 수 없습니다.',
        'Missing Settings!' => '설정이 없습니다!',

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
        'Start date shouldn\'t be defined after Stop date!' => '시작일은 종요일 이후에 정의되어서는 안됩니다!',
        'There was an error creating the System Maintenance' => '시스템 유지 보수를 작성하는 중 오류가 발생했습니다.',
        'Need SystemMaintenanceID!' => 'SystemMaintenanceID가 필요합니다!',
        'Could not get data for SystemMaintenanceID %s' => 'SystemMaintenanceID %s에 대한 데이터를 가져올 수 없습니다.',
        'System Maintenance was added successfully!' => '시스템 유지 보수가 성공적으로 추가 되었습니다!',
        'System Maintenance was updated successfully!' => '시스템 유지 보수가 성공적으로 업데이트되었습니다!',
        'Session has been killed!' => '세션이 종료되었습니다!',
        'All sessions have been killed, except for your own.' => '모든 세션이 자신의 것을 제외한 모든 세션에서 종료되었습니다.',
        'There was an error updating the System Maintenance' => '시스템 유지 보수를 업데이트하는 중 오류가 발생했습니다.',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'SystemMaintenance 항목을 삭제할 수 없습니다 : %s',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '템플릿이 업데이트 되었습니다!',
        'Template added!' => '템플릿이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '템플릿에 대한 첨부 파일 관계 변경',
        'Change Template Relations for Attachment' => '첨부 파일에 대한 템플릿 관계 변경',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '유형 필요!',
        'Type added!' => '유형이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '에이전트가 업데이트 되었습니다!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => '에이전트에 대한 그룹 관계 변경',
        'Change Agent Relations for Group' => '그룹에 대한 상담원 관계 변경',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => '달',
        'Week' => '주',
        'Day' => '일',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '모든 약속',
        'Appointments assigned to me' => '나에게 할당된 약속',
        'Showing only appointments assigned to you! Change settings' => '나에게 할당된 약속만 표시! 설정 변경',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '약속을 찾을 수 없습니다!',
        'Never' => '절대로',
        'Every Day' => '매일',
        'Every Week' => '매주',
        'Every Month' => '매달',
        'Every Year' => '매년',
        'Custom' => '관습',
        'Daily' => '매일',
        'Weekly' => '주간',
        'Monthly' => '월간',
        'Yearly' => '연간',
        'every' => '...마다',
        'for %s time(s)' => '1 % s 시간 동안',
        'until ...' => '때까지...',
        'for ... time(s)' => '...시간(들) 동안',
        'until %s' => '%s 까지',
        'No notification' => '알림없음',
        '%s minute(s) before' => '%s 분전',
        '%s hour(s) before' => '%s 시간전',
        '%s day(s) before' => '%s 일전',
        '%s week before' => '%s 주일 전에',
        'before the appointment starts' => '약속 시작 전에',
        'after the appointment has been started' => '약속이 시작된 후',
        'before the appointment ends' => '약속이 끝나기 전에',
        'after the appointment has been ended' => '약속이 끝난 후',
        'No permission!' => '비허가!',
        'Cannot delete ticket appointment!' => '티켓 예약을 삭제할 수 없습니다!',
        'No permissions!' => '비허가!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s 이상',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => '고객 이력',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'RecipientField가 제공되지 않습니다!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '%s에 해당하는 설정이 없습니다.',
        'Statistic' => '통계량',
        'No preferences for %s!' => '%s에 대한 환경 설정이 없습니다!',
        'Can\'t get element data of %s!' => '%s의 요소 데이터를 가져올 수 없습니다!',
        'Can\'t get filter content data of %s!' => '%s의 필터 콘텐츠 데이터를 가져올 수 없습니다!',
        'Customer Name' => '고객 이름',
        'Customer User Name' => '고객 사용자 이름',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'SourceObject와 SourceKey가 필요합니다!',
        'You need ro permission!' => '당신은 허가가 필요합니다!',
        'Can not delete link with %s!' => '%s의 링크를 삭제할 수 없습니다!',
        '%s Link(s) deleted successfully.' => '%s 링크(들)가 성공적으로 삭제되었습니다.',
        'Can not create link with %s! Object already linked as %s.' => '%s의 링크를 만들 수 없습니다! 개체가 이미 %s로 연결되었습니다.',
        'Can not create link with %s!' => '%s의 링크를 만들 수 없습니다!',
        '%s links added successfully.' => '%s의 링크가 성공적으로 추가되었습니다.',
        'The object %s cannot link with other object!' => '%s의 개체는 다른 개체와 연결할 수 없습니다!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Param 그룹이 필요합니다!',
        'This feature is not available.' => '',
        'Updated user preferences' => '업데이트 된 사용자 환경설정',
        'System was unable to deploy your changes.' => '시스템에서 변경 사항을 배치할 수 없습니다.',
        'Setting not found!' => '설정을 찾을 수 없습니다!',
        'System was unable to reset the setting!' => '시스템에서 설정을 재설정 할 수 없습니다!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '티켓 처리',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '매개 변수 %s이 없습니다.',
        'Invalid Subaction.' => '부제가 잘못되었습니다.',
        'Statistic could not be imported.' => '통계를 가져올 수 없습니다.',
        'Please upload a valid statistic file.' => '유효한 통계 파일을 업로드 하십시오.',
        'Export: Need StatID!' => '내보내기 : StatID가 필요합니다!',
        'Delete: Get no StatID!' => '삭제 : StatID를 가져 오지 마십시오!',
        'Need StatID!' => 'StatID가 필요합니다!',
        'Could not load stat.' => '통계를 로드 할 수 없습니다.',
        'Add New Statistic' => '새 통계 추가',
        'Could not create statistic.' => '통계를 만들 수 없습니다.',
        'Run: Get no %s!' => '실행 :  No %s 획득!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'TicketID가 주어지지 않았습니다!',
        'You need %s permissions!' => '%s의 권한이 필요합니다!',
        'Loading draft failed!' => '초안로드 실패!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '죄송합니다. 이 작업을 수행하려면 티켓 소유자여야 합니다.',
        'Please change the owner first.' => '먼저 소유자를 변경하십시오.',
        'FormDraft functionality disabled!' => 'FormDraft 기능이 비활성화되었습니다!',
        'Draft name is required!' => '초안 이름이 필요합니다!',
        'FormDraft name %s is already in use!' => 'FormDraft 이름 %s이 이미 사용 중입니다!',
        'Could not perform validation on field %s!' => '%s 필드에서 유효성 검사를 수행 할 수 없습니다!',
        'No subject' => '제목 없음',
        'Could not delete draft!' => '초안을 삭제할 수 없습니다!',
        'Previous Owner' => '이전 소유자',
        'wrote' => '쓴',
        'Message from' => '님의 메시지',
        'End message' => '메시지 끝내기',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s가 필요합니다!',
        'Plain article not found for article %s!' => '%s Article에 대한 일반 Article이 없습니다!',
        'Article does not belong to ticket %s!' => 'Article는 티켓 %s에 속하지 않습니다!',
        'Can\'t bounce email!' => '이메일을 반송할 수 없습니다!',
        'Can\'t send email!' => '이메일을 보낼 수 없습니다!',
        'Wrong Subaction!' => '잘못된 교섭!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '티켓을 잠글 수 없으며 TicketID가 제공되지 않습니다!',
        'Ticket (%s) is not unlocked!' => '티켓 (%s)은 잠금 해제되지 않았습니다!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '하나 이상의 티켓을 선택해야 합니다.',
        'Bulk feature is not enabled!' => '대량 기능을 사용할 수 없습니다!',
        'No selectable TicketID is given!' => '선택할 수있는 TicketID가 제공되지 않습니다!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '티켓을 선택하지 않았거나 다른 상담원이 잠근 티켓만 선택했습니다.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '다음 티켓은 다른 에이전트에 의해 잠겨 있거나이 티켓에 대한 쓰기 권한이 없기 때문에 무시되었습니다 : %s.',
        'The following tickets were locked: %s.' => '다음 티켓이 잠겼습니다 : %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => '주소 %s는 등록 된 고객 주소로 바뀝니다.',
        'Customer user automatically added in Cc.' => 'Cc에 고객 사용자가 자동으로 추가되었습니다.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => '티켓 "%s"가 생성되었습니다!',
        'No Subaction!' => '아니요!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'TicketID가 없습니다!',
        'System Error!' => '시스템 오류!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'ArticleID가 주어지지 않았습니다!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '다음 주',
        'Ticket Escalation View' => '티켓 Escalation 뷰',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'Article %s을 찾을 수 없습니다!',
        'Forwarded message from' => '에서 전달된 메시지',
        'End forwarded message' => '전달된 메시지 끝내기',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '기록을 표시 할 수 없으며 TicketID가 제공되지 않습니다!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '티켓을 잠글 수 없으며 TicketID가 제공되지 않습니다!',
        'Sorry, the current owner is %s!' => '죄송합니다, 현재 소유자는 %s입니다!',
        'Please become the owner first.' => '먼저 주인이 되십시오.',
        'Ticket (ID=%s) is locked by %s!' => '티켓 (ID = %s)이 %s에 의해 잠김!',
        'Change the owner!' => '소유자 변경',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => '새 게시물',
        'Pending' => '지연',
        'Reminder Reached' => '알림발생',
        'My Locked Tickets' => '나의 잠긴 티켓',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '티켓을 합칠 수 없습니다.',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '이동할 권한이 없습니다.',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '채팅이 Active 되지 않음',
        'No permission.' => '권한 없음',
        '%s has left the chat.' => '%s이 채팅에서 탈퇴했습니다.',
        'This chat has been closed and will be removed in %s hours.' => '이 채팅은 폐쇄되었으며 %s 시간 후에 삭제됩니다.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => '티켓이 잠겼습니다.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '아니 ArticleID!',
        'This is not an email article.' => '이것은 이메일 기사가 아닙니다.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '평범한 기사를 읽을 수 없습니다! 어쩌면 백엔드에 일반 전자 메일이 없습니다! 백엔드 메시지를 읽습니다.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'TicketID가 필요합니다!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'ActivityDialogEntityID "%s"을 가져올 수 없습니다!',
        'No Process configured!' => '프로세스가 구성되지 않았습니다!',
        'The selected process is invalid!' => '선택한 프로세스가 유효하지 않습니다!',
        'Process %s is invalid!' => '프로세스 %s이 잘못되었습니다!',
        'Subaction is invalid!' => '하위 작업이 잘못되었습니다.',
        'Parameter %s is missing in %s.' => '매개 변수 %s이 없습니다. %s',
        'No ActivityDialog configured for %s in _RenderAjax!' => '_RenderAjax에서 %s에 대해 구성된 ActivityDialog 없음!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '프로세스에 대한 Start ActivityEntityID 또는 Start ActivityDialogEntityID가 없습니다. _GetParam에서 %s!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'TicketID에 대한 티켓을 가져올 수 없습니다 : _GetParam에서 %s!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'ActivityEntityID를 결정할 수 없습니다. DynamicField 또는 Config가 올바르게 설정되지 않았습니다!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s 구성 값이 없습니다!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'ProcessEntityID 또는 TicketID 및 ActivityDialogEntityID가 없습니다!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'ProcessEntityID "%s"에 대해 StartActivityDialog 및 StartActivityDialog를 가져올 수 없습니다!',
        'Can\'t get Ticket "%s"!' => '티켓 "%s"을 얻을 수 없습니다!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '티켓 "%s"에 대한 ProcessEntityID 또는 ActivityEntityID를 가져올 수 없습니다!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'ActivityEntityID "%s"에 대한 활동 구성을 가져올 수 없습니다!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'ActivityDialogEntityID "%s"에 대한 ActivityDialog 구성을 가져올 수 없습니다!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '"%s"필드에 대한 데이터를 가져올 수 없습니다! ActivityDialog "%s" ',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '상태 또는 StateID가 동일한 ActivityDialog에 대해 구성된 경우 PendingTime을 사용할 수 있습니다. ActivityDialog : %s!',
        'Pending Date' => '보류 날짜',
        'for pending* states' => '보류 중 * 상태',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID가 없습니다!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'ActivityDialogEntityID "%s"에 대한 구성을 가져올 수 없습니다!',
        'Couldn\'t use CustomerID as an invisible field.' => '보이지 않는 필드로 CustomerID를 사용할 수 없습니다.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '누락 된 ProcessEntityID, ActivityDialogHeader.tt를 확인하십시오!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '프로세스 "%s"에 대한 StartActivityDialog 또는 StartActivityDialog가 구성되지 않았습니다!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'ProcessEntityID "%s"로 프로세스 티켓을 만들 수 없습니다!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'ProcessEntityID "%s"을 설정할 수 없습니다! TicketID "%s"에',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'ActivityEntityID "%s"을 설정할 수 없습니다! TicketID "%s"',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'ActivityDialog를 저장할 수 없습니다. 유효하지 않습니다. TicketID : %s!',
        'Invalid TicketID: %s!' => '잘못된 TicketID : %s!',
        'Missing ActivityEntityID in Ticket %s!' => '티켓 %s에 ActivityEntityID가 누락되었습니다!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '이 단계는 \'%s %s %s\'티켓의 진행중인 현재 활동에 더 이상 속하지 않습니다! 다른 사용자가이 티켓을 변경했습니다. 이 창을 닫고 티켓을 다시로드하십시오.',
        'Missing ProcessEntityID in Ticket %s!' => '티켓 %s에 ProcessEntityID가 누락되었습니다!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '%s의 DynamicField값 설정할 수 없음 - 티켓 ID "%s" - ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'PendingTime 설정할 수 없음 - 티켓 ID "%s" - ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '잘못된 ActivityDialog 필드 설정 : %s는 표시 => 1 / 표시 필드 일 수 없습니다. (표시 => 0 / 필드 표시 안 함 또는 표시 => 2 / 표시 필드를 필수로 변경하십시오)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '%s 설정할 수 없음 - 티켓 ID "%s" - ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'Process::Default%s 의 기본 구성이 누락되었습니다!',
        'Default Config for Process::Default%s invalid!' => 'Process::Default%s 의 기본 구성이 잘못되었습니다!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => '가능한 티켓',
        'including subqueues' => '하위대기열 포함',
        'excluding subqueues' => '하위대기열 제외',
        'QueueView' => '대기열보기',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => '내 책임있는 티켓',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => '최종검색',
        'Untitled' => '이름없음',
        'Ticket Number' => '티켓 번호',
        'Ticket' => '티켓',
        'printed by' => '프린트',
        'CustomerID (complex search)' => '고객ID(복합검색)',
        'CustomerID (exact match)' => '고객ID(일치)',
        'Invalid Users' => '잘못된 사용자',
        'Normal' => '일반',
        'CSV' => 'CSV',
        'Excel' => '엑셀',
        'in more than ...' => '이상...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '부가기능이 사용가능하지 않음',
        'Service View' => '서비스 뷰',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => '상태 뷰',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => '내가 본 티켓',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '부가기능이 활성화되지 않음',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '링크 삭제됨',
        'Ticket Locked' => '티켓이 잠김',
        'Pending Time Set' => '지연시간 셋팅',
        'Dynamic Field Updated' => 'Dynamic 필트가 업데이트됨',
        'Outgoing Email (internal)' => '발송 이메일(내부)',
        'Ticket Created' => '티켓이 생성됨',
        'Type Updated' => '타입이 생성됨',
        'Escalation Update Time In Effect' => '효과의 에스컬레이션 업데이트 시간',
        'Escalation Update Time Stopped' => '에스컬레이션 업데이트 시간 중지됨',
        'Escalation First Response Time Stopped' => '에스컬레이션 첫 번째 응답 시간 중지됨',
        'Customer Updated' => '고객가 업데이트됨',
        'Internal Chat' => '내부 채팅',
        'Automatic Follow-Up Sent' => '자동 후속 보냄',
        'Note Added' => '노트가 추가됨',
        'Note Added (Customer)' => '노트가 추가됨(고객)',
        'SMS Added' => 'SMS 추가됨',
        'SMS Added (Customer)' => 'SMS 추가됨(고객)',
        'State Updated' => '상태가 업데이트됨',
        'Outgoing Answer' => '답변 보내기',
        'Service Updated' => '서비스가 업데이트됨',
        'Link Added' => '링크가 추가됨',
        'Incoming Customer Email' => '수신 고객 이메일',
        'Incoming Web Request' => '수신 웹 요청',
        'Priority Updated' => '심각도 업데이트됨',
        'Ticket Unlocked' => '티켓이 잠금해제됨',
        'Outgoing Email' => '발신 이메일',
        'Title Updated' => '제목이 업데이트됨',
        'Ticket Merged' => '티켓이 합쳐짐',
        'Outgoing Phone Call' => '발신 전화',
        'Forwarded Message' => '전달된 메시지',
        'Removed User Subscription' => '삭제된 사용자 가입',
        'Time Accounted' => '회계 시간',
        'Incoming Phone Call' => '수신 전화',
        'System Request.' => '시스템 요청',
        'Incoming Follow-Up' => '들어오는 후속 조치',
        'Automatic Reply Sent' => '자동으로 답변 보냄',
        'Automatic Reject Sent' => '자동으로 거부 보냄',
        'Escalation Solution Time In Effect' => '에스컬레이션 솔루션 시간의 효과',
        'Escalation Solution Time Stopped' => '에스컬레이션 솔루션 시간 중지됨',
        'Escalation Response Time In Effect' => '에스컬레이셔 응답 시간',
        'Escalation Response Time Stopped' => '에스컬레이션 응답 시간 중지됨',
        'SLA Updated' => 'SLA 업데이트 됨',
        'External Chat' => '외부 채팅',
        'Queue Changed' => '대기열이 변경됨',
        'Notification Was Sent' => '알림을 보냈습니다.',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '이 티켓이 없거나 현재 상태로 액세스 할 수있는 권한이 없습니다.',
        'Missing FormDraftID!' => '누락 된 FormDraftID!',
        'Can\'t get for ArticleID %s!' => 'ArticleID %s를 얻을 수 없습니다!',
        'Article filter settings were saved.' => '기사 필터 설정이 저장되었습니다.',
        'Event type filter settings were saved.' => '이벤트 유형 필터 설정이 저장되었습니다.',
        'Need ArticleID!' => 'ArticleID가 필요합니다!',
        'Invalid ArticleID!' => '잘못된 ArticleID!',
        'Forward article via mail' => '우편으로 기사 전달',
        'Forward' => '전달',
        'Fields with no group' => '그룹이 없는 필드',
        'Invisible only' => '보이지 않는 곳만',
        'Visible only' => '표시 전용',
        'Visible and invisible' => '표시 및 숨김',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '기사를 열 수 없습니다! 아마 다른 기사 페이지에 있습니까?',
        'Show one article' => '기사 한 개 표시',
        'Show all articles' => '모든 기사 표시',
        'Show Ticket Timeline View' => '티켓 타임 라인보기 표시',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'FormID 없음.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '오류 : 파일을 제대로 삭제할 수 없습니다. 관리자에게 문의하십시오 (누락 된 FileID).',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'ArticleID이 필요합니다!',
        'No TicketID for ArticleID (%s)!' => 'ArticleID (%s)에 대한 TicketID가 없습니다!',
        'HTML body attachment is missing!' => 'HTML 본문 첨부가 없습니다.',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID와 ArticleID가 필요합니다!',
        'No such attachment (%s)!' => '첨부 파일이 없습니다 (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '%s::QueueDefault에 대한 SysConfig 설정을 확인하십시오.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '%s::TicketTypeDefault에 대한 SysConfig 설정을 확인하십시오.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '고객 ID가 필요합니다!',
        'My Tickets' => '내 티켓',
        'Company Tickets' => '회사 티켓',
        'Untitled!' => '제목없는!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '고객 실명',
        'Created within the last' => '마지막으로 생성된',
        'Created more than ... ago' => '만든 이상 ...전',
        'Please remove the following words because they cannot be used for the search:' =>
            '다음 단어를 검색에 사용할 수 없으므로 제거하십시오.',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '티켓을 다시 열 수 없으며 이 대기열에서 불가능합니다!',
        'Create a new ticket!' => '새 티켓을 만드십시오!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureMode 활성!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '설치 프로그램을 다시 실행하려면 SysConfig에서 SecureMode를 비활성화하십시오.',
        'Directory "%s" doesn\'t exist!' => '"%s" 디렉토리가 존재하지 않습니다!',
        'Configure "Home" in Kernel/Config.pm first!' => '먼저 Kernel / Config.pm에서 "홈"을 구성하십시오!',
        'File "%s/Kernel/Config.pm" not found!' => '"%s/Kernel/Config.pm"파일을 찾을 수 없습니다!',
        'Directory "%s" not found!' => '"%s" 디렉토리를 찾을 수 없습니다!',
        'Install OTOBO' => 'OTOBO 설치',
        'Intro' => '소개',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel / Config.pm에 쓸 수 없습니다!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '설치 프로그램을 사용하려면 웹 서버 사용자에게 Kernel / Config.pm 쓰기 권한을 설정하십시오!',
        'Database Selection' => '데이터베이스 선택',
        'Unknown Check!' => '알 수없는 확인!',
        'The check "%s" doesn\'t exist!' => '"%s" 체크가 존재하지 않습니다!',
        'Enter the password for the database user.' => '데이터베이스 사용자의 암호를입력하십시오.',
        'Database %s' => '데이터베이스 %s',
        'Configure MySQL' => 'MySQL 구성',
        'Enter the password for the administrative database user.' => '관리 데이터베이스 사용자의 암호를 입력하십시오.',
        'Configure PostgreSQL' => 'PostgreSQL 설정',
        'Configure Oracle' => 'Oracle 구성',
        'Unknown database type "%s".' => '알 수없는 데이터베이스 유형 "%s".',
        'Please go back.' => '돌아가 주세요.',
        'Create Database' => '데이터베이스 생성',
        'Install OTOBO - Error' => 'OTOBO 설치 - 오류',
        'File "%s/%s.xml" not found!' => '"%s / %s.xml"파일을 찾을 수 없습니다!',
        'Contact your Admin!' => '관리자에게 문의하십시오!',
        'System Settings' => '환경 설정',
        'Syslog' => 'Syslog',
        'Configure Mail' => '메일 구성',
        'Mail Configuration' => '메일 구성',
        'Can\'t write Config file!' => '구성 파일을 쓸 수 없습니다!',
        'Unknown Subaction %s!' => '알 수없는 Subaction %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '데이터베이스에 연결할 수 없습니다. Perl 모듈 DBD :: %s이 설치되지 않았습니다!',
        'Can\'t connect to database, read comment!' => '데이터베이스에 연결할 수 없으므로 주석을 읽으십시오!',
        'Database already contains data - it should be empty!' => '데이터베이스에 이미 데이터가 있습니다. 비워두워야 합니다.',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '오류 : 데이터베이스가 크기가 %s를 넘는 패킷을 수락하는지 확인하십시오 (패키지는 현재 최대 %s MB 만 허용). 오류를 피하기 위해 데이터베이스의 max_allowed_packet 설정을 조정하십시오.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '오류 : 데이터베이스의 innodb_log_file_size 값을 최소 %s MB (현재 : %s MB, 권장 : %s MB)로 설정하십시오. 자세한 내용은 %s를보십시오.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '잘못된 데이터베이스 정렬 (%s는 %s이지만 utf8이어야합니다).',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '아니 %s!',
        'No such user!' => '그런 사용자가 없습니다!',
        'Invalid calendar!' => '캘린더가 잘못되었습니다.',
        'Invalid URL!' => '잘못된 URL!',
        'There was an error exporting the calendar!' => '캘린더를 내보내는 중에 오류가 발생했습니다!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '구성 필요 패키지 :: RepositoryAccessRegExp',
        'Authentication failed from %s!' => '%s에서 인증 실패!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => '~에게 말을 걸다',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '다른 메일 주소로 기사 반송',
        'Bounce' => '되튐',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => '모든 응답',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '이 기사 다시 보내기',
        'Resend' => '재전송',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '이 기사의 메시지 로그 세부 사항보기',
        'Message Log' => '메시지 로그',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '메모에 회신',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => '이 기사 분할',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '이 기사의 출처보기',
        'Plain Format' => '일반 형식',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => '이 기사 인쇄',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'sales@otrs.com으로 문의하십시오.',
        'Get Help' => '도움말 보기',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => '마크',
        'Unmark' => '마크 해제',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '패키지 다시 설치',
        'Re-install' => '다시 설치',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Crypted',
        'Sent message encrypted to recipient!' => '수신자에게 암호화 된 메시지를 보냈습니다!',
        'Signed' => '서명 됨',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE"헤더가 발견되었지만 유효하지 않습니다!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S / MIME SIGNED MESSAGE"헤더가 발견되었지만 유효하지 않습니다!',
        'Ticket decrypted before' => '이 전에 해독된 티켓',
        'Impossible to decrypt: private key for email was not found!' => '불가능 해독 : 전자 메일의 개인 키를 찾을 수 없습니다!',
        'Successful decryption' => '성공적인 해독',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '주소에 사용할 수있는 암호화 키가 없습니다 \'%s\'.',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '주소에 대해 선택된 암호화 키가 없습니다 : \'%s\'.',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '암호화',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '키 / 인증서는 둘 이상의 키 / 인증서가있는 수신자에 대해서만 표시됩니다. 처음 발견 된 키 / 인증서가 사전 선택됩니다. 올바른 것을 선택하십시오.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '이메일 보안',
        'PGP sign' => 'PGP 서명',
        'PGP sign and encrypt' => 'PGP 서명 및 암호화',
        'PGP encrypt' => 'PGP 암호화',
        'SMIME sign' => 'SMIME 사인',
        'SMIME sign and encrypt' => 'SMIME 서명 및 암호화',
        'SMIME encrypt' => 'SMIME 암호화',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '\'%s\'주소에 사용할 수있는 서명 키가 없습니다.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '\'%s\'주소에 대해 선택한 서명 키가 없습니다.',
        'Sign' => '신호',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '하나 이상의 키 / 인증서가있는 발신자에 대해서만 키 / 인증서가 표시됩니다. 처음 발견 된 키 / 인증서가 사전 선택됩니다. 올바른 것을 선택하십시오.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => '표시된',
        'Refresh (minutes)' => '새로고침(분)',
        'off' => '떨어져서',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '표시된 고객 ID',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '표시된 고객 사용자',
        'Offline' => '오프라인',
        'User is currently offline.' => '사용자는 현재 오프라인 상태입니다.',
        'User is currently active.' => '사용자가 현재 활성 상태입니다.',
        'Away' => '떨어져',
        'User was inactive for a while.' => '사용자는 잠시동안 비활성 상태였습니다.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '종료 시간 후에 티켓의 시작 시간이 설정되었습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'OTOBO 뉴스 서버에 연결할 수 없습니다!',
        'Can\'t get OTOBO News from server!' => '서버에서 OTOBO 뉴스를 가져올 수 없습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '제품 뉴스 서버에 연결할 수 없습니다!',
        'Can\'t get Product News from server!' => '서버에서 제품 뉴스를 가져올 수 없습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '%s에 연결할 수 없습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => '표시된 티켓',
        'Shown Columns' => '표시된 열',
        'filter not active' => '필터가 활성화되지 않음',
        'filter active' => '활성 필터',
        'This ticket has no title or subject' => '이 티켓에는 제목이나 주제가 없습니다.',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '7일간 통계',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '사용자가 상태를 사용할 수 없도록 설정했습니다.',
        'Unavailable' => '불가능',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => '표준',
        'The following tickets are not updated: %s.' => '',
        'h' => '시간',
        'm' => '분',
        'd' => '일',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '이 티켓이 없거나 현재 상태로 액세스 할 수 있는 권한이 없습니다. 다음 작업 중 하나를 수행할 수 있습니다.',
        'This is a' => '이것은',
        'email' => '이메일',
        'click here' => '여기를 클릭',
        'to open it in a new window.' => '새 창에서 열려면.',
        'Year' => '년',
        'Hours' => '시간',
        'Minutes' => '분',
        'Check to activate this date' => '이 날짜를 활성화하려면 선택하십시오.',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => '비허가!',
        'No Permission' => '비허가',
        'Show Tree Selection' => '트리 선택 표시',
        'Split Quote' => '분할 견적',
        'Remove Quote' => '견적을 제거하십시오',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '로 연결된',
        'Search Result' => '검색 결과',
        'Linked' => '연결됨',
        'Bulk' => '일괄',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => '라이트',
        'Unread article(s) available' => '읽지 않은 기사(들)',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '약속',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '보관 검색',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => '온라인 상담원 : %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '에스컬레이트 된 티켓이 더 많습니다!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '환경 설정에서 시간대를 선택하고 저장버튼을 클릭하여 확인하십시오.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => '온라인 고객 : %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '시스템 유지 보수가 활성화 되었습니다!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '시스템 유지 보수 기간은 %s에서 시작되며 %s에서 중단 될 것으로 예상됩니다.',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO 데몬이 실행되고 있지 않습니다.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '부재 중 기능을 사용하도록 설정 했습니까? 사용하지 않도록 설정 하시겠습니까?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '배포된 %s 설정(들)이 잘못되었습니다. 잘못된 설정을 보려면 여기를 클릭하십시오.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '배포 취소 설정이 있습니다. 배포하시겠습니까?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '구성이 업데이트 되고 있습니다. 기다려주십시오...',
        'There is an error updating the system configuration!' => '시스템 구성을 업데이트 하는 중 오류가 발생했습니다!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '수퍼 유저 계정을 사용하여 %s 작업을하지 마십시오! 새 에이전트를 만들고 대신이 계정으로 작업하십시오.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '필수 알림을 위한 전송 방법을 하나 이상 선택했는지 확인하십시오.',
        'Preferences updated successfully!' => '환경 설정이 성공적으로 업데이트 되었습니다!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(과정에서)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '시작일 이후의 종료일을 지정 하십시오.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => '비밀번호 확인',
        'The current password is not correct. Please try again!' => '현재 암호가 올바르지 않습니다. 다시 시도하십시오!',
        'Please supply your new password!' => '새 암호를 입력하십시오!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '이 암호는 현재 시스템 구성에 의해 금지됩니다. 추가 질문이 있으면 관리자에게 문의하십시오.',
        'Can\'t update password, it must be at least %s characters long!' =>
            '암호를 업데이트 할 수 없습니다. 길이는 %s 이상이어야합니다!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '암호를 업데이트 할 수 없으며 최소 2 자의 대문자와 2 자 이상의 대문자를 포함해야합니다!',
        'Can\'t update password, it must contain at least 1 digit!' => '암호를 업데이트 할 수 없으며, 적어도 1자리 이상 포함해야합니다!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '비밀번호를 업데이트 할 수 없으며 문자 2 자 이상을 포함해야합니다!',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '시간대가 성공적으로 업데이트 되었습니다.',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => '무효의',
        'valid' => '유효한',
        'No (not supported)' => '아니요(지원되지 않음)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '과거 완료 또는 현재 + 향후 완료 상대시간 값이 없습니다.',
        'The selected time period is larger than the allowed time period.' =>
            '선택한 기간이 허용된 기간보다 깁니다.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'X축에서 현재 선택된 시간 눈금 값에 사용할 수있는 시간 눈금 값이 없습니다.',
        'The selected date is not valid.' => '선택한 날짜가 유효하지 않습니다.',
        'The selected end time is before the start time.' => '선택한 종료 시간은 시작시간 전입니다.',
        'There is something wrong with your time selection.' => '시간 선택에 문제가 있습니다.',
        'Please select only one element or allow modification at stat generation time.' =>
            '통계 생성 시간에 하나의 요소만 선택하거나 수정을 허용하십시오.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '이 필드의 값을 하나 이상 선택하거나 통계 생성 시간에 수정을 허용하십시오.',
        'Please select one element for the X-axis.' => 'X 축에 대해 하나의 요소를 선택하십시오.',
        'You can only use one time element for the Y axis.' => 'Y 축에는 하나의 시간 요소 만 사용할 수 있습니다.',
        'You can only use one or two elements for the Y axis.' => 'Y 축에는 하나 또는 두 개의 요소 만 사용할 수 있습니다.',
        'Please select at least one value of this field.' => '이 입력란의 값을 하나 이상 선택하십시오.',
        'Please provide a value or allow modification at stat generation time.' =>
            '통계 생성 시간에 값을 제공하거나 수정을 허용하십시오.',
        'Please select a time scale.' => '시간 척도를 선택하십시오.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '보고 시간 간격이 너무 작으면 더 큰 시간 척도를 사용하십시오.',
        'second(s)' => '초(s)',
        'quarter(s)' => '쿼터(s)',
        'half-year(s)' => '반년(들)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '다음 단어는 티켓 제한에 사용할 수 없으므로 제거하십시오. %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '이 설정 편집 및 잠금 해제를 취소하십시오.',
        'Reset this setting to its default value.' => '이 설정을 기본값으로 다시 설정하십시오.',
        'Unable to load %s!' => '%s를 로드 할 수 없습니다!',
        'Content' => '만족',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => '잠금 해제하여 다시 대기열로 보냅니다.',
        'Lock it to work on it' => '잠금 기능',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => '언 워치',
        'Remove from list of watched tickets' => '감상한 티켓 목록에서 제거',
        'Watch' => '살피다',
        'Add to list of watched tickets' => '시청 티켓 목록에 추가',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '주문',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => '잠긴 티켓 신규',
        'Locked Tickets Reminder Reached' => '잠긴 티켓 알리미에 도달 했습니다.',
        'Locked Tickets Total' => '잠긴 티켓 합계',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => '책임 티켓',
        'Responsible Tickets Reminder Reached' => '책임감 있는 티켓 알림 도달',
        'Responsible Tickets Total' => '책임 티켓 총계',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => '새로운 티켓을 보았습니다.',
        'Watched Tickets Reminder Reached' => '감상한 티켓 알리미에 도달함',
        'Watched Tickets Total' => '총 시청 티켓',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '티켓 동적 필드',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'ACL 구성 파일을 읽을 수 없습니다. 파일이 유효한지 확인하십시오.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '현재 예약된 시스템 유지보수로 인해 로그인 할 수 없습니다.',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => '세션이 잘못되었습니다. 다시 로그인하십시오.',
        'Session has timed out. Please log in again.' => '세션 시간이 초과되었습니다. 다시 로그인하십시오.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'PGP 서명 만',
        'PGP encrypt only' => 'PGP 만 암호화 함',
        'SMIME sign only' => 'SMIME 서명 만',
        'SMIME encrypt only' => 'SMIME 암호화 만',
        'PGP and SMIME not enabled.' => 'PGP 및 SMIME이 활성화되지 않았습니다.',
        'Skip notification delivery' => '알림 전달 건너 뛰기',
        'Send unsigned notification' => '서명되지 않은 알림 보내기',
        'Send unencrypted notification' => '암호화되지 않은 알림을 보냅니다.',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '구성 옵션 참조',
        'This setting can not be changed.' => '이 설정은 변경할 수 없습니다.',
        'This setting is not active by default.' => '이 설정은 기본적으로 활성화되어 있지 않습니다.',
        'This setting can not be deactivated.' => '이 설정은 비활성화 할 수 없습니다.',
        'This setting is not visible.' => '이 설정은 표시되지 않습니다.',
        'This setting can be overridden in the user preferences.' => '이 설정은 사용자 기본 설정에서 무시할 수 있습니다.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '이 설정은 사용자 기본 설정에서 무시될 수 있지만 기본적으로 활성화되지는 않습니다.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '고객 사용자 "%s"이 이미 있습니다.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '이 이메일 주소는 이미 다른 고객 사용자를 위해 사용 중입니다.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => '전/후',
        'between' => '사이에',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '예 : 텍스트 또는 문자 *',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '이 입력란을 무시하십시오.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => '이 필드는 필수이거나',
        'The field content is too long!' => '입력란 내용이 너무 깁니다.',
        'Maximum size is %s characters.' => '최대 크기는%s자입니다.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '알림 구성 파일을 읽을 수 없습니다. 파일이 유효한지 확인하십시오.',
        'Imported notification has body text with more than 4000 characters.' =>
            '가져온 알림에는 4000자 이상의 본문 텍스트가 있습니다.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '설치되지 않았다.',
        'installed' => '설치된',
        'Unable to parse repository index document.' => '저장소 색인 문서를 구문 분석 할 수 없습니다.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '이 저장소에 있는 프레임 워크 버전의 패키지가 없으며 다른 프레임 워크 버전의 패키지만 포함합니다.',
        'File is not installed!' => '파일이 설치되지 않았습니다!',
        'File is different!' => '파일이 다릅니다!',
        'Can\'t read file!' => '파일을 읽을 수 없습니다!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTOBO service contracts.</p>' =>
            '1이 패키지를 계속 설치하면 다음과 같은 문제가 발생할 수 있습니다. 123 보안 문제 34 안정성 문제 45 성능 문제 566이 패키지로 작업하여 발생하는 문제는 OTOBO 서비스 계약의 적용을받지 않습니다.',
        '<p>The installation of packages which are not verified by the OTOBO Team is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '"%s"프로세스와 모든 데이터가 성공적으로 가져 왔습니다.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '비활성',
        'FadeAway' => '사라지다',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '등록 서버에 접속할 수 없습니다. 나중에 다시 시도 해주십시오.',
        'No content received from registration server. Please try again later.' =>
            '등록 서버에서 받은 내용이 없습니다. 나중에 다시 시도 해주십시오.',
        'Can\'t get Token from sever' => '토큰을 서버에서 가져올 수 없습니다.',
        'Username and password do not match. Please try again.' => '사용자 이름과 암호가 일치하지 않습니다. 다시 시도하십시오.',
        'Problems processing server result. Please try again later.' => '서버 결과 처리 문제. 나중에 다시 시도 해주십시오.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '합집합',
        'week' => '주',
        'quarter' => '쿼터',
        'half-year' => '반년',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '상태 유형',
        'Created Priority' => '생성된 우선 순위',
        'Created State' => '생성된 주',
        'Create Time' => '시간 생성',
        'Pending until time' => '시간까지 보류 중입니다.',
        'Close Time' => '종료 시간',
        'Escalation' => '단계적 확대',
        'Escalation - First Response Time' => '에스컬레이션 - 첫 번째 응답 시간',
        'Escalation - Update Time' => '에스컬레이션 - 업데이트 시간',
        'Escalation - Solution Time' => '에스컬레이션 - 솔루션 시간',
        'Agent/Owner' => '담당상담원',
        'Created by Agent/Owner' => '담당상담원이 만듬',
        'Assigned to Customer User Login' => '고객 사용자 로그인에 할당 됨',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '에 의한 평가',
        'Ticket/Article Accounted Time' => '티켓 / 물품 소요 시간',
        'Ticket Create Time' => '티켓 생성 시간',
        'Ticket Close Time' => '티켓 종료 시간',
        'Accounted time by Agent' => '요원에 의해 정해진 시간',
        'Total Time' => '총 시간',
        'Ticket Average' => '티켓 평균',
        'Ticket Min Time' => '티켓 최소 시간',
        'Ticket Max Time' => '티켓 최대 시간',
        'Number of Tickets' => '티켓 수',
        'Article Average' => '기사 평균',
        'Article Min Time' => '기사 최소 시간',
        'Article Max Time' => '기사 최대 시간',
        'Number of Articles' => '기사 수',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '제한 없는',
        'Attributes to be printed' => '인쇄할 속성',
        'Sort sequence' => '정렬 순서',
        'State Historic' => '주 역사',
        'State Type Historic' => '국가 유형 역사',
        'Historic Time Range' => '역사적인 시간 범위',
        'Number' => '번호',
        'Last Changed' => '마지막 변경됨',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '술루션 평균',
        'Solution Min Time' => '솔루션 최소 시간',
        'Solution Max Time' => '솔루션 최대 시간',
        'Solution Average (affected by escalation configuration)' => '솔루션 평균 (에스컬레이션 구성의 영향을 받음)',
        'Solution Min Time (affected by escalation configuration)' => '솔루션 최소 시간 (에스컬레이션 구성의 영향을 받음)',
        'Solution Max Time (affected by escalation configuration)' => '솔루션 최대 시간 (에스컬레이션 구성의 영향을 받음)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '솔루션 근무 시간 평균 (에스컬레이션 구성의 영향을 받음)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '솔루션 최소 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '솔루션 최대 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Average (affected by escalation configuration)' =>
            '첫 번째 응답 평균 (에스컬레이션 구성의 영향을 받음)',
        'First Response Min Time (affected by escalation configuration)' =>
            '첫 번째 응답 최소 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Max Time (affected by escalation configuration)' =>
            '첫 번째 응답 최대 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '첫 번째 응답 근무 시간 평균 (에스컬레이션 구성의 영향을 받음)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '첫 번째 응답 최소 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '첫 번째 응답 최대 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'Number of Tickets (affected by escalation configuration)' => '티켓 수 (에스컬레이션 구성의 영향을 받음)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => '일',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '오래된 테이블',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '오래된 테이블이 데이터베이스에서 발견되었습니다. 비어있는 경우 제거할 수 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '표 존재',
        'Internal Error: Could not open file.' => '내부 오류 : 파일을 열 수 없습니다.',
        'Table Check' => '표 확인',
        'Internal Error: Could not read file.' => '내부 오류 : 파일을 읽을 수 없습니다.',
        'Tables found which are not present in the database.' => '발견된 테이블은 데이터베이스에 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '데이터베이스 크기',
        'Could not determine database size.' => '데이터베이스 크기를 결정할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '데이터베이스 버전',
        'Could not determine database version.' => '데이터베이스 버전을 확인할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '클라이언트 연결 문자 세트',
        'Setting character_set_client needs to be utf8.' => 'character_set_client 설정은 utf8이어야합니다.',
        'Server Database Charset' => '서버 데이터베이스 문자 세트',
        'The setting character_set_database needs to be \'utf8\'.' => '설정 character_set_database는 \'utf8\'이어야합니다.',
        'Table Charset' => '표 문자 집합',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '\'utf8\'이없는 테이블이 charset으로 발견되었습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB 로그 파일 사이즈',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'innodb_log_file_size 설정은 256MB 이상이어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '잘못된 기본값',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '잘못된 기본값이있는 테이블을 찾았습니다. 자동으로 수정하려면 다음을 실행하십시오. bin / otobo.Console.pl Maint :: Database :: Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '최대 쿼리 크기',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '\'max_allowed_packet\'설정은 64MB보다 커야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '쿼리 캐시 크기',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '\'query_cache_size\'설정을 사용해야합니다 (10MB 이상 512MB 이하).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '기본 저장소 엔진',
        'Table Storage Engine' => '테이블 스토리지 엔진',
        'Tables with a different storage engine than the default engine were found.' =>
            '기본 엔진과 다른 저장소 엔진이 있는 테이블이 발견 되었습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x 이상이 필요합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG 설정',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG는 al32utf8 (예 : GERMAN_GERMANY.AL32UTF8)로 설정해야합니다.',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT 설정',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT는 \'YYYY-MM-DD HH24 : MI : SS\'로 설정해야합니다.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT SQL 확인 설정',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '기본 키 시퀀스 및 트리거',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '잘못된 이름을 가진 다음 시퀀스 및 / 또는 트리거가 발견되었습니다. 수동으로 이름을 변경하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'client_encoding 설정은 UNICODE 또는 UTF8이어야합니다.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'server_encoding 설정은 UNICODE 또는 UTF8이어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '날짜 형식',
        'Setting DateStyle needs to be ISO.' => 'DateStyle 설정은 ISO 여야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '기본 키 시퀀스',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '가능한 잘못된 이름을 가진 다음 시퀀스가 발견되었습니다. 수동으로 이름을 변경하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'PostgreSQL 9.2 이상이 필요합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'OTOBO 디스크 파티션',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '디스크 사용량',
        'The partition where OTOBO is located is almost full.' => 'OTOBO가 위치한 파티션이 거의 찼습니다.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'OTOBO가 위치한 파티션에는 디스크 공간 문제가 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '디스크 파티션 사용법',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '분포',
        'Could not determine distribution.' => '배포를 결정할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '커널 버전',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '시스템로드',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '시스템로드는 시스템에있는 CPU의 최대 수 (예 : 8 개의 CPU가있는 시스템에서 8 이하의로드가 좋음) 여야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '펄 모듈',
        'Not all required Perl modules are correctly installed.' => '필요한 Perl 모듈이 모두 올바르게 설치되지는 않았습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '무료 스왑 공간 (%)',
        'No swap enabled.' => '스왑을 사용할 수 없습니다.',
        'Used Swap Space (MB)' => '사용 된 스왑 공간 (MB)',
        'There should be more than 60% free swap space.' => '스왑 공간이 60 % 이상 있어야합니다.',
        'There should be no more than 200 MB swap space used.' => '사용 된 스왑 공간은 200MB 이상이어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => '기사 검색 색인 상태',
        'Indexed Articles' => '색인 생성된 기사',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '커뮤니케이션 채널 당 기사',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => '수신 통신',
        'Outgoing communications' => '나가는 통신',
        'Failed communications' => '실패한 통신',
        'Average processing time of communications (s)' => '통신 평균 처리 시간(s)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '통신 로그 계정 상태 (지난 24시간)',
        'No connections found.' => '연결이 없습니다.',
        'ok' => '승인',
        'permanent connection errors' => '영구 연결 오류',
        'intermittent connection errors' => '간헐적인 연결 오류',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => '구성 설정',
        'Could not determine value.' => '가치를 결정할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => '데몬',
        'Daemon is running.' => '데몬이 실행 중입니다.',
        'Daemon is not running.' => '데몬이 실행되고 있지 않습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => '데이터베이스 레코드',
        'Ticket History Entries' => '티켓 기록 항목',
        'Articles' => '게시물',
        'Attachments (DB, Without HTML)' => '첨부 파일 (DB, HTML 제외)',
        'Customers With At Least One Ticket' => '최소 하나의 티켓을 소지한 고객',
        'Dynamic Field Values' => '동적 필드 값',
        'Invalid Dynamic Fields' => '잘못된 동적 필드',
        'Invalid Dynamic Field Values' => '잘못된 동적 필드 값',
        'GenericInterface Webservices' => 'GenericInterface 웹 서비스',
        'Process Tickets' => '티켓 처리',
        'Months Between First And Last Ticket' => '첫 번째 티켓과 마지막 티켓 간의 개월',
        'Tickets Per Month (avg)' => '월간 티켓 (평균)',
        'Open Tickets' => '진행중 티켓',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '기본 SOAP 사용자 이름 및 암호',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '보안 위험 : SOAP :: User 및 SOAP :: Password의 기본 설정을 사용합니다. 변경하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => '기본 관리자 비밀번호',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '보안 위험 : 에이전트 계정 root @ localhost에는 여전히 기본 암호가 있습니다. 계정을 변경하거나 계정을 무효화하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '이메일 전송 대기열',
        'Emails queued for sending' => '전송 대기중인 이메일',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (도메인 이름)',
        'Please configure your FQDN setting.' => 'FQDN 설정을 구성하십시오.',
        'Domain Name' => '도메인 이름',
        'Your FQDN setting is invalid.' => 'FQDN 설정이 잘못되었습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => '파일 시스템 쓰기 가능',
        'The file system on your OTOBO partition is not writable.' => 'OTOBO 파티션의 파일 시스템에 쓸 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '레거시 구성 백업',
        'No legacy configuration backup files found.' => '레거시 구성 백업 파일이 없습니다.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => '패키지 설치 상태',
        'Some packages have locally modified files.' => '일부 패키지에는 로컬로 수정된 파일이 있습니다.',
        'Some packages are not correctly installed.' => '일부 패키지가 올바르게 설치되지 않았습니다.',
        'Package Verification Status' => '패키지 확인 상태',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '일부 패키지는 OTRS 그룹에 의해 검증되지 않습니다! 이 패키지를 사용하지 않는 것이 좋습니다.',
        'Package Framework Version Status' => '패키지 프레임 워크 버전 상태',
        'Some packages are not allowed for the current framework version.' =>
            '일부 패키지는 현재 프레임 워크 버전에 허용되지 않습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => '패키지 목록',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '세션 구성 설정',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '스풀된 전자 메일',
        'There are emails in var/spool that OTOBO could not process.' => 'OTOBO가 처리 할 수없는 var / spool에 이메일이 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '시스템 ID 설정이 잘못되었습니다. 숫자 만 포함해야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '기본 티켓 유형',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '구성된 기본 티켓 유형이 잘못되었거나 누락되었습니다. Ticket :: Type :: Default 설정을 변경하고 유효한 티켓 유형을 선택하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => '티켓 색인 모듈',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '60,000 개 이상의 티켓이 있으며 StaticDB 백엔드를 사용해야합니다. 자세한 내용은 관리자 설명서 (성능 튜닝)를 참조하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '잠긴 티켓이 있는 사용자가 잘못되었습니다.',
        'There are invalid users with locked tickets.' => '잠긴 티켓이 있는 유효하지 않은 사용자가 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '시스템에 8,000개 이상의 티켓이 없어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '티켓 검색 Index Module',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '색인 생성 프로세스는 필터를 실행하거나 정지 단어 목록을 적용하지 않고 기사 검색 색인에 원본 기사 텍스트의 저장을 강제합니다. 이렇게하면 검색 색인의 크기가 커지고 전체 텍스트 검색 속도가 느려질 수 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'ticket_lock_index 테이블의 고아 레코드',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '표 ticket_lock_index에는 분리 된 레코드가 있습니다. bin / otobo.Console.pl "Maint :: Ticket :: QueueIndexCleanup"을 실행하여 StaticDB 색인을 정리하십시오.',
        'Orphaned Records In ticket_index Table' => 'ticket_index 테이블의 고아 레코드',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '표 ticket_index에는 분리 된 레코드가 있습니다. bin / otobo.Console.pl "Maint :: Ticket :: QueueIndexCleanup"을 실행하여 StaticDB 색인을 정리하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => '시간 설정',
        'Server time zone' => '서버 시간대',
        'OTOBO time zone' => 'OTOBO 시간대',
        'OTOBO time zone is not set.' => 'OTOBO 시간대가 설정되지 않았습니다.',
        'User default time zone' => '사용자 기본 시간대',
        'User default time zone is not set.' => '사용자 기본 시간대가 설정되지 않았습니다.',
        'Calendar time zone is not set.' => '달력 표준 시간대가 설정되지 않았습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - 에이전트 스킨 사용',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - 에이전트 테마 사용법',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - 특수 통계',
        'Agents using custom main menu ordering' => '사용자 정의 주 메뉴 순서를 사용하는 에이전트',
        'Agents using favourites for the admin overview' => '관리자 개요에 즐겨찾기를 사용하는 에이전트',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => '웹 서버',
        'Loaded Apache Modules' => '로드 된 Apache 모듈',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM 모델',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO는 \'prefork\'MPM 모델로 아파치를 실행해야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI 가속기 사용법',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '성능을 높이려면 FastCGI 또는 mod_perl을 사용해야합니다.',
        'mod_deflate Usage' => 'mod_deflate 사용법',
        'Please install mod_deflate to improve GUI speed.' => 'GUI 속도를 높이려면 mod_deflate를 설치하십시오.',
        'mod_filter Usage' => 'mod_filter 사용법',
        'Please install mod_filter if mod_deflate is used.' => 'mod_deflate가 사용되는 경우 mod_filter를 설치하십시오.',
        'mod_headers Usage' => 'mod_headers 사용법',
        'Please install mod_headers to improve GUI speed.' => 'GUI 속도를 높이려면 mod_headers를 설치하십시오.',
        'Apache::Reload Usage' => 'Apache :: Reload 사용법',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache :: Reload 또는 Apache2 :: Reload를 PerlModule 및 PerlInitHandler로 사용하여 모듈 설치 및 업그레이드시 웹 서버가 다시 시작되지 않도록해야합니다.',
        'Apache2::DBI Usage' => 'Apache2 :: DBI 사용법',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '사전 설정된 데이터베이스 연결을 사용하여 더 나은 성능을 얻으려면 Apache2 :: DBI를 사용해야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '환경 변수',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '지원 데이터 수집',
        'Support data could not be collected from the web server.' => '지원 데이터를 웹 서버에서 수집할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '웹 서버 버전',
        'Could not determine webserver version.' => '웹 서버 버전을 확인할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '동시 사용자 세부 정보',
        'Concurrent Users' => '동시 사용자',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '승인',
        'Problem' => '문제',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '%s 설정이 없습니다!',
        'Setting %s is not locked to this user!' => '설정 %s이 이 사용자에게 잠겨 있지 않습니다.',
        'Setting value is not valid!' => '설정 값이 유효하지 않습니다!',
        'Could not add modified setting!' => '수정된 설정을 추가할 수 없습니다!',
        'Could not update modified setting!' => '수정된 설정을 업데이트 할 수 없습니다!',
        'Setting could not be unlocked!' => '설정을 잠금 해제 할 수 없습니다!',
        'Missing key %s!' => '누락 된 키 %s!',
        'Invalid setting: %s' => '잘못된 설정 : %s',
        'Could not combine settings values into a perl hash.' => '설정 값을 perl 해시에 결합 할 수 없습니다.',
        'Can not lock the deployment for UserID \'%s\'!' => 'UserID \'%s\'에 대한 배포를 잠글 수 없습니다!',
        'All Settings' => '모든 설정',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => '부족',
        'Value is not correct! Please, consider updating this field.' => '값이 올바르지 않습니다! 이 필드를 업데이트 하십시오.',
        'Value doesn\'t satisfy regex (%s).' => '값이 정규식 (%s)을 만족하지 않습니다.',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '사용',
        'Disabled' => '불구가 된',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            '시스템이 OTOBOTimeZone에서 사용자 날짜를 계산할 수 없습니다!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            '시스템은 OTOBOTimeZone에서 사용자 DateTime을 계산할 수 없었습니다!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '값이 올바르지 않습니다! 이 모듈을 업데이트 하십시오.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '값이 올바르지 않습니다! 이 설정을 업데이트 하십시오.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '잠금 해제 시간 재설정.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many fail attempts, please retry again later' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '로그인 실패! 사용자 이름 또는 암호가 잘못 입력되었습니다.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '인증에 성공했지만 데이터베이스에 사용자 데이터 레코드가 없습니다. 관리자에게 문의하십시오.',
        'Can`t remove SessionID.' => 'SessionID를 제거 할 수 없습니다.',
        'Logout successful.' => '로그아웃에 성공했습니다.',
        'Feature not active!' => '기능이 활성화되지 않았습니다!',
        'Sent password reset instructions. Please check your email.' => '보낸 암호 재설정 지침. 이메일을 확인하십시오.',
        'Invalid Token!' => '잘못된 토큰!',
        'Sent new password to %s. Please check your email.' => '새 암호를 %s로 보냈습니다. 이메일을 확인하십시오.',
        'Error: invalid session.' => '오류 : 세션이 잘못되었습니다.',
        'No Permission to use this frontend module!' => '이 프론트 엔드 모듈을 사용할 권한이 없습니다!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '인증은 성공했지만 고객 레코드는 고객 백엔드에서 발견되지 않습니다. 관리자에게 문의하십시오.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '비밀번호를 재설정하지 못했습니다. 관리자에게 문의하십시오.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '이 전자 메일 주소는 이미 있습니다. 로그인하거나 비밀번호를 재설정하십시오.',
        'This email address is not allowed to register. Please contact support staff.' =>
            '이 이메일 주소는 등록 할 수 없습니다. 지원 담당자에게 문의하십시오.',
        'Added via Customer Panel (%s)' => '고객 패널을 통해 추가 (%s)',
        'Customer user can\'t be added!' => '고객 사용자를 추가 할 수 없습니다!',
        'Can\'t send account info!' => '계정 정보를 보낼 수 없습니다!',
        'New account created. Sent login information to %s. Please check your email.' =>
            '새 계정이 생성되었습니다. 로그인 정보를 %s로 보냈습니다. 이메일을 확인하십시오.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Action "%s"을 찾을 수 없습니다!',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => '유효하지 않은 일시적',
        'Group for default access.' => '기본 액세스 그룹.',
        'Group of all administrators.' => '모든 관리자 그룹.',
        'Group for statistics access.' => '통계 액세스 그룹.',
        'new' => '새로운',
        'All new state types (default: viewable).' => '모든 새 상태 유형 (기본값 : 표시 가능).',
        'open' => '열다',
        'All open state types (default: viewable).' => '모든 열린 상태 유형 (기본값 : 표시 가능).',
        'closed' => '닫은',
        'All closed state types (default: not viewable).' => '모든 닫힌 상태 유형 (기본값 : 볼 수 없음).',
        'pending reminder' => '대기중인 알림',
        'All \'pending reminder\' state types (default: viewable).' => '\'보류중인 모든 알림\'상태 유형 (기본값 : 표시 가능).',
        'pending auto' => '보류중인 자동',
        'All \'pending auto *\' state types (default: viewable).' => '\'보류 중 자동 *\'상태 유형 (기본값 : 표시 가능).',
        'removed' => '제거된',
        'All \'removed\' state types (default: not viewable).' => '\'제거 된\'모든 상태 유형 (기본값 : 볼 수 없음).',
        'merged' => '합병된',
        'State type for merged tickets (default: not viewable).' => '병합 된 티켓의 상태 유형 (기본값 : 볼 수 없음).',
        'New ticket created by customer.' => '고객이 만든 새 티켓입니다.',
        'closed successful' => '폐쇄 성공',
        'Ticket is closed successful.' => '티켓이 성공적으로 닫힙니다.',
        'closed unsuccessful' => '닫힌 실패',
        'Ticket is closed unsuccessful.' => '티켓이 성공적으로 닫히지 않았습니다.',
        'Open tickets.' => '진행중 티켓',
        'Customer removed ticket.' => '고객이 티켓을 내렸습니다.',
        'Ticket is pending for agent reminder.' => '에이전트 알림을 위해 티켓이 보류 중입니다.',
        'pending auto close+' => '보류 중 자동 닫기 +',
        'Ticket is pending for automatic close.' => '자동 종료를 위해 티켓 보류 중입니다.',
        'pending auto close-' => '보류 중인 자동 닫기 - ',
        'State for merged tickets.' => '병합된 티켓의 상태.',
        'system standard salutation (en)' => '시스템 표준 인사말 (en)',
        'Standard Salutation.' => '표준 인사말.',
        'system standard signature (en)' => '시스템 표준 서명 (en)',
        'Standard Signature.' => '표준 서명.',
        'Standard Address.' => '표준 주소.',
        'possible' => '가능한',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '닫힌 티켓에 대한 후속 조치가 가능합니다. 티켓이 재개됩니다.',
        'reject' => '받지 않다',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '닫힌 티켓에 대한 후속 조치는 불가능합니다. 새로운 티켓이 생성되지 않습니다.',
        'new ticket' => '새로운 티켓',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '닫힌 티켓에 대한 후속 조치는 불가능합니다. 새로운 티켓이 생성됩니다.',
        'Postmaster queue.' => '포스트 마스터 대기열.',
        'All default incoming tickets.' => '모든 기본 수신 티켓.',
        'All junk tickets.' => '모든 정크 티켓.',
        'All misc tickets.' => '모든 기타 티켓.',
        'auto reply' => '자동 회신',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '새 티켓이 생성된 후 발송될 자동응답 입니다.',
        'auto reject' => '자동 거부',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '후속 조치가 거부 된 후 발송 될 자동 거부 (대기열 후속 옵션이 "거부"인 경우)',
        'auto follow up' => '자동 후속 조치',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '티켓에 대한 후속 조치를받은 후 발송되는 자동 확인 (대기열 후속 옵션이 "가능"인 경우)',
        'auto reply/new ticket' => '자동 회신 / 새 티켓',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '후속 조치가 거부되고 새 티켓이 생성 된 후 발송 될 자동 응답 (대기열 후속 옵션이 "새 티켓"인 경우)',
        'auto remove' => '자동 제거',
        'Auto remove will be sent out after a customer removed the request.' =>
            '고객이 요청을 삭제하면 자동 제거가 발송됩니다.',
        'default reply (after new ticket has been created)' => '기본 답장 (새 티켓을 만든 후)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '가본 거부 (후속 조치 후 닫힌 티켓 거부)',
        'default follow-up (after a ticket follow-up has been added)' => '기본 후속 조치 (티켓 후속 조치가 추가된 후)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '기본 거부 / 새 티켓 생성 (새 티켓 작성으로 마감된 후속 조치)',
        'Unclassified' => '분류되지 않은',
        '1 very low' => '1 매우 낮음',
        '2 low' => '2 낮음',
        '3 normal' => '3 정상',
        '4 high' => '4 높음',
        '5 very high' => '5 매우 높음',
        'unlock' => '잠금해제',
        'lock' => '잠금',
        'tmp_lock' => 'tmp_lock',
        'agent' => '에이전트',
        'system' => '시스템',
        'customer' => '고객',
        'Ticket create notification' => '티켓 생성 알림',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '"내 대기열"또는 "내 서비스"중 하나에 새 티켓이 생성 될 때마다 알림을 받게됩니다.',
        'Ticket follow-up notification (unlocked)' => '티켓 후속 알림 (잠금 해제)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '고객이 "내 대기열"또는 "내 서비스"에있는 잠겨 있지 않은 티켓을 후속 전송하는 경우 알림을 받게됩니다.',
        'Ticket follow-up notification (locked)' => '티켓 후속 알림(잠김)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '고객이 티켓 소유자 또는 책임자인 잠긴 티켓에 대한 후속 조치를 보내는 경우 알림을 받게 됩니다.',
        'Ticket lock timeout notification' => '티켓 잠금 제한 시간 알림',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '소유한 티켓이 자동으로 잠금 해제되면 곧 알림이 전송됩니다.',
        'Ticket owner update notification' => '티켓 소유자 업데이트 알림',
        'Ticket responsible update notification' => '티켓 책임 업데이트 알림',
        'Ticket new note notification' => '티켓 새로운 노트 통지',
        'Ticket queue update notification' => '티켓 대기열 업데이트 알림',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '티켓이 "내 대기열"중 하나로 이동되면 알림을 받게됩니다.',
        'Ticket pending reminder notification (locked)' => '티켓 보류 알림(잠김)',
        'Ticket pending reminder notification (unlocked)' => '티켓 보류 알림 알림 (잠금 해제됨)',
        'Ticket escalation notification' => '티켓 에스컬레이션 알림',
        'Ticket escalation warning notification' => '티켓 에스컬레이션 경고 알림',
        'Ticket service update notification' => '티켓 서비스 업데이트 알림',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '티켓 서비스가 "내 서비스"중 하나로 변경되면 알림을 받게됩니다.',
        'Appointment reminder notification' => '약속 알림',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '약속 중 하나에 대해 미리 알림 시간에 도달할 때마다 알림을 받게 됩니다.',
        'Ticket email delivery failure notification' => '티켓 전자 메일 배달 실패 알림',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'AJAX 통신 중 오류가 발생했습니다. 상태 : %s, 오류 : %s',
        'This window must be called from compose window.' => '이 창은 작성 창에서 호출해야합니다.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '모두 추가',
        'An item with this name is already present.' => '이 이름을 가진 항목이 이미 있습니다.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '이 항목에는 여전히 하위 항목이 있습니다. 하위 항목을 포함하여 이 항목을 제거 하시겠습니까?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '더',
        'Less' => '적게',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Ctrl + C (Cmd + C)를 눌러 클립 보드에 복사하십시오.',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '이 첨부 파일 삭제',
        'Deleting attachment...' => '첨부 파일을 삭제하는 중...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '첨부 파일을 삭제하는 중 오류가 발생했습니다. 자세한 내용은 로그를 확인하십시오.',
        'Attachment was deleted successfully.' => '첨부 파일을 삭제했습니다.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '이 동적 필드를 정말로 삭제 하시겠습니까? 관련된 모든 데이터가 손실됩니다!',
        'Delete field' => '입력란 삭제',
        'Deleting the field and its data. This may take a while...' => '필드 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '선택 항목 삭제',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => '이 이벤트 트리거 삭제',
        'Duplicate event.' => '중복 이벤트.',
        'This event is already attached to the job, Please use a different one.' =>
            '이 이벤트는 이미 작업에 첨부되어 있습니다. 다른 이벤트를 사용하십시오.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => '통신 중에 오류가 발생했습니다.',
        'Request Details' => '요청 세부 정보',
        'Request Details for Communication ID' => '통신 ID 요청 세부 정보',
        'Show or hide the content.' => '내용을 표시하거나 숨깁니다.',
        'Clear debug log' => '디버그 로그 지우기',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '오류 처리 모듈 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => '이 호출자 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '죄송합니다. 기존 상태만 제거 할 수 없습니다.',
        'Sorry, the only existing field can\'t be removed.' => '죄송합니다. 기존 필드만 제거 할 수 없습니다.',
        'Delete conditions' => '조건 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '키 %s에 대한 매핑',
        'Mapping for Key' => '키 매핑',
        'Delete this Key Mapping' => '이 키 매핑 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => '이 작업 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => '웹 서비스 복제',
        'Delete operation' => '작업 삭제',
        'Delete invoker' => '호출자 삭제',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '경고 : SysConfig에서 적절한 변경을 수행하기 전에 \'admin\'그룹의 이름을 변경하면 관리 패널에서 잠길 것입니다! 이 경우 SQL 문에 따라 admin으로 다시 그룹 이름을 변경하십시오.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '이 메일 계정 삭제',
        'Deleting the mail account and its data. This may take a while...' =>
            '메일 계정 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '이 알림 언어를 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this notification?' => '이 알림을 정말로 삭제 하시겠습니까?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '패키지 업그레이드 프로세스가 실행 중입니다. 여기를 클릭하면 업그레이드 진행 상태에 대한 상태 정보를 볼 수 있습니다.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '패키지 업그레이드가 최근 완료 되었습니다. 결과를 보려면 여기를 클릭하십시오.',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '모든 패키지 업데이트',
        'Dismiss' => '버리다',
        'Update All Packages' => '모든 패키지 업데이트',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '현재 불가능',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '진행중인 패키지 업그레이드로 인해 현재 이 기능을 사용할 수 없습니다.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'OTOBO 데몬이 실행 중이 아니기 때문에이 옵션은 현재 비활성화되어 있습니다.',
        'Are you sure you want to update all installed packages?' => '설치된 패키지를 모두 업데이트 하시겠습니까?',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '이 PostMasterFilter 삭제',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '전자 메일 관리자 필터 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => '캔버스에서 엔티티 제거',
        'No TransitionActions assigned.' => '과도 행동이 할당되지 않았습니다.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '대화 상자가 아직 할당되지 않았습니다. 왼쪽의 목록에서 활동 대화 상자를 선택하고 여기로 드래그 하십시오.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '이 활동은 시작 활동이기 때문에 삭제할 수 없습니다.',
        'Remove the Transition from this Process' => '이 프로세스에서 전환 제거',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '이 버튼이나 링크를 사용하자마자 이 화면을 떠나고 현재 상태가 자동으로 저장됩니다. 계속 하시겠습니까?',
        'Delete Entity' => '엔티티 삭제',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '이 활동은 이미 프로세스에서 사용됩니다. 두 번 추가 할 수 없습니다!',
        'Error during AJAX communication' => 'AJAX 통신 중 오류가 발생했습니다.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '연결되지 않은 전환이 이미 캔버스에 배치되었습니다. 다른 전환을 배치하기 전에 이 전환을 먼저 연결하십시오.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '이 전환은 이미 이 활동에 사용됩니다. 두 번 사용할 수 없습니다!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '이 전환 액션은 이미 이 경로에서 사용됩니다. 두 번 사용할 수 없습니다!',
        'Hide EntityIDs' => '엔티티 ID 숨기기',
        'Edit Field Details' => '필드 세부 정보 편집',
        'Customer interface does not support articles not visible for customers.' =>
            '고객 인터페이스는 고객이 볼 수없는 기사를 지원하지 않습니다.',
        'Sorry, the only existing parameter can\'t be removed.' => '죄송합니다. 기존 매개변수만 제거 할 수 없습니다.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '정말로 이 인증서를 삭제하시겠습니까?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '업데이트 전송 중...',
        'Support Data information was successfully sent.' => '지원 데이터 정보가 성공적으로 전송되었습니다.',
        'Was not possible to send Support Data information.' => '지원 데이터 정보를 보낼 수 없었습니다.',
        'Update Result' => '업데이트 결과',
        'Generating...' => '생성 중...',
        'It was not possible to generate the Support Bundle.' => '지원 번들을 생성할 수 없었습니다.',
        'Generate Result' => '결과 생성',
        'Support Bundle' => '지원 번들',
        'The mail could not be sent' => '메일을 보낼 수 없습니다.',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '이 항목을 유효하지 않게 설정할 수는 없습니다. 영향을 받는 모든 구성 설정을 미리 변경해야 합니다.',
        'Cannot proceed' => '진행할 수 없습니다.',
        'Update manually' => '수동으로 업데이트',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '영향을받은 설정을 방금 만든 변경 사항을 반영하도록 자동으로 업데이트하거나 "수동으로 업데이트"를 눌러 직접 설정할 수 있습니다.',
        'Save and update automatically' => '자동 저장 및 업데이트',
        'Don\'t save, update manually' => '저장하지 않고 수동으로 업데이트 하십시오.',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '현재 보고 있는 항목은 아직 배포되지 않은 구성 설정의 일부이므로 현재 상태로 편집할 수 없습니다. 설정이 배포될 때까지 기다려주십시오. 다음에 해야할 일이 확실치 않으면 시스템 관리자에게 문의하십시오.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => '로딩 중...',
        'Search the System Configuration' => '시스템 구성 검색',
        'Please enter at least one search word to find anything.' => '검색할 단어를 하나 이상 입력하십시오.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '안타깝게도 다른 에이전트가 이미 배포 중이므로 현재 배포할 수 없습니다. 나중에 다시 시도 해주십시오.',
        'Deploy' => '배포',
        'The deployment is already running.' => '배포가 이미 실행 중입니다.',
        'Deployment successful. You\'re being redirected...' => '배포가 완료되었습니다. 리디렉션 중입니다...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '오류가 있었습니다. 자세한 정보는 편집 중인 모든 설정을 저장하고 로그를 확인하십시오.',
        'Reset option is required!' => '재설정 옵션이 필요합니다!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '이 배포를 복원하면 모든 설정이 배포 당시의 값으로 되돌아갑니다. 계속 하시겠습니까?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '값이 있는 키는 이름을 바꿀 수 없습니다. 대신 이 키/값 쌍을 제거하고 나중에 다시 추가하십시오.',
        'Unlock setting.' => '잠금 해제 설정.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            '이 예약된 시스템 유지관리를 정말로 삭제 하시겠습니까?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '이 템플릿 삭제',
        'Deleting the template and its data. This may take a while...' =>
            '템플릿 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '도약',
        'Timeline Month' => '타임라인 달',
        'Timeline Week' => '타임라인 주',
        'Timeline Day' => '타임라인 일',
        'Previous' => '너무 이른',
        'Resources' => '자원',
        'Su' => '일요일',
        'Mo' => '월요일',
        'Tu' => '화요일',
        'We' => '수요일',
        'Th' => '목요일',
        'Fr' => '금요일',
        'Sa' => '토요일',
        'This is a repeating appointment' => '이것은 반복되는 약속입니다.',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '이 발생 또는 모든 발생만 편집 하시겠습니까?',
        'All occurrences' => '모든 발생',
        'Just this occurrence' => '바로 이 사건',
        'Too many active calendars' => '활성 캘린더가 너무 많습니다.',
        'Please either turn some off first or increase the limit in configuration.' =>
            '먼저 설정을 해제하거나 설정 한도를 늘리십시오.',
        'Restore default settings' => '기본 설정 복원',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '이 약속을 삭제 하시겠습니까? 이 작업은 실행 취소할 수 없습니다.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '먼저 고객 사용자를 선택한 다음이 티켓에 지정할 고객 ID를 선택하십시오.',
        'Duplicated entry' => '중복 입력',
        'It is going to be deleted from the field, please try again.' => '현장에서 삭제 될 예정입니다. 다시 시도하십시오.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '검색 값을 하나 이상 입력하거나 *를 입력하십시오.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'OTOBO 데몬에 대한 정보',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '유효한 입력을 위해 빨간색으로 표시된 필드를 확인하십시오.',
        'month' => '달',
        'Remove active filters for this widget.' => '이 위젯에 대한 활성 필터를 제거하십시오.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '잠시만 기다려주십시오...',
        'Searching for linkable objects. This may take a while...' => '링크 가능한 객체 검색. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '이 링크를 정말로 삭제 하시겠습니까?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'AdBlock 또는 AdBlockPlus와 같은 브라우저 플러그인을 사용하고 있습니까? 이로 인해 여러 가지 문제가 발생할 수 있으며이 도메인에 예외를 추가하는 것이 좋습니다.',
        'Do not show this warning again.' => '이 경고를 다시 표시하지 마십시오.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '죄송합니다. 하지만 필수로 표시된 알림에 대해서는 모든 방법을 사용 중지 할 수 없습니다.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '죄송합니다만 이 알림에 대한 모든 방법을 사용중지 할 수는 없습니다.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '변경한 설정 중 적어도 하나는 페이지를 새로고침해야 합니다. 현재 화면을 다시 로드하려면 여기를 클릭하십시오.',
        'An unknown error occurred. Please contact the administrator.' =>
            '알 수없는 오류가 발생했습니다. 관리자에게 문의하십시오.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '데스크톱 모드로 전환',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '검색할 수 없으므로 다음 단어를 검색에서 제거하십시오.',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '이 요소는 하위 요소를 가지며 현재 제거할 수 없습니다.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '정말로 이 통계를 삭제 하시겠습니까?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '이 티켓에 지정할 고객 ID를 선택하십시오.',
        'Do you really want to continue?' => '계속하시겠습니까?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '...  %s 더',
        ' ...show less' => '... 덜 보임',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '새 초안 추가',
        'Delete draft' => '초안 삭제',
        'There are no more drafts available.' => '더이상 사용할 수있는 초안이 없습니다.',
        'It was not possible to delete this draft.' => '이 초안을 삭제할 수 없습니다.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => '기사 필터',
        'Apply' => '적용하다',
        'Event Type Filter' => '이벤트 유형 필터',

        # JS File: Core.Agent
        'Slide the navigation bar' => '탐색 바 슬라이드 하기',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Internet Explorer에서 호환 모드를 해제하십시오!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '모바일 모드로 전환',

        # JS File: Core.App
        'Error: Browser Check failed!' => '오류 : 브라우저 확인에 실패했습니다!',
        'Reload page' => '페이지 새로고침',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'Namespace %s을 초기화 할 수 없습니다. %s을 찾을 수 없으므로',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '에러 발생됨! 자세한 내용은 브라우저 오류 로그를 확인하십시오!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => '하나 이상의 오류가 발생했습니다!',

        # JS File: Core.Installer
        'Mail check successful.' => '메일 검사가 완료되었습니다.',
        'Error in the mail settings. Please correct and try again.' => '메일 설정에 오류가 있습니다. 수정하고 다시 시도하십시오.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '새 창에서 이 노드 열기',
        'Please add values for all keys before saving the setting.' => '설정을 저장하기 전에 모든 키의 값을 추가하십시오.',
        'The key must not be empty.' => '키는 비워 둘 수 없습니다.',
        'A key with this name (\'%s\') already exists.' => '이 이름을 가진 키 (\'%s\')가 이미 있습니다.',
        'Do you really want to revert this setting to its historical value?' =>
            '이 설정을 이전 값으로 되돌리시겠습니까?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '영업일 선택',
        'Invalid date (need a future date)!' => '날짜가 잘못 되었습니다 (미래 날짜 필요)!',
        'Invalid date (need a past date)!' => '날짜가 잘못 되었습니다 (지난 날짜 필요)!',

        # JS File: Core.UI.InputFields
        'Not available' => '사용 불가',
        'and %s more...' => '그리고 %s 더 ...',
        'Show current selection' => '현재 선택 항목 표시',
        'Current selection' => '현재 선택',
        'Clear all' => '모두 지우기',
        'Filters' => '필터',
        'Clear search' => '명확한 검색',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '지금 이 페이지를 떠나면 열려있는 모든 팝업 창이 닫힙니다.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '이 화면의 팝업이 이미 열려 있습니다. 이 파일을 닫고 이 파일을 로드하시겠습니까?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '팝업 창을 열 수 없습니다. 이 응용 프로그램에 대한 팝업 차단기를 비활성화하십시오.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '오름차순 정렬 적용,',
        'Descending sort applied, ' => '내림차순 정렬 적용,',
        'No sort applied, ' => '적용된 정렬 없음,',
        'sorting is disabled' => '정렬이 비활성화되었습니다.',
        'activate to apply an ascending sort' => '오름차순 정렬을 적용하려면 활성화',
        'activate to apply a descending sort' => '내림차순 정렬을 적용하려면 활성화',
        'activate to remove the sort' => '활성화하여 정렬을 제거하십시오.',

        # JS File: Core.UI.Table
        'Remove the filter' => '필터를 제거하십시오.',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => '현재 선택할 수 있는 요소가 없습니다.',

        # JS File: Core.UI
        'Please only select one file for upload.' => '업로드 할 파일을 하나만 선택하십시오.',
        'Sorry, you can only upload one file here.' => '죄송합니다. 여기에 하나의 파일만 업로드 할 수 있습니다.',
        'Sorry, you can only upload %s files.' => '죄송합니다. %s 파일 만 업로드 할 수 있습니다.',
        'Please only select at most %s files for upload.' => '업로드하려면 최대 %s 파일 만 선택하십시오.',
        'The following files are not allowed to be uploaded: %s' => '다음 파일은 업로드 할 수 없습니다 : %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '다음 파일은 파일 당 최대 허용 크기인 %s를 초과하여 업로드되지 않았습니다 : %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '다음 파일은 이미 업로드되었으며 다시 업로드되지 않았습니다 : %s',
        'No space left for the following files: %s' => '다음 파일에 공간이 없습니다 : %s',
        'Available space %s of %s.' => '사용 가능한 공간 %s / %s',
        'Upload information' => '정보 업로드',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '첨부파일을 삭제할 때 알 수없는 오류가 발생했습니다. 다시 시도하십시오. 오류가 계속되면 시스템 관리자에게 문의하십시오.',

        # JS File: Core.Language.UnitTest
        'yes' => '예',
        'no' => '아니오',
        'This is %s' => '이것은 %s입니다.',
        'Complex %s with %s arguments' => '%s 인수가있는 복합 %s',

        # JS File: OTOBOLineChart
        'No Data Available.' => '자료 없음.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => '그룹화 된',
        'Stacked' => '누적된',

        # JS File: OTOBOStackedAreaChart
        'Stream' => '흐름',
        'Expanded' => '퍼지는',

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
        'Show current selection',
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
};

1;
