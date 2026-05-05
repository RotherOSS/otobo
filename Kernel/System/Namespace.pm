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

package Kernel::System::Namespace;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

# Inform the object manager about the hard dependencies.
# This module must be discarded when one of the hard dependencies has been discarded.
our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

Kernel::System::Namespace - general methods for namespaces

=head1 DESCRIPTION

Namespaces backend.

=head1 PUBLIC INTERFACE

=head2 new()

create a Namespace object. Do not use it directly, instead use:

    my $NamespaceObject = $Kernel::OM->Get('Kernel::System::Namespace');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 NamespacesList()

get Namespaces depending on given scope

    my @Namespaces = $NamespaceObject->NamespacesList(
        Scope => 'DynamicField',        # (optional) defaults to 'Global'
    );

Returns:

    @Namespaces = (
        'GlobalNamespace1',
        'GlobalNamespace2',
        'DynamicFieldNamespace1',
        'DynamicFieldNamespace2',
    );

=cut

sub NamespacesList {
    my ( $Self, %Param ) = @_;

    $Param{Scope} ||= 'Global';

    my @Namespaces;

    # get namespaces config
    my $NamespacesConfig = $Kernel::OM->Get('Kernel::Config')->Get('Namespaces');

    return () unless IsHashRefWithData($NamespacesConfig);

    # global is needed always
    if ( IsArrayRefWithData( $NamespacesConfig->{Global} ) ) {
        push @Namespaces, $NamespacesConfig->{Global}->@*;
    }

    # add scoped namespaces
    if ( $Param{Scope} ne 'Global' && IsArrayRefWithData( $NamespacesConfig->{ $Param{Scope} } ) ) {
        push @Namespaces, $NamespacesConfig->{ $Param{Scope} }->@*;
    }

    return @Namespaces;
}

1;
