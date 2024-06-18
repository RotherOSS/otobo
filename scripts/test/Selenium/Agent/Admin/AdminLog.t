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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;
use Kernel::Config;

# the question whether there is a S3 backend must the resolved early
{
    my $ClearConfigObject = Kernel::Config->new( Level => 'Clear' );
    my $S3Active          = $ClearConfigObject->Get('Storage::S3::Active');

    skip_all('AdminLog unreliable with multiple instances of the web server') if $S3Active;
}

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
        my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Set log module in sysconfig.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LogModule',
            Value => 'Kernel::System::Log::SysLog',
        );

        # Clear log.
        $LogObject->CleanUp();

        # Destroy and instantiate log object.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Log'] );
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::Log' => {
                LogPrefix => 'TestAdminLog',
            },
        );
        $LogObject = $Kernel::OM->Get('Kernel::System::Log');

        my @LogMessages;

        # Create log entries.
        for ( 0 .. 1 ) {
            my $LogMessage = 'LogMessage' . $Helper->GetRandomNumber();

            $LogObject->Log(
                Priority => 'error',
                Message  => $LogMessage,
            );

            push @LogMessages, $LogMessage;
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminLog screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminLog");

        # filter with the first log entry
        $Selenium->find_element( "#FilterLogEntries", 'css' )->clear();
        $Selenium->find_element( "#FilterLogEntries", 'css' )->send_keys( $LogMessages[0], "\N{U+E007}" );
        sleep 1;

        # Check if the first log entry is shown in the table.
        is(
            $Selenium->execute_script(
                "return \$('#LogEntries tr td:contains($LogMessages[0])').parent().css('display')"
            ),
            'table-row',
            "First log entry exists in the table",
        );

        # Check if the second log entry is not shown in the table.
        is(
            $Selenium->execute_script(
                "return \$('#LogEntries tr td:contains($LogMessages[1])').parent().css('display')"
            ),
            'none',
            "Second log entry does not exist in the table",
        );

        # Click on 'Hide this message'.
        $Selenium->find_element( "#HideHint", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".SidebarColumn:hidden").length'
        );

        # Check if sidebar column is shown.
        is(
            $Selenium->execute_script(
                "return \$('.SidebarColumn').css('display')"
            ),
            'none',
            "Sidebar column is not visible on the screen",
        );

        # Verify log time stamp is in user default time zone (UTC).
        ok(
            $Selenium->execute_script("return \$('#LogEntries .Error:eq(0)').text().indexOf('UTC') !== -1"),
            "Log time stamp is in user default time zone (UTC) format."
        );

        # Get test UserID.
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my $UserID     = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Set test user's time zone.
        my $UserTimeZone = 'Europe/Berlin';
        $UserObject->SetPreferences(
            Key    => 'UserTimeZone',
            Value  => $UserTimeZone,
            UserID => $UserID,
        );

        # Relog test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminLog");

        # Verify log time stamp is in user preference time zone (Europe/Berlin).
        ok(
            $Selenium->execute_script("return \$('#LogEntries .Error:eq(0)').text().indexOf('$UserTimeZone') !== -1"),
            "Log time stamp is in user preference time zone ($UserTimeZone) format."
        );

        # Clear log.
        $LogObject->CleanUp();

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }
);

done_testing();
