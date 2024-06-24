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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my @CompareTests = (
    {
        Description => 'Source is missing, empty list is returned',
        Config      => {
            Target => 'Test 2',
        },
        ExpectedResult => {},
    },
    {
        Description => 'Target is missing, empty list is returned',
        Config      => {
            Source => 'Test 1',
        },
        ExpectedResult => {},
    },
    {
        Description => 'two different lines',
        Config      => {
            Source => 'Test 1',
            Target => 'Test 2',
        },
        ExpectedResult => {
            HTML => '<table class="DataTable diff">
<tr class=\'change\'><td><em>1</em></td><td><em>1</em></td><td>Test <del>1</del></td><td>Test <ins>2</ins></td></tr>
</table>
',
            Plain => <<'END_TXT',
@@ -1 +1 @@
-Test 1
\ No newline at end of file
+Test 2
\ No newline at end of file
END_TXT
        },
    },
);

my $DiffObject = $Kernel::OM->Get('Kernel::System::Diff');

for my $Test (@CompareTests) {
    my %Result = $DiffObject->Compare(
        $Test->{Config}->%*,
    );
    is( \%Result, $Test->{ExpectedResult}, $Test->{Description} );
}

done_testing;
