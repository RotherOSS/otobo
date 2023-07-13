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

package Kernel::System::DynamicField::Driver::Reference::Ticket;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::Reference::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Type',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Reference::Ticket - backend for the Reference dynamic field

=head1 DESCRIPTION

Ticket backend for the Reference dynamic field.

=head1 PUBLIC INTERFACE

=head2 GetFieldTypeSettings()

Get field type settings that are specific to the specific referenced object type.

=cut

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

    my @FieldTypeSettings;

    # Support restriction by ticket type when the Ticket::Type feature is activated.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    if ( $ConfigObject->Get('Ticket::Type') ) {
        my %TypeID2Name = $Kernel::OM->Get('Kernel::System::Type')->TypeList;
        push @FieldTypeSettings,
            {
                ConfigParamName => 'TicketType',
                Label           => Translatable('Type of the ticket'),
                Explanation     => Translatable('Select the of the ticket'),
                InputType       => 'Selection',
                SelectionData   => \%TypeID2Name,
                PossibleNone    => 1,
            };
    }

    return @FieldTypeSettings;
}

=head2 ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $LinkObject->ObjectPermission(
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    return $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $Param{Key},
        UserID   => $Param{UserID},
    );
}

=head2 ObjectDescriptionGet()

return a hash of object descriptions.

    my %Description = $PluginObject->ObjectDescriptionGet(
        Key     => 123,
        UserID  => 1,
    );

Return

    %Description = (
        Normal => "Ticket# 1234455",
        Long   => "Ticket# 1234455: Need a sample ticket title",
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get ticket
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{ObjectID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    return unless %Ticket;

    my $ParamHook = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Hook')      || 'Ticket#';
    $ParamHook .= $Kernel::OM->Get('Kernel::Config')->Get('Ticket::HookDivider') || '';

    # create description
    return (
        Normal => $ParamHook . "$Ticket{TicketNumber}",
        Long   => $ParamHook . "$Ticket{TicketNumber}: $Ticket{Title}",
    );
}

=head2 SearchObjects()

This is used in auto completion when searching for possible object IDs.

=cut

sub SearchObjects {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    return $TicketObject->TicketSearch(
        Limit  => $Param{MaxResults},
        Result => 'ARRAY',
        Title  => "%$Param{Term}%",
        UserID => $Param{UserID},
    );
}

1;
