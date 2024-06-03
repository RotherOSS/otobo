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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

use Kernel::System::VariableCheck qw(DataIsDifferent);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Define DB test parameters.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBType       = 'mysql';
my $DBName       = $ConfigObject->Get('Database');
my $DBUser       = $ConfigObject->Get('DatabaseUser');
my $DBPassword   = $ConfigObject->Get('DatabasePw');
my $DBServer     = $ConfigObject->Get('DatabaseHost');

# Check if DB is MySQL, finish test if it is not.
if ( $ConfigObject->Get('DatabaseDSN') !~ /^DBI:mysql/ ) {
    skip_all("Finishing prematurely test, need MySQL database");
}

# Create random test variable.
my $RandomID = $Helper->GetRandomID();

# Disable email checks to create new user.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Create customer companies.
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my @CustomerCompanyIDs;
my @CustomerCompanyNames;
for my $Count ( 1 .. 2 ) {
    my $CustomerCompanyName = 'CustomerCompany' . $Count . $RandomID;
    my $CustomerCompanyID   = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID          => $CustomerCompanyName,
        CustomerCompanyName => $CustomerCompanyName,
        ValidID             => 1,
        UserID              => 1,
    );
    $Self->True(
        $CustomerCompanyID,
        "$CustomerCompanyID is created"
    );
    push @CustomerCompanyIDs,   $CustomerCompanyID;
    push @CustomerCompanyNames, $CustomerCompanyName;
}

# Create two customer users for test customer companies.
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my @CustomerUsers;
my $Count;
for my $CustomerCompanyName (@CustomerCompanyNames) {
    for my $Index ( 1 .. 2 ) {
        $Count++;
        my $CustomerUserName  = 'CustomerUser' . $Count . $RandomID;
        my $CustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $CustomerUserName,
            UserLastname   => $CustomerUserName,
            UserCustomerID => $CustomerCompanyName,
            UserLogin      => $CustomerUserName,
            UserEmail      => $CustomerUserName . '@example.com',
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $CustomerUserLogin,
            "$CustomerUserLogin is created"
        );
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
$Self->True(
    $TicketID,
    "TicketID $TicketID is created"
);

# Create first test dynamic field database.
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my @Tests              = (

    # Test with filtering by CustomerCompany, returning CustomerCompany and CustomerUser.
    {
        Name           => 'Filter by CustomerCompany',
        PossibleValues => {
            Listfield_1     => 'on',
            FieldFilter_1   => 'CustomerID',
            Searchfield_2   => 'on',
            Searchfield_1   => 'on',
            FieldLabel_1    => 'Company',
            FieldName_1     => 'customer_id',
            FieldLabel_2    => 'Login',
            FieldName_2     => 'login',
            FieldDatatype_1 => 'TEXT',
            FieldDatatype_2 => 'TEXT',
            Listfield_2     => 'on',
            FieldFilter_2   => '',
            ValueCounter    => 2
        },
        TestScenario => [
            {
                DatabaseSearchByConfigName => 'Search param "**" - no TicketID',
                DatabaseSearchByConfig     => {
                    Search         => '**',
                    TicketID       => '',
                    CustomerID     => $CustomerCompanyNames[0],
                    CustomerUserID => $CustomerUsers[0],
                    Identifier     => '',
                    ResultLimit    => 0,
                },
                DatabaseSearchByConfigResult => [
                    [
                        {
                            Data  => $CustomerCompanyNames[0],
                            Label => 'Company'
                        },
                        {
                            Identifier => $CustomerUsers[0],
                            Data       => $CustomerUsers[0],
                            Datatype   => 'TEXT',
                            Label      => 'Login'
                        },
                        {
                            Data  => undef,
                            Label => undef
                        }
                    ],
                    [
                        {
                            Data  => $CustomerCompanyNames[0],
                            Label => 'Company'
                        },
                        {
                            Datatype   => 'TEXT',
                            Label      => 'Login',
                            Data       => $CustomerUsers[1],
                            Identifier => $CustomerUsers[1]
                        },
                        {
                            Data  => undef,
                            Label => undef
                        }
                    ]
                ],
                ExecuteDatabaseSearchByConfig  => 1,
                DatabaseSearchByAttributesName => 'Search param "**" - no TicketID',
                DatabaseSearchByAttributes     => {
                    TicketID => '',
                    Search   => {
                        '1' => '**'
                    },
                    ResultLimit => 0
                },
                DatabaseSearchByAttributesResult => {

                    # TODO: This is not yet fixed and it's returning more results then
                    # it should when there is no TicketID.
                },
                ExecuteDatabaseSearchByAttributes => 0,
            },
            {
                DatabaseSearchByConfigName => "Search param '$CustomerUsers[0]' - no TicketID",
                DatabaseSearchByConfig     => {
                    Search      => $CustomerUsers[0],
                    TicketID    => '',
                    Identifier  => '',
                    ResultLimit => 0,
                },
                ExecuteDatabaseSearchByConfig => 1,
                DatabaseSearchByConfigResult  => [
                    [
                        {
                            Data  => $CustomerCompanyNames[0],
                            Label => 'Company'
                        },
                        {
                            Identifier => $CustomerUsers[0],
                            Data       => $CustomerUsers[0],
                            Datatype   => 'TEXT',
                            Label      => 'Login'
                        },
                        {
                            Data  => undef,
                            Label => undef
                        }
                    ],
                ],
                DatabaseSearchByAttributesName => "Search param '$CustomerCompanyNames[0]' - no TicketID",
                DatabaseSearchByAttributes     => {
                    TicketID => '',
                    Search   => {
                        '1' => $CustomerCompanyNames[0]
                    },
                    ResultLimit => 0
                },
                DatabaseSearchByAttributesResult => {

                    # TODO: This is not yet fixed and it's returning more results then
                    # it should when there is no TicketID.
                },
                ExecuteDatabaseSearchByAttributes => 0,
            },
            {
                DatabaseSearchByConfigName => 'Search param "**" - with TicketID',
                DatabaseSearchByConfig     => {
                    Search      => '**',
                    TicketID    => $TicketID,
                    Identifier  => '',
                    ResultLimit => 0,
                },
                DatabaseSearchByConfigResult => [
                    [
                        {
                            Data  => $CustomerCompanyNames[0],
                            Label => 'Company'
                        },
                        {
                            Identifier => $CustomerUsers[0],
                            Data       => $CustomerUsers[0],
                            Datatype   => 'TEXT',
                            Label      => 'Login'
                        },
                        {
                            Data  => undef,
                            Label => undef
                        }
                    ],
                    [
                        {
                            Data  => $CustomerCompanyNames[0],
                            Label => 'Company'
                        },
                        {
                            Datatype   => 'TEXT',
                            Label      => 'Login',
                            Data       => $CustomerUsers[1],
                            Identifier => $CustomerUsers[1]
                        },
                        {
                            Data  => undef,
                            Label => undef
                        }
                    ]
                ],
                ExecuteDatabaseSearchByConfig  => 1,
                DatabaseSearchByAttributesName => 'Search param "**" - with TicketID',
                DatabaseSearchByAttributes     => {
                    TicketID => $TicketID,
                    Search   => {
                        '1' => '**'
                    },
                    ResultLimit => 0
                },
                DatabaseSearchByAttributesResult => {
                    Columns => [
                        'customer_id',
                        'login'
                    ],
                    Data => [
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[0]
                            ],
                            Identifier => $CustomerUsers[0]
                        },
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[1]
                            ],
                            Identifier => $CustomerUsers[1]
                        }
                    ],
                },
                ExecuteDatabaseSearchByAttributes => 1,
            },
            {
                DatabaseSearchByConfigName => "Search param '$CustomerUsers[0]' - with TicketID",
                DatabaseSearchByConfig     => {
                    Search      => $CustomerUsers[0],
                    TicketID    => $TicketID,
                    Identifier  => '',
                    ResultLimit => 0,
                },
                DatabaseSearchByConfigResult => [
                    [
                        {
                            Data  => $CustomerCompanyNames[0],
                            Label => 'Company'
                        },
                        {
                            Identifier => $CustomerUsers[0],
                            Data       => $CustomerUsers[0],
                            Datatype   => 'TEXT',
                            Label      => 'Login'
                        },
                        {
                            Data  => undef,
                            Label => undef
                        }
                    ],
                ],
                DatabaseSearchByAttributesName => "Search param '$CustomerCompanyNames[0]' - with TicketID",
                DatabaseSearchByAttributes     => {
                    TicketID => $TicketID,
                    Search   => {
                        '1' => $CustomerCompanyNames[0]
                    },
                    ResultLimit => 0
                },
                DatabaseSearchByAttributesResult => {
                    Columns => [
                        'customer_id',
                        'login'
                    ],
                    Data => [
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[0]
                            ],
                            Identifier => $CustomerUsers[0]
                        },
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[1]
                            ],
                            Identifier => $CustomerUsers[1]
                        }
                    ],
                },
                ExecuteDatabaseSearchByAttributes => 1,
            },
            {
                ExecuteDatabaseSearchByConfig  => 0,
                DatabaseSearchByAttributesName => "Search param '**' on Company Field - no TicketID, with CustomerID",
                DatabaseSearchByAttributes     => {
                    CustomerID => $CustomerCompanyNames[0],
                    Search     => {
                        '1' => '**'
                    },
                    ResultLimit => 0
                },
                DatabaseSearchByAttributesResult => {
                    Columns => [
                        'customer_id',
                        'login'
                    ],
                    Data => [
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[0]
                            ],
                            Identifier => $CustomerUsers[0]
                        },
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[1]
                            ],
                            Identifier => $CustomerUsers[1]
                        }
                    ],
                },
                ExecuteDatabaseSearchByAttributes => 1,
            },
            {
                ExecuteDatabaseSearchByConfig  => 0,
                DatabaseSearchByAttributesName => "Search param '**' on Login Field - no TicketID, with CustomerID",
                DatabaseSearchByAttributes     => {
                    CustomerID => $CustomerCompanyNames[0],
                    Search     => {
                        '2' => '**'
                    },
                    ResultLimit => 0
                },
                DatabaseSearchByAttributesResult => {
                    Columns => [
                        'customer_id',
                        'login'
                    ],
                    Data => [
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[0]
                            ],
                            Identifier => $CustomerUsers[0]
                        },
                        {
                            Data => [
                                $CustomerCompanyNames[0],
                                $CustomerUsers[1]
                            ],
                            Identifier => $CustomerUsers[1]
                        }
                    ],
                },
                ExecuteDatabaseSearchByAttributes => 1,
            },
        ],
    },
);

$Count = 0;
my @DynamicFieldIDs;
for my $Test (@Tests) {
    $Count++;

    # Create dynamic field
    my $DynamicFieldName = 'DFDatabase' . $Count . $RandomID;
    my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $DynamicFieldName,
        Label      => $DynamicFieldName,
        FieldOrder => 9991,
        FieldType  => 'Database',
        ObjectType => 'Ticket',
        Config     => {
            DBType         => $DBType,
            Link           => '',
            DBTable        => 'customer_user',
            Password       => $DBPassword,
            DBName         => $DBName,
            Searchprefix   => '',
            Server         => $DBServer,
            SID            => '',
            Port           => '',
            PossibleValues => $Test->{PossibleValues},
            Multiselect    => undef,
            Searchsuffix   => '',
            Identifier     => 2,
            CaseSensitive  => undef,
            Driver         => '',
            ResultLimit    => '',
            User           => $DBUser,
            CacheTTL       => 0,
        },
        ValidID => 1,
        UserID  => 1,
        Reorder => 0,
    );
    $Self->True(
        $DynamicFieldID,
        "DFDatabase ID $DynamicFieldID is created"
    );
    push @DynamicFieldIDs, $DynamicFieldID;

    # Get the test dynamic field value.
    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $DynamicFieldName,
    );

    # Create dynamic field database object.
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::DynamicFieldDB' => {
            DynamicFieldConfig => $DynamicFieldConfig,
        },
    );
    my $DynamicFieldDBObject = $Kernel::OM->Get('Kernel::System::DynamicFieldDB');

    for my $Scenario ( @{ $Test->{TestScenario} } ) {

        my $DataIsDifferent;

        # Execute 'DatabaseSearchByConfig' function and check return result.
        if ( $Scenario->{ExecuteDatabaseSearchByConfig} ) {
            my @DatabaseSearchByConfigResult = $DynamicFieldDBObject->DatabaseSearchByConfig(
                %{ $Scenario->{DatabaseSearchByConfig} },
                Config => $DynamicFieldConfig->{Config},
            );

            $DataIsDifferent = DataIsDifferent(
                Data1 => \@DatabaseSearchByConfigResult,
                Data2 => \@{ $Scenario->{DatabaseSearchByConfigResult} },
            );
            $Self->False(
                $DataIsDifferent,
                "DatabaseSearchByConfig() - $Scenario->{DatabaseSearchByConfigName} is correct"
            );
        }

        # Execute 'DatabaseSearchByAttributes' function and check return result.
        if ( $Scenario->{ExecuteDatabaseSearchByAttributes} ) {

            my %DatabaseSearchByAttributesResult = $DynamicFieldDBObject->DatabaseSearchByAttributes(
                Config => $DynamicFieldConfig->{Config},
                %{ $Scenario->{DatabaseSearchByAttributes} },
            );

            $DataIsDifferent = DataIsDifferent(
                Data1 => \%DatabaseSearchByAttributesResult,
                Data2 => \%{ $Scenario->{DatabaseSearchByAttributesResult} },
            );
            $Self->False(
                $DataIsDifferent,
                "DatabaseSearchByAttributes() - $Scenario->{DatabaseSearchByAttributesName} is correct"
            );
        }
    }
}

# Cleanup - it is not possible to use RestoreDatabase for this UnitTest.

# Delete created ticket.
my $Success = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketID $TicketID is deleted"
);

# Delete created customer users.
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
for my $CustomerUserLogin (@CustomerUsers) {
    $Success = $DBObject->Do(
        SQL  => "DELETE FROM customer_user WHERE login = ?",
        Bind => [ \$CustomerUserLogin ],
    );
    $Self->True(
        $Success,
        "$CustomerUserLogin is deleted",
    );
}

# Delete created customer company.
for my $CustomerCompanyName (@CustomerCompanyNames) {
    $Success = $DBObject->Do(
        SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
        Bind => [ \$CustomerCompanyName ],
    );
    $Self->True(
        $Success,
        "$CustomerCompanyName is deleted",
    );
}

# Delete created dynamic field.
for my $DynamicFieldID (@DynamicFieldIDs) {
    $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID      => $DynamicFieldID,
        UserID  => 1,
        Reorder => 0,
    );
    $Self->True(
        $Success,
        "DFDatabase ID $DynamicFieldID is deleted",
    );
}

$Self->DoneTesting();
