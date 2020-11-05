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

package Kernel::System::UnitTest::MockTime;

use strict;
use warnings;
use v5.24;
use namespace::autoclean -except => 'import';
use utf8;

# core modules
use Exporter qw(import);

# CPAN modules
use Test2::V0;
use DateTime 1.08;    # Load DateTime so that we can override functions for the FixedTimeSet().

# OTOBO modules

our %EXPORT_TAGS = (    ## no critic
    all => [ qw(FixedTimeSet FixedTimeGet FixedTimeUnset FixedTimeAddSeconds) ],
);

Exporter::export_ok_tags('all');

=head1 NAME

Kernel::System::UnitTest::MockTime - helper functions for mocking time in unit tests

=head1 SYNOPSIS

    #TODO

=head1 DESCRIPTION

=head1 SUBROUTINES

=cut

# used for mocking time
my $FixedTime;

BEGIN {

    *CORE::GLOBAL::time = sub {
        return $FixedTime // CORE::time();
    };

    *CORE::GLOBAL::localtime = sub {
        my ($Time) = @_;

        $Time //= $FixedTime // CORE::time();

        return CORE::localtime($Time);
    };

    *CORE::GLOBAL::gmtime = sub {
        my ($Time) = @_;

        $Time //= $FixedTime // CORE::time();

        return CORE::gmtime($Time);
    };

    no warnings 'redefine'; # yes, we want to override

    *DateTime::_core_time = sub {
            return $FixedTime // CORE::time();
    };
}

=head2 FixedTimeSet()

makes it possible to override the system time as long as this object lives.
You can pass an optional time parameter that should be used, if not,
the current system time will be used.

All calls to methods of Kernel::System::Time and Kernel::System::DateTime will
use the given time afterwards.

    FixedTimeSet(366475757);         # with Timestamp
    FixedTimeSet($DateTimeObject);   # with previously created DateTime object
    FixedTimeSet();                  # set to current date and time

Returns:
    Timestamp

=cut

sub FixedTimeSet {
    my ( $TimeToSave ) = @_;

    if ( $TimeToSave && ref $TimeToSave eq 'Kernel::System::DateTime' ) {
        $FixedTime = $TimeToSave->ToEpoch();
    }
    else {
        $FixedTime = $TimeToSave // CORE::time();
    }

    return $FixedTime;
}

=head2 FixedTimeGet()

get the current fixed time. Undef when no time has been fixed.

    my $FixedTime = FixedTimeGet();

Returns:
    Timestamp

=cut

sub FixedTimeGet {
    return $FixedTime;
}

=head2 FixedTimeUnset()

restores the regular system time behavior.

Returns:
    undef

=cut

sub FixedTimeUnset {
    undef $FixedTime;

    return $FixedTime;
}

=head2 FixedTimeAddSeconds()

adds a number of seconds to the fixed system time which was previously
set by FixedTimeSet(). You can pass a negative value to go back in time.

Returns:
    Timestamp

=cut

sub FixedTimeAddSeconds {
    my ( $SecondsToAdd ) = @_;

    return unless defined $FixedTime;

    $FixedTime += $SecondsToAdd;

    return $FixedTime;
}

1;
