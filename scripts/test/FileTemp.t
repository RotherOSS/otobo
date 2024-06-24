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

use strict;
use warnings;
use utf8;

# core modules
use File::Basename qw(dirname);
use File::Copy     qw(copy);

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my ( $Filename, $FilenameSuffix, $TempDir, $FH, $FHSuffix );

{
    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

    ( $FH, $Filename ) = $FileTempObject->TempFile();

    $Self->True(
        $Filename,
        'TempFile()',
    );

    $Self->True(
        ( -e $Filename ),
        'TempFile() -e',
    );

    $Self->Is(
        ( substr( $Filename, -4 ) ),
        '.tmp',
        'TempFile() suffix',
    );

    ( $FHSuffix, $FilenameSuffix ) = $FileTempObject->TempFile( Suffix => '.png' );

    $Self->True(
        $FilenameSuffix,
        'TempFile()',
    );

    $Self->True(
        ( -e $FilenameSuffix ),
        'TempFile() -e',
    );

    $Self->Is(
        ( substr( $FilenameSuffix, -4 ) ),
        '.png',
        'TempFile() custom suffix',
    );

    $TempDir = $FileTempObject->TempDir();

    $Self->True(
        ( -d $TempDir ),
        "TempDir $TempDir exists",
    );

    my $ConfiguredTempDir = $ConfigObject->Get('TempDir');
    $ConfiguredTempDir =~ s{/+}{/}smxg;

    $Self->Is(
        ( dirname $TempDir ),
        $ConfiguredTempDir,
        "$TempDir is relative to defined TempDir",
    );

    $Self->True(
        ( copy( $ConfigObject->Get('Home') . '/scripts/test/FileTemp.t', "$TempDir/" ) ),
        'Copy test to tempdir',
    );

    $Self->True(
        ( -e $TempDir . '/FileTemp.t' ),
        'Copied file exists in tempdir',
    );

    # destroy the file temp object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::FileTemp'] );
}

$Self->False(
    ( -e $Filename ),
    "TempFile() $Filename -e after destroy",
);

$Self->False(
    ( -e $FilenameSuffix ),
    "TempFile() $FilenameSuffix -e after destroy",
);

$Self->False(
    ( -d $TempDir ),
    "TempDir() $TempDir removed after destroy",
);

$Self->DoneTesting();
