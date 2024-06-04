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

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM
use Kernel::System::WebUserAgent;
use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $TestNumber     = 1;
my $TimeOut        = $ConfigObject->Get('Package::Timeout');
my $Proxy          = $ConfigObject->Get('Package::Proxy');
my $RepositoryRoot = $ConfigObject->Get('Package::RepositoryRoot') || [];

my @Tests = (
    {
        Name        => 'GET - empty url - Test ' . $TestNumber++,
        URL         => "",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => 0,
        ErrorNumber => 400,
    },
    {
        Name        => 'GET - wrong url - Test ' . $TestNumber++,
        URL         => "wrongurl",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => 0,
        ErrorNumber => 400,
    },
    {
        Name        => 'GET - invalid url - Test ' . $TestNumber++,
        URL         => "http://novalidurl",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => 0,
        ErrorNumber => 500,
    },
    {
        Name        => 'GET - http - invalid proxy - Test ' . $TestNumber++,
        URL         => "http://ftp.otobo.io/pub/otobo/packages/otobo.xml",
        Timeout     => $TimeOut,
        Proxy       => 'http://NoProxy',
        Success     => 0,
        ErrorNumber => 500,
    },
    {
        Name        => 'GET - http - ftp proxy - Test ' . $TestNumber++,
        URL         => "http://ftp.otobo.io/pub/otobo/packages/otobo.xml",
        Timeout     => $TimeOut,
        Proxy       => 'ftp://NoProxy',
        Success     => 0,
        ErrorNumber => 400,
    },
    {
        Name    => 'GET - http - long timeout - Test ' . $TestNumber++,
        URL     => "http://ftp.otobo.io/pub/otobo/packages/otobo.xml",
        Timeout => 100,
        Proxy   => $Proxy,
        Success => 1,
    },
    {
        Name    => 'GET - http - Header ' . $TestNumber++,
        URL     => "http://ftp.otobo.io/pub/otobo/packages/otobo.xml",
        Timeout => 100,
        Proxy   => $Proxy,
        Success => 1,
        Header  => {
            Content_Type => 'text/json',
        },
        Return  => 'REQUEST',
        Matches => qr!Content-Type:\s+text/json!,
    },
    {
        Skip        => 'makalu.otobo.io is not set up',
        Name        => 'GET - http - Credentials ' . $TestNumber++,
        URL         => "https://makalu.otobo.io/unittest/HTTPBasicAuth/",
        Timeout     => 100,
        Proxy       => $Proxy,
        Success     => 1,
        Credentials => {
            User     => 'guest',
            Password => 'guest',
            Realm    => 'OTRS UnitTest',
            Location => 'makalu.otobo.io:443',
        },
    },
    {
        Skip        => 'makalu.otobo.io is not set up',
        Name        => 'GET - http - MissingCredentials ' . $TestNumber++,
        URL         => "https://makalu.otobo.io/unittest/HTTPBasicAuth/",
        Timeout     => 100,
        Proxy       => $Proxy,
        Success     => 0,
        ErrorNumber => 401,
    },
    {
        Skip        => 'makalu.otobo.io is not set up',
        Name        => 'GET - http - IncompleteCredentials ' . $TestNumber++,
        URL         => "https://makalu.otobo.io/unittest/HTTPBasicAuth/",
        Timeout     => 100,
        Proxy       => $Proxy,
        Credentials => {
            User     => 'guest',
            Password => 'guest',
        },
        Success     => 0,
        ErrorNumber => 401,
    },
);

# get repository list
for my $URL ( @{$RepositoryRoot} ) {

    my %NewEntry = (
        Name    => 'Test ' . $TestNumber++,
        URL     => $URL,
        Timeout => $TimeOut,
        Proxy   => $Proxy,
        Success => '1',
    );

    push @Tests, \%NewEntry;
}

my %Interval = (
    1 => 3,
    2 => 15,
    3 => 60,
    4 => 60 * 3,
    5 => 60 * 6,
);

TEST:
for my $Test (@Tests) {

    if ( $Test->{Skip} ) {
        diag "Skipping $Test->{Name} : $Test->{Skip}";

        next TEST;
    }

    subtest $Test->{Name} => sub {
        TRY:
        for my $Try ( 1 .. 5 ) {

            my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
                Timeout => $Test->{Timeout},
                Proxy   => $Test->{Proxy},
            );

            isa_ok(
                $WebUserAgentObject,
                ['Kernel::System::WebUserAgent'],
                "WebUserAgent object creation",
            );

            my %Response = $WebUserAgentObject->Request(
                %{$Test},
            );

            ok(
                IsHashRefWithData( \%Response ),
                "WebUserAgent check structure from request",
            );

            my $Status = substr $Response{Status}, 0, 3;

            if ( !$Test->{Success} ) {

                if ( $Try < 5 && $Status eq 500 && $Test->{ErrorNumber} ne 500 ) {

                    sleep $Interval{$Try};

                    next TRY;
                }

                ok(
                    !$Response{Content},
                    "WebUserAgent fail test for URL: $Test->{URL}",
                );

                is(
                    $Status,
                    $Test->{ErrorNumber},
                    "WebUserAgent - Check error number",
                );

                return;
            }
            else {

                if ( $Try < 5 && ( !$Response{Content} || !$Status || $Status ne 200 ) ) {

                    sleep $Interval{$Try};

                    next TRY;
                }

                ok(
                    $Response{Content},
                    "WebUserAgent - Success test for URL: $Test->{URL}",
                );

                is(
                    $Status,
                    200,
                    "WebUserAgent - Check request status",
                );

                if ( $Test->{Matches} ) {
                    ok(
                        ( ${ $Response{Content} } =~ $Test->{Matches} ) || undef,
                        "Matches",
                    );
                }
            }

            if ( $Test->{Content} ) {

                is(
                    $Response{Content}->$*,
                    $Test->{Content},
                    "WebUserAgent - Check request content",
                );
            }
        }
    };
}

done_testing();
