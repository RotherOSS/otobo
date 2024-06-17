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

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Test2::Tools::HTTP;
use HTTP::Request::Common;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM

# This test checks whether the URLs / and /index.html work

# For now test only when running under Docker,
# even though this route could also be available outside Docker.
skip_all 'not running under Docker' unless $ENV{OTOBO_RUNS_UNDER_DOCKER};

plan(1);

# get needed singletons
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set up URLS
my $RobotsTxtURL = join '',
    $ConfigObject->Get('HttpType'),
    '://',
    $Helper->GetTestHTTPHostname(),
    '/robots.txt';
http_request(
    [ GET($RobotsTxtURL) ],
    http_response {
        http_is_success();
        http_content_type('text/plain');
        http_content( match(qr!Allow:\s+/otobo/public.pl!) );
    },
    "testing $RobotsTxtURL",
);
