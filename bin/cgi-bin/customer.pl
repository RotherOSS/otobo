#!/usr/bin/env perl
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

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::Web::InterfaceCustomer();
use Kernel::System::ObjectManager;

# make sure that the managed objects will be recreated for the current request
local $Kernel::OM = Kernel::System::ObjectManager->new();

# 0 = debug messages off; 1 = debug messages on;
my $Debug = 0;

# do the work and give the response to the webserver
print
    Kernel::System::Web::InterfaceCustomer->new(
        Debug => $Debug
    )->HeaderAndContent();
