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

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # Get needed objects.
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # make sure to enable cloud services
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CloudServices::Disabled',
            Value => 0,
        );

        # Disable all dashboard plugins.
        my $Config = $ConfigObject->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => $Config,
        );

        # get dashboard News plugin default sysconfig
        my %NewsConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'DashboardBackend###0405-News',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0405-News',
            Value => $NewsConfig{EffectiveValue},
        );

        my @NewsData;
        for ( 0 .. 1 ) {
            my $Number = $Helper->GetRandomNumber();
            push @NewsData, {
                Title => "UT Breaking News - $Number",
                Link  => "https://www.otobo.org/$Number",
            };
        }

        # Create a fake cloud service response with public feed data.
        my $CloudServiceResponse = {
            Results => {
                PublicFeeds => [
                    {
                        Success   => 1,
                        Operation => 'NewsFeed',
                        Data      => {
                            News => [
                                {
                                    Title => $NewsData[0]->{Title},
                                    Link  => $NewsData[0]->{Link},
                                    Time  => '2017-01-25T15:05:59+00:00',
                                },
                                {
                                    Title => $NewsData[1]->{Title},
                                    Link  => $NewsData[1]->{Link},
                                    Time  => '2017-01-25T15:05:59+00:00',
                                },
                            ],
                        },
                    },
                ],
            },
            ErrorMessage => '',
            Success      => 1,
        };
        my $CloudServiceResponseJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
            Data   => $CloudServiceResponse,
            Pretty => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Override Request() from WebUserAgent to always return some test data without making any
        #   actual web service calls. This should prevent instability in case cloud services are
        #   unavailable at the exact moment of this test run.
        my $CustomCode = <<"EOS";
sub Kernel::Config::Files::ZZZZUnitTestNews${RandomID}::Load {} # no-op, avoid warning logs
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
            Identifier => 'News' . $RandomID,
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'Dashboard',
            Key  => 'RSSNewsFeed-en',
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

        # Get script alias.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to dashboard screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Check if News plugin has items with correct titles and links.
        for my $Item (@NewsData) {
            ok(
                $Selenium->execute_script(
                    "return \$('#Dashboard0405-News tbody a[href=\"$Item->{Link}\"]:contains(\"$Item->{Title}\")').length;"
                ),
                "News dashboard plugin with title '$Item->{Title}' and link '$Item->{Link}' - found",
            );
        }
    }
);

done_testing();
