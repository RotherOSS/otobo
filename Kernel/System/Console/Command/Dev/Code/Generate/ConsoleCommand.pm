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

package Kernel::System::Console::Command::Dev::Code::Generate::ConsoleCommand;
## nofilter(TidyAll::Plugin::OTOBO::Perl::LayoutObject)

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use File::Path     ();
use File::Basename qw(dirname);

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate a console command skeleton.');
    $Self->AddOption(
        Name        => 'module-directory',
        Description =>
            "Specify the directory containing the module where the new command should be created (otherwise the OTOBO home directory will be used).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'name',
        Description => "Specify the name of the new command (e.g. 'Admin::Test::Command').",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $ModuleDirectory = $Self->GetOption('module-directory');
    if ( $ModuleDirectory && !-d $ModuleDirectory ) {
        die "Directory $ModuleDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $CommandName = $Self->GetArgument('name');
    my $TargetHome  = $Self->GetOption('module-directory') || $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # Keep comment lines in files also in the generated output.
    local $ENV{TEMPLATE_KEEP_COMMENTS} = 1;

    # create perl module file
    my $CommandPathPM = $CommandName . ".pm";
    $CommandPathPM =~ s{::}{/}smxg;
    my $SkeletonFilePM = __FILE__;
    $SkeletonFilePM =~ s{ConsoleCommand\.pm$}{ConsoleCommand/ConsoleCommand.pm.skel}xms;

    my $SkeletonTemplatePM = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SkeletonFilePM,
    );
    if ( !$SkeletonTemplatePM || !${$SkeletonTemplatePM} ) {
        $Self->PrintError("Could not read $SkeletonFilePM.");

        return $Self->ExitCodeError();
    }

    my $SkeletonPM = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        Template => ${$SkeletonTemplatePM},
        Data     => {
            CommandPath => $CommandPathPM,
            CommandName => $CommandName,
        },
    );

    my $TargetLocationPM  = "$TargetHome/Kernel/System/Console/Command/$CommandPathPM";
    my $TargetDirectoryPM = dirname($TargetLocationPM);

    if ( !-d $TargetDirectoryPM ) {
        File::Path::make_path($TargetDirectoryPM);
    }

    if ( -f $TargetLocationPM ) {
        $Self->PrintError("$TargetLocationPM already exists.");

        return $Self->ExitCodeError();
    }

    my $SuccessPM = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $TargetLocationPM,
        Content  => \$SkeletonPM,
    );

    if ($SuccessPM) {
        $Self->Print("<green>Generated:</green> <yellow>$TargetLocationPM</yellow>\n");
    }
    else {
        $Self->PrintError("Could not generate $TargetLocationPM.\n");

        return $Self->ExitCodeError();
    }

    # create unit test file
    my $CommandPathUT = $CommandName . ".t";
    $CommandPathUT =~ s{::}{/}smxg;
    my $SkeletonFileUT = __FILE__;
    $SkeletonFileUT =~ s{ConsoleCommand\.pm$}{ConsoleCommand/ConsoleCommand.t.skel}xms;

    my $SkeletonTemplateUT = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SkeletonFileUT,
    );
    if ( !$SkeletonTemplateUT || !${$SkeletonTemplateUT} ) {
        $Self->PrintError("Could not read $SkeletonFileUT.");

        return $Self->ExitCodeError();
    }

    my $SkeletonUT = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        Template => ${$SkeletonTemplateUT},
        Data     => {
            CommandPath => $CommandPathUT,
            CommandName => $CommandName,
        },
    );

    my $TargetLocationUT  = "$TargetHome/scripts/test/Console/Command/$CommandPathUT";
    my $TargetDirectoryUT = dirname($TargetLocationUT);

    if ( !-d $TargetDirectoryUT ) {
        File::Path::make_path($TargetDirectoryUT);
    }

    if ( -f $TargetLocationUT ) {
        $Self->PrintError("$TargetLocationUT already exists.");

        return $Self->ExitCodeError();
    }

    my $SuccessUT = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $TargetLocationUT,
        Content  => \$SkeletonUT,
    );

    if ($SuccessUT) {
        $Self->Print("<green>Generated:</green> <yellow>$TargetLocationUT</yellow>\n");

        return $Self->ExitCodeOk();
    }

    $Self->PrintError("Could not generate $TargetLocationUT.\n");

    return $Self->ExitCodeError();
}

1;
