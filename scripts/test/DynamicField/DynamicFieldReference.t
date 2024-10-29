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

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create random test variable.
my $RandomID = $Helper->GetRandomID;

# Disable email checks to create new user.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Create agents.
my $AgentObject = $Kernel::OM->Get('Kernel::System::User');
my @AgentIDs;
my @AgentLogins;
for my $Prefix (qw(ɑ β)) {
    my $AgentFirstName = $Prefix . 'First' . $RandomID;
    my $AgentLastName  = $Prefix . 'Last' . $RandomID;
    my $AgentLogin     = 'agent' . $Prefix . $RandomID;
    my $AgentID        = $AgentObject->UserAdd(
        UserFirstname => $AgentFirstName,
        UserLastname  => $AgentLastName,
        UserLogin     => $AgentLogin,
        UserEmail     => "agent$Prefix$RandomID" . '@example.test',
        ValidID       => 1,
        ChangeUserID  => 1,
    );
    ok( $AgentID, "$AgentLogin is created" );
    push @AgentIDs,    $AgentID;
    push @AgentLogins, $AgentLogin;
}

# Create customer companies.
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my @CustomerCompanyIDs;
my @CustomerCompanyNames;
for my $Prefix (qw(Companyɑ Companyβ)) {
    my $CustomerCompanyName = "$Prefix$RandomID";
    my $CustomerCompanyID   = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID          => $CustomerCompanyName,
        CustomerCompanyName => $CustomerCompanyName,
        ValidID             => 1,
        UserID              => 1,
    );
    ok( $CustomerCompanyID, "$CustomerCompanyName is created" );
    push @CustomerCompanyIDs,   $CustomerCompanyID;
    push @CustomerCompanyNames, $CustomerCompanyName;
}

# Create two customer users for each of the test customer companies.
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my @CustomerUsers;
for my $CustomerCompanyName (@CustomerCompanyNames) {
    for my $Prefix (qw(A B)) {
        my $CustomerUserName  = join '_', $CustomerCompanyName, $Prefix;
        my $CustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => 'Tester',
            UserLastname   => $CustomerUserName,
            UserCustomerID => $CustomerCompanyName,
            UserLogin      => $CustomerUserName,
            UserEmail      => $CustomerUserName . '@example.com',
            ValidID        => 1,
            UserID         => 1,
        );
        ok( $CustomerUserLogin, "$CustomerUserName is created" );
        push @CustomerUsers, $CustomerUserLogin;
    }
}

# Create test ticket.
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $TicketID     = $TicketObject->TicketCreate(
    Title        => 'UnitTest' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $CustomerCompanyIDs[0],
    CustomerUser => $CustomerUsers[0],
    OwnerID      => 1,
    UserID       => 1,
);
ok( $TicketID, "TicketID $TicketID is created" );

my @Tests = (
    {
        Name   => 'Create Reference to Agent',
        Config => {
            ReferencedObjectType => 'Agent',
            FieldType            => 'Agent',
        },
    },
    {
        Name   => 'Create Reference to CustomerCompany',
        Config => {
            ReferencedObjectType => 'CustomerCompany',
            FieldType            => 'CustomerCompany',
        },
    },
    {
        Name   => 'Create Reference to CustomerUser',
        Config => {
            ReferencedObjectType => 'CustomerUser',
            FieldType            => 'CustomerUser',
        },
    },
    {
        Name   => 'Create Reference to Ticket',
        Config => {
            ReferencedObjectType => 'Ticket',
            FieldType            => 'Ticket',
        },
    },
);

my $Count = 0;
my @DynamicFieldIDs;
for my $Test (@Tests) {
    subtest $Test->{Name} => sub {
        $Count++;

        # Create a ticket dynamic field
        my $DynamicFieldName   = 'DFReference' . $Count . $RandomID;
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldID     = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => $DynamicFieldName,
            FieldOrder => 9991,
            FieldType  => $Test->{Config}{FieldType},
            ObjectType => 'Ticket',
            Config     => {
                Tooltip    => "Tooltip for $DynamicFieldName",
                MultiValue => 1,
                $Test->{Config}->%*,
            },
            ValidID => 1,
            UserID  => 1,
            Reorder => 0,
        );
        ok( $DynamicFieldID, "DFDatabase ID $DynamicFieldName is created" );
        push @DynamicFieldIDs, $DynamicFieldID;

        # Get the test dynamic field value.
        my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicFieldName,
        );
    };
}

done_testing;
