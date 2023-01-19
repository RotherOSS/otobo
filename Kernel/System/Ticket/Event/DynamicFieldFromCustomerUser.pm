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

package Kernel::System::Ticket::Event::DynamicFieldFromCustomerUser;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
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
    for my $Needed (qw(Data UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    for my $Needed (qw(TicketID)) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed! in Data",
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get mapping config,
    my %Mapping = %{ $ConfigObject->Get('DynamicFieldFromCustomerUser::Mapping') || {} };

    # no mapping is OK
    return 1 if !%Mapping;

    # get customer user data, so that values can be stored in dynamic fields
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Param{Data}->{TicketID},
    );

    return if !%Ticket;

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get dynamic fields list
    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 1,
        ObjectType => 'Ticket',
        ResultType => 'HASH',
    );

    my $DynamicFieldsReverse = { reverse %{$DynamicFields} };

    my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Ticket{CustomerUserID},
    );

    # also continue if there was no CustomerUser data found - erase values
    # loop over the configured mapping of customer data variables to dynamic fields
    CUSTOMERUSERVARIABLENAME:
    for my $CustomerUserVariableName ( sort keys %Mapping ) {

        # check config for the particular mapping
        if ( !defined $DynamicFieldsReverse->{ $Mapping{$CustomerUserVariableName} } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "DynamicField $Mapping{$CustomerUserVariableName} in DynamicFieldFromCustomerUser::Mapping must be set in system and valid.",
            );
            next CUSTOMERUSERVARIABLENAME;
        }

        my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $Mapping{$CustomerUserVariableName},
        );

        # update dynamic field value for ticket
        $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{Data}->{TicketID},
            Value              => $CustomerUserData{$CustomerUserVariableName} || '',
            UserID             => $Param{UserID},
        );
    }

    return 1;
}

1;
