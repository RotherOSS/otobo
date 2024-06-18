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

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # activate Service
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );

        my %ServicePreferences = (
            Module  => "Kernel::Output::HTML::ServicePreferences::Generic",
            Label   => "Comment2",
            Desc    => "Define the service comment 2.",
            Block   => "TextArea",
            Cols    => 50,
            Rows    => 5,
            PrefKey => "Comment2",
        );

        # enable ServicePreferences
        $Helper->ConfigSettingChange(
            Key   => 'ServicePreferences###Comment2',
            Value => \%ServicePreferences,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'ServicePreferences###Comment2',
            Value => \%ServicePreferences,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to service admin
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminService");

        # click "Add service"
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ServiceEdit' )]")->VerifiedClick();

        # check add page, and especially included service attribute Comment2
        for my $ID (
            qw( Name ParentID ValidID Comment Comment2 )
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # create a real test service
        my $RandomServiceName = "Service" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",    'css' )->send_keys($RandomServiceName);
        $Selenium->find_element( "#Comment", 'css' )->send_keys("Some service Comment");

        # set included service attribute Comment2
        $Selenium->find_element( "#Comment2", 'css' )->send_keys('ServicePreferences Comment2');
        $Selenium->find_element( "#Submit",   'css' )->VerifiedClick();

        # check if test service is created
        $Self->True(
            index( $Selenium->get_page_source(), $RandomServiceName ) > -1,
            'New service found on table'
        );

        # go to new service again
        $Selenium->find_element( $RandomServiceName, 'link_text' )->VerifiedClick();

        # check service value
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Some service Comment',
            "#Comment stored value",
        );

        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            'ServicePreferences Comment2',
            "#Comment2 stored value",
        );

        # update service
        my $UpdatedComment = "Updated comment for ServicePreferences Comment2";

        $Selenium->find_element( "#Comment2", 'css' )->clear();
        $Selenium->find_element( "#Comment2", 'css' )->send_keys($UpdatedComment);
        $Selenium->find_element( "#Submit",   'css' )->VerifiedClick();

        # check updated values
        $Selenium->find_element( $RandomServiceName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            $UpdatedComment,
            "#Comment2 updated value",
        );

        # delete test service
        my $ServiceID = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
            Name => $RandomServiceName,
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $Success = $DBObject->Do(
            SQL => "DELETE FROM service_preferences WHERE service_id = $ServiceID",
        );
        $Self->True(
            $Success,
            "ServicePreferences are deleted - $RandomServiceName",
        );

        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Service is deleted - $RandomServiceName",
        );

        # make sure the cache is correct.
        for my $Cache (
            qw (ServicePreferencesDB Service SysConfig)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

$Self->DoneTesting();
