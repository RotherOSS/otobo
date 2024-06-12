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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Try::Tiny;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

subtest 'GetLogEntry() after Log()' => sub {
    $Kernel::OM->ObjectsDiscard;                 # start on a clean slate

    my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
    $Helper->ConfigSettingChange(
        Valid => 1,
        Key   => 'MinimumLogLevel',
        Value => 'info',
    );

    my $ExpectedInfo   = '🌨';
    my $ExpectedNotice = '⛄ was built';
    my $ExpectedError  = '⛄ has melted';

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => $ExpectedInfo,
    );

    {
        my $GottenInfo = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'info',
            What => 'Message',
        );
        like( $GottenInfo, qr/\Q$ExpectedInfo\E/, 'info after Log()' );

        my $GottenNotice = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'notice',
            What => 'Message',
        );
        is( $GottenNotice, '', 'notice before Log()' );

        my $GottenError = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'error',
            What => 'Message',
        );
        is( $GottenError, '', 'error before Log()' );
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => $ExpectedNotice,
    );
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $ExpectedError,
    );

    {
        my $GottenInfo = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'info',
            What => 'Message',
        );
        like( $GottenInfo, qr/\Q$ExpectedInfo\E/, 'info after Log(), checking again' );

        my $GottenNotice = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'notice',
            What => 'Message',
        );
        like( $GottenNotice, qr/\Q$ExpectedNotice\E/, 'notice after Log()' );

        my $GottenError = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'error',
            What => 'Message',
        );
        like( $GottenError, qr/\Q$ExpectedError\E/, 'error after Log()' );
    }
};

subtest 'GetLogEntry() after ObjectsDiscard' => sub {
    $Kernel::OM->ObjectsDiscard;    # start on a clean slate

    my $GottenInfo = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'info',
        What => 'Message',
    );
    is( $GottenInfo, '', 'info in clean slate' );

    my $GottenNotice = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'notice',
        What => 'Message',
    );
    is( $GottenNotice, '', 'notice in clean slate' );

    my $GottenError = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'error',
        What => 'Message',
    );
    is( $GottenError, '', 'error in clean slate' );
};

# the eval error, that is $@, should not be clobbered
{
    $Kernel::OM->ObjectsDiscard;    # start on a clean slate

    my $ExpectedError = '⛄ ran away';

    # provoke an exception and log it
    eval { die $ExpectedError };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EVAL_ERROR is '$@'",
        );
    }

    my $GottenError = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'error',
        What => 'Message',
    );
    like( $GottenError, qr/\Q$ExpectedError\E/, '$EVAL_ERROR was not clobbered' );
}

# Try::Tiny
{
    $Kernel::OM->ObjectsDiscard;    # start on a clean slate

    my $ExpectedError = '⛄ has been stolen';

    # provoke an exception and log it
    try {
        die $ExpectedError;
    }
    catch {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EVAL_ERROR is '$_'",    # try sets the topic variable $_
        );
    };

    my $GottenError = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
        Type => 'error',
        What => 'Message',
    );
    like( $GottenError, qr/\Q$ExpectedError\E/, 'with Try::Tiny the exception is logged' );
}

done_testing;
