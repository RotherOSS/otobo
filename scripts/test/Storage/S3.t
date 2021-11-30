# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use if $ENV{OTOBO_SYNC_WITH_S3}, 'Kernel::System::Storage::S3';

# For now test only when running under Docker,
# even though this route could also be available outside Docker.
skip_all 'not running with S3 storage' unless $ENV{OTOBO_SYNC_WITH_S3};

plan(7);

ok( $INC{'Kernel/System/Storage/S3.pm'}, 'Kernel::System::Storage::S3 was loaded' );

my $StorageS3Object = Kernel::System::Storage::S3->new();
isa_ok( $StorageS3Object, 'Kernel::System::Storage::S3' );

# expecting that ZZZAAuto.pm already exists
subtest 'ListObjects' => sub {

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

#TODO: DiscardObject
#TODO: DiscardObjects
