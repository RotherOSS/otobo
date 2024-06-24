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

package Kernel::System::Console::Command::Admin::SystemAddress::Add;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add new system address.');
    $Self->AddOption(
        Name        => 'name',
        Description => "Display name of the new system address.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'email-address',
        Description => "Email address which should be used for the new system address.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'queue-name',
        Description => "Queue name the address should be linked to.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'comment',
        Description => "Comment for the new system address.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check if queue already exists
    $Self->{QueueName} = $Self->GetOption('queue-name');
    $Self->{QueueID}   = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
        Queue => $Self->{QueueName},
    );
    if ( !$Self->{QueueID} ) {
        die "Queue $Self->{QueueName} does not exist.\n";
    }

    # check if system address already exists
    $Self->{EmailAddress} = $Self->GetOption('email-address');
    my $SystemExists = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress(
        Address => $Self->{EmailAddress},
    );
    if ($SystemExists) {
        die "SystemAddress $Self->{EmailAddress} already exists.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Adding a new system address...</yellow>\n");

    # add system address
    if (
        !$Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressAdd(
            UserID   => 1,
            ValidID  => 1,
            Comment  => $Self->GetOption('comment'),
            Realname => $Self->GetOption('name'),
            QueueID  => $Self->{QueueID},
            Name     => $Self->{EmailAddress},
        )
        )
    {
        $Self->PrintError("Can't add system address.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
