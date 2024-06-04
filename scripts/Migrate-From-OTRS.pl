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
use utf8;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Kernel::System::ObjectManager;

use Getopt::Long;

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-Migrate-From-OTRS.pl',
    },
);

# get options
my %Options = (
    Help           => 0,
    NonInteractive => 0,
    Timing         => 0,
    Verbose        => 0,
    OTRS6path      => '/opt/otrs/',
);
Getopt::Long::GetOptions(
    'help',            \$Options{Help},
    'non-interactive', \$Options{NonInteractive},
    'OTRS-6-path',     \$Options{OTRS6path},
    'timing',          \$Options{Timing},
    'verbose',         \$Options{Verbose},
);

{
    if ( $Options{Help} ) {
        print <<"EOF";

Migrate-From-OTRS.pl - Upgrade script for OTRS 5 to 6 migration.
Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.io/

Usage: $0
    Options are as follows:
        --help                          display this help
        --non-interactive               skip interactive input and display steps to execute after script has been executed
        --OTRS-6-path                   path to the OTRS 6 directory
        --timing                        shows how much time is consumed on each task execution in the script
        --verbose                       shows details on some migration steps, not just failing.

EOF
        exit 1;
    }

    # UID check
    if ( $> == 0 ) {    # $EFFECTIVE_USER_ID
        die "
Cannot run this program as root.
Please run it as the 'otobo' user or with the help of su:
    su -c \"$0\" -s /bin/bash otobo
";
    }

    my $Result = $Kernel::OM->Create('Kernel::System::MigrateFromOTRS')->Run(
        OTRSHomePath       => '/opt/otrs/',
        Task               => 'OTOBOPerlModulesCheck',
        CommandlineOptions => \%Options,
        UserID             => 1,
    );

    print "Result: " . $Kernel::OM->Get('Kernel::System::Main')->Dump($Result);

    exit 0;
}

1;
