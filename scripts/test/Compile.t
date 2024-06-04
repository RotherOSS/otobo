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
use v5.24.0;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Test::Compile::Internal;

# When there are extra arguments, then limit the checks to the passed files.
# Is useful for github actions.
my $CheckOnlyChangedFiles = @ARGV ? 1 : 0;
my %FileIsChanged         = map { $_ => 1 } @ARGV;

# make sure that there is at least one test
pass('checking only the files passed via @ARGV') if $CheckOnlyChangedFiles;

# limit the checks to specific dirs
my @Dirs = qw(Kernel Custom scripts bin);

# List of files that are know to have compile issues.
# NOTE: Please create an issue when adding to this list and the reason is not acceptable.
my %FailureIsAccepted = (
    'Kernel/System/Auth/Radius.pm'               => 'Authen::Radius is not required',
    'Kernel/System/CustomerAuth/Radius.pm'       => 'Authen::Radius is not required',
    'Kernel/cpan-lib/Devel/REPL/Plugin/OTOBO.pm' => 'Devel::REPL::Plugin is not required',
    'Kernel/cpan-lib/Font/TTF/Win32.pm'          => 'Win32::Registry is not available, but never mind as Win32 is not supported',
    'Kernel/cpan-lib/LWP/Protocol/GHTTP.pm'      => 'HTTP::GHTTP is not required',
    'Kernel/cpan-lib/PDF/API2/Win32.pm'          => 'Win32::TieRegistry is not available, but never mind as Win32 is not supported',
    'Kernel/cpan-lib/SOAP/Lite.pm'               => 'some strangeness concerning SOAP::Constants',
    'Kernel/cpan-lib/URI/urn/isbn.pm'            => 'Business::ISBN is not required',
);

# object for doing the actual check
my $Internal = Test::Compile::Internal->new();

note('check syntax of the Perl modules');
{
    FILE:
    for my $File ( $Internal->all_pm_files(@Dirs) ) {

        # check only files that were passed via the command line
        next FILE if $CheckOnlyChangedFiles && !$FileIsChanged{$File};

        # Kernel/TidyAll is usually a symlink to the corresponding dir in the CodePolicy.
        # The CodePolicy scripts and modules expect 'Kernel' to be in @INC, but that isn't the case
        # in proper OTOBO. Therefore the modules in Kernel/TidyAll are skipped here.
        next FILE if $File =~ m{^Kernel/TidyAll/};

        my $ToDo = $FailureIsAccepted{$File} ? todo("$File: $FailureIsAccepted{$File}") : undef;

        ok( $Internal->pm_file_compiles($File), "$File compiles" );
    }
}

note('check syntax of the Perl scripts');
{
    FILE:
    for my $File ( $Internal->all_pl_files(@Dirs) ) {

        # check only files that were passed via the command line
        next FILE if $CheckOnlyChangedFiles && !$FileIsChanged{$File};

        my $ToDo = $FailureIsAccepted{$File} ? todo("$File: $FailureIsAccepted{$File}") : undef;

        ok( $Internal->pl_file_compiles($File), "$File compiles" );
    }
}

note('look at Perl code with an unusual extension');
{
    my @Files = (
        'bin/psgi-bin/otobo.psgi',
    );

    FILE:
    for my $File (@Files) {

        # check only files that were passed via the command line
        next FILE if $CheckOnlyChangedFiles && !$FileIsChanged{$File};

        my $ToDo = $FailureIsAccepted{$File} ? todo("$File: $FailureIsAccepted{$File}") : undef;

        ok( $Internal->pl_file_compiles($File), "$File compiles" );
    }
}

note('check syntax of some shell scripts');
{
    # grab scripts in bin/docker and bin/devel
    my @ShellScripts = glob 'bin/*/*.sh';

    if ( !$ENV{OTOBO_RUNS_UNDER_DOCKER} ) {
        push @ShellScripts, 'bin/Cron.sh';
    }

    FILE:
    for my $File (@ShellScripts) {

        # check only files that were passed via the command line
        next FILE if $CheckOnlyChangedFiles && !$FileIsChanged{$File};

        my $CompileErrors = `bash -n "$File" 2>&1`;
        is( $CompileErrors, '', "$File compiles" );
    }
}

note('check syntax of Docker hub hook scripts, when the dir hooks exists');

SKIP: {
    skip 'no hooks dir' unless -d 'hooks';

    FILE:
    for my $File ( glob 'hooks/*' ) {

        # check only files that were passed via the command line
        next FILE if $CheckOnlyChangedFiles && !$FileIsChanged{$File};

        my $CompileErrors = `bash -n "$File" 2>&1`;
        is( $CompileErrors, '', "$File compiles" );
    }
}

done_testing();
