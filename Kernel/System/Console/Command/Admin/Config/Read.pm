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

package Kernel::System::Console::Command::Admin::Config::Read;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::SysConfig',
    'Kernel::System::Main',
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Gather the value of a setting.');
    $Self->AddOption(
        Name        => 'setting-name',
        Description => "The name of the setting.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/,
    );
    $Self->AddOption(
        Name        => 'target-path',
        Description => "Specify the output location of the setting value YAML file.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Gathering setting value...</yellow>\n");

    my $SettingName = $Self->GetOption('setting-name');

    my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
        Name => $SettingName,
    );

    # Return if there was no setting.
    if ( !%Setting ) {
        $Self->Print("<red>Fail.</red>\n");
        return $Self->ExitCodeError();
    }

    # Return if setting is invalid or not visible
    if ( !$Setting{IsValid} || $Setting{IsInvisible} ) {
        $Self->PrintError("Setting is invalid!\nFail.");
        return $Self->ExitCodeError();
    }

    # Return if not effectiveValue.
    if ( !defined $Setting{EffectiveValue} ) {
        $Self->PrintError("No effective value found for setting: $SettingName!.\nFail.");
        return $Self->ExitCodeError();
    }

    # Dump config as string.
    my $TargetPath         = $Self->GetOption('target-path');
    my $EffectiveValueYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Setting{EffectiveValue},
    );

    if ($TargetPath) {

        # Write configuration in a file.
        my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $TargetPath,
            Content  => \$EffectiveValueYAML,
            Mode     => 'utf8',
        );

        # Check if target file exists.
        if ( !$FileLocation ) {
            $Self->PrintError("Could not write file $TargetPath!\nFail.\n");
            return $Self->ExitCodeError();
        }

        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    # Send value to standard output
    $Self->Print("\nSetting: <yellow>$SettingName</yellow>");
    if ( !ref $Setting{EffectiveValue} ) {
        $Self->Print("\n$Setting{EffectiveValue}\n\n");
    }
    else {
        $Self->Print(" (YAML)\n$EffectiveValueYAML\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
