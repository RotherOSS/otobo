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

# This test checks the mirror handling features in DB.pm

my $MasterDSN      = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');
my $MasterUser     = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser');
my $MasterPassword = $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw');

my @Tests = (
    {
        Name   => "No mirror configured",
        Config => {
            'Core::MirrorDB::DSN'               => undef,
            'Core::MirrorDB::User'              => undef,
            'Core::MirrorDB::Password'          => undef,
            'Core::MirrorDB::AdditionalMirrors' => undef,
        },
        MirrorDBAvailable => 0,
        TestIterations    => 1,
    },
    {
        Name   => "First mirror configured",
        Config => {
            'Core::MirrorDB::DSN'               => $MasterDSN,
            'Core::MirrorDB::User'              => $MasterUser,
            'Core::MirrorDB::Password'          => $MasterPassword,
            'Core::MirrorDB::AdditionalMirrors' => undef,
        },
        MirrorDBAvailable => 1,
        TestIterations    => 1,
    },
    {
        Name   => "First mirror configured as invalid",
        Config => {
            'Core::MirrorDB::DSN'               => $MasterDSN,
            'Core::MirrorDB::User'              => 'wrong_user',
            'Core::MirrorDB::Password'          => 'wrong_password',
            'Core::MirrorDB::AdditionalMirrors' => undef,
        },
        MirrorDBAvailable => 0,
        TestIterations    => 1,
    },
    {
        Name   => "Additional mirror configured",
        Config => {
            'Core::MirrorDB::DSN'               => undef,
            'Core::MirrorDB::User'              => undef,
            'Core::MirrorDB::Password'          => undef,
            'Core::MirrorDB::AdditionalMirrors' => {
                1 => {
                    DSN      => $MasterDSN,
                    User     => $MasterUser,
                    Password => $MasterPassword,
                },
            },
        },
        MirrorDBAvailable => 1,
        TestIterations    => 1,
    },
    {
        Name   => "Additional mirror configured as invalid",
        Config => {
            'Core::MirrorDB::DSN'               => undef,
            'Core::MirrorDB::User'              => undef,
            'Core::MirrorDB::Password'          => undef,
            'Core::MirrorDB::AdditionalMirrors' => {
                1 => {
                    DSN      => $MasterDSN,
                    User     => 'wrong_user',
                    Password => 'wrong_password',
                },
            },
        },
        MirrorDBAvailable => 0,
        TestIterations    => 1,
    },
    {
        Name   => "Full config with valid first mirror and invalid additional",
        Config => {
            'Core::MirrorDB::DSN'               => $MasterDSN,
            'Core::MirrorDB::User'              => $MasterUser,
            'Core::MirrorDB::Password'          => $MasterPassword,
            'Core::MirrorDB::AdditionalMirrors' => {
                1 => {
                    DSN      => $MasterDSN,
                    User     => 'wrong_user',
                    Password => 'wrong_password',
                },
                2 => {
                    DSN      => $MasterDSN,
                    User     => $MasterUser,
                    Password => $MasterPassword,
                },
            },
        },
        MirrorDBAvailable => 1,

        # Use many iterations so that also the invalid mirror will be tried first at some point, probably.
        TestIterations => 10,
    },
);

TEST:
for my $Test (@Tests) {

    for my $TestIteration ( 1 .. $Test->{TestIterations} ) {

        $Kernel::OM->ObjectsDiscard();

        for my $ConfigKey ( sort keys %{ $Test->{Config} } ) {
            $Kernel::OM->Get('Kernel::Config')->Set(
                Key   => $ConfigKey,
                Value => $Test->{Config}->{$ConfigKey},
            );
        }

        {
            # Regular fetch from master
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            my @ValidIDs;
            my $TestPrefix = "$Test->{Name} - $TestIteration - UseMirrorDB 0: ";
            $DBObject->Prepare(
                SQL => "\nSELECT id\nFROM valid",    # simulate indentation
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @ValidIDs, $Row[0];
            }
            $Self->True(
                scalar @ValidIDs,
                "$TestPrefix valid ids were found",
            );
            $Self->True(
                $DBObject->{Cursor},
                "$TestPrefix statement handle active on master",
            );
            $Self->False(
                $DBObject->{MirrorDBObject},
                "$TestPrefix MirrorDB not connected",
            );

            $Kernel::OM->ObjectsDiscard(
                Objects => ['Kernel::System::DB'],
            );
        }

        {
            local $Kernel::System::DB::UseMirrorDB = 1;

            my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
            my @ValidIDs   = ();
            my $TestPrefix = "$Test->{Name} - $TestIteration - UseMirrorDB 1: ";

            $DBObject->Prepare(
                SQL => "\nSELECT id\nFROM valid",    # simulate indentation
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @ValidIDs, $Row[0];
            }
            $Self->True(
                scalar @ValidIDs,
                "$TestPrefix valid ids were found",
            );

            if ( !$Test->{MirrorDBAvailable} ) {
                $Self->True(
                    $DBObject->{Cursor},
                    "$TestPrefix statement handle active on master",
                );
                $Self->False(
                    $DBObject->{MirrorDBObject},
                    "$TestPrefix MirrorDB not connected",
                );
                next TEST;
            }

            $Self->False(
                $DBObject->{Cursor},
                "$TestPrefix statement handle inactive on master",
            );
            $Self->True(
                $DBObject->{MirrorDBObject}->{Cursor},
                "$TestPrefix statement handle active on mirror",
            );

            $Self->False(
                scalar $DBObject->Ping( AutoConnect => 0 ),
                "$TestPrefix master object is not connected automatically",
            );

            $Self->True(
                scalar $DBObject->{MirrorDBObject}->Ping( AutoConnect => 0 ),
                "$TestPrefix mirror object is connected",
            );

            $DBObject->Disconnect();

            $Self->False(
                scalar $DBObject->Ping( AutoConnect => 0 ),
                "$TestPrefix master object is disconnected",
            );

            $Self->False(
                scalar $DBObject->{MirrorDBObject}->Ping( AutoConnect => 0 ),
                "$TestPrefix mirror object is disconnected",
            );

            $DBObject->Connect();

            $Self->True(
                scalar $DBObject->Ping( AutoConnect => 0 ),
                "$TestPrefix master object is reconnected",
            );

            $Self->True(
                scalar $DBObject->{MirrorDBObject}->Ping( AutoConnect => 0 ),
                "$TestPrefix mirror object is not reconnected automatically",
            );
        }
    }
}

$Self->DoneTesting();
