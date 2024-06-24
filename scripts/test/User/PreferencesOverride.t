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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserRandom = 'unittest-' . $Helper->GetRandomID();
my $UserID     = $UserObject->UserAdd(
    UserFirstname => 'John',
    UserLastname  => 'Doe',
    UserLogin     => $UserRandom,
    UserEmail     => $UserRandom . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

my %UserData = $UserObject->GetUserData(
    UserID => $UserID,
);

KEY:
for my $Key ( sort keys %UserData ) {

    # Skip some data that comes from default values.
    next KEY if $Key =~ m/PageShown$/smx;
    next KEY if $Key =~ m/NextMask$/smx;
    next KEY if $Key =~ m/RefreshTime$/smx;
    next KEY if $Key =~ m/MarkTicketSeenRedirectURL$/smx;
    next KEY if $Key =~ m/MarkTicketUnseenRedirectURL$/smx;

    # These are actually user preferences.
    next KEY if $Key =~ m/UserEmail$/smx;
    next KEY if $Key =~ m/UserMobile$/smx;

    $Self->False(
        $UserObject->SetPreferences(
            Key    => $Key,
            Value  => '1',
            UserID => $UserID,
        ),
        "Preference for $Key not updated"
    );

    my %NewUserData = $UserObject->GetUserData(
        UserID => $UserID,
    );
    $Self->Is(
        $NewUserData{$Key},
        $UserData{$Key},
        "User data $Key unchanged"
    );
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
