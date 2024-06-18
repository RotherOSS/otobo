# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::Output::HTML::NavBar::AdminContactWD;

use strict;
use warnings;

# core modules

# CPAN modules
use List::Util qw(any);

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    return bless {}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if frontend module is registered (otherwise return).
    my $Config     = $ConfigObject->Get('Frontend::Module')->{AdminContactWD};
    my $Navigation = $ConfigObject->Get('Frontend::Navigation')->{AdminContactWD};

    return unless IsHashRefWithData($Config);
    return unless IsHashRefWithData($Navigation);
    return unless IsArrayRefWithData( $Navigation->{'002-DynamicField'} );

    # Check if there is source field configured (otherwise return).
    # DynamicFieldListGet() returns only valid dynamic fields.
    my $TicketDynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'Ticket',
    );

    # nothing to do when there is a valid dynamic field of type ContactWD
    return if any { $_->{FieldType} eq 'ContactWD' } $TicketDynamicFieldList->@*;

    # Frontend module is enabled but there is no ContactWD field configured, then remove the menu entry.
    my $NavBarName = $Config->{NavBarName};    # usually 'Ticket'
    my $Priority   = sprintf '%07d', $Navigation->{'002-DynamicField'}->[0]->{Prio};
    my %Return     = $Param{NavBar}->{Sub}->%*;

    # Remove AdminContactWD from the TicketMenu.
    delete $Return{$NavBarName}->{$Priority};

    return Sub => \%Return;
}

1;
