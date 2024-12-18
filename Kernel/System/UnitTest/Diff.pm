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

package Kernel::System::UnitTest::Diff;

use v5.24;
use strict;
use warnings;
use utf8;
use namespace::autoclean;

use parent 'Exporter';

# core modules

# CPAN modules
use Text::Diff qw(diff);
use Test2::API qw(context);

# OTOBO modules

our @EXPORT_OK = qw(TextEqOrDiff);    ## no critic qw(OTOBO::RequireCamelCase)

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::UnitTest::Diff - provide a testing method that shows a diff

=head1 PUBLIC INTERFACE

=head2 TextEqOrDiff()

test whether two strings are equal. Show an unified diff when the strings are not equal.

Two undefined values are considered as equal.
When only one argument is undefined then the test reports as false.
When at least one of the arguments is a reference then the test reports false.

    # OTODO modules
    use Kernel::System::UnitTest::Diff qw(TextEqOrDiff)

    TextEqOrDiff("A\nB\nC\nD", "A\nB\nC\nD", 'four equal lines' );     # ok
    TextEqOrDiff("A\nB\nc\nD", "A\nB\nC\nD", 'third line not equal' ); # not ok

=cut

sub TextEqOrDiff {
    my ( $Got, $Expected, $Desc ) = @_;

    my $Context = context();

    # a description is mandatory
    return $Context->fail_and_release('test description was provided for TextEqOrDiff()') unless $Desc;

    if ( !defined $Got && !defined $Expected ) {
        $Context->pass($Desc);

        $Context->diag("the tested and the expected value are both undefined");

        return $Context->release;
    }

    if ( !defined $Got ) {
        $Context->fail($Desc);
        $Context->diag("the tested ant the expected value are bou value is undefined while expected value is defined");

        return $Context->release;
    }

    if ( !defined $Expected ) {
        $Context->fail($Desc);
        $Context->diag("tested value is defined while expected value is undefined)");

        return $Context->release;
    }

    if ( ref $Got && ref $Expected ) {
        $Context->fail($Desc);
        $Context->diag("this testing method does not compare data structures");

        return $Context->release;
    }

    if ( ref $Got ) {
        $Context->fail($Desc);
        $Context->diag("tested value is a data structure");

        return $Context->release;
    }

    if ( ref $Expected ) {
        $Context->fail($Desc);
        $Context->diag("expected value is a data structure");

        return $Context->release;
    }

    # we have two plain scalars
    if ( $Got eq $Expected ) {
        return $Context->pass_and_release($Desc);
    }

    # unified diff for two strings
    my $UnifiedDiff = diff(
        \$Got,
        \$Expected,
        {
            STYLE => 'Unified',
        }
    );

    $Context->fail($Desc);
    $Context->diag($UnifiedDiff);

    return $Context->release;
}

1;
