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
use File::Basename;
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

sub _initialize {
    my ( $Self, $ArgFor ) = @_;
    $ArgFor ||= {};

    my $PassingToDoOk = delete $ArgFor->{PassingToDoOk};
    $Self->{PassingToDoOk} = $PassingToDoOk;

    return $Self->SUPER::_initialize($ArgFor);
}

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
            my $Bogosity = $Self->CheckForTestBogosity($Result);
            if ($Bogosity) {
                $Failure = $Self->XmlError( $Bogosity, $Content );
            }

            my @Children;
            if ($Failure) {
                push @Children, $Failure;
            }

            my $Case = $Self->XmlTestCase(
                {
                    'name'      => _GetTestcaseName($Result),
                    'classname' => $Self->GetTestsuiteName(),
                    'file'  => basename( $Self->{Name} ),
                    (
                        $TimerEnabled ? ( 'time' => $Duration ) : ()
                    ),
                },
                \@Children,
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

    my $SysOut = $Self->XmlSysOut( 'system-out', $Captured );
    my $SysErr = $Self->XmlSysOut( 'system-err', $DieMsg );

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
            {
                level   => 'error',
                message => $DieMsg,
                type    => ''
            }
        );
        $NumErrors++;
    }
    elsif ($Noplan) {
        $SuiteErr = $Self->XmlError(
            {
                level   => 'error',
                message => 'No plan in TAP output',
                type    => ''
            }
        );
        $NumErrors++;
    }
    elsif ( $Planned && ( $TestsRun != $Planned ) ) {
        $SuiteErr = $Self->XmlError(
            {
                level   => 'error',
                message => "Looks like you planned $Planned tests but ran $TestsRun.",
                type    => ''
            }
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
        \%Attrs,
        \@Tests
    );

    push $Self->{Formatter}->{TestSuites}->@*, $TestSuite;

    $Self->DumpJunitXml($TestSuite);

    return;
}

sub DumpJunitXml {
    my ( $Self, $TestSuite ) = @_;
    if ( my $SpoolDir = $ENV{PERL_TEST_HARNESS_DUMP_TAP} ) {

        my $Spool = File::Spec->catfile( $SpoolDir, $Self->{Name} . '.junit.xml' );

        # create target dir
        my ( $Vol, $Dir, undef ) = File::Spec->splitpath($Spool);
        my $Path = File::Spec->catpath( $Vol, $Dir, '' );
        mkpath($Path);

        # create JUnit XML, and dump to disk
        my $Junit = $Self->XmlTestSuites( {}, [$TestSuite] );
        my $Fout  = IO::File->new( $Spool, '>:utf8' )
            || die "Can't write $Spool ( $! )\n";
        $Fout->print( $Junit->toString() );
        $Fout->close();
    }

    return;
}

sub XmlSysOut {

    my $Self    = shift;
    my $Name    = shift;
    my $Content = shift;

    my $CData = _CData($Content);

    my $Dom  = $Self->{Formatter}->{Dom};
    my $Node = $Dom->createElement($Name);

    $Node->appendChild($CData);

    return $Node;
}

sub XmlError {

    my $Self     = shift;
    my $Bogosity = shift;
    my $Content  = shift;

    my $CData = _CData($Content);
    my $Level = $Bogosity->{level};

    my $Dom   = $Self->{Formatter}->{Dom};
    my $Error = $Dom->createElement($Level);
    $Error->setAttribute( type    => $Bogosity->{type} );
    $Error->setAttribute( message => $Bogosity->{message} );

    $Error->appendChild($CData);

    return $Error;
}

sub XmlTestCase {

    my $Self     = shift;
    my $Ref      = shift;
    my $Children = shift;

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

    my $Self     = shift;
    my $Ref      = shift;
    my $Children = shift;

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

    my $Self     = shift;
    my $Ref      = shift;
    my $Children = shift;

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
    my $Self   = shift;
    my $Result = shift;

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
    my $Self = shift;
    my $Name = $Self->{Name};
    $Name =~ s{^\./}{};
    $Name =~ s{^t/}{};
    my $Javaname = _CleanToJavaClassName($Name);
    $Javaname =~ s/^scripts_test_//;
    $Javaname =~ s/_t$//;
    return $Javaname;
}


# little procedural helpers

sub _GetTestcaseName {
    my $Test = shift;

    my $Name = $Test->number() . ' ' . _CleanTestDescription($Test);
    $Name =~ s/\s+$//;
    return $Name;
}

sub _CleanToJavaClassName {
    my $Str = shift;
    $Str =~ s/[^-:_A-Za-z0-9]+/_/gs;
    return $Str;
}

sub _CleanTestDescription {
    my $Test = shift;
    my $Desc = $Test->description();
    return _SqueakyClean($Desc);
}

sub _CData {
    my ($Data) = @_;
    $Data = _SqueakyClean($Data);

    return XML::LibXML::CDATASection->new($Data);
}

sub _SqueakyClean {
    my $String = shift;

    if ( !$String ) { return ''; }

    # control characters (except CR and LF)
    $String =~ s/([\x00-\x09\x0b\x0c\x0e-\x1f])/"^".chr(ord($1)+64)/ge;

    # high-byte characters
    $String =~ s/([\x7f-\xff])/'[\\x'.sprintf('%02x',ord($1)).']'/ge;
    return $String;
}

1;
