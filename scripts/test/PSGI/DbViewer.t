# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

# This test script does not work with Kernel::System::UnitTest::Driver.
# __SKIP_BY_KERNEL_SYSTEM_UNITTEST_DRIVER__

use strict;
use warnings;
use v5.24.0;
use utf8;

# core modules
use LWP::UserAgent;

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::ObjectManager;

# This test checks whether the /dbviewer route works

# For now test /dbviewer only when running under Docker,
# even though this route could also be available outside Docker.
skip_all 'not running under Docker' unless $ENV{OTOBO_RUNS_UNDER_DOCKER};

$Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-otobo.UnitTest',
    },
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify     => 1,
        DisableAsyncCalls => 1,
    },
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TestAdminUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
);

ok( $TestAdminUserLogin, 'test user created');

# set up URLS
my $BaseURL = join '',
    $ConfigObject->Get('HttpType'),
    '://',
    $Helper->GetTestHTTPHostname(),
    '/',
    $ConfigObject->Get('ScriptAlias');

my $AdminLoginURL = $BaseURL . "index.pl?Action=Login;User=$TestAdminUserLogin;Password=$TestAdminUserLogin;";
my $HelloURL      = $BaseURL . '../hello';
my $DbViewerURL   = $BaseURL . 'dbviewer';

my $UserAgent = LWP::UserAgent->new(
    Timeout => 60,
);
$UserAgent->cookie_jar( {} );    # keep cookies

# TODO: check HelloURL access allowed without login
# TODO: check HelloURL content
# TODO: check DbViewerURL access denied without login

# Login as admin
{
    my $Response = $UserAgent->get( $AdminLoginURL );
    ok( $Response->is_success(), "login to agent interface as admin user" );

    if ( !$Response->is_success() ) {
        # TODO: maybe bail out
        done_testing();

        exit;
    }

    # Get session info from cookie
    my $AdminSessionValid;
    $UserAgent->cookie_jar()->scan(
        sub {
            if ( $_[1] eq $ConfigObject->Get('SessionName') && $_[2] ) {
                $AdminSessionValid = 1;
            }
        }
    );

    ok( $AdminSessionValid, 'valid session for admin user' );

    if ( !$AdminSessionValid ) {
        done_testing();

        exit;
    }
}

# check /dbviewer
{
    my $Response = $UserAgent->get($DbViewerURL);
    my $Status   = $Response->code();

    is( $Status, 200, "status of $DbViewerURL" );

    ok( scalar $Response->header('Content-type'), "content type $DbViewerURL" );

    ok( ! scalar $Response->header('X-OTOBO-Login'), "$DbViewerURL is no OTOBO login screen" );

    # TODO: check response contents
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

# TODO: clean up the database, that is the test user

done_testing();
