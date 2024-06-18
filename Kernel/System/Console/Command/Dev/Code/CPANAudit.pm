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

package Kernel::System::Console::Command::Dev::Code::CPANAudit;

use strict;
use warnings;

use CPAN::Audit;
use File::Basename;
use FindBin qw($Bin);

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = ();

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Scan CPAN dependencies in Kernel/cpan-lib and in the system for known vulnerabilities.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Audit = CPAN::Audit->new(
        no_color    => 1,
        no_corelist => 0,
        ascii       => 0,
        verbose     => 0,
        quiet       => 0,
        interactive => 0,
    );

    my @PathsToScan;

    # We need to pass an explicit list of paths to be scanned by CPAN::Audit, otherwise it will fallback to @INC which
    #   includes our complete tree, with article storage, cache, temp files, etc. It can result in a downgraded
    #   performance if this command is run often.
    #   Please see bug#14666 for more information.
    PATH:
    for my $Path (@INC) {
        next PATH if $Path && $Path eq '.';                          # Current folder
        next PATH if $Path && $Path eq dirname($Bin);                # OTOBO home folder
        next PATH if $Path && $Path eq dirname($Bin) . '/Custom';    # Custom folder
        push @PathsToScan, $Path;
    }

    # Workaround for CPAN::Audit::Installed. It does not use the passed param(s), but @ARGV instead.
    local @ARGV = @PathsToScan;
    return $Audit->command('installed') == 0 ? $Self->ExitCodeOk() : $Self->ExitCodeError();
}

1;
