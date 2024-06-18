# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

use Kernel::System::UnitTest::MockTime qw(:all);

# OTOBO modules

# Testing Kernel::System::UnitTest::MockTime.

plan(5);

subtest 'before setting a fixed time' => sub {
    my $CoreTime   = CORE::time;
    my $MockedTime = time;         # might differ by 1 by chance
    ok( ( $MockedTime - $CoreTime ) >= 0, 'time not running backwards' );
    ok( ( $MockedTime - $CoreTime ) <= 1, 'at most 1 second diff between two calls' );
    ok( !defined FixedTimeGet(),          'no fixed time set yet' );
};

# epoch 1604562142 is Thu Nov  5 08:42:22 2020 CET
my $SampleTime = 1604562142;

subtest 'fixing a specific time' => sub {
    my $SampleTime = 1604562142;
    is( FixedTimeSet($SampleTime), $SampleTime, 'FixedTimeSet() with sample time' );
    is( FixedTimeGet(),            $SampleTime, 'FixedTimeGet() with sample time' );
    is( time,                      $SampleTime, 'time mocked' );
};

subtest 'add seconds' => sub {
    my $AddedSeconds = -122333;                       # yes, it's negative
    my $ExpectedTime = $SampleTime + $AddedSeconds;
    is( FixedTimeAddSeconds($AddedSeconds), $ExpectedTime, 'FixedTimeSet() with added seconds' );
    is( FixedTimeGet(),                     $ExpectedTime, 'FixedTimeGet() with added seconds' );
    is( time,                               $ExpectedTime, 'time mocked with added seconds' );
};

subtest 'fixing time to now' => sub {
    my $CoreTime = CORE::time;
    sleep 1;                                          # just to have a difference
    my $MockedTime = FixedTimeSet();                  # might differ by 1 by chance
    ok( ( $MockedTime - $CoreTime ) >= 1, 'time not running backwards' );
    ok( ( $MockedTime - $CoreTime ) <= 2, 'at most 2 second diff between two calls' );
    is( FixedTimeGet(), $MockedTime, 'FixedTimeGet() with time fixed to one second ago' );
    is( time(),         $MockedTime, 'mocked time with time fixed to one second ago' );
};

subtest 'back to normal' => sub {
    my $CoreTime = CORE::time;
    is( FixedTimeUnset(), undef, 'FixedTimeUnset' );
    my $MockedTime = time;                            # might differ by 1 by chance
    is( FixedTimeGet(), undef, 'FixedTimeGet() with fixed time unset' );
    ok( ( $MockedTime - $CoreTime ) >= 0, 'time not running backwards' );
    ok( ( $MockedTime - $CoreTime ) <= 1, 'at most 1 second diff between two calls' );
};
