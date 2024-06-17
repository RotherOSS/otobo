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

package Kernel::System::Console::Command::Dev::Package::Build;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Create an OTOBO package (opm) file from an OTOBO package source (sopm) file.');
    $Self->AddOption(
        Name        => 'version',
        Description => "Specify the version to be used (overrides version from sopm file).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d{1,4}[.]\d{1,4}[.]\d{1,4}$/smx,
    );
    $Self->AddOption(
        Name        => 'module-directory',
        Description =>
            "Specify the directory containing the module sources (otherwise the OTOBO home directory will be used).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'source-path',
        Description => "Specify the path to an OTOBO package source (sopm) file that should be built.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'target-directory',
        Description => "Specify the directory where the generated package should be placed.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Self->GetArgument('source-path');
    if ( !-r $SourcePath ) {
        die "File $SourcePath does not exist / cannot be read.\n";
    }

    my $TargetDirectory = $Self->GetArgument('target-directory');
    if ( !-d $TargetDirectory ) {
        die "Directory $TargetDirectory does not exist.\n";
    }

    my $ModuleDirectory = $Self->GetOption('module-directory');
    if ( $ModuleDirectory && !-d $ModuleDirectory ) {
        die "Directory $ModuleDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Building package...</yellow>\n");

    my $FileString;
    my $SourcePath = $Self->GetArgument('source-path');
    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SourcePath,
        Mode     => 'utf8',        # optional - binmode|utf8
        Result   => 'SCALAR',      # optional - SCALAR|ARRAY
    );
    if ( !$ContentRef || ref $ContentRef ne 'SCALAR' ) {
        $Self->PrintError("File $SourcePath is empty / could not be read.");
        return $Self->ExitCodeError();
    }
    $FileString = ${$ContentRef};

    my %Structure = $Kernel::OM->Get('Kernel::System::Package')->PackageParse(
        String => $FileString,
    );

    # Don't build the opm if the PackageIsDownloadable flag is explicitly disabled.
    if (
        defined $Structure{PackageIsDownloadable}
        && !$Structure{PackageIsDownloadable}->{Content}
        )
    {
        $Self->PrintError("Package is not built because the flag PackageIsDownloadable is set to 0.\n");

        return $Self->ExitCodeError();
    }

    if ( $Self->GetOption('version') ) {
        $Structure{Version}->{Content} = $Self->GetOption('version');
    }

    # build from given package directory, if any (otherwise default to OTOBO home)
    if ( $Self->GetOption('module-directory') ) {
        $Structure{Home} = $Self->GetOption('module-directory');
    }

    my $Filename = $Structure{Name}->{Content} . '-' . $Structure{Version}->{Content} . '.opm';
    my $Content  = $Kernel::OM->Get('Kernel::System::Package')->PackageBuild(%Structure);
    if ( !$Content ) {
        $Self->PrintError("Package build failed.\n");
        return $Self->ExitCodeError();
    }
    my $File = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $Self->GetArgument('target-directory') . '/' . $Filename,
        Content    => \$Content,
        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',                                                    # optional - Local|Attachment|MD5
        Permission => '644',                                                      # unix file permissions
    );
    if ( !$File ) {
        $Self->PrintError("File $File could not be written.\n");
        return $Self->ExitCodeError();
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
