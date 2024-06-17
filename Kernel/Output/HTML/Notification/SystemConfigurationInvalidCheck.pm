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

package Kernel::Output::HTML::Notification::SystemConfigurationInvalidCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::SysConfig',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Group = $Param{Config}->{Group} || 'admin';

    my $HasPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $Group,
        Type      => 'rw',
    );

    return '' if !$HasPermission;

    my @InvalidSettings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationInvalidList(
        CachedOnly => 1,
    );

    if ( scalar @InvalidSettings ) {

        return $LayoutObject->Notify(
            Priority => 'Error',
            Link     => $LayoutObject->{Baselink} . 'Action=AdminSystemConfiguration;Subaction=Invalid',
            Data     => $LayoutObject->{LanguageObject}->Translate(
                "You have %s invalid setting(s) deployed. Click here to show invalid settings.",
                scalar @InvalidSettings,
            ),
        );
    }

    return '';
}

1;
