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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Capture::Tiny qw(capture);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DumpCommand  = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Dump');
my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

my $ThawedCompleteDump;
{
    # run the console command and capture the output
    my $DumpAllCommand = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::DumpAll');
    my ( $JSONString, undef, $ExitCode ) = capture {
        return $DumpAllCommand->Execute;
    };
    is( $ExitCode, 0, "command ran successfully" );

    # Get a data structure from the printed JSON
    $ThawedCompleteDump = $JSONObject->Decode( Data => $JSONString );
    ref_ok(
        $ThawedCompleteDump,
        'HASH',
        'got hash from DumpAll'
    );
}

my @Keys = qw(
    Home
    CurrentDeploymentID
    ACLKeysLevel1Change
    PerformanceLog::File
    Loader::Agent::CommonCSS
);

for my $Key (@Keys) {
    subtest "config dump for key '$Key'" => sub {

        # run the console command and capture the output
        my ( $JSONString, undef, $ExitCode ) = capture {
            return $DumpCommand->Execute($Key);
        };

        is( $ExitCode, 0, "command ran successfully" );
        is(
            $JSONObject->Decode( Data => $JSONString ),
            $ConfigObject->Get($Key),
            'verify Dump command',
        );
        is(
            $ThawedCompleteDump->{$Key},
            $ConfigObject->Get($Key),
            'verify DumpAll command',
        );
    };
}

done_testing;
