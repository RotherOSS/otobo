# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use Test2::V0;
use Kernel::GenericInterface::Invoker::Elasticsearch::TicketManagement;

# Only record recovery calls: no database, Elasticsearch or ticket changes.
# The package TicketManagementTest::Objects acts both as a dummy ObjectManager
# and a dummy Ticket object.
{

    package TicketManagementTest::Objects;

    sub Get {
        my ($Self) = @_;

        return $Self;
    }

    sub TicketCreate {
        my ( $Self, %Param ) = @_;

        # only record the call
        push $Self->{Calls}->@*, [ TicketCreate => \%Param ];

        return 1;
    }

    sub ArticleList {
        my ( $Self, %Param ) = @_;

        # only record the call
        push $Self->{Calls}->@*, [ ArticleList => \%Param ];

        return ( { ArticleID => 11 }, { ArticleID => 12 } );
    }

    sub ArticleCreate {
        my ( $Self, %Param ) = @_;

        # only record the call
        push $Self->{Calls}->@*, [ ArticleCreate => \%Param ];

        return 1;
    }
}

my $Invoker = bless {}, 'Kernel::GenericInterface::Invoker::Elasticsearch::TicketManagement';

for my $Reason ( '[_doc][5]: document missing', '[5]: document missing' ) {
    subtest $Reason => sub {
        local $Kernel::OM = bless { Calls => [] }, 'TicketManagementTest::Objects';
        my $Result = $Invoker->HandleResponse(
            ResponseSuccess => 1,
            Data            => {
                error => {
                    type   => 'document_missing_exception',
                    reason => $Reason
                }
            },
        );
        ok( $Result->{Success}, 'recovery succeeds' );
        is(
            $Kernel::OM->{Calls},
            [
                [ TicketCreate => { TicketID => 5 } ],
                [ ArticleList  => { TicketID => 5 } ],
                [
                    ArticleCreate => {
                        TicketID  => 5,
                        ArticleID => 11
                    }
                ],
                [
                    ArticleCreate => {
                        TicketID  => 5,
                        ArticleID => 12
                    }
                ],
            ],
            'recreates the ticket and all its articles with the recovered ID',
        );
    };
}

for my $Reason (
    undef, '', '[abc]: document missing', '[0]: document missing',
    '[5]: unexpected error', 'prefix [5]: document missing', '[5]: document missing suffix'
    )
{
    subtest 'invalid reason: ' . ( $Reason // 'undef' ) => sub {
        local $Kernel::OM = bless { Calls => [] }, 'TicketManagementTest::Objects';
        my $Result = $Invoker->HandleResponse(
            ResponseSuccess => 1,
            Data            => {
                error => {
                    type   => 'document_missing_exception',
                    reason => $Reason
                }
            },
        );
        ok( !$Result->{Success}, 'reports an error when no valid ID can be recovered' );
        like( $Result->{ErrorMessage}, qr/Could not determine TicketID/, 'explains recovery failure' );
        is( $Kernel::OM->{Calls}, [], 'does not call ticket or article APIs with an invalid ID' );
    };
}

{
    local $Kernel::OM = bless { Calls => [] }, 'TicketManagementTest::Objects';
    my $Result = $Invoker->HandleResponse(
        ResponseSuccess => 1,
        Data            => { result => 'updated' }
    );
    ok( $Result->{Success}, 'normal response remains successful' );
    is( $Kernel::OM->{Calls}, [], 'normal response does not trigger recovery' );
    $Result = $Invoker->HandleResponse(
        ResponseSuccess      => 0,
        ResponseErrorMessage => 'transport failed'
    );
    is(
        $Result,
        {
            Success      => 0,
            ErrorMessage => 'transport failed'
        },
        'transport errors are preserved'
    );
}

done_testing;
