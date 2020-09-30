# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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
use Test2::V0 qw(plan is note like);

# OTOBO modules
use Kernel::System::ObjectManager;

$Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-otobo.UnitTest',
    },
);

my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::UnitTest::Run');

my @Tests = (
    {
        Name                 => "UnitTest 'NutsAndBolts.t' not executed because blacklisted",
        Test                 => 'NutsAndBolts',
        SkipNutsAndBoltsTest => 0,
        Config               => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => ['NutsAndBolts.t'],
        },
        ResultPattern        => qr{Result: \s+ NOTESTS}x,
    },
    {
        Name                 => "UnitTest 'NutsAndBolts.t' executed because not blacklisted",
        Test                 => 'NutsAndBolts',
        SkipNutsAndBoltsTest => 1,
        Config               => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => [],
        },
        ResultPattern        => qr{\QParse errors: No plan found in TAP output\E},
    },
);

plan( tests => scalar @Tests );

for my $Test (@Tests) {

    # override config
    $Helper->ConfigSettingChange(
        %{ $Test->{Config} },
    );

    # override %ENV
    local $ENV{SKIP_NUTSANDBOLTS_TEST} = $Test->{SkipNutsAndBoltsTest};

    # run Dev::UnitTest::Run
    my ( $ResultStdout, $ResultStderr, $ExitCode );
    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$ResultStdout;
        local *STDERR;
        open STDERR, '>:encoding(UTF-8)', \$ResultStderr;

        $ExitCode = $CommandObject->Execute( '--test', $Test->{Test}, '--quiet' );
    }

    # some diagnostics
    $ResultStderr //= 'undef';
    $ResultStdout //= 'undef';
    note( "err: '$ResultStderr'" );
    note( "out: '$ResultStdout'" );

    # Check for executed tests message.
    like( $ResultStdout, $Test->{ResultPattern}, $Test->{Name} );
}
