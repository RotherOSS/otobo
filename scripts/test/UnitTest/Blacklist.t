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
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::UnitTest::Run');

my @Tests = (
    {
        Name   => "UnitTest 'NutsAndBolts.t' not executed because blacklisted",
        Test   => 'NutsAndBolts',
        Config => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => ['NutsAndBolts.t'],
        },
        TestExecuted => 0,
    },
    {
        Name   => "UnitTest 'NutsAndBolts.t' executed because not blacklisted",
        Test   => 'NutsAndBolts',
        Config => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => [],
        },
        TestExecuted => 1,
    },
);

$Self->Plan( Tests => scalar @Tests );

for my $Test (@Tests) {

    $Helper->ConfigSettingChange(
        %{ $Test->{Config} },
    );

    # run Dev::UnitTest::Run
    my ( $ResultStdout, $ResultStderr, $ExitCode );
    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$ResultStdout;
        local *STDERR;
        open STDERR, '>:encoding(UTF-8)', \$ResultStderr;

        $ExitCode = $CommandObject->Execute( '--test', $Test->{Test}, '--quiet' );
    }
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$ResultStdout );
use Data::Dumper;
warn Dumper( [ $Test, 'out:', $ResultStdout, 'err:', $ResultStderr ] );

    # Check for executed tests message.
    #$Self->Note( Note => $Result );
    my $TestExecuted = $ResultStdout =~ m{Result: \s+ NOTESTS}xms ? 0 : 1;

    $Self->Is( $TestExecuted, $Test->{TestExecuted}, $Test->{Name} );
}
