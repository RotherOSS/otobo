#!/usr/bin/env perl
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

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Kernel::System::ObjectManager;

use Getopt::Long;

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-DBUpdate-to-10.1.pl',
    },
);

## get options
#my %Options = (
#    Help           => 0,
#    NonInteractive => 0,
#    Timing         => 0,
#    Verbose        => 0,
#);
#Getopt::Long::GetOptions(
#    'help',                      \$Options{Help},
#    'non-interactive',           \$Options{NonInteractive},
#    'cleanup-orphaned-articles', \$Options{CleanupOrphanedArticles},
#    'timing',                    \$Options{Timing},
#    'verbose',                   \$Options{Verbose},
#);

$Kernel::OM->Create('scripts::DBUpdateTo10_1')->Run();

exit 0;
