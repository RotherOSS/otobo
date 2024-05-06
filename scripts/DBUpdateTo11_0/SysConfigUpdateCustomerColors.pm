# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package scripts::DBUpdateTo11_0::SysConfigUpdateCustomerColors;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_0::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_0::SysConfigUpdateCustomerColors - Update customer color scheme

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %ColorSetting = $SysConfigObject->SettingGet(
        Name => 'CustomerColorDefinitions',
    );

    return   if !%ColorSetting;
    return 1 if !$ColorSetting{IsModified};

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $ColorSetting{DefaultID},
    );

    # Update setting with modified data
    my %Result = $SysConfigObject->SettingUpdate(
        Name           => 'CustomerColorDefinitions',
        IsValid        => 1,
        EffectiveValue => {
            $ColorSetting{EffectiveValue}->%*,
            MainHover  => $ColorSetting{EffectiveValue}{HoverDark}  // '#000099',
            HoverDark  => $ColorSetting{EffectiveValue}{HoverLight} // '#6d83f2',
            HoverLight => $ColorSetting{EffectiveValue}{NotifyOK}   // '#c4cdfa',
        },
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not update setting CustomerColorDefinitions.',
        );

        return;
    }

    my $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $ColorSetting{DefaultID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not unlock setting CustomerColorDefinitions.',
        );

        return;
    }

    return 1;
}

1;
