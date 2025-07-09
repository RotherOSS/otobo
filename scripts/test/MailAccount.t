# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get mail account object
my $MailAccountObject = $Kernel::OM->Get('Kernel::System::MailAccount');

my $MailAccountAdd = $MailAccountObject->MailAccountAdd(
    Login         => 'mail',
    Password      => 'SomePassword',
    Host          => 'pop3.example.com',
    Type          => 'POP3',
    ValidID       => 1,
    Trusted       => 0,
    IMAPFolder    => 'Foo',
    DispatchingBy => 'Queue',              # Queue|From
    QueueID       => 1,
    UserID        => 1,
);

$Self->True(
    $MailAccountAdd,
    'MailAccountAdd()',
);

my %MailAccount = $MailAccountObject->MailAccountGet(
    ID => $MailAccountAdd,
);

$Self->True(
    $MailAccount{Login} eq 'mail',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Password} eq 'SomePassword',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Host} eq 'pop3.example.com',
    'MailAccountGet() - Host',
);
$Self->True(
    $MailAccount{Type} eq 'POP3',
    'MailAccountGet() - Type',
);

$Self->True(
    $MailAccount{IMAPFolder} eq '',
    'MailAccountGet() - IMAPFolder',
);

my $MailAccountUpdate = $MailAccountObject->MailAccountUpdate(
    ID            => $MailAccountAdd,
    Login         => 'mail2',
    Password      => 'SomePassword2',
    Host          => 'imap.example.com',
    Type          => 'IMAP',
    ValidID       => 1,
    IMAPFolder    => 'Bar',
    Trusted       => 0,
    DispatchingBy => 'Queue',              # Queue|From
    QueueID       => 1,
    UserID        => 1,
);

$Self->True(
    $MailAccountUpdate,
    'MailAccountUpdate()',
);

%MailAccount = $MailAccountObject->MailAccountGet(
    ID => $MailAccountAdd,
);

$Self->True(
    $MailAccount{Login} eq 'mail2',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Password} eq 'SomePassword2',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Host} eq 'imap.example.com',
    'MailAccountGet() - Host',
);
$Self->True(
    $MailAccount{Type} eq 'IMAP',
    'MailAccountGet() - Type',
);

$Self->True(
    $MailAccount{IMAPFolder} eq 'Bar',
    'MailAccountGet() - IMAPFolder',
);

my %List = $MailAccountObject->MailAccountList(
    Valid => 0,    # just valid/all accounts
);

$Self->True(
    $List{$MailAccountAdd},
    'MailAccountList()',
);

my $MailAccountDelete = $MailAccountObject->MailAccountDelete(
    ID => $MailAccountAdd,
);

$Self->True(
    $MailAccountDelete,
    'MailAccountDelete()',
);

my $MailAccountAddIMAP = $MailAccountObject->MailAccountAdd(
    Login         => 'mail',
    Password      => 'SomePassword',
    Host          => 'imap.example.com',
    Type          => 'IMAPS',
    ValidID       => 1,
    Trusted       => 0,
    IMAPFolder    => 'Foo',
    DispatchingBy => 'Queue',              # Queue|From
    QueueID       => 1,
    UserID        => 1,
);

$Self->True(
    $MailAccountAddIMAP,
    'MailAccountAdd()',
);

%MailAccount = $MailAccountObject->MailAccountGet(
    ID => $MailAccountAddIMAP,
);

$Self->True(
    $MailAccount{Login} eq 'mail',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Password} eq 'SomePassword',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Host} eq 'imap.example.com',
    'MailAccountGet() - Host',
);
$Self->True(
    $MailAccount{Type} eq 'IMAPS',
    'MailAccountGet() - Type',
);

$Self->True(
    $MailAccount{IMAPFolder} eq 'Foo',
    'MailAccountGet() - IMAPFolder',
);

my $MailAccountUpdateIMAP = $MailAccountObject->MailAccountUpdate(
    ID            => $MailAccountAddIMAP,
    Login         => 'mail2',
    Password      => 'SomePassword2',
    Host          => 'imaps.example.com',
    Type          => 'IMAPS',
    ValidID       => 1,
    Trusted       => 0,
    DispatchingBy => 'Queue',               # Queue|From
    QueueID       => 1,
    UserID        => 1,
);

$Self->True(
    $MailAccountUpdateIMAP,
    'MailAccountUpdate()',
);

%MailAccount = $MailAccountObject->MailAccountGet(
    ID => $MailAccountAddIMAP,
);

$Self->True(
    $MailAccount{Login} eq 'mail2',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Password} eq 'SomePassword2',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Host} eq 'imaps.example.com',
    'MailAccountGet() - Host',
);
$Self->True(
    $MailAccount{Type} eq 'IMAPS',
    'MailAccountGet() - Type',
);

$Self->True(
    $MailAccount{IMAPFolder} eq 'INBOX',
    'MailAccountGet() - IMAPFolder fallback',
);

my $MailAccountDeleteIMAP = $MailAccountObject->MailAccountDelete(
    ID => $MailAccountAddIMAP,
);

$Self->True(
    $MailAccountDeleteIMAP,
    'MailAccountDelete() IMAP account',
);

my $ProfileRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::ProfileRepository');
my $Success           = $ProfileRepository->AddProfile(

    Name           => '__UnitTest_OIDCProfile',
    ClientSettings => {
        ClientSecret => 'XXX',
        ClientID     => 'YYY',
        RedirectURI  => 'ZZZ',
    },
    ProviderSettings => {
        OpenIDConfiguration => 'https://somewhere.com/.well-known/openid-configuration',
        TTL                 => 60 * 30,                                                    # optional: time period the extracted openid-configuration is cached
        SSLOptions          =>
            {    # if special ssl options are needed; SSLVerifyHostname => 0 and SSLVerifyMode => 0 are also possible but should only be used for testing purposes
                SSLCertificate    => 'SSL_cert_file',    # client certificate
                SSLKey            => 'SSL_key_file',     # client cert key
                SSLPassword       => 'SSL_passwd_cb',    # password for client cert key
                SSLCAFile         => 'SSL_ca_file',      # CA certificate
                SSLCADir          => 'SSL_ca_path',      # CA cert directory
                SSLVerifyHostname => 0,
                SSLVerifyMode     => 0
            }
    },
    Misc => {
        UseNonce   => 1,         # add a nonce to request and token (this is primarily important for the implicit flow where it is enabled by default)
        RandLength => 22,        # length for state and nonce random strings - default: 22
        RandTTL    => 60 * 5,    # valid time period for state and nonce (roughly the time a user can take to authenticate) - default: 300 s
        Leeway     => 2,         # leeway for small time differences between the OTOBO server and the OpenID provier - default: 2 s
    },
    UserID => 1,
    Valid  => 1,
);

$Self->True( $Success, 'OIDC Profile created' );

my $Profile = $ProfileRepository->GetProfile( Name => '__UnitTest_OIDCProfile' );

my $FunctionalAccounts = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccounts');

$Success = $FunctionalAccounts->SaveAccount(
    Name          => '__UnitTest1',
    OIDCProfileID => $Profile->{ProfileID},
    GrantType     => 'client_credentials',
    Scope         => 'openid email',
    Token         => 'access_token',
    Valid         => 1,
    UserID        => 1,
);

$Self->True( $Success, 'Functional account created' );

my $MailAccountAddXOAUTH2 = $MailAccountObject->MailAccountAdd(
    Login => 'mail',

    #    Password      => 'SomeOtherPassword',
    Host          => 'imap.example.com',
    Type          => 'IMAPS',
    ValidID       => 1,
    Trusted       => 0,
    IMAPFolder    => 'Foo',
    DispatchingBy => 'Queue',              # Queue|From
    QueueID       => 1,
    UserID        => 1,
    Auth          => 'XOAUTH2',
    AccountName   => '__UnitTest1',
);

$Self->True( $MailAccountAddXOAUTH2, 'IMAP with XOAUTH2 added' );

%MailAccount = $MailAccountObject->MailAccountGet(
    ID => $MailAccountAddXOAUTH2,
);

$Self->True(
    $MailAccount{Login} eq 'mail',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Password} eq '',
    'MailAccountGet() - Login',
);
$Self->True(
    $MailAccount{Host} eq 'imap.example.com',
    'MailAccountGet() - Host',
);
$Self->True(
    $MailAccount{Type} eq 'IMAPS',
    'MailAccountGet() - Type',
);

$Self->True(
    $MailAccount{IMAPFolder} eq 'Foo',
    'MailAccountGet() - IMAPFolder',
);

$Self->True(
    $MailAccount{Auth} eq 'XOAUTH2',
    'MailAccountGet() - Auth',
);

$Self->True(
    $MailAccount{AccountName} eq '__UnitTest1',
    'MailAccountGet() - Account Name',
);

$Self->DoneTesting();
