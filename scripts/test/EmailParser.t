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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use MIME::Parser ();
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::EmailParser ();

# get main object
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

subtest 'test PostMaster-Test1.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test1.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    # create local object
    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        'darthvader@otobo.org',
        "GetParam(WHAT => 'To')",
    );

    is(
        $EmailParserObject->GetParam( WHAT => 'From' ),
        'Skywalker Attachment <skywalker@otobo.org>',
        "GetParam(WHAT => 'From')",
    );

    is(
        $EmailParserObject->GetCharset(),
        'us-ascii',
        "GetCharset()",
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    ok(
        !$Attachments[1]->{Filename},
        "GetAttachments() - no attachments",
    );
};

subtest 'static methods' => sub {

    # as stand alone mode, without parsing emails
    my $EmailParserObject = Kernel::System::EmailParser->new(
        Mode  => 'Standalone',
        Debug => 0,
    );

    my @Addresses = $EmailParserObject->SplitAddressLine(
        Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber),
        Juergen "quoted name" Weber <juergen.qeber@air.com>',
    );

    is(
        $Addresses[2],
        'hans@example.com (Hans Huber)',
        "SplitAddressLine()",
    );

    is(
        $Addresses[3],
        'Juergen "quoted name" Weber <juergen.qeber@air.com>',
        "SplitAddressLine() with quoted name",
    );

    is(
        $EmailParserObject->GetEmailAddress( Email => 'Juergen Weber <juergen.qeber@air.com>' ),
        'juergen.qeber@air.com',
        "GetEmailAddress()",
    );

    is(
        $EmailParserObject->GetEmailAddress( Email => 'Juergen Weber <juergen+qeber@air.com>' ),
        'juergen+qeber@air.com',
        "GetEmailAddress() again",
    );

    is(
        $EmailParserObject->GetEmailAddress(
            Email => 'Juergen Weber <juergen+qeber@air.com> (Comment)'
        ),
        'juergen+qeber@air.com',
        "GetEmailAddress() with comment",
    );

    is(
        $EmailParserObject->GetEmailAddress( Email => 'juergen+qeber@air.com (Comment)' ),
        'juergen+qeber@air.com',
        "GetEmailAddress() with comment again",
    );

    is(
        $EmailParserObject->GetRealname( Email => '"Juergen "quoted name" Weber" <juergen.qeber@air.com>' ),
        'Juergen "quoted name" Weber',
        "GetRealname() with quoted name",
    );

    is(
        $EmailParserObject->GetRealname( Email => '"Juergen " quoted name " Weber" <juergen.qeber@air.com>' ),
        'Juergen "quoted name" Weber',
        "GetRealname() with quoted name",
    );
};

subtest 'PostMaster-Test3.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test3.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'utf-8',    # automatically converted
        "GetCharset()",
    );
    my @Attachments = $EmailParserObject->GetAttachments();
    my $MD5         = $MainObject->MD5sum( String => $Attachments[1]->{Content} ) || '';
    is(
        $MD5,
        '4e78ae6bffb120669f50bca56965f552',
        "md5 check",
    );
    is(
        $Attachments[1]->{Filename},
        'utf-8-file-äöüß-カスタマ.txt',
        "GetAttachments()",
    );
};

subtest 'PostMaster-Test4.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test4.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close($IN);

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'iso-8859-15',
        "GetCharset()",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'From' ),
        'Hans BÄKOSchönland <me@bogen.net>',
        "From()",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        'Namedyński (hans@example.com)',
        "To()",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'Subject' ),
        'utf8: 使って / ISO-8859-1: Priorität"  / cp-1251: Сергей Углицких',
        "Subject()",
    );

    # match values
    my %Match = (
        "Test1:" . chr(8211)              => 0,
        "Test2:&"                         => 0,
        "Test3:" . chr(8715)              => 0,
        "Test4:&"                         => 0,
        "Test5:" . chr( hex("3d") )       => 0,
        "Compare Cable, DSL or Satellite" => 0,
    );
    for my $Key ( sort keys %Match ) {
        if ( $EmailParserObject->GetMessageBody() =~ /$Key/ ) {
            $Match{$Key} = 1;
        }
        ok(
            $Match{$Key},
            "html2ascii - Body match - $Key",
        );
    }

    # match values not
    my %MatchNot = (
        "style"      => 0,
        "background" => 0,
        "br"         => 0,
        "div"        => 0,
        "html"       => 0,
    );
    for my $Key ( sort keys %MatchNot ) {
        if ( $EmailParserObject->GetMessageBody() !~ /$Key/ ) {
            $MatchNot{$Key} = 1;
        }
        ok(
            $MatchNot{$Key},
            "html2ascii - Body match not - $Key",
        );
    }
};

subtest 'PostMaster-Test5.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test5.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'utf-8',    # automatically converted
        "GetCharset()",
    );
    my @Attachments = $EmailParserObject->GetAttachments();
    my $MD5         = $MainObject->MD5sum( String => $Attachments[1]->{Content} ) || '';
    is(
        $MD5,
        'd2288c4aa6a50bc41a0e9b8820495922',
        "md5 check",
    );
    is(
        $Attachments[1]->{Filename},
        'test-attachment-äöüß-iso-8859-1.txt',
        "GetAttachments()",
    );
    is(
        $Attachments[1]->{ContentAlternative} || '',
        '',
        "ContentAlternative check",
    );
    $MD5 = $MainObject->MD5sum( String => $Attachments[2]->{Content} ) || '';
    is(
        $MD5,
        'bb29962e132ba159539f1e88b41663b1',
        "md5 check",
    );
    is(
        $Attachments[2]->{Filename},
        'test-attachment-äöüß-utf-8.txt',
        "GetAttachments()",
    );
    $MD5 = $MainObject->MD5sum( String => $Attachments[3]->{Content} ) || '';
    is(
        $MD5,
        '5ee767f3b68f24a9213e0bef82dc53e5',
        "md5 check",
    );
    is(
        $Attachments[3]->{Filename},
        'test-attachment-äöüß.pdf',
        "GetAttachments()",
    );
};

subtest 'PostMaster-Test6.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test6.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'utf-8',
        "GetCharset()",
    );
    my @Attachments = $EmailParserObject->GetAttachments();
    my $MD5         = $MainObject->MD5sum( String => $Attachments[1]->{Content} ) || '';
    is(
        $MD5,
        '5ee767f3b68f24a9213e0bef82dc53e5',
        "md5 check",
    );
    is(
        $Attachments[1]->{Filename},
        'test-attachment-äöüß.pdf',
        "GetAttachments()",
    );

    $MD5 = $MainObject->MD5sum( String => $Attachments[2]->{Content} ) || '';
    is(
        $MD5,
        'bb29962e132ba159539f1e88b41663b1',
        "md5 check",
    );
    is(
        $Attachments[2]->{Filename},
        'test-attachment-äöüß-utf-8.txt',
        "GetAttachments()",
    );

    $MD5 = $MainObject->MD5sum( String => $Attachments[3]->{Content} ) || '';
    is(
        $MD5,
        '0596f2939525c6bd50fc2b649e40fbb6',
        "md5 check",
    );
    is(
        $Attachments[3]->{Filename},
        'test-attachment-äöüß-iso-8859-1.txt',
        "GetAttachments()",
    );
};

subtest 'PostMaster-Test7.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test7.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'utf-8',    # automatically converted
        "GetCharset()",
    );
    my @Attachments = $EmailParserObject->GetAttachments();
    my $MD5         = $MainObject->MD5sum( String => $Attachments[1]->{Content} ) || '';
    is(
        $MD5,
        '5ee767f3b68f24a9213e0bef82dc53e5',
        "md5 check",
    );
    is(
        $Attachments[1]->{Filename},
        'test-attachment-äöüß.pdf',
        "GetAttachments()",
    );
    $MD5 = $MainObject->MD5sum( String => $Attachments[2]->{Content} ) || '';
    is(
        $MD5,
        'bb29962e132ba159539f1e88b41663b1',
        "md5 check",
    );
    is(
        $Attachments[2]->{Filename},
        'test-attachment-äöüß-utf-8.txt',
        "GetAttachments()",
    );
    $MD5 = $MainObject->MD5sum( String => $Attachments[3]->{Content} ) || '';
    is(
        $MD5,
        '0596f2939525c6bd50fc2b649e40fbb6',
        "md5 check",
    );
    is(
        $Attachments[3]->{Filename},
        'test-attachment-äöüß-iso-8859-1.txt',
        "GetAttachments()",
    );
};

subtest 'PostMaster-Test8.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test8.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        '',
        "GetCharset() - no charset should be found (non text body)",
    );

    my $Body        = $EmailParserObject->GetMessageBody();
    my @Attachments = $EmailParserObject->GetAttachments();
    my $MD5         = $MainObject->MD5sum( String => $Body ) || '';

    is(
        $MD5,
        '5ee767f3b68f24a9213e0bef82dc53e5',
        "md5 check",
    );

    ok(
        !$Attachments[0] || 0,
        "no attachment check",
    );
};

subtest 'PostMaster-Test9.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test9.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'us-ascii',
        "GetCharset() - us-ascii charset should be found",
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    my $MD5         = $MainObject->MD5sum( String => $Attachments[0]->{Content} ) || '';

    is(
        $MD5,
        '5ee767f3b68f24a9213e0bef82dc53e5',
        "md5 check",
    );

    ok(
        $Attachments[0] || 0,
        "attachment check #1",
    );

    ok(
        !$Attachments[1] || 0,
        "attachment check #2",
    );
};

subtest 'PostMaster-Test10.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test10.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'iso-8859-1',
        "GetCharset() - iso-8859-1 charset should be found",
    );

    my $MD5 = $MainObject->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
    is(
        $MD5,
        '4e269fc57c9aa7861ad432607e660ae9',
        "md5 body check",
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    $MD5 = $MainObject->MD5sum( String => $Attachments[0]->{Content} ) || '';
    is(
        $MD5,
        '4e269fc57c9aa7861ad432607e660ae9',
        "md5 check",
    );

    ok(
        $Attachments[0] || 0,
        "attachment check #1",
    );

    ok(
        $Attachments[1] || 0,
        "attachment check #2",
    );

    ok(
        $Attachments[2] || 0,
        "attachment check #3",
    );

    ok(
        !$Attachments[3] || 0,
        "attachment check #4",
    );
};

subtest 'PostMaster-Test11.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test11.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'ISO-8859-1',
        "GetCharset() - iso-8859-1 charset should be found",
    );

    my $MD5 = $MainObject->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
    is(
        $MD5,
        '52f20c90a1f0d8cf3bd415e278992001',
        "md5 body check",
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    ok(
        !$Attachments[0] || 0,
        "attachment check #0",
    );
};

subtest 'PostMaster-Test12.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test12.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'utf-8',    # automatically converted
        "GetCharset() - iso-8859-1 charset should be found",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        '金田　美羽 <support@example.com>',
        "GetParam(WHAT => 'To')",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'Cc' ),
        '張雅惠 <support2@example.com>, "문화연대" <support3@example.com>',
        "GetParam(WHAT => 'Cc')",
    );

    my $MD5 = $MainObject->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
    is(
        $MD5,
        '603c11a38065909cc13bf53c650506c1',
        "md5 body check",
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    $MD5 = $MainObject->MD5sum( String => $Attachments[1]->{Content} ) || '';
    is(
        $MD5,
        'ecfbec2030e6bf91cc97ed22f7c6551a',
        "md5 check",
    );
    is(
        $Attachments[1]->{Filename} || '',
        'attachment-äöüß-utf8.txt',
        "Filename check",
    );
    $MD5 = $MainObject->MD5sum( String => $Attachments[2]->{Content} ) || '';
    is(
        $MD5,
        'b25beeea18c52cdc791864b52862743e',
        "md5 check",
    );
    is(
        $Attachments[2]->{Filename} || '',
        'attachment-äöüß-iso.txt',
        "Filename check",
    );
    $MD5 = $MainObject->MD5sum( String => $Attachments[3]->{Content} ) || '';
    is(
        $MD5,
        'f287d0dd6d0f90da4ac69348b09ec281',
        "md5 check",
    );
    is(
        $Attachments[3]->{Filename} || '',
        'Обяснительная.jpg',
        "Filename check",
    );
    $MD5 = $MainObject->MD5sum( String => $Attachments[4]->{Content} ) || '';
    is(
        $MD5,
        'f287d0dd6d0f90da4ac69348b09ec281',
        "md5 check",
    );
    is(
        $Attachments[4]->{Filename} || '',
        'Сообщение.jpg',
        "Filename check",
    );
    is(
        $Attachments[5]->{Filename} || '',
        '報告書_..txt',
        "Filename check",
    );
    is(
        $Attachments[6]->{Filename} || '',
        '金田_美羽',
        "Filename check",
    );
    is(
        $Attachments[7]->{Filename} || '',
        '國科會50科學之旅活動計畫徵求書_r_final_.doc',
        "Filename check",
    );
    is(
        $Attachments[8]->{Filename} || '',
        '2차_보도자료.hwp',
        "Filename check",
    );
    ok(
        !$Attachments[9] || 0,
        "attachment check #0",
    );
};

subtest 'PostMaster-Test13.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test13.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        '',
        "GetCharset() - no charset should be found",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        'support@example.com',
        "GetParam(WHAT => 'To')",
    );
    my $MD5 = $MainObject->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
    is(
        $MD5,
        '474f97c23688e88edfb70139d5658e01',
        "md5 body check",
    );
};

subtest 'PostMaster-Test14.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test14.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'UTF-8',
        "GetCharset() - no charset should be found",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        'security@example.org',
        "GetParam(WHAT => 'To')",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'From' ),
        '"VIAGRA � Official Site" <security@example.org>',
        "GetParam(WHAT => 'From')",
    );
    my $MD5 = $MainObject->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
    is(
        $MD5,
        'b8b01a1acd8fe7efeff8351bf48d8f63',
        "md5 body check",
    );
};

subtest 'PostMaster-Test16.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test16.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'ISO-8859-1',
        "GetCharset() - iso-8859-1 charset should be found",
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    my $MD5         = $MainObject->MD5sum( String => $Attachments[1]->{Content} ) || '';
    is(
        $MD5,
        '9a7c5ce111d1ec69e1625d51abba0442',
        "md5 check",
    );
    is(
        $Attachments[0]->{ContentAlternative} || '',
        1,
        "ContentAlternative check",
    );
    is(
        $Attachments[1]->{ContentAlternative} || '',
        1,
        "ContentAlternative check",
    );

    # content type tests
    my @Tests = (
        {
            ContentType => 'Content-Type: text/plain; charset="iso-8859-1"; charset="iso-8859-1"',
            Charset     => 'iso-8859-1',
            MimeType    => 'text/plain',
        },
        {
            ContentType => 'Content-Type: text/plain; charset="iso-8859-1"',
            Charset     => 'iso-8859-1',
            MimeType    => 'text/plain',
        },
        {
            ContentType => 'Content-Type: text/xls-2; charset="iso-8859-1";',
            Charset     => 'iso-8859-1',
            MimeType    => 'text/xls-2',
        },
        {
            ContentType => 'Content-Type: text/plain; charset="iso-8859-1"; format=flowed',
            Charset     => 'iso-8859-1',
            MimeType    => 'text/plain',
        },
        {
            ContentType => 'Content-Type: text/plain; charset="utf8"; format=flowed',
            Charset     => 'utf8',
            MimeType    => 'text/plain',
        },
        {
            ContentType => 'Content-Type: text/plain; charset=iso-8859-1',
            Charset     => 'iso-8859-1',
            MimeType    => 'text/plain',
        },
        {
            ContentType => 'Content-Type: text/plain; charset=\'iso-8859-1\'',
            Charset     => 'iso-8859-1',
            MimeType    => 'text/plain',
        },
        {
            ContentType => 'Content-Type:text/plain; charset=\'iso-8859-1\'',
            Charset     => 'iso-8859-1',
            MimeType    => 'text/plain',
        },
        {
            ContentType => 'Content-Type: text/plain; charset = "utf8"; format=flowed',
            Charset     => 'utf8',
            MimeType    => 'text/plain',
        },
    );

    for my $Test (@Tests) {
        my %Data = $EmailParserObject->GetContentTypeParams(
            ContentType => $Test->{ContentType},
        );
        is(
            $Data{Charset},
            $Test->{Charset},
            "ContentType - Charset check",
        );
        is(
            $Data{MimeType},
            $Test->{MimeType},
            "MimeType - Charset check",
        );
    }
};

subtest 'PostMaster-Test19.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test19.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );
    is(
        $EmailParserObject->GetCharset(),
        'iso-8859-1',
        "GetCharset() - iso-8859-1 charset should be found",
    );

    #test #18
    my $ContentType = qq(Content-Type: text/html; charset="iso-8859-1"; charset="iso-8859-1");
    my %Data        = $EmailParserObject->GetContentTypeParams(
        ContentType => $ContentType,
    );
    is(
        $Data{Charset},
        'iso-8859-1',
        "ContentType - iso-8859-1 charset should be found",
    );
};

subtest 'PostMaster-Test20.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test20.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    my $ContentLocation;

    ATTACHMENT:
    for my $Attachment (@Attachments) {
        next ATTACHMENT if $Attachment->{ContentType} ne 'image/bmp; name="ole0.bmp"';
        $ContentLocation = $Attachment->{ContentID};
    }

    is(
        $ContentLocation,
        'Untitled%20Attachment',
        "Get Content-Location",
    );
};

subtest 'PostMaster-Test21.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test21.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        'Евгений Васильев Новоподзалупинский <xxzzyy@gmail.com>',
        "GetParam(WHAT => 'To' Multiline encode quote printable)",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'Subject' ),
        'Евгений Васильев Новоподзалупинский <xxzzyy@gmail.com>',
        "GetParam(WHAT => 'Subject' Multiline encode quote printable)",
    );
};

subtest 'PostMaster-Test22.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/PostMaster-Test22.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        'QBQB Евгений Васильев Новоподзалупинский <xxzzyy@gmail.com>',
        "GetParam(WHAT => 'To' Multiline encode)",
    );
    is(
        $EmailParserObject->GetParam( WHAT => 'Subject' ),
        'QBQB Евгений Васильев Новоподзалупинский <xxzzyy@gmail.com>',
        "GetParam(WHAT => 'Subject' Multiline encode)",
    );
};

subtest 'UTF-7.box' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/UTF-7.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    is(
        $EmailParserObject->GetParam( WHAT => 'To' ),
        'wop+autoreply=no@ticket.noris.net',
        "GetParam(WHAT => 'To') UTF-7 not decoded",
    );
};

subtest 'UTF-7.box again' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/UTF-7.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    is(
        $EmailParserObject->GetParam( WHAT => 'Envelope-To' ),
        'wop+autoreply=no@ticket.noris.net',
        "GetParam(WHAT => 'Envelope-To') UTF-7 not decoded",
    );
};

subtest 'UTF-7.box MIME::Parser' => sub {
    open( my $IN, '<', "$Home/scripts/test/sample/EmailParser/UTF-7.box" );    ## no critic qw(OTOBO::ProhibitOpen)
    my @Array = <$IN>;
    close $IN;

    my $Parser = MIME::Parser->new();

    # prevents writing to filesystem
    $Parser->output_to_core(1);
    my $Entity            = $Parser->parse_data( \@Array );
    my $EmailParserObject = Kernel::System::EmailParser->new(
        Entity => $Entity,
    );

    is(
        $EmailParserObject->GetParam( WHAT => 'Envelope-To' ),
        'wop+autoreply=no@ticket.noris.net',
        "GetParam(WHAT => 'Envelope-To') usage of EmailParser in Entity mode",
    );
};

done_testing;
