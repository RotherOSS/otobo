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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# use ReferenceData ISO list
$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => undef,
);

my $ReferenceDataObject = $Kernel::OM->Get('Kernel::System::ReferenceData');
isa_ok( $ReferenceDataObject, 'Kernel::System::ReferenceData' );

# tests the method CountryList()
my $CountryName2Name1 = $ReferenceDataObject->CountryList;
ref_ok( $CountryName2Name1, 'HASH', 'Got hashref from CountryList()' );

my %LocaleCodesCountryList = (
    "Afghanistan"                                          => "Afghanistan",
    "Aland Islands"                                        => "Aland Islands",
    "Albania"                                              => "Albania",
    "Algeria"                                              => "Algeria",
    "American Samoa"                                       => "American Samoa",
    "Andorra"                                              => "Andorra",
    "Angola"                                               => "Angola",
    "Anguilla"                                             => "Anguilla",
    "Antarctica"                                           => "Antarctica",
    "Antigua and Barbuda"                                  => "Antigua and Barbuda",
    "Argentina"                                            => "Argentina",
    "Armenia"                                              => "Armenia",
    "Aruba"                                                => "Aruba",
    "Australia"                                            => "Australia",
    "Austria"                                              => "Austria",
    "Azerbaijan"                                           => "Azerbaijan",
    "Bahamas"                                              => "Bahamas",
    "Bahrain"                                              => "Bahrain",
    "Bangladesh"                                           => "Bangladesh",
    "Barbados"                                             => "Barbados",
    "Belarus"                                              => "Belarus",
    "Belgium"                                              => "Belgium",
    "Belize"                                               => "Belize",
    "Benin"                                                => "Benin",
    "Bermuda"                                              => "Bermuda",
    "Bhutan"                                               => "Bhutan",
    "Bolivia (Plurinational State of)"                     => "Bolivia (Plurinational State of)",
    "Bonaire, Sint Eustatius and Saba"                     => "Bonaire, Sint Eustatius and Saba",
    "Bosnia and Herzegovina"                               => "Bosnia and Herzegovina",
    "Botswana"                                             => "Botswana",
    "Bouvet Island"                                        => "Bouvet Island",
    "Brazil"                                               => "Brazil",
    "British Indian Ocean Territory"                       => "British Indian Ocean Territory",
    "Brunei Darussalam"                                    => "Brunei Darussalam",
    "Bulgaria"                                             => "Bulgaria",
    "Burkina Faso"                                         => "Burkina Faso",
    "Burundi"                                              => "Burundi",
    "Cabo Verde"                                           => "Cabo Verde",
    "Cambodia"                                             => "Cambodia",
    "Cameroon"                                             => "Cameroon",
    "Canada"                                               => "Canada",
    "Cayman Islands"                                       => "Cayman Islands",
    "Central African Republic"                             => "Central African Republic",
    "Chad"                                                 => "Chad",
    "Chile"                                                => "Chile",
    "China"                                                => "China",
    "Christmas Island"                                     => "Christmas Island",
    "Cocos (Keeling) Islands"                              => "Cocos (Keeling) Islands",
    "Colombia"                                             => "Colombia",
    "Comoros"                                              => "Comoros",
    "Congo"                                                => "Congo",
    "Congo (The Democratic Republic of the)"               => "Congo (The Democratic Republic of the)",
    "Cook Islands"                                         => "Cook Islands",
    "Costa Rica"                                           => "Costa Rica",
    "Cote d'Ivoire"                                        => "Cote d'Ivoire",
    "Croatia"                                              => "Croatia",
    "Cuba"                                                 => "Cuba",
    "Curacao"                                              => "Curacao",
    "Cyprus"                                               => "Cyprus",
    "Czechia"                                              => "Czechia",
    "Denmark"                                              => "Denmark",
    "Djibouti"                                             => "Djibouti",
    "Dominica"                                             => "Dominica",
    "Dominican Republic"                                   => "Dominican Republic",
    "Ecuador"                                              => "Ecuador",
    "Egypt"                                                => "Egypt",
    "El Salvador"                                          => "El Salvador",
    "Equatorial Guinea"                                    => "Equatorial Guinea",
    "Eritrea"                                              => "Eritrea",
    "Estonia"                                              => "Estonia",
    "Eswatini"                                             => "Eswatini",
    "Ethiopia"                                             => "Ethiopia",
    "Falkland Islands (The) [Malvinas]"                    => "Falkland Islands (The) [Malvinas]",
    "Faroe Islands"                                        => "Faroe Islands",
    "Fiji"                                                 => "Fiji",
    "Finland"                                              => "Finland",
    "France"                                               => "France",
    "French Guiana"                                        => "French Guiana",
    "French Polynesia"                                     => "French Polynesia",
    "French Southern Territories"                          => "French Southern Territories",
    "Gabon"                                                => "Gabon",
    "Gambia"                                               => "Gambia",
    "Georgia"                                              => "Georgia",
    "Germany"                                              => "Germany",
    "Ghana"                                                => "Ghana",
    "Gibraltar"                                            => "Gibraltar",
    "Greece"                                               => "Greece",
    "Greenland"                                            => "Greenland",
    "Grenada"                                              => "Grenada",
    "Guadeloupe"                                           => "Guadeloupe",
    "Guam"                                                 => "Guam",
    "Guatemala"                                            => "Guatemala",
    "Guernsey"                                             => "Guernsey",
    "Guinea"                                               => "Guinea",
    "Guinea-Bissau"                                        => "Guinea-Bissau",
    "Guyana"                                               => "Guyana",
    "Haiti"                                                => "Haiti",
    "Heard Island and McDonald Islands"                    => "Heard Island and McDonald Islands",
    "Holy See"                                             => "Holy See",
    "Honduras"                                             => "Honduras",
    "Hong Kong"                                            => "Hong Kong",
    "Hungary"                                              => "Hungary",
    "Iceland"                                              => "Iceland",
    "India"                                                => "India",
    "Indonesia"                                            => "Indonesia",
    "Iran (Islamic Republic of)"                           => "Iran (Islamic Republic of)",
    "Iraq"                                                 => "Iraq",
    "Ireland"                                              => "Ireland",
    "Isle of Man"                                          => "Isle of Man",
    "Israel"                                               => "Israel",
    "Italy"                                                => "Italy",
    "Jamaica"                                              => "Jamaica",
    "Japan"                                                => "Japan",
    "Jersey"                                               => "Jersey",
    "Jordan"                                               => "Jordan",
    "Kazakhstan"                                           => "Kazakhstan",
    "Kenya"                                                => "Kenya",
    "Kiribati"                                             => "Kiribati",
    "Korea, The Democratic People's Republic of"           => "Korea, The Democratic People's Republic of",
    "Korea, The Republic of"                               => "Korea, The Republic of",
    "Kuwait"                                               => "Kuwait",
    "Kyrgyzstan"                                           => "Kyrgyzstan",
    "Lao People's Democratic Republic"                     => "Lao People's Democratic Republic",
    "Latvia"                                               => "Latvia",
    "Lebanon"                                              => "Lebanon",
    "Lesotho"                                              => "Lesotho",
    "Liberia"                                              => "Liberia",
    "Libya"                                                => "Libya",
    "Liechtenstein"                                        => "Liechtenstein",
    "Lithuania"                                            => "Lithuania",
    "Luxembourg"                                           => "Luxembourg",
    "Macao"                                                => "Macao",
    "Madagascar"                                           => "Madagascar",
    "Malawi"                                               => "Malawi",
    "Malaysia"                                             => "Malaysia",
    "Maldives"                                             => "Maldives",
    "Mali"                                                 => "Mali",
    "Malta"                                                => "Malta",
    "Marshall Islands"                                     => "Marshall Islands",
    "Martinique"                                           => "Martinique",
    "Mauritania"                                           => "Mauritania",
    "Mauritius"                                            => "Mauritius",
    "Mayotte"                                              => "Mayotte",
    "Mexico"                                               => "Mexico",
    "Micronesia (Federated States of)"                     => "Micronesia (Federated States of)",
    "Moldova, The Republic of"                             => "Moldova, The Republic of",
    "Monaco"                                               => "Monaco",
    "Mongolia"                                             => "Mongolia",
    "Montenegro"                                           => "Montenegro",
    "Montserrat"                                           => "Montserrat",
    "Morocco"                                              => "Morocco",
    "Mozambique"                                           => "Mozambique",
    "Myanmar"                                              => "Myanmar",
    "Namibia"                                              => "Namibia",
    "Nauru"                                                => "Nauru",
    "Nepal"                                                => "Nepal",
    "Netherlands (Kingdom of the)"                         => "Netherlands (Kingdom of the)",
    "New Caledonia"                                        => "New Caledonia",
    "New Zealand"                                          => "New Zealand",
    "Nicaragua"                                            => "Nicaragua",
    "Niger"                                                => "Niger",
    "Nigeria"                                              => "Nigeria",
    "Niue"                                                 => "Niue",
    "Norfolk Island"                                       => "Norfolk Island",
    "North Macedonia"                                      => "North Macedonia",
    "Northern Mariana Islands"                             => "Northern Mariana Islands",
    "Norway"                                               => "Norway",
    "Oman"                                                 => "Oman",
    "Pakistan"                                             => "Pakistan",
    "Palau"                                                => "Palau",
    "Palestine, State of"                                  => "Palestine, State of",
    "Panama"                                               => "Panama",
    "Papua New Guinea"                                     => "Papua New Guinea",
    "Paraguay"                                             => "Paraguay",
    "Peru"                                                 => "Peru",
    "Philippines"                                          => "Philippines",
    "Pitcairn"                                             => "Pitcairn",
    "Poland"                                               => "Poland",
    "Portugal"                                             => "Portugal",
    "Puerto Rico"                                          => "Puerto Rico",
    "Qatar"                                                => "Qatar",
    "Reunion"                                              => "Reunion",
    "Romania"                                              => "Romania",
    "Russian Federation"                                   => "Russian Federation",
    "Rwanda"                                               => "Rwanda",
    "Saint Barthelemy"                                     => "Saint Barthelemy",
    "Saint Helena, Ascension and Tristan da Cunha"         => "Saint Helena, Ascension and Tristan da Cunha",
    "Saint Kitts and Nevis"                                => "Saint Kitts and Nevis",
    "Saint Lucia"                                          => "Saint Lucia",
    "Saint Martin (French part)"                           => "Saint Martin (French part)",
    "Saint Pierre and Miquelon"                            => "Saint Pierre and Miquelon",
    "Saint Vincent and the Grenadines"                     => "Saint Vincent and the Grenadines",
    "Samoa"                                                => "Samoa",
    "San Marino"                                           => "San Marino",
    "Sao Tome and Principe"                                => "Sao Tome and Principe",
    "Saudi Arabia"                                         => "Saudi Arabia",
    "Senegal"                                              => "Senegal",
    "Serbia"                                               => "Serbia",
    "Seychelles"                                           => "Seychelles",
    "Sierra Leone"                                         => "Sierra Leone",
    "Singapore"                                            => "Singapore",
    "Sint Maarten (Dutch part)"                            => "Sint Maarten (Dutch part)",
    "Slovakia"                                             => "Slovakia",
    "Slovenia"                                             => "Slovenia",
    "Solomon Islands"                                      => "Solomon Islands",
    "Somalia"                                              => "Somalia",
    "South Africa"                                         => "South Africa",
    "South Georgia and the South Sandwich Islands"         => "South Georgia and the South Sandwich Islands",
    "South Sudan"                                          => "South Sudan",
    "Spain"                                                => "Spain",
    "Sri Lanka"                                            => "Sri Lanka",
    "Sudan"                                                => "Sudan",
    "Suriname"                                             => "Suriname",
    "Svalbard and Jan Mayen"                               => "Svalbard and Jan Mayen",
    "Sweden"                                               => "Sweden",
    "Switzerland"                                          => "Switzerland",
    "Syrian Arab Republic"                                 => "Syrian Arab Republic",
    "Taiwan (Province of China)"                           => "Taiwan (Province of China)",
    "Tajikistan"                                           => "Tajikistan",
    "Tanzania, the United Republic of"                     => "Tanzania, the United Republic of",
    "Thailand"                                             => "Thailand",
    "Timor-Leste"                                          => "Timor-Leste",
    "Togo"                                                 => "Togo",
    "Tokelau"                                              => "Tokelau",
    "Tonga"                                                => "Tonga",
    "Trinidad and Tobago"                                  => "Trinidad and Tobago",
    "Tunisia"                                              => "Tunisia",
    "Turkiye"                                              => "Turkiye",
    "Turkmenistan"                                         => "Turkmenistan",
    "Turks and Caicos Islands"                             => "Turks and Caicos Islands",
    "Tuvalu"                                               => "Tuvalu",
    "Uganda"                                               => "Uganda",
    "Ukraine"                                              => "Ukraine",
    "United Arab Emirates"                                 => "United Arab Emirates",
    "United Kingdom of Great Britain and Northern Ireland" => "United Kingdom of Great Britain and Northern Ireland",
    "United States Minor Outlying Islands"                 => "United States Minor Outlying Islands",
    "United States of America"                             => "United States of America",
    "Uruguay"                                              => "Uruguay",
    "Uzbekistan"                                           => "Uzbekistan",
    "Vanuatu"                                              => "Vanuatu",
    "Venezuela (Bolivarian Republic of)"                   => "Venezuela (Bolivarian Republic of)",
    "Viet Nam"                                             => "Viet Nam",
    "Virgin Islands (British)"                             => "Virgin Islands (British)",
    "Virgin Islands (U.S.)"                                => "Virgin Islands (U.S.)",
    "Wallis and Futuna"                                    => "Wallis and Futuna",
    "Western Sahara"                                       => "Western Sahara",
    "Yemen"                                                => "Yemen",
    "Zambia"                                               => "Zambia",
    "Zimbabwe"                                             => "Zimbabwe",
);
ref_ok( $CountryName2Name1, 'HASH' );
is(
    scalar keys $CountryName2Name1->%*,
    249,
    'number of officially assigned country codes in ISO 3166-1 alpha-2'
);
is(
    $CountryName2Name1,
    \%LocaleCodesCountryList,
    'countries without OwnCountryList sysconfig setting'
);

my $CountryName2Code1 = $ReferenceDataObject->CountryList(
    Result => 'CODE',
);
ref_ok( $CountryName2Code1, 'HASH', q{got hashref from CountryList( Result => 'CODE' )} );
is( $CountryName2Code1->{Afghanistan}, 'AF', 'mapping Afghanistan to AF' );

# set configuration to small list
my %OwnCode2Name = (
    'FR' => 'France',
    'NL' => 'Netherlands',
    'DE' => 'Germany'
);

$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => \%OwnCode2Name,
);

# The parameter Result => 'Code' was not passed,
# thus only the values are returned.
my $CountryName2Name2 = $ReferenceDataObject->CountryList;
is(
    $CountryName2Name2,
    { map { $_ => $_ } values %OwnCode2Name },
    'countries with OwnCountryList system setting'
);

my $CountryName2Code2 = $ReferenceDataObject->CountryList(
    Result => 'CODE',
);
is(
    $CountryName2Code2,
    \%OwnCode2Name,
    'country name to code with OwnCountryList system setting'
);

SKIP:
{
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    skip 'Locale::CLDR not available' unless $MainObject->Require('Locale::CLDR');

    my $CLDRCountryCode2Name = $ReferenceDataObject->CLDRCountryList(
        Language => 'de',
    );

    my %SampleCountryCode2Name = (
        AT => 'Österreich 🇦🇹',              # mit Umlaut
        BQ => 'Karibische Niederlande 🇧🇶',
        BV => 'Bouvetinsel 🇧🇻',
        CI => q{Côte d’Ivoire 🇨🇮},        # with U+02019 - RIGHT SINGLE QUOTATION MARK^
        DE => 'Deutschland 🇩🇪',
        MK => 'Nordmazedonien 🇲🇰',           # changed in CLDR 40
        SZ => 'Eswatini 🇸🇿',                 # changed in CLDR 40
    );

    ref_ok( $CLDRCountryCode2Name, 'HASH' );
    like(
        $CLDRCountryCode2Name,
        \%SampleCountryCode2Name,
        'German CLDR country list',
    );

    subtest 'default language names in hungarian' => sub {
        my %DefaultUsedLanguages = ( $ConfigObject->Get('DefaultUsedLanguages') || {} )->%*;
        my $NumLanguages         = keys %DefaultUsedLanguages;
        ok( $NumLanguages >= 50, 'got language list from SysConfig' );

        # Testing with Hungarian, region is ignored
        my %LanguageNameInHungarian = (
            ar_SA   => "arab",
            bg      => "bolg\xE1r",
            ca      => "katal\xE1n",
            cs      => "cseh",
            da      => "d\xE1n",
            de      => "n\xE9met",
            el      => "g\xF6r\xF6g",
            en      => "angol",
            en_CA   => "angol",
            en_GB   => "angol",
            es      => "spanyol",
            es_CO   => "spanyol",
            es_MX   => "spanyol",
            et      => "\xE9szt",
            fa      => "perzsa",
            fi      => "finn",
            fr      => "francia",
            fr_CA   => "francia",
            gl      => "gallego",
            he      => "h\xE9ber",
            hi      => "hindi",
            hr      => "horv\xE1t",
            hu      => "magyar",
            id      => "indon\xE9z",
            it      => "olasz",
            ja      => "jap\xE1n",
            ko      => "koreai",
            lt      => "litv\xE1n",
            lv      => "lett",
            mk      => "maced\xF3n",
            ms      => "mal\xE1j",
            nb_NO   => "norv\xE9g (bokm\xE5l)",
            nl      => "holland",
            pl      => "lengyel",
            pt      => "portug\xE1l",
            pt_BR   => "portug\xE1l",
            ro      => "rom\xE1n",
            ru      => "orosz",
            sk_SK   => "szlov\xE1k",
            sl      => "szlov\xE9n",
            sr_Cyrl => "szerb",
            sr_Latn => "szerb",
            sv      => "sv\xE9d",
            sw      => "szuah\xE9li",
            th_TH   => "thai",
            tr      => "t\xF6r\xF6k",
            uk      => "ukr\xE1n",
            vi_VN   => "vietn\xE1mi",
            zh_CN   => "k\xEDnai",
            zh_TW   => "k\xEDnai",
        );

        for my $LanguageCode ( sort keys %DefaultUsedLanguages ) {
            my $LanguageName = $ReferenceDataObject->LanguageCode2Name(
                LanguageCode => $LanguageCode,
                Language     => 'hu',
            );
            is(
                $LanguageName,
                $LanguageNameInHungarian{$LanguageCode},
                "$LanguageCode in hungarian"
            );
        }
    }
}

done_testing;
