# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and $Self

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $StatsReportObject = $Kernel::OM->Get('Kernel::System::StatsReport');

# define needed variable
my $RandomID = $Helper->GetRandomID();

my @Tests = (
    {
        Name          => 'test 1',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => 'SimpleStatsReport',
                Description => 'Test',
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 2',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => 'SimpleStatsReport',
                Description => '!"§$%&/()=?Ü*ÄÖL:L@,.-.',
            },
            ValidID => 2,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 3',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config  => {},
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => { 1 => 1 },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 4',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'SimpleStatsReport',
                Description => "lorem ipsum\nasdkaosdkoa\tsada\n",
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the name must be 'test 4', because the purpose if that it fails on
    {
        Name          => 'test 4',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'SimpleStatsReport',
                Description => 'Test',
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 5 - Invalid Config Add (Undef)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 6 - Invalid Config Add (String)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config  => 'Something',
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 7 - Invalid Config Update (string Config)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Description => 'Test',
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => 'string',
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 8 - Invalid Config Update (empty Config)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Description => 'Test',
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => {},
            ValidID => 1,
            UserID  => 1,
        },
    },
);

my @StatsReportIDs;
my %CheckStatsReportIDs;
TEST:
for my $Test (@Tests) {

    # add config
    my $StatsReportID = $StatsReportObject->StatsReportAdd(
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Add} }
    );
    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $StatsReportID,
            "$Test->{Name} - StatsReportAdd()",
        );
        next TEST;
    }
    else {
        $Self->True(
            $StatsReportID,
            "$Test->{Name} - StatsReportAdd()",
        );
    }

    # remember id to delete it later
    push @StatsReportIDs, $StatsReportID;

    # Remember reports which valid or invalid.
    if ( $Test->{Add}->{ValidID} eq '1' ) {
        $CheckStatsReportIDs{$StatsReportID} = 1;
    }
    else {
        $CheckStatsReportIDs{$StatsReportID} = 0;
    }

    # get config
    my $StatsReport = $StatsReportObject->StatsReportGet(
        ID => $StatsReportID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $StatsReport->{Name},
        "$Test->{Name} - StatsReportGet()",
    );
    $Self->IsDeeply(
        $StatsReport->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - StatsReportGet() - Config",
    );

    my $StatsReportByName = $StatsReportObject->StatsReportGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$StatsReportByName,
        \$StatsReport,
        "$Test->{Name} - StatsReportGet() with Name parameter result",
    );

    # get config from cache
    my $StatsReportFromCache = $StatsReportObject->StatsReportGet(
        ID => $StatsReportID,
    );

    # verify config from cache
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $StatsReportFromCache->{Name},
        "$Test->{Name} - StatsReportGet() from cache",
    );
    $Self->IsDeeply(
        $StatsReportFromCache->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - StatsReportGet() from cache- Config",
    );

    $Self->IsDeeply(
        $StatsReport,
        $StatsReportFromCache,
        "$Test->{Name} - StatsReportGet() - Cache and DB",
    );

    my $StatsReportByNameFromCache = $StatsReportObject->StatsReportGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$StatsReportByNameFromCache,
        \$StatsReportFromCache,
        "$Test->{Name} - StatsReportGet() with Name parameter result from cache",
    );

    # update config with a modification
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }
    my $Success = $StatsReportObject->StatsReportUpdate(
        ID   => $StatsReportID,
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Update} }
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $Success,
            "$Test->{Name} - StatsReportUpdate() False",
        );
        next TEST;
    }
    else {
        $Self->True(
            $Success,
            "$Test->{Name} - StatsReportUpdate() True",
        );
    }

    # get config
    $StatsReport = $StatsReportObject->StatsReportGet(
        ID     => $StatsReportID,
        UserID => 1,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $StatsReport->{Name},
        "$Test->{Name} - StatsReportGet()",
    );
    $Self->IsDeeply(
        $StatsReport->{Config},
        $Test->{Update}->{Config},
        "$Test->{Name} - StatsReportGet() - Config",
    );

    $StatsReportByName = $StatsReportObject->StatsReportGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$StatsReportByName,
        \$StatsReport,
        "$Test->{Name} - StatsReportGet() with Name parameter result",
    );

    # verify if cache was also updated
    if ( $Test->{SuccessUpdate} ) {
        my $StatsReportUpdateFromCache = $StatsReportObject->StatsReportGet(
            ID     => $StatsReportID,
            UserID => 1,
        );

        # verify config from cache
        $Self->Is(
            $Test->{Name} . ' ' . $RandomID,
            $StatsReportUpdateFromCache->{Name},
            "$Test->{Name} - StatsReportGet() from cache",
        );
        $Self->IsDeeply(
            $StatsReportUpdateFromCache->{Config},
            $Test->{Update}->{Config},
            "$Test->{Name} - StatsReportGet() from cache- Config",
        );
    }
}

# list check from DB
my $StatsReportList = $StatsReportObject->StatsReportList( Valid => 0 );
for my $StatsReportID (@StatsReportIDs) {
    $Self->True(
        scalar $StatsReportList->{$StatsReportID},
        "StatsReportList() from DB found StatsReport $StatsReportID",
    );

}

# list check from cache
$StatsReportList = $StatsReportObject->StatsReportList( Valid => 0 );
for my $StatsReportID (@StatsReportIDs) {
    $Self->True(
        scalar $StatsReportList->{$StatsReportID},
        "StatsReportList() from Cache found StatsReport $StatsReportID",
    );
}

# Valid list check from DB.
my $ValidStatsReportList = $StatsReportObject->StatsReportList();
for my $StatsReportID ( sort keys %CheckStatsReportIDs ) {
    if ( $CheckStatsReportIDs{$StatsReportID} ) {
        $Self->True(
            $ValidStatsReportList->{$StatsReportID},
            "Valid StatsReportList() from DB found StatsReport $StatsReportID"
        );
    }
    else {
        $Self->False(
            $ValidStatsReportList->{$StatsReportID},
            "Invalid StatsReportList() from DB found StatsReport $StatsReportID"
        );
    }
}

# Valid list check from cache.
$ValidStatsReportList = $StatsReportObject->StatsReportList();
for my $StatsReportID ( sort keys %CheckStatsReportIDs ) {
    if ( $CheckStatsReportIDs{$StatsReportID} ) {
        $Self->True(
            $ValidStatsReportList->{$StatsReportID},
            "Valid StatsReportList() from cache found StatsReport $StatsReportID"
        );
    }
    else {
        $Self->False(
            $ValidStatsReportList->{$StatsReportID},
            "Invalid StatsReportList() from cache found StatsReport $StatsReportID"
        );
    }
}

# delete stats reports
for my $StatsReportID (@StatsReportIDs) {
    my $Success = $StatsReportObject->StatsReportDelete(
        ID     => $StatsReportID,
        UserID => 1,
    );
    $Self->True(
        $Success,
        "StatsReportDelete() deleted StatsReport $StatsReportID",
    );
    $Success = $StatsReportObject->StatsReportDelete(
        ID     => $StatsReportID,
        UserID => 1,
    );
    $Self->False(
        $Success,
        "StatsReportDelete() deleted StatsReport $StatsReportID",
    );
}

# list check from DB
$StatsReportList = $StatsReportObject->StatsReportList( Valid => 0 );
for my $StatsReportID (@StatsReportIDs) {
    $Self->False(
        scalar $StatsReportList->{$StatsReportID},
        "StatsReportList() did not find stats report $StatsReportID",
    );
}

# list check from cache
$StatsReportList = $StatsReportObject->StatsReportList( Valid => 0 );
for my $StatsReportID (@StatsReportIDs) {
    $Self->False(
        scalar $StatsReportList->{$StatsReportID},
        "StatsReportList() from cache did not find stats report $StatsReportID",
    );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
