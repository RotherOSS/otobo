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

package Kernel::System::PostMaster::Filter;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData);

our @ObjectDependencies = (
    'Kernel::System::Cache',
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

    $Self->{CacheType} = 'PostMasterFilter';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 FilterList()

get all filter

    my %FilterList = $PMFilterObject->FilterList(
        SearchTerm   => $SearchTerm,                    # optional - String, term to search by
        SearchFilter => \@SearchFilter|$SearchFilter,   # optional - Array or string, restrict search to certain match headers
        SearchValue  => \@SearchValue|$SearchValue,     # optional - Array or string, restrict search to certain set headers
    );

=cut

sub FilterList {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check search items
    if ( $Param{SearchTerm} && !IsStringWithData( $Param{SearchTerm} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Value for SearchTerm is not a scalar value!",
        );
        return;
    }

    # More specifically: Should empty array refs be allowed?
    for my $SearchArrayItem (qw(SearchFilter SearchValue)) {

        # if scalar given, convert to array - check with !ref to prevent [ HASH(0x...) ]
        if ( $Param{$SearchArrayItem} && !ref $Param{$SearchArrayItem} && ref \$Param{$SearchArrayItem} eq 'SCALAR' ) {
            $Param{$SearchArrayItem} = [ $Param{$SearchArrayItem} ];
        }

        if ( $Param{$SearchArrayItem} && ref $Param{$SearchArrayItem} ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Value for $SearchArrayItem is not an array!",
            );
            return;
        }
    }

    # check cache
    my @CacheParts = qw(PostMasterFilterList);
    for my $Key ( sort keys %Param ) {

        # TODO Think about good practice for maintaining order when one or more keys are empty
        push @CacheParts, ( $Param{$Key} || '-' );
    }

    my $CacheKey = join '::', @CacheParts;
    my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    return if !$DBObject->Prepare(
        SQL => 'SELECT f_name FROM postmaster_filter',
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[0];
    }

    # apply search restrictions
    my %Result;
    if ( $Param{SearchTerm} ) {

        # iterate over filters given from sql select
        FILTER:
        for my $FilterName ( keys %Data ) {

            # fetch every single filter
            my %Filter = $Self->FilterGet( Name => $FilterName );
            next FILTER unless %Filter;

            # filter for match and set attributes
            my %SearchRelevantData = map { $_ eq 'Match' || $_ eq 'Set' ? ( $_ => $Filter{$_} ) : () } keys %Filter;

            # iterate over filter attributes
            FILTERATTRIBUTE:
            for my $FilterAttribute ( keys %SearchRelevantData ) {
                next FILTERATTRIBUTE unless $Filter{$FilterAttribute};

                # iterate over filter attribute contents
                for my $FilterDataIndex ( 0 .. $#{ $Filter{$FilterAttribute} } ) {

                    # fetch filter data and corresponding 'Not' entry
                    my %FilterData = $Filter{$FilterAttribute}->[$FilterDataIndex]->%*;

                    # caution: 'Not' only applies to 'Match', not to 'Set'
                    my %FilterNot = $FilterAttribute eq 'Match' ? $Filter{Not}->[$FilterDataIndex]->%* : ();

                    # skip if search filter or search value does not match
                    for my $SearchRestriction (qw(SearchFilter SearchValue)) {
                        if ( $Param{$SearchRestriction}->@* ) {
                            if ( !grep { $_ eq $FilterData{Key} } $Param{$SearchRestriction}->@* ) {
                                next FILTERATTRIBUTE;
                            }
                        }
                    }

                    if ( $FilterAttribute eq 'Match' ) {

                        # check if search term matches
                        if (
                            ( !$FilterNot{Value} && $Param{SearchTerm} =~ m{$FilterData{Value}}i )
                            || ( $FilterNot{Value} && $Param{SearchTerm} !~ m{$FilterData{Value}}i )
                            )
                        {
                            $Result{$FilterName} = $FilterName;
                        }
                    }
                    elsif ( $FilterAttribute eq 'Set' ) {
                        if ( $FilterData{Value} =~ m{$Param{SearchTerm}}i ) {
                            $Result{$FilterName} = $FilterName;
                        }
                    }

                }
            }
        }
    }
    else {
        %Result = %Data;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Result,
    );

    return %Result;
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

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

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

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 FilterGet()

gets filter properties.

    my %Filter = $PMFilterObject->FilterGet(
        Name => '132',
    );

Returns a hash with the keys Match, Set, and Not.

    %Filter = (
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
