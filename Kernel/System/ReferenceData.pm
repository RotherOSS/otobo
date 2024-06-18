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

package Kernel::System::ReferenceData;

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules
use Locale::Country qw(all_country_names);

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ReferenceData - ReferenceData lib

=head1 DESCRIPTION

Contains reference data. For now, this is limited to just a list of ISO country
codes.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ReferenceDataObject = $Kernel::OM->Get('Kernel::System::ReferenceData');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 CountryList()

return a list of countries as a hash reference. The countries are based on ISO
3166-2 and are provided by the Perl module Locale::Code::Country, or optionally
from the SysConfig setting ReferenceData::OwnCountryList.

    my $CountryList = $ReferenceDataObject->CountryList(
       Result => 'CODE', # optional: returns CODE => Country pairs conform ISO 3166-2.
    );

=cut

sub CountryList {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Result} || $Param{Result} ne 'CODE' ) {
        $Param{Result} = undef;
    }

    my $Countries = $Kernel::OM->Get('Kernel::Config')->Get('ReferenceData::OwnCountryList');

    if ( $Param{Result} && $Countries ) {

        # return Code => Country pairs from SysConfig
        return $Countries;
    }
    elsif ($Countries) {

        # return Country => Country pairs from SysConfig
        my %CountryJustNames = map { $_ => $_ } values %$Countries;

        return \%CountryJustNames;
    }

    # get the country list from Locale::Country
    my @CountryNames = all_country_names();

    if ( !@CountryNames ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Country name list is empty!',
        );
    }

    if ( $Param{Result} ) {

        # return Code => Country pairs from ISO list
        my %Countries;
        for my $Country (@CountryNames) {
            $Countries{$Country} = country2code( $Country, 1 );
        }

        return \%Countries;
    }

    # return Country => Country pairs from ISO list
    my %CountryNames = map { $_ => $_ } @CountryNames;

    return \%CountryNames;
}

1;
