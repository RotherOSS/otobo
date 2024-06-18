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

package Kernel::System::Console::Command::Maint::GenericInterface::DebugLog::Cleanup;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::GenericInterface::DebugLog',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete Generic Interface debug log entries.');

    $Self->AddOption(
        Name        => 'created-before-days',
        Description => "Remove debug log entries created more than ... days ago.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( $Self->GetOption('created-before-days') eq '0' ) {
        die "created-before-days must be greater than 0\n";
    }
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Deleting Generic Interface debug log entries...</yellow>\n");

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $Success = $DateTimeObject->Subtract(
        Days => $Self->GetOption('created-before-days'),
    );

    $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog')->LogCleanup(
        CreatedAtOrBefore => $DateTimeObject->ToString(),
    );

    if ( !$Success ) {
        $Self->Print("<green>Fail.</green>\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
