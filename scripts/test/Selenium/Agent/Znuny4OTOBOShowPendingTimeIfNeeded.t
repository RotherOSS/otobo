# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

use Kernel::System::VariableCheck qw(:all);

# create configuration backup
# get the Znuny4OTOBO Selenium object
my $SeleniumObject = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# store test function in variable so the Selenium object can handle errors/exceptions/dies etc.
my $SeleniumTest = sub {

    # initialize Znuny4OTOBO Helpers and other needed objects
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
    my $StateObject       = $Kernel::OM->Get('Kernel::System::State');
    my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');

    $ZnunyHelperObject->_RebuildConfig();

    for my $SysConfig ('AgentTicketNote') {

        my $Success = $SysConfigObject->SettingsSet(
            UserID   => 1,
            Comments => "Set $SysConfig State",
            Settings => [
                {
                    Name                   => "Ticket::Frontend::$SysConfig###State",
                    EffectiveValue         => '1',
                    IsValid                => 1,
                    UserModificationActive => 1,
                },
            ],
        );
    }

    my @PendingStateIDs = $StateObject->StateGetStatesByType(
        StateType => [ 'pending reminder', 'pending auto' ],
        Result    => 'ID',
    );

    # create test user and login
    my %TestUser = $SeleniumObject->AgentLogin(
        Groups => ['users'],
    );

    my @Tests = (
        {
            Name => "Action - AgentTicketPhone",
            Data => {
                Action => 'AgentTicketPhone',
                State  => 'NextStateID',
            },
        },
        {
            Name => "Action - AgentTicketEmail",
            Data => {
                Action => 'AgentTicketEmail',
                State  => 'NextStateID',
            },
        },
        {
            Name => "Action - AgentTicketNote",
            Data => {
                Action => 'AgentTicketNote',
                State  => 'NewStateID',
                Ticket => 1,
            },
        },
    );

    TEST:
    for my $Test (@Tests) {

        my $DisabledElement;
        my $TicketID;

        if ( $Test->{Data}->{Ticket} ) {
            $TicketID = $HelperObject->TicketCreate();
        }

        # navigate to Admin page
        $SeleniumObject->AgentInterface(
            Action      => $Test->{Data}->{Action},
            TicketID    => $TicketID,
            WaitForAJAX => 0,
        );

        my $Element = $SeleniumObject->FindElementSave(
            Selector     => "#$Test->{Data}->{State}",
            SelectorType => 'css',
        );

        for my $Field (qw(Day Year Month Hour Minute)) {

            eval {
                $DisabledElement = $SeleniumObject->find_element( "#$Field", 'css' )->is_displayed();
            };
            $Self->False(
                $DisabledElement,
                "Checking for disabled element '$Field'",
            );
        }

        my $Result = $SeleniumObject->InputSet(
            Attribute   => $Test->{Data}->{State},
            Content     => $PendingStateIDs[0],
            WaitForAJAX => 0,
            Options     => {
                KeyOrValue => 'Key',
            },
        );

        $Self->True(
            $Result,
            "Change NextStateID successfully.",
        );

        next TEST if !$Result;

        for my $Field (qw(Day Year Month Hour Minute)) {

            $Self->True(
                $SeleniumObject->find_element( "#$Field", 'css' )->is_displayed(),
                "Checking for enabled element '$Field'",
            );
        }
    }
};

# finally run the test(s) in the browser
$SeleniumObject->RunTest($SeleniumTest);

$Self->DoneTesting();


