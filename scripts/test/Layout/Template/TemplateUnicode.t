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

use File::Basename qw();

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

# call Output() once so that the TT objects are created.
$LayoutObject->Output( Template => '' );

# now add this directory as include path to be able to use the test templates
my $IncludePaths = $LayoutObject->{TemplateProviderObject}->include_path();
unshift @{$IncludePaths},
    $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/test/Layout/Template';
$LayoutObject->{TemplateProviderObject}->include_path($IncludePaths);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

# uncached and cached
for ( 1 .. 2 ) {
    my $Result = $LayoutObject->Output(
        TemplateFile => 'TemplateUnicode',
    );

    $Self->Is(
        $Result,
        "some unicode content ä ø\n",
        'Template is considered UTF8',
    );
}

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
