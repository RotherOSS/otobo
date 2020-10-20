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

package Kernel::System::Console::Command::Dev::Git::InstallHooks;

use strict;
use warnings;
use v5.24;
use utf8;
use namespace::autoclean;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use File::Path qw(make_path);
use File::Basename qw(fileparse);
use File::Spec qw();

# CPAN modules

# OTOBO modules


our @ObjectDependencies = (
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description( <<'END_DESC' );
Install git hooks into .git/hooks. Currently only the hook 'prepare-commit-msg' is supported.
Already existing hook scripts will be saved with a numbered extension.
END_DESC

    # no options or arguments are supported

    # $Self->AddOption(
    #     Name        => 'option',
    #     Description => "Describe this option.",
    #     Required    => 1,
    #     HasValue    => 1,
    #     ValueRegex  => qr/.*/smx,
    # );
    # $Self->AddArgument(
    #     Name        => 'argument',
    #     Description => "Describe this argument.",
    #     Required    => 1,
    #     ValueRegex  => qr/.*/smx,
    # );

    return;
}

# sub PreRun {
#     my ( $Self, %Param ) = @_;
#
#     # Perform any custom validations here. Command execution can be stopped with die().
#
#     # my $TargetDirectory = $Self->GetOption('target-directory');
#     # if ($TargetDirectory && !-d $TargetDirectory) {
#     #     die "Directory $TargetDirectory does not exist.\n";
#     # }
#
#     return;
# }

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Installing git hooks. See .git/hooks for the installed hooks.</yellow>\n");

    # make sure that the target dir exists
    # Do not rely on the config setting 'HOME'
    my $TargetDir = '.git/hooks';
    make_path( $TargetDir );

    # loop over the scripts in the dir corresponding to the command module
    my $SourceDir = __FILE__ =~ s{\.pm$}{}r;

    for my $DistFile ( grep { -f -r } glob "$SourceDir/*" ) {

        # Determine the target path
        my $HookName = fileparse( $DistFile, '.dist' );
        my $Target   = File::Spec->catfile( $TargetDir, $HookName );

        # use cp --backup=numbered because File::Copy doesn't support backups out of the box
        # Note: this might fail on non-Linux systems
        my $RetCp = system( 'cp', '--backup=numbered', $DistFile, $Target );
        if ( $RetCp != 0 ) {
            say "copying $DistFile into $TargetDir failed: $?";

            return $Self->ExitCodeError();
        }

        # make hook executable for the user: chmod u+x
        # But it looks like File::chmod is not a required module.
        my $OldMode = (stat($Target))[2];
        my $NewMode = $OldMode | 0100;
        my $RetChmod = chmod $NewMode, $Target;
        if ( $RetCp != 0 ) {
            say "setting $Target to executable failed";

            return $Self->ExitCodeError();
        }

        say "successfully installed $Target";
    }

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

# sub PostRun {
#     my ( $Self, %Param ) = @_;
#
#     # This will be called after Run() (even in case of exceptions). Perform any cleanups here.
#
#     return;
# }

1;
