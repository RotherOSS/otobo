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
use MIME::Base64 qw(encode_base64);

# OTOBO modules
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
        '0300-Body' => {
            Module => 'Kernel::System::PostMaster::FollowUpCheck::Body',
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

# create a new ticket
my $NewTicketID = $TicketObject->TicketCreate(
    Title        => ( sprintf 'Test ticket created by %s', __FILE__ ),
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

    # Tests where there is first a CSV attachment and then the HTML body
    {
        # FollowUp is detected because the ticket number is in the part that is saved as message body
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
        # FollowUp is not detected because the ticket number is not in the part that is saved as message body
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

# Run the tests.
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
