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

package Kernel::System::Console::Command::Dev::UnitTest::Run;

use strict;
use warnings;
use v5.24.0;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::UnitTest',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Execute unit tests using TAP::Harness.');
    $Self->AddOption(
        Name => 'test',
        Description =>
            "Run individual test files, e.g. 'Ticket' or 'Ticket/ArchiveFlags' (can be specified several times).",
        Required   => 0,
        HasValue   => 1,
        Multiple   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'directory',
        Description => 'Run all test files in the specified directory.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'verbose',
        Description => 'Show details for all tests, not just failing.',
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name => 'post-test-script',
        Description =>
            'Script(s) to execute after a test has been run. You can specify %File%, %TestOk% and %TestNotOk% as dynamic arguments.',
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
        Multiple   => 1
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::UnitTest' => {
            ANSI => $Self->{ANSI}, # as determined in Kernel::System::Console::BaseCommand
        },
    );

    # Allow specification of a default directory to limit test execution.
    my $DefaultDirectory = $Kernel::OM->Get('Kernel::Config')->Get('UnitTest::DefaultDirectory');

    my $FunctionResult = $Kernel::OM->Get('Kernel::System::UnitTest')->Run(
        Tests                  => $Self->GetOption('test'),
        Directory              => $Self->GetOption('directory') || $DefaultDirectory,
        Verbose                => $Self->GetOption('verbose'),
        PostTestScripts        => $Self->GetOption('post-test-script'),
    );

    return $Self->ExitCodeOk() if $FunctionResult;
    return $Self->ExitCodeError();
}

1;
