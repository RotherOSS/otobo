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

package scripts::DBUpdateTo10_1;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Main',
);

=head1 NAME

scripts::DBUpdateTo10_1 - Perform system upgrade from OTOBO 10.0 to 10.1

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $DBUpdateTo10_1Object = $Kernel::OM->Get('scripts::DBUpdateTo10_1');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Enable auto-flushing of STDOUT.
    $| = 1;    ## no critic qw(Variables::RequireLocalizedPunctuationVars)

    print "\n Migration started ... \n";

    my $SuccessfulMigration = 1;

    my @Tasks = (
        {
            Name   => 'Add data_storage table.',
            Module => 'DBAddDataStorage',
        },
    );

    TASK:
    for my $Task (@Tasks) {
        print "\tExecuting task '$Task->{Name}' ... \n";

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'scripts::DBUpdateTo10_1::' . $Task->{Module} ) ) {
            $SuccessfulMigration = 0;
            last TASK;
        }

        my $Success = $Kernel::OM->Create( 'scripts::DBUpdateTo10_1::' . $Task->{Module} )->Run();

        if ( !$Success ) {
            $SuccessfulMigration = 0;
            last TASK;
        }
    }

    return $SuccessfulMigration;
}

1;
