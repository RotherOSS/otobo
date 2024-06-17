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

package Kernel::System::Console::Command::Dev::Tools::ConsoleStats;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand Kernel::System::Console::Command::List);

our @ObjectDependencies = (
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Print some statistics about available console commands.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @Commands = $Self->ListAllCommands();
    my %OptionsCount;
    my %ArgumentsCount;
    for my $Command (@Commands) {
        my $CommandObject = $Kernel::OM->Get($Command);
        for my $Option ( @{ $CommandObject->{_Options} // [] } ) {
            $OptionsCount{ $Option->{Name} }++;
        }
        for my $Argument ( @{ $CommandObject->{_Arguments} // [] } ) {
            $ArgumentsCount{ $Argument->{Name} }++;
        }
    }
    my $OptionsSort = sub {
        my $ValueResult = $OptionsCount{$b} <=> $OptionsCount{$a};
        return $ValueResult if $ValueResult;
        return $a cmp $b;
    };
    $Self->Print("<yellow>Calculating option frequency...</yellow>\n");
    for my $OptionName ( sort $OptionsSort keys %OptionsCount ) {
        $Self->Print("  $OptionName: <yellow>$OptionsCount{$OptionName}</yellow>\n");
    }

    my $ArgumentsSort = sub {
        my $ValueResult = $ArgumentsCount{$b} <=> $ArgumentsCount{$a};
        return $ValueResult if $ValueResult;
        return $a cmp $b;
    };
    $Self->Print("<yellow>Calculating argument frequency...</yellow>\n");
    for my $ArgumentName ( sort $ArgumentsSort keys %ArgumentsCount ) {
        $Self->Print("  $ArgumentName: <yellow>$ArgumentsCount{$ArgumentName}</yellow>\n");
    }

    return $Self->ExitCodeOk();
}

1;
