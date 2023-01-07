# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
use HTTP::Request;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM
use Kernel::System::Web::Request;

subtest 'GET without script name' => sub {
    my $HTTPRequest = HTTP::Request->new( GET => 'http://www.example.com?a=4;b=5' );
    my $Request     = Kernel::System::Web::Request->new( HTTPRequest => $HTTPRequest );

    my @ParamNames = $Request->GetParamNames;
    is(
        [ sort @ParamNames ],
        [qw/a b/],
        'ParamNames',
    );

    is( $Request->GetParam( Param => 'a' ),   4,     'SingleParam a' );
    is( $Request->GetParam( Param => 'b' ),   5,     'SingleParam b' );
    is( $Request->GetParam( Param => 'aia' ), undef, 'SingleParam - not defined' );
    is( $Request->Content,                    '',    'no body in GET request' );
    is( $Request->ScriptName,                 '',    'no script name' );
};

subtest 'GET with script name' => sub {
    my $HTTPRequest = HTTP::Request->new( GET => 'http://www.example.com/some/where/script.sh?a=4;b=5' );
    my $Request     = Kernel::System::Web::Request->new( HTTPRequest => $HTTPRequest );

    my @ParamNames = $Request->GetParamNames;
    is(
        [ sort @ParamNames ],
        [qw/a b/],
        'ParamNames',
    );

    is( $Request->GetParam( Param => 'a' ),   4,             'SingleParam a' );
    is( $Request->GetParam( Param => 'b' ),   5,             'SingleParam b' );
    is( $Request->GetParam( Param => 'aia' ), undef,         'SingleParam - not defined' );
    is( $Request->Content,                    '',            'no body in GET request' );
    is( $Request->ScriptName,                 'script.sh',   'script name script.sh' );
    is( $Request->PathInfo,                   '/some/where', 'script path /some/where' );
};

# TODO: test support for POST_MAX

subtest 'POST without URL params' => sub {
    my $Body        = 'a=4&b=5;d=2';
    my $HTTPRequest = HTTP::Request->new(
        'POST',
        'http://www.example.com/script.awk',
        [ 'Content-Type' => 'application/x-www-form-urlencoded' ],
        $Body,
    );
    my $Request = Kernel::System::Web::Request->new( HTTPRequest => $HTTPRequest );

    my @ParamNames = $Request->GetParamNames;
    is(
        [ sort @ParamNames ],
        [qw/a b d/],
        'ParamNames',
    );

    is(
        [ $Request->GetArray( Param => 'a' ) ],
        [4],
        'Param a, from POST',
    );
    is(
        [ $Request->GetArray( Param => 'b' ) ],
        [5],
        'Param b, from POST',
    );
    is(
        [ $Request->GetArray( Param => 'c' ) ],
        [],
        'Param c not in body',
    );
    is(
        [ $Request->GetArray( Param => 'd' ) ],
        [2],
        'Param d, from POST',
    );

    is( $Request->Content,                         $Body,        'body in POST request' );
    is( $Request->GetParam( Param => 'POSTDATA' ), $Body,        'POSTDATA gets body' );
    is( $Request->ScriptName,                      'script.awk', 'script name script.awk' );
};

subtest 'POST with URL params' => sub {
    my $Body        = 'a=4&b=5;d=2';
    my $HTTPRequest = HTTP::Request->new(
        'POST',
        'http://www.example.com/script.py?c=4;c=5;b=6',
        [ 'Content-Type' => 'application/x-www-form-urlencoded' ],
        $Body,
    );
    my $Request = Kernel::System::Web::Request->new( HTTPRequest => $HTTPRequest );

    my @ParamNames = $Request->GetParamNames;
    is(
        [ sort @ParamNames ],
        [qw/a b c d/],
        'ParamNames',
    );

    is(
        [ $Request->GetArray( Param => 'a' ) ],
        [4],
        'Param a, from POST',
    );

    is(
        [ $Request->GetArray( Param => 'b' ) ],
        [ 6, 5 ],
        'Param b, from URL and body merged, GET is first',
    );
    is(
        $Request->GetParam( Param => 'b' ),
        5,
        'Param b, from POST as the last value is taken',
    );

    is(
        [ $Request->GetArray( Param => 'c' ) ],
        [ 4, 5 ],
        'Param c, from GET',
    );
    is(
        [ $Request->GetArray( Param => 'd' ) ],
        [2],
        'Param d, from POST',
    );
    is( $Request->Content,                         $Body,       'body in mixed request' );
    is( $Request->GetParam( Param => 'POSTDATA' ), $Body,       'POSTDATA gets body' );
    is( $Request->ScriptName,                      'script.py', 'script name script.py' );
};

done_testing;
