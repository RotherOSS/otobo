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

use v5.26;
use strict;
use warnings;
use utf8;

# core modules
use File::Basename qw(basename);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get helper object, put database changes into a transaction
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

# First create a system address for testing
my $RandomID              = $Helper->GetRandomID;
my $SystemAddressEmail    = join '@', $RandomID, 'example.com';
my $SystemAddressRealname = 'Testscript ' . basename(__FILE__);
my %SystemAddressData     = (
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 1,                        # system_address.queueid is not relevant for GetSystemAddress()
    ValidID  => 1,
    UserID   => 1,
);

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    %SystemAddressData,
);
ok( $SystemAddressID, 'SystemAddressAdd()' );

# Create a test queue that refers to the system address created above
my $RandomQueueName = 'Testqueue_' . $Helper->GetRandomNumber;
my $QueueID         = $QueueObject->QueueAdd(
    Name                => $RandomQueueName,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => $SystemAddressID,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'for testing GetSystemAddress()',
);

# test the initial system address
my %InitialSystemAddress = $QueueObject->GetSystemAddress(
    QueueID => $QueueID,
);
is(
    \%InitialSystemAddress,
    {
        Email    => $SystemAddressEmail,
        RealName => $SystemAddressRealname,
        Phrase   => $SystemAddressRealname,
    },
    'GetSystemAddress() - simple'
);

my @Tests = (
    {
        Line      => __LINE__,
        Name      => 'changed the address',
        Overrides => [
            Name => ( $SystemAddressEmail =~ s/@/_changed@/r ),
        ],
        ExpectedSystemAddress => {
            Email    => qq{${RandomID}_changed\@example.com},
            RealName => $SystemAddressRealname,
            Phrase   => $SystemAddressRealname,
        },
    },
    {
        Line      => __LINE__,
        Name      => 'changed the phrase',
        Overrides => [
            Realname => $SystemAddressRealname . '_changed',
        ],
        ExpectedSystemAddress => {
            Email    => $SystemAddressEmail,
            RealName => qq{${SystemAddressRealname}_changed},
            Phrase   => qq{${SystemAddressRealname}_changed},
        },
    },
    {
        Line      => __LINE__,
        Name      => 'phrase with comma',
        Overrides => [
            Realname => q{Punkt, Komma, Strich},
        ],
        ExpectedSystemAddress => {
            Email    => $SystemAddressEmail,
            RealName => qq{"Punkt, Komma, Strich"},
            Phrase   => qq{Punkt, Komma, Strich},
        },
    },
    {
        Line      => __LINE__,
        Name      => 'phrase with colon',
        Overrides => [
            Realname => q{Punkt: dot},
        ],
        ExpectedSystemAddress => {
            Email    => $SystemAddressEmail,
            RealName => qq{"Punkt: dot"},
            Phrase   => qq{Punkt: dot},
        },
    },
    {
        Line      => __LINE__,
        Name      => 'multiple spaces',
        Overrides => [
            Realname => q{one two  three   spaces},
        ],
        ExpectedSystemAddress => {
            Email    => $SystemAddressEmail,
            RealName => qq{one two  three   spaces},
            Phrase   => qq{one two  three   spaces},
        },
    },
);

for my $Test (@Tests) {
    subtest "$Test->{Name} (line $Test->{Line})" => sub {
        my $SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
            ID => $SystemAddressID,
            %SystemAddressData,
            ( $Test->{Overrides} // [] )->@*,
        );
        ok( $SystemAddressUpdate, 'SystemAddressUpdate' );

        my %SystemAddress = $QueueObject->GetSystemAddress(
            QueueID => $QueueID,
        );
        is(
            \%SystemAddress,
            $Test->{ExpectedSystemAddress},
            'GetSystemAddress',
        );
    };
}

done_testing;
