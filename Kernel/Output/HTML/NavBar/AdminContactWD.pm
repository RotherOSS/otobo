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

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if frontend module is registered (otherwise return).
    my $Config     = $ConfigObject->Get('Frontend::Module')->{AdminContactWD};
    my $Navigation = $ConfigObject->Get('Frontend::Navigation')->{AdminContactWD};

    return if !IsHashRefWithData($Config);
    return if !IsHashRefWithData($Navigation);
    return if !IsArrayRefWithData( $Navigation->{'004-OTOBOCommunity'} );

    # Check if there is source field configured (otherwise return).
    my $TicketDynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'Ticket',
    );

    FIELD:
    for my $Field ( @{$TicketDynamicFieldList} ) {
        next FIELD if $Field->{FieldType} ne 'ContactWD';
        next FIELD if $Field->{ValidID} ne 1;
        return     if $Field;
    }

    # Frontend module is enabled but there is no source field configured, then remove the menu entry.
    my $NavBarName = $Config->{NavBarName};
    my $Priority   = sprintf( '%07d', $Navigation->{'004-OTOBOCommunity'}->[0]->{Prio} );

    my %Return = %{ $Param{NavBar}->{Sub} };

    # Remove AdminContactWD from the TicketMenu.
    delete $Return{$NavBarName}->{$Priority};

    return ( Sub => \%Return );
}

1;
