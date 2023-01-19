# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::ToolBar::TicketWatcher;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if feature is active
    return if !$ConfigObject->Get('Ticket::Watcher');

    # check needed stuff
    for (qw(Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    return if !$ConfigObject->Get('Frontend::Module')->{AgentTicketWatchView};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check access
    my @Groups;
    if ( $ConfigObject->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $ConfigObject->Get('Ticket::WatcherGroup') };
    }
    if (@Groups) {
        my $Access      = 0;
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        GROUP:
        for my $Group (@Groups) {
            my $HasPermission = $GroupObject->PermissionCheck(
                UserID    => $Self->{UserID},
                GroupName => $Group,
                Type      => 'rw',
            );
            if ($HasPermission) {
                $Access = 1;
                last GROUP;
            }
        }

        # return on no access
        return if !$Access;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # find watched tickets
    my $Count = $TicketObject->TicketSearch(
        Result       => 'COUNT',
        WatchUserIDs => [ $Self->{UserID} ],
        UserID       => 1,
        Permission   => 'ro',
    ) || 0;
    my $CountNew = $TicketObject->TicketSearch(
        Result       => 'COUNT',
        WatchUserIDs => [ $Self->{UserID} ],
        TicketFlag   => {
            Seen => 1,
        },
        TicketFlagUserID => $Self->{UserID},
        UserID           => 1,
        Permission       => 'ro',
    ) || 0;
    $CountNew = $Count - $CountNew;

    my $CountReached = $TicketObject->TicketSearch(
        Result                        => 'COUNT',
        StateType                     => ['pending reminder'],
        WatchUserIDs                  => [ $Self->{UserID} ],
        TicketPendingTimeOlderMinutes => 1,
        UserID                        => 1,
        Permission                    => 'ro',
    ) || 0;

    my $Class        = $Param{Config}->{CssClass};
    my $ClassNew     = $Param{Config}->{CssClassNew};
    my $ClassReached = $Param{Config}->{CssClassReached};

    my $Icon        = $Param{Config}->{Icon};
    my $IconNew     = $Param{Config}->{IconNew};
    my $IconReached = $Param{Config}->{IconReached};

    my $URL = $LayoutObject->{Baselink};
    my %Return;
    my $Priority = $Param{Config}->{Priority};
    if ($CountNew) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Watched Tickets New'),
            Count       => $CountNew,
            Class       => $ClassNew,
            Icon        => $IconNew,
            Link        => $URL . 'Action=AgentTicketWatchView;Filter=New',
            AccessKey   => $Param{Config}->{AccessKeyNew} || '',
        };
    }
    if ($CountReached) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Watched Tickets Reminder Reached'),
            Count       => $CountReached,
            Class       => $ClassReached,
            Icon        => $IconReached,
            Link        => $URL . 'Action=AgentTicketWatchView;Filter=ReminderReached',
            AccessKey   => $Param{Config}->{AccessKeyReached} || '',
        };
    }
    if ($Count) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Watched Tickets Total'),
            Count       => $Count,
            Class       => $Class,
            Icon        => $Icon,
            Link        => $URL . 'Action=AgentTicketWatchView',
            AccessKey   => $Param{Config}->{AccessKey} || '',
        };
    }
    return %Return;
}

1;
