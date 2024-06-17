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

package Kernel::Modules::AdminCloudServiceSupportDataCollector;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    # ------------------------------------------------------------ #
    # edit action
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'EditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get needed objects
        my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
        my $RegistrationObject = $Kernel::OM->Get('Kernel::System::Registration');

        my $RegistrationType = $SystemDataObject->SystemDataGet(
            Key => 'Registration::Type',
        ) || '';
        my $Description = $SystemDataObject->SystemDataGet(
            Key => 'Registration::Description',
        ) || '';
        my $SupportDataSending = $ParamObject->GetParam( Param => 'SupportDataSending' ) || 'No';

        my %Result = $RegistrationObject->RegistrationUpdateSend(
            Type               => $RegistrationType,
            Description        => $Description,
            SupportDataSending => $SupportDataSending,
        );

        # log change
        if ( $Result{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  =>
                    "System Registration: User $Self->{UserID} changed Support Data Sending to: $SupportDataSending!",
            );

        }

        return $LayoutObject->Redirect(
            OP => 'Action=AdminCloudServiceSupportDataCollector',
        );
    }

    # ------------------------------------------------------------ #
    # edit action
    # ------------------------------------------------------------ #
    else {

        my $RegistrationState = $SystemDataObject->SystemDataGet(
            Key => 'Registration::State',
        ) || '';
        my $SupportDataSending = $SystemDataObject->SystemDataGet(
            Key => 'Registration::SupportDataSending',
        ) || 'No';

        if ( $RegistrationState ne 'registered' ) {

            $LayoutObject->Block(
                Name => 'NotRegistered',
            );
        }
        else {
            # check SupportDataSending if it is enable
            $Param{SupportDataSendingChecked} = '';

            if ( $SupportDataSending ne 'Yes' ) {

                $LayoutObject->Block(
                    Name => 'RegisteredNotSending',
                );
            }
            else {
                $Param{SupportDataSendingChecked} = 'checked="checked"';
            }

            $LayoutObject->Block(
                Name => 'SendingEdit',
                Data => {
                    %Param,
                }
            );

        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminCloudServiceSupportDataCollector',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
