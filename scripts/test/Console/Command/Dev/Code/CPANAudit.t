# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

# core modules

# CPAN modules
use Test2::V0;
use Test2::Tools::Compare qw(bag array);
use Test2::Tools::Explain;
use Capture::Tiny qw(capture);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $ThawedAuditReport;
{
    # run the console command and capture the output
    my $AuditCommand = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Code::CPANAudit');
    my ( $JSONString, undef, $ExitCode ) = capture {
        return $AuditCommand->Execute;
    };
    ok( $ExitCode == 0 || $ExitCode == 1, 'command exited with a sane code' );

    # Get a data structure from the printed JSON
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    $ThawedAuditReport = $JSONObject->Decode( Data => $JSONString );
    ref_ok(
        $ThawedAuditReport,
        'HASH',
        'got hash from DumpAll'
    );
}

# just a sanity check of the keys on the top level
for my $Key (qw( dists errors meta )) {
    ok( exists $ThawedAuditReport->{$Key}, "top level key '$Key' exists" );
}

# check keys on the meta level
for my $Key (qw( args command cpan_audit total_advisories )) {
    ok( exists $ThawedAuditReport->{meta}->{$Key}, "key 'meta->$Key' exists" );
}

# check the version of the advisories list
is(
    $ThawedAuditReport->{meta}->{cpan_audit},
    {
        db      => '20260129.001',
        version => '20250829.001',
    },
    'got expected version of the advisory list'
);

# There are known advisories. Report only on new advisories.
my @Excemptions = (
    {
        'App-cpanminus' => {
            advisories => bag {
                item { cves => array { item 'CVE-2024-45321'; end(); } };
                end();
            },
        }
    },
    {
        'File-Temp' => {
            advisories => bag {
                item { cves => array { item 'CVE-2011-4116'; end(); } };
                end();
            },
        }
    },
    {
        'Mojolicious' => {
            advisories => bag {
                item { cves => array { item 'CVE-2024-58135'; end(); } };
                item { cves => array { item 'CVE-2024-58134'; end(); } };
                end();
            },
        }
    },
    {
        'Mozilla-CA' => {
            advisories => bag {
                item { cves => array { item 'CVE-2024-39689'; end(); } };
                end();
            },
        }
    },
    {
        'perl-ldap' => {
            advisories => bag {
                item { cves => array { item 'CVE-2020-16093'; end(); } };
                end();
            },
        }
    },
);

for my $Excemption (@Excemptions) {
    my ($Dist) = keys $Excemption->%*;
    my $Found = like(
        $ThawedAuditReport->{dists},
        $Excemption,
        "found dist $Dist with matching advisories"
    );

    if ($Found) {
        delete $ThawedAuditReport->{dists}->{$Dist};
    }
}

my $FoundNoUnexpedtedAdvisories = is(
    $ThawedAuditReport->{dists},
    {},
    'no unexpected advisories'
);

if ( !$FoundNoUnexpedtedAdvisories ) {
    diag explain $ThawedAuditReport->{dists};
}

done_testing;
