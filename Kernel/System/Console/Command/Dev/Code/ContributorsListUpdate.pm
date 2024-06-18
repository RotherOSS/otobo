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

package Kernel::System::Console::Command::Dev::Code::ContributorsListUpdate;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use IO::File ();

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Update the list of contributors based on git commit information.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    chdir $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my @Lines = qx{git log --format="%aN <%aE>"};
    my %Seen;
    map { $Seen{$_}++ } @Lines;

    my $FileHandle = IO::File->new( 'AUTHORS.md', 'w' );
    $FileHandle->print("The following persons contributed to OTOBO:\n\n");

    AUTHOR:
    for my $Author ( sort keys %Seen ) {
        chomp $Author;
        if ( $Author =~ m/^[^<>]+ \s <>\s?$/smx ) {
            $Self->Print("<yellow>Could not find Author $Author, skipping.</yellow>\n");
            next AUTHOR;
        }
        $FileHandle->print("* $Author\n");
    }

    $FileHandle->close();

    return $Self->ExitCodeOk();
}

1;
