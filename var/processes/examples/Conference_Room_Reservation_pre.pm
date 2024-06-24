# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package var::processes::examples::Conference_Room_Reservation_pre;
## nofilter(TidyAll::Plugin::OTOBO::Perl::PerlCritic)

use strict;
use warnings;

use parent qw(var::processes::examples::Base);

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Dynamic fields definition
    my @DynamicFields = (

        # Make sure that TicketCalendarStartTime is present.
        {
            Name       => 'TicketCalendarStartTime',
            Label      => 'Start-Time',
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
                DefaultValue => '0',
                YearsPeriod  => '0',
            },
        },

        # Make sure that TicketCalendarEndTime is present.
        {
            Name       => 'TicketCalendarEndTime',
            Label      => 'End-Time',
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
                DefaultValue => '0',
                YearsPeriod  => '0',
            },
        },
        {
            Name       => 'PreProcConferenceRoomNo',
            Label      => 'Conference Room Number',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10002,
            Config     => {
                TreeView       => 1,
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-Room1' => 'Room 1',
                    'otobo5s-Room2' => 'Room 2',
                    'otobo5s-Room3' => 'Room 3',
                    'otobo5s-Room4' => 'Room 4',
                    'otobo5s-Room5' => 'Room 5',
                    'otobo5s-Room6' => 'Room 6',
                    'otobo5s-Room7' => 'Room 7',
                    'otobo5s-Room8' => 'Room 8',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcConferenceRoomService',
            Label      => 'Conference Room Service',
            FieldType  => 'Multiselect',
            ObjectType => 'Ticket',
            FieldOrder => 10003,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                TreeView       => 1,
                PossibleValues => {
                    'otobo5s-Flipchart'                              => 'Flipchart',
                    'otobo5s-Projector HDMI'                         => 'Projector HDMI',
                    'otobo5s-Projector VGA'                          => 'Projector VGA',
                    'otobo5s-Room Service - Soft Drinks & Beverages' => 'Room Service - Soft Drinks & Beverages',
                    'otobo5s-Room Service - Soft Drinks only'        => 'Room Service - Soft Drinks only',
                    'otobo5s-Whiteboard'                             => 'Whiteboard',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReservationDecision',
            Label      => 'Reservation decision',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10004,
            Config     => {
                TreeView       => 1,
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-approved' => 'approved',
                    'otobo5s-rejected' => 'rejected',
                },
                TranslatableValues => 0,
            },
        },

        # TODO: Review if this is ok
        {
            Name       => 'PreProcReservationApproved',
            Label      => 'Reservation approved',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10005,
            Config     => {
                TreeView       => 1,
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-no'  => 'no',
                    'otobo5s-yes' => 'yes',
                },
                TranslatableValues => 0,
            },
        },
    );

    my %Response = $Self->DynamicFieldsAdd(
        DynamicFieldList => \@DynamicFields,
    );

    return %Response;
}

1;
