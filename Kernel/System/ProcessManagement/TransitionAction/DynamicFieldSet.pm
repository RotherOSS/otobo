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

package Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet - A module to set a new ticket owner

=head1 DESCRIPTION

All DynamicFieldSet functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $DynamicFieldSetObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Params()

Returns the configuration params for this transition action module

    my @Params = $Object->Params();

Each element is a hash reference that describes the config parameter.
Currently only the keys I<Key>, I<Value> and I<Optional> are used.

=cut

sub Params {
    my ($Self) = @_;

    my @Params = (
        {
            Key   => 'Fieldname (replace with the real fieldname)',
            Value => 'New value (required)',
        },
        {
            Key      => 'UserID',
            Value    => '1 (can overwrite the logged in user)',
            Optional => 1,
        },
        {
            Key      => 'TicketID',
            Value    => '12345 (set dynamic field value of other than the process ticket itself)',
            Optional => 1,
        },
    );

    return @Params;
}

=head2 Run()

    Run Data

    my $DynamicFieldSetResult = $DynamicFieldSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            MasterSlave => 'Master',
            Approved    => '1',
            UserID      => 123,                 # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key

    If a Dynamic Field is named UserID (to avoid conflicts) it must be set in the config as:
    DynamicField_UserID => $Value,

    Returns:

    $DynamicFieldSetResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # define a common message to output in case of any error
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        . " Transition: $Param{TransitionEntityID}"
        . " TransitionAction: $Param{TransitionActionEntityID} - ";

    # check for missing or wrong params
    my $Success = $Self->_CheckParams(
        %Param,
        CommonMessage => $CommonMessage,
    );
    return if !$Success;

    # override UserID if specified as a parameter in the TA config
    $Param{UserID} = $Self->_OverrideUserID(%Param);

    # special case for DyanmicField UserID, convert form DynamicField_UserID to UserID
    if ( defined $Param{Config}->{DynamicField_UserID} ) {
        $Param{Config}->{UserID} = $Param{Config}->{DynamicField_UserID};
        delete $Param{Config}->{DynamicField_UserID};
    }

    # use ticket attributes if needed
    $Self->_ReplaceTicketAttributes(%Param);
    $Self->_ReplaceAdditionalAttributes(%Param);

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $TicketID = delete $Param{Config}->{TicketID};

    if ($TicketID) {
        if ( !$Kernel::OM->Get('Kernel::System::Ticket')->TicketGet( TicketID => $TicketID ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "'$TicketID' is not a valid TicketID.",
            );

            return;
        }
    }
    else {
        $TicketID = $Param{Ticket}->{TicketID};
    }

    for my $CurrentDynamicField ( sort keys %{ $Param{Config} } ) {

        # get required DynamicField config
        my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $CurrentDynamicField,
        );

        # check if we have a valid DynamicField
        if ( !IsHashRefWithData($DynamicFieldConfig) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Can't get DynamicField config for DynamicField: '$CurrentDynamicField'!",
            );
            return;
        }

        # Transform value from string to array for multiselect field (see bug#14900).
        if (
            $DynamicFieldConfig->{FieldType} eq 'Multiselect'
            && IsStringWithData( $Param{Config}->{$CurrentDynamicField} )
            )
        {
            $Param{Config}->{$CurrentDynamicField} = $Self->_ConvertScalar2ArrayRef(
                Data => $Param{Config}->{$CurrentDynamicField},
            );
        }

        # try to set the configured value
        my $Success = $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $TicketID,
            Value              => $Param{Config}->{$CurrentDynamicField},
            UserID             => $Param{UserID},
        );

        # check if everything went right
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Can't set value '"
                    . $Param{Config}->{$CurrentDynamicField}
                    . "' for DynamicField '$CurrentDynamicField',"
                    . "TicketID '" . $TicketID . "'!",
            );
            return;
        }
    }

    return 1;
}

1;
