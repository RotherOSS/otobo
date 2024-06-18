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

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and $main::Self
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable the services
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => '1',
        );

        # don't keep children services
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service::KeepChildren',
            Value => '0',
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );
        ok( $TestUserID, 'found user' );

        # get service object
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        # create two test services
        my @ServiceIDs;
        my @ServiceNames;
        for my $Service (qw(Parent Child)) {
            my $ServiceName = $Service . 'Service' . $Helper->GetRandomID();
            my $ServiceID   = $ServiceObject->ServiceAdd(
                Name    => $ServiceName,
                ValidID => 2,                 # invalid
                Comment => 'Selenium Test',
                UserID  => 1,
            );
            $Self->True(
                $ServiceID,
                "Service ID $ServiceID is created",
            );
            push @ServiceIDs,   $ServiceID;
            push @ServiceNames, $ServiceName;
        }

        # update second service to be child of first one and enable it
        my $Success = $ServiceObject->ServiceUpdate(
            ServiceID => $ServiceIDs[1],
            Name      => $ServiceNames[1],
            ParentID  => $ServiceIDs[0],
            ValidID   => 1,
            UserID    => 1,
        );
        $Self->True(
            $Success,
            "Service ID $ServiceIDs[1] is now child service"
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=NotificationSettings"
        );

        # verify child service is not shown
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ServiceID option[value=\"$ServiceIDs[1]\"]').length;"
            ),
            0,
            'Child service is not shown',
        );

        # turn on keep children setting
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service::KeepChildren',
            Value => '1',
        );

        # refresh the page
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=NotificationSettings"
        );

        # verify child service is shown (bug#11816)
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ServiceID option[value=\"$ServiceIDs[1]\"]').length;"
            ),
            1,
            'Child service is shown',
        );

        # add child service to 'My Services' preference
        $Selenium->InputFieldValueSet(
            Element => '#ServiceID',
            Value   => $ServiceIDs[1],
        );

        # save the setting, wait for the ajax call to finish and check if success sign is shown
        $Selenium->execute_script(
            "\$('#ServiceID').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#ServiceID').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#ServiceID').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#ServiceID').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete personal services connection
        $Success = $DBObject->Do(
            SQL => "DELETE FROM personal_services WHERE service_id = $ServiceIDs[1]",
        );
        $Self->True(
            $Success,
            "Delete personal service connection",
        );

        # delete created test services
        for my $Index ( 0 .. 1 ) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM service WHERE id = $ServiceIDs[$Index]",
            );
            $Self->True(
                $Success,
                "Delete service - $ServiceIDs[$Index]",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Service',
        );
    },
);

done_testing;
