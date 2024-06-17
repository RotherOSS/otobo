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

use vars (qw($Self));

# get lock object
my $LockObject = $Kernel::OM->Get('Kernel::System::Lock');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Names = sort $LockObject->LockViewableLock(
    Type => 'Name',
);

$Self->IsDeeply(
    \@Names,
    [ 'tmp_lock', 'unlock' ],
    'LockViewableLock()',
);

my @Tests = (
    {
        Name   => 'Lookup - lock',
        Input  => 'lock',
        Result => 1,
    },
    {
        Name   => 'Lookup - tmp_lock',
        Input  => 'tmp_lock',
        Result => 1,
    },
    {
        Name   => 'Lookup - unlock',
        Input  => 'unlock',
        Result => 1,
    },
    {
        Name   => 'Lookup - unlock_not_extsits',
        Input  => 'unlock_not_exists',
        Result => 0,
    },
);

for my $Test (@Tests) {

    my $LockID = $LockObject->LockLookup( Lock => $Test->{Input} );

    if ( $Test->{Result} ) {

        $Self->True( $LockID, $Test->{Name} );

        my $Lock = $LockObject->LockLookup( LockID => $LockID );

        $Self->Is(
            $Test->{Input},
            $Lock,
            $Test->{Name},
        );
    }
    else {
        $Self->False( $LockID, $Test->{Name} );
    }
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
