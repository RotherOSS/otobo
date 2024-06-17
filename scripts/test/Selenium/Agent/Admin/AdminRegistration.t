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

use Kernel::Language;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Fake a running daemon.
my $NodeID  = $ConfigObject->Get('NodeID') || 1;
my $Running = $Kernel::OM->Get('Kernel::System::Cache')->Set(
    Type  => 'DaemonRunning',
    Key   => $NodeID,
    Value => 1,
);

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # make sure to enable cloud services
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CloudServices::Disabled',
            Value => 0,
        );

        # Get needed variables.
        my $Daemon   = $ConfigObject->Get('Home') . '/bin/otobo.Daemon.pl';
        my $RandomID = $Helper->GetRandomID();

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminRegistration screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminRegistration");

        # Check if needed frontend module is registered in sysconfig.
        if ( !$ConfigObject->Get('Frontend::Module')->{AdminRegistration} ) {
            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    'Module Kernel::Modules::AdminRegistration not registered in Kernel/Config.pm!'
                ) > 0,
                'Module AdminRegistration is not registered in sysconfig, skipping test...'
            );

            return 1;
        }

        # Check breadcrumb on Overview screen.
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq(1)').text().trim()"),
            'System Registration Management',
            "Breadcrumb text 'System Registration Management' is found on screen"
        );

        # Create a fake cloud service response with public feed data.
        my $CloudServiceResponse = {
            Success      => '1',
            ErrorMessage => '',
            Results      => {
                SystemRegistration => [
                    {
                        Success      => '0',
                        ErrorMessage => 'Wrong OTOBOID or Password',
                        Operation    => 'TokenGet',
                        Data         => {
                            Auth   => 'invalid',
                            Reason => 'Wrong OTOBOID or Password',
                        }
                    },
                ],
            },
        };
        my $CloudServiceResponseJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
            Data   => $CloudServiceResponse,
            Pretty => 1,
        );

        # Override Request() from WebUserAgent to always return some test data without making any
        #   actual web service calls. This should prevent instability in case cloud services are
        #   unavailable at the exact moment of this test run.
        my $CustomCode = <<"EOS";
sub Kernel::Config::Files::ZZZZUnitTestAdminRegistration${RandomID}::Load {} # no-op, avoid warning logs
use Kernel::System::WebUserAgent;
package Kernel::System::WebUserAgent;
use strict;
use warnings;
## nofilter(TidyAll::Plugin::OTOBO::Perl::TestSubs)
{
    no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
    sub Request {
        my \$JSONString = q^
$CloudServiceResponseJSON
^;

        return (
            Content => \\\$JSONString,
            Status  => '200 OK',
        );
    }
}
1;
EOS
        $Helper->CustomCodeActivate(
            Code       => $CustomCode,
            Identifier => 'AdminRegistration' . $RandomID,
        );

        my @Tests = (
            {
                Name  => 'Empty email address field',
                Value => '',
            },
            {
                Name  => 'Wrong email address type',
                Value => $RandomID,
            },
            {
                Name  => 'Wrong email address',
                Value => $RandomID . '@test.com',
            }
        );

        for my $Test (@Tests) {

            $Selenium->find_element( "#OTOBOID",  'css' )->clear();
            $Selenium->find_element( "#OTOBOID",  'css' )->send_keys( $Test->{Value} );
            $Selenium->find_element( "#Password", 'css' )->clear();
            $Selenium->find_element( "#Password", 'css' )->send_keys( $Test->{Value} );
            $Selenium->find_element( "#Submit",   'css' )->click();

            if ( $Test->{Name} ne 'Wrong email address' ) {
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $("#OTOBOID.Error").length',
                );
                $Self->True(
                    $Selenium->execute_script("return \$('#OTOBOID.Error').length"),
                    "$Test->{Name} - class Error found",
                );
            }
            else {
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("div.MessageBox.Error p:contains(\'Wrong OTOBOID or Password\')").length',
                );
                $Self->True(
                    $Selenium->execute_script(
                        'return $("div.MessageBox.Error p:contains(\'Wrong OTOBOID or Password\')").length',
                    ),
                    "$Test->{Name} - error message is correct",
                );
            }
        }

        # Create field ID and modal dialog title pairs for different linked texts.
        my %Dialogs = (
            RegistrationMoreInfo       => 'System Registration',
            RegistrationDataProtection => 'Data Protection',
        );

        for my $Dialog ( sort keys %Dialogs ) {

            # Click on the linked text.
            $Selenium->find_element( "#$Dialog", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length' );

            # Check up if corresponding modal dialog exists on the page.
            $Self->Is(
                $Selenium->execute_script("return \$('.Dialog.Modal h1:eq(0)').text()"),
                $Dialogs{$Dialog},
                "Modal dialog with title '$Dialogs{$Dialog}' - found",
            );

            # Close the modal dialog.
            $Selenium->find_element( ".Dialog.Modal .fa.fa-times", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );
        }
    }
);

$Kernel::OM->Get('Kernel::System::Cache')->Delete(
    Type => 'DaemonRunning',
    Key  => $NodeID,
);

$Self->DoneTesting();
