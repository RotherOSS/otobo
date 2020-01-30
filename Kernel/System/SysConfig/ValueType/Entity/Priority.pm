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


package Kernel::System::SysConfig::ValueType::Entity::Priority;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::ValueType::Entity);

our @ObjectDependencies = (
    'Kernel::System::Priority',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::Entity::Priority - System configuration priority entity type backend.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $EntityTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Entity::Priority');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub EntityValueList {
    my ( $Self, %Param ) = @_;

    my %Priorities = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
        Valid => 1,
    );

    my @Result;

    for my $ID ( sort keys %Priorities ) {
        push @Result, $Priorities{$ID};
    }

    return @Result;
}

sub EntityLookupFromWebRequest {
    my ( $Self, %Param ) = @_;

    my $PriorityID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'PriorityID' ) // '';

    return if !$PriorityID;

    return $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup( PriorityID => $PriorityID );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
