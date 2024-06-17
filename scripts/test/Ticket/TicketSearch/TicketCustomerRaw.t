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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my @CustomerLogins;

# add two customer users
for ( 1 .. 2 ) {
    my $UserRand = "CustomerUserLogin + " . $Helper->GetRandomID();

    my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Firstname Test',
        UserLastname   => 'Lastname Test',
        UserCustomerID => "CustomerID-$UserRand",
        UserLogin      => $UserRand,
        UserEmail      => $UserRand . '-Email@example.com',
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );
    push @CustomerLogins, $CustomerUserID;

    $Self->True(
        $CustomerUserID,
        "CustomerUserAdd() - $CustomerUserID",
    );
}

my @TicketIDs;
my %CustomerIDTickets;
for my $CustomerUserLogin (@CustomerLogins) {
    for ( 1 .. 3 ) {

        # create a new ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'My ticket created by Agent A',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerUser => $CustomerUserLogin,
            CustomerID   => "CustomerID-$CustomerUserLogin",
            OwnerID      => 1,
            UserID       => 1,
        );

        $Self->True(
            $TicketID,
            "Ticket created for test - $CustomerUserLogin - $TicketID",
        );
        push @TicketIDs, $TicketID;
        push @{ $CustomerIDTickets{$CustomerUserLogin} }, $TicketID;

    }
}

# test search by CustomerUserLoginRaw, when CustomerUserLogin have special chars or whitespaces

for my $CustomerUserLogin (@CustomerLogins) {

    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result               => 'ARRAY',
        CustomerUserLoginRaw => $CustomerUserLogin,
        UserID               => 1,
        OrderBy              => ['Up'],
        SortBy               => ['TicketNumber'],
    );

    $Self->IsDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerLoginRaw: \'$CustomerUserLogin\'",
    );

}

# test search by CustomerUserLogin, when CustomerUserLogin have special chars or whitespaces
# result is empty

for my $CustomerUserLogin (@CustomerLogins) {

    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result            => 'ARRAY',
        CustomerUserLogin => $CustomerUserLogin,
        UserID            => 1,
        OrderBy           => ['Up'],
        SortBy            => ['TicketNumber'],
    );

    $Self->IsNotDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerLoginRaw: \'$CustomerUserLogin\'",
    );

}

# test search by CustomerIDRaw, when CustomerID have special chars or whitespaces

for my $CustomerUserLogin (@CustomerLogins) {

    my %User              = $CustomerUserObject->CustomerUserDataGet( User => $CustomerUserLogin );
    my $CustomerIDRaw     = $User{UserCustomerID};
    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result        => 'ARRAY',
        CustomerIDRaw => $CustomerIDRaw,
        UserID        => 1,
        OrderBy       => ['Up'],
        SortBy        => ['TicketNumber'],
    );

    $Self->IsDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerIDRaw \'$CustomerIDRaw\'",
    );
}

# test search by CustomerID, when CustomerID have special chars or whitespaces
# result is empty

for my $CustomerUserLogin (@CustomerLogins) {

    my %User              = $CustomerUserObject->CustomerUserDataGet( User => $CustomerUserLogin );
    my $CustomerIDRaw     = $User{UserCustomerID};
    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result     => 'ARRAY',
        CustomerID => $CustomerIDRaw,
        UserID     => 1,
        OrderBy    => ['Up'],
        SortBy     => ['TicketNumber'],
    );

    $Self->IsNotDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerIDRaw \'$CustomerIDRaw\'",
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
