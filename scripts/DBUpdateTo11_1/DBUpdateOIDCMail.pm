# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package scripts::DBUpdateTo11_1::DBUpdateOIDCMail;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use List::Util qw(any);

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdateTo11_1::DBUpdateOIDCMail - Update mail_account table for OIDC

=cut

use parent qw(scripts::DBUpdateTo11_1::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    # check if this needs to be executed
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    $DBObject->Prepare(
        SQL   => "SELECT * FROM mail_account",
        Limit => 10
    );

    my @Names = $DBObject->GetColumnNames();
    if ( any { $_ eq 'functional_account_id' } @Names ) {
        return 1;
    }

    # one statement per column, so that an already existing column does not abort the update
    my @XMLStrings;

    # new column
    push @XMLStrings, <<'END_XML';
        <TableAlter Name="mail_account">
            <ColumnAdd Name="auth" Type="VARCHAR" Size="20" Required="true" Default="Basic" />
        </TableAlter>
END_XML

    push @XMLStrings, <<'END_XML';
        <TableAlter Name="mail_account">
            <ColumnAdd Name="functional_account_id" Type="INTEGER" Required="false" />
        </TableAlter>
END_XML

    return unless $Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;
