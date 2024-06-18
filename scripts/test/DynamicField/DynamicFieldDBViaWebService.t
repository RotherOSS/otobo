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

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;                                   # Set up $Kernel::OM
use Kernel::GenericInterface::Debugger                          ();
use Kernel::GenericInterface::Operation::Session::SessionCreate ();         ## no perlimports, new() from string
use Kernel::GenericInterface::Operation::Ticket::TicketUpdate   ();         ## no perlimports, new() from string
use Kernel::GenericInterface::Requester                         ();
use Kernel::System::VariableCheck                               qw(:all);

# Skip SSL certificate verification.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# Disable email checks to create new user.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Get config database params.
my $Database       = $ConfigObject->Get('Database');
my $DatabaseHost   = $ConfigObject->Get('DatabaseHost');
my $DatabaseUser   = $ConfigObject->Get('DatabaseUser');
my $DatabaseUserPw = $ConfigObject->Get('DatabasePw');
my $DatabaseDSN    = $ConfigObject->Get('DatabaseDSN');

# Get database type.
my $DatabaseType;
if ( $DatabaseDSN =~ /:mysql/i ) {
    $DatabaseType = 'mysql';
}
elsif ( $DatabaseDSN =~ /:pg/i ) {
    $DatabaseType = 'postgresql';
}
elsif ( $DatabaseDSN =~ /:oracle/i ) {
    $DatabaseType = 'oracle';
}
elsif ( $DatabaseDSN =~ /:db2/i ) {
    $DatabaseType = 'db2';
}
elsif ( $DatabaseDSN =~ /(mssql|sybase|sql server)/i ) {
    $DatabaseType = 'mssql';
}

# Add database dynamic field and its possible values.
my $RandomID          = $Helper->GetRandomID();
my $DynamicFieldName  = 'Database' . $RandomID;
my $DynamicFieldLabel = 'Master Agent';
my $DynamicFieldID    = $DynamicFieldObject->DynamicFieldAdd(
    Config => {
        CacheTTL       => 0,
        CaseSensitive  => undef,
        DBName         => $Database,
        DBTable        => 'users',
        DBType         => $DatabaseType,
        Driver         => '',
        Identifier     => 1,
        Multiselect    => 'checked',
        Password       => $DatabaseUserPw,
        Port           => '',
        PossibleValues => {
            FieldDatatype_1 => 'TEXT',
            FieldFilter_1   => '',
            FieldLabel_1    => 'Master Agent',
            FieldName_1     => 'login',
            Listfield_1     => 'on',
            Searchfield_1   => 'on',
            ValueCounter    => 1
        },
        ResultLimit  => '',
        SID          => '',
        Searchprefix => '',
        Searchsuffix => '',
        Server       => $DatabaseHost,
        User         => $DatabaseUser
    },
    Name          => $DynamicFieldName,
    Label         => $DynamicFieldLabel,
    FieldOrder    => 9991,
    InternalField => 0,
    FieldType     => 'Database',
    ObjectType    => 'Ticket',
    ValidID       => 1,
    UserID        => 1,
);
ok( $DynamicFieldID, "DynamicFieldID $DynamicFieldID is created" );

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $DynamicFieldName,
);

# Add test users.
my @Users;
for ( 1 .. 3 ) {
    my $UserLogin = $Helper->TestUserCreate();
    my $UserID    = $UserObject->UserLookup(
        UserLogin => $UserLogin,
    );
    push @Users, {
        UserID    => $UserID,
        UserLogin => $UserLogin,
    };
}

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $Users[0]->{UserID},
    UserID       => $Users[0]->{UserID},
);
ok( $TicketID, "TicketID $TicketID is created" );

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

my $WebserviceName   = 'Webservice' . $Helper->GetRandomID();
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebserviceName,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);
ok( $WebserviceID, "WebserviceID $WebserviceID is created" );

# Get remote host with some precautions for certain unit test systems.
my $Host = $Helper->GetTestHTTPHostname();

# Prepare web-service config.
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . 'nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my $WebserviceConfig = {
    Description =>
        'Test for Ticket Connector using SOAP transport backend.',
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'http://otobo.org/SoapTestInterface/',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            TicketUpdate => {
                Type => 'Ticket::TicketUpdate',
            },
            SessionCreate => {
                Type => 'Session::SessionCreate',
            },
        },
    },
    Requester => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                NameSpace => 'http://otobo.org/SoapTestInterface/',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
            },
        },
        Invoker => {
            TicketUpdate => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# Update web-service with real config
# the update is needed because we are using
# the WebserviceID for the Endpoint in config.
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $Users[0]->{UserID},
);
ok( $WebserviceUpdate, "Updated Webservice $WebserviceID - $WebserviceName" );

my @Tests = (
    {
        Name        => 'Set Database DynamicField value to incorrect user',
        RequestData => {
            TicketID     => $TicketID,
            DynamicField => {
                Name  => $DynamicFieldName,
                Value => "test123",
            },
        },
        ExpectedResult  => undef,
        RequesterResult => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketUpdate.InvalidParameter',
                    ErrorMessage => 'TicketUpdate: DynamicField->Value parameter is invalid!'
                }
            },
            Success => 1,
        },
        Operation => 'TicketUpdate',
    },
    {
        Name        => 'Set Database DynamicField value to multiple users, one is incorrect',
        RequestData => {
            TicketID     => $TicketID,
            DynamicField => [
                {
                    Name  => $DynamicFieldName,
                    Value => [ $Users[0]->{UserLogin}, 'test123' ],
                },
            ],
        },
        ExpectedResult  => undef,
        RequesterResult => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketUpdate.InvalidParameter',
                    ErrorMessage => 'TicketUpdate: DynamicField->Value parameter is invalid!'
                }
            },
            Success => 1,
        },
        Operation => 'TicketUpdate',
    },
    {
        Name        => 'Set Database DynamicField value to one user',
        RequestData => {
            TicketID     => $TicketID,
            DynamicField => {
                Name  => $DynamicFieldName,
                Value => "$Users[0]->{UserLogin}",
            },
        },
        ExpectedResult  => [ $Users[0]->{UserLogin} ],
        RequesterResult => {
            Data => {
                TicketID     => $TicketID,
                TicketNumber => $Ticket{TicketNumber}
            },
            Success => 1,
        },
        Operation => 'TicketUpdate',
    },
    {
        Name        => 'Set Database DynamicField value to multiple users',
        RequestData => {
            TicketID     => $TicketID,
            DynamicField => [
                {
                    Name  => $DynamicFieldName,
                    Value => [ $Users[0]->{UserLogin}, $Users[1]->{UserLogin} ],
                },
            ],
        },
        ExpectedResult  => [ $Users[0]->{UserLogin}, $Users[1]->{UserLogin} ],
        RequesterResult => {
            Data => {
                TicketID     => $TicketID,
                TicketNumber => $Ticket{TicketNumber}
            },
            Success => 1,
        },
        Operation => 'TicketUpdate',
    },
);

# Debugger object instantiation.
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
isa_ok(
    $DebuggerObject,
    ['Kernel::GenericInterface::Debugger'],
    'DebuggerObject instantiate correctly',
);

for my $Test (@Tests) {
    subtest $Test->{Name} => sub {

        # Start requester with local invocation
        {
            my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
                DebuggerObject => $DebuggerObject,
                WebserviceID   => $WebserviceID,
                ConfigObject   => $ConfigObject,
            );
            my $LocalResult = $LocalObject->Run(
                WebserviceID => $WebserviceID,
                Invoker      => $Test->{Operation},
                Data         => {
                    UserLogin => $Users[0]->{UserLogin},
                    Password  => $Users[0]->{UserLogin},
                    %{ $Test->{RequestData} },
                },
            );

            # looks like local invocation has a redundant attribute,
            # temporarily remove it for the comparison
            delete local $LocalResult->{ErrorMessage};

            is(
                $LocalResult,
                $Test->{RequesterResult},
                "local result is correct.",
            );
        }

        # Start requester with our web-service.
        {
            my $RequesterObject = Kernel::GenericInterface::Requester->new(
                ConfigObject => $ConfigObject,
            );
            my $RequesterResult = $RequesterObject->Run(
                WebserviceID => $WebserviceID,
                Invoker      => $Test->{Operation},
                Data         => {
                    UserLogin => $Users[0]->{UserLogin},
                    Password  => $Users[0]->{UserLogin},
                    %{ $Test->{RequestData} },
                },
            );

            is(
                $RequesterResult,
                $Test->{RequesterResult},
                "result from web-service is correct.",
            );
        }

        # verify that the value has changed
        my $Value = $BackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $TicketID,
        );
        is(
            $Value,
            $Test->{ExpectedResult},
            "ValueGet() had the expected result.",
        );
    };
}

# Cleanup.
my $WebServiceDeleteSuccess = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $Users[0]->{UserID},
);
ok( $WebServiceDeleteSuccess, "WebServiceID $WebserviceID is deleted." );

my $TicketDeleteSuccess = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => $Users[0]->{UserID},
);
ok( $TicketDeleteSuccess, "TicketID $TicketID is deleted." );

my $DynamicFieldDeleteSuccess = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $DynamicFieldID,
    UserID => $Users[0]->{UserID},
);
ok( $DynamicFieldDeleteSuccess, "DynamicFieldID $DynamicFieldID is deleted." );

done_testing;
