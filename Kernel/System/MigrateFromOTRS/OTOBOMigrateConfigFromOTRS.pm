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

package Kernel::System::MigrateFromOTRS::OTOBOMigrateConfigFromOTRS;

use strict;
use warnings;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
    'Kernel::System::SysConfig::DB',
    'Kernel::System::FileTemp',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::MigrateFromOTRS::Base',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOMigrateConfigFromOTRS - Migrate config effective values.

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

=head1 PUBLIC INTERFACE

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success.

    my $RequirementIsMet = $MigrateFromOTRSObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    return 1;
}

=head2 Run()

Execute the migration task. Called by C<Kernel::System::MigrateFromOTRS::_ExecuteRun()>.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject      = $Kernel::OM->Create('Kernel::System::DateTime');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');
    my $SysConfigObject     = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $SysConfigDBObject   = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my $Epoch = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOMigrateConfigFromOTRS',
            SubTask   => "Migrate configuration to OTOBO.",
            StartTime => $Epoch,
        },
    );

    # Clean SysConfig database

    # Create tempdir to save sysconfig export tmp
    my $TmpDirectory = $Kernel::OM->Get('Kernel::System::FileTemp')->TempDir();

    # Dump only changed SysConfig entries in string $Export
    # This is essentially the OTRS config, as the database tables were copied from OTRS.
    my $Export = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDump(
        SkipDefaultSettings => 1,
        SkipUserSettings    => 1,
    );

    if ( !$Export ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate configuration settings.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("An error occured during SysConfig data migration or no configuration exists.");
        $Result{Successful} = 1;

        return \%Result;
    }

    # Write sysconfig content to file
    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Directory  => $TmpDirectory,
        Filename   => 'SysConfigDump.sysconf',
        Content    => \$Export,
        Mode       => 'utf8',                    # binmode|utf8
        Type       => 'Local',                   # optional - Local|Attachment|MD5
        Permission => '660',                     # unix file permissions
    );

    $Self->CleanOTRSFileToOTOBOStyle(
        File   => $TmpDirectory . '/' . 'SysConfigDump.sysconf',
        UserID => 1,
    );

    # We need a yaml string
    my $YAMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $TmpDirectory . '/' . 'SysConfigDump.sysconf',
        Mode     => 'utf8',
    );

    $SysConfigObject->ConfigurationLoad(
        ConfigurationYAML => ${$YAMLString},    # a YAML string in the format of L<ConfigurationDump()>
        UserID            => 1,
    );

    $Self->DisableSecureMode();

    # Reset config options defined in Base.pm ResetConfigOption
    my %ResetConfig = $MigrationBaseObject->ResetConfigOption()->%*;

    for my $Configname ( sort keys %ResetConfig ) {

        # Lock all settings to be able to update them if needed.
        my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            UserID  => 1,
            LockAll => 1,
        );

        my $Result = $SysConfigObject->SettingReset(
            Name              => $Configname,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        # Log info to apache error log and OTOBO log (syslog or file)
        $MigrationBaseObject->MigrationLog(
            String =>
                "Reset config option $Configname, cause some changes in OTOBO. Please check the settings manualy.",
            Priority => "notice",
        );
    }

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            Force   => 1,
            UserID  => 1,
            CleanUp => 1,
        )
        )
    {
        # Log info to apache error log and OTOBO log (syslog or file)
        $MigrationBaseObject->MigrationLog(
            String   => "There was a problem writing XML to DB.",
            Priority => "error",
        );

        return {
            Message    => $Self->{LanguageObject}->Translate("Migrate configuration settings."),
            Comment    => $Self->{LanguageObject}->Translate("An error occured during SysConfig migration when writing XML to DB."),
            Successful => 0,
        };
    }

    # Write ZZZAAuto.pm
    my %DeployResult = $SysConfigObject->ConfigurationDeploy(
        Comments    => $Param{Comments} || 'Migrate Configuration from OTRS to OTOBO',
        AllSettings => 1,
        Force       => 1,
        UserID      => 1,
    );

    if ( !$DeployResult{Success} ) {
        return {
            Message => $Self->{LanguageObject}->Translate("Migrate configuration settings."),
            Comment => $Self->{LanguageObject}->Translate(<<'END_COMMENT'),
The merged configuration could not be deployed because it contains invalid values. Please try to fix the configuration
by running these commands: "bin/otobo.Console.pl Admin::Config::ListInvalid" and "bin/otobo.Console.pl Admin::Config::FixInvalid".
After fixing the configuration run "bin/otobo.Console.pl Maint::Config::Rebuild" and continue with the migration.
END_COMMENT
            Successful => 0,
        };
    }

    return {
        Message    => $Self->{LanguageObject}->Translate("Migrate configuration settings."),
        Comment    => $Self->{LanguageObject}->Translate("SysConfig data migration completed."),
        Successful => 1,
    };
}

1;
