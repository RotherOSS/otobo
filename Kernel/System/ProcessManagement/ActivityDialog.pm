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

package Kernel::System::ProcessManagement::ActivityDialog;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ProcessManagement::ActivityDialog - activity dialog lib

=head1 DESCRIPTION

All Process Management Activity Dialog functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ActivityDialogGet()

    Get activity dialog info

    my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
        ActivityDialogEntityID => 'AD1',
        Interface              => ['AgentInterface'],   # ['AgentInterface'] or ['CustomerInterface'] or ['AgentInterface', 'CustomerInterface'] or 'all'
        Silent                 => 1,    # 1 or 0, default 0, if set to 1, will not log errors about not matching interfaces
    );

    Returns:

    $ActivityDialog = {
        Name             => 'UnitTestActivity',
        Interface        => 'CustomerInterface',   # 'AgentInterface', 'CustomerInterface', ['AgentInterface'] or ['CustomerInterface'] or ['AgentInterface', 'CustomerInterface']
        DescriptionShort => 'AD1 Process Short',
        DescriptionLong  => 'AD1 Process Long description',
        CreateTime       => '07-02-2012 13:37:00',
        CreateBy         => '2',
        ChangeTime       => '08-02-2012 13:37:00',
        ChangeBy         => '3',
        Fields => {
            DynamicField_Make => {
                Display          => 2,
                DescriptionLong  => 'Make Long',
                DescriptionShort => 'Make Short',
            },
            DynamicField_VWModel => {
                Display          => 2,
                DescriptionLong  => 'VWModel Long',
                DescriptionShort => 'VWModel Short',
            },
            DynamicField_PeugeotModel => {
                Display          => 0,
                DescriptionLong  => 'PeugeotModel Long',
                DescriptionShort => 'PeugeotModel Short',
            },
            StateID => {
               Display          => 1,
               DescriptionLong  => 'StateID Long',
               DescriptionShort => 'StateID Short',
            },
        },
        FieldOrder => [
            'StateID',
            'DynamicField_Make',
            'DynamicField_VWModelModel',
            'DynamicField_PeugeotModel'
        ],
        SubmitAdviceText => 'NOTE: If you submit the form ...',
        SubmitButtonText => 'Make an inquiry',
    };

=cut

sub ActivityDialogGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ActivityDialogEntityID Interface)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( $Param{Interface} ne 'all' && ref $Param{Interface} ne 'ARRAY' ) {
        $Param{Interface} = [ $Param{Interface} ];
    }

    my $ActivityDialog = $Kernel::OM->Get('Kernel::Config')->Get('Process::ActivityDialog');

    if ( !IsHashRefWithData($ActivityDialog) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ActivityDialog config!'
        );
        return;
    }

    if ( !IsHashRefWithData( $ActivityDialog->{ $Param{ActivityDialogEntityID} } ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No Data for ActivityDialog '$Param{ActivityDialogEntityID}' found!"
        );
        return;
    }

    if (
        $Param{Interface} ne 'all'
        && !IsArrayRefWithData(
            $ActivityDialog->{ $Param{ActivityDialogEntityID} }->{Interface}
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No Interface for ActivityDialog '$Param{ActivityDialogEntityID}' found!"
        );
    }

    if ( $Param{Interface} ne 'all' ) {
        my $Success;
        INTERFACE:
        for my $CurrentInterface ( @{ $Param{Interface} } ) {
            if (
                grep { $CurrentInterface eq $_ }
                @{ $ActivityDialog->{ $Param{ActivityDialogEntityID} }->{Interface} }
                )
            {
                $Success = 1;
                last INTERFACE;
            }
        }

        if ( !$Success ) {
            if ( !$Param{Silent} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "Not permitted Interface(s) '"
                        . join( '\', \'', @{ $Param{Interface} } )
                        . "' for ActivityDialog '$Param{ActivityDialogEntityID}'!"
                );
            }
            return;
        }
    }

    return $ActivityDialog->{ $Param{ActivityDialogEntityID} };
}

=head2 ActivityDialogCompletedCheck()

    Checks if an activity dialog is completed

    my $Completed = $ActivityDialogObject->ActivityDialogCompletedCheck(
        ActivityDialogEntityID => 'AD1',
        Data                   => {
            Queue         => 'Raw',
            DynamicField1 => 'Value',
            Subject       => 'Testsubject',
            # ...
        },
    );

    Returns:

    $Completed = 1; # 0

=cut

sub ActivityDialogCompletedCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ActivityDialogEntityID Data)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );
        return;
    }

    my $ActivityDialog = $Self->ActivityDialogGet(
        ActivityDialogEntityID => $Param{ActivityDialogEntityID},
        Interface              => 'all',
    );
    if ( !$ActivityDialog ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't get ActivtyDialog '$Param{ActivityDialogEntityID}'!",
        );
        return;
    }

    if ( !$ActivityDialog->{Fields} || ref $ActivityDialog->{Fields} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't get fields for ActivtyDialog '$Param{ActivityDialogEntityID}'!",
        );
        return;
    }

    # loop over the fields of the config activity dialog to check if the required fields are filled
    FIELDLOOP:
    for my $Field ( sort keys %{ $ActivityDialog->{Fields} } ) {

        # Checks if Field was invisible
        next FIELDLOOP if ( !$ActivityDialog->{Fields}->{$Field}->{Display} );

        # Checks if Field was visible but not required
        next FIELDLOOP if ( $ActivityDialog->{Fields}->{$Field}->{Display} == 1 );

        # checks if $Data->{Field} is defined and not an empty string
        return if ( !IsStringWithData( $Param{Data}->{$Field} ) );
    }

    return 1;
}

1;
