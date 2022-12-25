# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

use v5.24;
use strict;
use warnings;
use utf8;
use namespace::autoclean;

# core modules
use File::stat;
use Storable();
use Term::ANSIColor();
use TAP::Harness;
use List::Util qw(any);
use Sys::Hostname qw(hostname);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Package',
);

=head1 NAME

Kernel::System::UnitTest - functions to run all or some OTOBO unit tests

=head1 DESCRIPTION

The considered test scripts can be set up as:

=over 4

=item a single directory

=item multiple directories

=item a list of filters that filter the list of test scripts

=item a list of .sopm files

=back

=head1 PUBLIC INTERFACE

=head2 new()

create an unit test object. Do not use this subroutine directly. Use instead:

    my $UnitTestObject = $Kernel::OM->Get('Kernel::System::UnitTest');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    $Self->{Debug} = $Param{Debug} || 0;
    $Self->{ANSI}  = $Param{ANSI}  || 0;

    return $Self;
}

=head2 Run()

run all or some tests located in C<scripts/test/**/*.t> and print the result.

    $UnitTestObject->Run(
        Tests           => ['JSON', 'User'],           # optional, execute certain test files only
        Directory       => 'Selenium',                 # optional, execute only the tests in a subdirectory relative to scripts/test
        SOPMFiles       => ['FAQ.sopm', 'Fred.sopm' ], # optional, execute only the tests in the Filelist of the .sopm files
        Verbose         => 1,                          # optional (default 0), only show result details for all tests, not just failing
        PostTestScripts => ['...'],                    # Script(s) to execute after a test has been run.
                                                       #   You can specify %File%, %TestOk% and %TestNotOk% as dynamic arguments.
    );

You can also specify multiple directories:

    $UnitTestObject->Run(
        Directory  => [ 'SysConfig/DB', 'Selenium' ]   # optional, run test scripts from multiple directories
    );

Please note that the individual test files are not executed in the main process,
but instead in separate forked child processes which are controlled by L<Kernel::System::UnitTest::Driver>.
Their results will be transmitted to the main process via a local file.

Tests listed in B<UnitTest::Blacklist> are not executed.

Tests in F<Custom/scripts/test> take precedence over the tests in F<scripts/test>.

The options C<Tests> and C<SOPMFiles> are combined to a merged white list.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # handle parameters
    my $Verbosity           = $Param{Verbose} // 0;
    my $DirectoryParam      = $Param{Directory};      # either a scalar or an array ref
    my @ExecuteTestPatterns = ( $Param{Tests}     // [] )->@*;
    my @SOPMFiles           = ( $Param{SOPMFiles} // [] )->@*;

    # some config stuff
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Home         = $ConfigObject->Get('Home');
    my $Product      = join ' ', $ConfigObject->Get('Product'), $ConfigObject->Get('Version');
    my $Host         = hostname();

    # run tests in a subdir when requested
    my $TestDirectory = "$Home/scripts/test";
    my @Directories;
    if ( !$DirectoryParam ) {
        push @Directories, $TestDirectory;
    }
    elsif ( ref $DirectoryParam eq 'ARRAY' ) {
        for my $Directory ( $DirectoryParam->@* ) {
            push @Directories, "$TestDirectory/$Directory";
        }
    }
    else {
        push @Directories, "$TestDirectory/$DirectoryParam";
    }

    # some cleanp, why ???
    for my $Directory (@Directories) {
        $Directory =~ s/\.//g;
    }

    # add the files from the .sopm files to the whitelist
    if (@SOPMFiles) {
        my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
        FILE:
        for my $File (@SOPMFiles) {

            # for now we only consider local files
            next FILE unless -f $File;
            next FILE unless -r $File;

            my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $File,
                Mode     => 'utf8',
                Result   => 'SCALAR',
            );

            return $Self->ExitCodeError unless ref $ContentRef eq 'SCALAR';
            return $Self->ExitCodeError unless length $ContentRef->$*;

            # Parse package.
            my %Structure = $PackageObject->PackageParse(
                String => $ContentRef,
            );

            next FILE unless IsArrayRefWithData( $Structure{Filelist} );

            # for some reason the trailing .t is checked seperately
            push @ExecuteTestPatterns,
                map  {s/\.t$//r}
                grep {m!^scripts/test/!}
                map  { $_->{Location} }
                $Structure{Filelist}->@*;
        }
    }

    # Determine which tests should be skipped because of UnitTest::Blacklist
    my ( @SkippedTests, @ActualTests );
    {
        # Get patterns for blacklisted tests. The blacklisted tests are given
        # relative to $HOME/scripts/test.
        my @BlacklistPatterns;
        my $UnitTestBlacklist = $ConfigObject->Get('UnitTest::Blacklist');
        if ( IsHashRefWithData($UnitTestBlacklist) ) {

            CONFIGKEY:
            for my $ConfigKey ( sort keys $UnitTestBlacklist->%* ) {

                # check sanity of configuration, skip in case of problems
                next CONFIGKEY unless $ConfigKey;
                next CONFIGKEY unless $UnitTestBlacklist->{$ConfigKey};
                next CONFIGKEY unless IsArrayRefWithData( $UnitTestBlacklist->{$ConfigKey} );

                # filter empty values
                push @BlacklistPatterns, grep {$_} $UnitTestBlacklist->{$ConfigKey}->@*;
            }
        }

        # Collect the files in default directory or in the passed directories.
        # An empty list will be returned when $Directory is empty or when it does not exist.
        # It is quite possiple that a file is included multiple times.
        my @Files;
        for my $Directory (@Directories) {
            push @Files,
                $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                    Directory => $Directory,
                    Filter    => '*.t',
                    Recursive => 1,
                );
        }

        FILE:
        for my $File (@Files) {

            # check if only some tests are requested
            if (@ExecuteTestPatterns) {
                next FILE unless any { $File =~ /\/\Q$_\E\.t$/smx } @ExecuteTestPatterns;
            }

            # Check blacklisted files.
            if ( any { $File =~ m{\Q$TestDirectory/$_\E$}smx } @BlacklistPatterns ) {
                push @SkippedTests, $File;

                next FILE;
            }

            # Check if a file with the same path and name exists in the Custom folder.
            my $CustomFile = $File =~ s{ \A $Home }{$Home/Custom}xmsr;
            push @ActualTests, -e $CustomFile ? $CustomFile : $File;
        }
    }

    # Create the object that actually runs the test scripts.
    # The 'jobs' is not set, this means that per default tests are not run in parallel,
    # this is a requirement as test write temporary files in Kernel/Config/Files.
    my $Harness = TAP::Harness->new(
        {
            timer     => 1,
            verbosity => $Verbosity,

            # try to color the output when we are in an ANSI terminal
            color => $Self->{ANSI},

            # these libs are additional, $ENV{PERL5LIB} is still honored
            lib => [ "$Home/Custom", "$Home/Kernel/cpan-lib", $Home ],
        }
    );

# Register a callback that triggered after a test script has run.
# E.g. bin/otobo.Console.pl Dev::UnitTest::Run  --verbose --directory ACL --post-test-script 'echo file: %File%' --post-test-script 'echo ok: %TestOk%'  --post-test-script 'echo nok: %TestNotOk%' >prove_acl.out 2>&1
# See also: https://metacpan.org/pod/distribution/Test-Harness/lib/TAP/Harness/Beyond.pod#Callbacks
    if ( $Param{PostTestScripts} && ref $Param{PostTestScripts} eq 'ARRAY' && $Param{PostTestScripts}->@* ) {
        my @PostTestScripts = $Param{PostTestScripts}->@*;

        $Harness->callback(
            after_test => sub {
                my ( $TestInfo, $Parser ) = @_;

                for my $PostTestScript (@PostTestScripts) {

                    # command template as specified on the commant line
                    my $Cmd = $PostTestScript;

                    # It's not obvious when $TestInfo contains.
                    # The first array element seems to be the test script name.
                    my ($TestScript) = $TestInfo->@*;
                    $Cmd =~ s{%File%}{$TestScript}ismxg;

                    # $Parser is an instance of TAP::Parser, it represents the parsed TAP output
                    my $TestOk = $Parser->actual_passed();
                    $Cmd =~ s{%TestOk%}{$TestOk}iesmxg;
                    my $TestNotOk = $Parser->actual_failed();
                    $Cmd =~ s{%TestNotOk%}{$TestNotOk}iesmxg;

                    #use Data::Dumper;
                    #warn Dumper( [ 'LLL', $Cmd, $TestScript, $TestInfo, $Parser ] );

                    # finally do the work
                    system $Cmd;
                }
            }
        );
    }

    my $Aggregate = $Harness->runtests(@ActualTests);

    if (@SkippedTests) {
        say "Following blacklisted tests were skipped:";
        for my $SkippedTest (@SkippedTests) {
            say '  ', $Self->_Color( 'yellow', $SkippedTest );
        }
    }

    say sprintf
        'ran tests for product %s on host %s .',
        $Self->_Color( 'yellow', $Product ),
        $Self->_Color( 'yellow', $Host );

    return $Aggregate->all_passed();
}

=begin Internal:

=head2 _Color()

this will color the given text (see L<Term::ANSIColor::color()>) if
ANSI output is available and active, otherwise the text stays unchanged.

    my $PossiblyColoredText = $CommandObject->_Color('green', $Text);

=cut

sub _Color {
    my ( $Self, $Color, $Text ) = @_;

    # no coloring unless we are in an ANSI terminal
    return $Text unless $Self->{ANSI};

    # we are in an ANSI terminal
    return Term::ANSIColor::color($Color) . $Text . Term::ANSIColor::color('reset');
}

=end Internal:

=cut

1;
