# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2020-01-10 16:00:00',
    },
);
FixedTimeSet($DateTimeObject);

# Do not check email addresses.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Do not check RichText.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Frontend::RichText',
    Value => 0,
);

# Set DefaultLanguage to UTC.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'DefaultLanguage',
    Value => 'en',
);

# Set OTOBOTimeZone to UTC.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'OTOBOTimeZone',
    Value => 'UTC',
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Create test ticket.
my $TicketNumber = $TicketObject->TicketCreateNumber();
my $TicketID     = $TicketObject->TicketCreate(
    TN           => $TicketNumber,
    Title        => 'UnitTest ticket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerID   => '12345',
    CustomerUser => 'test@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "TicketID $TicketID is created",
);

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Phone',
);

my $LastAgentSubject      = 'Article#3-agent';
my $LastAgentSubject9     = 'Article#3 [...]';
my $LastAgentBody         = "agent-Article#3-Line1\nagent-Article#3-Line2\nagentArticle#3-Line3";
my $LastAgentBody2        = "> agent-Article#3-Line1\n> agent-Article#3-Line2";
my $LastCustomerSubject   = 'Article#6-customer';
my $LastCustomerSubject12 = 'Article#6-cu [...]';
my $LastCustomerBody      = "customer-Article#6-Line1\ncustomer-Article#6-Line2\ncustomerArticle#6-Line3";
my $LastCustomerBody1     = "> customer-Article#6-Line1";

my @Configs = (
    {
        SenderType => 'agent',
        Subject    => 'Article#1-agent',
        Body       => "agent-Article#1-Line1\nagent-Article#1-Line2\nagentArticle#1-Line3",
    },
    {
        SenderType => 'agent',
        Subject    => 'Article#2-agent',
        Body       => "agent-Article#2-Line1\nagent-Article#2-Line2\nagentArticle#2-Line3",
    },
    {
        SenderType => 'agent',
        Subject    => $LastAgentSubject,
        Body       => $LastAgentBody,
    },
    {
        SenderType => 'customer',
        Subject    => 'Article#4-customer',
        Body       => "customer-Article#4-Line1\ncustomer-Article#4-Line2\ncustomerArticle#4-Line3",
    },
    {
        SenderType => 'customer',
        Subject    => 'Article#5-customer',
        Body       => "customer-Article#5-Line1\ncustomer-Article#5-Line2\ncustomerArticle#5-Line3",
    },
    {
        SenderType => 'customer',
        Subject    => $LastCustomerSubject,
        Body       => $LastCustomerBody,
    },
);

my @Articles;

for my $Config (@Configs) {
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        %{$Config},
        TicketID             => $TicketID,
        IsVisibleForCustomer => 0,
        From                 => 'Some Agent <otobo@example.com>',
        To                   => 'Suplier<suplier@example.com>',
        Charset              => 'utf8',
        MimeType             => 'text/plain',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
    );
    $Self->True(
        $ArticleID,
        "ArticleID $ArticleID is created"
    );
    my %ArticleData = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );
    push @Articles, \%ArticleData;
}

# Get ticket and article data for tests.
my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

# Define for which template types certain tags are supported.
my %Supported = (
    Answer  => 1,
    Forward => 1,
    Note    => 1,
);

my @Tests = (
    {
        Name           => 'Supported tag - <OTOBO_CONFIG_ScriptAlias>',
        TemplateText   => 'Thank you for your email. <OTOBO_CONFIG_ScriptAlias>',
        ExpectedResult => 'Thank you for your email. ' . $ConfigObject->Get('ScriptAlias'),
    },
    {
        Name         => 'Supported tags - <OTOBO_TICKET_*> without TicketID',
        TemplateText =>
            'Options of the ticket data (e. g. <OTOBO_TICKET_TicketNumber>, <OTOBO_TICKET_TicketID>, <OTOBO_TICKET_Queue>)',
        ExpectedResult => 'Options of the ticket data (e. g. -, -, -)',
    },
    {
        Name         => 'Supported tags - <OTOBO_TICKET_*>  with TicketID',
        TemplateText =>
            'Options of the ticket data (e. g. <OTOBO_TICKET_TicketNumber>, <OTOBO_TICKET_TicketID>, <OTOBO_TICKET_Queue>, <OTOBO_TICKET_State>)',
        ExpectedResult => "Options of the ticket data (e. g. $TicketNumber, $TicketID, Raw, open)",
        TicketID       => $TicketID,
    },
    {
        Name           => 'Tag <OTOBO_AGENT_SUBJECT>',
        TemplateText   => 'Test: <OTOBO_AGENT_SUBJECT>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastAgentSubject",
            Supported => {
                $Articles[0]->{ArticleID} => "Test: $Articles[0]->{Subject}",
                $Articles[1]->{ArticleID} => "Test: $Articles[1]->{Subject}",
                $Articles[2]->{ArticleID} => "Test: $Articles[2]->{Subject}",
                $Articles[3]->{ArticleID} => 'Test: -',
                $Articles[4]->{ArticleID} => 'Test: -',
                $Articles[5]->{ArticleID} => 'Test: -',
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name           => 'Tag <OTOBO_AGENT_SUBJECT[9]>',
        TemplateText   => 'Test: <OTOBO_AGENT_SUBJECT[9]>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastAgentSubject9",
            Supported => {
                $Articles[0]->{ArticleID} => 'Test: Article#1 [...]',
                $Articles[1]->{ArticleID} => 'Test: Article#2 [...]',
                $Articles[2]->{ArticleID} => 'Test: Article#3 [...]',
                $Articles[3]->{ArticleID} => 'Test: -',
                $Articles[4]->{ArticleID} => 'Test: -',
                $Articles[5]->{ArticleID} => 'Test: -',
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name           => 'Tag <OTOBO_AGENT_BODY>',
        TemplateText   => 'Test: <OTOBO_AGENT_BODY>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastAgentBody",
            Supported => {
                $Articles[0]->{ArticleID} => "Test: $Articles[0]->{Body}",
                $Articles[1]->{ArticleID} => "Test: $Articles[1]->{Body}",
                $Articles[2]->{ArticleID} => "Test: $Articles[2]->{Body}",
                $Articles[3]->{ArticleID} => 'Test: -',
                $Articles[4]->{ArticleID} => 'Test: -',
                $Articles[5]->{ArticleID} => 'Test: -',
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name           => 'Tag <OTOBO_AGENT_BODY[2]>',
        TemplateText   => 'Test: <OTOBO_AGENT_BODY[2]>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastAgentBody2",
            Supported => {
                $Articles[0]->{ArticleID} => "Test: > agent-Article#1-Line1\n> agent-Article#1-Line2",
                $Articles[1]->{ArticleID} => "Test: > agent-Article#2-Line1\n> agent-Article#2-Line2",
                $Articles[2]->{ArticleID} => "Test: > agent-Article#3-Line1\n> agent-Article#3-Line2",
                $Articles[3]->{ArticleID} => 'Test: -',
                $Articles[4]->{ArticleID} => 'Test: -',
                $Articles[5]->{ArticleID} => 'Test: -',
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name           => 'Tag <OTOBO_CUSTOMER_SUBJECT>',
        TemplateText   => 'Test: <OTOBO_CUSTOMER_SUBJECT>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastCustomerSubject",
            Supported => {
                $Articles[0]->{ArticleID} => "Test: $Articles[0]->{Subject}",
                $Articles[1]->{ArticleID} => "Test: $Articles[1]->{Subject}",
                $Articles[2]->{ArticleID} => "Test: $Articles[2]->{Subject}",
                $Articles[3]->{ArticleID} => "Test: $Articles[3]->{Subject}",
                $Articles[4]->{ArticleID} => "Test: $Articles[4]->{Subject}",
                $Articles[5]->{ArticleID} => "Test: $Articles[5]->{Subject}",
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name           => 'Tag <OTOBO_CUSTOMER_SUBJECT[12]>',
        TemplateText   => 'Test: <OTOBO_CUSTOMER_SUBJECT[12]>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastCustomerSubject12",
            Supported => {
                $Articles[0]->{ArticleID} => 'Test: Article#1-ag [...]',
                $Articles[1]->{ArticleID} => 'Test: Article#2-ag [...]',
                $Articles[2]->{ArticleID} => 'Test: Article#3-ag [...]',
                $Articles[3]->{ArticleID} => 'Test: Article#4-cu [...]',
                $Articles[4]->{ArticleID} => 'Test: Article#5-cu [...]',
                $Articles[5]->{ArticleID} => 'Test: Article#6-cu [...]',
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name           => 'Tag <OTOBO_CUSTOMER_BODY>',
        TemplateText   => 'Test: <OTOBO_CUSTOMER_BODY>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastCustomerBody",
            Supported => {
                $Articles[0]->{ArticleID} => "Test: $Articles[0]->{Body}",
                $Articles[1]->{ArticleID} => "Test: $Articles[1]->{Body}",
                $Articles[2]->{ArticleID} => "Test: $Articles[2]->{Body}",
                $Articles[3]->{ArticleID} => "Test: $Articles[3]->{Body}",
                $Articles[4]->{ArticleID} => "Test: $Articles[4]->{Body}",
                $Articles[5]->{ArticleID} => "Test: $Articles[5]->{Body}",
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name           => 'Tag <OTOBO_CUSTOMER_BODY[1]>',
        TemplateText   => 'Test: <OTOBO_CUSTOMER_BODY[1]>',
        TicketID       => $TicketID,
        TemplateResult => {
            Note      => "Test: $LastCustomerBody1",
            Supported => {
                $Articles[0]->{ArticleID} => "Test: > agent-Article#1-Line1",
                $Articles[1]->{ArticleID} => "Test: > agent-Article#2-Line1",
                $Articles[2]->{ArticleID} => "Test: > agent-Article#3-Line1",
                $Articles[3]->{ArticleID} => "Test: > customer-Article#4-Line1",
                $Articles[4]->{ArticleID} => "Test: > customer-Article#5-Line1",
                $Articles[5]->{ArticleID} => "Test: > customer-Article#6-Line1",
            },
            Unsupported => 'Test: -',
        }
    },
    {
        Name         => 'Test supported tag - <OTOBO_EMAIL_DATE[*]> with time zones',
        TemplateText =>
            'Belgrade: <OTOBO_EMAIL_DATE[Europe/Belgrade]>; Denver: <OTOBO_EMAIL_DATE[America/Denver]>; Tokyo: <OTOBO_EMAIL_DATE[Asia/Tokyo]>',
        ExpectedResult =>
            "Belgrade: Friday, January 10, 2020 at 17:00:00 (Europe/Belgrade); Denver: Friday, January 10, 2020 at 09:00:00 (America/Denver); Tokyo: Saturday, January 11, 2020 at 01:00:00 (Asia/Tokyo)",
        Data     => \%TicketData,
        TicketID => $TicketID,
    },
    {
        Name         => 'Test supported tag - <OTOBO_EMAIL_DATE> without time zone',
        TemplateText =>
            'No TimeZone specified (UTC): <OTOBO_EMAIL_DATE>',
        ExpectedResult => 'No TimeZone specified (UTC): Friday, January 10, 2020 at 16:00:00 (UTC)',
        Data           => \%TicketData,
        TicketID       => $TicketID,
    },
);

my $StandardTemplateObject  = $Kernel::OM->Get('Kernel::System::StandardTemplate');
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

TEST:
for my $Test (@Tests) {
    for my $TemplateType (qw(Answer Forward Create Note Email PhoneCall)) {

        # Create standard template.
        my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
            Name         => $Helper->GetRandomID() . '-StandardTemplate',
            Template     => $Test->{TemplateText},
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => $TemplateType,
            ValidID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TemplateID,
            "'$TemplateType' type - TemplateID $TemplateID is created",
        );

        # Check template text.
        if ( $Test->{ExpectedResult} ) {
            my $Template = $TemplateGeneratorObject->Template(
                TemplateID => $TemplateID,
                TicketID   => $Test->{TicketID},
                Data       => $Test->{Data} // {},
                UserID     => 1,
            );
            $Self->Is(
                $Template,
                $Test->{ExpectedResult},
                "'$TemplateType' type - $Test->{Name}",
            );
        }
        elsif ( $Test->{TemplateResult} ) {

            # Test for all agent and customer articles.
            for my $Article (@Articles) {
                my $Template = $TemplateGeneratorObject->Template(
                    TemplateID => $TemplateID,
                    TicketID   => $Test->{TicketID},
                    Data       => { %TicketData, %{$Article} },
                    UserID     => 1,
                );

                if ( $Supported{$TemplateType} ) {
                    my $ExpectedResult = $Test->{TemplateResult}->{Supported}->{ $Article->{ArticleID} } // '';

                    # For Note template, there is last article data.
                    if ( $TemplateType eq 'Note' ) {
                        $ExpectedResult = $Test->{TemplateResult}->{Note};
                    }

                    $Self->Is(
                        $Template,
                        $ExpectedResult,
                        "'$TemplateType' type - $Article->{Subject} - $Test->{Name}",
                    );
                }
                else {
                    $Self->Is(
                        $Template,
                        $Test->{TemplateResult}->{Unsupported},
                        "'$TemplateType' type - $Article->{Subject} - $Test->{Name}",
                    );
                }
            }
        }
    }
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
