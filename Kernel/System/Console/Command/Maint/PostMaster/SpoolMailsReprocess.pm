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

package Kernel::System::Console::Command::Maint::PostMaster::SpoolMailsReprocess;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Reprocess mails from spool directory that could not be imported in the first place.');

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SpoolDir = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/spool';
    if ( !-d $SpoolDir ) {
        die "Spool directory $SpoolDir does not exist!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $SpoolDir = "$Home/var/spool";

    $Self->Print("<yellow>Processing mails in $SpoolDir...</yellow>\n");

    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $SpoolDir,
        Filter    => '*',
    );

    my $Success = 1;

    for my $File (@Files) {
        $Self->Print("  Processing <yellow>$File</yellow>... ");

        # Here we use a system call because Maint::PostMaster::Read has special exception handling
        #   and will die if certain problems occur.
        my $Result = system("$^X $Home/bin/otobo.Console.pl Maint::PostMaster::Read <  $File ");

        # Exit code 0 == success
        if ( !$Result ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Successfully reprocessed email $File.",
            );
            unlink $File;
            $Self->Print("<green>Ok.</green>\n");
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not re-process email $File.",
            );
            $Self->Print("<red>Failed.</red>\n");
            $Success = 0;
        }
    }

    if ( !$Success ) {
        $Self->PrintError("There were problems importing the spool mails.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
