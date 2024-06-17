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

# Set up the test driver $Self when we are running as a standalone script.
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set config
$ConfigObject->Set(
    Key   => 'PGP',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'PGP::Options',
    Value => '--batch --no-tty --yes',
);
$ConfigObject->Set(
    Key   => 'PGP::Key::Password',
    Value => {
        '04A17B7A' => 'somepass',
        '114D1CB6' => 'somepass',
    },
);

# check if gpg is located there
if ( !-e $ConfigObject->Get('PGP::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/gpg' ) {
        $ConfigObject->Set(
            Key   => 'PGP::Bin',
            Value => '/opt/local/bin/gpg'
        );
    }

    # Try to guess using system 'which'
    else {    # try to guess
        my $GPGBin = `which gpg`;
        chomp $GPGBin;
        if ($GPGBin) {
            $ConfigObject->Set(
                Key   => 'PGP::Bin',
                Value => $GPGBin,
            );
        }
    }
}

# create local crypt object
my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

skip_all("No PGP support") unless $PGPObject;

my %Search = (
    1 => 'unittest@example.com',
    2 => 'unittest2@example.com',
    3 => 'unittest3@example.com',
);

my %Check = (
    1 => {
        Type             => 'pub',
        Identifier       => 'UnitTest <unittest@example.com>',
        Bit              => '1024',
        Key              => '38677C3B',
        KeyPrivate       => '04A17B7A',
        Created          => '2007-08-21',
        Expires          => 'never',
        Fingerprint      => '4124 DFBD CF52 D129 AB3E  3C44 1404 FBCB 3867 7C3B',
        FingerprintShort => '4124DFBDCF52D129AB3E3C441404FBCB38677C3B',
    },
    2 => {
        Type             => 'pub',
        Identifier       => 'UnitTest2 <unittest2@example.com>',
        Bit              => '1024',
        Key              => 'F0974D10',
        KeyPrivate       => '8593EAE2',
        Created          => '2007-08-21',
        Expires          => '2037-08-13',
        Fingerprint      => '36E9 9F7F AD76 6405 CBE1  BB42 F533 1A46 F097 4D10',
        FingerprintShort => '36E99F7FAD766405CBE1BB42F5331A46F0974D10',
    },
    3 => {
        Type             => 'pub',
        Identifier       => 'unit test <unittest3@example.com>',
        Bit              => '4096',
        Key              => 'E023689E',
        KeyPrivate       => '114D1CB6',
        Created          => '2015-12-16',
        Expires          => 'never',
        Fingerprint      => '8C99 1F7D CFD0 5245 8DD7  F2E3 EC9A 3128 E023 689E',
        FingerprintShort => '8C991F7DCFD052458DD7F2E3EC9A3128E023689E',
    },
);

# Because of using Test2::VO this string is a Perl string with UTF8-flag on
my $TestText = 'hello1234567890äöüÄÖÜ€';

# This is a byte array.
my $EncodedTestText = $TestText;
utf8::encode($EncodedTestText);

my $Home = $ConfigObject->Get('Home');

# delete existing keys to have a cleaned test environment
COUNT:
for my $Count ( 1 .. 3 ) {

    my ($Key) = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );

    next COUNT unless $Key;
    next COUNT unless ref $Key eq 'HASH';

    if ( $Key->{KeyPrivate} ) {
        $PGPObject->SecretKeyDelete(
            Key => $Key->{KeyPrivate},
        );
    }

    if ( $Key->{Key} ) {
        $PGPObject->PublicKeyDelete(
            Key => $Key->{Key},
        );
    }
}

# start the tests
for my $Count ( 1 .. 3 ) {
    subtest "initial tests $Count" => sub {
        my ($Key) = $PGPObject->KeySearch(
            Search => $Search{$Count},
        );
        $Self->False(
            $Key || '',
            "KeySearch()",
        );

        # get keys
        for my $Privacy ( 'Private', 'Public' ) {

            my $KeyString = $MainObject->FileRead(
                Directory => $Home . "/scripts/test/sample/Crypt/",
                Filename  => "PGP${Privacy}Key-$Count.asc",
            );
            my $Message = $PGPObject->KeyAdd(
                Key => ${$KeyString},
            );

            $Self->True(
                $Message || '',
                "KeyAdd() ($Privacy)",
            );
        }

        ($Key) = $PGPObject->KeySearch(
            Search => $Search{$Count},
        );

        $Self->True(
            $Key || '',
            "KeySearch()",
        );
        for my $ID (qw(Type Identifier Bit Key KeyPrivate Created Expires Fingerprint FingerprintShort)) {
            $Self->Is(
                $Key->{$ID} || '',
                $Check{$Count}->{$ID},
                "KeySearch() - $ID",
            );
        }

        my $PublicKeyString = $PGPObject->PublicKeyGet(
            Key => $Key->{Key},
        );
        $Self->True(
            $PublicKeyString || '',
            "PublicKeyGet()",
        );

        my $PrivateKeyString = $PGPObject->SecretKeyGet(
            Key => $Key->{KeyPrivate},
        );
        $Self->True(
            $PrivateKeyString || '',
            "SecretKeyGet()",
        );

        # crypt
        my $Crypted = $PGPObject->Crypt(
            Message => $TestText,
            Key     => $Key->{Key},
        );
        $Self->True(
            $Crypted || '',
            "Crypt()",
        );
        $Self->True(
            $Crypted =~ m{-----BEGIN PGP MESSAGE-----} && $Crypted =~ m{-----END PGP MESSAGE-----},
            "Crypt() - Data seems ok (crypted)",
        );

        # decrypt
        my %Decrypt = $PGPObject->Decrypt(
            Message => $Crypted,
        );
        utf8::decode( $Decrypt{Data} );
        $Self->True(
            $Decrypt{Successful} || '',
            "Decrypt() - Successful",
        );
        $Self->Is(
            $Decrypt{Data} || '',
            $TestText,
            "Decrypt() - Data",
        );
        $Self->Is(
            $Decrypt{KeyID} || '',
            $Check{$Count}->{KeyPrivate},
            "Decrypt() - KeyID",
        );

        # sign inline
        my $Sign = $PGPObject->Sign(
            Message => $TestText,
            Key     => $Key->{KeyPrivate},
            Type    => 'Inline'              # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "Sign() - inline",
        );

        # verify
        my %Verify = $PGPObject->Verify(
            Message => $Sign,
        );
        $Self->True(
            $Verify{Successful} || '',
            "Verify() - inline",
        );
        $Self->Is(
            $Verify{KeyID} || '',
            $Check{$Count}->{Key},
            "Verify() - inline - KeyID",
        );
        $Self->Is(
            $Verify{KeyUserID} || '',
            $Check{$Count}->{Identifier},
            "Verify() - inline - KeyUserID",
        );

        # verify failure on manipulated text
        my $ManipulatedSign = $Sign;
        $ManipulatedSign =~ s{$EncodedTestText}{garble-$EncodedTestText-garble};
        %Verify = $PGPObject->Verify(
            Message => $ManipulatedSign,
        );
        $Self->True(
            !$Verify{Successful},
            "Verify() - on manipulated text",
        );

        # sign detached
        $Sign = $PGPObject->Sign(
            Message => $TestText,
            Key     => $Key->{KeyPrivate},
            Type    => 'Detached'            # Detached|Inline
        );
        $Self->True(
            $Sign || '',
            "Sign() - detached",
        );

        # verify
        %Verify = $PGPObject->Verify(
            Message => $TestText,
            Sign    => $Sign,
        );
        $Self->True(
            $Verify{Successful} || '',
            "Verify() - detached",
        );
        $Self->Is(
            $Verify{KeyID} || '',
            $Check{$Count}->{Key},
            "Verify() - detached - KeyID",
        );
        $Self->Is(
            $Verify{KeyUserID} || '',
            $Check{$Count}->{Identifier},
            "Verify() - detached - KeyUserID",
        );

        # verify failure
        %Verify = $PGPObject->Verify(
            Message => " $TestText ",
            Sign    => $Sign,
        );
        $Self->True(
            !$Verify{Successful},
            "Verify() - detached on manipulated text",
        );

        # file checks
        for my $File (qw(xls txt doc png pdf)) {
            my $Content = $MainObject->FileRead(
                Directory => $Home . "/scripts/test/sample/Crypt/",
                Filename  => "PGP-Test1.$File",
                Mode      => 'binmode',
            );
            my $Reference = ${$Content};

            # crypt
            my $Crypted = $PGPObject->Crypt(
                Message => $Reference,
                Key     => $Key->{Key},
            );
            $Self->True(
                $Crypted || '',
                "Crypt()",
            );
            $Self->True(
                $Crypted =~ m{-----BEGIN PGP MESSAGE-----} && $Crypted =~ m{-----END PGP MESSAGE-----},
                "Crypt() - Data seems ok (crypted)",
            );

            # decrypt
            my %Decrypt = $PGPObject->Decrypt(
                Message => $Crypted,
            );
            utf8::decode( $Decrypt{Data} );
            $Self->True(
                $Decrypt{Successful} || '',
                "Decrypt() - Successful",
            );
            $Self->True(
                $Decrypt{Data} eq ${$Content},
                "Decrypt() - Data",
            );
            $Self->Is(
                $Decrypt{KeyID} || '',
                $Check{$Count}->{KeyPrivate},
                "Decrypt - KeyID",
            );

            # sign inline
            my $Sign = $PGPObject->Sign(
                Message => $Reference,
                Key     => $Key->{KeyPrivate},
                Type    => 'Inline'              # Detached|Inline
            );
            $Self->True(
                $Sign || '',
                "Sign() - inline .$File",
            );

            # verify
            my %Verify = $PGPObject->Verify(
                Message => $Sign,
            );
            $Self->True(
                $Verify{Successful} || '',
                "Verify() - inline .$File",
            );
            $Self->Is(
                $Verify{KeyID} || '',
                $Check{$Count}->{Key},
                "Verify() - inline .$File - KeyID",
            );
            $Self->Is(
                $Verify{KeyUserID} || '',
                $Check{$Count}->{Identifier},
                "Verify() - inline .$File - KeyUserID",
            );

            # sign detached
            $Sign = $PGPObject->Sign(
                Message => $Reference,
                Key     => $Key->{KeyPrivate},
                Type    => 'Detached'            # Detached|Inline
            );
            $Self->True(
                $Sign || '',
                "Sign() - detached .$File",
            );

            # verify
            %Verify = $PGPObject->Verify(
                Message => ${$Content},
                Sign    => $Sign,
            );
            $Self->True(
                $Verify{Successful} || '',
                "Verify() - detached .$File",
            );
            $Self->Is(
                $Verify{KeyID} || '',
                $Check{$Count}->{Key},
                "Verify() - detached .$File - KeyID",
            );
            $Self->Is(
                $Verify{KeyUserID} || '',
                $Check{$Count}->{Identifier},
                "Verify() - detached .$File - KeyUserID",
            );
        }

        # Crypt() should still work if asked to crypt a UTF8-string (instead of ISO-string or
        # binary octets) - automatic conversion to a byte string should take place.
        my $UTF8Text = $TestText;
        utf8::upgrade($UTF8Text);
        $Self->True(
            utf8::is_utf8($UTF8Text),
            "Should now have a UTF8-string",
        );
        $Crypted = $PGPObject->Crypt(
            Message => $UTF8Text,
            Key     => $Key->{Key},
        );
        $Self->True(
            $Crypted || '',
            "Crypt() should still work if given a UTF8-string",
        );
        $Self->True(
            $Crypted =~ m{-----BEGIN PGP MESSAGE-----} && $Crypted =~ m{-----END PGP MESSAGE-----},
            "Crypt() - Data seems ok (crypted)",
        );

        # decrypt
        %Decrypt = $PGPObject->Decrypt(
            Message => $Crypted,
        );

        # we have crypted an utf8-string, but we will get back a byte string. In order to compare it,
        # we need to decode it into utf8:
        utf8::decode( $Decrypt{Data} );

        $Self->True(
            $Decrypt{Successful} || '',
            "Decrypt() - Successful",
        );
        $Self->Is(
            $Decrypt{Data},
            $UTF8Text,
            "Decrypt() - Data",
        );
    }
}

# check signing for different digest types
# only key 3 currently supports all those types
for my $Count (3) {

    subtest 'key 3' => sub {

        my ($Key) = $PGPObject->KeySearch(
            Search => $Search{$Count},
        );

        my %DeprecatedDigestTypes = (
            md5 => 1,
        );
        for my $DigestPreference (qw(md5 sha1 sha224 sha256 sha384 sha512)) {

            # set digest type
            $ConfigObject->Set(
                Key   => 'PGP::Options::DigestPreference',
                Value => $DigestPreference,
            );

            # sign inline
            my $Sign = $PGPObject->Sign(
                Message => $TestText,
                Key     => $Key->{KeyPrivate},
                Type    => 'Inline'              # Detached|Inline
            );
            if ( $DeprecatedDigestTypes{$DigestPreference} ) {
                $Self->False(
                    $Sign || '',
                    "Sign() using $DigestPreference fail - inline",
                );
            }
            else {
                $Self->True(
                    $Sign || '',
                    "Sign() using $DigestPreference - inline",
                );

                # verify used digest algtorithm
                my $DigestAlgorithm;
                $DigestAlgorithm = lc $1 if $Sign =~ m{ \n Hash: [ ] ([^\n]+) \n }xms;
                $Self->Is(
                    $DigestAlgorithm || '',
                    $DigestPreference,
                    "Sign() - check used digest algorithm",
                );

                # verify
                my %Verify = $PGPObject->Verify(
                    Message => $Sign,
                );

                $Self->True(
                    $Verify{Successful} || '',
                    "Verify() - inline",
                );
                $Self->Is(
                    $Verify{KeyID} || '',
                    $Check{$Count}->{Key},
                    "Verify() - inline - KeyID",
                );
                $Self->Is(
                    $Verify{KeyUserID} || '',
                    $Check{$Count}->{Identifier},
                    "Verify() - inline - KeyUserID",
                );

                # verify failure on manipulated text
                my $ManipulatedSign = $Sign;
                $ManipulatedSign =~ s{$EncodedTestText}{garble-$EncodedTestText-garble};
                %Verify = $PGPObject->Verify(
                    Message => $ManipulatedSign,
                );
                $Self->True(
                    !$Verify{Successful},
                    "Verify() - on manipulated text",
                );
            }

            # sign detached
            $Sign = $PGPObject->Sign(
                Message => $TestText,
                Key     => $Key->{KeyPrivate},
                Type    => 'Detached'            # Detached|Inline
            );
            if ( $DeprecatedDigestTypes{$DigestPreference} ) {
                $Self->False(
                    $Sign || '',
                    "Sign() using $DigestPreference fail - detached",
                );
            }
            else {
                $Self->True(
                    $Sign || '',
                    "Sign() using $DigestPreference - detached",
                );

                # verify
                my %Verify = $PGPObject->Verify(
                    Message => $TestText,
                    Sign    => $Sign,
                );
                $Self->True(
                    $Verify{Successful} || '',
                    "Verify() - detached",
                );
                $Self->Is(
                    $Verify{KeyID} || '',
                    $Check{$Count}->{Key},
                    "Verify() - detached - KeyID",
                );
                $Self->Is(
                    $Verify{KeyUserID} || '',
                    $Check{$Count}->{Identifier},
                    "Verify() - detached - KeyUserID",
                );

                # verify failure
                %Verify = $PGPObject->Verify(
                    Message => " $TestText ",
                    Sign    => $Sign,
                );
                $Self->True(
                    !$Verify{Successful},
                    "Verify() - detached on manipulated text",
                );
            }
        }
    }
}

# check for expired and revoked PGP keys
{

    # expired key
    my $Search = 'testingexpired@example.com';

    # get expired key
    my $KeyString = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-Expired.asc',
    );

    # add the key to the keyring
    $PGPObject->KeyAdd( Key => ${$KeyString} );

    # search for expired key and wait for expired status
    my ($Key) = $PGPObject->KeySearch(
        Search => $Search,
    );

    $Self->Is(
        $Key->{Status},
        'expired',
        'Check for expired pgp key',
    );

    # revoked key

    $Search = 'testingkey@test.com';

    # get key
    $KeyString = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-ToRevoke.asc',
    );

    # add the key to the keyring
    $PGPObject->KeyAdd( Key => ${$KeyString} );

    # get key
    $KeyString = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Crypt/',
        Filename  => 'PGPPublicKey-RevokeCert.asc',
    );

    # add the key to the keyring
    $PGPObject->KeyAdd( Key => ${$KeyString} );

    # search for revoked key and wait for revoked status
    ($Key) = $PGPObject->KeySearch(
        Search => $Search,
    );

    $Self->Is(
        $Key->{Status},
        'revoked',
        'Check for revoked pgp key',
    );
}

# delete keys
for my $Count ( 1 .. 3 ) {
    subtest "delete key $Count" => sub {
        my ($Key) = $PGPObject->KeySearch(
            Search => $Search{$Count},
        );
        $Self->True(
            $Key || '',
            "KeySearch()",
        );
        my $DeleteSecretKey = $PGPObject->SecretKeyDelete(
            Key => $Key->{KeyPrivate},
        );
        $Self->True(
            $DeleteSecretKey || '',
            "SecretKeyDelete()",
        );

        my $DeletePublicKey = $PGPObject->PublicKeyDelete(
            Key => $Key->{Key},
        );
        $Self->True(
            $DeletePublicKey || '',
            "PublicKeyDelete()",
        );

        ($Key) = $PGPObject->KeySearch(
            Search => $Search{$Count},
        );
        $Self->False(
            $Key || '',
            "KeySearch()",
        );
    }
}

# cleanup is done by RestoreDatabase

done_testing();
