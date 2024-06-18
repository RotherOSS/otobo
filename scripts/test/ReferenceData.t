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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# use ReferenceData ISO list
$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => undef,
);

my $ReferenceDataObject = $Kernel::OM->Get('Kernel::System::ReferenceData');

# tests the method to make sure there are at least 100 countries
my $CountryExists = $ReferenceDataObject->CountryList;

my $CountryListLength = scalar keys $CountryExists->%*;
ok( $CountryListLength > 100, "There are $CountryListLength countries registered" );

my @CountryList = (
    'Netherlands',
    'Germany',
    'Switzerland',
    'United States of America',
    'Japan',
    'South Sudan',

    # 'Kosovo', not yet in the list
    'North Macedonia',
    'Eswatini',
    'Tonga'
);
for my $Country (@CountryList) {
    ok( $CountryExists->{$Country}, "Testing existence of country ($Country)" );
}

@CountryList = ( 'Swasiland', 'asdf' );
for my $Country (@CountryList) {
    ok( !$CountryExists->{$Country}, "Testing non-existence of country ($Country)" );
}

# set configuration to small list
$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => {
        'FR' => 'France',
        'NL' => 'Netherlands',
        'DE' => 'Germany'
    },
);

my $OwnCountryExists = $ReferenceDataObject->CountryList;

@CountryList = ( 'Switzerland', 'United States', 'Japan', 'Sealand' );
for my $Country (@CountryList) {
    ok( !$OwnCountryExists->{$Country}, "OwnCountryList: Testing non-existence of country ($Country)" );
}

@CountryList = ( 'France', 'Netherlands', 'Germany' );
for my $Country (@CountryList) {
    ok( $OwnCountryExists->{$Country}, "OwnCountryList: Testing existence of country ($Country)" );
}

done_testing();
