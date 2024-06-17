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

my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
for my $Cache ( 0 .. 1 ) {
    $Self->IsDeeply(
        { $ArticleObject->ArticleSenderTypeList() },
        {
            '1' => 'agent',
            '2' => 'system',
            '3' => 'customer',
        },
        "ArticleSenderTypeList() - cache $Cache",
    );
}

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
for my $Cache ( 0 .. 1 ) {
    $Self->Is(
        $ArticleObject->ArticleSenderTypeLookup( SenderType => 'agent' ),
        1,
        "ArticleSenderTypeLookup( SenderType ) - cache $Cache",
    );
    $Self->Is(
        $ArticleObject->ArticleSenderTypeLookup( SenderTypeID => 1 ),
        'agent',
        "ArticleSenderTypeLookup( SenderTypeID ) - cache $Cache",
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
