# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # First page load, no links shown.
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'PublicFrontend::FooterLinks',
            Value => {},
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl");

        $Self->Is(
            $Selenium->execute_script("return \$('#Footer ul.FooterLinks > li > a').length;"),
            0,
            "No links in footer area displayed",
        );

        # Display link for OTOBO Homepage.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PublicFrontend::FooterLinks',
            Value => {
                'https://www.otrs.com' => 'OTOBO Homepage',
            },
        );

        $Selenium->VerifiedRefresh();

        $Self->Is(
            $Selenium->execute_script("return \$('#Footer ul.FooterLinks > li > a').length;"),
            1,
            "Links in footer area displayed",
        );

        $Self->True(
            index( $Selenium->get_page_source(), 'OTOBO Homepage' ) > -1,
            'OTOBO Homepage link is shown',
        );

        # Check public interface as well.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PublicFrontend::CommonParam###Action',
            Value => 'PublicDefault',
        );

        $Selenium->VerifiedGet("${ScriptAlias}public.pl");

        $Self->Is(
            $Selenium->execute_script("return \$('#Footer ul.FooterLinks > li > a').length;"),
            1,
            "Links in footer area displayed",
        );

        $Self->True(
            index( $Selenium->get_page_source(), 'OTOBO Homepage' ) > -1,
            'OTOBO Homepage link is shown',
        );
    }
);


$Self->DoneTesting();


