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

# CPAN modules
use Test2::V0;
use Test2::Tools::HTTP;
use HTTP::Request::Common;

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
        RestoreDatabase   => 1,
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

use Data::Dumper;
note("hello: $HelloURL");
note("login: $AdminLoginURL");
note("dbview: $DbViewerURL");
note( "access to /hello is allowed even without login" );
{
    http_request(
        [ GET($HelloURL), follow_redirects => 1 ],
        http_response {
            http_is_success();
            http_content_type( 'text/plain' );
            http_content( match( qr/🌍/ ) );  # content should be "Hallo 🌍!";
        },
        'testing /hello URL, without login first',
    );
# so strange: wget http://localhost:5000/otobo/../hello works, but in test script we get the logi page
note( Dumper( [ 'XXX', $HelloURL, http_tx->req, http_tx->res ] ) );
}

note( 'login required for access to /otobo/dbviewer' );
{
    http_request(
        [ GET($DbViewerURL), follow_redirects => 1 ],
        http_response {
            http_is_success();
            http_content_type( 'text/html' );
            http_content( match( qr/./ ) ); # TODO: saner regex
        },
        'testing /dbviewer URL',
    );

    # TODO: how can Test2::Tools::HTTP used for that test
    #ok( ! scalar $Response->header('X-OTOBO-Login'), "$DbViewerURL is no OTOBO login screen" );
}

note( 'login as admin' );
{
    http_request(
        [ GET($AdminLoginURL), follow_redirects => 1 ],
        http_response {
            http_is_success();
        },
        'login to agent interface as admin user'
    );

    # Get session info from cookie
    my $UserAgent = http_ua();
    my $AdminSessionValid;
    $UserAgent->cookie_jar()->scan(
        sub {
            if ( $_[1] eq $ConfigObject->Get('SessionName') && $_[2] ) {
                $AdminSessionValid = 1;
            }
        }
    );

    ok( $AdminSessionValid, 'valid session for admin user' );
}

note( 'access to /hello is still allowed after login' );
{
    http_request(
        [ GET($HelloURL), follow_redirects => 1 ],
        http_response {
            http_is_success();
            http_content_type( 'text/plain' );
            http_content( match( qr/🌍/ ) );  # content should be "Hallo 🌍!";
        },
        'testing /hello URL, without login first',
    );
}

note( 'access to /otobo/dbviewer granted after login' );
{
    http_request(
        [ GET($DbViewerURL), follow_redirects => 1 ],
        http_response {
            http_is_success();
            http_content_type( 'text/html' );
            http_content( match( qr/./ ) ); # TODO: saner regex
        },
        'testing /otobo/dbviewer URL',
    );

    # TODO: how can Test2::Tools::HTTP used for that test
    #ok( ! scalar $Response->header('X-OTOBO-Login'), "$DbViewerURL is no OTOBO login screen" );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

done_testing();
