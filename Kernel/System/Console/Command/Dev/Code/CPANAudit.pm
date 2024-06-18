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

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use File::Basename qw(dirname);
use FindBin        qw($Bin);

# CPAN modules
use CPAN::Audit 20230826.001 ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::JSON',
);

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

    # We need to pass an explicit list of paths to be scanned by CPAN::Audit, otherwise it will fallback to @INC which
    #   includes our complete tree, with article storage, cache, temp files, etc. It can result in a downgraded
    #   performance if this command is run often.
    #   Please see bug#14666 for more information.
    my @PathsToScan;
    PATH:
    for my $Path (@INC) {
        next PATH if $Path && $Path eq '.';                          # Current folder, relevant for old Perls
        next PATH if $Path && $Path eq dirname($Bin);                # OTOBO home folder
        next PATH if $Path && $Path eq dirname($Bin) . '/Custom';    # Custom folder
        push @PathsToScan, $Path;
    }

    my $Result = $Audit->command( 'installed', @PathsToScan );

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my $Dump       = $JSONObject->Encode(
        Data     => $Result,
        SortKeys => 1,
        Pretty   => 1,
    );
    $Self->Print($Dump);

    my $NumAdvisories = $Result->{meta}->{total_advisories} // -1;

    return $NumAdvisories ? 1 : 0;
}

1;
