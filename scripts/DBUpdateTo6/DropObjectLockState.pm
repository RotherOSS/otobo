# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package scripts::DBUpdateTo6::DropObjectLockState;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::DropObjectLockState - Drops object lock state table.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if table still exists
    my $TableExists = $Self->TableExists(
        Table => 'gi_object_lock_state',
    );

    return 1 if !$TableExists;

    # get number of remaining entries
    return if !$DBObject->Prepare(
        SQL => 'SELECT COUNT(*) FROM gi_object_lock_state',
    );

    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }

    # delete table but only if table is empty
    # if there are some entries left, these must be deleted by other modules
    # so we give them a chance to be migrated from these modules
    if ($Count) {
        print
            "\n    There are still entries in your gi_object_lock_state table, therefore it will not be deleted.\n";
        return 1;
    }

    # drop table 'gi_object_lock_state'
    my $XMLString = '<TableDrop Name="gi_object_lock_state"/>';

    return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
