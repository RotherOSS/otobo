# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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
use Test2::Tools::Explain;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

# get needed objects
my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

my $Stats = $StatsObject->StatsListGet(
    UserID => 1,
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

ok(
    scalar keys $Stats->%*,
    ( scalar keys $Stats->%* ) . " Stats found",
);

# Testing all of the stats
for my $StatID ( sort { int $a <=> int $b } keys $Stats->%* ) {

    subtest "testing stat with StatID = $StatID" => sub {

        my $Stat = $StatsObject->StatsGet( StatID => $StatID );

        ref_ok(
            $Stat,
            'HASH',
            "got info about a stat",
        ) || return;

        note sprintf 'Title is %s',  ( $Stat->{Title}  || 'unknown' );
        note sprintf 'Object is %s', ( $Stat->{Object} || 'unknown' );

        return if $Stat->{StatType} eq 'static';

        my $ResultLive = $StatsObject->StatsRun(
            StatID   => $StatID,
            GetParam => $Stat,
            UserID   => 1,
        );

        ref_ok(
            $ResultLive,
            'ARRAY',
            "StatsRun live mode",
        );

        my $ResultPreview = $StatsObject->StatsRun(
            StatID   => $StatID,
            GetParam => $Stat,
            Preview  => 1,
            UserID   => 1,
        );

        ref_ok(
            $ResultPreview,
            'ARRAY',
            "StatsRun preview mode",
        ) || return;

        ref_ok(
            $ResultPreview->[1],
            'ARRAY',
            "StatsRun preview mode headline",
        ) || return;

        is(
            scalar @{ $ResultPreview->[1] },
            scalar @{ $ResultLive->[1] },
            "StatsRun preview result has same number of columns in Row 1 as live result",
        );

        # TicketList stats make a ticket search and that could return identical results in preview and live
        #   if there are not enough tickets in the system (for example just one).
        if ( $Stat->{Object} ne 'TicketList' ) {
            my $IsOK = isnt(
                $ResultLive,
                $ResultPreview,
                "StatsRun differs between live and preview",
            );

            if ( !$IsOK ) {
                note explain $Stat;
                note explain $ResultLive;
                note explain $ResultPreview;
            }
        }
    };
}

done_testing;
