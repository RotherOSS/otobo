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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Email::Send creates queue entries, but no transport is executed in this test.
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my $EmailObject     = $Kernel::OM->Get('Kernel::System::Email');
my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

my $HeaderValue = sub {
    my ( $Header, $Name ) = @_;
    if ( $Header =~ /^\Q$Name\E:\s*(.*?)\s*$/mi ) {
        return $1;
    }
    return;
};

my %EmailParams = (
    From     => 'sender@example.test',
    To       => 'recipient@example.test',
    Subject  => 'Message-ID domain test',
    Body     => 'Message-ID domain test',
    Charset  => 'UTF-8',
    MimeType => 'text/plain',
);

my $FQDN = $ConfigObject->Get('FQDN');
for my $MessageIDDomain ( undef, '' ) {
    $ConfigObject->Set(
        Key   => 'MessageIDDomain',
        Value => $MessageIDDomain,
    );

    my $FallbackLabel = defined $MessageIDDomain ? 'empty' : 'unset';
    my $FallbackSend  = $EmailObject->Send(%EmailParams);
    ok( $FallbackSend->{Success}, "Send succeeds with an $FallbackLabel MessageIDDomain" );
    like(
        $HeaderValue->( $FallbackSend->{Data}->{Header}, 'Message-ID' ),
        qr/\@\Q$FQDN\E>/,
        "Generated Message-ID falls back to FQDN when MessageIDDomain is $FallbackLabel",
    );
}

my $MessageIDDomain = 'message-id.example.test';
$ConfigObject->Set(
    Key   => 'MessageIDDomain',
    Value => $MessageIDDomain,
);

my $ConfiguredSend = $EmailObject->Send(%EmailParams);
like(
    $HeaderValue->( $ConfiguredSend->{Data}->{Header}, 'Message-ID' ),
    qr/\@\Q$MessageIDDomain\E>/,
    'Generated Message-ID uses MessageIDDomain',
);

my $ExplicitMessageID = '<provided@example.test>';
my $ExplicitSend      = $EmailObject->Send(
    %EmailParams,
    'Message-ID' => $ExplicitMessageID,
);
is(
    $HeaderValue->( $ExplicitSend->{Data}->{Header}, 'Message-ID' ),
    $ExplicitMessageID,
    'Send preserves an explicitly supplied Message-ID',
);

my $BounceEmail = <<'EOF';
From: original@example.test
To: sender@example.test
Message-ID: <original@example.test>
Subject: Original message

Original body
EOF

my $GeneratedBounce = $EmailObject->Bounce(
    From  => 'sender@example.test',
    To    => 'recipient@example.test',
    Email => $BounceEmail,
);
is(
    $HeaderValue->( $GeneratedBounce->{Data}->{Header}, 'Message-ID' ),
    '<original@example.test>',
    'Bounce preserves the original Message-ID',
);
like(
    $HeaderValue->( $GeneratedBounce->{Data}->{Header}, 'Resent-Message-ID' ),
    qr/\@\Q$MessageIDDomain\E>/,
    'Generated Resent-Message-ID uses MessageIDDomain',
);

my $ExplicitResentMessageID = '<provided-bounce@example.test>';
my $ExplicitBounce          = $EmailObject->Bounce(
    From         => 'sender@example.test',
    To           => 'recipient@example.test',
    Email        => $BounceEmail,
    'Message-ID' => $ExplicitResentMessageID,
);
is(
    $HeaderValue->( $ExplicitBounce->{Data}->{Header}, 'Resent-Message-ID' ),
    $ExplicitResentMessageID,
    'Bounce preserves an explicitly supplied Message-ID',
);

$MailQueueObject->Delete();

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $TicketID     = $TicketObject->TicketCreate(
    Title        => 'Message-ID domain test',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.test',
    OwnerID      => 1,
    UserID       => 1,
);
ok( $TicketID, 'Create ticket for ArticleSend and ArticleBounce' );

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');
my $ArticleID            = $ArticleBackendObject->ArticleSend(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'sender@example.test',
    To                   => 'recipient@example.test',
    Subject              => 'Message-ID domain article test',
    Body                 => 'Message-ID domain article test',
    Charset              => 'UTF-8',
    MimeType             => 'text/plain',
    HistoryType          => 'SendAnswer',
    HistoryComment       => 'Message-ID domain test',
    UserID               => 1,
);
ok( $ArticleID, 'ArticleSend creates an article' );

my %Article = $ArticleBackendObject->ArticleGet(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
);
my $QueuedItems = $MailQueueObject->List();
my ($ArticleQueueItem) = grep {
    $_->{ArticleID} && $_->{ArticleID} == $ArticleID
} @{$QueuedItems};
ok( $ArticleQueueItem, 'ArticleSend queues the email' );
if ($ArticleQueueItem) {
    my $QueuedMessageID = $HeaderValue->( $ArticleQueueItem->{Message}->{Header}, 'Message-ID' );
    is( $Article{MessageID}, $QueuedMessageID, 'Stored and queued Message-IDs match' );
    like( $QueuedMessageID, qr/\@\Q$MessageIDDomain\E>/, 'ArticleSend uses MessageIDDomain' );
}

$MailQueueObject->Delete();

my $OriginalMessageID = $Article{MessageID};
my $BounceSuccess     = $ArticleBackendObject->ArticleBounce(
    From      => 'sender@example.test',
    To        => 'bounce@example.test',
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    UserID    => 1,
);
ok( $BounceSuccess, 'ArticleBounce queues a bounce' );

my %ArticleAfterBounce = $ArticleBackendObject->ArticleGet(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
);
is( $ArticleAfterBounce{MessageID}, $OriginalMessageID, 'ArticleBounce does not change the original article ID' );

$QueuedItems = $MailQueueObject->List();
my ($ArticleBounceQueueItem) = grep {
    $_->{Message}->{Header} =~ /^Resent-To:\s*bounce\@example\.test\s*$/mi
} @{$QueuedItems};
ok( $ArticleBounceQueueItem, 'ArticleBounce queues the resent email' );
if ($ArticleBounceQueueItem) {
    my $Header = $ArticleBounceQueueItem->{Message}->{Header};
    is( $HeaderValue->( $Header, 'Message-ID' ), $OriginalMessageID, 'ArticleBounce preserves the original Message-ID header' );
    like(
        $HeaderValue->( $Header, 'Resent-Message-ID' ),
        qr/\@\Q$MessageIDDomain\E>/,
        'ArticleBounce uses MessageIDDomain for Resent-Message-ID',
    );
}

done_testing;
