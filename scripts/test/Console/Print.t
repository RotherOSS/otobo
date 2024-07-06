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
use Capture::Tiny   qw(capture);
use Term::ANSIColor qw(color);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::Console::BaseCommand;

# initially ANSI is off, because we are not in interactive mode
subtest 'ANSI' => sub {
    my $BaseCommand = Kernel::System::Console::BaseCommand->new;
    ok( !$BaseCommand->ANSI, 'not interactive' );
    is( $BaseCommand->ANSI(1), 1, 'force interactive' );
    ok( $BaseCommand->ANSI, 'interactive is now forced' );
    is( $BaseCommand->ANSI(0), 0, 'force interactive' );
    ok( !$BaseCommand->ANSI, 'interactive off again' );
};

my $Green  = color('green');
my $Yellow = color('yellow');
my $Red    = color('red');
my $Reset  = color('reset');

subtest 'Print ANSI=0' => sub {
    my $BaseCommand = Kernel::System::Console::BaseCommand->new;
    $BaseCommand->ANSI(0);
    my ( $Out, $Error, $RetVal ) = capture {
        return $BaseCommand->Print(q{<green>green 🌲</green> and <yellow>yellow 🌞</yellow>});
    };

    is( $Out,    q{green 🌲 and yellow 🌞}, 'color tags removed' );
    is( $Error,  '',                            'nothing printed on STDERR' );
    is( $RetVal, undef,                         'returning undef' );
};

subtest 'Print() ANSI=1' => sub {
    my $BaseCommand = Kernel::System::Console::BaseCommand->new;
    $BaseCommand->ANSI(1);
    my ( $Out, $Error, $RetVal ) = capture {
        return $BaseCommand->Print(q{<green>green 🌲</green> and <yellow>yellow 🌞</yellow>});
    };

    is( $Out,    qq{${Green}green 🌲${Reset} and ${Yellow}yellow 🌞${Reset}}, 'color tags replaced' );
    is( $Error,  '',                                                              'nothing printed on STDERR' );
    is( $RetVal, undef,                                                           'returning undef' );
};

subtest 'PrintError() ANSI=0' => sub {
    my $BaseCommand = Kernel::System::Console::BaseCommand->new;
    $BaseCommand->ANSI(0);
    my ( $Out, $Error, $RetVal ) = capture {
        return $BaseCommand->PrintError(q{<green>green 🌲</green> and <yellow>yellow 🌞</yellow>});
    };

    is( $Out,    '',                                                                      'nothing printed on STDOUT' );
    is( $Error,  qq{Error: <green>green 🌲</green> and <yellow>yellow 🌞</yellow>\n}, q{'Error:' added, color tags kept} );
    is( $RetVal, undef,                                                                   'returning undef' );
};

subtest 'PrintError() ANSI=1' => sub {
    my $BaseCommand = Kernel::System::Console::BaseCommand->new;
    $BaseCommand->ANSI(1);
    my ( $Out, $Error, $RetVal ) = capture {
        return $BaseCommand->PrintError(q{<green>green 🌲</green> and <yellow>yellow 🌞</yellow>});
    };

    is( $Out,    '',                                                                                    'nothing printed on STDOUT' );
    is( $Error,  qq{${Red}Error: <green>green 🌲</green> and <yellow>yellow 🌞</yellow>\n${Reset}}, q{'Error:' added, color tags kept} );
    is( $RetVal, undef,                                                                                 'returning undef' );
};

# TODO: test PrintWarning()
# TODO: test PrintOk()

done_testing;
