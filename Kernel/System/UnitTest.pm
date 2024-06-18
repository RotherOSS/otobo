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

package Kernel::System::UnitTest;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use Term::ANSIColor ();
use TAP::Harness    ();
use List::Util      qw(any shuffle uniq);
use Sys::Hostname   qw(hostname);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Package',
);

=head1 NAME

Kernel::System::UnitTest - functions to run all or some OTOBO unit test scripts

=head1 DESCRIPTION

The considered test scripts can be set up as:

=over 4

=item a single directory

=item multiple directories

=item a list of filters that filter the list of test scripts

=item a list of .sopm files that add the files referenced in FileList to the filter list

=item a list of package names that add the files of the installed package to the filter list

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
        Tests           => [                    # optional, execute certain test files only
            'JSON',
            'User'
        ],
        TestScriptPathes => [                   # optional, execute specific test scripts or scripts in dir
            'scripts/test/DB',
            'scripts/test/NutsAndBolts.t'
        ],
        Directory       => 'Selenium',          # optional, execute only the tests in a subdirectory relative to scripts/test
        SOPMFiles       => [                    # optional, execute only the tests in the Filelist of the .sopm files
            'FAQ.sopm',
            'Fred.sopm'
        ],
        Packages        => [                    # optional, execute only the tests in the Filelist of the installed package
            'Survey',                           #   'core' indicates the core files listed in ARCHIVE
            'TimeAccounting'
        ],
        Verbose         => 1,                   # optional (default 0), only show result details for all tests, not just failing
        Merge           => 1,                   # optional (default 0), merge STDERR and STDOUT of test scripts
        PostTestScripts => ['...'],             # Script(s) to execute after a test has been run.
                                                #   You can specify %File%, %TestOk% and %TestNotOk% as dynamic arguments.
    );

You can also specify multiple directories:

    $UnitTestObject->Run(
        Directory  => [ 'SysConfig/DB', 'Selenium' ]   # optional, run test scripts from multiple directories
    );

It is a goal that there are no dependencies between the test scripts. This can be tested
by randomly ordering the test scripts.

    $UnitTestObject->Run(
        Shuffle  => 1, # randomly order the test scripts
    );

Please note that the individual test files are not executed in the main process,
but instead in separate forked child processes which are controlled by L<Kernel::System::UnitTest::Driver>.
Their results will be transmitted to the main process via a local file.

Tests in F<Custom/scripts/test> take precedence over the tests in F<scripts/test>.

The options C<Tests>, C<SOPMFiles>, and C<Packages> are combined to a merged white list.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # handle parameters
    my $Verbosity        = $Param{Verbose} // 0;    # print test results when set to 1
    my $Merge            = $Param{Merge}   // 0;
    my $DoShuffle        = $Param{Shuffle} // 0;
    my $DirectoryParam   = $Param{Directory};       # either a scalar or an array ref
    my @SOPMFiles        = ( $Param{SOPMFiles}        // [] )->@*;
    my @Packages         = ( $Param{Packages}         // [] )->@*;
    my @TestScriptPathes = ( $Param{TestScriptPathes} // [] )->@*;

    # The tests specified with the option --test indicate the file name
    # or optionally one or more parent directories.
    # The trailing .t is appended unless it was already passed.
    my @ExecuteTestPatterns =
        map {qr!/\Q$_\E$!smx}
        map { m/\.t$/ ? $_ : "$_.t" }
        ( $Param{Tests} // [] )->@*;

    # some config stuff
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Home         = $ConfigObject->Get('Home');
    my $Product      = join ' ', $ConfigObject->Get('Product'), $ConfigObject->Get('Version');
    my $Host         = hostname();

    my @ActualTestScripts;
    if (@TestScriptPathes) {

        # only the explicit list counts, all other options are ignored
        for my $TestScriptPath (@TestScriptPathes) {
            if ( -f $TestScriptPath ) {
                push @ActualTestScripts, $TestScriptPath;
            }
            elsif ( -d $TestScriptPath ) {

                # no special handling of 'Custom' dir
                push @ActualTestScripts,
                    $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                        Directory => $TestScriptPath,
                        Filter    => '*.t',
                        Recursive => 1,
                    );
            }
            else {
                # do nothing
            }
        }
    }
    else {

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
            SOPM_FILE:
            for my $SopmFile (@SOPMFiles) {

                # for now we only consider local files
                next SOPM_FILE unless -f $SopmFile;
                next SOPM_FILE unless -r $SopmFile;

                my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                    Location => $SopmFile,
                    Mode     => 'utf8',
                    Result   => 'SCALAR',
                );

                return $Self->ExitCodeError unless ref $ContentRef eq 'SCALAR';
                return $Self->ExitCodeError unless length $ContentRef->$*;

                # Parse package.
                my %Structure = $PackageObject->PackageParse(
                    String => $ContentRef,
                );

                next SOPM_FILE unless IsArrayRefWithData( $Structure{Filelist} );

                # collect all test scripts below scripts/test
                push @ExecuteTestPatterns,
                    map  {qr!/\Q$_\E$!smx}
                    grep {m!^scripts/test/!}
                    map  { $_->{Location} }
                    $Structure{Filelist}->@*;
            }
        }

        # add the files from the installed packages to the whitelist
        if (@Packages) {

            # get the details of all installed packages
            my $PackageObject     = $Kernel::OM->Get('Kernel::System::Package');
            my @PackageList       = $PackageObject->RepositoryList();
            my %PackageListLookup = map { $_->{Name}->{Content} => $_ } @PackageList;

            PACKAGE:
            for my $Package (@Packages) {

                # Special package name. Get test scripts in OTOBO core.
                if ( $Package eq 'core' ) {
                    my $ChecksumFile = "$Home/ARCHIVE";
                    my $ChecksumFileArrayRef;
                    if ( -e $ChecksumFile ) {
                        $ChecksumFileArrayRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                            Location        => $ChecksumFile,
                            Mode            => 'utf8',
                            Type            => 'Local',
                            Result          => 'ARRAY',
                            DisableWarnings => 1,
                        );
                    }

                    if ( $ChecksumFileArrayRef && @{$ChecksumFileArrayRef} ) {

                        # for some reason the trailing .t is checked seperately
                        push @ExecuteTestPatterns,
                            map  {qr!/\Q$_\E$!smx}
                            grep {m!^scripts/test/!}
                            map  {s/\s+$//r}
                            map  {s/.*:://r}           # remove the leading MD5sum
                            $ChecksumFileArrayRef->@*;
                    }
                }

                # Silently ignore not installed packages
                next PACKAGE unless $PackageListLookup{$Package};

                # package is already parsed
                my %Structure = $PackageListLookup{$Package}->%*;

                next PACKAGE unless IsArrayRefWithData( $Structure{Filelist} );

                # collect all test scripts below scripts/test
                push @ExecuteTestPatterns,
                    map  {qr!/\Q$_\E$!smx}
                    grep {m!^scripts/test/!}
                    map  { $_->{Location} }
                    $Structure{Filelist}->@*;
            }
        }

        # Collect the files in default directory or in the passed directories.
        # An empty list will be returned when $Directory is empty or when it does not exist.
        my @Files;
        for my $Directory (@Directories) {
            push @Files,
                $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                    Directory => $Directory,
                    Filter    => '*.t',
                    Recursive => 1,
                );
        }

        # Weed out duplicate files.
        @Files = uniq @Files;

        # shuffle if requested
        if ($DoShuffle) {
            @Files = shuffle @Files;
        }

        # check if only some tests are requested
        if (@ExecuteTestPatterns) {
            @Files = grep {
                my $File = $_;
                any { $File =~ $_ } @ExecuteTestPatterns
            } @Files;
        }

        # Check if a file with the same path and name exists in the Custom folder.
        FILE:
        for my $File (@Files) {
            my $CustomFile = $File =~ s{ \A $Home }{$Home/Custom}xmsr;
            push @ActualTestScripts, -e $CustomFile ? $CustomFile : $File;
        }
    }

    # Create the object that actually runs the test scripts.
    # The 'jobs' is not set, this means that per default tests are not run in parallel,
    # this is a requirement as test write temporary files in Kernel/Config/Files.
    my $Harness = TAP::Harness->new(
        {
            timer     => 1,
            verbosity => $Verbosity,
            merge     => $Merge,

            # try to color the output when we are in an ANSI terminal
            color => $Self->{ANSI},

            # these libs are additional, $ENV{PERL5LIB} is still honored
            lib => [ "$Home/Custom", "$Home/Kernel/cpan-lib", $Home ],
        }
    );

    # Register a callback that triggered after a test script has run.
    # E.g.:
    #   bin/otobo.Console.pl Dev::UnitTest::Run  --verbose --directory ACL \
    #     --post-test-script 'echo file: %File%' \
    #     --post-test-script 'echo ok: %TestOk%' \
    #     --post-test-script 'echo nok: %TestNotOk%' > prove_acl.out 2>&1
    # See also: https://metacpan.org/pod/distribution/Test-Harness/lib/TAP/Harness/Beyond.pod#Callbacks
    if ( $Param{PostTestScripts} && ref $Param{PostTestScripts} eq 'ARRAY' && $Param{PostTestScripts}->@* ) {
        my @PostTestScripts = $Param{PostTestScripts}->@*;

        $Harness->callback(
            after_test => sub {
                my ( $TestInfo, $Parser ) = @_;

                for my $PostTestScript (@PostTestScripts) {

                    # command template as specified on the command line
                    my $Cmd = $PostTestScript;

                    # It's not obvious what $TestInfo contains.
                    # The first array element seems to be the test script name.
                    my ($TestScript) = $TestInfo->@*;
                    $Cmd =~ s{%File%}{$TestScript}ismxg;

                    # $Parser is an instance of TAP::Parser, it represents the parsed TAP output
                    my $TestOk = $Parser->actual_passed();
                    $Cmd =~ s{%TestOk%}{$TestOk}iesmxg;
                    my $TestNotOk = $Parser->actual_failed();
                    $Cmd =~ s{%TestNotOk%}{$TestNotOk}iesmxg;

                    # finally do the work
                    system $Cmd;
                }
            }
        );
    }

    my $Aggregate = $Harness->runtests(@ActualTestScripts);

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
