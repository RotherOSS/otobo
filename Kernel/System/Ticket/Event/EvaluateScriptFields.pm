# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Ticket::Event::EvaluateScriptFields;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::DynamicField::Driver::BaseScript',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Data Event)) {
        if ( !$Param{$Argument} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    return if !$Param{Data}{TicketID};

    my $Triggers = $Kernel::OM->Get('Kernel::System::DynamicField::Driver::BaseScript')->GetStorageTriggers();

    return 1 if !IsHashRefWithData($Triggers);
    return 1 if !$Triggers->{ $Param{Event} };

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{Data}{TicketID},
        DynamicFields => 1,
        UserID        => 1,
    );

    for my $FieldID ( $Triggers->{ $Param{Event} }->@* ) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $FieldID,
        );
        my $Result = $DynamicFieldBackendObject->Evaluate(
            DynamicFieldConfig => $DynamicField,
            Object             => \%Ticket,
        );

        $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $Param{Data}{TicketID},
            Value              => $Result,
            UserID             => 1,
            Store              => 1,
        );
    }

    return 1;
}

1;
