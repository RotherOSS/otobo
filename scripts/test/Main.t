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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use File::Path qw(rmtree);

# CPAN modules
use JSON::PP ();
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM

our $Self;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# FilenameCleanUp - tests, Attachment and md5
my @FilenameCleanUpTests = (
    {
        Name         => 'Attachment',
        FilenameOrig => 'me_to/a+la l.xml',
        FilenameNew  => 'me_to_a+la_l.xml',
        Type         => 'Attachment',
    },
    {
        Name         => 'leading dots - Attachment',
        FilenameOrig => '....test.xml',
        FilenameNew  => 'test.xml',
        Type         => 'Attachment',
    },
    {
        Name         => 'Attachment',
        FilenameOrig => 'me_to/a+lal123456789012345678901234567890Liebe Grüße aus Straubing123456789012345678901234567890123456789012345678901234567890.xml',
        FilenameNew  => 'me_to_a+lal123456789012345678901234567890Liebe_Gruesse_aus_Straubing123456789012345678901234567890123456789012345678901234567890.xml',
        Type         => 'Attachment',
    },
    {
        Name         => 'md5',
        FilenameOrig => 'some file.xml',
        FilenameNew  => '6b9e62f9a8c56a0c06c66cc716e30c45',
        Type         => 'md5',
    },
    {
        Name         => 'md5',
        FilenameOrig => 'me_to/a+lal Grüße 0öäüßカスタマ.xml',
        FilenameNew  => 'c235a9eabe8494b5f90ffd1330af3407',
        Type         => 'md5',
    },
);

for my $Test (@FilenameCleanUpTests) {
    my $Filename = $MainObject->FilenameCleanUp(
        Filename => $Test->{FilenameOrig},
        Type     => $Test->{Type},
    );

    is( $Filename, $Test->{FilenameNew}, "FilenameCleanUp() - $Test->{Name}" );
}

# FilenameCleanUp - tests Local, both with or withoud NoReplace
my @FilenameCleanUpLocalTests = (
    {
        Name     => 'alphanumeric',
        Original => 'abcABC012_',
    },
    {
        Name     => 'greek',
        Original => 'Ρόδος',
    },
    {
        Name           => 'space and slash',
        Original       => 'me_t o/alal.xml',
        LocalReplace   => 'me_t_o_alal.xml',
        LocalNoReplace => 'me_t o/alal.xml',
    },
    {
        Name           => 'question mark',
        Original       => 'me_to/al?al"l.xml',
        LocalReplace   => 'me_to_al_al_l.xml',
        LocalNoReplace => 'me_to/al?al"l.xml',
    },
    {
        Name           => 'backslash',
        Original       => 'me_to/a\/\\lal.xml',
        LocalReplace   => 'me_to_a___lal.xml',
        LocalNoReplace => 'me_to/a\/\\lal.xml',
    },
    {
        Name           => 'brackets',
        Original       => 'me_to/al[al].xml',
        LocalReplace   => 'me_to_al_al_.xml',
        LocalNoReplace => 'me_to/al[al].xml',
    },
    {
        Name           => 'slash',
        Original       => 'me_to/alal.xml',
        LocalReplace   => 'me_to_alal.xml',
        LocalNoReplace => 'me_to/alal.xml',
    },
    {
        Name     => 'short filename and short extension',
        Original => 'short.short',
    },
    {
        Name         => 'long filename',
        Original     => 'a' x 250,
        LocalReplace => 'a' x 220,
    },
    {
        Name         => 'öong filename short extension',
        Original     => 'a' x 250 . '.test',
        LocalReplace => 'a' x 215 . '.test',
    },
    {
        Name         => 'short filename long extension',
        Original     => 'test.' . 'a' x 250,
        LocalReplace => 't.' . 'a' x 218,
    },
    {
        Name         => 'long filename no extension - 2 bytes character',
        Original     => 'ß' x 250,
        LocalReplace => 'ß' x 110,
    },
    {
        Name         => 'long filename short extension - 2 bytes character',
        Original     => 'ß' x 250 . '.test',
        LocalReplace => 'ß' x 107 . '.test',
    },
    {
        Name         => ' Short filename long extension - 2 bytes character',
        Original     => 'test.' . 'ß' x 250,
        LocalReplace => 't.' . 'ß' x 109,
    },
    {
        Name     => 'filename ending with period',
        Original => 'abc.',
    },
    {
        Name           => 'umlaut, eszett, plus',
        Original       => 'me_to/a+lal Grüße 0.xml',
        LocalReplace   => 'me_to_a+lal_Grüße_0.xml',
        LocalNoReplace => 'me_to/a+lal Grüße 0.xml',
        S3             => 'me_to_a_lal_Grüße_0.xml',
    },
    {
        Name         => 'leading dots',
        Original     => '....test.xml',
        LocalReplace => 'test.xml',
    },
    {
        Name           => 'U+02460 - CIRCLED DIGIT ONE',
        Original       => 'circled_one_①.txt',
        LocalReplace   => 'circled_one__.txt',
        LocalNoReplace => 'circled_one_①.txt',
    },

    # The AWS documentation lists characters that should be avoided.
    # See https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-keys.html.
    # Only the pound sign is not replaced by the type 'Local'
    {
        Name           => 'S3 characters to avoid',
        Original       => qq{a\\b{c\x{80}d\x{FF}e^f}g%h`i]j"k>l[m~n<o#p|q},
        LocalReplace   => 'a_b_c_d_e_f_g_h_i_j_k_l_m_n_o#p_q',
        LocalNoReplace => qq{a\\b{c\x{80}d\x{FF}e^f}g%h`i]j"k>l[m~n<o#p|q},
        S3             => 'a_b_c_d_e_f_g_h_i_j_k_l_m_n_o_p_q',
    },
    {
        Name     => 'pound sign',
        Original => 'pound_sign_#',
        S3       => 'pound_sign__',
    },

    # The AWS documentation lists characters that might require extra handling
    # See https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-keys.html.
    # Only the plus is not replaced by the type 'Local'
    {
        Name           => 'S3 characters with extra handling',
        Original       => qq{A&B\$C\x{00}D\x{1F}E\x{7F}F\@G=H;I/J:K+L M,N?O},
        LocalReplace   => 'A_B_C_D_E_F_G_H_I_J_K+L_M_N_O',
        LocalNoReplace => qq{A&B\$C\x{00}D\x{1F}E\x{7F}F\@G=H;I/J:K+L M,N?O},
        S3             => 'A_B_C_D_E_F_G_H_I_J_K_L_M_N_O',
    },
    {
        Name     => 'plussign',
        Original => 'plus_+',
        S3       => 'plus__',
    },
);

for my $Test (@FilenameCleanUpLocalTests) {
    subtest "FilenameCleanUp() - Local - $Test->{Name}" => sub {
        my $Replace = $MainObject->FilenameCleanUp(
            Filename => $Test->{Original},
            Type     => 'Local',
        );

        is(
            $Replace,
            $Test->{LocalReplace} // $Test->{Original},
            'LocalReplace'
        );

        my $NoReplace = $MainObject->FilenameCleanUp(
            Filename  => $Test->{Original},
            Type      => 'Local',
            NoReplace => 'ß',
        );

        is(
            $NoReplace,
            $Test->{LocalNoReplace} // $Test->{LocalReplace} // $Test->{Original},
            'LocalNoReplace'
        );

        my $TypeS3 = $MainObject->FilenameCleanUp(
            Filename => $Test->{Original},
            Type     => 'S3',
        );

        is(
            $TypeS3,
            $Test->{S3} // $Test->{LocalReplace} // $Test->{Original},
            'S3'
        );
    };
}

# md5sum tests
my $String = 'abc1234567890';
my $MD5Sum = $MainObject->MD5sum( String => \$String );
is(
    $MD5Sum,
    '57041f8f7dff9b67e3f97d7facbaf8d3',
    "MD5sum() - String - abc1234567890",
);

# test charset specific situations
$String = 'abc1234567890äöüß-カスタマ';
$MD5Sum = $MainObject->MD5sum( String => \$String );

is(
    $MD5Sum,
    '56a681e0c46b1f156020182cdf62e825',
    "MD5sum() - String - $String",
);

my %MD5SumOf = (
    doc => '2e520036a0cda6a806a8838b1000d9d7',
    pdf => '5ee767f3b68f24a9213e0bef82dc53e5',
    png => 'e908214e672ed20c9c3f417b82e4e637',
    txt => '0596f2939525c6bd50fc2b649e40fbb6',
    xls => '39fae660239f62bb0e4a29fe14ff5663',
);

my $Home = $ConfigObject->Get('Home');

for my $Extension (qw(doc pdf png txt xls)) {
    my $MD5Sum = $MainObject->MD5sum(
        Filename => $Home . "/scripts/test/sample/Main/Main-Test1.$Extension",
    );
    is(
        $MD5Sum,
        $MD5SumOf{$Extension},
        "MD5sum() - Filename - Main-Test1.$Extension",
    );
}

my $Path = $ConfigObject->Get('TempDir');

# write & read some files via Directory/Filename
for my $Extension (qw(doc pdf png txt xls)) {
    my $MD5Sum = $MainObject->MD5sum(
        Filename => $Home . "/scripts/test/sample/Main/Main-Test1.$Extension",
    );
    my $Content = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Main/',
        Filename  => "Main-Test1.$Extension",
    );
    ok(
        ${$Content},
        "FileRead() - Main-Test1.$Extension",
    );
    my $FileLocation = $MainObject->FileWrite(
        Directory => $Path,
        Filename  => "me_öüto/al<>?Main-Test1.$Extension",
        Content   => $Content,
    );
    ok(
        $FileLocation,
        "FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $MainObject->MD5sum(
        Filename => $Path . '/' . $FileLocation,
    );
    is(
        $MD5Sum2,
        $MD5Sum,
        "MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $MainObject->FileDelete(
        Directory => $Path,
        Filename  => $FileLocation,
    );
    ok(
        $Success,
        "FileDelete() - $FileLocation",
    );
}

# write & read some files via Location
for my $Extension (qw(doc pdf png txt xls)) {
    my $MD5Sum = $MainObject->MD5sum(
        Filename => $Home . "/scripts/test/sample/Main/Main-Test1.$Extension",
    );
    my $Content = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/Main/' . "Main-Test1.$Extension",
    );
    $Self->True(
        ${$Content} || '',
        "FileRead() - Main-Test1.$Extension",
    );
    my $FileLocation = $MainObject->FileWrite(
        Location => $Path . "Main-Test1.$Extension",
        Content  => $Content,
    );
    $Self->True(
        $FileLocation || '',
        "FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $MainObject->MD5sum( Filename => $FileLocation );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum  || '',
        "MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $MainObject->FileDelete( Location => $FileLocation );
    $Self->True(
        $Success || '',
        "FileDelete() - $FileLocation",
    );
}

# write / read ARRAYREF test
my $Content      = "some\ntest\nöäüßカスタマ";
my $FileLocation = $MainObject->FileWrite(
    Directory => $Path,
    Filename  => "some-test.txt",
    Mode      => 'utf8',
    Content   => \$Content,
);
$Self->True(
    $FileLocation || '',
    "FileWrite() - $FileLocation",
);

my $ContentARRAYRef = $MainObject->FileRead(
    Directory => $Path,
    Filename  => $FileLocation,
    Mode      => 'utf8',
    Result    => 'ARRAY',         # optional - SCALAR|ARRAY
);
$Self->True(
    $ContentARRAYRef || '',
    "FileRead() - $FileLocation $ContentARRAYRef",
);
$Self->Is(
    $ContentARRAYRef->[0] || '',
    "some\n",
    "FileRead() [0] - $FileLocation",
);
$Self->Is(
    $ContentARRAYRef->[1] || '',
    "test\n",
    "FileRead() [1] - $FileLocation",
);
$Self->Is(
    $ContentARRAYRef->[2] || '',
    "öäüßカスタマ",
    "FileRead() [2] - $FileLocation",
);

my $Success = $MainObject->FileDelete(
    Directory => $Path,
    Filename  => $FileLocation,
);
$Self->True(
    $Success || '',
    "FileDelete() - $FileLocation",
);

# check if the file have the correct charset
my $ContentSCALARRef = $MainObject->FileRead(
    Location => $Home . '/scripts/test/sample/Main/PDF-test2-utf-8.txt',
    Mode     => 'utf8',
    Result   => 'SCALAR',
);

my $Text = ${$ContentSCALARRef};

$Self->True(
    Encode::is_utf8($Text),
    "FileRead() - Check a utf8 file - exists the utf8 flag ( $Text )",
);

$Self->True(
    Encode::is_utf8( $Text, 1 ),
    "FileRead() - Check a utf8 file - is the utf8 content wellformed ( $Text )",
);

# FileGetMTime tests
{
    my $FileMTime = $MainObject->FileGetMTime(
        Location => $Home . '/Kernel/Config.pm',
    );

    $Self->True(
        int $FileMTime > 1_000_000,
        'FileGetMTime()',
    );

    my $FileMTimeNonexisting = $MainObject->FileGetMTime(
        Location => $Home . '/Kernel/some.nonexisting.file',
    );

    $Self->False(
        defined $FileMTimeNonexisting,
        'FileGetMTime() for nonexisting file',
    );
}

# testing GetReleaseInfo
{
    my $ReleaseInfoByFilename = $MainObject->GetReleaseInfo(
        Directory => $Home,
        Filename  => 'RELEASE',
    );
    like(
        $ReleaseInfoByFilename,
        {
            Product => 'OTOBO',
            Version => qr/^11\./,
        },
        'release info via file name'
    );

    my $ReleaseInfoByLocation = $MainObject->GetReleaseInfo(
        Location => "$Home/RELEASE",
    );
    like(
        $ReleaseInfoByLocation,
        {
            Product => 'OTOBO',
            Version => qr/^11\./,
        },
        'release info via location'
    );

    my $ReleaseInfoNoArgs = $MainObject->GetReleaseInfo(
    );
    is(
        $ReleaseInfoNoArgs,
        {},
        'GetReleaseInfo() called with missing args'
    );

    my $ReleaseInfoDummyLocation = $MainObject->GetReleaseInfo(
        Location => "$Home/RELIES",
    );
    is(
        $ReleaseInfoNoArgs,
        {},
        'GetReleaseInfo() called with non-existing location'
    );
}

# testing DirectoryRead function
my $DirectoryWithFiles    = "$Path/WithFiles";
my $DirectoryWithoutFiles = "$Path/WithoutFiles";
my $SubDirA               = "$DirectoryWithFiles/a";
my $SubDirB               = "$DirectoryWithFiles/b";

# create needed test directories
for my $Directory ( $DirectoryWithFiles, $DirectoryWithoutFiles, $SubDirA, $SubDirB, ) {
    if ( !mkdir $Directory ) {
        $Self->True(
            0,
            "DirectoryRead() - create '$Directory': $!",
        );
    }
}

# create test files
for my $Directory ( $DirectoryWithFiles, $SubDirA, $SubDirB, ) {

    for my $Suffix (
        0 .. 5,
        'öäüßカスタマ',         # Unicode NFC
        'Второй_файл',    # Unicode NFD
        )
    {
        my $Success = $MainObject->FileWrite(
            Directory => $Directory,
            Filename  => "Example_File_$Suffix",
            Content   => \'',
        );
        $Self->True(
            $Success,
            "DirectoryRead() - create '$Directory/Example_File_$Suffix'!",
        );
    }
}

my @DirectoryReadTests = (
    {
        Name      => 'Read directory with files, \'Example_File*\' Filter',
        Filter    => 'Example_File*',
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
        ],
    },
    {
        Name      => 'Read directory with files, \'Example_File*\' Filter, recursive',
        Filter    => 'Example_File*',
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$SubDirA/Example_File_0",
            "$SubDirA/Example_File_1",
            "$SubDirA/Example_File_2",
            "$SubDirA/Example_File_3",
            "$SubDirA/Example_File_4",
            "$SubDirA/Example_File_5",
            "$SubDirA/Example_File_öäüßカスタマ",
            "$SubDirA/Example_File_Второй_файл",
            "$SubDirB/Example_File_0",
            "$SubDirB/Example_File_1",
            "$SubDirB/Example_File_2",
            "$SubDirB/Example_File_3",
            "$SubDirB/Example_File_4",
            "$SubDirB/Example_File_5",
            "$SubDirB/Example_File_öäüßカスタマ",
            "$SubDirB/Example_File_Второй_файл",

        ],
    },
    {
        Name      => 'Read directory with files, \'XX_NOTEXIST_XX\' Filter',
        Filter    => 'XX_NOTEXIST_XX',
        Directory => $DirectoryWithFiles,
        Results   => [],
    },
    {
        Name      => 'Read directory with files, \'XX_NOTEXIST_XX\' Filter, recursive',
        Filter    => 'XX_NOTEXIST_XX',
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [],
    },
    {
        Name      => 'Read directory with files, *0 *1 *2 Filters',
        Filter    => [ '*0', '*1', '*2' ],
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
        ],
    },
    {
        Name      => 'Read directory with files, *0 *1 *2 Filters, recursive',
        Filter    => [ '*0', '*1', '*2' ],
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$SubDirA/Example_File_0",
            "$SubDirA/Example_File_1",
            "$SubDirA/Example_File_2",
            "$SubDirB/Example_File_0",
            "$SubDirB/Example_File_1",
            "$SubDirB/Example_File_2",
        ],
    },
    {
        Name      => 'Read directory with files, *0 *1 *2 Filters',
        Filter    => [ '*0', '*2', '*1', '*1', '*0', '*2' ],
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_1",
        ],
    },
    {
        Name      => 'Read directory with files, no Filter',
        Filter    => '*',
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$DirectoryWithFiles/a",
            "$DirectoryWithFiles/b",
        ],
    },
    {
        Name      => 'Read directory with files, no Filter (multiple)',
        Filter    => [ '*', '*', '*' ],
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$DirectoryWithFiles/a",
            "$DirectoryWithFiles/b",
        ],
    },
    {
        Name      => 'Read directory with files, no Filter (multiple), recursive',
        Filter    => [ '*', '*', '*' ],
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$DirectoryWithFiles/a",
            "$DirectoryWithFiles/b",
            "$SubDirA/Example_File_0",
            "$SubDirA/Example_File_1",
            "$SubDirA/Example_File_2",
            "$SubDirA/Example_File_3",
            "$SubDirA/Example_File_4",
            "$SubDirA/Example_File_5",
            "$SubDirA/Example_File_öäüßカスタマ",
            "$SubDirA/Example_File_Второй_файл",
            "$SubDirB/Example_File_0",
            "$SubDirB/Example_File_1",
            "$SubDirB/Example_File_2",
            "$SubDirB/Example_File_3",
            "$SubDirB/Example_File_4",
            "$SubDirB/Example_File_5",
            "$SubDirB/Example_File_öäüßカスタマ",
            "$SubDirB/Example_File_Второй_файл",
        ],
    },
    {
        Name      => 'Read directory without files, * Filter',
        Filter    => '*',
        Directory => $DirectoryWithoutFiles,
        Results   => [],
    },
    {
        Name      => 'Read directory without files, no Filter',
        Filter    => '*',
        Directory => $DirectoryWithoutFiles,
        Results   => [],
    },
    {
        Name      => 'Directory doesn\'t exists!',
        Directory => 'THIS',
        Filter    => '*',
        Results   => [],
    },
);

for my $Test (@DirectoryReadTests) {

    my @UnicodeResults;
    for my $Result ( @{ $Test->{Results} } ) {
        push @UnicodeResults, $EncodeObject->Convert2CharsetInternal(
            Text => $Result,
            From => 'utf-8',
        );
    }
    @UnicodeResults = sort @UnicodeResults;

    my @Results = $MainObject->DirectoryRead(
        Directory => $Test->{Directory},
        Filter    => $Test->{Filter},
        Recursive => $Test->{Recursive},
    );

    is( \@Results, \@UnicodeResults, $Test->{Name} );
}

# delete needed test directories
for my $Directory ( $DirectoryWithFiles, $DirectoryWithoutFiles ) {
    if ( !rmtree( [$Directory] ) ) {
        $Self->True(
            0,
            "DirectoryRead() - delete '$Directory'",
        );
    }
}

# Dump()
my @DumpTests = (
    {
        Name             => 'Unicode dump 1',
        Source           => 'é',
        ResultDumpBinary => "\$VAR1 = 'é';\n",
        ResultDumpAscii  => '$VAR1 = "\x{e9}";' . "\n",
    },
    {
        Name             => 'Unicode dump 2',
        Source           => 'äöüßÄÖÜ€ис é í  ó',
        ResultDumpBinary => "\$VAR1 = 'äöüßÄÖÜ€ис é í  ó';\n",
        ResultDumpAscii  =>
            '$VAR1 = "\x{e4}\x{f6}\x{fc}\x{df}\x{c4}\x{d6}\x{dc}\x{20ac}\x{438}\x{441} \x{e9} \x{ed}  \x{f3}";' . "\n",
    },
    {
        Name   => 'Unicode dump 3',
        Source =>
            "\x{e4}\x{f6}\x{fc}\x{df}\x{c4}\x{d6}\x{dc}\x{20ac}\x{438}\x{441} \x{e9} \x{ed}  \x{f3}",
        ResultDumpBinary => "\$VAR1 = 'äöüßÄÖÜ€ис é í  ó';\n",
        ResultDumpAscii  =>
            '$VAR1 = "\x{e4}\x{f6}\x{fc}\x{df}\x{c4}\x{d6}\x{dc}\x{20ac}\x{438}\x{441} \x{e9} \x{ed}  \x{f3}";' . "\n",
    },
    {
        Name             => 'Unicode dump 4',
        Source           => "Mus\x{e9}e royal de l\x{2019}Arm\x{e9}e et d\x{2019}histoire militaire",
        ResultDumpBinary => "\$VAR1 = 'Musée royal de l’Armée et d’histoire militaire';\n",
        ResultDumpAscii  => '$VAR1 = "Mus\x{e9}e royal de l\x{2019}Arm\x{e9}e et d\x{2019}histoire militaire";' . "\n",
    },
    {
        Name             => 'Unicode dump 5',
        Source           => "Antonín Dvořák",
        ResultDumpBinary => "\$VAR1 = 'Antonín Dvořák';\n",
        ResultDumpAscii  => '$VAR1 = "Anton\x{ed}n Dvo\x{159}\x{e1}k";' . "\n",
    },
    {
        Name             => 'Scalar Reference',
        Source           => \1,
        ResultDumpBinary => "\$VAR1 = \\1;\n",
        ResultDumpAscii  => "\$VAR1 = \\1;\n",
    },
    {
        Name             => 'Array Reference',
        Source           => [ 1, 2 ],
        ResultDumpBinary => "\$VAR1 = [
  1,
  2
];\n",
        ResultDumpAscii => "\$VAR1 = [
  1,
  2
];\n",
    },
    {
        Name             => 'Hash Reference',
        Source           => { 1 => 2 },
        ResultDumpBinary => "\$VAR1 = {
  '1' => 2
};\n",
        ResultDumpAscii => "\$VAR1 = {
  '1' => 2
};\n",
    },
    {
        Name             => 'JSON::PP::Boolean true Reference',
        Source           => JSON::PP::true(),
        ResultDumpBinary => q|$VAR1 = bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' );
|,
        ResultDumpAscii => q|$VAR1 = bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' );
|,
    },
    {
        Name             => 'JSON::PP::Boolean false Reference',
        Source           => JSON::PP::false(),
        ResultDumpBinary => q|$VAR1 = bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' );
|,
        ResultDumpAscii => q|$VAR1 = bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' );
|,
    },
);

for my $Test (@DumpTests) {
    subtest "$Test->{Name} - Dump()" => sub {
        is(
            $MainObject->Dump( $Test->{Source} ),
            $Test->{ResultDumpBinary},
            "result (binary)"
        );
        is(
            $MainObject->Dump( $Test->{Source}, 'ascii' ),
            $Test->{ResultDumpAscii},
            "result (ascii)"
        );
    };
}

# Generate Random string tests
{
    my $Token = $MainObject->GenerateRandomString();
    my $Desc  = 'no args';

    # '0' is acceptable of For Length =>1, '00' is true already
    $Self->True(
        ( ( $Token eq '0' || $Token ) && ref $Token eq '' ),
        "GenerateRandomString - $Desc - generated",
    );

    $Self->Is(
        length $Token,
        16,
        "GenerateRandomString - $Desc - standard size is 16",
    );
}

{
    my $Token = $MainObject->GenerateRandomString( Length => 0 );
    my $Desc  = 'Length 0';

    $Self->True(
        ( ( $Token eq '0' || $Token ) && ref $Token eq '' ),
        "GenerateRandomString - $Desc - generated",
    );

    $Self->Is(
        length $Token,
        16,
        "GenerateRandomString - $Desc - standard size is 16",
    );
}

{
    my $Token = $MainObject->GenerateRandomString( Length => 1 );
    my $Desc  = 'Length 1';

    $Self->True(
        ( ( $Token eq '0' || $Token ) && ref $Token eq '' ),
        "GenerateRandomString - $Desc - generated",
    );

    $Self->Is(
        length $Token,
        1,
        "GenerateRandomString - $Desc - size is 1",
    );
}

{
    my $Token = $MainObject->GenerateRandomString( Length => 8 );
    my $Desc  = 'Length 8';

    $Self->True(
        ( ( $Token eq '0' || $Token ) && ref $Token eq '' ),
        "GenerateRandomString - $Desc - generated",
    );

    $Self->Is(
        length $Token,
        8,
        "GenerateRandomString - $Desc - size is 8",
    );
}

{
    my %Values;
    my $Seen = 0;
    COUNTER:
    for my $Counter ( 1 .. 100_000 ) {
        my $Random = $MainObject->GenerateRandomString( Length => 16 );
        if ( $Values{$Random}++ ) {
            $Seen = 1;

            last COUNTER;
        }
    }

    $Self->False( $Seen, "GenerateRandomString - no duplicates in 100k iterations" );
}

# test with custom alphabet
{
    my $NoHexChar;
    COUNTER:
    for my $Counter ( 1 .. 1000 ) {
        my $HexString = $MainObject->GenerateRandomString(
            Length     => 32,
            Dictionary => [ 0 .. 9, 'a' .. 'f' ],
        );
        if ( $HexString =~ m{[^0-9a-f]}xms ) {
            $NoHexChar = $HexString;
            last COUNTER;
        }
    }

    $Self->Is(
        $NoHexChar,
        undef,
        'Test output for hex chars in 1000 generated random strings with hex dictionary',
    );
}

# test with a stupid alphabet
{
    my $XString = $MainObject->GenerateRandomString(
        Length     => 32,
        Dictionary => [ 'x', 'x', 'x', 'x' ],
    );

    $Self->Is(
        $XString,
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        'Test with dictionary containing only x',
    );
}

# verify that irand() is not available as a method
{
    $Self->False( $MainObject->can('irand'), 'Kernel::System::Main::irand() is not supported' );

    my $RandonNumber = eval {
        $MainObject->irand(22);
    };
    my $ExceptionMatches = $@ =~ m/Can't locate object method "irand"/ ? 1 : 0;
    $Self->True( $ExceptionMatches, "Kernel::System::Main::irand() not located" );
    $Self->False( $RandonNumber, "Kernel::System::Main::irand() did not return anything" );
}

done_testing();
