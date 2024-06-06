# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
use Test::LongString lcss => 0;
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # After login get an arbitrary page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # note $Selenium->get_page_source();

        # AgentTicketStatusView contains the following snippet. This snippet will be used for testing our testing functions.
        #    <div class="OverviewBox ARIARoleMain Small" role="main">
        #        <h1>Status View: Open tickets</h1>
        #
        #
        #
        #        <div class="OverviewControl" id="OverviewControl">

        # LogExecuteCommandActive is on. This means that extra test events
        # will be emitted by the the test library.
        note('a couple of test cases that are succeeding, logging activated');
        {
            $Selenium->content_contains(q{<h1>Status View: Open tickets</h1>});
            $Selenium->content_lacks(q{<h1>Status View: Closed tickets</h1>});
            $Selenium->find_element_ok(q{//div[@id='OverviewControl']});
            $Selenium->find_element_by_xpath_ok(q{//div[@id='OverviewControl']});
            $Selenium->find_no_element_ok(q{//div[@id='OverviewOutOfControl']});
            $Selenium->find_no_element_by_xpath_ok(q{//div[@id='OverviewOutOfControl']});
        }

        note('a couple of test cases that are succeeding, logging deactivated');
        {
            $Selenium->LogExecuteCommandActive(0);
            $Selenium->content_contains(q{<h1>Status View: Open tickets</h1>});
            $Selenium->content_lacks(q{<h1>Status View: Closed tickets</h1>});
            $Selenium->find_element_ok(q{//div[@id='OverviewControl']});
            $Selenium->find_element_by_xpath_ok(q{//div[@id='OverviewControl']});
            $Selenium->find_no_element_ok(q{//div[@id='OverviewOutOfControl']});
            $Selenium->find_no_element_by_xpath_ok(q{//div[@id='OverviewOutOfControl']});
            $Selenium->LogExecuteCommandActive(1);
        }

        # Now the same test cases but with the strings switched around.
        # Some of these cases should fail but not throw an exception.
        # Other cases are expected to throw an exeption.
        #
        # The expected failures are marked as TODO as they do not indicate an error.
        # LogExecuteCommandActive is on. This means that extra test events
        # will be emitted by the the test library. These extra events,
        # like the event for getPageSource(), are usually successful. The consequence
        # is that these extra events are reported as 'TODO passed'. This is fine.
        note('LogExecuteCommandActive activated, four failing TODO tests expected');
        {
            try_ok {
                my $ToDO = todo('content_contains() expected to fail');

                $Selenium->content_contains(q{<h1>Status View: Closed tickets</h1>});
            }
            'no exception for failing content_contains()';

            try_ok {
                my $ToDO = todo('content_lacks() expected to fail');

                $Selenium->content_lacks(q{<h1>Status View: Open tickets</h1>});
            }
            'no exception for failing content_lacks()';

            my $ExceptionFindElement = dies {
                my $ToDO = todo('find_element_ok() expected to fail');

                $Selenium->find_element_ok(q{//div[@id='OverviewOutOfControl']});
            };
            ok( $ExceptionFindElement, 'exception for failing find_element_ok()' );

            # This emits a 'TODO passed' event as first a successful findElements() is executed.
            my $ExceptionFindNoElement = dies {
                my $ToDO = todo('find_no_element_ok() expected to fail');

                $Selenium->find_no_element_ok(q{//div[@id='OverviewControl']});
            };
            ok( $ExceptionFindNoElement, 'exception for failing find_no_element_ok()' );
        }

        # Now the same test cases, with the strings switched around, again.
        # These cases should fail but not throw an exception.
        # This time with LogExecuteCommandActive deactivated.
        note('LogExecuteCommandActive deactivated, four failing TODO tests expected');
        $Selenium->LogExecuteCommandActive(0);
        {
            try_ok {
                my $ToDO = todo('content_contains() expected to fail');

                $Selenium->content_contains(q{<h1>Status View: Closed tickets</h1>});
            }
            'no exception for failing content_contains()';

            try_ok {
                my $ToDO = todo('content_lacks() expected to fail');

                $Selenium->content_lacks(q{<h1>Status View: Open tickets</h1>});
            }
            'no exception for failing content_lacks()';

            my $ExceptionFindElement = dies {
                my $ToDO = todo('find_element_ok() expected to fail');

                $Selenium->find_element_ok(q{//div[@id='OverviewOutOfControl']});
            };
            ok( $ExceptionFindElement, 'exception for failing find_element_ok()' );

            my $ExceptionFindNoElement = dies {
                my $ToDO = todo('find_no_element_ok() expected to fail');

                $Selenium->find_no_element_ok(q{//div[@id='OverviewControl']});
            };
            ok( $ExceptionFindNoElement, 'exception for failing find_no_element_ok()' );
        }
        $Selenium->LogExecuteCommandActive(1);
    },
);

done_testing();
