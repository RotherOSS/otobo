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

my @LinkEncodeTests = (

    {
        Source => '%',
        Target => '%25',
    },
    {
        Source => '&',
        Target => '%26',
    },
    {
        Source => '=',
        Target => '%3D',
    },
    {
        Source => '!',
        Target => '%21',
    },
    {
        Source => '"',
        Target => '%22',
    },
    {
        Source => '#',
        Target => '%23',
    },
    {
        Source => '$',
        Target => '%24',
    },
    {
        Source => '\'',
        Target => '%27',
    },
    {
        Source => ',',
        Target => '%2C',
    },
    {
        Source => '+',
        Target => '%2B',
    },
    {
        Source => '?',
        Target => '%3F',
    },
    {
        Source => '|',
        Target => '%7C',
    },
    {
        Source => '/',
        Target => '%2F',
    },

    # According to the URL encoding RFC, the path segment of an URL must use %20 for space,
    # while in the query string + is used normally. However, IIS does not understand + in the
    # path segment, but understands %20 in the query string, like all others do as well.
    # Therefore we use %20.
    {
        Source => ' ',
        Target => '%20',
    },
    {
        Source => ':',
        Target => '%3A',
    },
    {
        Source => ';',
        Target => '%3B',
    },
    {
        Source => '@',
        Target => '%40',
    },

    # LinkEncode() on reserved characters
    {
        Source => '!*\'();:@&=+$,/?#[]',
        Target => '%21%2A%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%23%5B%5D',
    },

    # LinkEncode() on common characters
    {
        Source => '<>"{}|\`^% ',
        Target => '%3C%3E%22%7B%7D%7C%5C%60%5E%25%20',
    },

    # LinkEncode() on normal characters
    {
        Source => 'normaltext123',
        Target => 'normaltext123',
    },
);

for my $LinkEncodeTest (@LinkEncodeTests) {
    $Self->Is(
        $LayoutObject->LinkEncode( $LinkEncodeTest->{Source} ),
        $LinkEncodeTest->{Target},
        "LinkEncode from '$LinkEncodeTest->{Source}' to '$LinkEncodeTest->{Target}'",
    );
}

$Self->DoneTesting();
