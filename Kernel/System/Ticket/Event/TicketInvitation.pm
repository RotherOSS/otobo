# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Ticket::Event::TicketInvitation;

use v5.24;
use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::AsynchronousExecutor);

our @ObjectDependencies = (
    'Kernel::System::Calendar',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Data!",
            );

            return;
        }
    }

    my ( $TicketID, $ArticleID ) = $Param{Data}->@{qw(TicketID ArticleID)};

    # only article events are supported
    return unless $Param{Event} =~ m/^Article/;

    # loop protection: submit the task only once for an article in this process
    return if $Kernel::OM->Get('Kernel::System::Ticket')
        ->{'_TicketInvitation::AlreadyProcessed'}
        ->{$TicketID}
        ->{$ArticleID}++;

    my %Calendar = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarGet(
        CalendarName => $Param{Config}->{CalendarName},
    );

    # create ticket participations in an asynchronous call
    return $Self->AsyncCall(
        ObjectName     => 'Kernel::System::Calendar',
        FunctionName   => 'TicketInvitationProcessArticle',
        FunctionParams => {
            TicketID   => $TicketID,
            ArticleID  => $ArticleID,
            CalendarID => $Calendar{CalendarID},
            RuleID     => $Param{Config}->{RuleID},    # refering to a (dummy) ticket appointment rule
            UserID     => $Param{UserID},
        },
    );
}

1;
