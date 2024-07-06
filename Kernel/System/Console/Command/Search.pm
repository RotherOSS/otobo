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

package Kernel::System::Console::Command::Search;

use strict;
use warnings;

use parent qw(
    Kernel::System::Console::BaseCommand
    Kernel::System::Console::Command::List
);

our @ObjectDependencies = (
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Search for commands.');
    $Self->AddArgument(
        Name        => 'searchterm',
        Description => "Find commands with similar names or descriptions.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return $Self->HandleSearch( SearchCommand => $Self->GetArgument('searchterm') );
}

# Also used from "Help" command.

sub HandleSearch {
    my ( $Self, %Param ) = @_;

    my $SearchCommand = $Param{SearchCommand};

    $Self->Print("Searching for commands similar to '<yellow>$SearchCommand</yellow>'...\n");

    my $PreviousCommandNameSpace = '';
    my $UsageText;

    COMMAND:
    for my $Command ( $Self->ListAllCommands() ) {
        my $CommandObject = $Kernel::OM->Get($Command);

        if (
            $Command !~ m{\Q$SearchCommand\E}smxi
            &&
            $CommandObject->Description() !~ m{\Q$SearchCommand\E}smxi
            )
        {
            next COMMAND;
        }
        my $CommandName = $CommandObject->Name();

        # Group by toplevel namespace
        my ($CommandNamespace) = $CommandName =~ m/^([^:]+)::/smx;
        $CommandNamespace //= '';
        if ( $CommandNamespace ne $PreviousCommandNameSpace ) {
            $UsageText .= "<yellow>$CommandNamespace</yellow>\n";
            $PreviousCommandNameSpace = $CommandNamespace;
        }
        $UsageText .= sprintf( " <green>%-40s</green> - %s\n", $CommandName, $CommandObject->Description() );
    }

    if ( !$UsageText ) {
        $Self->PrintWarning('No commands found.');

        return $Self->ExitCodeOk();
    }

    $Self->Print($UsageText);

    return $Self->ExitCodeOk();
}

1;
