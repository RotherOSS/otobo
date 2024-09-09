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

package Kernel::System::Console::Command::Dev::Package::DocumentationGenerate;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::SysConfig::XML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate a documentation skeleton containing the current sopm and SysConfig information.');
    $Self->AddOption(
        Name        => 'module-directory',
        Description =>
            "Specify the directory containing the module sources (otherwise the OTOBO home directory will be used).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'force',
        Description => "Overwrite the current files.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddArgument(
        Name        => 'source-path',
        Description => "Specify the path to an OTOBO package source (sopm) file that should be built.",
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

    my $ModuleDirectory = $Self->GetOption('module-directory');
    if ( $ModuleDirectory && !-d $ModuleDirectory ) {
        die "Directory $ModuleDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

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

    if ( !$Structure{Name}->{Content} ) {
        $Self->PrintError("Source sopm incomplete - no name present.\n");
        return $Self->ExitCodeError();
    }

    my $Home = $Self->GetOption('module-directory') || '.';
    $Home =~ s/\/$//;

    if ( !$Self->GetOption('force') && -e "$Home/doc/content/index.rst" ) {
        $Self->PrintError("$Home/doc/content/index.rst already exists. Use '--force' to overwrite (if you want that!).\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<yellow>Generating documentation...</yellow>\n");

    my $MainObject         = $Kernel::OM->Get('Kernel::System::Main');
    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

    my @SettingList;
    my @XMLConfigFiles;
    for my $File ( $Structure{Filelist}->@* ) {
        if ( $File->{Location} =~ m(Kernel/Config/Files/XML/.+\.xml$) ) {
            push @XMLConfigFiles, "$Home/$File->{Location}";
        }
    }

    FILE:
    for my $File (@XMLConfigFiles) {

        # Read XML file.
        my $ConfigFile = $MainObject->FileRead(
            Location => $File,
            Mode     => 'utf8',
            Result   => 'SCALAR',
        );
        if ( !ref $ConfigFile || !${$ConfigFile} ) {
            $Self->PrintError("Can't open file $File: $!");

            next FILE;
        }

        my @ParsedSettings = $SysConfigXMLObject->SettingListParse(
            XMLInput    => ${$ConfigFile},
            XMLFilename => $File,
        );

        if (@ParsedSettings) {
            push @SettingList, @ParsedSettings;
        }
    }

    my $RST = join(
        '',
        $Self->FrontMatter(
            Structure => \%Structure,
        ),
        $Self->Skeleton(
            Structure => \%Structure,
        ),
        $Self->ConfigReference(
            SettingList => \@SettingList,
        ),
        $Self->BackMatter(),
    );

    my $Success = $MainObject->FileWrite(
        Directory => "$Home/doc/content",
        Filename  => 'index.rst',
        Content   => \$RST,
        Mode      => 'utf8',
        Parents   => 1,
    );

    if ( !$Success ) {
        $Self->PrintError("Could not write $Home/doc/en/$Structure{Name}{Content}.rst.\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub FrontMatter {
    my ( $Self, %Param ) = @_;

# sphinx will eat the first chapter, so we make a sacrificial chapter - see https://stackoverflow.com/questions/27965192/python-sphinx-skips-first-section-when-generating-pdf
    return <<"END";
.. toctree::
    :maxdepth: 2
    :caption: Contents

Sacrifice to Sphinx
===================

END
}

sub Skeleton {
    my ( $Self, %Param ) = @_;

    my %Descriptions = map { $_->{Lang} => $_->{Content} } $Param{Structure}{Description}->@*;
    my $Description  = $Descriptions{en} || $Descriptions{de} || 'What do I do?';

    my $PackageRequired;
    if ( $Param{Structure}{PackageRequired} ) {
        for my $Package ( $Param{Structure}{PackageRequired}->@* ) {
            $PackageRequired .= "$Package->{Content} $Package->{Version}\n";
        }

        chomp $PackageRequired;
    }

    else {
        $PackageRequired = '\\-';
    }

    return <<"END";
Description
===========
$Description

System requirements
===================

Framework
---------
OTOBO $Param{Structure}{Framework}[0]{Content}

Packages
--------
$PackageRequired

Third-party software
--------------------
\\-

Usage
=====

Setup
-----

END
}

sub ConfigReference {
    my ( $Self, %Param ) = @_;

    my %Navigation;

    for my $Setting ( $Param{SettingList}->@* ) {
        push $Navigation{ $Setting->{XMLContentParsed}{Navigation}[0]{Content} }->@*, {
            Name        => $Setting->{XMLContentParsed}{Name},
            Required    => $Setting->{XMLContentParsed}{Required},
            Description => $Setting->{XMLContentParsed}{Description}[0]{Content},
        };
    }

    return if !%Navigation;

    my $ConfigReference =
        "Configuration Reference\n" .
        "-----------------------\n\n";

    for my $NavEntry ( sort keys %Navigation ) {
        $ConfigReference .=
            "$NavEntry\n" .
            "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\n";

        for my $Setting ( sort $Navigation{$NavEntry}->@* ) {
            $ConfigReference .=
                "$Setting->{Name}\n" .
                '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""' .
                "\n$Setting->{Description}\n\n";
        }
    }

    return $ConfigReference;
}

sub BackMatter {
    my ( $Self, %Param ) = @_;

    return <<'END';
About
=======

Contact
-------
| Rother OSS GmbH
| Email: hello@otobo.io
| Web: https://otobo.io

Version
-------
Author: |doc-vendor| / Version: |doc-version| / Date of release: |doc-datestamp|
END
}

1;
