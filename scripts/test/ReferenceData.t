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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# use ReferenceData ISO list
$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => undef,
);

my $ReferenceDataObject = $Kernel::OM->Get('Kernel::System::ReferenceData');

# tests the method to make sure there are at least 100 countries
my $CountryList = $ReferenceDataObject->CountryList();

my $CountryListLength = scalar keys %$CountryList;

$Self->True(
    $CountryListLength > 100,
    "There are $CountryListLength countries registered",
);

# let's assume these countries don't go anywhere
my @CountryList = ( 'Netherlands', 'Germany', 'Switzerland', 'United States of America', 'Japan' );

for my $Country (@CountryList) {
    $Self->True(
        $$CountryList{$Country},
        "Testing existence of country ($Country)",
    );
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

$CountryList = $ReferenceDataObject->CountryList();

@CountryList = ( 'Switzerland', 'United States', 'Japan' );

for my $Country (@CountryList) {
    $Self->False(
        $$CountryList{$Country},
        "OwnCountryList: Testing non-existence of country ($Country)",
    );
}

@CountryList = ( 'France', 'Netherlands', 'Germany' );

for my $Country (@CountryList) {
    $Self->True(
        $$CountryList{$Country},
        "OwnCountryList: Testing existence of country ($Country)",
    );
}

$Self->DoneTesting();
