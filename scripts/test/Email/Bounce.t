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

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'OTOBOTimeZone',
    Value => 'UTC',
);

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my $SystemTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2014-01-01 12:00:00',
    },
);
FixedTimeSet($SystemTime);

my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

my @Tests = (
    {
        Name   => 'Simple email',
        Params => {
            From         => 'from@bounce.com',
            To           => 'to@bounce.com',
            'Message-ID' => '<bounce@mail>',
            Email        => <<'EOF',
From: test@home.com
To: test@otobo.org
Message-ID: <original@mail>
Subject: Bounce test

Testmail
EOF
        },
        Result => <<'EOF',
From: test@home.com
To: test@otobo.org
Message-ID: <original@mail>
Subject: Bounce test
Resent-Message-ID: <bounce@mail>
Resent-To: to@bounce.com
Resent-From: from@bounce.com
Resent-Date: Wed, 1 Jan 2014 12:00:00 +0000

Testmail
EOF
    },
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Outgoing',
    },
);

for my $Test (@Tests) {
    $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Message'
    );
    my $SentResult = $EmailObject->Bounce(
        %{ $Test->{Params} },
        CommunicationLogObject => $CommunicationLogObject,
    );

    $Self->True(
        $SentResult->{Success},
        sprintf( 'Bounce %s queued.', $Test->{Name}, ),
    );

    $Self->Is(
        $SentResult->{Data}->{Header} . "\n" . $SentResult->{Data}->{Body},
        $Test->{Result},
        "$Test->{Name} Bounce()",
    );
}

$Self->DoneTesting();
