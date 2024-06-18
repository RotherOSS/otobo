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

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $StatsObject  = $Kernel::OM->Get('Kernel::System::Stats');

        # Disable all dashboard plugins.
        my $Config = $ConfigObject->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Stats::ExchangeAxis',
            Value => 1,
        );

        # Add at least one dashboard setting dashboard sysconfig so dashboard can be loaded.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0400-UserOnline',
            Value => {
                'Block'         => 'ContentSmall',
                'CacheTTLLocal' => '5',
                'Default'       => '0',
                'Description'   => '',
                'Filter'        => 'Agent',
                'Group'         => '',
                'IdleMinutes'   => '60',
                'Limit'         => '10',
                'Module'        => 'Kernel::Output::HTML::Dashboard::UserOnline',
                'ShowEmail'     => '0',
                'SortBy'        => 'UserFullname',
                'Title'         => 'Online'
            },
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $StatisticContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $ConfigObject->Get('Home')
                . '/scripts/test/Selenium/Output/Dashboard/Stats.xml',
        );

        # Import test stats.
        my $TestStatID = $StatsObject->Import(
            Content => $StatisticContent,
            UserID  => $TestUserID,
        );
        $Self->True(
            $TestStatID,
            "Successfully imported StatID $TestStatID",
        );

        # Update test stats name and show as dashboard widget.
        my $TestStatsName = "SeleniumStats" . $Helper->GetRandomID();
        my $Update        = $StatsObject->StatsUpdate(
            StatID => $TestStatID,
            Hash   => {
                Title                 => $TestStatsName,
                ShowAsDashboardWidget => '1',
            },
            UserID => $TestUserID,
        );
        $Self->True(
            $Update,
            "Stats is updated - ID $TestStatID",
        );

        $TestStatID = sprintf( "%02d", $TestStatID );
        my $StatsWidgetID = "10$TestStatID-Stats";

        # Store invalid old-style time zone offset in user preferences for imported statistic.
        my $Success = $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            Key   => "UserDashboardStatsStatsConfiguration$StatsWidgetID",
            Value => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => {
                    TimeZone => '+2',    # old-style offset
                },
            ),
            UserID => $TestUserID,
        );

        # Login and go to dashboard.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Enable stats widget on dashboard.
        my $StatsInSettings = "Settings10" . $TestStatID . "-Stats";
        $Selenium->execute_script("\$('.SettingsWidget .Header a').click();");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.SettingsWidget.Expanded').length;"
        );
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#$StatsInSettings:visible').length;"
        );

        $Selenium->execute_script("\$('#$StatsInSettings').click();");
        $Selenium->WaitFor(
            JavaScript => "return \$('#$StatsInSettings:checked').length;"
        );

        $Selenium->find_element( ".SettingsWidget button", 'css' )->VerifiedClick();

        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Stats::Dashboard::Generate');
        my $ExitCode      = $CommandObject->Execute();
        sleep 2;
        $Selenium->VerifiedRefresh();
        $Selenium->WaitFor(
            JavaScript => "return !\$('#Dashboard$TestStatID-Stats i').hasClass('fa-signal')",
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#GraphWidgetContainer10$TestStatID-Stats svg').length;",
        );

        $Self->Is(
            $Selenium->execute_script('return $(".nv-legend-text:contains(Misc)").length;'),
            1,
            "Legend entry for Misc queue found.",
        );

        # Expand stat widget settings.
        $Selenium->execute_script("\$('#Dashboard$StatsWidgetID-toggle').trigger('click');");

        # Verify time zone is set to system default.
        my $SelectedTimeZone = $Selenium->execute_script("return \$('#TimeZone').val();");
        $Self->Is(
            $SelectedTimeZone,
            $ConfigObject->Get('OTOBOTimeZone'),
            'Default time zone'
        );

        # Exchange axis and check if it works.
        $Selenium->InputFieldValueSet(
            Element => '#ExchangeAxis',
            Value   => '1',
        );
        $Selenium->execute_script( "\$('#Dashboard$StatsWidgetID" . "_submit').trigger('click');" );
        sleep 1;

        $ExitCode = $CommandObject->Execute();
        sleep 2;
        $Selenium->VerifiedRefresh();
        $Selenium->WaitFor(
            JavaScript => "return !\$('#Dashboard$TestStatID-Stats i').hasClass('fa-signal')",
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#GraphWidgetContainer10$TestStatID-Stats svg').length;",
        );

        $Self->Is(
            $Selenium->execute_script('return $(".nv-legend-text:contains(open)").length;'),
            1,
            "Legend entry for open state found.",
        );

        # Change the language from the user to test the translations.
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $TestUserID,
            Key    => 'UserLanguage',
            Value  => 'de',
        );
        sleep 1;

        $ExitCode = $CommandObject->Execute();
        sleep 2;
        $Selenium->VerifiedRefresh();
        $Selenium->WaitFor(
            JavaScript => "return !\$('#Dashboard$TestStatID-Stats i').hasClass('fa-signal');",
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#GraphWidgetContainer10$TestStatID-Stats svg').length;",
        );

        $Self->Is(
            $Selenium->execute_script('return $(".nv-legend-text:contains(offen)").length;'),
            1,
            "Legend entry for open state found.",
        );

        # Check if statistic PNG can be downloaded. See bug#14583.
        my $HashRef = $StatsObject->StatsGet(
            StatID             => $TestStatID,
            NoObjectAttributes => 1,
        );

        $Selenium->execute_script(
            "\$('#GraphWidgetLink10$TestStatID-Stats').closest('.ActionMenu').show();"
        );

        $Selenium->execute_script(
            "\$('#GraphWidgetLink10$TestStatID-Stats').find('.TriggerTooltip').click();"
        );

        $Selenium->find_element( "#GraphWidgetLink10$TestStatID-Stats a[download=\"$HashRef->{Title}\.png\"]", "css" )
            ->click();

        # Check if href is created.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#GraphWidgetLink10$TestStatID-Stats a[href*=\"data:image\/png\"]').length;"
            ),
            1,
            "Download link for png exists"
        );

        # Delete test stat.
        $Self->True(
            $StatsObject->StatsDelete(
                StatID => $TestStatID,
                UserID => $TestUserID,
            ),
            "Stats is deleted - ID $TestStatID",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw( Stats Dashboard DashboardQueueOverview )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

$Self->DoneTesting();
