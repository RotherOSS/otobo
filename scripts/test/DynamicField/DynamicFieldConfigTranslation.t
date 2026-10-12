# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get helper object, put database changes into a transaction
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

my $RandomID = $Helper->GetRandomID;

# create the objects the reference fields refer to
my $QueueName = 'Queue' . $RandomID;
my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Queue for the translation of dynamic field configs',
    UserID          => 1,
);
ok( $QueueID, 'queue created' );

my $TypeName = 'Type' . $RandomID;
my $TypeID   = $Kernel::OM->Get('Kernel::System::Type')->TypeAdd(
    Name    => $TypeName,
    ValidID => 1,
    UserID  => 1,
);
ok( $TypeID, 'ticket type created' );

my $GroupName = 'Group' . $RandomID;
my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
    Name    => $GroupName,
    ValidID => 1,
    UserID  => 1,
);
ok( $GroupID, 'group created' );

my $ServiceName = 'Service' . $RandomID;
my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
    Name    => $ServiceName,
    ValidID => 1,
    UserID  => 1,

    # needed when ITSMCore is installed
    TypeID      => 1,
    Criticality => '3 normal',
);
ok( $ServiceID, 'service created' );

# the export translates IDs to names, the import translates the names back to IDs
my @Tests = (
    {
        Name      => 'ticket field: queues and ticket types',
        FieldType => 'Ticket',
        IDs       => {
            Queue      => [$QueueID],
            TicketType => [$TypeID],
        },
        Names => {
            Queue      => [$QueueName],
            TicketType => [$TypeName],
        },
    },
    {
        Name      => 'agent field: groups',
        FieldType => 'Agent',
        IDs       => {
            Group => [$GroupID],
        },
        Names => {
            Group => [$GroupName],
        },
    },
    {
        Name      => 'service field: allowed services',
        FieldType => 'Service',
        IDs       => {
            AllowedServiceIDs => [$ServiceID],
        },
        Names => {
            AllowedServiceIDs => [$ServiceName],
        },
    },
);

for my $Test (@Tests) {
    subtest $Test->{Name} => sub {
        my $ExportedConfig = $DynamicFieldObject->DynamicFieldConfigID2Name(
            DynamicFieldConfig => {
                Name      => 'Field' . $RandomID,
                FieldType => $Test->{FieldType},
                Config    => { $Test->{IDs}->%* },
            },
        );
        is( $ExportedConfig->{Config}, $Test->{Names}, 'export: IDs are translated to names' );

        my $ImportedConfig = $DynamicFieldObject->DynamicFieldConfigName2ID(
            DynamicFieldConfig => {
                Name      => 'Field' . $RandomID,
                FieldType => $Test->{FieldType},
                Config    => { $Test->{Names}->%* },
            },
        );
        is( $ImportedConfig->{Config}, $Test->{IDs}, 'import: names are translated to IDs' );
    };
}

subtest 'export of an ID that does not exist' => sub {
    my $UnknownServiceID = 999_999_999;

    my $ExportedConfig = $DynamicFieldObject->DynamicFieldConfigID2Name(
        DynamicFieldConfig => {
            Name      => 'Field' . $RandomID,
            FieldType => 'Service',
            Config    => {
                AllowedServiceIDs => [ $ServiceID, $UnknownServiceID ],
            },
        },
    );
    is(
        $ExportedConfig->{Config}{AllowedServiceIDs},
        [ $ServiceName, $UnknownServiceID ],
        'the unknown ID is kept',
    );
};

subtest 'empty values are kept' => sub {
    for my $Translation (qw(DynamicFieldConfigID2Name DynamicFieldConfigName2ID)) {
        my $TranslatedConfig = $DynamicFieldObject->$Translation(
            DynamicFieldConfig => {
                Name      => 'Field' . $RandomID,
                FieldType => 'Ticket',
                Config    => {
                    Queue => [ undef, '' ],
                },
            },
        );
        is( $TranslatedConfig->{Config}{Queue}, [ undef, '' ], "$Translation keeps empty values" );
    }
};

subtest 'import of a name that does not exist' => sub {
    my $ImportedConfig = $DynamicFieldObject->DynamicFieldConfigName2ID(
        DynamicFieldConfig => {
            Name      => 'Field' . $RandomID,
            FieldType => 'Ticket',
            Config    => {
                Queue => [ $QueueName, 'UnknownQueue' . $RandomID ],
            },
        },
    );
    ok( !$ImportedConfig, 'the translation fails' );

    # the import creates the field with a known queue only
    my %FieldConfig = (
        Label      => 'Ticket field',
        FieldType  => 'Ticket',
        ObjectType => 'Ticket',
    );
    my $Result = $ZnunyHelperObject->_DynamicFieldsCreate(
        {
            %FieldConfig,
            Name   => 'KnownQueue' . $RandomID,
            Config => {
                Queue => [$QueueName],
            },
        },
        {
            %FieldConfig,
            Name   => 'UnknownQueue' . $RandomID,
            Config => {
                Queue => [ $QueueName, 'UnknownQueue' . $RandomID ],
            },
        },
    );
    ok( !$Result->{Success}, 'the import reports a failure' );

    my $FieldWithKnownQueue = $DynamicFieldObject->DynamicFieldGet(
        Name => 'KnownQueue' . $RandomID,
    );
    is( $FieldWithKnownQueue->{Config}{Queue}, [$QueueID], 'the field with a known queue is created' );

    my $FieldWithUnknownQueue = $DynamicFieldObject->DynamicFieldGet(
        Name => 'UnknownQueue' . $RandomID,
    );
    ok( !$FieldWithUnknownQueue->{ID}, 'the field with an unknown queue is not created' );
};

done_testing;
