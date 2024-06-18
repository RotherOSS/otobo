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
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @DynamicFields = map { $Helper->GetRandomID() } 1 .. 2;
my @Config;

for my $DynamicField (@DynamicFields) {
    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $DynamicField,
        Label      => 'test',
        FieldOrder => 123,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Reorder    => 0,
        ValidID    => 1,
        UserID     => 1,
        Config     => { Test => 1 },
    );
    $Self->True( $ID, "Dynamic Field $DynamicField created" );

    push @Config, $DynamicFieldObject->DynamicFieldGet(
        ID => $ID,
    );
}

my $MainTicketID = $TicketObject->TicketCreate(
    Title        => 'Main Ticket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    CustomerNo   => '123456',
    CustomerUser => 'customer@example.com',
    UserID       => 1,
    State        => 'new',
    OwnerID      => 1,
);

$Self->True( $MainTicketID, 'Could create main ticket' );

my $Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $Config[0],
    ObjectID           => $MainTicketID,
    Value              => 'main 0',
    UserID             => 1,
);

$Self->True( $Success, 'Set dynamic field on main ticket' );

my $MergeTicketID = $TicketObject->TicketCreate(
    Title        => 'Merge Ticket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    CustomerNo   => '123456',
    CustomerUser => 'customer@example.com',
    UserID       => 1,
    State        => 'new',
    OwnerID      => 1,
);

$Self->True( $MergeTicketID, 'Could create merge ticket' );

$BackendObject->ValueSet(
    DynamicFieldConfig => $Config[0],
    ObjectID           => $MergeTicketID,
    Value              => 'merge 0',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Config[1],
    ObjectID           => $MergeTicketID,
    Value              => 'merge 1',
    UserID             => 1,
);

my %MergeTicket = $TicketObject->TicketGet(
    TicketID      => $MergeTicketID,
    UserID        => 1,
    DynamicFields => 1,
);

$TicketObject->TicketMergeDynamicFields(
    MainTicketID  => $MainTicketID,
    MergeTicketID => $MergeTicketID,
    UserID        => 1,
    DynamicFields => \@DynamicFields,
);

my %MainTicket = $TicketObject->TicketGet(
    TicketID      => $MainTicketID,
    UserID        => 1,
    DynamicFields => 1,
);

$Self->Is(
    $MainTicket{ 'DynamicField_' . $DynamicFields[0] },
    'main 0',
    'TicketMergeDynamicFields left existing DF in main ticket intact',
);

$Self->Is(
    $MainTicket{ 'DynamicField_' . $DynamicFields[1] },
    'merge 1',
    'TicketMergeDynamicFields copied DF from merge ticket',
);

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
