#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use JSON;
use Path::Class qw(file);
use Data::Dumper;
use Time::Piece;

# OTOBO modules

my $ExpireInDays = 365;

my %TestCases = (
    1 => 'unittest@example.org',
    2 => 'unittest2@example.org',
    3 => 'unittest3@example.org',
    4 => 'unittest_expired@example.org',
);

my %Passwords = (
    1 => 'a passphrase',
    2 => 'anotherpassphrase',
    3 => 'a passphrase',
    4 => 'a passphrase',
);

my $JSON = {};

for my $ID ( 1 .. 3 ) {

    my $Email = $TestCases{$ID};

    print "Email: $Email\n";

    my $KeyOut   = "scripts/test/sample/SMIME/SMIMEPrivateKey-$ID.asc";
    my $CertOut  = "scripts/test/sample/SMIME/SMIMECertificate-$ID.asc";
    my $Subject  = "/C=DE/ST=Bayern/L=Straubing/O=OTOBO/CN=unittest/emailAddress=$Email";
    my $Password = $Passwords{$ID};

    # add SubjectAltNames in special case 3
    my $SubjectAltName = '';
    if ( $ID == 3 ) {
        $SubjectAltName = ' -addext "subjectAltName = email:unittest4@example.org, email:unittest5@example.org" ';
        $Email .= ', unittest4@example.org, unittest5@example.org';
    }

    # the openssl command line assembled
    my $Days = $ExpireInDays;
    if ( $ID == 4 ) {
        $Days = 1;
    }
    my $Cmd = "openssl req -x509 -newkey rsa:4096 -passout 'pass:$Password' -keyout $KeyOut -out $CertOut -sha256 -days $Days -subj '$Subject' $SubjectAltName";

    print "$Cmd\n";

    my $Result = system("$Cmd");
    if ( $Result != 0 ) {
        die "openssl invocation failed!\n";
    }

    # fetch data from cert and format for testing

    my $Private = 'No';
    my $Type    = "cert";

    my $Modulus = qx~openssl x509 -modulus -noout -in $CertOut   | sed 's/^Modulus=//' ~;
    $Modulus =~ s/\s+$//;    # trim whitespace

    my $Subject2 = qx~openssl x509 -subject -noout -in $CertOut   | sed 's/^subject=//' ~;
    $Subject2 =~ s/\s+$//;

    my $Subject3 = $Subject2;
    $Subject2 =~ s/=/= /g;
    $Subject3 =~ s/ =/=/g;

    my $Issuer = qx~openssl x509 -issuer -noout -in $CertOut   | sed 's/^issuer=//' ~;
    $Issuer =~ s/\s+$//;

    my $Issuer2 = $Issuer;
    $Issuer  =~ s/=/= /g;
    $Issuer2 =~ s/ =/=/g;

    my $Hash = qx~openssl x509 -hash -noout -in $CertOut ~;
    $Hash =~ s/\s+$//;

    my $Serial = qx~openssl x509 -serial -noout -in $CertOut   | sed 's/^serial=//' ~;
    $Serial =~ s/\s+$//;

    my $Fingerprint = qx~openssl x509 -fingerprint -noout -in $CertOut   | sed 's/^SHA1 Fingerprint=//' ~;
    $Fingerprint =~ s/\s+$//;

    my $EndDate = qx~openssl x509 -dates -noout -in $CertOut | grep 'notAfter' | sed 's/^notAfter=//' ~;
    $EndDate =~ s/\s+$//;

    my $StartDate = qx~openssl x509 -dates -noout -in $CertOut | grep 'notBefore' | sed 's/^notBefore=//' ~;
    $StartDate =~ s/\s+$//;

    my $t            = Time::Piece->strptime( $EndDate, "%b %d %H:%M:%S %Y GMT" );
    my $ShortEndDate = $t->strftime("%Y-%m-%d");

    $t = Time::Piece->strptime( $StartDate, "%b %d %H:%M:%S %Y GMT" );
    my $ShortStartDate = $t->strftime("%Y-%m-%d");

    # the whole PEM file as string, for t4est comparisions
    my $PEM = file($CertOut)->slurp;

    # the unitest expectations as JSON file
    $JSON->{$ID} = {
        Email          => $Email,
        Modulus        => $Modulus,
        Subject        => [ $Subject2, $Subject3 ],
        Issuer         => [ $Issuer,   $Issuer2 ],
        Hash           => $Hash,
        Private        => $Private,
        Serial         => $Serial,
        Type           => $Type,
        Fingerprint    => $Fingerprint,
        EndDate        => $EndDate,
        ShortEndDate   => $ShortEndDate,
        StartDate      => $StartDate,
        ShortStartDate => $ShortStartDate,
        Pem            => $PEM,
    };

    # convert cert to p7b
    my $P7B = $CertOut;
    $P7B =~ s/\.asc$/.p7b/;

    system("openssl crl2pkcs7 -out $P7B -nocrl -certfile $CertOut");

    # convert cert to DER
    my $DER = $CertOut;
    $DER =~ s/\.asc$/.der/;

    system("openssl x509 -outform der -in $CertOut -out $DER");

    # convert cert to pfx
    my $PFX = $CertOut;
    $PFX =~ s/\.asc$/.pfx/;

    system("openssl pkcs12 -export -in $CertOut  -inkey $KeyOut -out $PFX -passin 'pass:$Password' -passout 'pass:$Password'");
}

# write test expectations to JSON file
file("scripts/test/sample/SMIME/smime_test.json")->spew(
    JSON->new->canonical(1)->utf8->pretty->encode($JSON)
);

# generate the example test .eml encrypted by cert "1"
system(
    "openssl smime -encrypt -in scripts/test/sample/SMIME/Plain-Test.eml -to 'unittest\@example.org' -from 'unittest\@example.org' -subject 'Unittest data' -out scripts/test/sample/SMIME/SMIME-Test.eml -des3 scripts/test/sample/SMIME/SMIMECertificate-1.asc"
);

# to test decryption using openssl (passphrase is 'a passphrase')
# openssl smime -in scripts/test/sample/SMIME/SMIME-Test.eml -inkey scripts/test/sample/SMIME/SMIMEPrivateKey-1.asc -decrypt scripts/test/sample/SMIME/SMIMECertificate-1.asc
