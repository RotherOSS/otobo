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
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# add two users
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my @Tests = (
    {
        Name                    => 'Regular User',
        CustomerUserLogin       => "johndoe$RandomID",
        CustomerID              => "johndoe$RandomID",
        CustomerEmail           => "johndoe$RandomID\@email.com",
        CustomerUserLoginUpdate => "johndoe2$RandomID",
        CustomerIDUpdate        => "johndoe2$RandomID",
    },
    {
        Name                    => 'Update to special characters',
        CustomerUserLogin       => "max$RandomID",
        CustomerID              => "max$RandomID",
        CustomerEmail           => "max$RandomID\@email.com",
        CustomerUserLoginUpdate => "max + & # () * $RandomID",
        CustomerIDUpdate        => "max + & # () * $RandomID",
    },
    {
        Name                    => 'Update from special characters',
        CustomerUserLogin       => "moritz + & # () * $RandomID",
        CustomerID              => "moritz + & # () * $RandomID",
        CustomerEmail           => "moritz$RandomID\@email.com",
        CustomerUserLoginUpdate => "moritz$RandomID",
        CustomerIDUpdate        => "moritz$RandomID",
    },
);

for my $Test (@Tests) {

    my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Firstname Test',
        UserLastname   => 'Lastname Test',
        UserCustomerID => $Test->{CustomerID},
        UserLogin      => $Test->{CustomerUserLogin},
        UserEmail      => $Test->{CustomerEmail},
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );

    $Self->True(
        $CustomerUserID,
        "$Test->{Name} - customer created",
    );

    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => $Test->{CustomerID},
        CustomerUser => $Test->{CustomerUserLogin},
        OwnerID      => 1,
        UserID       => 1,
    );

    $Self->True(
        $TicketID,
        "$Test->{Name} - ticket created",
    );

    my $Update = $CustomerUserObject->CustomerUserUpdate(
        Source         => 'CustomerUser',
        ID             => $Test->{CustomerUserLogin},
        UserFirstname  => 'Firstname Test',
        UserLastname   => 'Lastname Test',
        UserCustomerID => $Test->{CustomerIDUpdate},
        UserLogin      => $Test->{CustomerUserLoginUpdate},
        UserEmail      => $Test->{CustomerEmail},
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );

    $Self->True(
        $Update,
        "$Test->{Name} - customer updated",
    );

    $Self->Is(
        $TicketObject->TicketSearch(
            Result        => 'COUNT',
            CustomerIDRaw => $Test->{CustomerIDUpdate},
            UserID        => 1,
            OrderBy       => ['Up'],
            SortBy        => ['TicketNumber'],
        ),
        1,
        "$Test->{Name} - ticket was updated with new CustomerID $Test->{CustomerIDUpdate}"
    );

    $Self->Is(
        $TicketObject->TicketSearch(
            Result               => 'COUNT',
            CustomerUserLoginRaw => $Test->{CustomerUserLoginUpdate},
            UserID               => 1,
            OrderBy              => ['Up'],
            SortBy               => ['TicketNumber'],
        ),
        1,
        "$Test->{Name} - ticket was updated with new CustomerID $Test->{CustomerUserLoginUpdate}"
    );

}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
