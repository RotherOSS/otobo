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
use File::Path qw(mkpath rmtree);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

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

my $HomeDir = $ConfigObject->Get('Home');

# create directory for certificates and private keys
my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
mkpath( [$CertPath],    0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
mkpath( [$PrivatePath], 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

# set SMIME paths
$ConfigObject->Set(
    Key   => 'SMIME::CertPath',
    Value => $CertPath,
);
$ConfigObject->Set(
    Key   => 'SMIME::PrivatePath',
    Value => $PrivatePath,
);

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin');

# set config
$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'SMIME::FetchFromCustomer',
    Value => 1,
);

# check if openssl is located there
if ( !$ConfigObject->Get('SMIME::Bin') || !-e $ConfigObject->Get('SMIME::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }
}

my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

if ($SMIMEObject) {
    pass('got SMIME support');
}
else {
    diag "NOTICE: No SMIME support!";

    if ( !-e $OpenSSLBin ) {
        fail("$OpenSSLBin exists");
    }
    elsif ( !-x $OpenSSLBin ) {
        fail("$OpenSSLBin is executable!");
    }
    elsif ( !-e $CertPath ) {
        fail("$CertPath exists");
    }
    elsif ( !-d $CertPath ) {
        fail("$CertPath is a directory");
    }
    elsif ( !-r $CertPath ) {
        fail("$CertPath is readable");
    }
    elsif ( !-e $PrivatePath ) {
        fail("$PrivatePath exists");
    }
    elsif ( !-d $PrivatePath ) {
        fail("$PrivatePath is a directory");
    }
    elsif ( !-w $PrivatePath ) {
        fail("$PrivatePath is writable");
    }

    done_testing();

    exit 0;
}

=item $CertificateSearch->()

searching for unittest-added certificates
returns found certificates with attributes

    my $Result = $CertificateSearch->();

Returns:
    same return as $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->CertificateSearch(
        Search => 'SearchString'
    );

=cut

my $CertificateSearch = sub {
    my @Result;
    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    my %Search = (
        1 => 'unittest@example.org',
        2 => 'unittest2@example.org',
        3 => 'unittest3@example.org',
        4 => 'unittest4@example.org',
        5 => 'unittest5@example.org',
    );
    for my $SearchString ( values %Search, 'axel@johanneum.example.org' ) {

        my @Certificat = $SMIMEObject->CertificateSearch( Search => $SearchString );
        if ( defined $Certificat[0]->{Filename} && !grep { $_->{Filename} eq $Certificat[0]->{Filename} } @Result ) {
            push @Result, @Certificat;
        }

    }

    return @Result;
};

# delete all before running
my @PreRunSearchResult = $CertificateSearch->();

for my $Cert (@PreRunSearchResult) {
    $SMIMEObject->CertificateRemove(
        Filename => $Cert->{Filename},
    );
}

# All certificates for testing
my @Certificates = (
    {
        CertificateName      => 'Check1',
        CertificateFileName1 => 'SMIMECertificate-1.asc',
        CertificateFileName2 => 'SMIMECertificate-1.p7b',
        CertificateFileName3 => 'SMIMECertificate-1.der',
        CertificateFileName4 => 'SMIMECertificate-1.pfx',
        CertificatePassFile  => 'SMIMEPrivateKeyPass-1.asc',
        Success              => 1,
        PFXWithLegacyAlgo    => 1,
    },
    {
        CertificateName      => 'Check2',
        CertificateFileName1 => 'SMIMECertificate-2.asc',
        CertificateFileName2 => 'SMIMECertificate-2.p7b',
        CertificateFileName3 => 'SMIMECertificate-2.der',
        CertificateFileName4 => 'SMIMECertificate-2.pfx',
        CertificatePassFile  => 'SMIMEPrivateKeyPass-2.asc',
        Success              => 1,
        PFXWithLegacyAlgo    => 1,
    },
    {
    },
    {
        CertificateName      => 'Check3',
        CertificateFileName1 => 'SMIMECertificate-3.asc',
        CertificateFileName2 => 'SMIMECertificate-3.p7b',
        CertificateFileName3 => 'SMIMECertificate-3.der',
        CertificateFileName4 => 'SMIMECertificate-3.pfx',
        CertificatePassFile  => 'SMIMEPrivateKeyPass-3.asc',
        Success              => 1,
        PFXWithLegacyAlgo    => 1,
    },
    {
    },
    {
        CertificateName      => 'OTOBOUserCert',
        CertificateFileName1 => 'SMIMEUserCertificate-Axel.crt',
        CertificateFileName2 => 'SMIMEUserCertificate-Axel.p7b',
        CertificateFileName3 => 'SMIMEUserCertificate-Axel.der',
        CertificateFileName4 => 'SMIMEUserCertificate-Axel.pfx',
        CertificatePassFile  => 'SMIMEUserPrivateKeyPass-Axel.crt',
        Success              => 1,
        PFXWithLegacyAlgo    => 1,
    },
    {
    },
    {
        CertificateName      => 'OTOBOUserCert wrong password',
        CertificateFileName1 => 'SMIMEUserCertificate-Axel.crt',
        CertificateFileName2 => 'SMIMEUserCertificate-Axel.p7b',
        CertificateFileName3 => 'SMIMEUserCertificate-Axel.der',
        CertificateFileName4 => 'SMIMEUserCertificate-Axel.pfx',
        CertificatePassFile  => 'SMIMEUserWrongPrivateKeyPass-Axel.crt',
        Success              => 0,                                         # Test with passfile will fail (wrong password)
        PFXWithLegacyAlgo    => 1,
    },
    {
    },
);

=item CertificationConversionTest

do the testing
- read
- convert
- search-empty
- add
- search-filled
- remove
returns Certificate String converted to PEM-format

    my $Result = CertificationConversionTest(
        "my test"               # description
        1,                      # success
        $CertificateString,     # filename
        'PEM',                  # format             # PEM, PKCS#7/P7B, DER, PFX
        'PemCertificateString', # CheckString        # (optional), FilereadString if empty
        'Path/to/PassFile'      # pass-filename      # (optional) only needed for PFX
    );

Returns:
    $Result =
    "-----BEGIN CERTIFICATE-----
    MIIEXjCCA0agAwIBAgIJAPIBQyBe/HbpMA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNV
    ...
    nj2wbQO4KjM12YLUuvahk5se
    -----END CERTIFICATE-----
    ";

=cut

sub CertificationConversionTest {
    my ( $Description, $Success, $CertificateFileName, $CheckString, $CertificatePassFile ) = @_;

    return unless $Description;
    return unless defined $Success;
    return unless $CertificateFileName;

    my $FormatedCertificate;

    subtest $Description => sub {

        # create objects
        my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');
        my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

        # read
        my $CertString = $MainObject->FileRead(
            Directory => $ConfigObject->Get('Home') . '/scripts/test/sample/SMIME/',
            Filename  => $CertificateFileName,
        );
        $CheckString ||= $CertString->$*;

        # convert
        # no passfile
        if ( !$CertificatePassFile ) {
            $FormatedCertificate = $SMIMEObject->ConvertCertFormat(
                String => $CertString->$*
            );

            # Remove any not needed information for easy compare.
            if ( $FormatedCertificate && $FormatedCertificate !~ m{\A-----BEGIN} ) {
                $FormatedCertificate = substr( $FormatedCertificate, index( $FormatedCertificate, '-----BEGIN' ), -1 );
            }
            is( $FormatedCertificate, $CheckString, "#$CertificateFileName ConvertCertFormat() was successful" );
        }

        # passfile needed
        else {

            my $Pass = $MainObject->FileRead(
                Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
                Filename  => $CertificatePassFile,
            );
            $FormatedCertificate = $SMIMEObject->ConvertCertFormat(
                String     => $CertString->$*,
                Passphrase => $Pass->$*,
            );

            # Remove any not needed information for easy compare.
            if ( $FormatedCertificate && $FormatedCertificate !~ m{\A-----BEGIN} ) {
                $FormatedCertificate = substr( $FormatedCertificate, index( $FormatedCertificate, '-----BEGIN' ), -1 ) . "\n";
            }

            if ($Success) {
                is( $FormatedCertificate, $CheckString, "#$CertificateFileName ConvertCertFormat() was successful" );
            }
            else {
                is( $FormatedCertificate, undef, "#$CertificateFileName ConvertCertFormat() was UNsuccessful (invalid password?)" );
            }
        }

        # search before add
        my @SearchResult = $CertificateSearch->();
        ok( !$SearchResult[0], "#$CertificateFileName CertificateSearch()-before was empty", );

        # add
        if ($FormatedCertificate) {
            my %AddResult = $SMIMEObject->CertificateAdd( Certificate => $FormatedCertificate );
            ok( $AddResult{Successful}, "#$CertificateFileName CertificateAdd() - $AddResult{Message}" );

            # search after add
            @SearchResult = $CertificateSearch->();
            ok( $SearchResult[0], "#$CertificateFileName CertificateSearch()-after was NOT empty" );
        }

        # remove
        for my $Cert (@SearchResult) {
            my %Result = $SMIMEObject->CertificateRemove(
                Filename => $Cert->{Filename},
            );

            is( $Result{Successful}, 1, "#$CertificateFileName CertificateRemove() - $Result{Message}" );
        }
        return;
    };

    return $FormatedCertificate;
}

# check certificates
for my $Certificate (@Certificates) {

    # PEM check
    my $PemCertificate = CertificationConversionTest(
        "$Certificate->{CertificateName} PEM",    # subtest description
        $Certificate->{Success},                  # Success
        $Certificate->{CertificateFileName1},     # Filename
    );

    # P7B check
    CertificationConversionTest(
        "$Certificate->{CertificateName} PKCS#7/P7B",    # subtest description
        $Certificate->{Success},                         # Success
        $Certificate->{CertificateFileName2},            # filename
        $PemCertificate,                                 # checkstring
    );

    # DER check
    CertificationConversionTest(
        "$Certificate->{CertificateName} DER",           # subtest description
        $Certificate->{Success},                         # Success
        $Certificate->{CertificateFileName3},            # filename
        $PemCertificate                                  # checkstring
    );

    # PFX check
    # Do not run this test when we have openssl 3 and certificates that
    # have been generated with the obsolete algorithm RC2-40-CBC.
    # See https://www.openssl.org/docs/manmaster/man7/migration_guide.html#Legacy-Algorithms.
    if ( $Certificate->{PFXWithLegacyAlgo} && $SMIMEObject->{OpenSSLMajorVersion} >= 3 ) {
        diag "Skipping: $Certificate->{CertificateName} PFX";
    }
    else {
        CertificationConversionTest(
            "$Certificate->{CertificateName} PFX",    # subtest description
            $Certificate->{Success},                  # Success
            $Certificate->{CertificateFileName4},     # filename
            $PemCertificate,                          # checkstring
            $Certificate->{CertificatePassFile}       # pass-filename
        );
    }
}

# delete needed test directories
for my $Directory ( $CertPath, $PrivatePath ) {
    my $Success = rmtree( [$Directory] );
    ok( $Success, "Directory deleted - '$Directory'", );
}

done_testing;
