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

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable all dashboard plugins.
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        # Get dashboard RSS plugin default sysconfig.
        my %RSSConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'DashboardBackend###0410-RSS',
            Default => 1,
        );

        my $RandomRSSTitle = 'RSS' . $Helper->GetRandomID();

        # Set URL config to xml content in ordr to prevent instability in case cloud services are
        # unavailable at the exact moment of this test run.
        $RSSConfig{DefaultValue}->{URL} = "
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <rss version=\"2.0\"  xmlns:content=\"http://purl.org/rss/1.0/modules/content/\"
              xmlns:wfw=\"http://wellformedweb.org/CommentAPI/\"
              xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
              xmlns:atom=\"http://www.w3.org/2005/Atom\"
              xmlns:sy=\"http://purl.org/rss/1.0/modules/syndication/\"
              xmlns:slash=\"http://purl.org/rss/1.0/modules/slash/\"  >
              <channel>
                  <title>Press Releases &#8211;otobo.io| OTOBO Simple Service Management</title>
                  <atom:link href=\"https://www.otobo.org/feed/?cat=112%2C254%2C111\" rel=\"self\" type=\"application/rss+xml\" />
                  <link>https://www.otobo.org</link>
                  <description>Simple service management</description>
                  <lastBuildDate>Fri, 26 Jan 2018 13:37:52 +0000</lastBuildDate>
                  <language>en-EN</language>
                  <sy:updatePeriod>hourly</sy:updatePeriod>
                  <sy:updateFrequency>1</sy:updateFrequency>
                  <generator>https://wordpress.org/?v=4.9.2</generator>
                  <item>
                      <title>$RandomRSSTitle</title>
                      <link>https://www.otobo.org/$RandomRSSTitle</link>
                      <pubDate>Tue, 16 Jan 2018 09:00:07 +0000</pubDate>
                      <dc:creator><![CDATA[Marketing OTOBO]]></dc:creator>
                      <category><![CDATA[Release and Security Notes]]></category>
                      <category><![CDATA[Release Notes: OTOBO Community Solution]]></category>
                      <guid isPermaLink=\"false\">https://www.otobo.org/?p=61580</guid>
                      <description><![CDATA[&#160; January 16, 2018 — OTOBO, test]]></description>
                      <content:encoded><![CDATA[<div class=\"row box-space-md\"> <div class=\"col-lg-12 col-md-12 col-sm-12 column1\"></div> </div>]]></content:encoded>
                  </item>
              </channel>
            </rss>
        ";

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0410-RSS',
            Value => $RSSConfig{EffectiveValue},
        );

        # Avoid SSL errors on old test platforms.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'WebUserAgent::DisableSSLVerification',
            Value => 1,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Wait for RSS plugin to show up.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Dashboard0410-RSS").length' );

        # Test if RSS feed is shown.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#Dashboard0410-RSS tbody a[href*=\"www.otobo.org/$RandomRSSTitle\"]').text().trim() === '$RandomRSSTitle'"
            ),
            "RSS feed '$RandomRSSTitle' - found",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw( Dashboard DashboardQueueOverview )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

$Self->DoneTesting();
