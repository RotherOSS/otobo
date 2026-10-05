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

package Kernel::GenericInterface::Invoker::Elasticsearch::ManagementCommon;

use v5.24;
use strict;
use warnings;

use Exporter 'import';

## nofilter(TidyAll::Plugin::OTOBO::Perl::PerlCritic)
our @EXPORT_OK = qw(RemoveESWeightedSearchBoostSuffix);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker::Elasticsearch::ManagementCommon

This is a procedural interface.

=head1 PUBLIC INTERFACE

=head1 RemoveESWeightedSearchBoostSuffix

    my $CleanedAttribute = RemoveESWeightedSearchBoostSuffix( Data => 'Title^3' );

where

    $CleanedAttribute = 'Title';

=cut

sub RemoveESWeightedSearchBoostSuffix {
    my (%Param) = @_;

    my $Data = $Param{Data};

    if ( ref $Data eq 'HASH' ) {

        my %Result;
        my @Keys = keys $Data->%*;
        for my $Key (@Keys) {

            $Result{$Key} = RemoveESWeightedSearchBoostSuffix( Data => $Data->{$Key} );
        }
        return \%Result;
    }

    elsif ( ref $Data eq 'ARRAY' ) {

        my @Result;
        my @Items = $Data->@*;
        for my $Item (@Items) {

            push @Result, RemoveESWeightedSearchBoostSuffix( Data => $Item );
        }
        return \@Result;
    }
    else {

        $Data =~ s/\^.*$//;
        return $Data;
    }

    return;
}

1;
