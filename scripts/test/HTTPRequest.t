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

use v5.24;
use strict;
use warnings;
use utf8;

=head1 DESCRIPTION

This test script tests the module L<Kernel::System::Web::Request>. The input is taken
from an instance of L<HTTP::Request>.

=cut

# core modules

# CPAN modules
use HTTP::Request::Common qw(POST);
use HTTP::Request         ();
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::Web::Request ();

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
    is(
        $Request->Headers->psgi_flatten,
        [
            'Host'           => 'www.example.com',
            'Content-Length' => 0
        ],
        'flat list of headers'
    );
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
    is(
        $Request->Headers->psgi_flatten,
        [
            'Host'           => 'www.example.com',
            'Content-Length' => 0
        ],
        'flat list of headers'
    );
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
    is(
        $Request->Headers->psgi_flatten,
        [
            'Host'           => 'www.example.com',
            'Content-Length' => 11,
            'Content-Type'   => 'application/x-www-form-urlencoded'
        ],
        'flat list of headers'
    );
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
        6,
        'Param b taken from URL as the first value is taken',
    );

    is(
        [ $Request->GetArray( Param => 'c' ) ],
        [ 4, 5 ],
        'Param c, from GET',
    );
    is(
        $Request->GetParam( Param => 'c' ),
        4,
        'Param c taken from URL, the first value is taken',
    );
    is(
        [ $Request->GetArray( Param => 'd' ) ],
        [2],
        'Param d, from POST',
    );
    is( $Request->Content,                         $Body,       'body in mixed request' );
    is( $Request->GetParam( Param => 'POSTDATA' ), $Body,       'POSTDATA gets body' );
    is( $Request->ScriptName,                      'script.py', 'script name script.py' );
    is(
        $Request->Headers->psgi_flatten,
        [
            'Host'           => 'www.example.com',
            'Content-Length' => 11,
            'Content-Type'   => 'application/x-www-form-urlencoded'
        ],
        'flat list of headers'
    );
};

subtest 'POST with file upload' => sub {
    my $Body         = 'a=4&b=5;d=2';
    my $ContentFile1 = <<'END_TXT';
File1 line1
File1 line2
END_TXT
    my $ContentFile2 = <<'END_TXT';
File2 line1
File2 line2
END_TXT

    my $HTTPRequest = POST(
        '/',
        {
            a     => ord 'a',
            b     => ord 'b',
            File1 => [
                undef, 'file1.txt',
                Content      => $ContentFile1,
                Content_Type => 'text/plain'
            ],
            File2 => [
                undef, 'file2.txt',
                Content      => $ContentFile2,
                Content_Type => 'text/plain'
            ],
        },
        Content_Type => 'form-data',
    );
    my $Request = Kernel::System::Web::Request->new( HTTPRequest => $HTTPRequest );

    my @ParamNames = $Request->GetParamNames;
    is(
        [ sort @ParamNames ],
        [qw/File1 File2 a b/],
        'ParamNames',
    );

    # File1
    is( $Request->GetParam( Param => 'File1' ), 'file1.txt', 'filename for File1' );
    is(
        { $Request->GetUploadAll( Param => 'File1' ) },
        {
            Filename    => 'file1.txt',
            ContentType => 'text/plain',
            Content     => $ContentFile1,
        },
        'upload info for File1',
    );

    # File2
    is( $Request->GetParam( Param => 'File2' ), 'file2.txt', 'filename for File2' );
    is(
        { $Request->GetUploadAll( Param => 'File2' ) },
        {
            Filename    => 'file2.txt',
            ContentType => 'text/plain',
            Content     => $ContentFile2,
        },
        'upload info for File2',
    );
    like(
        $Request->Headers->psgi_flatten,
        [
            'Content-Length' => 387,
            'Content-Type'   => 'multipart/form-data; boundary=xYzZY',
        ],
        'flat list of headers, ignoring the tempdir'
    );
};

subtest 'SetArray' => sub {
    my $HTTPRequest = HTTP::Request->new( GET => 'http://www.example.com?a=4;b=5' );
    my $Request     = Kernel::System::Web::Request->new( HTTPRequest => $HTTPRequest );

    isa_ok( $HTTPRequest, 'HTTP::Request' );
    isa_ok( $Request,     'Kernel::System::Web::Request' );
    is( $Request->GetParam( Param => 'a' ), 4, 'SingleParam a' );
    is( $Request->GetParam( Param => 'b' ), 5, 'SingleParam b' );

    # overwrite with single value
    $Request->SetArray(
        Param  => 'a',
        Values => ['14']
    );
    is( $Request->GetParam( Param => 'a' ),     14,   'GetParam: a set with single value' );
    is( [ $Request->GetArray( Param => 'a' ) ], [14], 'GetArray: a set with single value' );

    # overwrite without value
    is(
        [ sort $Request->GetParamNames ],
        [qw(a b)],
        'GetParamNames: before removing a'
    );
    $Request->SetArray(
        Param  => 'a',
        Values => []
    );
    is( $Request->GetParam( Param => 'a' ),     undef, 'GetParam: a removed' );
    is( [ $Request->GetArray( Param => 'a' ) ], [],    'GetArray: a removed' );
    is(
        [ sort $Request->GetParamNames ],
        [qw(b)],
        'GetParamNames: after removing a'
    );

    # overwrite with multi values
    $Request->SetArray(
        Param  => 'b',
        Values => [qw(⛄ 15a 15b 15c 15d)]
    );
    is( $Request->GetParam( Param => 'b' ),     '⛄',                     'GetParam: b set with multi values' );
    is( [ $Request->GetArray( Param => 'b' ) ], [qw(⛄ 15a 15b 15c 15d)], 'GetArray: b set with multi values' );

    # new with single value
    $Request->SetArray(
        Param  => 'newA',
        Values => ['24']
    );
    is( $Request->GetParam( Param => 'newA' ),     24,   'GetParam: newA set with single value' );
    is( [ $Request->GetArray( Param => 'newA' ) ], [24], 'GetArray: newA set with single value' );

    # new with multi values
    $Request->SetArray(
        Param  => 'newB',
        Values => [qw(25a 25b 25c 25d)]
    );
    is( $Request->GetParam( Param => 'newB' ),     '25a',                 'GetParam: newB set with multi values' );
    is( [ $Request->GetArray( Param => 'newB' ) ], [qw(25a 25b 25c 25d)], 'GetArray: newB set with multi values' );

    # new without value
    is(
        [ sort $Request->GetParamNames ],
        [qw(b newA newB)],
        'GetParamNames: before removing newC'
    );
    $Request->SetArray(
        Param  => 'newC',
        Values => []
    );
    is( $Request->GetParam( Param => 'newC' ),     undef, 'GetParam: newC set without value' );
    is( [ $Request->GetArray( Param => 'newC' ) ], [],    'GetArray: newC set without value' );
    is(
        [ sort $Request->GetParamNames ],
        [qw(b newA newB)],
        'GetParamNames: after removing newC'
    );
    is(
        $Request->Headers->psgi_flatten,
        [
            'Host'           => 'www.example.com',
            'Content-Length' => 0,
        ],
        'flat list of headers'
    );
};

done_testing;
