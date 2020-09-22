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

package Kernel::System::UnitTest;

use strict;
use warnings;

use File::stat;
use Storable();
use Term::ANSIColor();
use Time::HiRes();

use Kernel::System::VariableCheck qw(IsHashRefWithData IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::UnitTest - functions to run all or some OTOBO unit tests

=head1 PUBLIC INTERFACE

=head2 new()

create unit test object. Do not use it directly, instead use:

    my $UnitTestObject = $Kernel::OM->Get('Kernel::System::UnitTest');

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    $Self->{Debug} = $Param{Debug} || 0;
    $Self->{ANSI}  = $Param{ANSI};

    return $Self;
}

=head2 Run()

run all or some tests located in C<scripts/test/**/*.t> and print the result.

    $UnitTestObject->Run(
        Name                   => ['JSON', 'User'],     # optional, execute certain test files only
        Directory              => 'Selenium',           # optional, execute tests in subdirectory
        Verbose                => 1,                    # optional (default 0), only show result details for all tests, not just failing
        PostTestScripts        => ['...'],              # Script(s) to execute after a test has been run.
                                                        #  You can specify %File%, %TestOk% and %TestNotOk% as dynamic arguments.
        NumberOfTestRuns       => 10,                   # optional (default 1), number of successive runs for every single unit test
    );

Please note that the individual test files are not executed in the main process,
but instead in separate forked child processes which are controlled by L<Kernel::System::UnitTest::Driver>.
Their results will be transmitted to the main process via a local file.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Verbose} = $Param{Verbose};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Product = $ConfigObject->Get('Product') . " " . $ConfigObject->Get('Version');
    my $Home    = $ConfigObject->Get('Home');

    my $Directory = "$Home/scripts/test";
    if ( $Param{Directory} ) {
        $Directory .= "/$Param{Directory}";
        $Directory =~ s/\.//g;
    }

    my @TestsToExecute = @{ $Param{Tests} // [] };

    my $UnitTestBlacklist = $ConfigObject->Get('UnitTest::Blacklist');
    my @BlacklistedTests;
    my @SkippedTests;
    if ( IsHashRefWithData($UnitTestBlacklist) ) {

        CONFIGKEY:
        for my $ConfigKey ( sort keys %{$UnitTestBlacklist} ) {

            next CONFIGKEY if !$ConfigKey;
            next CONFIGKEY
                if !$UnitTestBlacklist->{$ConfigKey} || !IsArrayRefWithData( $UnitTestBlacklist->{$ConfigKey} );

            TEST:
            for my $Test ( @{ $UnitTestBlacklist->{$ConfigKey} } ) {

                next TEST if !$Test;

                push @BlacklistedTests, $Test;
            }
        }
    }

    my $StartTime      = CORE::time();                      # Use non-overridden time().
    my $StartTimeHiRes = [ Time::HiRes::gettimeofday() ];

    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.t',
        Recursive => 1,
    );

    my $NumberOfTestRuns = $Param{NumberOfTestRuns};
    if ( !$NumberOfTestRuns ) {
        $NumberOfTestRuns = 1;
    }

    FILE:
    for my $File (@Files) {

        # check if only some tests are requested
        if ( @TestsToExecute && !grep { $File =~ /\/\Q$_\E\.t$/smx } @TestsToExecute ) {
            next FILE;
        }

        # Check blacklisted files.
        if ( @BlacklistedTests && grep { $File =~ m{\Q$Directory/$_\E$}smx } @BlacklistedTests ) {
            push @SkippedTests, $File;
            next FILE;
        }

        # Check if a file with the same path and name exists in the Custom folder.
        my $CustomFile = $File =~ s{ \A $Home }{$Home/Custom}xmsr;
        if ( -e $CustomFile ) {
            $File = $CustomFile;
        }

        for ( 1 .. $NumberOfTestRuns ) {
            $Self->_HandleFile(
                PostTestScripts => $Param{PostTestScripts},
                File            => $File,
                DataDiffType    => $Param{DataDiffType},
            );
        }
    }

    my $Duration = sprintf( '%.3f', Time::HiRes::tv_interval($StartTimeHiRes) );

    my $Host           = $ConfigObject->Get('FQDN');
    my $TestCountTotal = ( $Self->{TestCountOk} // 0 ) + ( $Self->{TestCountNotOk} // 0 );

    print "=====================================================================\n";

    if (@SkippedTests) {
        print "Following blacklisted tests were skipped:\n";
        for my $SkippedTest (@SkippedTests) {
            print '  ' . $Self->_Color( 'yellow', $SkippedTest ) . "\n";
        }
    }

    printf(
        "%s ran %s test(s) in %s for %s.\n",
        $Self->_Color( 'yellow', $Host ),
        $Self->_Color( 'yellow', $TestCountTotal ),
        $Self->_Color( 'yellow', "${Duration}s" ),
        $Self->_Color( 'yellow', $Product )
    );

    if ( $Self->{TestCountNotOk} ) {
        print $Self->_Color( 'red', "$Self->{TestCountNotOk} tests failed.\n" );
        print " FailedTests:\n";
        FAILEDFILE:
        for my $FailedFile ( @{ $Self->{NotOkInfo} || [] } ) {
            my ( $File, @Tests ) = @{ $FailedFile || [] };
            next FAILEDFILE if !@Tests;
            print sprintf "  %s %s\n", $File, join ", ", @Tests;
        }
    }
    elsif ( $Self->{TestCountOk} ) {
        print $Self->_Color( 'green', "All $Self->{TestCountOk} tests passed.\n" );
    }
    else {
        print $Self->_Color( 'yellow', "No tests executed.\n" );
    }

    return $Self->{TestCountNotOk} ? 0 : 1;
}

=begin Internal:

=cut

sub _HandleFile {
    my ( $Self, %Param ) = @_;

    my $ResultDataFile = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/tmp/UnitTest.dump';
    unlink $ResultDataFile;

    # Create a child process.
    my $PID = fork;

    # Could not create child.
    if ( $PID < 0 ) {

        $Self->{ResultData}->{ $Param{File} } = { TestNotOk => 1 };
        $Self->{TestCountNotOk} += 1;

        print $Self->_Color( 'red', "Could not create child process for $Param{File}.\n" );

        return;
    }

    # We're in the child process.
    if ( !$PID ) {

        my $Driver = $Kernel::OM->Create(
            'Kernel::System::UnitTest::Driver',
            ObjectParams => {
                Verbose      => $Self->{Verbose},
                ANSI         => $Self->{ANSI},
                DataDiffType => $Param{DataDiffType},
            },
        );

        $Driver->Run( File => $Param{File} );

        exit 0;
    }

    # Wait for child process to finish.
    waitpid( $PID, 0 );

    my $ResultData = eval { Storable::retrieve($ResultDataFile) };

    if ( !$ResultData ) {
        print $Self->_Color( 'red', "Could not read result data for $Param{File}.\n" );
        $ResultData->{TestNotOk}++;
    }

    $Self->{ResultData}->{ $Param{File} } = $ResultData;
    $Self->{TestCountOk}    += $ResultData->{TestOk}    // 0;
    $Self->{TestCountNotOk} += $ResultData->{TestNotOk} // 0;

    $Self->{SeleniumData} //= $ResultData->{SeleniumData};

    $Self->{NotOkInfo} //= [];
    if ( $ResultData->{NotOkInfo} ) {

        # Cut out from result data hash, as we don't need to send this to the server.
        push @{ $Self->{NotOkInfo} }, [ $Param{File}, @{ delete $ResultData->{NotOkInfo} } ];
    }

    for my $PostTestScript ( @{ $Param{PostTestScripts} // [] } ) {
        my $Commandline = $PostTestScript;
        $Commandline =~ s{%File%}{$Param{File}}ismxg;
        $Commandline =~ s{%TestOk%}{$ResultData->{TestOk} // 0}iesmxg;
        $Commandline =~ s{%TestNotOk%}{$ResultData->{TestNotOk} // 0}iesmxg;
        system $Commandline;
    }

    return 1;
}

=head2 _Color()

this will color the given text (see L<Term::ANSIColor::color()>) if
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
