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
    http_header
    http_is_redirect
    http_is_success
    http_isnt_success
    http_request
    http_response
);
use HTTP::Request::Common qw(GET);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# This test checks whether the redirect to the default interface works

# For now test only when running under Docker,
# even though this route could also be available outside Docker.
skip_all 'not running under Docker' unless $ENV{OTOBO_RUNS_UNDER_DOCKER};

# get needed singletons
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $BaseURL = join '',
    $ConfigObject->Get('HttpType'),
    '://',
    $Helper->GetTestHTTPHostname;

diag('otobo/index.pl and otobo/customer.pl are not redirected');
http_request(
    [ GET("$BaseURL/otobo/index.pl") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL/otobo/customer.pl") ],
    http_response {
        http_is_success();
    },
);

diag('trailing slash is accepted too');
http_request(
    [ GET("$BaseURL/otobo/index.pl/") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL/otobo/customer.pl/") ],
    http_response {
        http_is_success();
    },
);

diag('double slash is fine');
http_request(
    [ GET("$BaseURL/otobo//index.pl/") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL/otobo//customer.pl/") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL//otobo/index.pl/") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL//otobo/customer.pl/") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL/otobo/index.pl//") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL/otobo/customer.pl//") ],
    http_response {
        http_is_success();
    },
);

diag('many slashes are squashed too');
http_request(
    [ GET("$BaseURL////otobo//////////index.pl////////////") ],
    http_response {
        http_is_success();
    },
);
http_request(
    [ GET("$BaseURL////otobo//////////customer.pl////////////") ],
    http_response {
        http_is_success();
    },
);

# a counter example
http_request(
    [ GET("$BaseURL/otobo/ /customer.pl") ],
    http_response {
        http_isnt_success();
        http_is_redirect();
        http_header( 'Location', "../index.pl" );
    },
    "/ / is not squashed",
);

done_testing();
