# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Dump');
my $JSONObject    = $Kernel::OM->Get('Kernel::System::JSON');

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
        my ( $JSONString, $ExitCode );
        {
            local *STDOUT;                          ## no critic qw(Variables::RequireInitializationForLocalVars)
            open STDOUT, '>:utf8', \$JSONString;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
            $ExitCode = $CommandObject->Execute($Key);
        }

        is( $ExitCode, 0, "command ran successfully" );
        is(
            $JSONObject->Decode( Data => $JSONString ),
            $ConfigObject->Get($Key),
            'roundtrip',
        );
    };
}

done_testing;
