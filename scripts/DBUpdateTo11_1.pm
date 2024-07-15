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

package scripts::DBUpdateTo11_1;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
);

=head1 NAME

scripts::DBUpdateTo11_1 - Perform system upgrade from OTOBO 11.0 to 11.1

=head1 PUBLIC INTERFACE

=head1 Run

This method is run without parameters.

=cut

sub Run {
    print "\n Migration started ... \n";

    my $SuccessfulMigration = 1;

    my @Tasks = (
        {
            Name   => 'Increase translation content length.',
            Module => 'DBUpdateTranslationLength',
        },
    );

    TASK:
    for my $Task (@Tasks) {
        print "\tExecuting task '$Task->{Name}' ... \n";

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'scripts::DBUpdateTo11_1::' . $Task->{Module} ) ) {
            $SuccessfulMigration = 0;

            last TASK;
        }

        my $Success = $Kernel::OM->Create( 'scripts::DBUpdateTo11_1::' . $Task->{Module} )->Run;

        if ( !$Success ) {
            $SuccessfulMigration = 0;

            last TASK;
        }
    }

    return $SuccessfulMigration;
}

1;
