# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::PostMaster::Filter;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::PostMaster::Filter

=head1 DESCRIPTION

All postmaster database filters

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $PMFilterObject = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 FilterList()

get all filter

    my %FilterList = $PMFilterObject->FilterList();

=cut

sub FilterList {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT f_name FROM postmaster_filter',
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[0];
    }

    return %Data;
}

=head2 FilterAdd()

add a filter

    $PMFilterObject->FilterAdd(
        Name           => 'some name',
        StopAfterMatch => 0,
        Match = [
            {
                Key   => 'Subject',
                Value => '^ADV: 123',
        },
            ...
        ],
        Not = [
            {
                Key   => 'Subject',
                Value => '1',
        },
            ...
        ],
        Set = [
            {
                Key   => 'X-OTOBO-Queue',
                Value => 'Some::Queue',
            },
            ...
        ],
    );

=cut

sub FilterAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name StopAfterMatch Match Set)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @Not = @{ $Param{Not} || [] };

    for my $Type (qw(Match Set)) {

        my @Data = @{ $Param{$Type} };

        for my $Index ( 0 .. ( scalar @Data ) - 1 ) {

            return if !$DBObject->Do(
                SQL =>
                    'INSERT INTO postmaster_filter (f_name, f_stop, f_type, f_key, f_value, f_not)'
                    . ' VALUES (?, ?, ?, ?, ?, ?)',
                Bind => [
                    \$Param{Name},         \$Param{StopAfterMatch}, \$Type,
                    \$Data[$Index]->{Key}, \$Data[$Index]->{Value}, \$Not[$Index]->{Value},
                ],
            );
        }
    }

    return 1;
}

=head2 FilterDelete()

delete a filter

    $PMFilterObject->FilterDelete(
        Name => '123',
    );

=cut

sub FilterDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL  => 'DELETE FROM postmaster_filter WHERE f_name = ?',
        Bind => [ \$Param{Name} ],
    );

    return 1;
}

=head2 FilterGet()

get filter properties, returns HASH ref Match and Set

    my %Data = $PMFilterObject->FilterGet(
        Name => '132',
    );

=cut

sub FilterGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL =>
            'SELECT f_type, f_key, f_value, f_name, f_stop, f_not'
            . ' FROM postmaster_filter'
            . ' WHERE f_name = ?'
            . ' ORDER BY f_key, f_value',
        Bind => [ \$Param{Name} ],
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @{ $Data{ $Row[0] } }, {
            Key   => $Row[1],
            Value => $Row[2],
        };
        $Data{Name}           = $Row[3];
        $Data{StopAfterMatch} = $Row[4];

        if ( $Row[0] eq 'Match' ) {
            push @{ $Data{Not} }, {
                Key   => $Row[1],
                Value => $Row[5],
            };
        }
    }

    return %Data;
}

1;
