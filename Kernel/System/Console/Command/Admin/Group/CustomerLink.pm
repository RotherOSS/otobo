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

package Kernel::System::Console::Command::Admin::Group::CustomerLink;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::CustomerGroup',
    'Kernel::System::CustomerUser',
    'Kernel::System::Group',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Connect a customer user to a group.');
    $Self->AddOption(
        Name        => 'customer-user-login',
        Description => 'Login name of the customer who should be linked to the given group.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'group-name',
        Description => 'Group name of the group the given customer should be linked to.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'permission',
        Description => 'Permission (ro|rw) the customer user should have for the group he is going to be linked to.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/(ro|rw)/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    $Self->{CustomerLogin} = $Self->GetOption('customer-user-login');
    $Self->{GroupName}     = $Self->GetOption('group-name');

    # check role
    my $CustomerName = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
        UserLogin => $Self->{CustomerLogin},
    );
    if ( !$CustomerName ) {
        die "Customer $Self->{CustomerLogin} does not exist.\n";
    }

    # check group
    $Self->{GroupID} = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup( Group => $Self->{GroupName} );
    if ( !$Self->{GroupID} ) {
        die "Group $Self->{GroupName} does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Trying to link customer $Self->{CustomerLogin} to group $Self->{GroupName}...</yellow>\n");

    my %Permissions;
    for my $Permission (qw(ro rw)) {
        $Permissions{$Permission} = ( $Self->GetOption('permission') eq $Permission ) ? 1 : 0;
    }

    # add user 2 group
    if (
        !$Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberAdd(
            UID        => $Self->{CustomerLogin},
            GID        => $Self->{GroupID},
            UserID     => 1,
            ValidID    => 1,
            Permission => {
                %Permissions,
            },
        )
        )
    {
        $Self->PrintError("Can't add user to group.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
