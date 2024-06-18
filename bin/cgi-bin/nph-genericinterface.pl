#!/usr/bin/env perl
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
use v5.24;
use utf8;

# core modules
use File::Basename qw(dirname);

# CPAN modules
use Plack::Builder;
use Plack::Handler::CGI qw();
use Plack::Util qw();

# OTOBO modules

#local $ENV{PLACK_URLMAP_DEBUG} = 1; # enable when the URL mapping does not work

# otobo.psgi looks primarily in $ENV{PATH_INFO}
local $ENV{PATH_INFO}   = join '/', grep { defined $_ && $_ ne '' } @ENV{qw(SCRIPT_NAME PATH_INFO)};
local $ENV{SCRIPT_NAME} = '';

my $CgiBinDir = dirname(__FILE__);

state $App = builder {

    #    enable 'Plack::Middleware::DebugLogging',
    #        debug    => 1,
    #        response => 1,
    #        request  => 1;

    Plack::Util::load_psgi("$CgiBinDir/../psgi-bin/otobo.psgi");
};

#$Plack::Middleware::DebugLogging::module_map->{'text/xml; charset=utf-8'} = 'XML::Simple';
#$Plack::Middleware::DebugLogging::module_map->{'text/xml; charset=UTF-8'} = 'XML::Simple';

# set up a PSGI environment from %ENV
my $PSGIEnv = Plack::Handler::CGI->new()->setup_env();

# run the PSGI-application
my $Res = $App->($PSGIEnv);

# sanity check
die "Bad response from the PSGI app" unless ref $Res eq 'ARRAY';
die "Bad response from the PSGI app" unless ref $Res->[2] eq 'ARRAY';

# turn the PSGI response into non parsed header HTTP response

# copied from HTTP::Status
my %Code2Message = (
    100 => 'Continue',
    101 => 'Switching Protocols',
    102 => 'Processing',                      # RFC 2518 (WebDAV)
    103 => 'Early Hints',
    200 => 'OK',
    201 => 'Created',
    202 => 'Accepted',
    203 => 'Non-Authoritative Information',
    204 => 'No Content',
    205 => 'Reset Content',
    206 => 'Partial Content',
    207 => 'Multi-Status',                    # RFC 2518 (WebDAV)
    300 => 'Multiple Choices',
    301 => 'Moved Permanently',
    302 => 'Found',
    303 => 'See Other',
    304 => 'Not Modified',
    305 => 'Use Proxy',
    307 => 'Temporary Redirect',
    400 => 'Bad Request',
    401 => 'Unauthorized',
    402 => 'Payment Required',
    403 => 'Forbidden',
    404 => 'Not Found',
    405 => 'Method Not Allowed',
    406 => 'Not Acceptable',
    407 => 'Proxy Authentication Required',
    408 => 'Request Timeout',
    409 => 'Conflict',
    410 => 'Gone',
    411 => 'Length Required',
    412 => 'Precondition Failed',
    413 => 'Request Entity Too Large',
    414 => 'Request-URI Too Large',
    415 => 'Unsupported Media Type',
    416 => 'Request Range Not Satisfiable',
    417 => 'Expectation Failed',
    422 => 'Unprocessable Entity',            # RFC 2518 (WebDAV)
    423 => 'Locked',                          # RFC 2518 (WebDAV)
    424 => 'Failed Dependency',               # RFC 2518 (WebDAV)
    425 => 'No code',                         # WebDAV Advanced Collections
    426 => 'Upgrade Required',                # RFC 2817
    449 => 'Retry with',                      # unofficial Microsoft
    500 => 'Internal Server Error',
    501 => 'Not Implemented',
    502 => 'Bad Gateway',
    503 => 'Service Unavailable',
    504 => 'Gateway Timeout',
    505 => 'HTTP Version Not Supported',
    506 => 'Variant Also Negotiates',         # RFC 2295
    507 => 'Insufficient Storage',            # RFC 2518 (WebDAV)
    509 => 'Bandwidth Limit Exceeded',        # unofficial
    510 => 'Not Extended',                    # RFC 2774
);

*STDOUT->autoflush(1);
binmode STDOUT;

# first the status line
my $StatusMessage = $Code2Message{ $Res->[0] } // 'UNKNOWN';
my $Headers       = "HTTP/1.1 $Res->[0] $StatusMessage\015\012";

# add the headers
while ( my ( $Key, $Val ) = splice $Res->[1]->@*, 0, 2 ) {
    $Headers .= "$Key: $Val\015\012";
}
$Headers .= "\015\012";

print STDOUT $Headers;

for my $Line ( $Res->[2]->@* ) {
    print STDOUT $Line;
}
