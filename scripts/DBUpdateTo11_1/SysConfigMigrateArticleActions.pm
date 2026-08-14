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
use List::Util qw(none uniq);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(DataIsDifferent IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
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

    # $OldConfig contains the old settings from OTOBO 11.0.x assuming
    # that Maint::Config::Rebuild hasn't run with the option --cleanup before.
    # Having executed Maint::Config::Rebuild without the cleanup option is fine.
    my $OldConfig = $ConfigObject->Get('Ticket::Frontend::Article::Actions');
    if ( !IsHashRefWithData($OldConfig) ) {

        # This case also occurs on installations that were installed as 11.1.x. But in that case
        # there is no obvious reason why the migration is executed.
        $LogObject->Log(
            Priority => 'notice',
            Message  => "Could not retrieve the setting Ticket::Frontend::Article::Actions",
        );

        return 1;
    }

    # hardcoded content of 11.0 default config for comparison later on
    my %OldConfigDefault = (
        Internal => {
            AgentTicketArticleRestore => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketArticleRestore',
                Prio   => 10,
                Valid  => 1,
            },
            AgentTicketArticleDelete => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketArticleDelete',
                Prio   => 20,
                Valid  => 1,
            },
            AgentTicketArticleVersion => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketArticleVersion',
                Prio   => 30,
                Valid  => 1,
            },
            AgentTicketArticleEdit => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketArticleEdit',
                Prio   => 40,
                Valid  => 1,
            },
            AgentTicketCompose => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketCompose',
                Prio   => 100,
                Valid  => 1,
            },
            AgentTicketForward => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketForward',
                Prio   => 200,
                Valid  => 1,
            },
            AgentTicketBounce => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketBounce',
                Prio   => 300,
                Valid  => 1,
            },
            AgentTicketPhone => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPhone',
                Prio   => 400,
                Valid  => 1,
            },
            AgentTicketPrint => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPrint',
                Prio   => 500,
                Valid  => 1,
            },
            AgentTicketPlain => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPlain',
                Prio   => 600,
                Valid  => 1,
            },
            MarkAsImportant => {
                Module => 'Kernel::Output::HTML::ArticleAction::MarkAsImportant',
                Prio   => 700,
                Valid  => 1,
            },
            AgentTicketNote => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketNote',
                Prio   => 800,
                Valid  => 1,
            },
            MarkArticleSeenUnseen => {
                Module => 'Kernel::Output::HTML::ArticleAction::MarkArticleSeenUnseen',
                Prio   => 900,
                Valid  => 1,
            },
        },
        Phone => {
            AgentTicketCompose => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketCompose',
                Prio   => 100,
                Valid  => 1,
            },
            AgentTicketArticleEdit => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketArticleEdit',
                Prio   => 1100,
                Valid  => 1,
            },
            AgentTicketForward => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketForward',
                Prio   => 200,
                Valid  => 1,
            },
            AgentTicketBounce => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketBounce',
                Prio   => 300,
                Valid  => 1,
            },
            AgentTicketPhone => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPhone',
                Prio   => 400,
                Valid  => 1,
            },
            AgentTicketPrint => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPrint',
                Prio   => 500,
                Valid  => 1,
            },
            AgentTicketPlain => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPlain',
                Prio   => 600,
                Valid  => 1,
            },
            MarkAsImportant => {
                Module => 'Kernel::Output::HTML::ArticleAction::MarkAsImportant',
                Prio   => 700,
                Valid  => 1,
            },
            AgentTicketNote => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketNote',
                Prio   => 800,
                Valid  => 1,
            },
            MarkArticleSeenUnseen => {
                Module => 'Kernel::Output::HTML::ArticleAction::MarkArticleSeenUnseen',
                Prio   => 900,
                Valid  => 1,
            },
        },
        Email => {
            AgentTicketCompose => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketCompose',
                Prio   => 100,
                Valid  => 1,
            },
            AgentTicketForward => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketForward',
                Prio   => 200,
                Valid  => 1,
            },
            AgentTicketBounce => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketBounce',
                Prio   => 300,
                Valid  => 1,
            },
            AgentTicketPhone => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPhone',
                Prio   => 400,
                Valid  => 1,
            },
            AgentTicketPrint => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPrint',
                Prio   => 500,
                Valid  => 1,
            },
            AgentTicketMessageLog => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketMessageLog',
                Prio   => 550,
                Valid  => 1,
            },
            AgentTicketPlain => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketPlain',
                Prio   => 600,
                Valid  => 1,
            },
            MarkAsImportant => {
                Module => 'Kernel::Output::HTML::ArticleAction::MarkAsImportant',
                Prio   => 700,
                Valid  => 1,
            },
            AgentTicketNote => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketNote',
                Prio   => 800,
                Valid  => 1,
            },
            AgentTicketEmailResend => {
                Module => 'Kernel::Output::HTML::ArticleAction::AgentTicketEmailResend',
                Prio   => 900,
                Valid  => 1,
            },
            MarkArticleSeenUnseen => {
                Module => 'Kernel::Output::HTML::ArticleAction::MarkArticleSeenUnseen',
                Prio   => 1000,
                Valid  => 1,
            },
        },
        Invalid => {
            ReinstallPackageLink => {
                Module => 'Kernel::Output::HTML::ArticleAction::ReinstallPackageLink',
                Prio   => 200,
                Valid  => 1,
            },
            GetHelpLink => {
                Module => 'Kernel::Output::HTML::ArticleAction::GetHelpLink',
                Prio   => 100,
                Valid  => 1,
            },
            MarkArticleSeenUnseen => {
                Module => 'Kernel::Output::HTML::ArticleAction::MarkArticleSeenUnseen',
                Prio   => 100,
                Valid  => 1,
            },
        },
    );
    my @KnownModules = (
        'Kernel::Output::HTML::ArticleAction::AgentTicketArticleRestore',
        'Kernel::Output::HTML::ArticleAction::AgentTicketArticleDelete',
        'Kernel::Output::HTML::ArticleAction::AgentTicketArticleVersion',
        'Kernel::Output::HTML::ArticleAction::AgentTicketArticleEdit',
        'Kernel::Output::HTML::ArticleAction::AgentTicketCompose',
        'Kernel::Output::HTML::ArticleAction::AgentTicketForward',
        'Kernel::Output::HTML::ArticleAction::AgentTicketBounce',
        'Kernel::Output::HTML::ArticleAction::AgentTicketPhone',
        'Kernel::Output::HTML::ArticleAction::AgentTicketPrint',
        'Kernel::Output::HTML::ArticleAction::AgentTicketPlain',
        'Kernel::Output::HTML::ArticleAction::MarkAsImportant',
        'Kernel::Output::HTML::ArticleAction::AgentTicketNote',
        'Kernel::Output::HTML::ArticleAction::MarkArticleSeenUnseen',
        'Kernel::Output::HTML::ArticleAction::AgentTicketMessageLog',
        'Kernel::Output::HTML::ArticleAction::AgentTicketEmailResend',
        'Kernel::Output::HTML::ArticleAction::ReinstallPackageLink',
        'Kernel::Output::HTML::ArticleAction::GetHelpLink',
    );

    CHANNEL:
    for my $Channel (qw(Internal Phone Email Invalid)) {

        my %OldConfigSetting = $SysConfigObject->SettingGet(
            Name => "Ticket::Frontend::Article::Actions###$Channel",
        );

        next CHANNEL unless $OldConfigSetting{IsModified};

        my $ConfigName  = "Ticket::Frontend::Article::Actions::$Channel";
        my $SettingName = "Ticket::Frontend::Article::Actions::$Channel###000-Ticket";

        my %ArticleActionsSetting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );
        if ( !%ArticleActionsSetting ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Setting $SettingName not present despite it should be - skipping...",
            );
            next CHANNEL;
        }

        my %ArticleActionsToStore = $ArticleActionsSetting{EffectiveValue}->%*;

        # compare modified setting with defaults from core
        {
            my %DefaultConfig = $OldConfigDefault{$Channel}->%*;

            ACTION:
            for my $Action ( uniq( keys $OldConfig->{$Channel}->%*, keys $ArticleActionsSetting{EffectiveValue}->%* ) ) {

                # not present in old modified config - count as deleted
                if ( !$OldConfig->{$Channel}{$Action} ) {
                    delete $ArticleActionsToStore{$Action};

                    next ACTION;
                }

                my %OldActionConfig = $OldConfig->{$Channel}{$Action}->%*;

                # check if action config changed at all
                if ( $DefaultConfig{$Action} ) {
                    my $IsDifferent = DataIsDifferent(
                        Data1 => $DefaultConfig{$Action},
                        Data2 => \%OldActionConfig,
                    );

                    next ACTION unless $IsDifferent;
                }

                # check if module of changed config is present
                my $ModuleChanged = $OldActionConfig{Module};
                if ( none { $_ eq $ModuleChanged } @KnownModules ) {
                    delete $ArticleActionsToStore{$Action};

                    next ACTION;
                }

                # config changed and module present - update config
                $ArticleActionsToStore{$Action} = \%OldActionConfig;
            }
        }

        # do not update if nothing changed at all
        my $ConfigIsDifferent = DataIsDifferent(
            Data1 => \%ArticleActionsToStore,
            Data2 => $ArticleActionsSetting{EffectiveValue},
        );

        next CHANNEL unless $ConfigIsDifferent;

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
                %ArticleActionsToStore,
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
