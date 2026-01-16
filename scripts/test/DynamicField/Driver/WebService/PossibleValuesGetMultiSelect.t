# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::ObjectManager ();

$Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-otobo.UnitTest',
    },
);

# This test can not use RestoreDtabase as it sends a web request to itself.
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Do not check email addresses.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Use DoNotSendEmail email backend.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my $TestUser = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUser,
);

my $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');
my $SourceTicketID1 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => 'example.com',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => $TestUserID,
);
ok( $SourceTicketID1, "TicketCreate() Ticket 1 $SourceTicketID1" );

my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
my $WebserviceName   = 'TestWebservice' . $Helper->GetRandomID();
my $WebserviceID     = $WebserviceObject->WebserviceAdd(
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
ok( $WebserviceID, "WebserviceAdd WebService $WebserviceID" );

my $MappingInbound = <<'ENDTEMPLATE';
<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    version="1.0"
    extension-element-prefixes="date">

    <xsl:output method="xml" encoding="utf-8" indent="yes" />

    <!-- Don't return unmatched tags -->
    <xsl:template match="text()" />

    <!-- Remove empty elements -->
    <xsl:template match="*[not(node())]" />

    <!-- Root template -->
    <xsl:template match="/">
        <RootElement>
            <xsl:apply-templates />
        </RootElement>
    </xsl:template>

    <xsl:template match="/*/Ticket">
        <PossibleValue>
            <Key>Key1</Key>
            <Value>Value1</Value>
        </PossibleValue>
        <PossibleValue>
            <Key>Key2</Key>
            <Value>Value2</Value>
        </PossibleValue>
        <PossibleValue>
            <Key>Key3</Key>
            <Value>Value3</Value>
        </PossibleValue>
    </xsl:template>
</xsl:transform>
ENDTEMPLATE

my $MappingOutbound = <<"ENDTEMPLATE",
<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    version="1.0"
    extension-element-prefixes="date">
    <xsl:output method="xml" encoding="utf-8" indent="yes" />

    <!-- Don't return unmatched tags -->
    <xsl:template match="text()" />

    <!-- Remove empty elements -->
    <xsl:template match="*[not(node())]" />

    <!-- Root template -->
    <xsl:template match="/">
        <RootElement>
            <UserLogin>$TestUser</UserLogin>
            <Password>$TestUser</Password>
            <TicketID>$SourceTicketID1</TicketID>
        </RootElement>
    </xsl:template>
</xsl:transform>
ENDTEMPLATE

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . "nph-genericinterface.pl/WebserviceID/$WebserviceID";

my $WebserviceConfig = {
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => '0',
    },
    Description      => 'Dynamic Field Web Service Test',
    FrameworkVersion => '6.0.x git',
    Provider         => {
        Operation => {
            TicketGet => {
                Type => 'Ticket::TicketGet',
            },
        },
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength         => 100000000,
                NameSpace         => 'http://www.otobo.org/TicketConnector/',
                RequestNameScheme => 'Request',
            },
        },
    },
    Requester => {
        Invoker => {
            TicketGet => {
                Type           => 'Generic::PassThrough',
                MappingInbound => {
                    Type   => 'XSLT',
                    Config => {
                        Template => $MappingInbound,
                    },
                },
                MappingOutbound => {
                    Type   => 'XSLT',
                    Config => {
                        Template => $MappingOutbound,
                    },
                },
            },
        },
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
                NameSpace => 'http://www.otobo.org/TicketConnector/',
            },
        },
    },
};

# Update webs service with real config.
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => 1,
);
ok( $WebserviceUpdate, "Updated Webservice $WebserviceID - $WebserviceName" );

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# Add webservice dynamic field and its possible values.
my $RandomID          = $Helper->GetRandomID();
my $DynamicFieldName  = 'WebService' . $RandomID;
my $DynamicFieldLabel = 'WebService';
my $DynamicFieldID    = $DynamicFieldObject->DynamicFieldAdd(
    Config => {
        CacheTTL           => 0,
        WebserviceID       => $WebserviceID,
        Invoker            => 'TicketGet',
        Multiselect        => 1,
        PossibleNone       => 0,
        TranslatableValues => 0,
        TreeView           => 0,
    },
    Name          => $DynamicFieldName,
    Label         => $DynamicFieldLabel,
    FieldOrder    => 9991,
    InternalField => 0,
    FieldType     => 'WebService',
    ObjectType    => 'Ticket',
    ValidID       => 1,
    UserID        => 1,
);
ok( $DynamicFieldID, "DynamicFieldAdd() ID $DynamicFieldID" );

my @Tests = (
    {
        Name   => 'MultiValueOneValue',
        Values => ['Key1'],
    },
    {
        Name   => 'MultiValueTwoValues',
        Values => [ 'Key1', 'Key2' ],
    },
    {
        Name   => 'MultiValueThreeValues',
        Values => [ 'Key1', 'Key2', 'Key3' ],
    },
);

my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
    ID => $DynamicFieldID,
);

my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

for my $Test (@Tests) {

    subtest "$Test->{Name} Webservice $WebserviceID - $WebserviceName" => sub {

        my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        my $TestTicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket_Title',
            Queue        => 'Misc',
            Lock         => 'lock',
            Priority     => '2 low',
            State        => 'open',
            CustomerNo   => 'example.com',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => $TestUserID,
        );
        ok( $TestTicketID, "TicketCreate() Ticket 2 $TestTicketID" );

        my @ValueText;
        for my $Value ( $Test->{Values}->@* ) {
            push @ValueText, {
                ValueText => $Value
            };
        }

        my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
            FieldID  => $DynamicFieldID,
            ObjectID => $TestTicketID,
            UserID   => $TestUserID,
            Value    => \@ValueText,
        );

        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TestTicketID,
            DynamicFields => 1
        );

        my $ValuesCount = scalar $Test->{Values}->@*;
        for ( my $Count = 0; $Count < $ValuesCount; $Count++ ) {

            ok( $Test->{Values}->[$Count] eq $Ticket{"DynamicField_$DynamicFieldName"}->[$Count], "Match Value" );
        }

        $Success = $TicketObject->TicketDelete(
            TicketID => $TestTicketID,
            UserID   => 1,
        );
        ok( $Success, "Ticket ID $TestTicketID - deleted" );

    };
}

for my $TicketID ($SourceTicketID1) {

    # Delete test created ticket.
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    ok( $Success, "Ticket ID $TicketID - deleted" );
}

# Delete test created database dynamic field.
my $DynamicFieldDeleteSuccess = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $DynamicFieldID,
    UserID => 1,
);
ok( $DynamicFieldDeleteSuccess, "Database dynamic field ID $DynamicFieldID - deleted" );

my $WebserviceDeleteSuccess = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
ok( $WebserviceDeleteSuccess, "Web Service ID $WebserviceID - deleted" );

# Make sure the cache is correct.
for my $Cache (qw(Ticket DynamicField Webservice)) {
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Cache,
    );
}

done_testing();
