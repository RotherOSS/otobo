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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my %QueuePreferences = (
            Module  => "Kernel::Output::HTML::QueuePreferences::Generic",
            Label   => "Comment2",
            Desc    => "Define the queue comment 2.",
            Block   => "TextArea",
            Cols    => 50,
            Rows    => 5,
            PrefKey => "Comment2",
        );

        # Enable QueuePreferences.
        $Helper->ConfigSettingChange(
            Key   => 'QueuePreferences###Comment2',
            Value => \%QueuePreferences,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'QueuePreferences###Comment2',
            Value => \%QueuePreferences,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to queue admin.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminQueue");

        # Add new queue.
        $Selenium->find_element( "a.Create", 'css' )->VerifiedClick();

        # Check add page, and especially included queue attribute Comment2.
        for my $ID (
            qw(Name GroupID FollowUpID FollowUpLock SalutationID SystemAddressID SignatureID ValidID Comment2)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );

            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Create a real test queue.
        my $RandomQueueName = 'Queue' . $Helper->GetRandomID();
        my $TestComment     = 'QueuePreferences Comment2';

        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomQueueName);
        $Selenium->InputFieldValueSet(
            Element => '#GroupID',
            Value   => '1',
        );
        $Selenium->InputFieldValueSet(
            Element => '#FollowUpID',
            Value   => '1',
        );
        $Selenium->InputFieldValueSet(
            Element => '#SalutationID',
            Value   => '1',
        );
        $Selenium->InputFieldValueSet(
            Element => '#SystemAddressID',
            Value   => '1',
        );
        $Selenium->InputFieldValueSet(
            Element => '#SignatureID',
            Value   => '1',
        );
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => '1',
        );

        # Set included queue attribute Comment2.
        $Selenium->find_element( "#Comment2", 'css' )->send_keys($TestComment);
        $Selenium->find_element( "#Submit",   'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"AdminQueue;Subaction=Change\"]:contains($RandomQueueName)').length"
        );

        # Check if test queue is created.
        $Self->True(
            $Selenium->execute_script(
                "return \$('a[href*=\"AdminQueue;Subaction=Change\"]:contains($RandomQueueName)').length === 1"
            ),
            'New queue found on table'
        );

        # Go to new queue again.
        $Selenium->find_element( $RandomQueueName, 'link_text' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Name').length && \$('#Comment2').length"
        );

        # Check queue value for Comment2.
        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            $TestComment,
            "#Comment2 stored value",
        );

        # Update queue.
        my $UpdatedComment = "Updated comment for $TestComment";
        my $UpdatedName    = $RandomQueueName . "-updated";
        $Selenium->find_element( "#Name",     'css' )->clear();
        $Selenium->find_element( "#Name",     'css' )->send_keys($UpdatedName);
        $Selenium->find_element( "#Comment2", 'css' )->clear();
        $Selenium->find_element( "#Comment2", 'css' )->send_keys($UpdatedComment);
        $Selenium->find_element( "#Submit",   'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"AdminQueue;Subaction=Change\"]:contains($UpdatedName)').length"
        );

        # Check updated values.
        $Selenium->find_element( $UpdatedName, 'link_text' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Name').length && \$('#Comment2').length"
        );

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $UpdatedName,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            $UpdatedComment,
            "#Comment2 updated value",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test queue.
        my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
            Queue => $UpdatedName,
        );
        my $Success = $DBObject->Do(
            SQL => "DELETE FROM queue_preferences WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "QueuePreferences are deleted - $UpdatedName",
        );
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Queue is deleted - $UpdatedName",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (
            qw (Queue SysConfig)
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }
);

$Self->DoneTesting();
