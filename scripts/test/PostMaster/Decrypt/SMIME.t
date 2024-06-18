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
use File::Path qw(mkpath rmtree);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::PostMaster ();

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $HomeDir = $ConfigObject->Get('Home');

# Create directory for certificates and private keys
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

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin') || '/usr/bin/openssl';

# get the openssl major version, e.g. 1 for version 1.0.0
# openssl 0.9 is no longer considered for this test script, as openssl 1.0.0 was already released in 2010
my $OpenSSLVersionString = qx{$OpenSSLBin version};                                                       # e.g. "OpenSSL 1.1.1f  31 Mar 2020"
my ($OpenSSLMajorVersion) = $OpenSSLVersionString =~ m{ \A (?: (?: Open|Libre)SSL )? \s* ( \d )  }xmsi;
ok( $OpenSSLMajorVersion >= 0, 'openssl has version 1.0.0 or newer' );

# Set config.
$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);

# Do not really send emails.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# Get test email backed object.
my $TestBackendObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Success = $TestBackendObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestBackendObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

# Check if OpenSSL is located there.
if ( !-e $OpenSSLBin ) {

    # maybe it's a mac with mac ports
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }
}

# Create crypt object.
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

    exit 0;
}

#
# Setup environment
#

# OpenSSL 1.0.0 hashes
my $Check1Hash = 'f62a2257';
my $Check2Hash = '35c7d865';

# certificates
my @Certificates = (
    {
        CertificateName       => 'Check1',
        CertificateHash       => $Check1Hash,
        CertificateFileName   => 'SMIMECertificate-1.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-1.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-1.asc',
    },
);

# Get main object.
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

# Add chain certificates.
for my $Certificate (@Certificates) {

    # Add certificate ...
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

my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');
my $FilterRand1      = 'filter' . $Helper->GetRandomID();

$PostMasterFilter->FilterAdd(
    Name           => $FilterRand1,
    StopAfterMatch => 0,
    Match          => [
        {
            Key   => 'X-OTOBO-BodyDecrypted',
            Value => 'Hi',
        },
    ],
    Set => [
        {
            Key   => 'X-OTOBO-Queue',
            Value => 'Junk',
        },
    ],
);

# Read email content (from a file).
my $Email = $MainObject->FileRead(
    Location => $ConfigObject->Get('Home') . '/scripts/test/sample/SMIME/SMIME-Test.eml',
    Result   => 'ARRAY',
);

$ConfigObject->Set(
    Key   => 'PostmasterDefaultState',
    Value => 'new'
);

$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule',
    Value => {}
);

$ConfigObject->Set(
    Key   => 'PostMaster::PreFilterModule',
    Value => {
        '000-DecryptBody' => {
            'Module'             => 'Kernel::System::PostMaster::Filter::Decrypt',
            'StoreDecryptedBody' => '1',
        },
        '000-MatchDBSource' => {
            'Module' => 'Kernel::System::PostMaster::Filter::MatchDBSource',
        }
    }
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

my $PostMasterObject = Kernel::System::PostMaster->new(
    CommunicationLogObject => $CommunicationLogObject,
    Email                  => $Email,
    Trusted                => 1,
);

my @Return = $PostMasterObject->Run( Queue => '' );

$Self->Is(
    $Return[0] || 0,
    1,
    "Create new ticket",
);

$Self->True(
    $Return[1] || 0,
    "Create new ticket (TicketID)",
);

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

# Get ticket object.
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $TicketID = $Return[1];

my %Ticket = $TicketObject->TicketGet(
    TicketID => $Return[1],
);

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
my @ArticleIndex         = $ArticleObject->ArticleList(
    TicketID => $Return[1],
    UserID   => 1,
);

my %FirstArticle = $ArticleBackendObject->ArticleGet( %{ $ArticleIndex[0] } );

$Self->Is(
    $Ticket{Queue},
    'Junk',
    "Ticket created in $Ticket{Queue}",
);

my $GetBody = $FirstArticle{Body};
chomp($GetBody);

$Self->Is(
    $GetBody,
    'Hi',
    "Body decrypted $FirstArticle{Body}",
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

done_testing();
