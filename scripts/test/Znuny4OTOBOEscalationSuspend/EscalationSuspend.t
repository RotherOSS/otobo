# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
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

use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;    # Set up the test driver $Self
use Kernel::System::VariableCheck qw(:all);

our $Self;

# explicitly declare the number of tests. This makes is obvious when the
# test script prematurely exits
plan(24);

## nofilter(TidyAll::Plugin::OTOBO::Migrations::OTOBO10::TimeObject)

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $QueueObject          = $Kernel::OM->Get('Kernel::System::Queue');
my $CacheObject          = $Kernel::OM->Get('Kernel::System::Cache');
my $ZnunyHelperObject    = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
my $TimeObject           = $Kernel::OM->Get('Kernel::System::Time');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# Disable transaction mode for escalation index ticket event module
my $TicketEventModulePostConfig = $ConfigObject->Get('Ticket::EventModulePost');
my $EscalationIndexName         = '9990-EscalationIndex';

$Self->True(
    $TicketEventModulePostConfig->{$EscalationIndexName},
    "Ticket::EventModulePost $EscalationIndexName exists",
);

$TicketEventModulePostConfig->{$EscalationIndexName}->{Transaction} = 0;
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost',
    Value => $TicketEventModulePostConfig,
);

$TicketEventModulePostConfig = $ConfigObject->Get('Ticket::EventModulePost');

$Self->IsDeeply(
    $TicketEventModulePostConfig->{$EscalationIndexName},
    {
        'Transaction' => 0,
        'Event'       =>
            'TicketSLAUpdate|TicketQueueUpdate|TicketStateUpdate|TicketCreate|ArticleCreate|TicketDynamicFieldUpdate|TicketTypeUpdate|TicketServiceUpdate|TicketCustomerUpdate|TicketPriorityUpdate|TicketMerge',
        'Module' => 'Kernel::System::Ticket::Event::TicketEscalationIndex'
    },
    "Disable transaction mode for $EscalationIndexName Ticket::EventModulePost",
);

# Subs:
# Kernel::System::Ticket::TicketEscalationIndexBuild
# Kernel::System::Ticket::TicketEscalationSuspendCalculate
# Kernel::System::Ticket::TicketWorkingTimeSuspendCalculate
# Kernel::System::Ticket::TicketGetClosed

my $MySolutionTime = 120;
my $MyQueueName    = "MyTestQueue";
my $MyTicketName   = "MyTestTicket";
my $Pending        = 5;                # minutes
my $Success;
my $TicketEscalationIndexBuild;
my $TicketWorkingTimeSuspendCalculate;
my %TicketGetClosed;
my $TicketGetClosed;
my $SuspendStateActive;

# create a queue for testing

my $QueueID = $ZnunyHelperObject->_QueueCreateIfNotExists(
    Name                => $MyQueueName,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => $MySolutionTime,    # (optional)
    FirstResponseNotify => 80,                 # (optional, notify agent if first response escalation is 60% reached)
    UpdateTime          => 120,                # (optional)
    UpdateNotify        => 80,                 # (optional, notify agent if update escalation is 80% reached)
    SolutionTime        => 120,                # (optional)
    SolutionNotify      => 80,                 # (optional, notify agent if solution escalation is 80% reached)
    UnlockTimeout       => 480,                # (optional)
    FollowUpId          => 3,                  # possible (1), reject (2) or new ticket (3) (optional, default 0)
    FollowUpLock        => 0,                  # yes (1) or no (0) (optional, default 0)
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    Comment             => 'Some comment',
    UserID              => 1,
);

if ($QueueID) {

    my %Queue = $QueueObject->QueueGet(
        ID => $QueueID,
    );

    $Self->Is(
        $Queue{Name},
        $MyQueueName,
        "QueueGet() - Queuename",
    );
    $Self->Is(
        $QueueID,
        $QueueID,
        "QueueGet() - QueueID of  $MyQueueName - ",
    );

    # check the SolutionTime
    $Self->Is(
        $Queue{SolutionTime},
        '120',
        'QueueGet() - SolutionTime - ',
    );
}

# create a ticket for testing
my $TicketID = $TicketObject->TicketCreate(
    Title         => $MyTicketName,
    Queue         => $MyQueueName,             # or QueueID => 123,
    Lock          => 'unlock',
    Priority      => '3 normal',               # or PriorityID => 2,
    State         => 'new',                    # or StateID => 5,
    CustomerID    => 'Znuny',
    CustomerUser  => 'customer@example.com',
    OwnerID       => 1,
    ResponsibleID => 1,                        # not required
    ArchiveFlag   => 'n',                      # (y|n) not required
    UserID        => 1,
);

$Self->True(
    $TicketID,
    "TicketCreate() - create test-ticket",
);

# check TicketID
$Self->Is(
    $TicketID,
    $TicketID,
    'TicketID: ',
);

# get Ticket-Values
my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);

# we need an article to check SenderType (agent|customer)
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    ChannelName          => 'Internal',
    IsVisibleForCustomer => 0,
    SenderType           => 'customer',                           # agent|system|customer
    From                 => 'Some Agent <email@example.com>',     # not required but useful
    Subject              => 'some short description',             # required
    Body                 => 'the message text',                   # required
    ContentType          => 'text/plain; charset=ISO-8859-15',    # or optional Charset & MimeType
    HistoryType          => 'OwnerUpdate',                        # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 0,                                    # if you don't want to send agent notifications
);
$Self->True(
    $ArticleID,
    "create article: $ArticleID",
);

# Kernel::System::Ticket::TicketEscalationIndexBuild

# check line 73
$Success = $TicketObject->TicketStateSet(
    State    => 'merged',
    TicketID => $TicketID,
    UserID   => 1,
);

# get Ticket-Values
%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);

$Self->Is(
    $Ticket{State},
    'merged',
    'TicketGet() - (State = merged) # do no escalations on (merge|close|remove) tickets',
);

$TicketEscalationIndexBuild = $TicketObject->TicketEscalationIndexBuild(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketEscalationIndexBuild,
    'TicketEscalationIndexBuild()  - should be true(1) if state = merged',
);

# check for EscalationSuspendCancelEscalation and EscalationSuspendStates
# Set the ticket to pending reminder

$Success = $TicketObject->TicketStateSet(
    State    => 'pending reminder',
    TicketID => $TicketID,
    UserID   => 1,
);

#set pending time to 30 min
my $PendingDateTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => $Ticket{Created},
    }
);
$PendingDateTime->Add( Minutes => $Pending );

my $SystemPendingTime = $PendingDateTime->ToEpoch();
my $PendingTime       = $PendingDateTime->ToString();

$Success = $TicketObject->TicketPendingTimeSet(
    String   => $PendingTime,
    TicketID => $TicketID,
    UserID   => 1,
);

# clean up ticket cache to make sure we work on real values
$CacheObject->CleanUp(
    Type => 'Ticket',
);

# get the clean ticket and its escalation times
%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);

# get the two necessary sysconfigs for EscalationSuspendCancelEscalation and EscalationSuspendStates
# store them to reset them to the former value
# and set them that cancelescalation can come into action
my $EscalationSuspendCancelEscalationSetting = $ConfigObject->Get('EscalationSuspendCancelEscalation');
if ( !$EscalationSuspendCancelEscalationSetting ) {
    $ConfigObject->Set(
        Key   => 'EscalationSuspendCancelEscalation',
        Value => 1,
    );
}

my $EscalationSuspendStatesSetting = $ConfigObject->Get('EscalationSuspendStates');

if (
    !IsArrayRefWithData($EscalationSuspendStatesSetting)
    || !grep { $_ eq 'pending reminder' } @{$EscalationSuspendStatesSetting}
    )
{
    $ConfigObject->Set(
        Key   => 'EscalationSuspendStates',
        Value => ['pending reminder'],
    );
}

# forward the system time
FixedTimeSet(
    $SystemPendingTime + 60,
);

# store current EscalationTimes to compare them after TicketEscalationIndexBuild
my %EscalationTimesBefore;
for my $Key (qw(EscalationTime EscalationResponseTime EscalationSolutionTime )) {
    $EscalationTimesBefore{$Key} = $Ticket{$Key};
}

$TicketEscalationIndexBuild = $TicketObject->TicketEscalationIndexBuild(
    TicketID => $TicketID,
    UserID   => 1,
);

# Again cache cleanup to get new EscalationTimes
$CacheObject->CleanUp(
    Type => 'Ticket',
);

%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);

# If EscalationTime, EscalationResponseTime and EscalationSolutionTime have been changed
# compared to the previous values
# and set to 0 IndexBuild was successful
for my $Key (qw(EscalationTime EscalationResponseTime EscalationSolutionTime )) {

    $Self->False(
        $Ticket{$Key} eq $EscalationTimesBefore{$Key},
        "$Key: Should get changed by TicketEscalationIndexBuild, is $Ticket{$Key} was $EscalationTimesBefore{$Key}",
    );

    $Self->False(
        $Ticket{$Key},
        "TicketEscalationIndexBuild() - $Key set to 0 successfully",
    );
}

# Jump back to normal time
FixedTimeUnset();

# reset Configs
$ConfigObject->Set(
    Key   => 'EscalationSuspendStates',
    Value => $EscalationSuspendStatesSetting,
);
$ConfigObject->Set(
    Key   => 'EscalationSuspendCancelEscalation',
    Value => $EscalationSuspendCancelEscalationSetting,
);

# State = open
$Success = $TicketObject->TicketStateSet(
    State    => 'open',
    TicketID => $TicketID,
    UserID   => 1,
);

# get Ticket-Values
%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);

$TicketEscalationIndexBuild = $TicketObject->TicketEscalationIndexBuild(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketEscalationIndexBuild,
    'TicketEscalationIndexBuild() - state = open',
);

# get  FirstResponseTime
my %Escalation = $TicketObject->TicketEscalationPreferences(
    Ticket => \%Ticket,
    UserID => 1,
);

$Self->Is(
    $Escalation{FirstResponseTime},    #SolutionTime
    '120',
    'TicketEscalationPreferences() - seconds total till escalation, 120 - ',
);

# Ein Ticket wird erstellt. Die Lösungszeit beträgt 2 Stunden. Die zu erwartende Eskalation wird für 10:00 angezeigt.
# $SuspendStateActive = 1

$Success = $TicketObject->TicketPendingTimeSet(
    String   => $PendingTime,
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $Ticket{Created},
    $Ticket{Created},
    '$Ticket{Created}',
);
$Self->IsNot(
    $PendingTime,
    $Ticket{Created},
    "TicketPendingTimeSet -  should be plus $Pending min. of createdTime",
);

#set pending reminder
$Success = $TicketObject->TicketStateSet(
    State    => 'pending reminder',
    TicketID => $TicketID,
    UserID   => 1,
);

# get Ticket-Values
%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);
$Self->Is(
    $Ticket{State},
    'pending reminder',
    '$Ticket{Created}',
);

my $SystemTime = $TimeObject->SystemTime();

# if systemTime is greater SystemPendingTime Create CustomerArticle..
# Der Kunde Antwortet via E-Mail mit den fehlenden Informationen. Das Ticket wird in den Status "open"

if ( $SystemTime gt $SystemPendingTime ) {

    $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        ChannelName          => 'Internal',
        IsVisibleForCustomer => 1,

        #         ArticleType => 'note-internal',                      # email-external|email-internal|phone|fax|...
        SenderType     => 'customer',                           # agent|system|customer
        From           => 'Some Agent <email@example.com>',     # not required but useful
        Subject        => 'some short description',             # required
        Body           => 'the message text',                   # required
        ContentType    => 'text/plain; charset=ISO-8859-15',    # or optional Charset & MimeType
        HistoryType    => 'OwnerUpdate',                        # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 0,                                    # if you don't want to send agent notifications
    );
    $Self->True(
        $ArticleID,
        "create a new article: $ArticleID",
    );

    # change state to open (follow up via customer)
    $Success = $TicketObject->TicketStateSet(
        State    => 'open',
        TicketID => $TicketID,
        UserID   => 1,
    );

    # get Ticket-Values
    %Ticket = $TicketObject->TicketGet(
        TicketID => $TicketID,
        Extended => 1,
    );
}

$TicketEscalationIndexBuild = $TicketObject->TicketEscalationIndexBuild(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketEscalationIndexBuild,
    'TicketEscalationIndexBuild() - set pending time and customer article',
);

# Kernel::System::Ticket::TicketEscalationSuspendCalculate
sleep(10);

%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);

# get escalation properties
%Escalation = $TicketObject->TicketEscalationPreferences(
    Ticket => \%Ticket,
    UserID => 1,
);

$SuspendStateActive = 1;

#return $DestinationTime = $StartTime + $ResponseTime - $EscalatedTime;
my $TicketEscalationSuspendCalculat = $TicketObject->TicketEscalationSuspendCalculate(
    StartTime    => $Ticket{Created},
    TicketID     => $TicketID,
    ResponseTime => $Escalation{UpdateTime},
    Calendar     => $Escalation{Calendar},     #
    Suspended    => $SuspendStateActive,       # should be 1
);

my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
    SystemTime => $TicketEscalationSuspendCalculat,
);

$Self->IsNot(
    $TimeStamp,
    "",
    'TicketEscalationSuspendCalculat()   - return new DestinationTime ',
);

# Kernel::System::Ticket::TicketWorkingTimeSuspendCalculate
# return $WorkingTimeUnsuspended ... (without pending status)
$TicketWorkingTimeSuspendCalculate = $TicketObject->TicketWorkingTimeSuspendCalculate(
    StartTime => $Ticket{Created},
    TicketID  => $TicketID,
    Calendar  => $Escalation{Calendar},
);

$Self->IsNot(
    $TicketWorkingTimeSuspendCalculate,
    '',
    'TicketWorkingTimeSuspendCalculate()   - WorkingTime:',
);
