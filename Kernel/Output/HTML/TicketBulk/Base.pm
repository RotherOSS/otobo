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

package Kernel::Output::HTML::TicketBulk::Base;

use strict;
use warnings;

our @ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::TicketBulk::Base - ticket bulk module base class

=head1 DESCRIPTION

Base class for ticket bulk modules.

=head1 PUBLIC INTERFACE

=head2 Display()

Generates the required HTML to display new fields in ticket bulk screen. It requires to get the value from the web request (e.g. in case of an error to re-display the field content).

    my $ModuleContent = $ModuleObject->Display(
        Errors       => $ErrorsHashRef,             # created in ticket bulk and updated by Validate()
        UserID       => $123,
    );

Returns:

    $ModuleContent = $HMLContent;                   # HTML content of the field

Override this method in your modules.

=cut

sub Display {
    my ( $Self, %Param ) = @_;

    return;
}

=head2 Validate()

Validates the values of the ticket bulk module. It requires to get the value from the web request.

    my @Result = $ModuleObject->Validate(
        UserID       => $123,
    );

Returns:

    @Result = (
        {
            ErrorKey   => 'SomeFieldName',
            ErrorValue => 'SomeErrorMessage',
        }
       # ...
    );

Override this method in your modules.

=cut

sub Validate {
    my ( $Self, %Param ) = @_;

    return ();
}

=head2 Store()

Stores the values of the ticket bulk module. It requires to get the values from the web request.

    my @Success = $ModuleObject->Store(
        TicketID => 123,
        UserID   => 123,
    );

Returns:

    $Success = 1,       # or false in case of an error;

Override this method in your modules.

=cut

sub Store {
    my ( $Self, %Param ) = @_;

    return;
}

1;
