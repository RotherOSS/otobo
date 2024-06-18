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

our $Self;

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my $StartTime = time();

# HTML link quoting of HTML
my @Tests = (
    {
        Name   => 'HTMLLinkQuote() - simple',
        String => 'some Text',
        Result => 'some Text',
    },
    {
        Name   => 'HTMLLinkQuote() - simple',
        String => 'some <a name="top">Text',
        Result => 'some <a name="top">Text',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a href="http://example.com">Text</a>',
        Result => 'some <a href="http://example.com" target="_blank">Text</a>',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a
 href="http://example.com">Text</a>',
        Result => 'some <a
 href="http://example.com" target="_blank">Text</a>',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a href="http://example.com" target="somewhere">Text</a>',
        Result => 'some <a href="http://example.com" target="somewhere">Text</a>',
    },
    {
        Name   => 'HTMLLinkQuote() - extended',
        String => 'some <a href="http://example.com" target="somewhere">http://example.com</a>',
        Result => 'some <a href="http://example.com" target="somewhere">http://example.com</a>',
    },
);

for my $Test (@Tests) {
    my $HTML = $LayoutObject->HTMLLinkQuote(
        String => $Test->{String},
    );
    $Self->Is(
        $HTML || '',
        $Test->{Result},
        $Test->{Name},
    );
}

# this check is only to display how long it had take
$Self->True(
    1,
    "Layout.t - to handle the whole test file it takes " . ( time() - $StartTime ) . " seconds.",
);

$Self->DoneTesting();
