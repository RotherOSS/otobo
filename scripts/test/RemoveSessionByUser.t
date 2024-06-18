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

my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create test users and a session for every one.
my @TestUserLogins;
for my $Count ( 1 .. 3 ) {
    my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate();
    push @TestUserLogins, $TestUserLogin;

    my %UserData = $UserObject->GetUserData(
        UserID        => $TestUserID,
        NoOutOfOffice => 1,
    );

    my $NewSessionID = $SessionObject->CreateSessionID(
        %UserData,
        UserLastRequest => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
        UserType        => 'User',
        SessionSource   => 'AgentInterface',
    );
    $Self->True(
        $NewSessionID,
        "SessionID '$NewSessionID' is created for user '$TestUserLogin'",
    );
}

# Check if all sessions exist.
my @SessionIDs = $SessionObject->GetAllSessionIDs();
my %SessionDataLoginBefore;

for my $SessionID (@SessionIDs) {
    my %SessionData = $SessionObject->GetSessionIDData(
        SessionID => $SessionID,
    );
    $SessionDataLoginBefore{ $SessionData{UserLogin} } = 1;
}

for my $TestUserLogin (@TestUserLogins) {
    $Self->True(
        $SessionDataLoginBefore{$TestUserLogin},
        "User '$TestUserLogin' is found",
    );
}

my $TestUserLoginRemoveSession = $TestUserLogins[0];

# Remove session from one test user.
my $Success = $SessionObject->RemoveSessionByUser(
    UserLogin => $TestUserLoginRemoveSession,
);
$Self->True(
    $Success,
    "Session from user '$TestUserLoginRemoveSession' is deleted",
);

# Check if only appropriate session is removed.
@SessionIDs = $SessionObject->GetAllSessionIDs();
my %SessionDataLoginAfter;

for my $SessionID (@SessionIDs) {
    my %SessionData = $SessionObject->GetSessionIDData(
        SessionID => $SessionID,
    );
    $SessionDataLoginAfter{ $SessionData{UserLogin} } = 1;
}

for my $TestUserLogin (@TestUserLogins) {
    if ( $TestUserLogin eq $TestUserLoginRemoveSession ) {
        $Self->False(
            $SessionDataLoginAfter{$TestUserLogin},
            "User '$TestUserLogin' is not found",
        );
    }
    else {
        $Self->True(
            $SessionDataLoginAfter{$TestUserLogin},
            "User '$TestUserLogin' is found",
        );
    }
}

# Restore to the previous state is done by RestoreDatabase.

$Self->DoneTesting();
