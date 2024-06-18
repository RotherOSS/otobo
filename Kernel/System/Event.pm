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

package Kernel::System::Event;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
);

=head1 NAME

Kernel::System::Event - events management

=head1 DESCRIPTION

Global module to manage events.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $EventObject = $Kernel::OM->Get('Kernel::System::Event');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 EventList()

get a list of available events in the system.

    my %Events = $EventObject->EventList(
        ObjectTypes => ['Ticket', 'Article'],    # optional filter
    );

    returns
    (
        Ticket => ['TicketCreate', 'TicketPriorityUpdate', ...],
        Article => ['ArticleCreate', ...],
    )

=cut

sub EventList {
    my ( $Self, %Param ) = @_;

    my %ObjectTypes = map { $_ => 1 } @{ $Param{ObjectTypes} || [] };

    my %EventConfig = %{ $Kernel::OM->Get('Kernel::Config')->Get('Events') || {} };

    my %Result;
    for my $ObjectType ( sort keys %EventConfig ) {

        if ( !%ObjectTypes || $ObjectTypes{$ObjectType} ) {
            $Result{$ObjectType} = $EventConfig{$ObjectType};
        }
    }

    # get ticket df events
    if ( !%ObjectTypes || $ObjectTypes{'Ticket'} ) {

        # get dynamic field object
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
            Valid      => 1,
            ObjectType => ['Ticket'],
            ResultType => 'HASH',
        );

        my @DynamicFieldEvents = map {"TicketDynamicFieldUpdate_$_"} sort values %{$DynamicFields};

        push @{ $Result{'Ticket'} || [] }, @DynamicFieldEvents;
    }

    # there is currently only one article df event
    if ( !%ObjectTypes || $ObjectTypes{'Article'} ) {
        push @{ $Result{'Article'} || [] }, 'ArticleDynamicFieldUpdate';
    }

    return %Result;

}

1;
