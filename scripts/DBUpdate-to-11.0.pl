#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

use v5.24;
use strict;
use warnings;
use utf8;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

# core modules
#use Getopt::Long;

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

$Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-DBUpdate-to-11.0.pl',
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

$Kernel::OM->Create('scripts::DBUpdateTo11_0')->Run;

exit 0;
