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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my %NewSessionData = (
    UserLogin => 'root',
    UserEmail => 'root@example.com',
    UserType  => 'User',
);

# get session object
my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

my $SessionID = $SessionObject->CreateSessionID(%NewSessionData);

$Self->True(
    $SessionID,
    "SessionID created",
);

my ( $Result, $ExitCode );

# get ListAll command object
my $ListAllCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::ListAll');
{
    local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $ListAllCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListAll exit code",
);

$Self->True(
    scalar $Result =~ m{$SessionID}xms,
    "SessionID is listed",
);

# get DeleteAll command object
my $DeleteAllCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::DeleteAll');

$ExitCode = $DeleteAllCommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "DeleteAll exit code",
);

$Self->Is(
    scalar $SessionObject->GetAllSessionIDs(),
    0,
    "Sessions removed",
);

undef $Result;

{
    local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $ListAllCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListAll exit code",
);

$Self->True(
    scalar $Result !~ m{$SessionID}xms,
    "SessionID is no longer listed",
);

$SessionID = $SessionObject->CreateSessionID(%NewSessionData);

# get DeleteExpired command object
my $DeleteExpiredCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::DeleteExpired');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SessionMaxTime',
    Value => 10000
);

$ExitCode = $DeleteExpiredCommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "DeleteExpired exit code",
);

$Self->Is(
    scalar $SessionObject->GetAllSessionIDs(),
    1,
    "Sessions still alive",
);

undef $Result;

# get ListExpired command object
my $ListExpiredCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::ListExpired');
{
    local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $ListExpiredCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListExpired exit code",
);

$Self->True(
    scalar $Result !~ m{$SessionID}xms,
    "SessionID is not listed as expired",
);

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SessionMaxTime',
    Value => -1
);

undef $Result;

{
    local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $ListExpiredCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListExpired exit code",
);

$Self->True(
    scalar $Result =~ m{$SessionID}xms,
    "SessionID is listed as expired",
);

$ExitCode = $DeleteExpiredCommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "DeleteExpired exit code",
);

$Self->Is(
    scalar $SessionObject->GetAllSessionIDs(),
    0,
    "Expired sessions deleted",
);

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
