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

# core modules

# CPAN modules
use Test2::V0;
use HTTP::Request::Common qw(GET);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# Get config object.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# UIse DoNotSendEmail email backend.
my $Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);
ok( $Success, "Set Send Mail Module to DoNotSendEmail" );

# Set default language to English.
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
ok( $Success, "Set default language to English" );

# Disable email checks to create new user.
$Success = $ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);
ok( $Success, "Disabled CheckMXRecord" );

$Success = $ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
ok( $Success, "Disabled CheckEmailAddress" );

# Enable lock after create event.
$Success = $ConfigObject->Set(
    Key   => 'Ticket::EventModulePost###3100-LockAfterCreate',
    Value => {
        Action      => 'AgentTicketPhone|AgentTicketEmail',
        Event       => 'TicketCreate',
        Module      => 'Kernel::System::Ticket::Event::LockAfterCreate',
        Transaction => 0,
    },
);
ok( $Success, "Enabled event LockAfterCreate" );

# Create a new user for current test.
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
);
my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $UserLogin,
);
my $UserID = $UserData{UserID};

# Create a new customer user for current test.
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();

my %TicketCreateTemplate = (
    Title        => 'Ticket Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => $CustomerUserLogin,
    OwnerID      => $UserID,
    UserID       => $UserID,
);

my @Tests = (
    {
        Name         => 'UserID 1',
        Request      => 'Action=AgentTicketPhone',
        TicketCreate => {
            UserID => 1,
        },
        Success => 0,
    },
    {
        Name         => 'Closed Ticket',
        Request      => 'Action=AgentTicketPhone',
        TicketCreate => {
            State => 'closed successful',
        },
        Success => 0,
    },
    {
        Name         => 'Wrong Action',
        Request      => 'Action=AgentTicketActionCommon',
        TicketCreate => {},
        Success      => 0,
    },
    {
        Name         => 'Missing Action',
        Request      => 'SubAction=StoreNew',
        TicketCreate => {},
        Success      => 0,
    },
    {
        Name         => 'Success Phone',
        Request      => 'Action=AgentTicketPhone',
        TicketCreate => {},
        Success      => 1,
    },
    {
        Name         => 'Success Email',
        Request      => 'Action=AgentTicketEmail',
        TicketCreate => {},
        Success      => 1,
    },
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

for my $Test (@Tests) {

    # Fake a web request, as Action is used by the LockAfterCreate event.
    my $QueryString = $Test->{Request} // '';
    my $HTTPRequest = GET( 'http://example.com/example?' . $QueryString );
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Web::Request' => { HTTPRequest => $HTTPRequest }
    );

    # Create an unlocked ticket,
    my $TicketID = $TicketObject->TicketCreate(
        %TicketCreateTemplate,
        %{ $Test->{TicketCreate} }
    );
    ok( $TicketID, "$Test->{Name} TicketCreate() successful for Ticket ID $TicketID" );

    # Check ticket lock.
    my $TicketLock = $TicketObject->TicketLockGet( TicketID => $TicketID );
    is(
        $TicketLock // 0,
        $Test->{Success},
        "$Test->{Name} TicketLockGet() for Ticket ID $TicketID",
    );
}
continue {

    # Discard web request object as we need a new one in the next iteration.
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Web::Request', ],
    );
}

# Cleanup is done by RestoreDatabase.

done_testing;
