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

package Kernel::System::Calendar::Participation;

use v5.24;
use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::EventHandler);

# core modules
use List::Util qw(uniq);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Calendar',
    'Kernel::System::Calendar::Appointment',
    'Kernel::System::Calendar::Participation',
    'Kernel::System::Calendar::Plugin',
    'Kernel::System::CalendarEvent',
    'Kernel::System::CustomerUser',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::Calendar::Participation - track participation in meetings

=head1 DESCRIPTION

This OTOBO modules tracks the participation status of agents and customers to meetings.
A meeting is an appointment.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ParticipationObject = $Kernel::OM->Get('Kernel::System::Calendar::Participation');

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'AppointmentCalendar::EventModulePost',
    );

    $Self->{ParentCacheType} = 'Appointment';
    $Self->{CacheType}       = 'Particiption';
    $Self->{CacheTTL}        = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 ParticipationCreate()

creates a new participation for an existing appointment.

    my $ParticipationID = $ParticipationObject->ParticipationCreate(
        AppointmentID         => 17,  # required
        AgentUserID           => 2,   # (optional) the invited agent
        IsTicketInvitation    => 1,   # (optional) whether this is an invitation from the outside, default is 0
        UserID                => 1,   # required, creator of the participation, 1 in the case of external invitations
        Inviter               => 'root@localhost', # string with either email (external invitation) or user full name (internal invitation)
    );

Returns the ParticipationID if successful.

Events:
    ParticipationCreate

=cut

sub ParticipationCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Param{Inviter} //= '';

    #optional: CustomerUserID, ParticipantEmail, AgentUserID

    # Explicitly set the default for IsTicketInvitation
    my $IsTicketInvitation  = $Param{IsTicketInvitation}  // 0;
    my $ParticipationStatus = $Param{ParticipationStatus} // 'NEEDS-ACTION';

    # Insert into the table calendar_participation
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # create db record
    return unless $DBObject->Do(
        SQL => <<'END_SQL',
INSERT INTO calendar_participation (
      appointment_id,
      is_ticket_invitation,
      customer_user_id,
      agent_user_id,
      participant_email,
      participation_status,
      inviter,
      cloned_appointment_id,
      create_time,
      create_by,
      change_time,
      change_by
    )
  VALUES (
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    current_timestamp,
    ?,
    current_timestamp,
    ?
  )
END_SQL
        Bind => [
            \$Param{AppointmentID},
            \$IsTicketInvitation,
            \$Param{CustomerUserID},
            \$Param{AgentUserID},
            \$Param{ParticipantEmail},
            \$ParticipationStatus,
            \$Param{Inviter},
            \$Param{ClonedAppointmentID},
            \$Param{UserID},
            \$Param{UserID},
        ],
    );

    return unless $DBObject->Prepare(
        SQL => <<'END_SQL',
SELECT id
  FROM calendar_participation
  ORDER BY id DESC
END_SQL
        Limit => 1,
    );

    my $ParticipationID;
    while ( my ($ID) = $DBObject->FetchrowArray() ) {
        $ParticipationID = $ID || '';
    }

    # return if there is not appointment created
    if ( !$ParticipationID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Can\'t get ParticipationID from INSERT!',
        );

        return;
    }

    # delete cache for AppointmentGet, as that also fetches the participation
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    for my $Counter ( 0 .. 1 ) {
        $CacheObject->Delete(
            Type => $Self->{ParentCacheType},
            Key  => $Param{AppointmentID} . '::' . $Counter,
        );
    }

    # fire event
    $Self->EventHandler(
        Event => 'ParticipationCreate',
        Data  => {
            AppointmentID   => $Param{AppointmentID},
            ParticipationID => $ParticipationID,
        },
        UserID => $Param{UserID},
    );

    return $ParticipationID;
}

=head2 ParticipationList()

get a list of participation hash references. There are several filters available.
The list can be selected by agent user is, a list of appointment IDs, a Calendar ID
and a list of participation status. The filters are combined with AND logic.

    my @Participations = $ParticipationObject->ParticipationList(
        AgentUserID         => 1,                                                     # (required) Valid Agent UserID or
        AppointmentIDs      => [1, 2],                                                # (required) List of Appointment IDs
        CalendarID          => 1,                                                     # (optional) Filter by CalendarID
        ParticipationStatus => ['ACCEPTED', 'DECLINED', 'TENTATIVE', 'NEEDS-ACTION'], # (optional) Status to filter by
    );

When the parameter C<AppointmentIDs> is passed then no appointment data is added to the result.

Returns an array of hashes with selected participation data:

    @Participations = (
        {
            ParticipationID     => 1,
            AppointmentID       => 1,
            AgentUserID         => 123,
            CustomerUserID      => undef,
            ParticipantEmail    => undef,
            ParticipationStatus => 'NEEDS-ACTION',
            Inviter             => 'root@localhost',
        },
        {
            ParticipationID     => 2,
            AppointmentID       => 2,
            AgentUserID         => undef,
            CustomerUserID      => undef,
            ParticipantEmail    => 'customer.246@example.org',
            ParticipationStatus => 'NEEDS-ACTION',
            Inviter             => 'root@localhost',
        },
        {
            ParticipationID     => 3,
            AppointmentID       => 3,
            AgentUserID         => undef,
            CustomerUserID      => 123,
            ParticipantEmail    => undef,
            ParticipationStatus => 'NEEDS-ACTION',
            Inviter             => 'root@localhost',
        },
        ...
    );

=cut

sub ParticipationList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{AgentUserID} && !$Param{AppointmentIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need at least one of AgentUserID or AppointmentIDs!",
        );

        return;
    }

    # construct the SQL query
    my ( @Conditions, @Binds );
    my $JoinSQL = '';
    if ( $Param{AgentUserID} ) {
        push @Conditions, 'cp.agent_user_id = ?';
        push @Binds,      \$Param{AgentUserID};

        # $CacheType   = join '_', $Self->{CacheType}, 'List', 'Agent', @Binds;
    }

    if ( $Param{AppointmentIDs} && IsArrayRefWithData( $Param{AppointmentIDs} ) ) {
        my $PlaceholderList = join ', ', map {'?'} $Param{AppointmentIDs}->@*;
        push @Conditions, "cp.appointment_id IN ($PlaceholderList)";
        push @Binds,      map { \$_ } $Param{AppointmentIDs}->@*;

        # $CacheType   = join '_', $Self->{CacheType}, 'List' . 'Appointment', @Binds;
    }

    if ( $Param{ParticipationStatus} && IsArrayRefWithData( $Param{ParticipationStatus} ) ) {
        my $PlaceholderList = join ', ', map {'?'} $Param{ParticipationStatus}->@*;
        push @Conditions, "cp.participation_status IN ($PlaceholderList)";
        push @Binds,      map { \$_ } $Param{ParticipationStatus}->@*;
    }

    if ( $Param{CalendarID} ) {
        $JoinSQL = 'JOIN calendar_appointment a ON a.id = cp.appointment_id';
        push @Conditions, 'a.calendar_id = ?';
        push @Binds,      \$Param{CalendarID};
    }

    my $WhereClause = join ' AND ', @Conditions;
    my $CacheKey    = 'complete';

    # TODO Decide whether to delete caching here and the two outcommented lines above
    # check cache
    #{
    #    my $CachedData = $Kernel::OM->Get('Kernel::System::Cache')->Get(
    #        Type => $CacheType,
    #        Key  => $CacheKey,
    #    );

    #    return $CachedData->@* if ref $CachedData eq 'ARRAY';
    #}

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db query for the agent participations
    return unless $DBObject->Prepare(
        SQL => <<"END_SQL",
SELECT
    cp.id,
    cp.appointment_id,
    cp.is_ticket_invitation,
    cp.participation_status,
    cp.agent_user_id,
    cp.customer_user_id,
    cp.participant_email,
    cp.inviter,
    cp.cloned_appointment_id,
    cp.create_time,
    cp.create_by,
    cp.change_time,
    cp.change_by
  FROM calendar_participation cp
  $JoinSQL
  WHERE $WhereClause
  ORDER BY id ASC
END_SQL
        Bind => \@Binds,
    );

    my @Participations;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Participation;
        @Participation{
            qw(
                ParticipationID
                AppointmentID
                IsTicketInvitation
                ParticipationStatus
                AgentUserID
                CustomerUserID
                ParticipantEmail
                Inviter
                ClonedAppointmentID
                CreateTime
                CreateBy
                ChangeTime
                ChangeBy
                )
        } = @Row;
        push @Participations, \%Participation;
    }

    # enrich with the appointment data
    if ( !$Param{AppointmentIDs} ) {
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        APPOINTMENT:
        for my $Participation (@Participations) {

            # this gets the participations again
            my %Appointment = $AppointmentObject->AppointmentGet(
                AppointmentID => $Participation->{AppointmentID},
            );
            $Participation->{Appointment} = \%Appointment;
        }

    }

    # cache
    # $Kernel::OM->Get('Kernel::System::Cache')->Set(
    #     Type  => $CacheType,
    #     Key   => $CacheKey,
    #     Value => \@Result,
    #     TTL   => $Self->{CacheTTL},
    # );

    return @Participations;
}

=head2 TicketInvitationList()

get a list of ticket invitations. This list is filtered by the agent user id. That is only
tickets where the user is the owner or the responsible are considered.
The found appointment must have is_ticket_invitation set but no
participation for the passed AgentUserID.

    my @Participations = $ParticipationObject->TicketInvitationList(
        AgentUserID         => 12,                                                    # (required) Valid Agent UserID
        UserID              => 12,                                                    # (required)
        TicketID            => 1,                                                     # (optional) Filter by TicketID
        CalendarID          => 1,                                                     # (optional) Filter by CalendarID
    );

Returns an array of hashes with selected participation data:

=cut

sub TicketInvitationList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    NEEDED:
    for my $Needed (qw(AgentUserID UserID)) {
        next NEEDED if $Param{$Needed};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed!",
        );

        return;
    }

    # special case for a single ticket
    # It is intented that all users who have access to the ticket can see ticket invitations
    my ( @Conditions, @Binds );
    if ( $Param{TicketID} ) {
        push @Conditions, 't.id = ?';
        push @Binds,      \$Param{TicketID};
    }
    else {
        push @Conditions, '(t.user_id = ? OR t.responsible_user_id = ?)';
        push @Binds, \$Param{AgentUserID}, \$Param{AgentUserID};
    }

    # filter by calendar id
    if ( $Param{CalendarID} ) {
        push @Conditions, 'ca.calendar_id = ?';
        push @Binds,      \$Param{CalendarID};
    }
    my $ConditionsSQL = join ' AND ', @Conditions;

    # fetch appointments linked to relevant tickets
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    $DBObject->Prepare(
        SQL => <<"END_SQL",
SELECT
    t.id,
    cp.id,
    cp.appointment_id,
    cp.is_ticket_invitation,
    cp.participation_status,
    cp.agent_user_id,
    cp.customer_user_id,
    cp.participant_email,
    cp.inviter,
    cp.cloned_appointment_id,
    cp.create_time,
    cp.create_by,
    cp.change_time,
    cp.change_by
FROM ticket t
JOIN calendar_appointment_ticket cat
  ON cat.ticket_id = t.id
JOIN calendar_appointment ca
  ON ca.id = cat.appointment_id
JOIN calendar_participation cp
  ON ( cp.appointment_id = ca.id AND cp.is_ticket_invitation = 1 )
LEFT JOIN calendar_participation cp_agent
  ON ( cp_agent.appointment_id = ca.id AND cp_agent.agent_user_id = ? )
WHERE $ConditionsSQL
    AND cp_agent.id IS NULL
END_SQL
        Bind => [ \$Param{AgentUserID}, @Binds ],
    );

    my @Participations;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Participation;
        @Participation{
            qw(
                TicketID
                ParticipationID
                AppointmentID
                IsTicketInvitation
                ParticipationStatus
                AgentUserID
                CustomerUserID
                ParticipantEmail
                Inviter
                ClonedAppointmentID
                CreateTime
                CreateBy
                ChangeTime
                ChangeBy
                )
        } = @Row;
        push @Participations, \%Participation;
    }

    # enrich with the appointment data
    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    if ( !$Param{AppointmentIDs} ) {
        for my $Participation (@Participations) {

            # this gets the participations again
            my %Appointment = $AppointmentObject->AppointmentGet(
                AppointmentID => $Participation->{AppointmentID},
            );
            $Participation->{Appointment} = \%Appointment;
        }
    }

    return @Participations;
}

=head2 ParticipationGet()

Get participation data.

    my %Participation = $ParticipationObject->ParticipationGet(
        ParticipationID => 1,                                  # (required)
        UserID          => 1,
    );

Returns a hash:

    %Participation = (
        AppointmentID           => 14,
        AgentUserID             => 1 || undef,
        IsTicketInvitation      => 0 || 1,
        ClonedAppointmentID     => 15,
        CustomerUserID          => 'customeruser' || undef,
        ParticipantEmail        => 'test@test.de' || undef,
        ParticipationID         => 2,
        ParticipationStatus     => 'accepted',
        CreateTime              => '2016-01-01 00:00:00',
        Inviter                 => 'root@localhost',
        CreateBy                => 2,
        ChangeTime              => '2016-01-01 00:00:00',
        ChangeBy                => 2,
    );

=cut

sub ParticipationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ParticipationID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!!!!!!",
            );

            return;
        }
    }

    # check cache
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $CachedData  = $CacheObject->Get(
        Type => $Self->{CacheType},
        Key  => $Param{ParticipationID},
    );

    return $CachedData->%* if ref $CachedData eq 'HASH';

    # needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $SQL      = <<'END_SQL';
SELECT
    id,
    appointment_id,
    is_ticket_invitation,
    participation_status,
    agent_user_id,
    customer_user_id,
    participant_email,
    inviter,
    cloned_appointment_id,
    create_time,
    create_by,
    change_time,
    change_by
  FROM calendar_participation
  WHERE id = ?
END_SQL
    my @Binds = ( \$Param{ParticipationID} );

    # db query
    return unless $DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Binds,
        Limit => 1,
    );

    my %Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        @Result{
            qw(
                ParticipationID
                AppointmentID
                IsTicketInvitation
                ParticipationStatus
                AgentUserID
                CustomerUserID
                ParticipantEmail
                Inviter
                ClonedAppointmentID
                CreateTime
                CreateBy
                ChangeTime
                ChangeBy
                )
        } = @Row;
    }

    # cache
    $CacheObject->Set(
        Type  => $Self->{CacheType},
        Key   => $Param{ParticipationID},
        Value => \%Result,
        TTL   => $Self->{CacheTTL},
    );

    return %Result;
}

=head2 ParticipationUpdate()

updates an existing participation. Only the status and the cloned appointment id can be updated.

    my $Success = $ParticipationObject->ParticipationUpdate(
        ParticipationID     => 2,                                       # (required)
        ParticipationStatus => 'TENTATIVE',                             # (required) status
        ClonedAppointmentID => 16,                                      # (optional) in case a new appointment was created
        UserID              => 1,                                       # (required) UserID
    );

returns 1 if successful:

    $Success = 1;

Events:
    ParticipationUpdate

=cut

sub ParticipationUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    NEEDED:
    for my $Needed (qw(ParticipationID ParticipationStatus UserID)) {

        next NEEDED if $Param{$Needed};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed!",
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # the participation status is always updated
    my @Updates = 'participation_status = ?';
    my @Binds   = ( \$Param{ParticipationStatus} );

    if ( $Param{ClonedAppointmentID} ) {
        push @Updates, 'cloned_appointment_id = ?';
        push @Binds,   \$Param{ClonedAppointmentID};
    }

    my $UpdateSQL = join ",\n", @Updates;

    push @Binds, \$Param{UserID}, \$Param{ParticipationID};

    # update db record
    return unless $DBObject->Do(
        SQL => <<"END_SQL",
UPDATE calendar_participation
SET
  $UpdateSQL,
  change_time          = current_timestamp,
  change_by            = ?
  WHERE id = ?
END_SQL
        Bind => \@Binds,
    );

    # delete cache, also for AppointmentGet, as that also fetches the participation
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    $CacheObject->Delete(
        Type => $Self->{CacheType},
        Key  => $Param{ParticipationID},
    );

    # delete cache also for AppointmentGet, as AppointmentGet() also fetches the participation
    {
        my $SelectSuccess = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
            SQL => <<'END_SQL',
SELECT appointment_id
  FROM calendar_participation
  WHERE id = ?
END_SQL
            Bind => [
                \$Param{ParticipationID},
            ],
            Limit => 1,
        );

        if ($SelectSuccess) {
            my $AppointmentID;
            while ( my ($ID) = $DBObject->FetchrowArray() ) {
                $AppointmentID = $ID || '';
            }

            if ($AppointmentID) {
                for my $Counter ( 0 .. 1 ) {
                    $CacheObject->Delete(
                        Type => $Self->{ParentCacheType},
                        Key  => $AppointmentID . '::' . $Counter,
                    );
                }
            }
        }
    }

    my %Participation = $Self->ParticipationGet(
        ParticipationID => $Param{ParticipationID},
        UserID          => $Param{UserID},
    );

    # fire event
    $Self->EventHandler(
        Event => 'ParticipationUpdate',
        Data  => {
            ParticipationID => $Param{ParticipationID},
            AppointmentID   => $Participation{AppointmentID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ParticipationDelete()

Deletes an existing participation. This method is used when the underlying appointment is deleted.

    my $Success = $ParticipationObject->ParticipationDelete(
        ParticipationID => '1',
        UserID          => '1',
    );

Events:
    ParticipationDelete

=cut

sub ParticipationDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ParticipationID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Participation = $Self->ParticipationGet(
        ParticipationID => $Param{ParticipationID},
        UserID          => $Param{UserID},
    );

    # delete participation
    my $SQL = '
        DELETE FROM calendar_participation
        WHERE id = ?
    ';

    # delete db record
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => [
            \$Param{ParticipationID},
        ],
    );

    # fire event
    $Self->EventHandler(
        Event => 'ParticipationDelete',
        Data  => {
            AppointmentID   => $Participation{AppointmentID},
            ParticipationID => $Param{ParticipationID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ParticipationSearch()

Search participation based on a search term and several optional parameters.
Search is performed across participation, linked appointments and involved users.

    my @Participations = $ParticipationObject->ParticipationSearch(
        SearchTerm          => 'abc',                                                 # (required) Search term
        FromDate            => '1970-01-01',                                          # (optional) Date restriction for appointment starting dates
        TillDate            => '2022-12-31',                                          # (optional) Date restriction for appointment ending dates
        AgentUserID         => 1,                                                     # (required) Valid agent user ID
        ParticipationStatus => ['ACCEPTEd', 'DECLINED', 'TENTATIVE', 'NEEDS-ACTION'], # (optional) Status to filter by
    );

=cut

sub ParticipationSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AgentUserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $SearchRegex = qr{$Param{SearchTerm}}i;

    my @Participations = $Self->ParticipationList(
        AgentUserID         => $Param{AgentUserID},
        ParticipationStatus => $Param{ParticipationStatus},
    );

    if ( !$Param{SearchTerm} && !$Param{FromDate} && !$Param{TillDate} ) {
        return @Participations;
    }

    my @Result;
    PARTICIPATION:
    for my $Participation (@Participations) {

        # perform search on appointment data
        my $FromDateCheck   = 1;
        my $TillDateCheck   = 1;
        my $SearchTermCheck = 0;
        if ( $Param{FromDate} ) {
            my $FromDateObj = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Param{FromDate},
                },
            );
            my $AppointmentStartObj = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Participation->{Appointment}{StartTime},
                },
            );
            $FromDateCheck = $AppointmentStartObj->Compare($FromDateObj) == -1 ? 0 : 1;
        }

        if ( $Param{TillDate} ) {
            my $TillDateObj = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Param{TillDate},
                },
            );
            my $AppointmentEndObj = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Participation->{Appointment}{EndTime},
                },
            );
            $TillDateCheck = $TillDateObj->Compare($AppointmentEndObj) == -1 ? 0 : 1;
        }

        if (
            ( $Participation->{Appointment}{Title} && $Participation->{Appointment}{Title} =~ $SearchRegex )
            || ( $Participation->{Appointment}{Description} && $Participation->{Appointment}{Description} =~ $SearchRegex )
            || ( $Participation->{Appointment}{Location}    && $Participation->{Appointment}{Location}    =~ $SearchRegex )
            )
        {
            $SearchTermCheck = 1;
        }

        if ( $FromDateCheck && $TillDateCheck && $SearchTermCheck ) {
            push @Result, $Participation;
            next PARTICIPATION;
        }

        my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Participation->{CustomerUserID},
        );

        if (%CustomerUser) {
            if (
                $CustomerUser{UserFirstname}   =~ $SearchRegex
                || $CustomerUser{UserLastname} =~ $SearchRegex
                || $CustomerUser{UserLogin}    =~ $SearchRegex
                || $CustomerUser{UserEmail}    =~ $SearchRegex
                )
            {
                push @Result, $Participation;
                next PARTICIPATION;
            }
        }

        if ( $Participation->{ParticipantEmail} && $Participation->{ParticipantEmail} =~ $SearchRegex ) {
            push @Result, $Participation;
        }
    }

    return @Result;
}

=begin Internal:

=cut

=end Internal:

=cut

1;
