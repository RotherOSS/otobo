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

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get customer user object
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my $RandomID        = $Helper->GetRandomID();
my $CustomerUserID  = "user$RandomID";
my $CustomerUserID2 = "user$RandomID-2";
my $CustomerID      = "customer$RandomID";
my $CustomerID2     = "customer$RandomID-2";
my $UserID          = 1;

my @Tests = (
    {
        Name    => 'No parameters',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No CustomerUserID',
        Config => {
            CustomerID => $CustomerID,
            Active     => 1,
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No CustomerID',
        Config => {
            CustomerUserID => $CustomerUserID,
            Active         => 1,
            UserID         => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No UserID',
        Config => {
            CustomerUserID => $CustomerUserID,
            CustomerID     => $CustomerID,
            Active         => 1,
        },
        Success => 0,
    },
    {
        Name   => 'All parameters',
        Config => {
            CustomerUserID => $CustomerUserID,
            CustomerID     => $CustomerID,
            Active         => 1,
            UserID         => $UserID,
        },
        ExpectedCustomers => [
            $CustomerID,
        ],
        ExpectedUsers => [
            $CustomerUserID,
        ],
        Success => 1,
    },
    {
        Name   => 'Multiple customer users',
        Config => [
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => 1,
                UserID         => $UserID,
            },
            {
                CustomerUserID => $CustomerUserID2,
                CustomerID     => $CustomerID,
                Active         => 1,
                UserID         => $UserID,
            },
        ],
        ExpectedCustomers => [
            $CustomerID,
        ],
        ExpectedUsers => [
            $CustomerUserID,
            $CustomerUserID2,
        ],
        Success => 1,
    },
    {
        Name   => 'Reset customer association',
        Config => [
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => 0,
                UserID         => $UserID,
            },
            {
                CustomerUserID => $CustomerUserID2,
                CustomerID     => $CustomerID,
                Active         => 0,
                UserID         => $UserID,
            },
        ],
        ExpectedCustomers => [],
        ExpectedUsers     => [],
        Success           => 1,
    },
    {
        Name   => 'Multiple customers',
        Config => [
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => 1,
                UserID         => $UserID,
            },
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID2,
                Active         => 1,
                UserID         => $UserID,
            },
        ],
        ExpectedCustomers => [
            $CustomerID,
            $CustomerID2,
        ],
        ExpectedUsers => [
            $CustomerUserID,
        ],
        Success => 1,
    },
);

for my $Test (@Tests) {

    my @Configs;

    # single configuration
    if ( ref $Test->{Config} eq 'HASH' ) {
        push @Configs, $Test->{Config};
    }

    # multiple configurations
    elsif ( ref $Test->{Config} eq 'ARRAY' ) {
        @Configs = @{ $Test->{Config} };
    }

    # add relations
    for my $Config (@Configs) {
        my $Success = $CustomerUserObject->CustomerUserCustomerMemberAdd(
            %{$Config},
        );

        if ( $Test->{Success} ) {
            $Self->True(
                $Success,
                "CustomerUserCustomerMemberAdd() - $Test->{Name}",
            );
        }
        else {
            $Self->False(
                $Success,
                "CustomerUserCustomerMemberAdd() - $Test->{Name}",
            );
        }
    }

    # check output
    if ( $Test->{Success} ) {
        for my $Config (@Configs) {
            my @CustomerIDs = $CustomerUserObject->CustomerUserCustomerMemberList(
                CustomerUserID => $Config->{CustomerUserID},
            );

            $Self->IsDeeply(
                \@CustomerIDs,
                $Test->{ExpectedCustomers},
                "CustomerUserCustomerMemberList( CustomerUserID ) - $Test->{Name}",
            );

            my @CustomerUserIDs = $CustomerUserObject->CustomerUserCustomerMemberList(
                CustomerID => $Config->{CustomerID},
            );

            $Self->IsDeeply(
                \@CustomerUserIDs,
                $Test->{ExpectedUsers},
                "CustomerUserCustomerMemberList( CustomerID ) - $Test->{Name}",
            );

            @CustomerIDs = $CustomerUserObject->CustomerIDs(
                User => $Config->{CustomerUserID},
            );

            $Self->IsDeeply(
                \@CustomerIDs,
                $Test->{ExpectedCustomers},
                "CustomerIDs( CustomerUserID ) - $Test->{Name}",
            );
        }
    }
}

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
