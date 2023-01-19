# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Test2::API qw/context/;

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');
my $QueueObject        = $Kernel::OM->Get('Kernel::System::Queue');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');

# disable the EscalationStopEvents event handler
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost###4300-EscalationStopEvents',
    Value => undef,
);

# set fixed time
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2014-12-12 00:00:00',
        },
    )->ToEpoch()
);

sub CheckNumEvents {
    my %Param = @_;

    my $JobName = $Param{JobName} || '';

    my $Context = context();
    $Context->diag("within CheckNumEvents");

    my $Comment = $Param{Comment} || "job $JobName";

    subtest $Comment => sub {

        # run the TriggerEscalationStartEvents job if requested
        if ($JobName) {

            my $JobRun = $Param{GenericAgentObject}->JobRun(
                Job    => $JobName,
                Config => {
                    Escalation => 1,
                    Queue      => $Param{QueueName},
                    New        => {
                        Module => 'Kernel::System::GenericAgent::TriggerEscalationStartEvents',
                    },
                },
                UserID => 1,
            );

            $Self->True(
                $JobRun,
                "JobRun() $JobName Run the GenericAgent job",
            );
        }

        my @Lines = $Param{TicketObject}->HistoryGet(
            TicketID => $Param{TicketID},
            UserID   => 1,
        );

        while ( my ( $Event, $NumEvents ) = each %{ $Param{NumEvents} } ) {

            my @EventLines = grep { $_->{HistoryType} eq $Event } @Lines;

            $Self->Is(
                scalar @EventLines,
                $NumEvents,
                "check num of $Event events, $Comment",
            );

            # keep current number for reference
            $Param{NumEvents}->{$Event} = scalar @EventLines;
        }
    };

    $Context->release();

    return;
}

# one time with the business hours changed to 24x7, and
# one time with no business hours at all
my %WorkingHours = (
    '0_holiday' => '',
    '1_allday'  => '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23',
);

for my $Hours ( sort keys %WorkingHours ) {

    # An unique indentifier, so that data from different test runs won't be mixed up.
    my $UniqueSignature   = join '_', $HelperObject->GetRandomID(), $Hours;
    my $StartingTimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # use a calendar with the same business hours for every day so that the UT runs correctly
    # on every day of the week and outside usual business hours.
    {
        my %Week;
        my @WindowTime = split ',', $WorkingHours{$Hours};
        for my $Day (qw(Sun Mon Tue Wed Thu Fri Sat)) {
            $Week{$Day} = \@WindowTime;
        }

        # set working hours
        $ConfigObject->Set(
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );
    }

    # disable default Vacation days
    $ConfigObject->Set(
        Key   => 'TimeVacationDays',
        Value => {},
    );

    # create a test queue with immediate escalation
    my ( $QueueID, $QueueName );
    {

        # Setting negative escalation times is a hack.
        # In the test script there should be no need to wait.
        # But they shouldn't be 0, as false value turn off escalation.
        $QueueName = "Queue-$UniqueSignature";
        $QueueID   = $QueueObject->QueueAdd(
            Name                => $QueueName,
            ValidID             => 1,
            GroupID             => 1,
            FirstResponseTime   => -10,
            FirstResponseNotify => 80,
            UpdateTime          => -20,
            UpdateNotify        => 80,
            SolutionTime        => -40,
            SolutionNotify      => 80,
            SystemAddressID     => 1,
            SalutationID        => 1,
            SignatureID         => 1,
            UserID              => 1,
            Comment             => "Queue for OTOBOEscalationEvents.t for test run at $StartingTimeStamp",
        );
        $Self->True( $QueueID, "QueueAdd() $QueueName" );

        # sanity check
        my %Queue = $QueueObject->QueueGet(
            ID     => $QueueID,
            UserID => 1,
        );
        $Self->Is( $Queue{Name},    $QueueName, "QueueGet() $QueueName - Name" );
        $Self->Is( $Queue{QueueID}, $QueueID,   "QueueGet() $QueueName - QueueID" );
    }

    # add a test ticket
    my $TicketID;
    {

        # TicketEscalationIndexBuild() is called implicitly
        # by the TicketEscalationIndex event handler.
        my $TicketTitle = "Ticket-$UniqueSignature";
        $TicketID = $TicketObject->TicketCreate(
            Title      => $TicketTitle,
            QueueID    => $QueueID,
            Lock       => 'unlock',
            PriorityID => 1,
            StateID    => 1,
            OwnerID    => 1,
            UserID     => 1,
        );
        $Self->True( $TicketID, "TicketCreate() $TicketTitle" );

        # wait 1 second to have escalations
        FixedTimeAddSeconds(1);

        # Renew objects because of transaction.
        $Kernel::OM->ObjectsDiscard(
            Objects => [
                'Kernel::System::Ticket',
                'Kernel::System::Ticket::Article',
                'Kernel::System::Ticket::Article::Backend::Phone',
                'Kernel::System::Ticket::Article::Backend::Email',
                'Kernel::System::Ticket::Article::Backend::Internal',
            ],
        );
        $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID );

        # sanity check
        $Self->Is( $Ticket{TicketID}, $TicketID,    "TicketGet() $TicketTitle - ID" );
        $Self->Is( $Ticket{Title},    $TicketTitle, "TicketGet() $TicketTitle - Title" );

        # the ticket should be escalated.
        $Self->True(
            $Ticket{EscalationDestinationTime},
            "TicketGet() $TicketTitle - EscalationDestinationTime is set"
        );
        $Self->True( $Ticket{EscalationTime}, "TicketGet() $TicketTitle - EscalationTime is set" );
        $Self->True(
            $Ticket{EscalationTime} < 0,
            "TicketGet() $TicketTitle - EscalationTime less than 0"
        );

        # first response time escalation
        $Self->True(
            $Ticket{EscalationResponseTime},
            "TicketGet() $TicketTitle - EscalationResponseTime is set"
        );
        $Self->True(
            $Ticket{FirstResponseTimeEscalation},
            "TicketGet() $TicketTitle - FirstResponseTimeEscalation is set"
        );
        $Self->False(
            $Ticket{FirstResponseTimeNotification},
            "TicketGet() $TicketTitle - FirstResponseTimeNotification is not set"
        );
        $Self->True(
            $Ticket{FirstResponseTime},
            "TicketGet() $TicketTitle - FirstResponseTime is set"
        );
        $Self->True(
            $Ticket{FirstResponseTime} < 0,
            "TicketGet() $TicketTitle - FirstResponseTime less than 0"
        );

        # no update escalation, es there was no communication with the customer yet
        $Self->False(
            $Ticket{EscalationUpdateTime},
            "TicketGet() $TicketTitle - EscalationUpdateTime is not set"
        );
        $Self->False(
            $Ticket{UpdateTimeEscalation},
            "TicketGet() $TicketTitle - UpdateTimeEscalation is not set"
        );
        $Self->False(
            $Ticket{UpdateTimeNotification},
            "TicketGet() $TicketTitle - UpdateTimeNotification is not set"
        );

        # solution time escalation
        $Self->True(
            $Ticket{EscalationSolutionTime},
            "TicketGet() $TicketTitle - EscalationSolutionTime is set"
        );
        $Self->True(
            $Ticket{SolutionTimeEscalation},
            "TicketGet() $TicketTitle - SolutionTimeEscalation is set"
        );
        $Self->False(
            $Ticket{SolutionTimeNotification},
            "TicketGet() $TicketTitle - SolutionTimeNotification is not set"
        );
        $Self->True( $Ticket{SolutionTime}, "TicketGet() $TicketTitle - SolutionTime is set" );
        $Self->True(
            $Ticket{SolutionTime} < 0,
            "TicketGet() $TicketTitle - SolutionTime less than 0"
        );
    }

    # Set up the expected number of emitted events.
    my %NumEvents;
    {
        # Right after ticket creation, no events should have been emitted.
        # The not yet supported events, should never be emitted.
        %NumEvents = (
            EscalationNotifyBefore             => 0,    # not yet supported
            EscalationResponseTimeNotifyBefore => 0,
            EscalationUpdateTimeNotifyBefore   => 0,
            EscalationSolutionTimeNotifyBefore => 0,
            EscalationStart                    => 0,    # not yet supported
            EscalationResponseTimeStart        => 0,
            EscalationUpdateTimeStart          => 0,
            EscalationSolutionTimeStart        => 0,
            EscalationStop                     => 0,    # not yet supported
            EscalationResponseTimeStop         => 0,    # not yet supported
            EscalationUpdateTimeStop           => 0,    # not yet supported
            EscalationSolutionTimeStop         => 0,    # not yet supported
        );
        CheckNumEvents(
            GenericAgentObject => $GenericAgentObject,
            TicketObject       => $TicketObject,
            TicketID           => $TicketID,
            NumEvents          => \%NumEvents,
            QueueName          => $QueueName,
            Comment            => 'after ticket create',
        );
    }

    # run GenericAgent job for triggering
    # EscalationResponseTimeStart and EscalationSolutionTimeStart
    {
        if ( $WorkingHours{$Hours} ) {

            # check whether events were triggered: first response
            # escalation, solution time escalation
            $NumEvents{EscalationSolutionTimeStart}++;
            $NumEvents{EscalationResponseTimeStart}++;
        }
        CheckNumEvents(
            GenericAgentObject => $GenericAgentObject,
            TicketObject       => $TicketObject,
            TicketID           => $TicketID,
            NumEvents          => \%NumEvents,
            JobName            => "Job1-$UniqueSignature",
            QueueName          => $QueueName,
        );
    }

    # run GenericAgent job again, with suppressed event generation
    {
        $ConfigObject->Set(
            Key   => 'OTOBOEscalationEvents::DecayTime',
            Value => 100,
        );

        # check whether events were triggered
        CheckNumEvents(
            GenericAgentObject => $GenericAgentObject,
            TicketObject       => $TicketObject,
            TicketID           => $TicketID,
            NumEvents          => \%NumEvents,
            JobName            => "Job2-$UniqueSignature",
            QueueName          => $QueueName,
        );
    }

    # run GenericAgent job again, without suppressed event generation
    {
        $ConfigObject->Set(
            Key   => 'OTOBOEscalationEvents::DecayTime',
            Value => 0,
        );

        if ( $WorkingHours{$Hours} ) {

            # check whether events were triggered: first response escalation, solution time escalation
            $NumEvents{EscalationSolutionTimeStart}++;
            $NumEvents{EscalationResponseTimeStart}++;
        }
        CheckNumEvents(
            GenericAgentObject => $GenericAgentObject,
            TicketObject       => $TicketObject,
            TicketID           => $TicketID,
            NumEvents          => \%NumEvents,
            JobName            => "Job3-$UniqueSignature",
            QueueName          => $QueueName,
        );
    }

    # generate an response and see the first response escalation go away
    {
        $ConfigObject->Set(
            Key   => 'OTOBOEscalationEvents::DecayTime',
            Value => 0,
        );

        # first response
        my $ArticleID = $ArticleObject->BackendForChannel( ChannelName => 'Phone' )->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'agent',
            From                 => 'Agent Some Agent Some Agent <email@example.com>',
            To                   => 'Customer A <customer-a@example.com>',
            Cc                   => 'Customer B <customer-b@example.com>',
            ReplyTo              => 'Customer B <customer-b@example.com>',
            Subject              => 'first response',
            Body                 => 'irgendwie und sowieso',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'first response',
            UserID               => 1,
            NoAgentNotify        => 1,                                                   # if you don't want to send agent notifications
        );

        if ( $WorkingHours{$Hours} ) {

            # check whether events were triggered
            # the first response escalation goes away, update time escalation is triggered
            $NumEvents{EscalationSolutionTimeStart}++;
            $NumEvents{EscalationUpdateTimeStart}++;
        }

        # Renew objects because of transaction.
        $Kernel::OM->ObjectsDiscard(
            Objects => [
                'Kernel::System::Ticket',
                'Kernel::System::Ticket::Article',
                'Kernel::System::Ticket::Article::Backend::Phone',
                'Kernel::System::Ticket::Article::Backend::Email',
                'Kernel::System::Ticket::Article::Backend::Internal',
            ],
        );
        $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        CheckNumEvents(
            GenericAgentObject => $GenericAgentObject,
            TicketObject       => $TicketObject,
            TicketID           => $TicketID,
            NumEvents          => \%NumEvents,
            JobName            => "Job4-$UniqueSignature",
            QueueName          => $QueueName,
        );
    }

    # no new escalations when escalation times are far in the future
    {
        $ConfigObject->Set(
            Key   => 'OTOBOEscalationEvents::DecayTime',
            Value => 0,
        );

        # set the escalation into the future
        my %Queue = $QueueObject->QueueGet(
            ID     => $QueueID,
            UserID => 1,
        );
        my $QueueUpdate = $QueueObject->QueueUpdate(
            %Queue,
            FirstResponseTime => 100,
            UpdateTime        => 200,
            SolutionTime      => 300,
            Comment           => 'escalations in the future',
            UserID            => 1,
        );
        $Self->True( $QueueUpdate, "QueueUpdate() $QueueName" );

        # we have change the queue, but the ticket does not know that
        # invalidate the cache for the next TicketGet
        $TicketObject->_TicketCacheClear( TicketID => $TicketID );

        # trigger an update
        # a note internal does not make the update time escalation go away
        my $ArticleID = $ArticleObject->BackendForChannel( ChannelName => 'Internal' )->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'agent',
            From                 => 'Agent Some Agent Some Agent <email@example.com>',
            To                   => 'Customer A <customer-a@example.com>',
            Cc                   => 'Customert B <customer-b@example.com>',
            ReplyTo              => 'Customer B <customer-b@example.com>',
            Subject              => 'some short description',
            Body                 => 'irgendwie und sowieso',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
            NoAgentNotify        => 1,                                                   # if you don't want to send agent notifications
        );

        # Renew objects because of transaction.
        $Kernel::OM->ObjectsDiscard(
            Objects => [
                'Kernel::System::Ticket',
                'Kernel::System::Ticket::Article',
                'Kernel::System::Ticket::Article::Backend::Phone',
                'Kernel::System::Ticket::Article::Backend::Email',
                'Kernel::System::Ticket::Article::Backend::Internal',
            ],
        );
        $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        CheckNumEvents(
            GenericAgentObject => $GenericAgentObject,
            TicketObject       => $TicketObject,
            TicketID           => $TicketID,
            NumEvents          => \%NumEvents,
            JobName            => "Job5-$UniqueSignature",
            QueueName          => $QueueName,
        );
    }
}

# Add case when escalation time is greater than rest of working day time.
# Escalation destination times must be moved to the next working day (see bug#11243).
my @TimeWorkingHours = ( '9', '10', '11', '12', '13', '14', '15', '16', '17' );
my @Days             = qw(Mon Tue Wed Thu Fri);
my %Week;

for my $Day (@Days) {
    $Week{$Day} = \@TimeWorkingHours;
}

# Set working hours.
$ConfigObject->Set(
    Key   => 'TimeWorkingHours',
    Value => \%Week,
);

# Set fixed time for testing.
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2017-04-26 17:50:00',
        },
    )->ToEpoch()
);

my $RandomNumber = $HelperObject->GetRandomNumber();

# Create test queue.
my $QueueName = "Queue-$RandomNumber";
my $QueueID   = $QueueObject->QueueAdd(
    Name                => $QueueName,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 80,
    UpdateTime          => 40,
    UpdateNotify        => 80,
    SolutionTime        => 50,
    SolutionNotify      => 80,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => "Test Queue",
);
$Self->True( $QueueID, "$QueueName is created" );

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title      => "Ticket-$RandomNumber",
    QueueID    => $QueueID,
    Lock       => 'unlock',
    PriorityID => 1,
    StateID    => 1,
    OwnerID    => 1,
    UserID     => 1,
);
$Self->True( $TicketID, "TicketID $TicketID is created" );

# Renew object because of transaction.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Get created ticket and check created and escalation destination times.
my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID );

$Self->Is(
    $Ticket{Created},
    '2017-04-26 17:50:00',
    "Created time '$Ticket{Created}' is correct"
);
$Self->Is(
    $Ticket{EscalationDestinationDate},
    '2017-04-27 09:20:00',
    "Escalation time '$Ticket{EscalationDestinationDate}' is correct"
);
$Self->Is(
    $Ticket{SolutionTimeDestinationDate},
    '2017-04-27 09:40:00',
    "Solution time '$Ticket{SolutionTimeDestinationDate}' is correct"
);

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
