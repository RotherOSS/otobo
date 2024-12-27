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

package Kernel::System::UnitTest::Formatter::Session;

use strict;
use warnings;
use v5.24;
use utf8;

# core modules
use File::Path qw(remove_tree mkpath);
use Time::HiRes qw();
use File::Spec;
use File::Copy qw(copy);

# CPAN modules
use Try::Tiny;
use XML::LibXML;

use parent 'TAP::Formatter::Console::Session';

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {
        TestCases => [],
        Queue     => [],
        %Param,
    }, $Type;

    return $Self;
}

# virtual method called to initialize the Session.
sub _initialize {
    my ( $Self, $ArgFor ) = @_;
    $ArgFor ||= {};

    my $PassingToDoOk = delete $ArgFor->{PassingToDoOk};
    $Self->{PassingToDoOk} = $PassingToDoOk;

    return $Self->SUPER::_initialize($ArgFor);
}

# virtual method called for each single test result.
sub result {
    my ( $Self, $Result ) = @_;

    # except for a few things we don't want to process as a "test case", add
    # the test result to the queue.
    if ( $Result->raw() =~ /^# Looks like you failed \d+ tests? of \d+/ )                   { return; }
    if ( $Result->raw() =~ /^# Looks like you planned \d+ tests? but ran \d+/ )             { return; }
    if ( $Result->raw() =~ /^# Looks like your test died before it could output anything/ ) { return; }

    $Result->{Time} = $Self->get_time;
    push $Self->{Queue}->@*, $Result;

    return;
}

# virtual method called after each testsuite is run.
sub close_test {
    my $Self   = shift;
    my $Xml    = $Self->{Formatter}->{Xml};
    my $Parser = $Self->{Parser};

    # Process the queued up TAP stream
    my $TStart       = $Self->{Parser}->start_time;
    my $TLastTest    = $TStart;
    my $TimerEnabled = $Self->{Formatter}->{timer};

    my $Queue = $Self->{Queue};
    my $Index = 0;

    while ( $Index < @{$Queue} ) {
        my $Result = $Queue->[ $Index++ ];

        # Test output
        if ( $Result->is_test ) {

            # how long did it take for this test?
            my $Duration = $Result->{Time} - $TLastTest;

            # slurp in all of the content up until the next test
            my $Content = $Result->as_string;
            QUEUEITEMS:
            while ( $Index < @{$Queue} ) {
                last QUEUEITEMS if ( $Queue->[$Index]->is_test );
                last QUEUEITEMS if ( $Queue->[$Index]->is_plan );

                my $Stuff = $Queue->[ $Index++ ];
                $Content .= "\n" . $Stuff->as_string;
            }

            # create a failure/error element if the test was bogus
            my $Failure;
            my $Bogosity = $Self->CheckForTestBogosity( Result => $Result );
            if ($Bogosity) {
                $Failure = $Self->XmlError(
                    Bogosity => $Bogosity,
                    Content  => $Content
                );
            }

            my @Children;
            if ($Failure) {
                push @Children, $Failure;
            }

            my $Case = $Self->XmlTestCase(
                Ref => {
                    'name'      => $Self->_GetTestcaseName( Test => $Result ),
                    'classname' => $Self->GetTestsuiteName(),
                    'file'      => $Self->{Name},
                    (
                        $TimerEnabled ? ( 'time' => $Duration ) : ()
                    ),
                },
                Children => \@Children,
            );

            push $Self->{TestCases}->@*, $Case;

            # update time of last test seen
            $TLastTest = $Result->{Time};
        }
    }

    # collect up all of the captured test output
    my $Captured = join '', map { $_->raw . "\n" } @{$Queue};

    # if the test died unexpectedly, make note of that
    my $DieMsg;
    my $Exit = $Parser->exit();
    if ($Exit) {
        my $WStat  = $Parser->wait();
        my $Status = sprintf( "%d (wstat %d, 0x%x)", $Exit, $WStat, $WStat );
        $DieMsg = "Dubious, test returned $Status";
    }

    my $SysOut = $Self->XmlSysOut(
        Tag      => 'system-out',
        Captured => $Captured
    );
    my $SysErr = $Self->XmlSysOut(
        Tag      => 'system-err',
        Captured => $DieMsg
    );

    # timing results
    my $TestsRun = $Parser->tests_run() || 0;
    my $Time     = $Parser->end_time() - $Parser->start_time();
    my $Failures = $Parser->failed();

    # test plan results
    my $Noplan  = $Parser->plan() ? 0 : 1;
    my $Planned = $Parser->tests_planned() || 0;

    my $NumErrors = 0;
    $NumErrors += $Parser->todo_passed() unless $Self->{PassingToDoOk};
    $NumErrors += abs( $TestsRun - $Planned ) if ($Planned);

    my $SuiteErr;
    if ($DieMsg) {
        $SuiteErr = $Self->XmlError(
            Bogosity => {
                level   => 'error',
                message => $DieMsg,
                type    => ''
            },
            Content => '',
        );
        $NumErrors++;
    }
    elsif ($Noplan) {
        $SuiteErr = $Self->XmlError(
            Bogosity => {
                level   => 'error',
                message => 'No plan in TAP output',
                type    => ''
            },
            Content => '',
        );
        $NumErrors++;
    }
    elsif ( $Planned && ( $TestsRun != $Planned ) ) {
        $SuiteErr = $Self->XmlError(
            Bogosity => {
                level   => 'error',
                message => "Looks like you planned $Planned tests but ran $TestsRun.",
                type    => ''
            },
            COntent => '',
        );
    }

    my @Tests = @{ $Self->{TestCases} };

    push @Tests, $SysOut;
    push @Tests, $SysErr;

    my %Attrs = (
        'name'     => $Self->GetTestsuiteName(),
        'tests'    => $TestsRun,
        'failures' => $Failures,
        'errors'   => $NumErrors,
        (
            $TimerEnabled ? ( 'time' => $Time ) : ()
        ),
    );

    if ($SuiteErr) {
        push @Tests, $SuiteErr;
    }

    my $TestSuite = $Self->XmlTestSuite(
        Ref      => \%Attrs,
        Children => \@Tests,
    );

    push $Self->{Formatter}->{TestSuites}->@*, $TestSuite;

    $Self->DumpJunitXml( TestSuite => $TestSuite );

    return;
}

sub DumpJunitXml {

    my ( $Self, %Param ) = @_;

    if ( my $SpoolDir = $ENV{PERL_TEST_HARNESS_DUMP_TAP} ) {

        my $Spool = File::Spec->catfile( $SpoolDir, $Self->{Name} . '.junit.xml' );

        # create target dir
        my ( $Vol, $Dir, undef ) = File::Spec->splitpath($Spool);
        my $Path = File::Spec->catpath( $Vol, $Dir, '' );
        mkpath($Path);

        # create JUnit XML, and dump to disk
        my $Junit = $Self->XmlTestSuites(
            Ref      => {},
            Children => [ $Param{TestSuite} ]
        );
        my $Fout = IO::File->new( $Spool, '>:utf8' )
            || die "Can't write $Spool ( $! )\n";
        $Fout->print( $Junit->toString() );
        $Fout->close();
    }

    return;
}

sub XmlSysOut {

    my ( $Self, %Param ) = @_;

    my $CData = $Self->_CData( Text => $Param{Captured} );

    my $Dom  = $Self->{Formatter}->{Dom};
    my $Node = $Dom->createElement( $Param{Tag} );

    $Node->appendChild($CData);

    return $Node;
}

sub XmlError {

    my ( $Self, %Param ) = @_;

    my $Bogosity = $Param{Bogosity};
    my $Content  = $Param{Content};

    my $CData = $Self->_CData( Text => $Content );
    my $Level = $Bogosity->{level};

    my $Dom   = $Self->{Formatter}->{Dom};
    my $Error = $Dom->createElement($Level);
    $Error->setAttribute( type    => $Bogosity->{type} );
    $Error->setAttribute( message => $Bogosity->{message} );

    $Error->appendChild($CData);

    return $Error;
}

sub XmlTestCase {

    my ( $Self, %Param ) = @_;

    my $Ref      = $Param{Ref};
    my $Children = $Param{Children};

    my $Dom      = $Self->{Formatter}->{Dom};
    my $TestCase = $Dom->createElement('testcase');

    for my $Key ( keys %$Ref ) {
        $TestCase->setAttribute( $Key, $Ref->{$Key} );
    }

    for my $Child (@$Children) {

        $TestCase->appendChild($Child);
    }

    return $TestCase;
}

sub XmlTestSuite {

    my ( $Self, %Param ) = @_;

    my $Ref      = $Param{Ref};
    my $Children = $Param{Children};

    my $Dom       = $Self->{Formatter}->{Dom};
    my $TestSuite = $Dom->createElement('testsuite');

    for my $Key ( keys %$Ref ) {
        $TestSuite->setAttribute( $Key, $Ref->{$Key} );
    }

    for my $Child (@$Children) {
        $TestSuite->appendChild($Child);
    }

    return $TestSuite;
}

sub XmlTestSuites {

    my ( $Self, %Param ) = @_;

    my $Ref      = $Param{Ref};
    my $Children = $Param{Children};

    my $Dom        = $Self->{Formatter}->{Dom};
    my $TestSuites = $Dom->createElement('testsuites');

    for my $Key ( keys %$Ref ) {
        $TestSuites->setAttribute( $Key, $Ref->{$Key} );
    }

    for my $Child (@$Children) {
        $TestSuites->appendChild($Child);
    }

    return $TestSuites;
}

sub CheckForTestBogosity {

    my ( $Self, %Param ) = @_;

    my $Result = $Param{Result};

    if ( $Result->todo_passed() && !$Self->{PassingToDoOk} ) {
        return {
            level   => 'error',
            type    => 'TodoTestSucceeded',
            message => $Result->explanation(),
        };
    }

    if ( $Result->is_unplanned() ) {
        return {
            level   => 'error',
            type    => 'UnplannedTest',
            message => $Result->as_string(),
        };
    }

    if ( !$Result->is_ok() ) {
        return {
            level   => 'failure',
            type    => 'TestFailed',
            message => $Result->as_string(),
        };
    }

    return;
}

sub GetTestsuiteName {

    my ( $Self, %Param ) = @_;

    my $Name = $Self->{Name};
    $Name =~ s{^\./}{};
    $Name =~ s{^t/}{};
    my $Javaname = $Self->_CleanToJavaClassName( Name => $Name );
    $Javaname =~ s/^scripts_test_//;
    $Javaname =~ s/_t$//;
    return $Javaname;
}

# little procedural helpers

sub _GetTestcaseName {

    my ( $Self, %Param ) = @_;

    my $Test = $Param{Test};

    my $Name = $Test->number() . ' ' . $Self->_CleanTestDescription( Test => $Test );
    $Name =~ s/\s+$//;
    return $Name;
}

sub _CleanToJavaClassName {

    my ( $Self, %Param ) = @_;

    my $Str = $Param{Name};

    $Str =~ s/[^-:_A-Za-z0-9]+/_/gs;
    return $Str;
}

sub _CleanTestDescription {

    my ( $Self, %Param ) = @_;

    my $Test = $Param{Test};

    my $Desc = $Test->description();
    return $Self->_SqueakyClean( Text => $Desc );
}

sub _CData {

    my ( $Self, %Param ) = @_;

    my $Text = $Param{Text};
    $Text = $Self->_SqueakyClean( Text => $Text );

    return XML::LibXML::CDATASection->new($Text);
}

sub _SqueakyClean {

    my ( $Self, %Param ) = @_;

    my $String = $Param{Text};

    if ( !$String ) { return ''; }

    # control characters (except CR and LF)
    $String =~ s/([\x00-\x09\x0b\x0c\x0e-\x1f])/"^".chr(ord($1)+64)/ge;

    # high-byte characters
    $String =~ s/([\x7f-\xff])/'[\\x'.sprintf('%02x',ord($1)).']'/ge;
    return $String;
}

1;
