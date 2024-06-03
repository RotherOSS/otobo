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
        my $Queue  = $Kernel::OM->Get('Kernel::System::Queue');
        my $Random = $Helper->GetRandomID();

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Do not check Service.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );

        # Do not check Type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # Disable queue selection.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketMessage###Queue',
            Value => 0
        );

        # Enable customer group support.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1
        );

        # Create test group.
        my $GroupName = 'Group' . $Random;
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "GroupID $GroupID is created.",
        );

        # Add test queue.
        my $QueueID = $Queue->QueueAdd(
            Name            => 'Queue' . $Random,
            ValidID         => 1,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "QueueID $QueueID is created.",
        );

        # Set test queue as default.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketMessage###QueueDefault',
            Value => 'Queue' . $Random
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Set user permissions to not include writing to test queue.
        my $Success = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberAdd(
            GID        => $GroupID,
            UID        => $TestCustomerUserLogin,
            Permission => {
                ro => 1,
                rw => 0,
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "CustomerUser '$TestCustomerUserLogin' added to test group '$GroupName' with only 'ro' permission."
        );

        # Log in as the test customer user.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to CustomerTicketMessage screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage");

        # Input fields and try to create ticket.
        $Selenium->find_element( "#Subject",        'css' )->send_keys('Subject');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Text');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Verify that there is an error.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('.MessageBox.Error').length;" );
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Error').length;"),
            "Error message appears on the top.",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('.MessageBox.Error p:contains(\"You don\\'t have sufficient permissions for ticket creation in default queue\")').length;"
            ),
            "Error message text is correct.",
        );

        # Delete test queue.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$QueueID ],
        );
        $Self->True(
            $Success,
            "QueueID $QueueID is deleted.",
        );

        # Delete test group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_customer_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group-CustomerUser relation for GroupID $GroupID is deleted.",
        );

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups_table WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "GroupID $GroupID is deleted.",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(CustomerGroup Group)) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

$Self->DoneTesting();
