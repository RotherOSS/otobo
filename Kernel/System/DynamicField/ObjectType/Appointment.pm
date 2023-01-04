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

package Kernel::System::DynamicField::ObjectType::Appointment;

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use Scalar::Util;

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Calendar::Appointment',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::DynamicField::ObjectType::Appointment

=head1 DESCRIPTION

Appointment object handler for DynamicFields

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::ObjectType::Appointment->new();

=cut

sub new {
    my ($Type) = @_;

    my $Self = bless {}, $Type;

    return $Self;
}

=head2 PostValueSet()

perform specific functions after the Value set for this object type.

    my $Success = $DynamicFieldAppointmentHandlerObject->PostValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. AppointmentID
        Value              => $Value,                   # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub PostValueSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

    my %Appointment = $AppointmentObject->AppointmentGet(
        AppointmentID => $Param{ObjectID},
    );

    return unless IsHashRefWithData( \%Appointment );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Update change time.
    return if !$DBObject->Do(
        SQL => "UPDATE calendar_appointment
                SET change_time = current_timestamp, change_by = ?
                WHERE id = ?",
        Bind => [ \$Param{UserID}, \$Param{ObjectID} ],
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    for my $Counter ( 0 .. 1 ) {

        $CacheObject->Delete(
            Type => 'Appointment',
            Key  => $Appointment{AppointmentID} . '::' . $Counter,
        );

    }

    $CacheObject->CleanUp(
        Type => 'AppointmentList' . $Appointment{CalendarID},
    );

    $CacheObject->CleanUp(
        Type => 'AppointmentDays' . $Param{UserID},
    );

    # Trigger event.
    $AppointmentObject->EventHandler(
        Event => 'AppointmentDynamicFieldUpdate_' . $Param{DynamicFieldConfig}->{Name},
        Data  => {
            FieldName     => $Param{DynamicFieldConfig}->{Name},
            Value         => $Param{Value},
            OldValue      => $Param{OldValue},
            AppointmentID => $Param{ObjectID},
            UserID        => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ObjectDataGet()

retrieves the data of the current object.

    my %ObjectData = $DynamicFieldAppointmentHandlerObject->ObjectDataGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        UserID             => 123,
    );

returns:

    %ObjectData = (
        ObjectID => 123,
        Data     => {
            AppointmentNumber => '20101027000001',
            Title        => 'some title',
            AppointmentID     => 123,
            # ...
        }
    );

=cut

sub ObjectDataGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(DynamicFieldConfig UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # Check DynamicFieldConfig (general).
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );

        return;
    }

    # Check DynamicFieldConfig (internally).
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );

            return;
        }
    }

    my $AppointmentID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
        Param => 'AppointmentID',
    );

    return unless $AppointmentID;

    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

    my %Appointment = $AppointmentObject->AppointmentGet(
        AppointmentID => $AppointmentID,
        DynamicFields => 1,
    );

    if ( !%Appointment ) {

        return (
            ObjectID => $AppointmentID,
            Data     => {},
        );
    }

    my %SkipAttributes = ();

    my %Result = (
        ObjectID => $AppointmentID,
    );

    ATTRIBUTE:
    for my $Attribute ( sort keys %Appointment ) {

        next ATTRIBUTE if $SkipAttributes{$Attribute};

        $Result{Data}->{$Attribute} = $Appointment{$Attribute};
    }

    return %Result;

}

1;
