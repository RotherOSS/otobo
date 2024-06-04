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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my @ExpectedLinks = (
            q{https://otobo.io},    # powered by Rother OSS © 2019-2020
            q{https://otobo.io},    # OTOBO logo
        );

        # look for the footer links in the customer and in the public interface
        for my $Page (qw(customer.pl  public.pl)) {

            # login page for the customer.pl
            # stub page for public.pl
            $Selenium->VerifiedGet("${ScriptAlias}${Page}");

            # Get the list of links in the footer.
            # Looks like execute_script() can't return data structure, so join the links for now.
            # NOTE: The map would be nicer with JS arrow functions.
            # Use 🎋 - U+1F38B - TANABATA TREE as seperator just because why not.
            my $LinksStr = $Selenium->execute_script( <<'END_JS' );
    return $('#oooFooter a').map(
        function() {
            return $(this).attr('href');
        }
    ).toArray().join('🎋')
END_JS

            # expect exactly three links
            note($LinksStr);
            like(
                $LinksStr,
                qr{^ [^🎋]+ 🎋 [^🎋].+ $}x,
                "LinkStr for $Page"
            );

            my @Links = split /🎋/, $LinksStr;
            is( \@Links, \@ExpectedLinks, "links in the footer of $Page" );
        }
    }
);

done_testing();
