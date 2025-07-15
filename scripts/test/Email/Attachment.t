# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

# Email Attachments test purpose:
# 1) Create email
# 2) Add attachments
# 3) Verify Content-Type
# This UT referrer to Bug #7879, perldoc MIME::Entity, rfc2045.
#
# Correct:
# ----------------------------------------------------------------------------------------
# Content-Type: application/octet-stream; name="TESTBUILD-OTOBOAdminTypeServices-1.1.1.opm"
# Content-Disposition: inline; filename="TESTBUILD-OTOBOAdminTypeServices-1.1.1.opm"
# Content-Transfer-Encoding: base64
# ----------------------------------------------------------------------------------------
#
# Incorrect:
# ----------------------------------------------------------------------------------------
# Content-Type: application/octet-stream;
# name="TESTBUILD-OTOBOAdminTypeServices-1.1.1.opm"
# name="TESTBUILD-OTOBOAdminTypeServices-1.1.1.opm";
# Content-Disposition: inline; filename="TESTBUILD-OTOBOAdminTypeServices-1.1.1.opm"
# Content-Transfer-Encoding: base64
# ----------------------------------------------------------------------------------------

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::EmailParser ();

# get helper object
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

my $AttachmentReference = [
    {
        Filename    => 'csvfile.csv',
        Content     => 'empty',
        ContentType => 'text/csv',
    },
    {
        Filename    => 'pngfile.png',
        Content     => 'empty',
        ContentType => 'image/png; name=pngfile.png',
    },
    {
        Filename    => 'utf-8',
        Content     => 'empty',
        ContentType => 'text/html; charset="utf-8"',
    },
    {
        Filename    => 'dos',
        Content     => 'empty',
        ContentType => 'text/html; charset="dos"; name="utf"',
    },
    {
        Filename    => 'cp121',
        Content     => 'empty',
        ContentType => 'text/html; name="utf-7"; charset="cp121"',
    },
];

my $AttachmentNumber = scalar @{$AttachmentReference};

# do not really send emails
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# test scenarios. added only one attachment.
my @Tests = (
    {
        Name => 'HTML email.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            MimeType   => 'text/html',
            Charset    => 'utf8',
            Attachment => [
                {
                    Filename    => 'csvfile.csv',
                    Content     => 'empty',
                    ContentType => 'text/csv',
                },
                {
                    Filename    => 'pngfile.png',
                    Content     => 'empty',
                    ContentType => 'image/png; name=pngfile.png',
                },
                {
                    Filename    => 'utf-8',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="utf-8"',
                },
                {
                    Filename    => 'dos',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="dos"; name="utf"',
                },
                {
                    Filename    => 'cp121',
                    Content     => 'empty',
                    ContentType => 'text/html; name="utf-7"; charset="cp121"',
                },
            ],
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
        },
    },
    {
        Name => 'Text/plain email.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            MimeType   => 'text/plain',
            Charset    => 'utf8',
            Attachment => [
                {
                    Filename    => 'csvfile.csv',
                    Content     => 'empty',
                    ContentType => 'text/csv',
                },
                {
                    Filename    => 'pngfile.png',
                    Content     => 'empty',
                    ContentType => 'image/png; name=pngfile.png',
                },
                {
                    Filename    => 'utf-8',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="utf-8"',
                },
                {
                    Filename    => 'dos',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="dos"; name="utf"',
                },
                {
                    Filename    => 'cp121',
                    Content     => 'empty',
                    ContentType => 'text/html; name="utf-7"; charset="cp121"',
                },
            ],
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
        },
    },

    {
        Name => 'HTML email - Attachments grow up one.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            MimeType   => 'text/html',
            Charset    => 'utf8',
            Attachment => $AttachmentReference,
            MimeType   => 'text/html',
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
        },
        CheckAttachmentsSize => '1',
    },
    {
        Name => 'HTML email - Attachments grow up two.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            MimeType   => 'text/html',
            Charset    => 'utf8',
            Attachment => $AttachmentReference,
            MimeType   => 'text/html',
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
        },
        CheckAttachmentsSize => '1',
    },

);

# get email object
my $EmailObject     = $Kernel::OM->Get('Kernel::System::Email');
my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

my $SendEmail = sub {
    my %Param = @_;

    # Delete mail queue
    $MailQueueObject->Delete();

    # Generate the mail and queue it
    $EmailObject->Send( %Param, );

    # Get last item in the queue.
    my $Items = $MailQueueObject->List();
    $Items = [ sort { $b->{ID} <=> $a->{ID} } @{$Items} ];
    my $LastItem = $Items->[0];

    my $Result = $MailQueueObject->Send( %{$LastItem} );

    return ( \$LastItem->{Message}->{Header}, \$LastItem->{Message}->{Body}, );
};

# testing loop
for my $Test (@Tests) {

    # Send mail and get results as two string refs
    my ( $Header, $Body ) = $SendEmail->( %{ $Test->{Data} } );

    # check reference attachment size
    if ( $Test->{CheckAttachmentsSize} ) {

        my $CurrentAttachmentNumber = scalar @{$AttachmentReference};
        is(
            $AttachmentNumber,
            $CurrentAttachmentNumber,
            "AttachmentsSize: $Test->{Name} ",
        );
    }

    # standardize in case of strange output
    if ( !$Header || ref $Header ne 'SCALAR' ) {
        my $String = '';
        $Header = \$String;
    }
    if ( !$Body || ref $Body ne 'SCALAR' ) {
        my $String = '';
        $Body = \$String;
    }

    # Test whether the constructed email conserves
    # the content type associated with the file name.
    # For that extract the Content-Type of the attachments.
    # The attachments are contained in the body of the email.
    {
        my %Filename2ContentType;
        for my $Header ( split /\n/, $Body->$* ) {

            # Look at lines like:
            #   Content-Type: text/csv; name="csvfile.csv"
            if ( $Header =~ /^Content\-Type\:\ .*?\;.*?\"(.*?)\"/x ) {
                ( undef, $Filename2ContentType{$1} ) = split /: /, $Header;
            }
        }

        # Final check Content-Type from Email Send
        for my $Name (@Tests) {
            for my $Attach ( @{ $Name->{Data}->{Attachment} } ) {
                is(
                    $Filename2ContentType{ $Attach->{Filename} },
                    $Name->{ExpectedResults}->{ $Attach->{Filename} }
                        . '; name="' . $Attach->{Filename} . '"',
                    "EmailSend: $Name->{Name} ",
                );
            }
        }
    }

    # Repeat the check of whether the email conserves the content type
    # ot the attachments
    # This time look at the mail as parsed with Kernel::Syste,::EmailParaer
    my %Filename2ContentType;
    {
        my $Email        = join "\n", $Header->$*, $Body->$*;
        my @Array        = split /\n/, $Email;    # newlines are removed
        my $ParserObject = Kernel::System::EmailParser->new(
            Email => \@Array,
        );

        # The body of the mail contains the MIME headers of the attachments.
        # $ParserObject->{Email} is a Mail::Internet,
        # The body still has the lines without trailing newlines.
        my $Headers = $ParserObject->{Email}->{'mail_inet_body'};
        for my $Header ( @{$Headers} ) {
            if ( $Header =~ /^Content\-Type\:\ .*?\;.*?\"(.*?)\"/x ) {
                ( undef, $Filename2ContentType{$1} ) = split /: /, $Header;
            }
        }
    }

    # Final check Content-Type from EmailParser
    for my $Name (@Tests) {
        for my $Attach ( @{ $Name->{Data}->{Attachment} } ) {
            is(
                $Filename2ContentType{ $Attach->{Filename} },
                $Name->{ExpectedResults}->{ $Attach->{Filename} }
                    . qq{; name="$Attach->{Filename}"},
                "EmailParser: $Name->{Name} ",
            );
        }
    }

}

done_testing;
