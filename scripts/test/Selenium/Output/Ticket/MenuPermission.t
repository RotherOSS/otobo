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

        # get needed objects
        my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
        my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get needed variables
        my $RandomNumber = $Helper->GetRandomNumber();
        my $Success;

        # define group names - first will be added to the system, second doesn't exist
        my $TestGroupName        = 'exist:group:' . $RandomNumber;
        my $NoExistTestGroupName = 'no-exist:group:' . $RandomNumber;

        # add group
        my $TestGroupID = $GroupObject->GroupAdd(
            Name    => $TestGroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $TestGroupID,
            "GroupID $TestGroupID is created",
        );

        # get original config for menu module 'Close'
        my %MenuModuleCloseSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name => 'Ticket::Frontend::MenuModule###450-Close',
        );

        # create ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'SeleniumCustomer',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # create test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', ],
        ) || die "Did not get test user";

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # add the group to the test user
        $Success = $GroupObject->PermissionGroupUserAdd(
            GID        => $TestGroupID,
            UID        => $TestUserID,
            Permission => {
                rw => 1,
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Test user '$TestUserLogin' update group permission for group '$TestGroupID'"
        );

        # login
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my @Tests = (
            {
                Name           => "Menu module 'Close' exists",
                Group          => $TestGroupName,
                ExpectedResult => 1,
            },
            {
                Name           => "Menu module 'Close' doesn't exist",
                Group          => $NoExistTestGroupName,
                ExpectedResult => 0,
            }
        );

        for my $Test (@Tests) {

            # update config
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'Ticket::Frontend::MenuModule###450-Close',
                Value => {
                    %{ $MenuModuleCloseSysConfig{EffectiveValue} },
                    Group => 'rw:' . $Test->{Group},
                },
            );

            # navigate to AgentTicketZoom screen of created test ticket
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            # check if menu module 'Close' exists
            $Self->Is(
                $Selenium->execute_script("return \$('#nav-Close').length"),
                $Test->{ExpectedResult},
                $Test->{Name}
            );
        }

        # cleanup
        # delete group user relation
        $Success = $DBObject->Do(
            SQL => "DELETE FROM group_user WHERE user_id = $TestUserID AND group_id = $TestGroupID",
        );
        $Self->True(
            $Success,
            "Relation groupID '$TestGroupID' to userID '$TestUserID' is deleted"
        );

        # delete group
        $Success = $DBObject->Do(
            SQL => "DELETE FROM groups_table WHERE id = $TestGroupID",
        );
        $Self->True(
            $Success,
            "GroupID $TestGroupID is deleted",
        );

        # delete created test ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        # get cache object
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # make sure cache is correct
        for my $Cache (qw( User Group Ticket )) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

$Self->DoneTesting();
