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
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

my $Index = 0;

my @Tests = (
    {
        Name    => 'Test ' . $Index . '.- No RequestData',
        Success => '0',
    },
    {
        Name        => 'Test ' . $Index . '.- RequestData is not an array, HASH',
        RequestData => {},
        Success     => '0',
    },
    {
        Name        => 'Test ' . $Index . '.- RequestData is not an array, STRING',
        RequestData => 'Array',
        Success     => '0',
    },
    {
        Name        => 'Test ' . $Index . '.- RequestData without web service',
        RequestData => {
            '' => [
                {
                    InstanceName => 'AnyName',            # optional
                    Operation    => "ConfigurationSet",
                    Data         => {

                        # ... request operation data ...
                    },
                },
            ],
        },
        Success => '0',
    },
    {
        Name        => 'Test ' . $Index . '.- RequestData without Operation',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'AnyName',    # optional
                    Data         => {

                        # ... request operation data ...
                    },
                },
            ],
        },
        Success => '0',
    },
    {
        Name        => 'Test ' . $Index . '.- Wrong Data structure - STRING',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'MyInstance',               # optional
                    Operation    => "ConfigurationSet",
                    Data         => 'NoCorrectDataStructure',
                },
            ],
        },
        Success => '0',
    },
    {
        Name        => 'Test ' . $Index . '.- Wrong Data structure - ARRAY',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'MyInstance',             # optional
                    Operation    => "ConfigurationSet",
                    Data         => [ 'a', 'b', 'c', 'd' ],
                },
            ],
        },
        Success => '0',
    },
    {
        Name        => 'Test ' . $Index . '.- Correct Request data structure - Not a real CloudService',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'AnyName',            # optional
                    Operation    => "ConfigurationSet",
                    Data         => {

                        # ... request operation data ...
                    },
                },
            ],
        },
        Success => '1',
    },

);

my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Run');

for my $Test (@Tests) {

    my $RequestResult = $CloudServiceObject->Request(
        %{$Test},
    );

    if ( $Test->{Success} ) {

        if ( defined $RequestResult ) {
            $Self->Is(
                ref $RequestResult,
                'HASH',
                "$Test->{Name} - Operation result Data structure",
            );

            # check result for each cloud service is available
            for my $CloudServiceName ( sort keys %{ $Test->{RequestData} } ) {

                $Self->True(
                    $RequestResult->{$CloudServiceName},
                    "$Test->{Name} - A result for each Cloud Service should be present - $CloudServiceName.",
                );

                $Self->Is(
                    scalar @{ $RequestResult->{$CloudServiceName} },
                    scalar @{ $Test->{RequestData}->{$CloudServiceName} },
                    "$Test->{Name} - Each operation should return a result.",
                );
            }
        }
        else {

            $Self->True(
                1,
                "$Test->{Name} - A result from Cloud Service is not availble perhaps web response was not successful because Internet connection.",
            );
        }
    }
    else {
        $Self->Is(
            $RequestResult,
            undef,
            "$Test->{Name} - Operation executed with Fail",
        );
    }
}

$Self->DoneTesting();
