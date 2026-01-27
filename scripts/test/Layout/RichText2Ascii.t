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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name   => 'Plain',
        String => 'some plain text',
        Result => 'some plain text',
    },
    {
        Name   => 'Umlauts',
        String => '&Auml;nderung',
        Result => 'Änderung',
    },
    {
        Name   => 'α - U+003B1 - GREEK SMALL LETTER ALPHA',
        String => '&alpha;',
        Result => 'α',
    },
);
for my $Test (@Tests) {
    my $Plain = $LayoutObject->RichText2Ascii(
        String => $Test->{String},
    );
    is( $Plain, $Test->{Result}, $Test->{Name} );
}

done_testing;
