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
use Test2::V0;
use MIME::Base64 qw(encode_base64);

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::PostMaster ();

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'PostMaster::CheckFollowUpModule',
    Value => {
        '0400-Attachments' => {
            Module => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
        }
    }
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
FixedTimeSet();

my $AgentAddress    = 'agent@example.com';
my $CustomerAddress = 'external@example.com';
my $InternalAddress = 'internal@example.com';

# create a new ticket
my $NewTicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'external@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

ok( $NewTicketID, 'TicketCreate()' );

my %Ticket = $TicketObject->TicketGet(
    TicketID => $NewTicketID,
    UserID   => 1,
);

my $Subject = $TicketObject->TicketSubjectBuild(
    TicketNumber => $Ticket{TicketNumber},
    Subject      => 'test',
);
ok( index( $Subject, $Ticket{TicketNumber} ) > -1, 'The subject contains the ticket number' );

# filter test
# As a reminder, here are the return codes from Kernel::System::PostMaster::Run():
#     0 = error (also undefined)
#     1 = new ticket created
#     2 = follow up / open/reopen
#     3 = follow up / close -> new ticket
#     4 = follow up / close -> reject
#     5 = ignored (because of X-OTOBO-Ignore header)
my @Tests = (
    {
        Name  => 'Ticket number in body, no attachments (new ticket)',
        Email => <<"END_EML",
From: Customer <$CustomerAddress>
To: Agent <$AgentAddress>
Subject: Test

Some Content in Body
$Subject
END_EML
        ExpectedRetCode => 1,    # not a follow up
    },

    {
        Name  => 'Ticket number in body of HTML email, no attachments (new ticket)',
        Email => <<"END_EML",
From: Customer <$CustomerAddress>
To: Agent <$AgentAddress>
Content-Type: text/html; charset="iso-8859-1"; format=flowed
Subject: Test

Some Content in Body<br/>
$Subject
END_EML
        ExpectedRetCode => 1,    # not a follow up
    },

    {
        Name  => 'Plain email, ticket number in body, attachment without ticket number (new ticket)',
        Email => <<"END_EML",
Date: Thu, 21 Jun 2012 17:06:27 +0200
From: "Peter Pruchnerovic - MALL.cz" <peter.pruchnerovic\@mall.cz>
MIME-Version: 1.0
To: testqueue\@mall.cz
Subject: TRT
Content-Type: multipart/mixed;
 boundary="------------060303050306010608070702"

This is a multi-part message in MIME format.
--------------060303050306010608070702
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

$Subject

--------------060303050306010608070702
Content-Type: text/plain;
 name="test.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="test.txt"

Some text
--------------060303050306010608070702
END_EML
        ExpectedRetCode => 1,    # not a follow up
    },

    {
        Name  => 'Plain email, attachment with ticket number',
        Email => <<"END_EML",
Date: Thu, 21 Jun 2012 17:06:27 +0200
From: "Peter Pruchnerovic - MALL.cz" <peter.pruchnerovic\@mall.cz>
MIME-Version: 1.0
To: testqueue\@mall.cz
Subject: TRT
Content-Type: multipart/mixed;
 boundary="------------060303050306010608070702"

This is a multi-part message in MIME format.
--------------060303050306010608070702
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Test message body

--------------060303050306010608070702
Content-Type: text/plain;
 name="test.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="test.txt"

$Subject
--------------060303050306010608070702
END_EML
        ExpectedRetCode => 2,    # follow up
    },

    {
        Name  => 'HTML email, body with ticket number',
        Email => <<"END_EML",
Content-Type: multipart/alternative; boundary="Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10"
Subject: test multipart/mixed HTML
Date: Fri, 9 Sep 2016 09:03:57 +0200
To: test\@home.com
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
X-Mailer: Apple Mail (2.3124)


--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
    charset=utf-8

$Subject

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Type: multipart/mixed;
    boundary="Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655"


--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
    charset=us-ascii

<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class="">$Subject<div class=""><br class=""></div><div class=""></div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Disposition: attachment;
    filename=1.txt
Content-Type: text/plain;
    name="1.txt"
Content-Transfer-Encoding: 7bit

1

--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 8bit
Content-Type: text/html;
    charset=utf-8

<html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""></div><div class=""><br class=""></div><div class="">$Subject</div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655--

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10--

END_EML
        ExpectedRetCode => 1,    # not a follow up
    },

    {
        Name  => 'HTML email, attachment with ticket number',
        Email => <<"END_EML",
Content-Type: multipart/alternative; boundary="Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10"
Subject: test multipart/mixed HTML
Date: Fri, 9 Sep 2016 09:03:57 +0200
To: test\@home.com
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
X-Mailer: Apple Mail (2.3124)


--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
    charset=utf-8

first part

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Type: multipart/mixed;
    boundary="Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655"


--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
    charset=us-ascii

<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class="">first part<div class=""><br class=""></div><div class=""></div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Disposition: attachment;
    filename=1.txt
Content-Type: text/plain;
    name="1.txt"
Content-Transfer-Encoding: 7bit

$Subject

--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 8bit
Content-Type: text/html;
    charset=utf-8

<html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""></div><div class=""><br class=""></div><div class="">second part</div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655--

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10--

END_EML
        ExpectedRetCode => 2,    # follow up
    },

    # Tests where there is first a CSV attachment and then the HTML body
    {
        # FollowUp is detected because the ticket number is in the part that is marked as attachment
        Name            => 'first CSV attachment with ticket number, then HTML',
        ExpectedRetCode => 2,                                                      # follow up
        Email           => <<"END_EML",
Content-Type: multipart/mixed; boundary="------------H1Sv6GUVtxR7USkdsEdBLUc0"
Message-ID: <40af3c51-db15-479d-99e9-69f848acacea\@gmx.de>
Date: Thu, 7 Aug 2025 15:15:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Andy Admin <Andy.Admin\@gmx.de>
From: Tina Tester <Tina.Tester\@gmx.de>
Subject: Sample of first CSV attachment and then HTML

This is a multi-part message in MIME format.
--------------H1Sv6GUVtxR7USkdsEdBLUc0
Content-Type: text/csv; charset=UTF-8; name="sample_csv.csv"
Content-Disposition: attachment; filename="sample_csv.csv"
Content-Transfer-Encoding: base64

@{[ encode_base64( join "\n", 'key1,value1', "subject,$Subject", 'key3,value3', '') ]}

--------------H1Sv6GUVtxR7USkdsEdBLUc0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><b>bold</b></p>
    <p><font color="#33d17a">green</font><br>
    </p>
  </body>
</html>
--------------H1Sv6GUVtxR7USkdsEdBLUc0--
END_EML
    },
    {
        # FollowUp is not detected because the ticket number is not in the part that is marked as attachment
        Name            => 'first CSV attachment, then HTML with ticket number',
        ExpectedRetCode => 1,                                                      # not a follow up
        Email           => <<"END_EML",
Content-Type: multipart/mixed; boundary="------------H1Sv6GUVtxR7USkdsEdBLUc0"
Message-ID: <40af3c51-db15-479d-99e9-69f848acacea\@gmx.de>
Date: Thu, 7 Aug 2025 15:15:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Andy Admin <Andy.Admin\@gmx.de>
From: Tina Tester <Tina.Tester\@gmx.de>
Subject: Sample of first CSV attachment and then HTML

This is a multi-part message in MIME format.
--------------H1Sv6GUVtxR7USkdsEdBLUc0
Content-Type: text/csv; charset=UTF-8; name="sample_csv.csv"
Content-Disposition: attachment; filename="sample_csv.csv"
Content-Transfer-Encoding: base64

@{[ encode_base64( join "\n", 'key1,value1', 'subject,no_tn_in_subject', 'key2,value3', '') ]}

--------------H1Sv6GUVtxR7USkdsEdBLUc0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><b>bold</b></p>
    <p><font color="#33d17a">green</font><br>
    </p>
    Subject: $Subject
  </body>
</html>
--------------H1Sv6GUVtxR7USkdsEdBLUc0--
END_EML
    },
);

# Run the tests
for my $Test (@Tests) {
    my ( $RetCode, $RetTicketID );
    {
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
            Email                  => \$Test->{Email},
            Debug                  => 2,
        );

        ( $RetCode, $RetTicketID ) = $PostMasterObject->Run();

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }
    is(
        $RetCode || 0,
        $Test->{ExpectedRetCode},
        "$Test->{Name} - got expected return code",
    );

    if ( $Test->{ExpectedRetCode} == 1 ) {

        isnt(
            $RetTicketID || 0,
            $Ticket{TicketID},
            "$Test->{Name} - new ticket created",
        );
    }
    else {
        is(
            $RetTicketID || 0,
            $Ticket{TicketID},
            "$Test->{Name} - follow-up created",
        );

    }
}

done_testing;
