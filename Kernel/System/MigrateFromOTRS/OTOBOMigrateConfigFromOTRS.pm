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
    'Kernel::Language',
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::FileTemp',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOMigrateConfigFromOTRS - Migrate config effective values.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my %Result;

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Epoch          = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOMigrateConfigFromOTRS',
            SubTask   => "Migrate configuration to OTOBO.",
            StartTime => $Epoch,
        },
    );

    my $Success         = 1;
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    #
    # Clean SysConfig database
    #

    # Create tempdir to save sysconfig export tmp
    my $TmpDirectory = $Kernel::OM->Get('Kernel::System::FileTemp')->TempDir();

    # Dump only changed SysConfig entrys in string $Export
    my $Export = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDump(
        SkipDefaultSettings => 1,
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

    $Success = $SysConfigObject->ConfigurationLoad(
        ConfigurationYAML => ${$YAMLString},    # a YAML string in the format of L<ConfigurationDump()>
        UserID            => 123,
    );

    # Write ZZZAuto.pm
    $Success = $SysConfigObject->ConfigurationDeploySync();

    $Self->DisableSecureMode();

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

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
