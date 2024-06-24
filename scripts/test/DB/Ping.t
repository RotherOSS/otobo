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

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my @TestsMofifiers = (
    {
        Name        => 'Autoconnect off - No connect after object creation',
        Command     => '',
        Success     => 0,
        AutoConnect => 0,
    },
    {
        Name        => 'Autoconnect off - Connected',
        Command     => 'Connect',
        Success     => 1,
        AutoConnect => 0,
    },
    {
        Name        => 'Autoconnect off - Diconnected',
        Command     => 'Disconnect',
        Success     => 0,
        AutoConnect => 0,
    },
    {
        Name        => 'Autoconnect off - Connected again',
        Command     => 'Connect',
        Success     => 1,
        AutoConnect => 0,
    },
    {
        Name        => 'Autoconnect off - Diconnected again',
        Command     => 'Disconnect',
        Success     => 0,
        AutoConnect => 0,
    },
    {
        Name        => 'Autoconnect on - Ping should connect automatically',
        Command     => '',
        Success     => 1,
        AutoConnect => 1,
    },
    {
        Name        => 'Autoconnect on - Ping should connect again after disconnected',
        Command     => 'Disconnect',
        Success     => 1,
        AutoConnect => 1,
    },
    {
        Name        => 'Autoconnect on - Already connected',
        Command     => 'Connect',
        Success     => 1,
        AutoConnect => 1,
    },
    {
        Name        => 'Autoconnect on - Already connected',
        Command     => 'Connect',
        Success     => 1,
        AutoConnect => 1,
    },
);

for my $TestCase (@TestsMofifiers) {

    my $Command = $TestCase->{Command} || '';
    if ($Command) {
        $DBObject->$Command();
    }

    my $Success = $DBObject->Ping(
        AutoConnect => $TestCase->{AutoConnect},
    );

    if ( $TestCase->{Success} ) {
        $Self->True(
            $Success,
            "$TestCase->{Name} - Ping() with true",
        );
    }
    else {
        $Self->False(
            $Success,
            "$TestCase->{Name} - Ping() with false",
        );
    }
}

$Self->DoneTesting();
