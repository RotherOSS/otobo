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

package Kernel::System::Console::Command::Admin::Queue::List;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Queue',
    'Kernel::System::Valid',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List existing queues.');
    $Self->AddOption(
        Name        => 'all',
        Description => "Show all queues.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'verbose',
        Description => "More detailled output.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Listing Queues...</yellow>\n");

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %ValidList   = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    my $Valid  = !$Self->GetOption('all');
    my %Queues = $QueueObject->QueueList( Valid => $Valid );

    if ( $Self->GetOption('verbose') ) {
        for ( sort keys %Queues ) {
            my %Queue = $QueueObject->QueueGet( ID => $_ );

            $Self->Print( sprintf( "%6s", $_ ) . " $Queue{'Name'} " );
            if ( $Queue{'ValidID'} == 1 ) {
                $Self->Print("<green>$ValidList{$Queue{'ValidID'}}</green>\n");
            }
            else {
                $Self->Print("<yellow>$ValidList{$Queue{'ValidID'}}</yellow>\n");
            }
        }
    }
    else {
        for ( sort keys %Queues ) {
            $Self->Print("  $Queues{$_}\n");
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
