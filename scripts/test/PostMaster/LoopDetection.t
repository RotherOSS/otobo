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
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# This test checks if OTOBO correctly detects that an email must not be auto-responded to.
my @Tests = (
    {
        Name  => 'Regular mail',
        Email =>
            'From: test@home.com
To: test@home.com
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => '',
        },
    },
    {
        Name  => 'Precedence',
        Email =>
            'From: test@home.com
To: test@home.com
Precedence: bulk
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => 'yes',
        },
    },
    {
        Name  => 'X-Loop',
        Email =>
            'From: test@home.com
To: test@home.com
X-Loop: yes
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => 'yes',
        },
    },
    {
        Name  => 'X-No-Loop',
        Email =>
            'From: test@home.com
To: test@home.com
X-No-Loop: yes
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => 'yes',
        },
    },
    {
        Name  => 'X-OTOBO-Loop',
        Email =>
            'From: test@home.com
To: test@home.com
X-OTOBO-Loop: yes
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => 'yes',
        },
    },
    {
        Name  => 'Auto-submitted: auto-generated',
        Email =>
            'From: test@home.com
To: test@home.com
Auto-submitted: auto-generated
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => 'yes',
        },
    },
    {
        Name  => 'Auto-Submitted: auto-replied',
        Email =>
            'From: test@home.com
To: test@home.com
Auto-Submitted: auto-replied
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => 'yes',
        },
    },
    {
        Name  => 'Auto-submitted: no',
        Email =>
            'From: test@home.com
To: test@home.com
Auto-submitted: no
Subject: Testmail

Body
',
        EmailParams => {
            From           => 'test@home.com',
            'X-OTOBO-Loop' => '',
        },
    },
);

for my $Test (@Tests) {

    my @Email = split( /\n/, $Test->{Email} );

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
        Email                  => \@Email,
    );

    my $EmailParams = $PostMasterObject->GetEmailParams();

    for my $EmailParam ( sort keys %{ $Test->{EmailParams} } ) {
        $Self->Is(
            $EmailParams->{$EmailParam},
            $Test->{EmailParams}->{$EmailParam},
            "$Test->{Name} - $EmailParam",
        );
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Message',
        Status        => 'Successful',
    );
    $CommunicationLogObject->CommunicationStop(
        Status => 'Successful',
    );
}

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
