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

my $Version = $DBObject->Version();

$Self->True(
    $Version,
    "DBObject Version() generated version $Version",
);

$Self->IsNot(
    $Version,
    'unknown',
    "DBObject Version() generated version $Version",
);

# extract text string and version number from Version
# just as a sanity check
my ( $Text, $Number ) = $Version =~ /(\w+)\s+([0-9\.]+)/;

$Self->True(
    $Text,
    "DBObject Version() $Version contains a name (found $Text)",
);

$Self->True(
    $Number,
    "DBObject Version() $Version contains a version number (found $Number)",
);

$Self->DoneTesting();
