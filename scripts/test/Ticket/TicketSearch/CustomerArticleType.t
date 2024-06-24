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

use Kernel::System::VariableCheck qw(:all);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$ConfigObject->Set(
    Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
    Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB',
);

my $UserID = 1;

# get a random id
my $RandomID = $Helper->GetRandomID();

# Make sure that the ticket and article objects get recreated for each loop.
$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::Ticket',
        'Kernel::System::Ticket::Article',
    ],
);

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel(
    ChannelName => 'Internal',
);

my @TicketIDs;

# create tickets
for my $TitleDataItem ( 'Ticket One Title', 'Ticket Two Title' ) {
    my $TicketID = $TicketObject->TicketCreate(
        Title        => "$TitleDataItem$RandomID",
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerID   => '123465' . $RandomID,
        CustomerUser => 'customerOne@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );

    # sanity check
    $Self->True(
        $TicketID,
        "TicketCreate() successful for Ticket ID $TicketID",
    );

    # get the Ticket entry
    my %TicketEntry = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $UserID,
    );

    $Self->True(
        IsHashRefWithData( \%TicketEntry ),
        "TicketGet() successful for Local TicketGet ID $TicketID",
    );

    push @TicketIDs, $TicketID;
}

# Create articles (article not visible for customer only for first article of first ticket).
for my $Item ( 0 .. 1 ) {
    for my $SubjectDataItem (qw( Kumbala Acua )) {
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketIDs[$Item],
            IsVisibleForCustomer => ( $Item == 0 && $SubjectDataItem eq 'Kumbala' ) ? 1 : 0,
            SenderType           => 'agent',
            From                 => 'Agent Some Agent Some Agent <email@example.com>',
            To                   => 'Customer A <customer-a@example.com>',
            Cc                   => 'Customer B <customer-b@example.com>',
            ReplyTo              => 'Customer B <customer-b@example.com>',
            Subject              => "$SubjectDataItem$RandomID",
            Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'first article',
            UserID               => 1,
            NoAgentNotify        => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - $ArticleID "
        );

        $ArticleObject->ArticleSearchIndexBuild(
            TicketID  => $TicketIDs[$Item],
            ArticleID => $ArticleID,
            UserID    => 1,
        );
    }
}

# actual tests
my @Tests = (
    {
        Name   => 'Agent Interface (Internal/External)',
        Config => {
            MIMEBase_Subject => 'Kumbala' . $RandomID,
            UserID           => 1,
        },
        ExpectedResults => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => 'Customer Interface (Internal/External)',
        Config => {
            MIMEBase_Subject => 'Kumbala' . $RandomID,
            CustomerUserID   => 'customerOne@example.com',
        },
        ExpectedResults => [ $TicketIDs[0] ],
        ForBothStorages => 1,
    },
    {
        Name   => 'Customer Interface (External/External)',
        Config => {
            MIMEBase_Subject => 'Acua' . $RandomID,
            UserID           => 1,
        },
        ExpectedResults => [ $TicketIDs[0], $TicketIDs[1] ],
    },
);

for my $Test (@Tests) {

    my @FoundTicketIDs = $TicketObject->TicketSearch(
        Result              => 'ARRAY',
        SortBy              => 'Age',
        OrderBy             => 'Down',
        Limit               => 100,
        UserID              => 1,
        ConditionInline     => 0,
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        FullTextIndex       => 1,
        %{ $Test->{Config} },
    );

    @FoundTicketIDs = sort { int $a <=> int $b } @FoundTicketIDs;
    @{ $Test->{ExpectedResults} } = sort { int $a <=> int $b } @{ $Test->{ExpectedResults} };

    $Self->IsDeeply(
        \@FoundTicketIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} TicketSearch() -"
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
