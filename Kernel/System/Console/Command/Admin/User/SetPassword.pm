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

package Kernel::System::Console::Command::Admin::User::SetPassword;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Update the password for an agent.');
    $Self->AddArgument(
        Name        => 'user',
        Description => "Specify the user login of the agent to be updated.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'password',
        Description => "Set a new password for the agent (a password will be generated otherwise).",
        Required    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Login = $Self->GetArgument('user');

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my %UserList   = $UserObject->UserSearch(
        UserLogin => $Login,
    );

    if ( !scalar %UserList ) {
        $Self->PrintError("No user found with login '$Login'!\n");
        return $Self->ExitCodeError();
    }

    # if no password has been provided, generate one
    my $Password = $Self->GetArgument('password');
    if ( !$Password ) {
        $Password = $UserObject->GenerateRandomPassword( Size => 12 );
        $Self->Print("<yellow>Generated password '$Password'.</yellow>\n");
    }

    my $Result = $UserObject->SetPassword(
        UserLogin => $Login,
        PW        => $Password,
    );

    if ( !$Result ) {
        $Self->PrintError("Failed to set password!\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Successfully set password for user '$Login'.</green>\n");
    return $Self->ExitCodeOk();
}

1;
