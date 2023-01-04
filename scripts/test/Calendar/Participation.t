# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        #RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# create needed objects

my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
ok($GroupObject);
isa_ok( $GroupObject, ['Kernel::System::Group'] );

my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
ok($CalendarObject);
isa_ok( $CalendarObject, ['Kernel::System::Calendar'] );

my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
ok($AppointmentObject);
isa_ok( $AppointmentObject, ['Kernel::System::Calendar::Appointment'] );

my $ParticipationObject = $Kernel::OM->Get('Kernel::System::Calendar::Participation');
ok($ParticipationObject);
isa_ok( $ParticipationObject, ['Kernel::System::Calendar::Participation'] );

# A participation is always part of appointment. An appointment needs a calendar.
# A calendar has a group.

# create test group
my $GroupName = join '-', 'test-calendar-group', $RandomID;
my $GroupID   = $GroupObject->GroupAdd(
    Name    => $GroupName,
    ValidID => 1,
    UserID  => 1,
);
ok( $GroupID, "Test group $GroupName created with ID $GroupID" );

# Create test user the hosts appointments and add it to the test group.
my ( $UserLoginHost, $UserIDHost ) = $Helper->TestUserCreate(
    Groups => [$GroupName],
);
ok( $UserLoginHost && $UserIDHost, "Test host $UserLoginHost with ID $UserIDHost created" );

my ( $UserLoginAttendee, $UserIDAttendee ) = $Helper->TestUserCreate(
    Groups => [$GroupName],
);
ok( $UserLoginAttendee && $UserIDAttendee, "Test attendee $UserLoginAttendee with ID $UserIDAttendee created" );

# create test calendar
my $CalendarName = join '-', 'test-calendar', $RandomID;
my %Calendar     = $CalendarObject->CalendarCreate(
    CalendarName => $CalendarName,
    Color        => '#3A87AD',
    GroupID      => $GroupID,
    UserID       => $UserIDHost,
);
ok( $Calendar{CalendarID}, "calendar $CalendarName created with ID $Calendar{CalendarID}" );

my $AppointmentID = $AppointmentObject->AppointmentCreate(
    CalendarID  => $Calendar{CalendarID},
    Title       => "Appointment-A-$RandomID",
    Description => 'Coffee break ☕',
    Location    => 'Germany',
    StartTime   => '2022-10-05 11:20:00',
    EndTime     => '2022-10-05 11:40:00',
    AllDay      => 0,
    UserID      => $UserIDHost,
);
ok( $AppointmentID, 'test appointment created' );

# invite the attendee
my $ParticipationID = $ParticipationObject->ParticipationCreate(
    AppointmentID => $AppointmentID,
    AgentUserID   => $UserIDAttendee,
    UserID        => $UserIDHost,
    Inviter       => $UserLoginHost,
);

# inspect the new invitation
subtest 'get initial participation' => sub {
    my %Participation = $ParticipationObject->ParticipationGet(
        ParticipationID => $ParticipationID,
        UserID          => $UserIDHost,
    );

    is(
        $Participation{ParticipationID},
        $ParticipationID,
        'ParticipationID'
    );

    is(
        $Participation{ParticipationStatus},
        'status TODO',
        'ParticipationStatus'
    );

    is(
        $Participation{AgentUserID},
        $UserIDAttendee,
        'AgentUserID'
    );
    is(
        $Participation{ChangeBy},
        $UserIDHost,
        'ChangeBy'
    );

    is(
        $Participation{CreateBy},
        $UserIDHost,
        'CreateBy'
    );
};

my $UpdatedStatus = 'tea please';
my $UpdateSuccess = $ParticipationObject->ParticipationUpdate(
    ParticipationID     => $ParticipationID,
    ParticipationStatus => $UpdatedStatus,
    UserID              => $UserIDHost,
);
ok( $UpdateSuccess, 'update of participation succeeded' );

# inspect the updated invitation
subtest 'get updated participation' => sub {
    my %Participation = $ParticipationObject->ParticipationGet(
        ParticipationID => $ParticipationID,
        UserID          => $UserIDHost,
    );

    is(
        $Participation{ParticipationID},
        $ParticipationID,
        'ParticipationID'
    );

    is(
        $Participation{ParticipationStatus},
        $UpdatedStatus,
        'ParticipationStatus'
    );

    is(
        $Participation{AgentUserID},
        $UserIDAttendee,
        'AgentUserID'
    );

    is(
        $Participation{ChangeBy},
        $UserIDHost,
        'ChangeBy'
    );

    is(
        $Participation{CreateBy},
        $UserIDHost,
        'CreateBy'
    );
};

# Test the automatic creation of an appointment and participation
{

    # disable the ArticleCreate event handler as we call the event handler explicitly
    $Helper->ConfigSettingChange(
        Valid => 0,
        Key   => 'Ticket::EventModulePost###950-TicketParticipations',
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    ok($ArticleObject);
    isa_ok( $ArticleObject, ['Kernel::System::Ticket::Article'] );

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    ok($TicketObject);
    isa_ok( $TicketObject, ['Kernel::System::Ticket'] );

    # create test ticket with attachments
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Ticket with an invitation',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => $UserIDHost,
        UserID       => $UserIDHost,
    );
    ok( $TicketID, 'TicketCreate()' );

    my $ArticleBackendObject = $ArticleObject->BackendForChannel(
        ChannelName => 'Internal',
    );
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        IsVisibleForCustomer => 0,
        SenderType           => 'agent',
        From                 => 'Some Agent <email@example.com>',
        To                   => 'Some Customer <customer-a@example.com>',
        Subject              => 'some short description',
        Body                 => 'the message text',
        ContentType          => 'text/plain; charset=ISO-8859-15',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'Some free text!',
        UserID               => $UserIDHost,
        Attachment           => [
            {
                Content     => 'empty',
                ContentType => 'text/csv',
                Filename    => 'Test 1.txt',
            },
            {
                Content     => BasicInvite(),
                ContentType => 'text/calendar',
                Filename    => 'Test 2.ics',
            },
        ],
        NoAgentNotify => 1,
    );
    ok( $ArticleID, 'ArticleCreate()' );

    # this is usually a scheduled task created by an event handles
    $ParticipationObject->TicketParticipationProcessArticle(
        TicketID   => $TicketID,
        ArticleID  => $ArticleID,
        CalendarID => $Calendar{CalendarID},
        UserID     => $UserIDHost,
    );
}

sub BasicInvite {
    return <<"END_VCALENDAR";
BEGIN:VCALENDAR
PRODID:Participation.t
VERSION:2.0
CALSCALE:GREGORIAN
METHOD:REQUEST
BEGIN:VTIMEZONE
TZID:Europe/Warsaw
BEGIN:DAYLIGHT
TZOFFSETFROM:+0100
TZOFFSETTO:+0200
TZNAME:CES
RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
DTSTART:20221018T100000Z
DTEND:20221018T123000Z
DTSTAMP:20221017T114135Z
ORGANIZER;CN=organizer1\@mail.com:mailto:organizer1\@mail.com
UID:2AD840A9B960C4A369C1F6040010000000C200E00074C5B7101A82E0080000000090A64A98E413D8010077ACF613F0000080000000000000
ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=attendee1\@mail.com;X-NUM-GUESTS=0:mailto:attendee1\@mail.com
ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=attendee2\@mail.com;X-NUM-GUESTS=0:mailto:attendee2\@mail.com
CREATED:20221017T114050Z
DESCRIPTION:Created by Participation.t
LAST-MODIFIED:20221017T114133Z
LOCATION:Default location value.
SEQUENCE:1
STATUS:CONFIRMED
SUMMARY:Default summary.
TRANSP:OPAQUE
END:VEVENT
END:VCALENDAR
END_VCALENDAR
}

done_testing;
