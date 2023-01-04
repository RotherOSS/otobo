# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::Modules::AgentParticipation;

use v5.24;
use strict;
use warnings;

# core modules
use List::Util qw(uniq);

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {%Param}, $Type;

    # frontend specific config
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("TicketIcalIntegration::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParticipationObject = $Kernel::OM->Get('Kernel::System::Calendar::Participation');
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject         = $Kernel::OM->Get('Kernel::System::Web::Request');
    my %Data;

    # collect participation data if participation id given
    my $ParticipationID = $ParamObject->GetParam( Param => 'ParticipationID' );
    if ($ParticipationID) {

        # This also gets the underlying appointment data
        my %CurrentParticipation = $ParticipationObject->ParticipationGet(
            ParticipationID => $ParticipationID,
            UserID          => $Self->{UserID},
        );

        # build participant string
        if ( $CurrentParticipation{AgentUserID} ) {
            my %AgentUser = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $CurrentParticipation{AgentUserID},
                Valid  => 1,
            );
            $Data{Participation}->{Participant} = $AgentUser{UserFullname};
        }
        elsif ( $CurrentParticipation{CustomerUserID} ) {
            my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                User => $CurrentParticipation{CustomerUserID},
            );
            $Data{Participation}->{Participant} = $CustomerUser{UserFullname};
        }
        else {
            $Data{Participation}->{Participant} = $CurrentParticipation{ParticipantEmail};
        }

        $Data{Participation}->{Inviter} = $CurrentParticipation{Inviter};

        # fetch data from corresponding appointment
        $Data{Participation}->{Title}       = $CurrentParticipation{Appointment}->{Title};
        $Data{Participation}->{Description} = $CurrentParticipation{Appointment}->{Description};
    }

    my $Notification = '';
    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'Created' ) {

        # if there is no ticket id!
        if ( $Self->{ParticipationID} && $Self->{Subaction} eq 'Created' ) {

            # notify info
            $Notification .= $LayoutObject->Notify(
                Info => $LayoutObject->{LanguageObject}->Translate(
                    'Participation "%s" created!',
                    $Self->{ParticipationID},
                ),
                Link => $LayoutObject->{Baselink}
                    . 'Action=AgentParticipation;ParticipationID='
                    . $Self->{ParticipationID},
            );
        }

    }
    elsif (
        $Self->{Subaction} eq 'InstantAcceptInvitation'
        ||
        $Self->{Subaction} eq 'AcceptInvitation'
        ||
        $Self->{Subaction} eq 'InstantDeclineInvitation'
        ||
        $Self->{Subaction} eq 'InstantTentativelyAcceptInvitation'
        ||
        $Self->{Subaction} eq 'DeclineInvitation'
        ||
        $Self->{Subaction} eq 'TentativelyAcceptInvitation'
        )
    {

        # challenge token check for write action
        # TODO: sent token also for DeclineInvitation and TentativelyAcceptInvitation
        if ( $Self->{Subaction} =~ m/^Instant/ ) {
            $LayoutObject->ChallengeTokenCheck();
        }

        # determine new status
        my $ParticipationStatus
            = $Self->{Subaction} eq 'InstantAcceptInvitation'
            ? 'ACCEPTED'
            : $Self->{Subaction} eq 'AcceptInvitation'                   ? 'ACCEPTED'
            : $Self->{Subaction} eq 'InstantDeclineInvitation'           ? 'DECLINED'
            : $Self->{Subaction} eq 'DeclineInvitation'                  ? 'DECLINED'
            : $Self->{Subaction} eq 'InstantTentativelyAcceptInvitation' ? 'TENTATIVE'
            : $Self->{Subaction} eq 'TentativelyAcceptInvitation'        ? 'TENTATIVE'
            :                                                              'DECLINED';

        # perform the action for the participation
        my $ParticipationID = $ParamObject->GetParam( Param => 'ParticipationID' );

        my ($Success);
        if (
            $Self->{Subaction} eq 'InstantAcceptInvitation'
            ||
            $Self->{Subaction} eq 'AcceptInvitation'
            )
        {
            # An invitation was accepted. Accepting an invitation means to create a new appointment that is linked
            # to to the participation.
            # TODO: check permissions

            # Base the new appointment on the referenced appointment
            my %Participation = $ParticipationObject->ParticipationGet(
                ParticipationID => $ParticipationID,
                UserID          => $Self->{UserID},
            );
            my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
            my %Appointment       = $AppointmentObject->AppointmentGet(
                AppointmentID => $Participation{AppointmentID},
            );

            # create a new appointment unless the same calendar is chosen
            # TODO: maybe check the unique ID
            my $CalendarID = $ParamObject->GetParam( Param => 'CalendarID' );
            my $ClonedAppointmentID;
            if ( $CalendarID != $Appointment{CalendarID} ) {
                $Appointment{CalendarID} = $CalendarID;
                delete $Appointment{AppointmentID};
                $ClonedAppointmentID = $AppointmentObject->AppointmentCreate(
                    %Appointment,
                    UserID => $Self->{UserID},
                );
            }

            # for ticket invitations we create a participation for the user
            if ( $Participation{IsTicketInvitation} ) {
                $Success = $ParticipationObject->ParticipationCreate(
                    AppointmentID       => $Participation{AppointmentID},
                    Inviter             => $Participation{Inviter},
                    AgentUserID         => $Self->{UserID},
                    ParticipationStatus => $ParticipationStatus,
                    ClonedAppointmentID => $ClonedAppointmentID,
                    UserID              => $Self->{UserID},
                );
            }
            else {
                $Success = $ParticipationObject->ParticipationUpdate(
                    ParticipationID     => $ParticipationID,
                    ParticipationStatus => $ParticipationStatus,
                    ClonedAppointmentID => $ClonedAppointmentID,
                    UserID              => $Self->{UserID},
                );
            }
        }
        else {
            $Success = $ParticipationObject->ParticipationUpdate(
                ParticipationID     => $ParticipationID,
                ParticipationStatus => $ParticipationStatus,
                UserID              => $Self->{UserID},
            );
        }

        # send JSON for AJAX based interfaces
        if ( $Self->{Subaction} =~ m/^Instant/ ) {

            # build simple JSON output
            my $JSON = $LayoutObject->JSONEncode(
                Data => {
                    Success => $Success,
                },
            );

            # send JSON response
            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }
    }
    elsif ( $Self->{Subaction} eq 'CheckConflictingAppointments' ) {

        my %GetParam =
            map { $_ => $ParamObject->GetParam( Param => $_ ) }
            qw(ParticipationID CalendarID);

        my %Participation = $ParticipationObject->ParticipationGet(
            UserID          => $Self->{UserID},
            ParticipationID => $GetParam{ParticipationID},
        );

        my %ParticipationAppointment = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentGet(
            AppointmentID => $Participation{AppointmentID},
        );

        my @ConflictingAppointments = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentList(
            CalendarID => $GetParam{CalendarID},
            StartTime  => $ParticipationAppointment{StartTime},
            EndTime    => $ParticipationAppointment{EndTime},
        );

        my $JSON = $LayoutObject->JSONEncode(
            Data => {
                Success => 1,
            },
        );

        # If there is only one conflicting appointment and this appointment has the same unique id as the present one, do not count as conflict
        if (
            @ConflictingAppointments &&
            !( $#ConflictingAppointments == 0 && $ConflictingAppointments[0]->{UniqueID} eq $ParticipationAppointment{UniqueID} )
            )
        {
            my $ConflictMessage = $LayoutObject->Output(
                Template => '[% Translate(Data.ConflictMessage) %]',
                Data     => {
                    ConflictMessage => 'You have a conflicting appointment.',
                },
            );
            $JSON = $LayoutObject->JSONEncode(
                Data => {
                    Success         => 1,
                    ConflictMessage => $ConflictMessage,
                }
            );
        }

        # send JSON response
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    $Self->_Overview(%Param);

    # build output
    return join '',
        $LayoutObject->Header( Title => 'Participation' ),
        $LayoutObject->NavigationBar(),
        $Notification,
        $LayoutObject->Output(
            Data         => \%Data,
            TemplateFile => 'AgentParticipation',
        ),
        $LayoutObject->Footer();
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    # get direct participations
    my $ParticipationObject = $Kernel::OM->Get('Kernel::System::Calendar::Participation');
    my @Participations      = $ParticipationObject->ParticipationList(
        AgentUserID => $Self->{UserID},
    );
    push @Participations, $ParticipationObject->TicketInvitationList(
        AgentUserID => $Self->{UserID},
        UserID      => $Self->{UserID},
    );

    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my @CalendarList = $CalendarObject->CalendarList(
        UserID  => $Self->{UserID},
        ValidID => 1,
    );

    # render own participations
    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            Title => Translatable('My Participations'),
        },
    );

    for my $Participation (@Participations) {

        my %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $Participation->{Appointment}->{CalendarID},
        );

        # convert time zone and format the appointment times
        for my $DateKey (qw(StartTime EndTime)) {
            $Participation->{Appointment}->{$DateKey} = $LayoutObject->{LanguageObject}->FormatTimeString(
                $Participation->{Appointment}->{$DateKey},
            );
        }

        if ( $Participation->{IsTicketInvitation} ) {
            $Participation->{ObjectName} = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup( TicketID => $Participation->{TicketID} );
            $Participation->{ObjectLink} = 'Action=AgentTicketZoom;TicketID=' . $Participation->{TicketID};
        }
        else {
            $Participation->{ObjectName} = $Calendar{CalendarName};
            $Participation->{ObjectLink} = 'Action=AgentAppointmentCalendarOverview;AppointmentID=' . $Participation->{AppointmentID};
        }

        my %ParticipationSelectionData = (
            'InstantAcceptInvitation'            => 'Accept',
            'InstantTentativelyAcceptInvitation' => 'Accept Tentatively',
            'InstantDeclineInvitation'           => 'Decline',
        );

        my $SelectedID = '';
        if ( $Participation->{ParticipationStatus} eq 'DECLINED' ) {
            $ParticipationSelectionData{InstantDeclineInvitation} = 'Declined';
            $SelectedID = 'InstantDeclineInvitation';
        }
        elsif ( $Participation->{ParticipationStatus} eq 'ACCEPTED' ) {
            $ParticipationSelectionData{InstantAcceptInvitation} = 'Accepted';
            $SelectedID = 'InstantAcceptInvitation';
        }
        elsif ( $Participation->{ParticipationStatus} eq 'TENTATIVE' ) {
            $ParticipationSelectionData{InstantTentativelyAcceptInvitation} = 'Accepted Tentatively';
            $SelectedID = 'InstantTentativelyAcceptInvitation';
        }

        $Participation->{ParticipationStatusSelectionString} = $LayoutObject->BuildSelection(
            Data         => \%ParticipationSelectionData,
            Name         => 'CalendarParticipationAction_' . $Participation->{ParticipationID},
            Multiple     => 0,
            Class        => 'Modernize CalendarParticipationAction',
            PossibleNone => 1,
            SelectedID   => $SelectedID,
        );

        $Participation->{CalendarSelectionString} = $LayoutObject->BuildSelection(
            Data         => { map { $_->{CalendarID} => $_->{CalendarName} } @CalendarList },
            Name         => 'CalendarSelection_' . $Participation->{ParticipationID},
            Multiple     => 0,
            Class        => 'Modernize CalendarSelection Hidden',
            PossibleNone => 0,
            SelectedID   => $Participation->{Appointment}{CalendarID},
        );

        # TODO rewrite template to use nested data for the appointment
        $LayoutObject->Block(
            Name => 'Participation',
            Data => {
                $Participation->{Appointment}->%*,
                $Participation->%*,
                CalendarName => $Calendar{CalendarName},
                Color        => $Calendar{Color},
            },
        );
    }

    if ( !@Participations ) {
        $LayoutObject->Block(
            Name => 'ParticipationNoDataRow',
        );
    }

    $Param{Overview} = 1;

    return %Param;
}

1;
