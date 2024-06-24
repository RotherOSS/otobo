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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM

plan(1);

# Temporarily disabled to work around a mod_perl bug that occurs on Ubuntu 15.04 and gentoo atm (2016-01-29).
#
# Frontend/Basic.t finds one module to return a 500 internal error (seemingly random).
# The apache error log shows this message:
#
# [perl:error] [pid 908] [client ::1:36519] Use of each() on hash after insertion without resetting hash iterator results in undefined behavior, Perl interpreter: 0x55b01def9a90 at /opt/otobo/Kernel/cpan-lib/Apache2/Reload.pm line 171.
#
# This seems to be caused by Apache2::Reload trying to reload modules which in turn triggers an internal mod_perl bug
#   that we currently don't know.
#
# Avoid this error by not reinstalling the installed packages in the UT scenarios so that mod_perl does not try to reload the packages.

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::ReinstallAll');

my $ExitCode = $CommandObject->Execute();

is( $ExitCode, 0, 'Admin::Package::ReinstallAll exit code' );
