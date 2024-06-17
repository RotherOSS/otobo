# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::LinkObject::Appointment;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::LinkObject',
    'Kernel::System::Calendar',
    'Kernel::System::Calendar::Appointment',
);

=head1 NAME

Kernel::System::LinkObject::Appointment

=head1 DESCRIPTION

Appointment backend for the appointment link object.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $LinkObjectAppointmentObject = $Kernel::OM->Get('Kernel::System::LinkObject::Appointment');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 LinkListWithData()

fill up the link list with data

    $Success = $LinkObject->LinkListWithData(
        LinkList                     => $HashRef,
        IgnoreLinkedTicketStateTypes => 0|1,        # (optional) default 0
        UserID                       => 1,
    );

=cut

sub LinkListWithData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LinkList UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

    # check link list
    if ( ref $Param{LinkList} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'LinkList must be a hash reference!',
        );
        return;
    }

    for my $LinkType ( sort keys %{ $Param{LinkList} } ) {

        for my $Direction ( sort keys %{ $Param{LinkList}->{$LinkType} } ) {

            APPOINTMENT:
            for my $AppointmentID ( sort keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get appointment data
                my %Appointment = $AppointmentObject->AppointmentGet(
                    AppointmentID => $AppointmentID,
                );

                # remove id from hash if no service data was found
                if ( !%Appointment ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$AppointmentID};
                    next APPOINTMENT;
                }

                # add appointment data
                $Param{LinkList}->{$LinkType}->{$Direction}->{$AppointmentID} = \%Appointment;
            }
        }
    }

    return 1;
}

=head2 ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $LinkObject->ObjectPermission(
        Object  => 'Appointment',
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # TODO: Permission handling

    return 1;
}

=head2 ObjectDescriptionGet()

return a hash of object descriptions

Return
    %Description = (
        Normal => 123,
        Long   => "The Appointment Title",
    );

    %Description = $LinkObject->ObjectDescriptionGet(
        Key     => 123,
        Mode    => 'Temporary',  # (optional)
        UserID  => 1,
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # create description
    my %Description = (
        Normal => 'Appointment',
        Long   => 'Appointment',
    );

    return %Description if $Param{Mode} && $Param{Mode} eq 'Temporary';

    # get ticket
    my %Appointment = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentGet(
        AppointmentID => $Param{Key},
    );

    return if !%Appointment;

    # create description
    %Description = (
        Normal => $Appointment{AppointmentID},
        Long   => $Appointment{Title},
    );

    return %Description;
}

=head2 ObjectSearch()

Return a hash list of the search results.

Returns:

    $SearchList = {
        NOTLINKED => {
            Source => {
                12  => $DataOfItem12,
                212 => $DataOfItem212,
                332 => $DataOfItem332,
            },
        },
    };

    $SearchList = $LinkObject->ObjectSearch(
        SubObject    => 'Bla',     # (optional)
        SearchParams => $HashRef,  # (optional)
        UserID       => 1,
    );

=cut

sub ObjectSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # set default params
    $Param{SearchParams} ||= {};

    # get needed objects
    my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

    my %Search;
    my @CalendarIDs;
    my @Appointments;

    # Search by appointment title and description, if supplied. The conversion of parameter names is
    #   necessary, since link object search parameters should have unique names.
    if ( $Param{SearchParams}->{AppointmentTitle} ) {
        $Search{Title} = $Param{SearchParams}->{AppointmentTitle};
    }
    if ( $Param{SearchParams}->{AppointmentDescription} ) {
        $Search{Description} = $Param{SearchParams}->{AppointmentDescription};
    }

    # Search by specific calendar IDs.
    if (
        $Param{SearchParams}->{AppointmentCalendarID}
        && IsArrayRefWithData( $Param{SearchParams}->{AppointmentCalendarID} )
        )
    {
        @CalendarIDs = @{ $Param{SearchParams}->{AppointmentCalendarID} };
    }

    # Search in all available calendars for the user.
    else {
        my @CalendarList = $CalendarObject->CalendarList(
            UserID     => $Param{UserID},
            Permission => 'rw',
            ValidID    => 1,
        );

        @CalendarIDs = map { $_->{CalendarID} } @CalendarList;
    }

    for my $CalendarID (@CalendarIDs) {
        my @CalendarAppointments = $AppointmentObject->AppointmentList(
            %Search,
            CalendarID => $CalendarID,
            Result     => 'HASH',
        );
        push @Appointments, @CalendarAppointments;
    }

    # add appointment data
    my %SearchList;
    for my $Appointment (@Appointments) {
        $SearchList{NOTLINKED}->{Source}->{ $Appointment->{AppointmentID} } = $Appointment;
    }

    return \%SearchList;
}

=head2 LinkAddPre()

link add pre event module

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        SourceObject => 'Appointment',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        TargetObject => 'Appointment',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=head2 LinkAddPost()

link add pre event module

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        SourceObject => 'Appointment',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        TargetObject => 'Appointment',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

=head2 LinkDeletePre()

link delete pre event module

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        SourceObject => 'Appointment',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        TargetObject => 'Appointment',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

=head2 LinkDeletePost()

link delete post event module

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        SourceObject => 'Appointment',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        TargetObject => 'Appointment',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

1;
