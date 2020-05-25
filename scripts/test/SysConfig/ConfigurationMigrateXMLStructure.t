# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Config;

# get needed objects
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# load xml from samples
my $XML = $MainObject->FileRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->{Home} . '/scripts/test/sample/SysConfig/',
    Filename  => 'ConfigurationMigrateXMLStructure.xml',
    Mode      => 'utf8',
);

my $XMLExpected = $MainObject->FileRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->{Home} . '/scripts/test/sample/SysConfig/',
    Filename  => 'ConfigurationMigrateXMLStructureResult.xml',
    Mode      => 'utf8',
);
my @XMLExpectedSettings = split( '</Setting>', ${$XMLExpected} );

# Migrate
my $Result = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateXMLStructure(
    Content => ${$XML},
    Name    => 'MigrateXMLStructure',
);

my @ResultSettings = split( '</Setting>', $Result );

$Self->Is(
    scalar @ResultSettings,
    scalar @XMLExpectedSettings,
    "Compare Setting number."
);

INDEX:
for my $Index ( 0 .. scalar @ResultSettings - 1 ) {
    $Self->True(
        $XMLExpectedSettings[$Index],
        "Check if expected item exists [$Index]",
    );
    next INDEX if !$XMLExpectedSettings[$Index];

    # Get Description
    $XMLExpectedSettings[$Index] =~ m{<Description.*?>(.*?)</Description>};
    my $Title = $1 || 'Test without description';

    $Self->Is(
        $ResultSettings[$Index],
        $XMLExpectedSettings[$Index],
        $Title,
    );
}

1;
