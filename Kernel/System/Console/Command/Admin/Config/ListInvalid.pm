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

package Kernel::System::Console::Command::Admin::Config::ListInvalid;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List invalid system configuration.');
    $Self->AddOption(
        Name        => 'export-to-path',
        Description => "Export list to a YAML file instead.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @InvalidSettings = $SysConfigObject->ConfigurationInvalidList(
        Undeployed => 1,
        NoCache    => 1,
    );

    if ( !scalar @InvalidSettings ) {
        $Self->Print("<green>All settings are valid.</green>\n");
        return $Self->ExitCodeOk();
    }

    my $ExportToPath = $Self->GetOption('export-to-path');

    if ($ExportToPath) {
        $Self->Print("<red>Settings with invalid values have been found.</red>\n");
    }
    else {
        $Self->Print("<red>The following settings have an invalid value:</red>\n");
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my %EffectiveValues;
    SETTINGNAME:
    for my $SettingName (@InvalidSettings) {
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        if ($ExportToPath) {
            $EffectiveValues{$SettingName} = $Setting{EffectiveValue};
            next SETTINGNAME;
        }

        my $EffectiveValue = $MainObject->Dump(
            $Setting{EffectiveValue},
        );

        $EffectiveValue =~ s/\$VAR1 = //;

        $Self->Print("    $SettingName = $EffectiveValue");
    }

    if ($ExportToPath) {

        my $EffectiveValuesYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
            Data => \%EffectiveValues,
        );

        # Write settings to a file.
        my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $ExportToPath,
            Content  => \$EffectiveValuesYAML,
            Mode     => 'utf8',
        );

        # Check if target file exists.
        if ( !$FileLocation ) {
            $Self->PrintError("Could not write file $ExportToPath!\nFail.\n");
            return $Self->ExitCodeError();
        }

        $Self->Print("<green>Done.</green>\n");
    }

    return $Self->ExitCodeError();
}

1;
