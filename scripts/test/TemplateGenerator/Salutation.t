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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketObject            = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject           = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $QueueObject             = $Kernel::OM->Get('Kernel::System::Queue');
my $SalutationObject        = $Kernel::OM->Get('Kernel::System::Salutation');
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');
my $CustomerCompanyObject   = $Kernel::OM->Get('Kernel::System::CustomerCompany');

# create test company
my $TestCustomerID    = $Helper->GetRandomID() . "CID";
my $TestCompanyName   = "Company" . $Helper->GetRandomID();
my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
    CustomerID             => $TestCustomerID,
    CustomerCompanyName    => $TestCompanyName,
    CustomerCompanyStreet  => '5201 Blue Lagoon Drive',
    CustomerCompanyZIP     => '33126',
    CustomerCompanyCity    => 'Miami',
    CustomerCompanyCountry => 'USA',
    CustomerCompanyURL     => 'http://www.example.org',
    CustomerCompanyComment => 'some comment',
    ValidID                => 1,
    UserID                 => 1,
);
$Self->True(
    $CustomerCompanyID,
    "CustomerCompany is created - ID $CustomerCompanyID",
);

# create test customer user
my $TestUserLogin      = 'Customer' . $Helper->GetRandomID();
my $TestUserFirstname  = 'Firstname' . $Helper->GetRandomID();
my $TestUserLastname   = 'Lastname' . $Helper->GetRandomID();
my $CustomerEmail      = "$TestUserLogin\@localhost.com";
my $TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => $TestUserFirstname,
    UserLastname   => $TestUserLastname,
    UserCustomerID => $TestCustomerID,
    UserLogin      => $TestUserLogin,
    UserEmail      => $CustomerEmail,
    ValidID        => 1,
    UserID         => 1
);
$Self->True(
    $TestCustomerUserID,
    "CustomerUser is created - ID $TestCustomerUserID",
);

my @Tests = (
    {
        Name       => 'Test supported tags -<OTOBO_CUSTOMER_REALNAME> and <OTOBO_CUSTOMER_DATA_UserEmail>',
        Salutation => "Dear <OTOBO_CUSTOMER_REALNAME>,

    Thank you for your request. Your email address in our database
    is \"<OTOBO_CUSTOMER_DATA_UserEmail>\".
    ",
        ExpectedResult => "Dear $TestUserFirstname $TestUserLastname,

    Thank you for your request. Your email address in our database
    is \"$CustomerEmail\".
    ",
    },
    {
        Name           => 'Test unsupported tags',
        Salutation     => 'Test: <OTOBO_AGENT_SUBJECT> <OTOBO_AGENT_BODY> <OTOBO_CUSTOMER_BODY> <OTOBO_CUSTOMER_SUBJECT>',
        ExpectedResult => 'Test: - - - -',
    },
    {
        Name       => 'Test supported tags - <OTOBO_TICKET_*>  with TicketID',
        Salutation =>
            'Options of the ticket data (e. g. <OTOBO_TICKET_TicketNumber>, <OTOBO_TICKET_TicketID>, <OTOBO_TICKET_Queue>, <OTOBO_TICKET_State>)',
    },
);

# check salutation text without TicketID or QueueID
my $Salutation = $TemplateGeneratorObject->Salutation(
    UserID => 1,
    Data   => {},
);
$Self->False(
    $Salutation,
    'Template Salutation() - without TicketID.',
);

for my $Test (@Tests) {

    # add salutation
    my $SalutationID = $SalutationObject->SalutationAdd(
        Name => $Helper->GetRandomID() . '-Salutation',
        Text => $Test->{Salutation},

        ContentType => 'text/plain; charset=utf-8',
        Comment     => 'some comment',
        ValidID     => 1,
        UserID      => 1,
    );
    $Self->True(
        $SalutationID,
        "Salutation is created - ID $SalutationID",
    );

    my $QueueName = $Helper->GetRandomID() . '-Queue';
    my $QueueID   = $QueueObject->QueueAdd(
        Name            => $QueueName,
        ValidID         => 1,
        GroupID         => 1,
        SystemAddressID => 1,
        SalutationID    => $SalutationID,
        SignatureID     => 1,
        UserID          => 1,
        Comment         => 'Selenium Test',
    );
    $Self->True(
        $QueueID,
        "Queue is created - ID $QueueID",
    );

    # create test ticket
    my $TicketNumber = $TicketObject->TicketCreateNumber();
    my $TicketID     = $TicketObject->TicketCreate(
        TN           => $TicketNumber,
        Title        => 'UnitTest ticket',
        QueueID      => $QueueID,
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerID   => $TestCustomerID,
        CustomerUser => $TestUserLogin,
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        "Ticket is created - ID $TicketID",
    );

    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    # create test email article
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        IsVisibleForCustomer => 1,
        SenderType           => 'customer',
        Subject              => 'some short description',
        Body                 => 'the message text',
        Charset              => 'ISO-8859-15',
        MimeType             => 'text/plain',
        HistoryType          => 'EmailCustomer',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
    );
    $Self->True(
        $ArticleID,
        "Article is created - ID $ArticleID",
    );

    # get last article
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );

    if ( !defined $Test->{ExpectedResult} ) {
        $Test->{ExpectedResult} = "Options of the ticket data (e. g. $TicketNumber, $TicketID, $QueueName, open)";
    }

    my $Salutation = $TemplateGeneratorObject->Salutation(
        TicketID => $TicketID,
        Data     => {%Article},
        UserID   => 1,
    );

    # check salutation text
    $Self->Is(
        $Salutation,
        $Test->{ExpectedResult},
        $Test->{Name},
    );

}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
