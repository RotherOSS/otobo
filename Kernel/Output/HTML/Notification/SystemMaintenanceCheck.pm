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

package Kernel::Output::HTML::Notification::SystemMaintenanceCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::SystemMaintenance',
    'Kernel::Output::HTML::Layout',
    'Kernel::Config',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get system maintenance object
    my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');

    my $ActiveMaintenance = $SystemMaintenanceObject->SystemMaintenanceIsActive();

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if system maintenance is active
    if ($ActiveMaintenance) {

        my $SystemMaintenanceData = $SystemMaintenanceObject->SystemMaintenanceGet(
            ID     => $ActiveMaintenance,
            UserID => $Self->{UserID},
        );

        my $NotifyMessage =
            $SystemMaintenanceData->{NotifyMessage}
            || $Kernel::OM->Get('Kernel::Config')->Get('SystemMaintenance::IsActiveDefaultNotification')
            || $LayoutObject->{LanguageObject}->Translate("System maintenance is active!");

        return $LayoutObject->Notify(
            Priority => 'Notice',
            Data     =>
                $LayoutObject->{LanguageObject}->Translate(
                    $NotifyMessage,
                ),
        );
    }

    my %SystemMaintenanceIsComing = $SystemMaintenanceObject->SystemMaintenanceIsComing();

    if (%SystemMaintenanceIsComing) {

        my $MaintenanceStartDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $SystemMaintenanceIsComing{StartDate},
            },
        );
        my $MaintenanceStartDateTime = $LayoutObject->{LanguageObject}->FormatTimeString(
            $MaintenanceStartDateTimeObject->ToString(),
            'DateFormat',
            'NoSeconds',
        );

        my $MaintenanceStopDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $SystemMaintenanceIsComing{StopDate},
            },
        );
        my $MaintenanceStopDateTime = $LayoutObject->{LanguageObject}->FormatTimeString(
            $MaintenanceStopDateTimeObject->ToString(),
            'DateFormat',
            'NoSeconds',
        );

        return $LayoutObject->Notify(
            Priority => 'Notice',
            Data     =>
                $LayoutObject->{LanguageObject}->Translate(
                    "A system maintenance period will start at: %s and is expected to stop at: %s",
                    $MaintenanceStartDateTime, $MaintenanceStopDateTime
                ),
        );

    }

    return '';
}

1;
