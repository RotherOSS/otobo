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

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $LoopProtectionObject = $Kernel::OM->Get('Kernel::System::PostMaster::LoopProtection');

# define needed variable
my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

for my $Module (qw(DB FS)) {

    $ConfigObject->Set(
        Key   => 'LoopProtectionModule',
        Value => "Kernel::System::PostMaster::LoopProtection::$Module",
    );

    # get rand sender address
    my $UserRand1 = 'example-user' . $RandomID . '@example.com';
    my $UserRand2 = 'example-user' . $RandomID . '@example.org';

    $ConfigObject->Set(
        Key   => 'PostmasterMaxEmailsPerAddress',
        Value => { $UserRand2 => 5 },
    );

    my $LoopProtectionObject = Kernel::System::PostMaster::LoopProtection->new();

    my $Check = $LoopProtectionObject->Check( To => $UserRand1 );

    $Self->True(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );

    for ( 1 .. 42 ) {
        my $SendEmail = $LoopProtectionObject->SendEmail( To => $UserRand1 );
        $Self->True(
            $SendEmail || 0,
            "#$Module - SendEmail() - #$_ ",
        );
    }

    $Check = $LoopProtectionObject->Check( To => $UserRand1 );

    $Self->False(
        $Check || 0,
        "#$Module - Check() - $UserRand1",
    );

    # now test with per-address limit
    my $SendEmail = $LoopProtectionObject->SendEmail( To => $UserRand2 );
    for ( 1 .. 6 ) {
        my $SendEmail = $LoopProtectionObject->SendEmail( To => $UserRand2 );
        $Self->True(
            $SendEmail || 0,
            "#$Module - SendEmail() - $UserRand2 #$_ (with custom limit)",
        );
        $Check = $LoopProtectionObject->Check( To => $UserRand2 );
    }

    $Check = $LoopProtectionObject->Check( To => $UserRand2 );
    $Self->False(
        $Check || 0,
        "#$Module - Check() - $UserRand2 (with custom limit)",
    );
}

$Self->DoneTesting();
