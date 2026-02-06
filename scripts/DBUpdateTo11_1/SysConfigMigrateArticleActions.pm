# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package scripts::DBUpdateTo11_1::SysConfigMigrateArticleActions;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules
use File::Basename;
use List::Util qw(any none);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(DataIsDifferent IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Console::Command::Maint::Config::Rebuild',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigMigrateArticleActions - Migrate existing Article::Actions configs to new structure

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $LogObject       = $Kernel::OM->Get('Kernel::System::Log');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $OldConfig       = $ConfigObject->Get('Ticket::Frontend::Article::Actions');

    return unless IsHashRefWithData($OldConfig);

    # deploy new sysconfig settings
    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
    my ( $Result, $ExitCode );

    {
        local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
        open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
        $ExitCode = $CommandObject->Execute();
    }

    if ( !$ExitCode ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Could not deploy system configuration!",
        );

        return;
    }

    CHANNEL:
    for my $Channel (qw(Internal Phone Email Invalid)) {

        next CHANNEL unless ( exists $OldConfig->{$Channel} && IsHashRefWithData( $OldConfig->{$Channel} ) );

        my %OldConfigSetting = $SysConfigObject->SettingGet(
            Name => "Ticket::Frontend::Article::Actions###$Channel",
        );

        next CHANNEL unless $OldConfigSetting{IsModified};

        my $ConfigName  = "Ticket::Frontend::Article::Actions::$Channel";
        my $SettingName = "Ticket::Frontend::Article::Actions::$Channel###000-Ticket";

        # tackle agent-side setting
        my %ArticleActionsSetting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );
        next CHANNEL if !%ArticleActionsSetting;

        # filter for standard actions only
        my %TransferConfigsHash;

        OLDCONFIGITEMNAME:
        for my $OldConfigItemName ( keys $OldConfig->{$Channel}->%* ) {
            next OLDCONFIGITEMNAME unless $ArticleActionsSetting{EffectiveValue}{$OldConfigItemName};
            next OLDCONFIGITEMNAME unless DataIsDifferent(
                Data1 => $OldConfig->{$Channel}{$OldConfigItemName},
                Data2 => $ArticleActionsSetting{EffectiveValue}{$OldConfigItemName},
            );

            $TransferConfigsHash{$OldConfigItemName} = $OldConfig->{$Channel}{$OldConfigItemName};
        }

        next CHANNEL unless %TransferConfigsHash;

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $ArticleActionsSetting{DefaultID},
        );

        # Update setting with modified data
        my %Result = $SysConfigObject->SettingUpdate(
            Name           => $SettingName,
            IsValid        => 1,
            EffectiveValue => {
                $ArticleActionsSetting{EffectiveValue}->%*,
                %TransferConfigsHash,
            },
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Could not update setting $SettingName.",
            );

            return;
        }

        my $Success = $SysConfigObject->SettingUnlock(
            UserID    => 1,
            DefaultID => $ArticleActionsSetting{DefaultID},
        );

        if ( !$Success ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Could not unlock setting $SettingName.",
            );

            return;
        }

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments      => "UpgradeTo11.1 - Migrated $ConfigName to $SettingName setting.",
            UserID        => 1,
            Force         => 1,
            DirtySettings => [$SettingName],
        );

        if ( !$DeploymentResult{Success} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Deployment failed.",
            );

            return;
        }
    }

    return 1;
}

1;
