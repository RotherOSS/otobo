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

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet FixedTimeUnset);
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->ObjectParamAdd(
    'Kernel::Language' => {
        UserLanguage => 'de',
    },
);

my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

my @Tests = (
    {
        Name           => 'Default format',
        DateFormatLong => '%T - %D.%M.%Y',
        FixedTimeSet   => '2014-01-10 11:12:13',
        Data           => {
            Format => 'DateFormatLong',
            Year   => '2014',
            Month  => '01',
            Day    => '10',
            Hour   => '11',
            Minute => '12',
            Second => '13',
        },
        ResultGet    => '11:12:13 - 10.01.2014',
        ResultReturn => '11:12:13 - 10.01.2014',
    },
    {
        Name           => 'All tags test',
        DateFormatLong => '%A %B %T - %D.%M.%Y',
        FixedTimeSet   => '2014-01-10 11:12:13',
        Data           => {
            Format => 'DateFormatLong',
            Year   => '2014',
            Month  => '01',
            Day    => '10',
            Hour   => '11',
            Minute => '12',
            Second => '13',
        },
        ResultGet    => 'Fr Jan 11:12:13 - 10.01.2014',
        ResultReturn => ' Jan 11:12:13 - 10.01.2014',
    },
    {

        Name           => 'All tags test, HTML elements (as used in BuildDateSelection)',
        DateFormatLong => '%A %B %T - %D.%M.%Y',
        FixedTimeSet   => '2014-01-10 11:12:13',
        Data           => {
            Format => 'DateFormatLong',
            Year   => '<input value="2014"/>',
            Month  => '<input value="1"/>',
            Day    => '<input value="10"/>',
            Hour   => '<input value="11"/>',
            Minute => '<input value="12"/>',
            Second => '<input value="13"/>',
        },
        ResultGet    => 'Fr Jan 11:12:13 - 10.01.2014',
        ResultReturn =>
            '  <input value="11"/>:<input value="12"/>:<input value="13"/> - <input value="10"/>.<input value="1"/>.<input value="2014"/>',
    },
);

for my $Test (@Tests) {

    $LanguageObject->{DateFormatLong} = $Test->{DateFormatLong};

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Test->{FixedTimeSet},
        },
    );

    FixedTimeSet($DateTimeObject);

    my $Result = $LanguageObject->Time(
        %{ $Test->{Data} },
        Mode   => 'NotNumeric',
        Action => 'return',
    );
    is( $Result, $Test->{ResultReturn}, "$Test->{Name} - return" );

    $Result = $LanguageObject->Time(
        %{ $Test->{Data} },
        Action => 'get',
    );
    is( $Result, $Test->{ResultGet}, "$Test->{Name} - get" );

    FixedTimeUnset();
}

done_testing;
