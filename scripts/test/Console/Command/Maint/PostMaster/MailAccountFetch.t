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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::MailAccountFetch');
my $PIDObject     = $Kernel::OM->Get('Kernel::System::PID');

my $ExitCode = $CommandObject->Execute();

# Just check exit code; should be 0 also if no accounts are configured.
$Self->Is(
    $ExitCode,
    0,
    'Maint::PostMaster::MailAccountFetch exit code',
);

# lock the mail account fetch process
$PIDObject->PIDCreate(
    Name  => 'MailAccountFetch',
    Force => 1,
    TTL   => 600,                  # 10 minutes
);

$ExitCode = $CommandObject->Execute();

# Just check exit code; should be 0 also if no accounts are configured.
$Self->Is(
    $ExitCode,
    1,
    'Maint::PostMaster::MailAccountFetch exit code with already locked MailAccountFetch',
);

# unlock the mail account fetch process again
$PIDObject->PIDDelete( Name => 'MailAccountFetch' );

# test a normal fetch again with unlocked process
$ExitCode = $CommandObject->Execute();

# Just check exit code; should be 0 also if no accounts are configured.
$Self->Is(
    $ExitCode,
    0,
    'Maint::PostMaster::MailAccountFetch exit code',
);

$ExitCode = $CommandObject->Execute( '--mail-account-id', 99999 );

# Just check exit code; should be 1 since account does not exit.
$Self->Is(
    $ExitCode,
    1,
    'Maint::PostMaster::MailAccountFetch exit code for non-existing mail account'
);

$Self->DoneTesting();
