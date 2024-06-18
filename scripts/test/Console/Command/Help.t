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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Help');

subtest 'command without arguments' => sub {
    my ( $Result, $Error, $ExitCode ) = capture {
        return $CommandObject->Execute;
    };
    is( $ExitCode, 1, 'Exit code without arguments' );
    like( $Error, qr/please provide a value for argument 'command'/, 'error message' );
    is( $Result, '', 'no result' );
};

subtest 'command help' => sub {
    my ( $Result, $Error, $ExitCode ) = capture {
        return $CommandObject->Execute('Help');
    };
    is( $ExitCode, 0, "Exit code looking for one command" );
    like( $Result, qr/otobo.Console.pl Help command/, "Found Help for 'Help' command" );
    is( $Error, '', 'no error' );
};

subtest 'command search' => sub {
    my ( $Result, $Error, $ExitCode ) = capture {
        return $CommandObject->Execute('Lis');
    };
    is( $ExitCode, 0, "Exit code searching for commands" );
    unlike( $Result, qr/otobo.Console.pl Help command/, "Help for 'Help' command not found" );
    like( $Result, qr/List all installed OTOBO packages/, 'Found Admin::Package::List command entry' );
    is( $Error, '', 'no error' );
};

subtest 'command search (empty)' => sub {
    my ( $Result, $Error, $ExitCode ) = capture {
        return $CommandObject->Execute('NonExistingSearchTerm');
    };
    is( $ExitCode, 0, 'Exit code searching for commands' );
    unlike( $Result, qr/otobo.Console.pl Help command/, "Help for 'Help' command not found" );
    like( $Result, qr/No commands found./, "No commands found." );
    is( $Error, '', 'no error' );
};

done_testing;
