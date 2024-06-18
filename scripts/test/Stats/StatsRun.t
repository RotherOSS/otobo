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

$Self->True(
    scalar keys %{$Stats},
    ( scalar keys %{$Stats} ) . " Stats found",
);

STATID:
for my $StatID ( sort { int $a <=> int $b } keys %{$Stats} ) {
    my $Stat = $StatsObject->StatsGet( StatID => $StatID );

    next STATID if ( $Stat->{StatType} eq 'static' );

    my $ResultLive = $StatsObject->StatsRun(
        StatID   => $StatID,
        GetParam => $Stat,
        UserID   => 1,
    );

    $Self->True(
        ref $ResultLive eq 'ARRAY',
        "StatsRun live mode (StatID $StatID)",
    );

    my $ResultPreview = $StatsObject->StatsRun(
        StatID   => $StatID,
        GetParam => $Stat,
        Preview  => 1,
        UserID   => 1,
    );

    $Self->True(
        ref $ResultPreview eq 'ARRAY',
        "StatsRun preview mode (StatID $StatID) $Stat->{Object}",
    ) || next STATID;

    $Self->True(
        ref $ResultPreview->[1] eq 'ARRAY',
        "StatsRun preview mode headline (StatID $StatID) $Stat->{Object}",
    ) || next STATID;

    $Self->Is(
        scalar @{ $ResultPreview->[1] },
        scalar @{ $ResultLive->[1] },
        "StatsRun preview result has same number of columns in Row 1 as live result (StatID $StatID) $Stat->{Object}",
    );

    # TicketList stats make a ticket search and that could return identical results in preview and live
    #   if there are not enough tickets in the system (for example just one).
    if ( $Stat->{Object} ne 'TicketList' ) {
        $Self->IsNotDeeply(
            $ResultLive,
            $ResultPreview,
            "StatsRun differs between live and preview (StatID $StatID)",
        );
    }
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
