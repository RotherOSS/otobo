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

# Prevent used once warning.
use Kernel::System::ObjectManager;

my @CompareTests = (
    {
        Description => 'Test #1 - missing Source',
        Config      => {
            Target => 'Test 2',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Test #2 - missing Target',
        Config      => {
            Source => 'Test 1',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Test #3',
        Config      => {
            Source => 'Test 1',
            Target => 'Test 2',
        },
        ExpectedResult => {
            HTML => '<table class="DataTable diff">
<tr class=\'change\'><td><em>1</em></td><td><em>1</em></td><td>Test <del>1</del></td><td>Test <ins>2</ins></td></tr>
</table>
',
            Plain =>
                '<div class="file"><span class="fileheader"></span><div class="hunk"><span class="hunkheader">@@ -1 +1 @@
</span><del>- Test 1</del><ins>+ Test 2</ins><span class="hunkfooter"></span></div><span class="filefooter"></span></div>'
        },
    },
);

my $DiffObject = $Kernel::OM->Get('Kernel::System::Diff');

for my $Test (@CompareTests) {
    my %Result = $DiffObject->Compare(
        %{ $Test->{Config} },
    );

    if (%Result) {
        $Self->IsDeeply(
            \%Result,
            $Test->{ExpectedResult},
            $Test->{Description},
        );
    }
    else {
        $Self->False(
            $Test->{ExpectedResult},
            $Test->{Description},
        );
    }
}

$Self->DoneTesting();
