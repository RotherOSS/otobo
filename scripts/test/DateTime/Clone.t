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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Timezones = ( 'UTC', 'Europe/Berlin' );

my @Tests = (
    {
        Title  => 'Current time',
        Params => {},
    },
    {
        Title  => 'For epoch 1414281600',
        Params => {
            Epoch => 1414281600,
        },
    },
);

for my $Timezone (@Timezones) {

    $ConfigObject->Set(
        Key   => 'OTOBOTimeZone',
        Value => $Timezone,
    );

    for my $Test (@Tests) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                %{ $Test->{Params} },
            },
        );
        my $ClonedDateTimeObject = $DateTimeObject->Clone();

        $Self->IsDeeply(
            $ClonedDateTimeObject->Get(),
            $DateTimeObject->Get(),
            "$Test->{Title} ($Timezone) Values of cloned DateTime object must match those of original object."
        );

        $Self->Is(
            $ClonedDateTimeObject->ToEpoch(),
            $DateTimeObject->ToEpoch(),
            "$Test->{Title} ($Timezone) Compare unix epoch time",
        );
        $Self->Is(
            $ClonedDateTimeObject->ToString(),
            $DateTimeObject->ToString(),
            "$Test->{Title} ($Timezone) Compare timestamp",
        );

        # Change cloned DateTime object, must not influence original object
        $ClonedDateTimeObject->Add( Days => 10 );
        $Self->IsNotDeeply(
            $ClonedDateTimeObject->Get(),
            $DateTimeObject->Get(),
            "$Test->{Title} ($Timezone) Changed values of cloned DateTime object must not influence those of original object."
        );

        $Self->IsNot(
            $ClonedDateTimeObject->ToEpoch(),
            $DateTimeObject->ToEpoch(),
            "$Test->{Title} ($Timezone) Compare updated unix epoch time",
        );

        $Self->IsNot(
            $ClonedDateTimeObject->ToString(),
            $DateTimeObject->ToString(),
            "$Test->{Title} ($Timezone) Compare updated timestamp",
        );
    }
}

$Self->DoneTesting();
