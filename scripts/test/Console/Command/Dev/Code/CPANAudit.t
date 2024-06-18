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

my $ThawedAuditReport;
{
    # run the console command and capture the output
    my $AuditCommand = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Code::CPANAudit');
    my ( $JSONString, undef, $ExitCode ) = capture {
        return $AuditCommand->Execute;
    };
    ok( $ExitCode == 0 || $ExitCode == 1, 'command exited with a sane code' );

    # Get a data structure from the printed JSON
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    $ThawedAuditReport = $JSONObject->Decode( Data => $JSONString );
    ref_ok(
        $ThawedAuditReport,
        'HASH',
        'got hash from DumpAll'
    );
}

# just a sanity check of the keys on the top level
for my $Key (qw( dists errors meta )) {
    ok( exists $ThawedAuditReport->{$Key}, "top level key '$Key' exists" );
}

done_testing;
