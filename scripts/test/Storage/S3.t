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

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM
use Kernel::Config;

# Testing S3 backend only the S3 backend is active.
{
    my $ClearConfigObject = Kernel::Config->new( Level => 'Clear' );
    my $S3Active          = $ClearConfigObject->Get('Storage::S3::Active');

    skip_all 'not running with S3 storage' unless $S3Active;
}

plan(24);

my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');
isa_ok( $StorageS3Object, 'Kernel::System::Storage::S3' );
ok( $INC{'Kernel/System/Storage/S3.pm'}, 'Kernel::System::Storage::S3 was loaded' );

# expecting that ZZZAAuto.pm already exists
subtest 'ListObjects() ZZZAAuto.pm' => sub {

    # run a blocking GET request to S3
    my $FilesPrefix     = join '/', 'Kernel', 'Config', 'Files';
    my %Name2Properties = $StorageS3Object->ListObjects(
        Prefix => "$FilesPrefix/",
    );

    ok( exists $Name2Properties{'ZZZAAuto.pm'}, 'ZZZAAuto.pm found' );

    my $Properties = $Name2Properties{'ZZZAAuto.pm'};

    ref_ok( $Properties, 'HASH' );
    ok( $Properties->{Size},  'got Size for ZZZAAuto.pm' );
    ok( $Properties->{Mtime}, 'got Mtime for ZZZAAuto.pm' );
    is( $Properties->{Key}, "OTOBO/$FilesPrefix/ZZZAAuto.pm", 'Key for ZZZAAuto.pm' );
};

subtest 'ListObjects() with Delimiter' => sub {

    # store two objects and process the headers of the two objects
    my $Prefix = join '/', 'test', 'Storage', 'S3', 'sub1', 'sub2', 'panda_bear';
    my %ExpectedSize;

    # panda
    {
        my $Content = <<'END_SAMPLE';
uni panda
🐼 - U+1F43C - PANDA FACE
END_SAMPLE
        $ExpectedSize{'uni_panda.txt'} = bytes::length($Content);
        my $Key = join '/', $Prefix, 'uni_panda.txt';
        my $WriteSuccess = $StorageS3Object->StoreObject(
            Key     => $Key,
            Content => $Content,
            Headers => { 'Content-Type' => 'text/plain' },
        );
        ok( $WriteSuccess, 'writing succeeded' );
    }

    # bear
    {
        my $Content = <<'END_SAMPLE';
uni bear
🐻 - U+1F43B - BEAR FACE
🧸 - U+1F9F8 - TEDDY BEAR
END_SAMPLE
        $ExpectedSize{'uni_bear.txt'} = bytes::length($Content);
        my $Key = join '/', $Prefix, 'uni_bear.txt';
        my $WriteSuccess = $StorageS3Object->StoreObject(
            Key     => $Key,
            Content => $Content,
            Headers => { 'Content-Type' => 'text/plain' },
        );
        ok( $WriteSuccess, 'writing succeeded' );
    }

    {
        my %Name2Properties = $StorageS3Object->ListObjects(
            Prefix => join( '/', 'test', 'Storage', 'S3', 'sub1', '' ),
        );
        is( [ keys %Name2Properties ], [], 'delimeter after sub2' );
    }

    # test 'non-occuring delimiter'
    # no need to be extravagant here, choose a non-occuring delimiter from the list of safe characters in
    # https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-keys.html
    {
        my %Name2Properties = $StorageS3Object->ListObjects(
            Prefix    => join( '/', 'test', 'Storage', 'S3', 'sub1', '' ),
            Delimiter => ')',
        );
        is(
            [ sort keys %Name2Properties ],
            [ 'sub2/panda_bear/uni_bear.txt', 'sub2/panda_bear/uni_panda.txt' ],
            'non-occuring delimiter: closing parens'
        );
    }

    {
        my %Name2Properties = $StorageS3Object->ListObjects(
            Prefix    => join( '/', 'test', 'Storage', 'S3', 'sub1', '' ),
            Delimiter => '',
        );
        is(
            [ sort keys %Name2Properties ],
            [ 'sub2/panda_bear/uni_bear.txt', 'sub2/panda_bear/uni_panda.txt' ],
            'empty delimiter'
        );
    }
};

subtest 'Store and retrieve object' => sub {
    my $Content = <<'END_SAMPLE';
uni book
📕 - U+1F4D5 - CLOSED BOOK
📖 - U+1F4D6 - OPEN BOOK
📗 - U+1F4D7 - GREEN BOOK
📘 - U+1F4D8 - BLUE BOOK
📙 - U+1F4D9 - ORANGE BOOK
END_SAMPLE

    my $Key = join '/', 'test', 'Storage', 'S3', 'uni_book.txt';
    my $WriteSuccess = $StorageS3Object->StoreObject(
        Key     => $Key,
        Content => $Content,
        Headers => { 'Content-Type' => 'text/plain' },
    );

    ok( $WriteSuccess, 'writing succeeded' );

    my %Retrieved = $StorageS3Object->RetrieveObject(
        Key => $Key,
    );

    # RetrieveObject() does not consider the read in content as UTF-8, as the encoding is usually not known.
    # Here we decode explicitly, as we know that UTF-8 encoded string was stored.
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Retrieved{Content} );

    is( $Retrieved{FilesizeRaw}, bytes::length($Content), 'size in bytes' );
    is( $Retrieved{Content},     $Content,                'Content matches' );
    is( $Retrieved{ContentType}, 'text/plain',            'Content type matches' );
};

# Test some more cleaned up file names.
# This is important for the article storage.
{
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $Prefix     = join '/', 'test', 'Storage', 'S3', 'FilenameCleanUp', '';
    my $Content    = <<'END_CONTENT';
uni file
 - U+0001C - INFORMATION SEPARATOR FOUR
␜ - U+0241C - SYMBOL FOR FILE SEPARATOR
📁 - U+1F4C1 - FILE FOLDER
📂 - U+1F4C2 - OPEN FILE FOLDER
🗃 - U+1F5C3 - CARD FILE BOX
🗄 - U+1F5C4 - FILE CABINET
END_CONTENT

    my @Tests = (
        {
            Name         => 'greek with leading snowman',
            FilenameOrig => '⛄Στους υπολογιστές, το διεθνές πρότυπο',
        },
        {
            Name         => 'Perl package name',
            FilenameOrig => 'Just::Another::Perl::Package',
        },
        {
            Name         => 'nonword hash',
            FilenameOrig => 'two_hashes_#_#',
        },
        {
            Name         => 'nonword minus',
            FilenameOrig => 'decrement: --',
        },
        {
            Name         => 'nonword plus',
            FilenameOrig => 'increment: ++',
            Skip         => 'MinIO has problems with + in object key',
        },
        {
            Name         => 'nonword underscore',
            FilenameOrig => '_cursive_',
        },
        {
            Name         => 'enclosed alphanumerics i',
            FilenameOrig => 'i ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯',
        },
        {
            Name         => 'enclosed alphanumerics ii',
            FilenameOrig => 'ii ⑰ ⑱ ⑲ ⑳ ⑴ ⑵ ⑶ ⑷ ⑸ ⑹ ⑺ ⑻ ⑼ ⑽ ⑾ ⑿',
        },
        {
            Name         => 'enclosed alphanumerics iii',
            FilenameOrig => 'iii ⒀ ⒁ ⒂ ⒃ ⒄ ⒅ ⒆ ⒇ ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏',
        },
        {
            Name         => 'enclosed alphanumerics iv',
            FilenameOrig => 'iv ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗ ⒘ ⒙ ⒚ ⒛ ⒜ ⒝ ⒞ ⒟',
        },
        {
            Name         => 'enclosed alphanumerics v',
            FilenameOrig => 'v ⒠ ⒡ ⒢ ⒣ ⒤ ⒥ ⒦ ⒧ ⒨ ⒩ ⒪ ⒫ ⒬ ⒭ ⒮ ⒯',
        },
        {
            Name         => 'enclosed alphanumerics vi',
            FilenameOrig => 'vi ⒰ ⒱ ⒲ ⒳ ⒴ ⒵ Ⓐ Ⓑ Ⓒ Ⓓ Ⓔ Ⓕ Ⓖ Ⓗ Ⓘ Ⓙ',
        },
        {
            Name         => 'enclosed alphanumerics vii',
            FilenameOrig => 'vii Ⓚ Ⓛ Ⓜ Ⓝ Ⓞ Ⓟ Ⓠ Ⓡ Ⓢ Ⓣ Ⓤ Ⓥ Ⓦ Ⓧ Ⓨ Ⓩ',
        },
        {
            Name         => 'enclosed alphanumerics viii',
            FilenameOrig => 'viii ⓐ ⓑ ⓒ ⓓ ⓔ ⓕ ⓖ ⓗ ⓘ ⓙ ⓚ ⓛ ⓜ ⓝ ⓞ ⓟ',
        },
        {
            Name         => 'enclosed alphanumerics ix',
            FilenameOrig => 'ix ⓠ ⓡ ⓢ ⓣ ⓤ ⓥ ⓦ ⓧ ⓨ ⓩ ⓪ ⓫ ⓬ ⓭ ⓮ ⓯',
        },
        {
            Name         => 'enclosed alphanumerics x',
            FilenameOrig => 'x ⓰ ⓱ ⓲ ⓳ ⓴ ⓵ ⓶ ⓷ ⓸ ⓹ ⓺ ⓻ ⓼ ⓽ ⓾ ⓿ ',
        },
    );

    TEST:
    for my $Test (@Tests) {

        next TEST if $Test->{Skip};

        subtest "FilenameCleanUP - $Test->{Name}" => sub {

            my $Filename = $MainObject->FilenameCleanUp(
                Filename => $Test->{FilenameOrig},
                Type     => $Test->{Type},
            );

            like(
                $Filename,
                qr{^[\w\-+.\#_]+$},
                "'$Test->{FilenameOrig}' -> '$Filename' only has the expected characters",
            );

            my $Key          = $Prefix . $Filename;
            my $WriteSuccess = $StorageS3Object->StoreObject(
                Key     => $Key,
                Content => $Content,
                Headers => { 'Content-Type' => 'text/plain' },
            );

            ok( $WriteSuccess, 'writing succeeded' );

            my %Retrieved = $StorageS3Object->RetrieveObject(
                Key => $Key,
            );

            # RetrieveObject() does not consider the read in content as UTF-8, as the encoding is usually not known.
            # Here we decode explicitly, as we know that UTF-8 encoded string was stored.
            $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Retrieved{Content} );

            is( $Retrieved{FilesizeRaw}, bytes::length($Content), 'size in bytes' );
            is( $Retrieved{Content},     $Content,                'Content matches' );
            is( $Retrieved{ContentType}, 'text/plain',            'Content type matches' );
        };
    }
}

subtest 'SaveObjectToFile()' => sub {
    my $Content = <<'END_SAMPLE';
uni snow
⛄ - U+026C4 - SNOWMAN WITHOUT SNOW
🌨 - U+1F328 - CLOUD WITH SNOW
🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN
END_SAMPLE

    my $Key = join '/', 'test', 'Storage', 'S3', 'uni_snow.txt';
    my $WriteSuccess = $StorageS3Object->StoreObject(
        Key     => $Key,
        Content => $Content,
        Headers => { 'Content-Type' => 'text/plain' },
    );

    ok( $WriteSuccess, 'writing succeeded' );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TempDir      = $ConfigObject->Get('TempDir');
    my $Location     = "$TempDir/uni_snow.txt";
    unlink $Location;
    ok( !-e $Location, "$Location does not exist before SaveObjectToFile()" );

    my $Saved = $StorageS3Object->SaveObjectToFile(
        Key      => $Key,
        Location => $Location,
    );
    ok( $Saved, 1, 'object was saved' );
    ok( -e $Location, "$Location exists after SaveObjectToFile()" );
    is( -s $Location, bytes::length($Content), 'size in bytes of saved file' );

    my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');
    my $FileContent = $MainObject->FileRead(
        Location => $Location,
    )->$*;

    # the read in content is UTF-8 encoded
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$FileContent );
    is( bytes::length($FileContent), bytes::length($Content), 'size in bytes' );
    is( length($FileContent),        length($Content),        'size in code points' );
    ok( bytes::length($FileContent) > length($Content), 'there are multi byte chars' );
    is( $FileContent, $Content, 'Content matches' );
};

subtest 'ObjectExists' => sub {
    my $Content = <<'END_SAMPLE';
uni omicron
Ό - U+0038C - GREEK CAPITAL LETTER OMICRON WITH TONOS
Ο - U+0039F - GREEK CAPITAL LETTER OMICRON
ο - U+003BF - GREEK SMALL LETTER OMICRON
ό - U+003CC - GREEK SMALL LETTER OMICRON WITH TONOS
ὀ - U+01F40 - GREEK SMALL LETTER OMICRON WITH PSILI
ὁ - U+01F41 - GREEK SMALL LETTER OMICRON WITH DASIA
ὂ - U+01F42 - GREEK SMALL LETTER OMICRON WITH PSILI AND VARIA
ὃ - U+01F43 - GREEK SMALL LETTER OMICRON WITH DASIA AND VARIA
ὄ - U+01F44 - GREEK SMALL LETTER OMICRON WITH PSILI AND OXIA
ὅ - U+01F45 - GREEK SMALL LETTER OMICRON WITH DASIA AND OXIA
Ὀ - U+01F48 - GREEK CAPITAL LETTER OMICRON WITH PSILI
Ὁ - U+01F49 - GREEK CAPITAL LETTER OMICRON WITH DASIA
Ὂ - U+01F4A - GREEK CAPITAL LETTER OMICRON WITH PSILI AND VARIA
Ὃ - U+01F4B - GREEK CAPITAL LETTER OMICRON WITH DASIA AND VARIA
Ὄ - U+01F4C - GREEK CAPITAL LETTER OMICRON WITH PSILI AND OXIA
Ὅ - U+01F4D - GREEK CAPITAL LETTER OMICRON WITH DASIA AND OXIA
ὸ - U+01F78 - GREEK SMALL LETTER OMICRON WITH VARIA
ό - U+01F79 - GREEK SMALL LETTER OMICRON WITH OXIA
Ὸ - U+01FF8 - GREEK CAPITAL LETTER OMICRON WITH VARIA
Ό - U+01FF9 - GREEK CAPITAL LETTER OMICRON WITH OXIA
𝚶 - U+1D6B6 - MATHEMATICAL BOLD CAPITAL OMICRON
𝛐 - U+1D6D0 - MATHEMATICAL BOLD SMALL OMICRON
𝛰 - U+1D6F0 - MATHEMATICAL ITALIC CAPITAL OMICRON
𝜊 - U+1D70A - MATHEMATICAL ITALIC SMALL OMICRON
𝜪 - U+1D72A - MATHEMATICAL BOLD ITALIC CAPITAL OMICRON
𝝄 - U+1D744 - MATHEMATICAL BOLD ITALIC SMALL OMICRON
𝝤 - U+1D764 - MATHEMATICAL SANS-SERIF BOLD CAPITAL OMICRON
𝝾 - U+1D77E - MATHEMATICAL SANS-SERIF BOLD SMALL OMICRON
𝞞 - U+1D79E - MATHEMATICAL SANS-SERIF BOLD ITALIC CAPITAL OMICRON
𝞸 - U+1D7B8 - MATHEMATICAL SANS-SERIF BOLD ITALIC SMALL OMICRON
END_SAMPLE

    my $Key = join '/', 'test', 'Storage', 'S3', 'uni_omicron.txt';
    my $WriteSuccess = $StorageS3Object->StoreObject(
        Key     => $Key,
        Content => $Content,
        Headers => { 'Content-Type' => 'text/plain' },
    );

    ok( $WriteSuccess, 'writing succeeded' );

    my $FoundExisting = $StorageS3Object->ObjectExists(
        Key => $Key,
    );
    is( $FoundExisting, 1, 'found uni_omicron.txt' );

    my $FoundNonExisting = $StorageS3Object->ObjectExists(
        Key => $Key . '.non_existing',
    );
    is( $FoundNonExisting, '', 'did not find uni_omicron.txt.non_existing' );
};

subtest 'ProcessHeaders' => sub {

    # store two objects and process the headers of the two objects
    my $Prefix = join '/', 'test', 'Storage', 'S3', 'panda_bear';
    my %ExpectedSize;

    # panda
    {
        my $Content = <<'END_SAMPLE';
uni panda
🐼 - U+1F43C - PANDA FACE
END_SAMPLE
        $ExpectedSize{'uni_panda.txt'} = bytes::length($Content);
        my $Key = join '/', $Prefix, 'uni_panda.txt';
        my $WriteSuccess = $StorageS3Object->StoreObject(
            Key     => $Key,
            Content => $Content,
            Headers => { 'Content-Type' => 'text/plain' },
        );
        ok( $WriteSuccess, 'writing succeeded' );
    }

    # bear
    {
        my $Content = <<'END_SAMPLE';
uni bear
🐻 - U+1F43B - BEAR FACE
🧸 - U+1F9F8 - TEDDY BEAR
END_SAMPLE
        $ExpectedSize{'uni_bear.txt'} = bytes::length($Content);
        my $Key = join '/', $Prefix, 'uni_bear.txt';
        my $WriteSuccess = $StorageS3Object->StoreObject(
            Key     => $Key,
            Content => $Content,
            Headers => { 'Content-Type' => 'text/plain' },
        );
        ok( $WriteSuccess, 'writing succeeded' );
    }

    my %FoundSize;
    $StorageS3Object->ProcessHeaders(
        Prefix    => $Prefix,
        Filenames => [ keys %ExpectedSize ],
        Callback  => sub {
            my ($FinishedTransaction) = @_;

            # extract and store the file size
            my $Filename    = $FinishedTransaction->req->url->path->parts->[-1];
            my $FilesizeRaw = $FinishedTransaction->res->headers->content_length;
            $FoundSize{$Filename} = $FilesizeRaw;
        },
    );

    is( \%FoundSize, \%ExpectedSize, 'sizes match' );
};

subtest 'DiscardObject() and DiscardObjects()' => sub {

    # store two objects and process the headers of the two objects
    my $Prefix     = join '/', 'test', 'Storage', 'S3', 'greek_alphabet';
    my $MtimeRegex = qr/^ \d+ (?:\.\d{1,3})? $/x;    # 1653750544.2 is also possible

    # set up test content
    my %Alphabet = ( 'uni_alpha.txt', <<'EOT', 'uni_beta.txt', <<'EOT', 'uni_gamma', <<'EOT', 'uni_delta.txt', <<'EOT' );
uni alpha
ɑ - U+00251 - LATIN SMALL LETTER ALPHA
ɒ - U+00252 - LATIN SMALL LETTER TURNED ALPHA
Ά - U+00386 - GREEK CAPITAL LETTER ALPHA WITH TONOS
Α - U+00391 - GREEK CAPITAL LETTER ALPHA
ά - U+003AC - GREEK SMALL LETTER ALPHA WITH TONOS
α - U+003B1 - GREEK SMALL LETTER ALPHA
ᵅ - U+01D45 - MODIFIER LETTER SMALL ALPHA
ᶐ - U+01D90 - LATIN SMALL LETTER ALPHA WITH RETROFLEX HOOK
ᶛ - U+01D9B - MODIFIER LETTER SMALL TURNED ALPHA
EOT
uni beta
Β - U+00392 - GREEK CAPITAL LETTER BETA
β - U+003B2 - GREEK SMALL LETTER BETA
ϐ - U+003D0 - GREEK BETA SYMBOL
ᵝ - U+01D5D - MODIFIER LETTER SMALL BETA
ᵦ - U+01D66 - GREEK SUBSCRIPT SMALL LETTER BETA
EOT
uni gamma
Ɣ - U+00194 - LATIN CAPITAL LETTER GAMMA
ɣ - U+00263 - LATIN SMALL LETTER GAMMA
ˠ - U+002E0 - MODIFIER LETTER SMALL GAMMA
Γ - U+00393 - GREEK CAPITAL LETTER GAMMA
γ - U+003B3 - GREEK SMALL LETTER GAMMA
ᴦ - U+01D26 - GREEK LETTER SMALL CAPITAL GAMMA
ᵞ - U+01D5E - MODIFIER LETTER SMALL GREEK GAMMA
ᵧ - U+01D67 - GREEK SUBSCRIPT SMALL LETTER GAMMA
ℽ - U+0213D - DOUBLE-STRUCK SMALL GAMMA
ℾ - U+0213E - DOUBLE-STRUCK CAPITAL GAMMA
Ⲅ - U+02C84 - COPTIC CAPITAL LETTER GAMMA
ⲅ - U+02C85 - COPTIC SMALL LETTER GAMMA
𝚪 - U+1D6AA - MATHEMATICAL BOLD CAPITAL GAMMA
𝛄 - U+1D6C4 - MATHEMATICAL BOLD SMALL GAMMA
𝛤 - U+1D6E4 - MATHEMATICAL ITALIC CAPITAL GAMMA
𝛾 - U+1D6FE - MATHEMATICAL ITALIC SMALL GAMMA
𝜞 - U+1D71E - MATHEMATICAL BOLD ITALIC CAPITAL GAMMA
𝜸 - U+1D738 - MATHEMATICAL BOLD ITALIC SMALL GAMMA
𝝘 - U+1D758 - MATHEMATICAL SANS-SERIF BOLD CAPITAL GAMMA
𝝲 - U+1D772 - MATHEMATICAL SANS-SERIF BOLD SMALL GAMMA
𝞒 - U+1D792 - MATHEMATICAL SANS-SERIF BOLD ITALIC CAPITAL GAMMA
𝞬 - U+1D7AC - MATHEMATICAL SANS-SERIF BOLD ITALIC SMALL GAMMA
EOT
uni delta
ƍ - U+0018D - LATIN SMALL LETTER TURNED DELTA
Δ - U+00394 - GREEK CAPITAL LETTER DELTA
δ - U+003B4 - GREEK SMALL LETTER DELTA
ᵟ - U+01D5F - MODIFIER LETTER SMALL DELTA
ẟ - U+01E9F - LATIN SMALL LETTER DELTA
≜ - U+0225C - DELTA EQUAL TO
⍋ - U+0234B - APL FUNCTIONAL SYMBOL DELTA STILE
⍍ - U+0234D - APL FUNCTIONAL SYMBOL QUAD DELTA
⍙ - U+02359 - APL FUNCTIONAL SYMBOL DELTA UNDERBAR
𐎄 - U+10384 - UGARITIC LETTER DELTA
𝚫 - U+1D6AB - MATHEMATICAL BOLD CAPITAL DELTA
𝛅 - U+1D6C5 - MATHEMATICAL BOLD SMALL DELTA
𝛥 - U+1D6E5 - MATHEMATICAL ITALIC CAPITAL DELTA
𝛿 - U+1D6FF - MATHEMATICAL ITALIC SMALL DELTA
𝜟 - U+1D71F - MATHEMATICAL BOLD ITALIC CAPITAL DELTA
𝜹 - U+1D739 - MATHEMATICAL BOLD ITALIC SMALL DELTA
𝝙 - U+1D759 - MATHEMATICAL SANS-SERIF BOLD CAPITAL DELTA
𝝳 - U+1D773 - MATHEMATICAL SANS-SERIF BOLD SMALL DELTA
𝞓 - U+1D793 - MATHEMATICAL SANS-SERIF BOLD ITALIC CAPITAL DELTA
𝞭 - U+1D7AD - MATHEMATICAL SANS-SERIF BOLD ITALIC SMALL DELTA
EOT

    # submit test content to S3
    for my $Filename ( sort keys %Alphabet ) {

        my $Key = join '/', $Prefix, $Filename;
        my $WriteSuccess = $StorageS3Object->StoreObject(
            Key     => $Key,
            Content => $Alphabet{$Filename},
            Headers => { 'Content-Type' => 'text/plain' },
        );
        ok( $WriteSuccess, "writing $Filename succeeded" );
    }

    # check the submission
    my %Name2Properties1 = $StorageS3Object->ListObjects(
        Prefix => "$Prefix/",
    );
    like(
        \%Name2Properties1,
        {
            'uni_delta.txt' => {
                'Size'  => '1002',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_delta.txt",
            },
            'uni_beta.txt' => {
                'Size'  => '215',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_beta.txt"
            },
            'uni_alpha.txt' => {
                'Size'  => '439',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_alpha.txt",
            },
            'uni_gamma' => {
                'Size'  => '1095',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_gamma",
            }
        },
        'all files'
    );

    # discard uni_alpha.txt
    my $DiscardAlphaSuccess = $StorageS3Object->DiscardObject(
        Key => "$Prefix/uni_alpha.txt"
    );
    is( $DiscardAlphaSuccess, 1, 'uni_alpha.txt discarded' );

    my $DiscardNonExistingSuccess = $StorageS3Object->DiscardObject(
        Key => "$Prefix/uni_alpha.txt"
    );
    is( $DiscardNonExistingSuccess, 1, 'uni_alpha.txt was already discarded, still successfull' );

    my %Name2Properties2 = $StorageS3Object->ListObjects(
        Prefix => "$Prefix/",
    );
    like(
        \%Name2Properties1,
        {
            'uni_delta.txt' => {
                'Size'  => '1002',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_delta.txt",
            },
            'uni_beta.txt' => {
                'Size'  => '215',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_beta.txt"
            },
            'uni_gamma' => {
                'Size'  => '1095',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_gamma",
            }
        },
        'without uni_alpha.txt'
    );

    # discard uni_beta.txt and uni_gamma.txt
    my $DiscardAllButDeltaSuccess = $StorageS3Object->DiscardObjects(
        Prefix => "$Prefix/",
        Keep   => qr/delta/,
    );
    is( $DiscardAllButDeltaSuccess, 1, 'two more files discarded' );

    my %Name2Properties3 = $StorageS3Object->ListObjects(
        Prefix => "$Prefix/",
    );
    like(
        \%Name2Properties3,
        {
            'uni_delta.txt' => {
                'Size'  => '1002',
                'Mtime' => $MtimeRegex,
                'Key'   => "OTOBO/test/Storage/S3/greek_alphabet/uni_delta.txt",
            },
        },
        'all but uni_delta.txt discarded'
    );

    my $DiscardDeltaSuccess = $StorageS3Object->DiscardObjects(
        Prefix      => "test/Stor",
        DiscardOnly => qr{delt},
        Delimiter   => '',
    );
    is( $DiscardDeltaSuccess, 1, 'uni_delta discarded' );

    my %Name2Properties4 = $StorageS3Object->ListObjects(
        Prefix => "$Prefix/",
    );
    is( \%Name2Properties4, {}, 'all discarded' );
};
