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

# Set up the test driver $Self when we are running as a standalone script.
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

use File::Path qw(mkpath rmtree);

my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject   = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $HomeDir = $ConfigObject->Get('Home');

# Create directory for certificates and private keys.
my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
mkpath( [$CertPath],    0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
mkpath( [$PrivatePath], 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

# Set SMIME paths.
$ConfigObject->Set(
    Key   => 'SMIME::CertPath',
    Value => $CertPath,
);
$ConfigObject->Set(
    Key   => 'SMIME::PrivatePath',
    Value => $PrivatePath,
);

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin') || '/usr/bin/openssl';

# get the openssl major version, e.g. 1 for version 1.0.0
# openssl 0.9 is no longer considered for this test script, as openssl 1.0.0 was already released in 2010
my $OpenSSLVersionString = qx{$OpenSSLBin version};                                                       # e.g. "OpenSSL 1.1.1f  31 Mar 2020"
my ($OpenSSLMajorVersion) = $OpenSSLVersionString =~ m{ \A (?: (?: Open|Libre)SSL )? \s* ( \d )  }xmsi;
ok( $OpenSSLMajorVersion >= 0, 'openssl has version 1.0.0 or newer' );

$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# Check if openssl is located there.
if ( !-e $OpenSSLBin ) {

    # Maybe it's a mac with macport.
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }
}

my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

if ( !$SMIMEObject ) {
    diag "NOTICE: No SMIME support!";

    if ( !-e $OpenSSLBin ) {
        $Self->False(
            1,
            "No such $OpenSSLBin!",
        );
    }
    elsif ( !-x $OpenSSLBin ) {
        $Self->False(
            1,
            "$OpenSSLBin not executable!",
        );
    }
    elsif ( !-e $CertPath ) {
        $Self->False(
            1,
            "No such $CertPath!",
        );
    }
    elsif ( !-d $CertPath ) {
        $Self->False(
            1,
            "No such $CertPath directory!",
        );
    }
    elsif ( !-w $CertPath ) {
        $Self->False(
            1,
            "$CertPath not writable!",
        );
    }
    elsif ( !-e $PrivatePath ) {
        $Self->False(
            1,
            "No such $PrivatePath!",
        );
    }
    elsif ( !-d $Self->{PrivatePath} ) {
        $Self->False(
            1,
            "No such $PrivatePath directory!",
        );
    }
    elsif ( !-w $PrivatePath ) {
        $Self->False(
            1,
            "$PrivatePath not writable!",
        );
    }

    done_testing();
}

# OpenSSL 1.0.0 hashes.
my $Check1Hash      = 'f62a2257';
my $Check2Hash      = '35c7d865';
my $JohanneumCAHash = '3b966dd9';
my $GeologyCAHash   = '4bb5116c';
my $CabinetCAHash   = '63bc283c';
my $AxelCertHash    = 'c8c9e520';

my @Certificates = (
    {
        CertificateName       => 'Check1',
        CertificateHash       => $Check1Hash,
        CertificateFileName   => 'SMIMECertificate-1.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-1.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-1.asc',
    },
    {
        CertificateName       => 'Check2',
        CertificateHash       => $Check2Hash,
        CertificateFileName   => 'SMIMECertificate-2.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-2.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-2.asc',
    },
    {
        CertificateName       => 'OTOBOUserCert',
        CertificateHash       => $AxelCertHash,
        CertificateFileName   => 'SMIMEUserCertificate-Axel.crt',
        PrivateKeyFileName    => 'SMIMEUserPrivateKey-Axel.pem',
        PrivateSecretFileName => 'SMIMEUserPrivateKeyPass-Axel.crt',
    },
    {
        CertificateName       => 'CabinetCA',
        CertificateHash       => $CabinetCAHash,
        CertificateFileName   => 'SMIMECACertificate-Cabinet.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-Cabinet.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-Cabinet.crt',
    },
    {
        CertificateName       => 'GeologyCA',
        CertificateHash       => $GeologyCAHash,
        CertificateFileName   => 'SMIMECACertificate-Geology.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-Geology.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-Geology.crt',
    },
    {
        CertificateName       => 'JohanneumCA',
        CertificateHash       => $JohanneumCAHash,
        CertificateFileName   => 'SMIMECACertificate-Johanneum.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-Johanneum.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-Johanneum.crt',
    },
);

# Add chain certificates.
for my $Certificate (@Certificates) {

    # Add certificate.
    my $CertString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{CertificateFileName},
    );
    my %Result = $SMIMEObject->CertificateAdd( Certificate => ${$CertString} );
    $Self->True(
        $Result{Successful} || '',
        "#$Certificate->{CertificateName} CertificateAdd() - $Result{Message}",
    );

    # Add private key.
    my $KeyString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{PrivateKeyFileName},
    );
    my $Secret = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{PrivateSecretFileName},
    );
    %Result = $SMIMEObject->PrivateAdd(
        Private => ${$KeyString},
        Secret  => ${$Secret},
    );
    $Self->True(
        $Result{Successful} || '',
        "#$Certificate->{CertificateName} PrivateAdd()",
    );
}

my $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

my @CertList = $CryptObject->CertificateList();

my $Cert1 = $CertList[0];
my $Cert2 = $CertList[1];

my %Cert1Attributes = $CryptObject->CertificateAttributes(
    Certificate => $CryptObject->CertificateGet( Filename => $Cert1 ),
    Filename    => $Cert1,
);
my %Cert2Attributes = $CryptObject->CertificateAttributes(
    Certificate => $CryptObject->CertificateGet( Filename => $Cert2 ),
    Filename    => $Cert2,
);

my @Data = $CryptObject->SignerCertRelationGet(
    CertFingerprint => $Cert1Attributes{Fingerprint},
);
$Self->False(
    @Data ? 1 : 0,
    'Certificate 1 has no relations',
);
@Data = $CryptObject->SignerCertRelationGet(
    CertFingerprint => $Cert2Attributes{Fingerprint},
);
$Self->False(
    @Data ? 1 : 0,
    'Certificate 2 has no relations',
);

$CryptObject->SignerCertRelationAdd(
    CertFingerprint => $Cert1Attributes{Fingerprint},
    CAFingerprint   => $Cert2Attributes{Fingerprint},
    UserID          => 1,
);

@Data = $CryptObject->SignerCertRelationGet(
    CertFingerprint => $Cert1Attributes{Fingerprint},
);
$Self->True(
    @Data ? 1 : 0,
    'Certificate 1 has relations',
);

my $Success = $CryptObject->CertificateRemove(
    Filename => $Cert2,
);
$Self->True(
    @Data ? 1 : 0,
    'Certificate 2 got removed',
);

@Data = $CryptObject->SignerCertRelationGet(
    CertFingerprint => $Cert1Attributes{Fingerprint},
);
$Self->False(
    @Data ? 1 : 0,
    'Certificate 1 has no relations',
);

# Delete needed test directories.
for my $Directory ( $CertPath, $PrivatePath ) {
    my $Success = rmtree( [$Directory] );
    $Self->True(
        $Success,
        "Directory deleted - '$Directory'",
    );
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
