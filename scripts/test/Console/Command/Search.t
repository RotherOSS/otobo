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

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Search');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Search exit code without arguments",
);

# Check command search
my $Result;

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute('Lis');
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code searching for commands",
);

$Self->False(
    index( $Result, 'otobo.Console.pl Help command' ) > -1,
    "Help for 'Help' command not found",
);

$Self->True(
    index( $Result, 'List all installed OTOBO packages' ) > -1,
    "Found Admin::Package::List command entry",
);

# Check command search (empty)

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute('NonExistingSearchTerm');
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code searching for commands",
);

$Self->False(
    index( $Result, 'otobo.Console.pl Help command' ) > -1,
    "Help for 'Help' command not found",
);

$Self->True(
    index( $Result, 'No commands found.' ) > -1,
    "No commands found.",
);

$Self->DoneTesting();
