# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use HTTP::Request::Common qw(POST);
use HTTP::Message::PSGI qw(req_to_psgi);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::Auth::HTTPBasicAuth         ();
use Kernel::System::CustomerAuth::HTTPBasicAuth ();

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# make sure that no environment of the test runner leaks into the tests
local $ENV{OTOBO_PROXY_SECRET};
delete $ENV{OTOBO_PROXY_SECRET};

my $Secret = 'correct horse battery staple';

# Build a request that looks like an unauthenticated API call. The credentials in the body
# must never influence the result of the HTTPBasicAuth backends.
my $SetRequest = sub {
    my %Env = @_;

    my $PSGIEnv = req_to_psgi(
        POST(
            '/otobo/nph-genericinterface.pl/Webservice/GenericTicketConnector/SessionCreate',
            'Content-Type' => 'application/json',
            Content        => '{"UserLogin":"irrelevant","Password":"irrelevant"}',
        )
    );

    delete $PSGIEnv->{REMOTE_USER};

    for my $Key ( keys %Env ) {
        if ( defined $Env{$Key} ) {
            $PSGIEnv->{$Key} = $Env{$Key};
        }
        else {
            delete $PSGIEnv->{$Key};
        }
    }

    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );
    $Kernel::OM->ObjectParamAdd( 'Kernel::System::Web::Request' => { PSGIEnv => $PSGIEnv } );

    return;
};

# Both backends share the logic, only the config prefix differs.
my %Backends = (
    'Kernel::System::Auth::HTTPBasicAuth'         => 'AuthModule::HTTPBasicAuth',
    'Kernel::System::CustomerAuth::HTTPBasicAuth' => 'Customer::AuthModule::HTTPBasicAuth',
);

my $ResetConfig = sub {
    for my $Prefix ( values %Backends ) {
        for my $Count ( '', 1 .. 10 ) {
            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader$Count",
                Value => undef
            );
            $ConfigObject->Set(
                Key   => "${Prefix}::Replace$Count",
                Value => undef
            );
            $ConfigObject->Set(
                Key   => "${Prefix}::ReplaceRegExp$Count",
                Value => undef
            );
        }
    }
    $ConfigObject->Set(
        Key   => 'WebServer::ProxySecret',
        Value => undef
    );

    return;
};

for my $Module ( sort keys %Backends ) {
    my $Prefix = $Backends{$Module};

    subtest $Module => sub {

        my $AuthObject = $Module->new( Count => '' );
        my $Auth       = sub { return $AuthObject->Auth( User => 'irrelevant', Pw => 'irrelevant' ) };

        subtest 'REMOTE_USER set by the web server' => sub {
            $ResetConfig->();

            $SetRequest->( REMOTE_USER => 'alice' );
            is( scalar $Auth->(), 'alice', 'REMOTE_USER is accepted without any proxy configuration' );

            $SetRequest->(
                REMOTE_USER      => 'alice',
                HTTP_REMOTE_USER => 'root@localhost'
            );
            is( scalar $Auth->(), 'alice', 'REMOTE_USER wins over a client supplied header' );

            $SetRequest->();
            is( scalar $Auth->(), undef, 'no identity at all' );
        };

        subtest 'Remote-User header without a valid secret (the vulnerable scenario)' => sub {
            $ResetConfig->();

            $SetRequest->( HTTP_REMOTE_USER => 'root@localhost' );
            is( scalar $Auth->(), undef, 'header ignored: TrustProxyHeader not enabled' );

            # enabling the option alone is not enough, a secret must be configured
            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader",
                Value => 1
            );
            $SetRequest->( HTTP_REMOTE_USER => 'root@localhost' );
            is( scalar $Auth->(), undef, 'header ignored: TrustProxyHeader enabled but no secret configured' );

            # a secret is configured, but the request does not carry it
            $ConfigObject->Set(
                Key   => 'WebServer::ProxySecret',
                Value => $Secret
            );
            $SetRequest->( HTTP_REMOTE_USER => 'root@localhost' );
            is( scalar $Auth->(), undef, 'header ignored: request has no secret' );

            # wrong secret
            $SetRequest->(
                HTTP_REMOTE_USER          => 'root@localhost',
                HTTP_X_OTOBO_PROXY_SECRET => 'wrong'
            );
            is( scalar $Auth->(), undef, 'header ignored: wrong secret' );
        };

        subtest 'Remote-User header from a trusted proxy (correct secret)' => sub {
            $ResetConfig->();
            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader",
                Value => 1
            );
            $ConfigObject->Set(
                Key   => 'WebServer::ProxySecret',
                Value => $Secret
            );

            $SetRequest->(
                HTTP_REMOTE_USER          => 'alice',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), 'alice', 'accepted with correct secret' );

            $SetRequest->(
                HTTP_REMOTE_USER          => '  alice  ',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), 'alice', 'surrounding whitespace is removed' );

            $SetRequest->(
                HTTP_REMOTE_USER          => '',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), undef, 'empty header yields no user' );
        };

        subtest 'secret via environment variable' => sub {
            $ResetConfig->();
            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader",
                Value => 1
            );
            local $ENV{OTOBO_PROXY_SECRET} = $Secret;

            $SetRequest->(
                HTTP_REMOTE_USER          => 'alice',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), 'alice', 'OTOBO_PROXY_SECRET is honoured' );
        };

        subtest 'multi-valued header is rejected' => sub {
            $ResetConfig->();
            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader",
                Value => 1
            );
            $ConfigObject->Set(
                Key   => 'WebServer::ProxySecret',
                Value => $Secret
            );

            # This is what a PSGI server produces when both the proxy and the client sent
            # a Remote-User header and the proxy did not strip the client's copy.
            $SetRequest->(
                HTTP_REMOTE_USER          => 'alice@EXAMPLE.ORG, root@localhost',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), undef, 'proxy value first' );

            $SetRequest->(
                HTTP_REMOTE_USER          => 'root@localhost, alice@EXAMPLE.ORG',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), undef, 'client value first' );

            $ConfigObject->Set(
                Key   => "${Prefix}::ReplaceRegExp",
                Value => '^(.+?)@.+?$'
            );
            $SetRequest->(
                HTTP_REMOTE_USER          => 'root@localhost, alice@EXAMPLE.ORG',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), undef, 'ReplaceRegExp is not applied to a multi-valued header' );
        };

        subtest 'Replace and ReplaceRegExp are still applied' => sub {
            $ResetConfig->();
            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader",
                Value => 1
            );
            $ConfigObject->Set(
                Key   => 'WebServer::ProxySecret',
                Value => $Secret
            );

            $ConfigObject->Set(
                Key   => "${Prefix}::Replace",
                Value => 'EXAMPLE\\'
            );
            $SetRequest->( REMOTE_USER => 'EXAMPLE\\alice' );
            is( scalar $Auth->(), 'alice', 'Replace on REMOTE_USER' );
            $SetRequest->(
                HTTP_REMOTE_USER          => 'EXAMPLE\\alice',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), 'alice', 'Replace on trusted header' );
            $ConfigObject->Set(
                Key   => "${Prefix}::Replace",
                Value => undef
            );

            $ConfigObject->Set(
                Key   => "${Prefix}::ReplaceRegExp",
                Value => '^(.+?)@.+?$'
            );
            $SetRequest->( REMOTE_USER => 'alice@EXAMPLE.ORG' );
            is( scalar $Auth->(), 'alice', 'ReplaceRegExp on REMOTE_USER' );
            $SetRequest->(
                HTTP_REMOTE_USER          => 'alice@EXAMPLE.ORG',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is( scalar $Auth->(), 'alice', 'ReplaceRegExp on trusted header' );
        };

        subtest 'Count suffix of the backend is honoured' => sub {
            $ResetConfig->();
            my $AuthObject2 = $Module->new( Count => 2 );
            $ConfigObject->Set(
                Key   => 'WebServer::ProxySecret',
                Value => $Secret
            );

            # enabled for backend '' but not for backend 2
            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader",
                Value => 1
            );
            $SetRequest->(
                HTTP_REMOTE_USER          => 'alice',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is(
                scalar $AuthObject2->Auth(
                    User => 'x',
                    Pw   => 'x'
                ),
                undef,
                'backend 2 not enabled'
            );

            $ConfigObject->Set(
                Key   => "${Prefix}::TrustProxyHeader2",
                Value => 1
            );
            $SetRequest->(
                HTTP_REMOTE_USER          => 'alice',
                HTTP_X_OTOBO_PROXY_SECRET => $Secret
            );
            is(
                scalar $AuthObject2->Auth(
                    User => 'x',
                    Pw   => 'x'
                ),
                'alice',
                'backend 2 enabled'
            );
        };
    };
}

$ResetConfig->();

done_testing;
