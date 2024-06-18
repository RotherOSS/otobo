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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM, $Self is not used here
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

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

            subtest "running $File" => sub {
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

                ok( $Completed, "$File - JavaScript unit tests completed" );

                $Selenium->LogExecuteCommandActive(0);
                $Selenium->find_element_by_css_ok("#qunit-testresult span.failed");
                $Selenium->find_element_by_css_ok("#qunit-testresult span.passed");
                $Selenium->find_element_by_css_ok("#qunit-testresult span.total");
                $Selenium->LogExecuteCommandActive(1);

                my $Passed = $Selenium->execute_script(
                    "return \$('#qunit-testresult span.passed').text()"
                );
                my $Failed = $Selenium->execute_script(
                    "return \$('#qunit-testresult span.failed').text()"
                );
                my $Total = $Selenium->execute_script(
                    "return \$('#qunit-testresult span.total').text()"
                );

                ok( $Passed, "$File - found passed tests" );
                is( $Passed, $Total, "$File - total number of tests" );
                ok( !$Failed, "$File - failed tests" );

                # Generate screenshot on failure
                if ( $Failed || !$Passed || $Passed != $Total ) {
                    $Selenium->HandleError("Failed JS unit tests found.");
                }
            };
        }
    }
);

done_testing;
