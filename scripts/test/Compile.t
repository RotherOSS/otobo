# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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

my $Internal = Test::Compile::Internal->new();
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
    'scripts/apache2-perl-startup.pl'            => 'mod_perl not neccessarily available',
);

note( 'check syntax of the Perl modules' );

foreach my $File ( $Internal->all_pm_files(@Dirs) ) {
    if ( $FailureIsAccepted{$File} ) {
        my $ToDo = todo "$File: $FailureIsAccepted{$File}";

        ok( $Internal->pm_file_compiles($File), "$File compiles" );
    }
    else {
        ok( $Internal->pm_file_compiles($File), "$File compiles" );
    }
}

note( 'check syntax of the Perl scripts' );

foreach my $File ( $Internal->all_pl_files(@Dirs) ) {
    if ( $FailureIsAccepted{$File} ) {
        my $ToDo = todo "$File: $FailureIsAccepted{$File}";

        ok( $Internal->pl_file_compiles($File), "$File compiles" );
    }
    else {
        ok( $Internal->pl_file_compiles($File), "$File compiles" );
    }
}

note( 'look at Perl code with an unusual extension' );
{
    my @Files = (
        'bin/psgi-bin/otobo.psgi',
    );
    foreach my $File ( @Files ) {
        if ( $FailureIsAccepted{$File} ) {
            my $ToDo = todo "$File: $FailureIsAccepted{$File}";

            ok( $Internal->pl_file_compiles($File), "$File compiles" );
        }
        else {
            ok( $Internal->pl_file_compiles($File), "$File compiles" );
        }
    }
}

note( 'check syntax of some shell scripts' );
{
    my @ShellScripts = glob 'bin/docker/*.sh';

    if ( ! $ENV{OTOBO_RUNS_UNDER_DOCKER} ) {
        push @ShellScripts, 'bin/Cron.sh';
    }

    # git hooks
    push @ShellScripts, 'Kernel/System/Console/Command/Dev/Git/InstallHooks/prepare-commit-msg.dist';

    for my $File ( @ShellScripts ) {
        my $CompileErrors = `bash -n "$File" 2>&1`;
        is( $CompileErrors, '', "$File compiles" );
    }
}

note( 'check syntax of Docker hub hook scripts, when the dir hooks exists' );

SKIP: {
    skip 'no hooks dir' if ! -d 'hooks';

    for my $File ( glob 'hooks/*' ) {
        my $CompileErrors = `bash -n "$File" 2>&1`;
        is( $CompileErrors, '', "$File compiles" );
    }
}

done_testing();
