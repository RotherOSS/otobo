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

package Kernel::System::Console::Command::Admin::User::Add;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add a user.');
    $Self->AddOption(
        Name        => 'user-name',
        Description => "User name for the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'first-name',
        Description => "First name of the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'last-name',
        Description => "Last name of the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'email-address',
        Description => "Email address of the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'password',
        Description => "Password for the new user. If left empty, a password will be created automatically.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'group',
        Description => "Name of the group to which the new user should be added (with rw permissions!).",
        Required    => 0,
        HasValue    => 1,
        Multiple    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check if all groups exist
    my @Groups    = @{ $Self->GetOption('group') // [] };
    my %GroupList = reverse $Kernel::OM->Get('Kernel::System::Group')->GroupList();

    GROUP:
    for my $Group (@Groups) {
        if ( !$GroupList{$Group} ) {
            die "Group '$Group' does not exist.\n";
        }
        $Self->{Groups}->{ $GroupList{$Group} } = $Group;
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Adding a new user...</yellow>\n");

    # add user
    my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
        UserLogin     => $Self->GetOption('user-name'),
        UserFirstname => $Self->GetOption('first-name'),
        UserLastname  => $Self->GetOption('last-name'),
        UserPw        => $Self->GetOption('password'),
        UserEmail     => $Self->GetOption('email-address'),
        ChangeUserID  => 1,
        UserID        => 1,
        ValidID       => 1,
    );

    if ( !$UserID ) {
        $Self->PrintError("Can't add user.");
        return $Self->ExitCodeError();
    }

    for my $GroupID ( sort keys %{ $Self->{Groups} } ) {

        my $Success = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupUserAdd(
            UID        => $UserID,
            GID        => $GroupID,
            Permission => { 'rw' => 1 },
            UserID     => 1,
        );
        if ($Success) {
            $Self->Print( "<green>User added to group '" . $Self->{Groups}->{$GroupID} . "'</green>\n" );
        }
        else {
            $Self->PrintError( "Failed to add user to group '" . $Self->{Groups}->{$GroupID} . "'." );
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
