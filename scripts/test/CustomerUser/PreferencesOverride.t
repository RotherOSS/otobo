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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $RandomID = $Helper->GetRandomID();

my $UserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $RandomID . '-Customer-Id',
    UserLogin      => $RandomID,
    UserEmail      => $RandomID . '-Email@example.com',
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);

my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $UserID,
);

KEY:
for my $Key ( sort keys %CustomerData ) {

    # Skip some data that comes from default values.
    next KEY if $Key =~ m/Config$/smx;
    next KEY if $Key =~ m/RefreshTime$/smx;
    next KEY if $Key =~ m/ShowTickets$/smx;
    next KEY if $Key eq 'Source';
    next KEY if $Key eq 'CustomerCompanyValidID';
    next KEY if $Key eq 'UserLanguage';

    $Self->False(
        $CustomerUserObject->SetPreferences(
            Key    => $Key,
            Value  => '1',
            UserID => $UserID,
        ),
        "Preference for $Key not updated"
    );

    my %NewCustomerData = $CustomerUserObject->CustomerUserDataGet(
        User => $UserID,
    );
    $Self->Is(
        $NewCustomerData{$Key},
        $CustomerData{$Key},
        "Customer data $Key unchanged"
    );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
