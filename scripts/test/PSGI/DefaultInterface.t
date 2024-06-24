# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Test2::Tools::HTTP qw(
    http_code
    http_content
    http_header
    http_is_error
    http_is_redirect
    http_is_success
    http_isnt_redirect
    http_isnt_success
    http_request
    http_response
    psgi_app_add
);
use HTTP::Request::Common qw(GET);
use Plack::Util           ();

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

plan( 2 * 12 );

# This test script checks whether the redirect to the default interface works

# Skip the test when Selenium is not activated.
# Actually, Selenium is not used in this test but we assume that we have a running OTOBO web server
# when Selenium testing is activated.
SKIP:
{
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $SeleniumTestsConfig = $ConfigObject->Get('SeleniumTestsConfig');

    skip 'Selenium testing not active', 12 unless $SeleniumTestsConfig;

    # get needed singletons
    my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

    my $OtoboURL = join '',
        $ConfigObject->Get('HttpType'),
        '://',
        $Helper->GetTestHTTPHostname(),
        '/otobo';

    RunTests($OtoboURL);
}

# This should work without a running OTOBO web server running
{
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    psgi_app_add Plack::Util::load_psgi("$Home/bin/psgi-bin/otobo.psgi");

    my $OtoboURL = '/otobo';

    RunTests($OtoboURL);
}

# execute the tests either agains a running web server or against a mocked server
sub RunTests {
    my ($OtoboURL) = @_;

    http_request(
        [ GET($OtoboURL) ],
        http_response {
            http_isnt_success();
            http_is_redirect();
            http_header( 'Location', 'otobo/index.pl' );
        },
        "testing $OtoboURL",
    );

    my $BrokenOtoboURL = $OtoboURL . '_cruft_added';
    http_request(
        [ GET($BrokenOtoboURL) ],
        http_response {
            http_code(404);
            http_is_error();
            http_content( match(qr/URL was not found/) );
        },
        "testing $BrokenOtoboURL",
    );

    my $WithSlashURL = $OtoboURL . '/';
    http_request(
        [ GET($WithSlashURL) ],
        http_response {
            http_isnt_success();
            http_is_redirect();
            http_header( 'Location', 'index.pl' );
        },
        "testing $WithSlashURL",
    );

    my $WithThreeSlashesURL = $OtoboURL . '///';
    http_request(
        [ GET($WithThreeSlashesURL) ],
        http_response {
            http_isnt_success();
            http_is_redirect();
            http_header( 'Location', 'index.pl' );
        },
        "testing $WithThreeSlashesURL",
    );

    my $IndexPlURL = join '/', $OtoboURL, 'index.pl';
    http_request(
        [ GET($IndexPlURL) ],
        http_response {
            http_is_success();
            http_isnt_redirect();
        },
        "testing $IndexPlURL",
    );

    my $IndexPhpURL = join '/', $OtoboURL, 'index.php';
    http_request(
        [ GET($IndexPhpURL) ],
        http_response {
            http_isnt_success();
            http_is_redirect();
            http_header( 'Location', 'index.pl' );
        },
        "testing $IndexPhpURL",
    );

    my $FourDeepURL = join '/', $OtoboURL, 'level_1', 'level_2', 'level_3', 'level_4', 'sample.html';
    http_request(
        [ GET($FourDeepURL) ],
        http_response {
            http_isnt_success();
            http_is_redirect();
            http_header( 'Location', '../../../../index.pl' );
        },
        "testing $FourDeepURL",
    );

    my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

    # switch the default interface
    for my $Interface ( 'index.pl', 'customer.pl', 'public.pl' ) {
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::DefaultInterface',
            Value => $Interface,
        );

        http_request(
            [ GET($OtoboURL) ],
            http_response {
                http_isnt_success();
                http_is_redirect();
                http_header( 'Location', "otobo/$Interface" );
            },
            "testing redirect to default interface $Interface",
        );

        # inactive interfaces fall back to index.pl
        if ( $Interface eq 'customer.pl' ) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'CustomerFrontend::Active',
                Value => 0,
            );

            http_request(
                [ GET($OtoboURL) ],
                http_response {
                    http_isnt_success();
                    http_is_redirect();
                    http_header( 'Location', "otobo/index.pl" );
                },
                "testing redirect to deactivated default interface $Interface",
            );
        }

        if ( $Interface eq 'public.pl' ) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'PublicFrontend::Active',
                Value => 0,
            );

            http_request(
                [ GET($OtoboURL) ],
                http_response {
                    http_isnt_success();
                    http_is_redirect();
                    http_header( 'Location', "otobo/index.pl" );
                },
                "testing redirect to deactivated default interface $Interface",
            );
        }

        $Helper->CustomFileCleanup();
    }

    return;
}
