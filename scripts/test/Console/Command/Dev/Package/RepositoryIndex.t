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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Package::RepositoryIndex');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Dev::Package::RepositoryIndex exit code without arguments",
);

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $Result;
{
    local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
    open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
    $ExitCode = $CommandObject->Execute("$Home/Kernel/Config/Files");
}

$Self->Is(
    $ExitCode,
    0,
    "Dev::Package::RepositoryIndex exit code",
);

$Self->Is(
    $Result,
    '<?xml version="1.0" encoding="utf-8" ?>
<otobo_package_list version="1.0">
</otobo_package_list>
',
    "Dev::Package::RepositoryIndex result for empty directory",
);

$Self->DoneTesting();
