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

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name  => 'Simple URL',
        Input => 'http://www.url.com',
    },
    {
        Name  => 'URL with parameters',
        Input => 'http://www.url.com?parameter=test;parameter2=test2',
    },
    {
        Name  => 'URL with round brackets',
        Input => 'http://www.url.com/file(1)name/file(2)name',
    },
    {
        Name  => 'URL with square brackets',
        Input => 'http://www.url.com?host[0]=hostname;[1]',
    },
    {
        Name  => 'URL with curly brackets',
        Input => 'http://www.url.com?host{0}=hostname;{1}',
    },
);

for my $Test (@Tests) {

    my $Output = $LayoutObject->Ascii2Html(
        Text        => $Test->{Input},
        LinkFeature => 1,
    );

    $Self->Is(
        $Output,
        '<a href="'
            . $Test->{Input}
            . '" target="_blank" title="'
            . $Test->{Input} . '">'
            . $Test->{Input} . '</a>',
        $Test->{Name},
    );
}

$Self->DoneTesting();
