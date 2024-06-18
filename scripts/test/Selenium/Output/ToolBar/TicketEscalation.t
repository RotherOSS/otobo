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

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # enable tool bar AgentTicketEscalationView
        my %AgentTicketEscalationView = (
            AccessKey => 'w',
            Action    => 'AgentTicketEscalationView',
            CssClass  => 'EscalationView',
            Icon      => 'fa fa-exclamation',
            Link      => 'Action=AgentTicketEscalationView',
            Module    => 'Kernel::Output::HTML::ToolBar::Link',
            Name      => 'Escalation view',
            Priority  => '1010030',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Frontend::ToolBarModule###3-Ticket::AgentTicketEscalationView',
            Value => \%AgentTicketEscalationView,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###3-Ticket::AgentTicketEscalationView',
            Value => \%AgentTicketEscalationView
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

        # click on tool bar AgentTicketEscalationView
        $Selenium->find_element("//a[contains(\@title, \'Escalation view:\' )]")->VerifiedClick();

        # verify that test is on the correct screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketEscalationView";

        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar AgentTicketEscalationView shortcut - success",
        );
    }
);

$Self->DoneTesting();
