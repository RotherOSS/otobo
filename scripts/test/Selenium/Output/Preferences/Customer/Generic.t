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

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to customer preferences
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # create test params
        my @Tests = (
            {
                Name  => 'Ticket Overview',
                ID    => 'UserRefreshTimeUpdate',
                Value => '5',
            },
            {
                Name  => 'Number of displayed tickets',
                ID    => 'UserShowTicketsUpdate',
                Value => '30',
            },
        );

        my $UpdateMessage = "Preferences updated successfully!";

        # update generic preferences
        for my $Test (@Tests) {

            $Selenium->InputFieldValueSet(
                Element => "#$Test->{ID}",
                Value   => $Test->{Value},
            );
            $Selenium->find_element( "#$Test->{ID}", 'css' )->VerifiedClick();

            $Self->True(
                index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
                "Customer preference $Test->{Name} - updated"
            );
        }
    }
);

$Self->DoneTesting();
