# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package scripts::DBUpdateTo6::MigrateConfigEffectiveValues;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::SysConfig::Migration',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateConfigEffectiveValues - Migrate config effective values.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # Move and rename ZZZAuto.pm from OTOBO 5 away from Kernel/Config/Files
    my ( $FileClass, $FilePath ) = $Self->_MoveZZZAuto();

    # check error
    if ( !$FilePath ) {
        if ($Verbose) {
            print
                "    Could not find Kernel/Config/Files/ZZZAuto.pm or Kernel/Config/Backups/ZZZAutoOTOBO5.pm, skipping...\n";
        }
        return 1;
    }

    # Rebuild config to read the xml config files from otobo 6 to write them
    # to the database and deploy them to ZZZAAuto.pm
    $Self->RebuildConfig();
    if ($Verbose) {
        print "\n    If you see errors about 'Setting ... is invalid', that's fine, no need to worry! \n"
            . "    This could happen because some config settings are no longer needed for OTOBO 6 \n"
            . "    or you may have some packages installed, which will be migrated \n"
            . "    in a later step (during the package upgrade). \n"
            . "\n"
            . "    The configuration migration can take some time, please be patient.\n";
    }

    # migrate the effective values from modified settings in OTOBO 5 to OTOBO 6
    my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
        FileClass => $FileClass,
        FilePath  => $FilePath,
        NoOutput  => !$Verbose,
    );

    return $Success;
}

sub _MoveZZZAuto {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # define old location of ZZZAuto.pm and file class name
    my $OldLocation  = "$Home/Kernel/Config/Files/ZZZAuto.pm";
    my $OldFileClass = 'Kernel::Config::Files::ZZZAuto';

    # define backup directory, new location of ZZZAuto.pm (renamed to ZZZAutoOTOBO5.pm)
    # and new file class
    my $BackupDirectory = "$Home/Kernel/Config/Backups";
    my $NewLocation     = "$BackupDirectory/ZZZAutoOTOBO5.pm";
    my $NewFileClass    = 'Kernel::Config::Backups::ZZZAutoOTOBO5';

    # ZZZAuto.pm file does not exist
    if ( !-e $OldLocation ) {

        # but Kernel/Config/Backups/ZZZAutoOTOBO5.pm exists already
        return ( $NewFileClass, $NewLocation ) if -e $NewLocation;

        # error
        return;
    }

    # check if backup directory exists
    if ( !-d $BackupDirectory ) {

        # we try to create it
        if ( !mkdir $BackupDirectory ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not create directory $BackupDirectory!",
            );
            return;
        }
    }

    # move it to new location and rename it
    system("mv $OldLocation $NewLocation");

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Read the content of the file. Make sure to open it in UTF-8 mode, in order to preserve multi-byte characters.
    #   Please see bug#13344 for more information.
    my $ContentSCALARRef = $MainObject->FileRead(
        Location => $NewLocation,
        Mode     => 'utf8',
    );

    # rename the package name inside the file
    ${$ContentSCALARRef} =~ s{^package $OldFileClass;$}{package $NewFileClass;}ms;

    # write content back to file
    my $FileLocation = $MainObject->FileWrite(
        Location   => $NewLocation,
        Content    => $ContentSCALARRef,
        Mode       => 'utf8',
        Permission => '644',
    );

    return ( $NewFileClass, $FileLocation );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
