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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $XXEFilename  = $ConfigObject->Get('Home') . '/var/tmp/XXE.t.txt';

# Write XXE payload.
# XXE stands for XML External Entitiy. Providing XML with external entities is a method of security attacks
unlink $XXEFilename;
my $FileCreated = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
    Location => $XXEFilename,
    Content  => \"XXE",
);
$Self->True(
    $FileCreated,
    'XXE payload written.',
);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'XMLParse',
);

my $XML = <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE r [
<!ELEMENT r ANY >
<!ENTITY sp SYSTEM "$XXEFilename">
]>
<test_xml>Node &sp;</test_xml>
EOF

my $XMLObject       = $Kernel::OM->Get('Kernel::System::XML');
my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

$Self->Is(
    [ $XMLObject->XMLParse( String => $XML ) ]->[0]->{Content},
    "Node ",
    'K::S::XML XXE check.',
);

$Self->Is(
    $XMLSimpleObject->XMLIn( XMLInput => $XML ),
    "Node ",
    'K::S::XML::Simple XXE check.',
);

# Clean-up
unlink $XXEFilename;

$Self->DoneTesting();
