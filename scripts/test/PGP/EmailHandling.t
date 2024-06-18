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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Kernel::OM
use Kernel::Output::HTML::ArticleCheck::PGP;
use Kernel::System::PostMaster;
use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $HTMLUtilsObject      = $Kernel::OM->Get('Kernel::System::HTMLUtils');
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');
my $UserObject           = $Kernel::OM->Get('Kernel::System::User');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

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
    Value => { '04A17B7A' => 'somepass' },
);

$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my $PGPBin = $ConfigObject->Get('PGP::Bin');

# check if gpg is located there
if ( !$PGPBin || !( -e $PGPBin ) ) {

    if ( -e '/usr/bin/gpg' ) {
        $ConfigObject->Set(
            Key   => 'PGP::Bin',
            Value => '/usr/bin/gpg'
        );
    }

    # maybe it's a mac with macport
    elsif ( -e '/opt/local/bin/gpg' ) {
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

skip_all('no PGP support') unless $PGPObject;

# make some preparations
my %Search = (
    1 => 'unittest@example.com',
    2 => 'unittest2@example.com',
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
);

# add PGP keys and perform sanity check
for my $Count ( 1 .. 2 ) {

    subtest "Key $Count" => sub {
        my ( $Key, @OtherKeys ) = $PGPObject->KeySearch(
            Search => $Search{$Count},
        );
        ok( !$Key, "KeySearch(), key not found" );

        # get keys
        my $KeyString = $MainObject->FileRead(
            Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/Crypt/",
            Filename  => "PGPPrivateKey-$Count.asc",
        );
        my $Message = $PGPObject->KeyAdd(
            Key => ${$KeyString},
        );
        ok( $Message, "KeyAdd()" );

        ( $Key, @OtherKeys ) = $PGPObject->KeySearch(
            Search => $Search{$Count},
        );
        ok( $Key, "KeySearch(), key found" );

        for my $ID (qw(Type Identifier Bit Key KeyPrivate Created Expires Fingerprint FingerprintShort)) {
            is(
                $Key->{$ID} || '',
                $Check{$Count}->{$ID},
                "KeySearch() - $ID",
            );
        }

        my $PublicKeyString = $PGPObject->PublicKeyGet(
            Key => $Key->{Key},
        );
        ok( $PublicKeyString, "PublicKeyGet()" );

        my $PrivateKeyString = $PGPObject->SecretKeyGet(
            Key => $Key->{KeyPrivate},
        );
        ok( $PrivateKeyString, "SecretKeyGet()" );
    };
}

# tests for handling signed / encrypted emails
my @CryptTests = (
    {
        Name           => 'Encrypted Body, Plain Attachments',
        EmailFile      => '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-1.eml',
        ArticleSubject => 'PGP Test 2013-07-02-1977-1',
        ArticleBody    => "This is only a test.\n",
    },
    {
        Name           => 'Encrypted Body and Attachments as whole',
        EmailFile      => '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-2.eml',
        ArticleSubject => 'PGP Test 2013-07-02-1977-2',
        ArticleBody    => "This is only a test.\n",
    },
    {
        Name           => 'Encrypted Body and Attachments independently',
        EmailFile      => '/scripts/test/sample/PGP/PGP_Test_2013-07-02-1977-3.eml',
        ArticleSubject => 'PGP Test 2013-07-02-1977-3',
        ArticleBody    => "This is only a test.\n",
    },
    {
        Name               => 'Signed 7bit (Short lines)',
        EmailFile          => '/scripts/test/sample/PGP/Signed_PGP_Test_7bit.eml',
        CheckSignatureOnly => 1,
    },
    {
        Name               => 'Signed Quoted-Printable (Long Lines)',
        EmailFile          => '/scripts/test/sample/PGP/Signed_PGP_Test_QuotedPrintable.eml',
        CheckSignatureOnly => 1,
    },
);

# to store added tickets into the system (will be deleted later)
my @AddedTickets;

# lookup table to get a better idea of postmaster result
my %PostMasterReturnLookup = (
    0 => 'error (also false)',
    1 => 'new ticket created',
    2 => 'follow up / open/reopen',
    3 => 'follow up / close -> new ticket',
    4 => 'follow up / close -> reject',
    5 => 'ignored (because of X-OTOBO-Ignore header)',
);

for my $Test (@CryptTests) {

    subtest $Test->{Name} => sub {

        # read email content (from a file)
        my $Email = $MainObject->FileRead(
            Location => $ConfigObject->Get('Home') . $Test->{EmailFile},
            Result   => 'ARRAY',
        );

        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => 'Email',
                Direction => 'Incoming',
            },
        );
        $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

        # use post master to import mail into OTOBO
        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => $Email,
            Trusted                => 1,
        );
        my @PostMasterResult = $PostMasterObject->Run( Queue => '' );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );

        # sanity check (if postmaster runs correctly)
        isnt(
            $PostMasterResult[0],
            0,
            "PostMaster result should not be 0"
                . " ($PostMasterReturnLookup{ $PostMasterResult[0] })",
        );

        # check if we get a new TicketID
        isnt(
            $PostMasterResult[1],
            undef,
            "PostMaster TicketID should not be undef",
        );

        # set the TicketID as the result form PostMaster
        my $TicketID = $PostMasterResult[1] || 0;

        if ( $PostMasterResult[1] > 0 ) {
            push @AddedTickets, $TicketID;

            # get ticket articles
            my @Articles = $ArticleObject->ArticleList(
                TicketID  => $TicketID,
                OnlyFirst => 1,
            );

            # use the first result, there should be only one
            my %RawArticle;
            if (@Articles) {
                %RawArticle = $Articles[0]->%*;
            }
            note "TicketID: $RawArticle{TicketID}";
            note "ArticleID: $RawArticle{ArticleID}";

            # use ArticleCheck::PGP to decrypt the article
            my $CheckObject = Kernel::Output::HTML::ArticleCheck::PGP->new(
                ArticleID => $Articles[0]->{ArticleID},
                UserID    => $TestUserID,
            );

            my %Article = $ArticleBackendObject->ArticleGet(
                TicketID  => $RawArticle{TicketID},
                ArticleID => $RawArticle{ArticleID},
            );

            my @CheckResult = $CheckObject->Check( Article => \%Article );

            # sanity destroy object
            $CheckObject = undef;

            if ( $Test->{CheckSignatureOnly} ) {

                RESULTITEM:
                for my $ResultItem (@CheckResult) {

                    next RESULTITEM if $ResultItem->{Key} ne 'Signed';

                    ok( $ResultItem->{SignatureFound}, 'Signature found with true' );
                    ok( $ResultItem->{Successful},     'Signature verify with true' );

                    last RESULTITEM;
                }

                return;
            }

            # check actual contents (subject and body)
            %Article = $ArticleBackendObject->ArticleGet(
                TicketID  => $RawArticle{TicketID},
                ArticleID => $RawArticle{ArticleID},
            );

            is(
                $Article{Subject},
                $Test->{ArticleSubject},
                "Decrypted article subject",
            );

            is(
                $Article{Body},
                $Test->{ArticleBody},
                "Decrypted article body",
            );

            # get the list of attachments
            my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID        => $Articles[0]->{ArticleID},
                ExcludePlainText => 1,
                ExcludeHTMLBody  => 1,
                ExcludeInline    => 1,
            );

            use Data::Dumper;
            warn Dumper( \%AtmIndex );
            FILEID:
            for my $FileID ( sort keys %AtmIndex ) {

                # skip non important attachments
                next FILEID if $AtmIndex{$FileID}->{Filename} =~ m{\A file-\d+ \z}msx;

                # get the attachment from the article (it should be already decrypted)
                my %Attachment = $ArticleBackendObject->ArticleAttachment(
                    ArticleID => $Articles[0]->{ArticleID},
                    FileID    => $FileID,
                );
                warn Dumper( \%Attachment );

                # read the original file (from file system)
                my $FileStringRef = $MainObject->FileRead(
                    Location => $ConfigObject->Get('Home')
                        . '/scripts/test/sample/Crypt/'
                        . $AtmIndex{$FileID}->{Filename},
                );

                # check actual contents (attachment)
                is(
                    $Attachment{Content},
                    ${$FileStringRef},
                    "Decrypted attachment $AtmIndex{$FileID}->{Filename}",
                );
            }
        }
    };
}

# different mails to test
my @ArticleTests = (
    {
        Name        => 'simple string',
        ArticleData => {
            Body     => 'Simple string',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with unix newline',
        ArticleData => {
            Body     => 'Simple string \n with unix newline',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with windows newline',
        ArticleData => {
            Body     => 'Simple string \r\n with windows newline',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with long word',
        ArticleData => {
            Body =>
                'SimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleString',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with long lines',
        ArticleData => {
            Body =>
                'Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with unicode data',
        ArticleData => {
            Body     => 'äöüßø@«∑€©ƒ',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'Multiline HTML',
        ArticleData => {
            Body =>
                '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Simple Line<br/><br/><br/>Your Ticket-Team<br/><br/>Your Agent<br/><br/>--<br/> Super Support - Waterford Business Park<br/> 5201 Blue Lagoon Drive - 8th Floor &amp; 9th Floor - Miami, 33126 USA<br/> Email: hot@example.com - Web: <a href="http://www.example.com/" title="http://www.example.com/" target="_blank">http://www.example.com/</a><br/>--</body></html>',
            MimeType => 'text/html',
        },
    },
    {
        Name        => 'Reply to a previously signed message',
        ArticleData => {
            Body => '
Reply text
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Original signed text
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
> Comment: GPGTools - http://gpgtools.org
>
> iEYEARECAAYFAlJzpy4ACgkQjDflB7tFqcf4pgCbBf/f5dTEVDagR7Sq2mJq+lL+
> rpAAn3qKwT7j8PMYfSnBwGs0tM1ekbpd
> =eLoO
> -----END PGP SIGNATURE-----
>
>',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'Inline Attachment',
        ArticleData => {
            Body =>
                '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Hi<img alt="" src="cid:inline835421.188799263.1394842906.6253839.53368344@Mandalore.local" style="height:16px; width:16px" /></body></html>',
            MimeType   => 'text/html',
            Attachment => [
                {
                    ContentID =>
                        'inline835421.188799263.1394842906.6253839.53368344@Mandalore.local',
                    Content     => 'Any',
                    ContentType => 'image/png; name="ui-toolbar-bookmark.png"',
                    Filename    => 'ui-toolbar-bookmark.png',
                    Disposition => 'inline',
                },
            ],
        },
    },
    {
        Name        => 'Normal Attachment',
        ArticleData => {
            Body =>
                '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Simple Line<br/><br/><br/>Your Ticket-Team<br/><br/>Your Agent<br/><br/>--<br/> Super Support - Waterford Business Park<br/> 5201 Blue Lagoon Drive - 8th Floor &amp; 9th Floor - Miami, 33126 USA<br/> Email: hot@example.com - Web: <a href="http://www.example.com/" title="http://www.example.com/" target="_blank">http://www.example.com/</a><br/>--</body></html>',
            MimeType   => 'text/html',
            Attachment => [
                {
                    ContentID   => '',
                    Content     => 'Any',
                    ContentType => 'image/png; name="ui-toolbar-bookmark.png"',
                    Filename    => 'ui-toolbar-bookmark.png',
                    Disposition => 'attachment',
                },
            ],
        },
    },
);

# test each mail with sign/crypt/sign+crypt
my @TestVariations;

for my $Test (@ArticleTests) {
    push @TestVariations, {
        Name        => $Test->{Name} . " (old API) sign only (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From => 'unittest@example.org',
            To   => 'unittest@example.org',
            Sign => {
                Type    => 'PGP',
                SubType => 'Detached',
                Key     => $Check{1}->{KeyPrivate},
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 0,
    };

    push @TestVariations, {
        Name        => $Test->{Name} . " (old API) crypt only (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From  => 'unittest2@example.org',
            To    => 'unittest2@example.org',
            Crypt => {
                Type    => 'PGP',
                SubType => 'Detached',
                Key     => $Check{2}->{Key},
            },
        },
        VerifySignature  => 0,
        VerifyDecryption => 1,
    };

    push @TestVariations, {
        Name        => $Test->{Name} . " (old API) sign and crypt (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From => 'unittest2@example.org',
            To   => 'unittest2@example.org',
            Sign => {
                Type    => 'PGP',
                SubType => 'Detached',
                Key     => $Check{2}->{KeyPrivate},
            },
            Crypt => {
                Type    => 'PGP',
                SubType => 'Detached',
                Key     => $Check{2}->{Key},
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 1,
    };

    # TODO: currently inline signatures tests does not work as OTOBO does not save the signature
    #    in the Article{Body}, the body remains intact after sending the email, only the email has
    #    the signature

    # here starts the tests for new API

    push @TestVariations, {
        Name        => $Test->{Name} . " sign only (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From          => 'unittest@example.org',
            To            => 'unittest@example.org',
            EmailSecurity => {
                Backend => 'PGP',
                Method  => 'Detached',
                SignKey => $Check{1}->{KeyPrivate},
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 0,
    };

    push @TestVariations, {
        Name        => $Test->{Name} . " crypt only (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From          => 'unittest2@example.org',
            To            => 'unittest2@example.org',
            EmailSecurity => {
                Backend     => 'PGP',
                Method      => 'Detached',
                EncryptKeys => [ $Check{2}->{Key} ],
            },
        },
        VerifySignature  => 0,
        VerifyDecryption => 1,
    };

    push @TestVariations, {
        Name        => $Test->{Name} . " sign and crypt (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From          => 'unittest2@example.org',
            To            => 'unittest2@example.org',
            EmailSecurity => {
                Backend     => 'PGP',
                Method      => 'Detached',
                SignKey     => $Check{2}->{KeyPrivate},
                EncryptKeys => [ $Check{2}->{Key} ],
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 1,
    };

    # start tests with 2 recipients

    push @TestVariations, {
        Name        => $Test->{Name} . " sign only (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From          => 'unittest@example.org',
            To            => 'unittest@example.org, unittest2@example.org',
            EmailSecurity => {
                Backend => 'PGP',
                Method  => 'Detached',
                SignKey => $Check{1}->{KeyPrivate},
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 0,
    };

    push @TestVariations, {
        Name        => $Test->{Name} . " crypt only (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From          => 'unittest2@example.org',
            To            => 'unittest@example.org, unittest2@example.org',
            EmailSecurity => {
                Backend     => 'PGP',
                Method      => 'Detached',
                EncryptKeys => [ $Check{1}->{Key}, $Check{2}->{Key} ],
            },
        },
        VerifySignature  => 0,
        VerifyDecryption => 1,
    };

    push @TestVariations, {
        Name        => $Test->{Name} . " sign and crypt (Detached)",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From          => 'unittest2@example.org',
            To            => 'unittest@example.org, unittest2@example.org',
            EmailSecurity => {
                Backend     => 'PGP',
                Method      => 'Detached',
                SignKey     => $Check{2}->{KeyPrivate},
                EncryptKeys => [ $Check{1}->{Key}, $Check{2}->{Key} ],
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 1,
    };

}

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => $TestUserID,
);

ok( $TicketID, 'TicketCreate()' );

my $TicketNumber = $TicketObject->TicketNumberLookup(
    TicketID => $TicketID,
);

push @AddedTickets, $TicketID;

for my $Test (@TestVariations) {
    subtest $Test->{Name} => sub {

        my $ArticleID = $ArticleBackendObject->ArticleSend(
            %{ $Test->{ArticleData} },
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            HistoryType          => 'AddNote',
            HistoryComment       => 'note',
            Subject              => 'Unittest data',
            Charset              => 'utf-8',
            UserID               => 1,
        );

        ok( $ArticleID, "ArticleSend()" );

        # Read generated email and use it to create yet another article.
        # This is necessary because otherwise reading the existing article will result in using the internal body
        #   which doesn't contain signatures etc.
        my $Email = $ArticleBackendObject->ArticlePlain(
            ArticleID => $ArticleID,
            UserID    => $TestUserID,
        );

        # Add ticket number to subject (to ensure mail will be attached to original ticket)
        my @FollowUp;
        for my $Line ( split "\n", $Email ) {
            if ( $Line =~ /^Subject:/ ) {
                $Line = 'Subject: ' . $TicketObject->TicketSubjectBuild(
                    TicketNumber => $TicketNumber,
                    Subject      => $Line,
                );
            }
            push @FollowUp, $Line;
        }
        my $NewEmail = join "\n", @FollowUp;

        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => 'Email',
                Direction => 'Incoming',
            },
        );
        $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

        my $PostMasterObject = Kernel::System::PostMaster->new(
            Email                  => \$NewEmail,
            CommunicationLogObject => $CommunicationLogObject,
        );

        my @Return = $PostMasterObject->Run();
        is(
            \@Return,
            [ 2, $TicketID ],
            "PostMaster()",
        );

        my @Articles = $ArticleObject->ArticleList(
            TicketID => $TicketID,
            OnlyLast => 1,
        );
        my %Article = $ArticleBackendObject->ArticleGet(
            TicketID  => $TicketID,
            ArticleID => $Articles[0]->{ArticleID},
        );

        my $CheckObject = Kernel::Output::HTML::ArticleCheck::PGP->new(
            ArticleID => $Article{ArticleID},
            UserID    => $TestUserID,
        );

        my @CheckResult = $CheckObject->Check( Article => \%Article );

        # Run check a second time to simulate repeated views.
        my @FirstCheckResult = @CheckResult;
        @CheckResult = $CheckObject->Check( Article => \%Article );

        is(
            \@FirstCheckResult,
            \@CheckResult,
            "CheckObject() stable",
        );

        if ( $Test->{VerifySignature} ) {
            my $SignatureVerified =
                grep {
                    $_->{Successful} && $_->{Key} eq 'Signed' && $_->{SignatureFound} && $_->{Message}
                } @CheckResult;

            ok( $SignatureVerified, "signature verified" );
        }

        if ( $Test->{VerifyDecryption} ) {
            my $DecryptionVerified =
                grep { $_->{Successful} && $_->{Key} eq 'Crypted' && $_->{Message} } @CheckResult;

            ok( $DecryptionVerified, "decryption verified" );
        }

        my %FinalArticleData = $ArticleBackendObject->ArticleGet(
            TicketID  => $TicketID,
            ArticleID => $Article{ArticleID},
        );

        my $TestBody = $Test->{ArticleData}->{Body};

        # convert test body to ASCII if it was HTML
        if ( $Test->{ArticleData}->{MimeType} eq 'text/html' ) {
            $TestBody = $HTMLUtilsObject->ToAscii(
                String => $TestBody,
            );
        }

        is(
            $FinalArticleData{Body},
            $TestBody,
            "verified body content",
        );

        if ( defined $Test->{ArticleData}->{Attachment} ) {
            my $Found;
            my %Index = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $Article{ArticleID},
            );

            TESTATTACHMENT:
            for my $Attachment ( @{ $Test->{ArticleData}->{Attachment} } ) {

                next TESTATTACHMENT if !$Attachment->{Filename};

                ATTACHMENTINDEX:
                for my $AttachmentIndex ( sort keys %Index ) {

                    if ( $Index{$AttachmentIndex}->{Filename} ne $Attachment->{Filename} ) {
                        next ATTACHMENTINDEX;
                    }

                    # when the attachment originally does not include a ContentID at create time is not
                    #   changed to '<>', it is still empty, also if the mail is just signed but not
                    #   encrypted, the attachment is not rewritten so it keeps without the surrounding
                    #   '<>'
                    my $ExpectedContentID = $Attachment->{ContentID};
                    if ( $Attachment->{ContentID} ) {
                        $ExpectedContentID = '<' . $Attachment->{ContentID} . '>';
                    }
                    is(
                        $Index{$AttachmentIndex}->{ContentID},
                        $ExpectedContentID,
                        "Attachment '$Attachment->{Filename}' ContentID",
                    );
                    $Found = 1;
                    last ATTACHMENTINDEX;
                }
                ok( $Found, "Attachment '$Attachment->{Filename}' was found" );
            }

            # Remove all attachments, then run CheckObject again to verify they are not written again.
            $ArticleBackendObject->ArticleDeleteAttachment(
                ArticleID => $Article{ArticleID},
                UserID    => 1,
            );

            $CheckObject->Check( Article => \%Article );

            %Index = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $Article{ArticleID},
            );
            ok(
                !scalar keys %Index,
                "Attachments not rewritten by ArticleCheck module"
            );
        }
    };
}

# delete PGP keys
for my $Count ( 1 .. 2 ) {
    my @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );
    ok( $Keys[0] || '', "Key:$Count - KeySearch()" );
    my $DeleteSecretKey = $PGPObject->SecretKeyDelete(
        Key => $Keys[0]->{KeyPrivate},
    );
    ok( $DeleteSecretKey, "Key:$Count - SecretKeyDelete()", );

    my $DeletePublicKey = $PGPObject->PublicKeyDelete(
        Key => $Keys[0]->{Key},
    );
    ok( $DeletePublicKey, "Key:$Count - PublicKeyDelete()" );

    @Keys = $PGPObject->KeySearch(
        Search => $Search{$Count},
    );
    ok( !$Keys[0], "Key:$Count - KeySearch()" );
}

# cleanup is done by RestoreDatabase.
done_testing();
