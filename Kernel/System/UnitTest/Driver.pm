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

package Kernel::System::UnitTest::Driver;

use strict;
use warnings;
use v5.24.0;
use utf8;

# core modules
use Storable qw();
use Time::HiRes qw();
use Term::ANSIColor qw();

# CPAN modules
use Text::Diff;

# OTOBO modules
# UnitTest helper must be loaded to override the builtin time functions!
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(DataIsDifferent);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::UnitTest::Driver - unit test file execution wrapper, test subroutines

=head1 PUBLIC INTERFACE

=head2 new()

create unit test driver object. Do not use it directly, instead use:

    my $Driver = $Kernel::OM->Create(
        'Kernel::System::UnitTest::Driver',
        ObjectParams => {
            Verbose => $Self->{Verbose},
            ANSI    => $Self->{ANSI},
        },
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    $Self->{ANSI}         = $Param{ANSI};
    $Self->{Verbose}      = $Param{Verbose};
    $Self->{DataDiffType} = ucfirst( lc( $Param{DataDiffType} || 'Table' ) );

    # When Kernel::System::UnitTest is under test itself,
    # then the output of the various instances should not be mangled
    $Self->{SelfTest} = $Param{SelfTest};

    return $Self;
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

    if ( !$Name ) {
        return $Self->_Print( 0, 'Error: test name was not provided.' );
    }

    if ($True) {
        return $Self->_Print( 1, $Name );
    }
    else {
        return $Self->_Print( 0, $Name );
    }
}

=head2 False()

test for a scalar value that evaluates to false.

It has the same interface as L</True()>, but tests
for a false value instead.

=cut

sub False {
    my ( $Self, $False, $Name ) = @_;

    if ( !$Name ) {
        return $Self->_Print( 0, 'Error: test name was not provided.' );
    }

    if ( !$False ) {
        return $Self->_Print( 1, $Name );
    }
    else {
        return $Self->_Print( 0, $Name );
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

    if ( !$Name ) {
        return $Self->_Print( 0, 'Error: test name was not provided.' );
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Self->_Print( 0, "$Name (is 'undef' should be '$ShouldBe')" );
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 0, "$Name (is '$Test' should be 'undef')" );
    }
    elsif ( $Test eq $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }
    else {
        return $Self->_Print( 0, "$Name (is '$Test' should be '$ShouldBe')" );
    }
}

=head2 IsNot()

compares two scalar values for inequality.

It has the same interface as L</Is()>, but tests
for inequality instead.

=cut

sub IsNot {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        return $Self->_Print( 0, 'Error: test name was not provided.' );
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 0, "$Name (is 'undef')" );
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }
    if ( $Test ne $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }
    else {
        return $Self->_Print( 0, "$Name (is '$Test' should not be '$ShouldBe')" );
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

    if ( !$Name ) {
        $Self->_Print( 0, 'Error: test name was not provided.' );
        return;
    }

    my $Diff = DataIsDifferent(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Self->_Print( 0, "$Name (is 'undef' should be defined)" );
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 0, "$Name (is defined should be 'undef')" );
    }
    elsif ( !$Diff ) {
        return $Self->_Print( 1, $Name );
    }
    else {
        my $TestDump     = $Kernel::OM->Get('Kernel::System::Main')->Dump($Test);
        my $ShouldBeDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($ShouldBe);
        local $ENV{DIFF_OUTPUT_UNICODE} = 1;
        my $Diff = Text::Diff::diff(
            \$TestDump,
            \$ShouldBeDump,
            {
                STYLE      => $Self->{DataDiffType},
                FILENAME_A => 'Actual data',
                FILENAME_B => 'Expected data',
            }
        );

        # Provide colored diff.
        if ( $Self->{ANSI} ) {
            my @DiffLines = split( m{\n}, $Diff );
            $Diff = '';

            for my $DiffLine (@DiffLines) {

                # Diff type "Table"
                if ( $Self->{DataDiffType} eq 'Table' ) {

                    # Line changed
                    if ( substr( $DiffLine, 0, 1 ) eq '*' && substr( $DiffLine, -1, 1 ) eq '*' ) {
                        $DiffLine = $Self->_Color( 'yellow', $DiffLine );
                    }

                    # Line added
                    elsif ( substr( $DiffLine, 0, 1 ) eq '|' && substr( $DiffLine, -1, 1 ) eq '*' ) {
                        $DiffLine = $Self->_Color( 'green', $DiffLine );
                    }

                    # Line removed
                    elsif ( substr( $DiffLine, 0, 1 ) eq '*' && substr( $DiffLine, -1, 1 ) eq '|' ) {
                        $DiffLine = $Self->_Color( 'red', $DiffLine );
                    }
                }

                # Diff type "Unified"
                else {
                    # Line added
                    if ( substr( $DiffLine, 0, 1 ) eq '+' && substr( $DiffLine, 0, 4 ) ne '+++ ' ) {
                        $DiffLine = $Self->_Color( 'green', $DiffLine );
                    }

                    # Line removed
                    elsif ( substr( $DiffLine, 0, 1 ) eq '-' && substr( $DiffLine, 0, 4 ) ne '--- ' ) {
                        $DiffLine = $Self->_Color( 'red', $DiffLine );
                    }
                }
                $Diff .= $DiffLine . "\n";
            }
        }

        my $Output;
        $Output .= $Self->_Color( 'yellow', "Diff" ) . ":\n$Diff\n";
        $Output .= $Self->_Color( 'yellow', "Actual data" ) . ":\n$TestDump\n";
        $Output .= $Self->_Color( 'yellow', "Expected data" ) . ":\n$ShouldBeDump\n";

        return $Self->_Print( 0, "$Name (is not equal, see below)\n$Output" );
    }
}

=head2 IsNotDeeply()

compares two data structures for inequality.

It has the same interface as L</IsDeeply()>, but tests
for inequality instead.

=cut

sub IsNotDeeply {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Self->_Print( 0, 'Error: test name was not provided.' );
        return;
    }

    my $Diff = DataIsDifferent(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 0, "$Name (is 'undef')" );
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        return $Self->_Print( 1, $Name );
    }

    if ($Diff) {
        return $Self->_Print( 1, $Name );
    }
    else {
        my $TestDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($Test);
        my $Output   = $Self->_Color( 'yellow', "Actual data" ) . ":\n$TestDump\n";
        return $Self->_Print( 0, "$Name (the structures are wrongly equal, see below)\n$Output" );
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

sub AttachSeleniumScreenshot {
    my ( $Self, %Param ) = @_;

    push @{ $Self->{ResultData}->{Results}->{ $Self->{TestCount} }->{Screenshots} },
        {
        Filename => $Param{Filename},
        Content  => $Param{Content},
        };

    return;
}

=head2 Plan

Explicitly declare the expected number of tests.
The required parameter B<Tests> sets the expected number of tests.

=cut

sub Plan {
    my $Self = shift;
    my %Param = @_;

    say "1..$Param{Tests}";

    return;
}

=head2 DoneTesting()

Print out a test plan. This assumes that the number of test that have
run so far is exactly the number of tests that should run.
This effectively disables the check of the test plan.
This method is called automatically in Kernel::System::UnitTest::RegisterDriver.

    $Driver->DoneTesting();

=cut

sub DoneTesting {
    my ($Self) = @_;

    # DoneTesting() is disabled when running via Dev::UnitTest::Run
    return 0 if caller ne 'main';

    my $TestCountTotal = $Self->{ResultData}->{TestOk} // 0;
    $TestCountTotal += $Self->{ResultData}->{TestNotOk} // 0;

    return $Self->Plan( Tests => $TestCountTotal );
}

=head2 Note()

Print out a note to STDOUT. The parameter B<Note> will be split into lines and each line
is prepended by '# '. A trailing newline will be added when there isn't on yet.

=cut

sub Note {
    my ($Self, %Param) = @_;

    my $Note = $Param{Note} // '';
    chomp $Note;
    print map { "# $_\n" } split /\n/, $Note;

    return;
}

=begin Internal:

=cut

sub _Print {
    my $Self = shift;
    my ( $ResultOk, $Message ) = @_;

    $Message ||= '->>No Name!<<-';

    my $ShortMessage = $Message;
    if ( length $ShortMessage > 2_000 && !$Self->{Verbose} ) {
        $ShortMessage = substr( $ShortMessage, 0, 2_000 ) . "[...]";
    }

    if ( $Self->{Verbose} || !$ResultOk ) {

        if ( $Self->{SelfTest} ) {
            # When Kernel::System::UnitTest is tested itself
            # the we don't want to print the output of the tested functions,
            # as this confused whoever is analysing the output.
        }
        else {
            # Work around problem with leading \0 bytes in the output buffer
            #  which breaks the unicode output. The reason is not certain, maybe because of
            #  Perl's exception handling.
            $Self->{OutputBuffer} =~ s{\0}{}g;
            print $Self->{OutputBuffer};
        }
    }
    $Self->{OutputBuffer} = '';

    $Self->{TestCount}++;
    if ($ResultOk) {
        if ( $Self->{SelfTest} ) {
            # print nothing as Kernel::System::UnitTest is tested itself
        }
        elsif ( $Self->{Verbose} ) {
            say $Self->_Color( 'green', 'ok' ), " $Self->{TestCount} - $ShortMessage";
        }
        else {
            print $Self->_Color( 'green', "." );
        }

        $Self->{ResultData}->{TestOk}++;

        return 1;
    }
    else {
        if ( $Self->{SelfTest} ) {
            # print nothing as Kernel::System::UnitTest is tested itself
        }
        else {
            if ( !$Self->{Verbose} ) {
                say '';
            }
            say $Self->_Color( 'red', "not ok" ), " $Self->{TestCount} - $ShortMessage";
        }
        $Self->{ResultData}->{TestNotOk}++;
        $Self->{ResultData}->{Results}->{ $Self->{TestCount} }->{Status}  = 'not ok';
        $Self->{ResultData}->{Results}->{ $Self->{TestCount} }->{Message} = $Message;

        # Failure summary: only the first line
        my ($TestFailureDetails) = split m/\r?\n/, $Message, 2;

        # And only without details
        $TestFailureDetails =~ s{\s*\(.+\Z}{};
        if ( length $TestFailureDetails > 100 ) {
            $TestFailureDetails = substr( $TestFailureDetails, 0, 100 ) . "[...]";
        }

        # Store information about failed tests, but only if we are running in a toplevel unit test object
        #   that is actually processing files, and not in an embedded object that just runs individual tests.
        push @{ $Self->{ResultData}->{NotOkInfo} }, sprintf "#%s - %s", $Self->{TestCount},
            $TestFailureDetails;

        return;
    }
}

=head2 _Color()

this will color the given text (see Term::ANSIColor::color()) if
ANSI output is available and active, otherwise the text stays unchanged.

    my $PossiblyColoredText = $CommandObject->_Color('green', $Text);

=cut

sub _Color {
    my ( $Self, $Color, $Text ) = @_;

    return $Text if !$Self->{ANSI};
    return Term::ANSIColor::color($Color) . $Text . Term::ANSIColor::color('reset');
}

=end Internal:

=cut

1;
