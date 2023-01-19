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

package Kernel::Output::HTML::TicketMenu::Lock;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Ticket',
    'Kernel::System::Group',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    if ( !$Param{Ticket} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need Ticket!'
        );
        return;
    }

    # check if frontend module registered, if not, do not show action
    if ( $Param{Config}->{Action} ) {
        my $Module = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{ $Param{Config}->{Action} };
        return if !$Module;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check lock permission
    my $AccessOk = $TicketObject->TicketPermission(
        Type     => 'lock',
        TicketID => $Param{Ticket}->{TicketID},
        UserID   => $Self->{UserID},
        LogNo    => 1,
    );
    return if !$AccessOk;

    # check permission
    if ( $TicketObject->TicketLockGet( TicketID => $Param{Ticket}->{TicketID} ) ) {
        my $AccessOk = $TicketObject->OwnerCheck(
            TicketID => $Param{Ticket}->{TicketID},
            OwnerID  => $Self->{UserID},
        );
        return if !$AccessOk;
    }

    # group check
    if ( $Param{Config}->{Group} ) {

        my @Items = split /;/, $Param{Config}->{Group};

        my $AccessOk;
        ITEM:
        for my $Item (@Items) {

            my ( $Permission, $Name ) = split /:/, $Item;

            if ( !$Permission || !$Name ) {
                $LogObject->Log(
                    Priority => 'error',
                    Message  => "Invalid config for Key Group: '$Item'! "
                        . "Need something like '\$Permission:\$Group;'",
                );
            }

            my %Groups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
                UserID => $Self->{UserID},
                Type   => $Permission,
            );

            next ITEM if !%Groups;

            my %GroupsReverse = reverse %Groups;

            next ITEM if !$GroupsReverse{$Name};

            $AccessOk = 1;

            last ITEM;
        }

        return if !$AccessOk;
    }

    # check acl
    my %ACLLookup = reverse( %{ $Param{ACL} || {} } );
    return if ( !$ACLLookup{ $Param{Config}->{Action} } );

    # if ticket is locked
    if ( $Param{Ticket}->{Lock} eq 'lock' ) {

        # if it is locked for somebody else
        return if $Param{Ticket}->{OwnerID} ne $Self->{UserID};

        # show unlock action
        return {
            %{ $Param{Config} },
            %{ $Param{Ticket} },
            %Param,
            Name        => Translatable('Unlock'),
            Description => Translatable('Unlock to give it back to the queue'),
            Link        =>
                'Action=AgentTicketLock;Subaction=Unlock;TicketID=[% Data.TicketID | uri %];[% Env("ChallengeTokenParam") | html %]',
        };
    }

    # if ticket is unlocked
    return {
        %{ $Param{Config} },
        %{ $Param{Ticket} },
        %Param,
        Name        => Translatable('Lock'),
        Description => Translatable('Lock it to work on it'),
        Link        =>
            'Action=AgentTicketLock;Subaction=Lock;TicketID=[% Data.TicketID | uri %];[% Env("ChallengeTokenParam") | html %]',
    };
}

1;
