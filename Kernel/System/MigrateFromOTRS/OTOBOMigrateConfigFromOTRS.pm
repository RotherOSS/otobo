# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::MigrateFromOTRS::OTOBOMigrateConfigFromOTRS;    ## no critic

use strict;
use warnings;
use File::Copy qw(copy);

use parent qw(Kernel::System::MigrateFromOTRS::Base);

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
    my ( $Self, %Param ) = @_;

    return 1;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Result;

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject      = $Kernel::OM->Create('Kernel::System::DateTime');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');
    my $SysConfigObject     = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $SysConfigDBObject   = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my $Epoch   = $DateTimeObject->ToEpoch();
    my $Success = 1;

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOMigrateConfigFromOTRS',
            SubTask   => "Migrate configuration to OTOBO.",
            StartTime => $Epoch,
        },
    );

    #
    # Clean SysConfig database
    #

    # Create tempdir to save sysconfig export tmp
    my $TmpDirectory = $Kernel::OM->Get('Kernel::System::FileTemp')->TempDir();

    # Dump only changed SysConfig entrys in string $Export
    my $Export = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDump(
        SkipDefaultSettings => 1,
        SkipUserSettings    => 1,
    );

    if ( !$Export ) {
        $Result{Message} = $Self->{LanguageObject}->Translate("Migrate configuration settings.");
        $Result{Comment} = $Self->{LanguageObject}
            ->Translate("An error occured during SysConfig data migration or no configuration exists.");
        $Result{Successful} = 1;
        return \%Result;
    }

    # Write opm content to new sopm file
    $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Directory  => $TmpDirectory,
        Filename   => 'SysConfigDump.sysconf',
        Content    => \$Export,
        Mode       => 'utf8',                    # binmode|utf8
        Type       => 'Local',                   # optional - Local|Attachment|MD5
        Permission => '660',                     # unix file permissions
    );

    $Success = $Self->CleanOTRSFileToOTOBOStyle(
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
    my $ResetConfigRef = $MigrationBaseObject->ResetConfigOption();
    my %ResetConfig    = %{$ResetConfigRef};

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
        $Result{Message} = $Self->{LanguageObject}->Translate("Migrate configuration settings.");
        $Result{Comment}
            = $Self->{LanguageObject}->Translate("An error occured during SysConfig migration when writing XML to DB.");
        $Result{Successful} = 0;
        return \%Result;
    }

    # Write ZZZAuto.pm
    $Success = $SysConfigObject->ConfigurationDeploy(
        Comments    => $Param{Comments} || "Migrate Configuration from OTRS to OTOBO",
        AllSettings => 1,
        Force       => 1,
        UserID      => 1,
    );

    if ( !$Success ) {
        $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate configuration settings.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("An error occured during SysConfig data migration.");
        $Result{Successful} = 0;
        return \%Result;
    }

    $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate configuration settings.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("SysConfig data migration completed.");
    $Result{Successful} = 1;
    return \%Result;
}

1;
