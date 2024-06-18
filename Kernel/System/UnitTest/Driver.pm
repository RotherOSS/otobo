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

package Kernel::System::UnitTest::Driver;

use v5.24;
use strict;
use warnings;
use utf8;
use namespace::autoclean;

# core modules

# CPAN modules
use Text::Diff;
use Test2::API qw(context);

# OTOBO modules
use Kernel::System::UnitTest::Helper;    # needed to override the builtin time functions!
use Kernel::System::VariableCheck qw(DataIsDifferent);

our @ObjectDependencies = (
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::UnitTest::Driver - unit test file execution wrapper, test subroutines

=head1 PUBLIC INTERFACE

=head2 new()

create unit test driver object. Do not use it directly, instead use:

    my $Driver = $Kernel::OM->Create( 'Kernel::System::UnitTest::Driver' );

No parameter is supported.

=cut

sub new {
    my $Class = shift;

    # allocate new hash for object
    return bless {}, $Class;
}

=head2 True()

test for a scalar value that evaluates to true.

Send a scalar value to this function along with the test's name:

    $UnitTestObject->True(1, 'Test Name');

    $UnitTestObject->True($ParamA, 'Test Name');

Internally, the function receives this value and evaluates it to see
if it's true, returning 1 in this case or undef, otherwise.

    my $TrueResult = $UnitTestObject->True(
        $TestValue,
        'Test Name',
    );

=cut

sub True {
    my ( $Self, $True, $Name ) = @_;

    my $Context = context();

    if ( !$Name ) {
        return $Context->fail_and_release('Error: test name was not provided for True().');
    }

    if ($True) {
        return $Context->pass_and_release($Name);
    }
    else {
        return $Context->fail_and_release($Name);
    }
}

=head2 False()

test for a scalar value that evaluates to false.

It has the same interface as L</True()>, but tests
for a false value instead.

=cut

sub False {
    my ( $Self, $False, $Name ) = @_;

    my $Context = context();

    if ( !$Name ) {
        return $Context->fail_and_release('Error: test name was not provided for False().');
    }

    if ( !$False ) {
        return $Context->pass_and_release($Name);
    }
    else {
        return $Context->fail_and_release($Name);
    }
}

=head2 Is()

compares two scalar values for equality.

To this function you must send a pair of scalar values to compare them,
and the name that the test will take, this is done as shown in the examples
below.

    $UnitTestObject->Is($A, $B, 'Test Name');

Returns 1 if the values were equal, or undef otherwise.

    my $IsResult = $UnitTestObject->Is(
        $ValueFromFunction,      # test data
        1,                       # expected value
        'Test Name',
    );

=cut

sub Is {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    my $Context = context();

    if ( !$Name ) {
        return $Context->fail_and_release('Error: test name was not provided for Is().');
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Context->fail_and_release("$Name (is 'undef' should be '$ShouldBe')");
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Context->fail_and_release("$Name (is '$Test' should be 'undef')");
    }
    elsif ( $Test eq $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }
    else {
        return $Context->fail_and_release("$Name (is '$Test' should be '$ShouldBe')");
    }
}

=head2 IsNot()

compares two scalar values for inequality.

It has the same interface as L</Is()>, but tests
for inequality instead.

=cut

sub IsNot {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    my $Context = context();

    if ( !$Name ) {
        return $Context->fail_and_release('Error: test name was not provided for IsNot().');
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Context->fail_and_release("$Name (is 'undef')");
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }
    if ( $Test ne $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }
    else {
        return $Context->fail_and_release("$Name (is '$Test' should not be '$ShouldBe')");
    }
}

=head2 IsDeeply()

compares complex data structures for equality.

To this function you must send the references to two data structures to be compared,
and the name that the test will take, this is done as shown in the examples
below.

    $UnitTestObject-> IsDeeply($ParamA, $ParamB, 'Test Name');

Where $ParamA and $ParamB must be references to a structure (scalar, list or hash).

Returns 1 if the data structures are the same, or undef otherwise.

    my $IsDeeplyResult = $UnitTestObject->IsDeeply(
        \%ResultHash,           # test data
        \%ExpectedHash,         # expected value
        'Dummy Test Name',
    );

=cut

sub IsDeeply {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    my $Context = context();

    if ( !$Name ) {
        return $Context->fail_and_release('Error: test name was not provided for IsDeeply().');
    }

    my $Diff = DataIsDifferent(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Context->fail_and_release("$Name (is 'undef' should be defined)");
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Context->fail_and_release("$Name (is defined should be 'undef')");
    }
    elsif ( !$Diff ) {
        return $Context->pass_and_release($Name);
    }
    else {
        my $TestDump     = $Kernel::OM->Get('Kernel::System::Main')->Dump($Test);
        my $ShouldBeDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($ShouldBe);
        local $ENV{DIFF_OUTPUT_UNICODE} = 1;
        my $Diff = Text::Diff::diff(
            \$TestDump,
            \$ShouldBeDump,
            {
                STYLE      => 'Table',
                FILENAME_A => 'Actual data',
                FILENAME_B => 'Expected data',
            }
        );

        my $Output = '';
        $Output .= "Diff" . ":\n$Diff\n";
        $Output .= "Actual data" . ":\n$TestDump\n";
        $Output .= "Expected data" . ":\n$ShouldBeDump\n";

        return $Context->fail_and_release("$Name (is not equal, see below)\n$Output");
    }
}

=head2 IsNotDeeply()

compares two data structures for inequality.

It has the same interface as L</IsDeeply()>, but tests
for inequality instead.

=cut

sub IsNotDeeply {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    my $Context = context();

    if ( !$Name ) {
        return $Context->fail_and_release('Error: test name was not provided for IsNotDeeply().');
    }

    my $Diff = DataIsDifferent(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Context->fail_and_release("$Name (is 'undef')");
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Context->pass_and_release($Name);
    }

    if ($Diff) {
        return $Context->pass_and_release($Name);
    }
    else {
        my $TestDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($Test);
        my $Output   = "Actual data" . ":\n$TestDump\n";

        return $Context->fail_and_release("$Name (the structures are wrongly equal, see below)\n$Output");
    }
}

=head2 AttachSeleniumScreenshot()

attach a screenshot taken during Selenium error handling. These will be sent to the server
together with the test results.

    $Driver->AttachSeleniumScreenshot(
        Filename => $Filename,
        Content  => $Data               # raw image data
    );

=cut

# TODO: is that feature still useful ? AFAIK OTOBO has no test result upload service.
sub AttachSeleniumScreenshot {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    push @{ $Self->{ResultData}->{Results}->{ $Self->{TestCount} }->{Screenshots} },
        {
            Filename => $Param{Filename},
            Content  => $Param{Content},
        };

    $Context->release();

    return;
}

=head2 DoneTesting()

Print out a test plan. This assumes that the number of test that have
run so far is exactly the number of tests that should run.
This effectively disables the check of the test plan.

    $Driver->DoneTesting();

=cut

sub DoneTesting {
    my $Self = shift;

    my $Context = context();
    my $Ret     = $Context->done_testing();
    $Context->release();

    return $Ret;
}

=head2 Note()

Print out a note to STDOUT. The parameter B<Note> will be split into lines and each line
is prepended by '# '. A newline will be appended unless there already is a newline.

=cut

sub Note {
    my ( $Self, %Param ) = @_;

    my $Context = context();
    my $Ret     = $Context->note( $Param{Note} // '' );
    $Context->release();

    return $Ret;
}

1;
