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

use vars (qw($Self));

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()'
);

my @ArticleIDs;

for my $Item ( 0 .. 1 ) {
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        IsVisibleForCustomer => 0,
        SenderType           => 'agent',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'Some free text!',
        Charset              => 'ISO-8859-15',
        MimeType             => 'text/plain',
        UserID               => 1,
    );

    $Self->True(
        $ArticleID,
        'ArticleCreate()'
    );

    push @ArticleIDs, $ArticleID;
}

# article flag tests
my @Tests = (
    {
        Name   => 'seen flag',
        Key    => 'seen',
        Value  => 1,
        UserID => 1,
    },
    {
        Name   => 'not seen flag',
        Key    => 'not seen',
        Value  => 2,
        UserID => 1,
    },
);

# delete pre-existing article flags which are created on TicketCreate
$ArticleObject->ArticleFlagDelete(
    TicketID  => $TicketID,
    ArticleID => $ArticleIDs[0],
    Key       => 'Seen',
    UserID    => 1,
);
$ArticleObject->ArticleFlagDelete(
    TicketID  => $TicketID,
    ArticleID => $ArticleIDs[1],
    Key       => 'Seen',
    UserID    => 1,
);

for my $Test (@Tests) {

    # set for article 1
    my %Flag = $ArticleObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet() article 1'
    );
    my $Set = $ArticleObject->ArticleFlagSet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        UserID    => 1,
    );
    $Self->True(
        $Set,
        'ArticleFlagSet() article 1'
    );

    # set for article 2
    %Flag = $ArticleObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[1],
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet() article 2'
    );
    $Set = $ArticleObject->ArticleFlagSet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[1],
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        UserID    => 1,
    );
    $Self->True(
        $Set,
        'ArticleFlagSet() article 2'
    );
    %Flag = $ArticleObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[1],
        UserID    => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        $Test->{Value},
        'ArticleFlagGet() article 2'
    );

    # get all flags of ticket
    %Flag = $ArticleObject->ArticleFlagsOfTicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->IsDeeply(
        \%Flag,
        {
            $ArticleIDs[0] => {
                $Test->{Key} => $Test->{Value},
            },
            $ArticleIDs[1] => {
                $Test->{Key} => $Test->{Value},
            },
        },
        'ArticleFlagsOfTicketGet() both articles'
    );

    # delete for article 1
    my $Delete = $ArticleObject->ArticleFlagDelete(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        UserID    => 1,
    );
    $Self->True(
        $Delete,
        'ArticleFlagDelete() article 1'
    );
    %Flag = $ArticleObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet() article 1'
    );

    %Flag = $ArticleObject->ArticleFlagsOfTicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->IsDeeply(
        \%Flag,
        {
            $ArticleIDs[1] => {
                $Test->{Key} => $Test->{Value},
            },
        },
        'ArticleFlagsOfTicketGet() only one article'
    );

    # delete for article 2
    $Delete = $ArticleObject->ArticleFlagDelete(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[1],
        Key       => $Test->{Key},
        UserID    => 1,
    );
    $Self->True(
        $Delete,
        'ArticleFlagDelete() article 2'
    );

    %Flag = $ArticleObject->ArticleFlagsOfTicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->IsDeeply(
        \%Flag,
        {},
        'ArticleFlagsOfTicketGet() empty articles'
    );

    # test ArticleFlagsDelete for AllUsers
    $Set = $ArticleObject->ArticleFlagSet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        UserID    => 1,
    );
    $Self->True(
        $Set,
        'ArticleFlagSet() article 1'
    );
    %Flag = $ArticleObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        $Test->{Value},
        'ArticleFlagGet() article 1'
    );
    $Delete = $ArticleObject->ArticleFlagDelete(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        Key       => $Test->{Key},
        AllUsers  => 1,
    );
    $Self->True(
        $Delete,
        'ArticleFlagDelete() article 1 for AllUsers'
    );
    %Flag = $ArticleObject->ArticleFlagGet(
        ArticleID => $ArticleIDs[0],
        UserID    => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        scalar undef,
        'ArticleFlagGet() article 1 after delete for AllUsers'
    );
}

# test searching for article flags

my @SearchTestFlagsSet = qw( f1 f2 f3 );

for my $Flag (@SearchTestFlagsSet) {
    my $Set = $ArticleObject->ArticleFlagSet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        Key       => $Flag,
        Value     => 42,
        UserID    => 1,
    );

    $Self->True(
        $Set,
        "Can set article flag $Flag"
    );
}

my @FlagSearchTests = (
    {
        Search => {
            ArticleFlag => {
                f1 => 42,
                f2 => 42,
            },
        },
        Expected => 1,
        Name     => 'Can find ticket when searching for two article flags',
    },
    {
        Search => {
            ArticleFlag => {
                f1 => 42,
                f2 => 1,
            },
        },
        Expected => 0,
        Name     => 'Wrong flag value leads to no match',
    },
);

for my $Test (@FlagSearchTests) {
    my $Found = $TicketObject->TicketSearch(
        TicketID => $TicketID,
        Result   => 'COUNT',
        UserID   => 1,
        %{ $Test->{Search} },
    );

    $Self->Is(
        $Found,
        $Test->{Expected},
        $Test->{Name}
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
