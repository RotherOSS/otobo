# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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
use Test2::Tools::HTTP;
use HTTP::Request::Common;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Kernel::OM

# This test checks whether the redirect to the default interface works

# For now test only when running under Docker,
# even though this route could also be available outside Docker.
skip_all 'not running under Docker' unless $ENV{OTOBO_RUNS_UNDER_DOCKER};

plan(4);

# get needed singletons
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $OtoboURL = join '',
    $ConfigObject->Get('HttpType'),
    '://',
    $Helper->GetTestHTTPHostname(),
    '/otobo';
http_request(
    [ GET($OtoboURL) ],
    http_response {
        http_isnt_success();
        http_is_redirect();
        http_header( 'Location', '../otobo/index.pl' );
    },
    "testing $OtoboURL",
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
        http_header( 'Location', '../otobo/index.pl' );
    },
    "testing $IndexPlURL",
);

my $FourDeepURL = join '/', $OtoboURL, 'level_1', 'level_2', 'level_3', 'level_4', 'sample.html';
http_request(
    [ GET($FourDeepURL) ],
    http_response {
        http_isnt_success();
        http_is_redirect();
        http_header( 'Location', '../../../../../otobo/index.pl' );
    },
    "testing $FourDeepURL",
);
