# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::UnitTest::Selenium;

our $Self;

# get the Selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

# store test function in variable so the Selenium object can handle errors/exceptions/dies etc.
my $SeleniumTest = sub {

    # initialize Znuny4OTOBO Helpers and other needed objects
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
    my $StateObject       = $Kernel::OM->Get('Kernel::System::State');
    my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');

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
    my $TestUserLogin = $HelperObject->TestUserCreate(
        Groups => ['users'],
    ) || die "Did not get test user";

    $Selenium->Login(
        Type     => 'Agent',
        User     => $TestUserLogin,
        Password => $TestUserLogin,
    );

    my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

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

        my $TicketID = '';
        if ( $Test->{Data}->{Ticket} ) {
            my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

            $TicketID = $TicketObject->TicketCreate(
                Title    => "Selenium Test Ticket for Znuny4OTOBOShowPendingTimeIfNeeded.t",
                Queue    => 'Raw',
                Lock     => 'unlock',
                Priority => '3 normal',
                State    => 'new',
                OwnerID  => 1,
                UserID   => 1,
            );
        }

        # Navigate to appropriate screen in the test
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Test->{Data}->{Action};TicketID=$TicketID");

        for my $Field (qw(Day Year Month Hour Minute)) {

            my $IsDisplayed = eval {
                $Selenium->find_element( "#$Field", 'css' )->is_displayed();
            };

            ok( !$IsDisplayed, "disabled element '$Field' is not displayed" );
        }

        my $StateElement = eval {
            $Selenium->find_element( "#$Test->{Data}->{State}", 'css' );
        };
        ok( $StateElement, 'state input field found' );

        my $Result = $Selenium->InputFieldValueSet(
            Element => "#$Test->{Data}->{State}",
            Value   => $PendingStateIDs[0],
        );

        ok( $Result, 'Changed state successfully' );

        next TEST unless $Result;

        for my $Field (qw(Day Year Month Hour Minute)) {

            $Self->True(
                $Selenium->find_element( "#$Field", 'css' )->is_displayed(),
                "Checking for enabled element '$Field'",
            );
        }
    }
};

# finally run the test(s) in the browser
$Selenium->RunTest($SeleniumTest);

done_testing();
