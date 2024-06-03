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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self (unused) and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

# Update 'To' in CustomerTicketMessage on Add/Update Group (Bug#10988).

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # make sure that CustomerGroupSupport is disabled
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 0
        );

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # add test queue in group users
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
        my $QueueName   = "Queue" . $Helper->GetRandomID();
        my $QueueID     = $QueueObject->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => 1,
            Comment         => 'Selenium test queue',
        );
        ok( $QueueID, "Queue is created - $QueueName" );

        # click on 'Please click here, to create a new one'
        $Selenium->find_element( '.oooTicketListMessage', 'css' )->VerifiedClick();

        # verify that test queue is available for users group
        $Selenium->find_element_by_css_ok(
            "#Dest option[value='$QueueID||$QueueName']",
            "$QueueName is available to select"
        );

        # create test group
        my $GroupName   = "Group" . $Helper->GetRandomID();
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        my $GroupID     = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        ok( $GroupID, "Group is created - $GroupName" );

        # add test queue to test group
        my $QueueUpdateID = $QueueObject->QueueUpdate(
            QueueID         => $QueueID,
            Name            => $QueueName,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            FollowUpID      => 1,
            UserID          => 1,
            ValidID         => 1,
        );
        ok( $QueueUpdateID, "Queue is updated - $QueueName" );

        # refresh page
        $Selenium->VerifiedRefresh();

        # check if test queue is available to select
        $Selenium->content_contains( $QueueName, "$QueueName is available to select with new group $GroupName" );

        # update group to invalid
        my $GroupUpdate = $GroupObject->GroupUpdate(
            ID      => $GroupID,
            Name    => $GroupName,
            ValidID => 2,
            UserID  => 1,
        );
        ok( $GroupUpdate, "$GroupName is updated to invalid status" );

        # refresh page
        $Selenium->VerifiedRefresh();

        # check test queue with invalid test group
        $Selenium->content_lacks( $QueueName, "$QueueName is not available to select with invalid group $GroupName" );

        # get database object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # clean up test data
        if ($QueueID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueID",
            );
            ok( $Success, "Queue is deleted - $QueueName" );
        }

        if ($GroupID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM groups_table WHERE id = $GroupID",
            );
            ok( $Success, "Group is deleted - $GroupName" );
        }

        # make sure the cache is correct
        for my $Cache (qw (Queue Group)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

done_testing();
