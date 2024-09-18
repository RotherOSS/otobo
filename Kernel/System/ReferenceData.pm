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
use namespace::autoclean;
use utf8;

# core modules
use Try::Tiny qw(try);

# CPAN modules
use Locale::Country qw(all_country_names code2country country2code);

# OTOBO modules

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Log
    Kernel::System::Main
);

=for stopwords da CLDR

=head1 NAME

Kernel::System::ReferenceData - ReferenceData lib

=head1 DESCRIPTION

Contains reference data. For now, this is limited to:

=over 4

=item ISO 3166-1 country codes and English names

Currently there are 249 officially assigned codes.
Retired codes are not included.

=item Translated country names from the Unicode CLDR

The keys are two letter country codes. The codes are made up of:

=over 4

=item the 249 officially assigned ISO 3166-1 codes

=item exceptional reservations: Ascension Island, Clipperton Island, Diego Garcia, Ceuta and Melilla, Canary Islands, and Tristan da Cunha

=item user-assigned temporary country code: Kosovo

=back

=back

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ReferenceDataObject = $Kernel::OM->Get('Kernel::System::ReferenceData');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    return bless {}, $Type;
}

=head2 CountryList()

return a list of countries as a hash reference. The countries are based on ISO
3166-1 and are provided by the Perl module Locale::Code::Country, or optionally
from the SysConfig setting ReferenceData::OwnCountryList.

    my $CountryName2Name = $ReferenceDataObject->CountryList()

or

    my $CountryName2Code = $ReferenceDataObject->CountryList()
       Result => 'CODE', # optional: returns CODE => Country pairs conform ISO 3166-1 alpha-2.
    );

=cut

sub CountryList {
    my ( $Self, %Param ) = @_;

    # Determine whether the values of the result should be the codes
    my $ReturnCodes = ( $Param{Result} // '' ) eq 'CODE';

    my $OwnCountries = $Kernel::OM->Get('Kernel::Config')->Get('ReferenceData::OwnCountryList');
    if ($OwnCountries) {

        # return Code => Country pairs from SysConfig
        return $OwnCountries if $ReturnCodes;

        # return Country => Country pairs from SysConfig
        my %CountryName2Name = map { $_ => $_ } values $OwnCountries->%*;

        return \%CountryName2Name;
    }

    # get the country list from Locale::Country
    my @CountryNames = all_country_names();

    if ( !@CountryNames ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Country name list is empty!',
        );
    }

    if ($ReturnCodes) {

        # return Country => Code pairs from ISO 3166-1. The codes are the alpha-2 codes.
        my %CountryName2Code;
        for my $Country (@CountryNames) {
            $CountryName2Code{$Country} = uc country2code($Country);
        }

        return \%CountryName2Code;
    }

    # return Country => Country pairs from ISO list
    my %CountryName2Name = map { $_ => $_ } @CountryNames;

    return \%CountryName2Name;
}

=head2 CLDRCountryList()

returns a mapping of translated country names to two letter country codes.
The translated country name are prepended by their flag.
The data is provided by L<Locale::CLDR>.

    my $CountryName2Code = $ReferenceDataObject->CLDRCountryList(
        Language => 'de',
    );

=cut

sub CLDRCountryList {
    my ( $Self, %Param ) = @_;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Locale::CLDR is not required for OTOBO
    if ( $MainObject->Require('Locale::CLDR') ) {

        my $LanguageID = lc substr $Param{Language}, 0, 2;    # for now ignore the region
        my $Locale     = try {
            Locale::CLDR->new( language_id => $LanguageID );
        };

        # fall back to English
        $Locale ||= try {
            Locale::CLDR->new( language_id => 'en' );
        };
        if ($Locale) {

            # For getting the country flags.
            # See https://en.wikipedia.org/wiki/Regional_indicator_symbol
            # This indicators are in a sequence:  ord(🇩) = ord('🇦') - ord('A') + ord('D')
            my $Base             = ord('🇦') - ord('A');
            my %Letter2Indicator = map
                { $_ => chr( $Base + ord($_) ) }
                ( 'A' .. 'Z' );

            my $AllRegions = $Locale->all_regions();    # includes regions like '001' => World
            my %Code2Name;
            CODE:
            for my $Code ( grep { length $_ == 2 } keys $AllRegions->%* ) {

                # Skip the country codes that are only meant for testing and development.
                next CODE if $Code eq 'XA';    # Pseudo-Accents
                next CODE if $Code eq 'XB';    # Pseudo-Bidi

                my $Flag =
                    join '',
                    map { $Letter2Indicator{$_} }
                    split //, $Code;
                $Code2Name{$Code} = "$AllRegions->{$Code} $Flag";
            }

            return \%Code2Name;
        }
    }

    # Fall back to Locale::Country when Locale::CLDR is not available.
    # The names will be in English.
    my @CountryNames = all_country_names();

    # return Country => Code pairs from ISO 3166-1. The codes are the alpha-2 codes.
    my %CountryName2Code;
    for my $Country (@CountryNames) {
        $CountryName2Code{$Country} = uc country2code($Country);
    }

    return \%CountryName2Code;
}

=head2 CountryCode2Name()

Get a translated country name for a country code.

    my $CountryName = $ReferenceDataObject->CountryCode2Name(
        CountryCode => 'AF',
        Language    => 'de',
    );

Returns:

    $CountryName = 'Afghanistan';

=cut

sub CountryCode2Name {
    my ( $Self, %Param ) = @_;

    my $Code = $Param{CountryCode};

    return $Code unless $Code =~ m/^[A-Z]{2}$/;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    if ( $MainObject->Require('Locale::CLDR') ) {
        my $LanguageID = lc substr $Param{Language}, 0, 2;    # for now ignore the region
        my $Locale     = try {
            Locale::CLDR->new( language_id => $LanguageID );
        };

        # fall back to English
        $Locale ||= try {
            Locale::CLDR->new( language_id => 'en' );
        };

        return $Locale->region_name($Code) if $Locale;
    }

    # Fall back to Locale::Country when Locale::CLDR is not available.
    # The names will be in English
    return code2country($Code);
}

=head2 LanguageCode2Name()

Get a translated language name for a language code.

    my $LanguageName = $ReferenceDataObject->LanguageCode2Name(
        LanguageCode => 'hu',
        Language     => 'de',
    );

Returns:

    $LanuguageName = 'ungarisch';

=cut

sub LanguageCode2Name {
    my ( $Self, %Param ) = @_;

    my ($Code) = $Param{LanguageCode} =~ m/^([a-z]{2})/;

    return unless defined $Code;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # No fallback when Locale::CLDR is not available
    return unless $MainObject->Require('Locale::CLDR');

    # The target language
    my $LanguageID = lc substr $Param{Language}, 0, 2;    # for now ignore the region

    # No explicit check whether a language pack is available because object creation
    # will fail in the bad case.

    # Cache the Locale, because $LanguageID is not changed when Kernel::Language::LanguageList()
    # calls this method.
    state $LocaleCache = {};
    $LocaleCache->{$LanguageID} //= try {
        Locale::CLDR->new( language_id => $LanguageID );
    };
    my $Locale = $LocaleCache->{$LanguageID};

    # no fall back to English
    return unless $Locale;

    # consider possible aliases
    my $NormalizedCode = $Locale->language_aliases->{$Code} // $Code;

    # trick language name into accepting the code without creating a new instance of Locale::CLDR
    $Self->language_id($NormalizedCode);

    return $Locale->language_name($Self);
}

sub language_id {    ## no critic qw(OTOBO::RequireCamelCase)
    my ( $Self, $LanguageID ) = @_;

    if ( defined $LanguageID ) {
        $Self->{LanguageID} = $LanguageID;
    }

    return $Self->{LanguageID};
}

1;
