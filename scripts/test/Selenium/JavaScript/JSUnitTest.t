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

use Time::HiRes qw(sleep);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $WebPath = $ConfigObject->Get('Frontend::WebPath');

        my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/httpd/htdocs/js/test',
            Filter    => "*.html",
        );

        for my $File (@Files) {

            # Remove path
            $File =~ s{.*/}{}smx;

            $Selenium->get("${WebPath}js/test/$File");

            my $JSModuleName = $File;
            $JSModuleName =~ s{\.UnitTest\.html}{}xms;

            # Wait for the tests to complete.
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('span.module-name:contains($JSModuleName)').length;"
            );
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $("#qunit-testresult.complete").length;'
            );

            my $Completed = $Selenium->execute_script(
                "return \$('#qunit-testresult.complete').length"
            );

            $Self->True(
                $Completed,
                "$File - JavaScript unit tests completed"
            );

            $Selenium->find_element( "#qunit-testresult span.failed", 'css' );
            $Selenium->find_element( "#qunit-testresult span.passed", 'css' );
            $Selenium->find_element( "#qunit-testresult span.total",  'css' );

            my ( $Passed, $Failed, $Total );
            $Passed = $Selenium->execute_script(
                "return \$('#qunit-testresult span.passed').text()"
            );
            $Failed = $Selenium->execute_script(
                "return \$('#qunit-testresult span.failed').text()"
            );
            $Total = $Selenium->execute_script(
                "return \$('#qunit-testresult span.total').text()"
            );

            $Self->True( $Passed, "$File - found passed tests" );
            $Self->Is( $Passed, $Total, "$File - total number of tests" );
            $Self->False( $Failed, "$File - failed tests" );

            # Generate screenshot on failure
            if ( $Failed || !$Passed || $Passed != $Total ) {
                $Selenium->HandleError("Failed JS unit tests found.");
            }
        }

    }
);


$Self->DoneTesting();


