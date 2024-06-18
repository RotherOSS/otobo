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

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Tests = (
    {
        Name   => 'Simple test',
        Params => {
            Name => 'test',
            Data => {
                1 => 'Testqueue',
            },
        },
        ResultTree => '<select name="test" id="test" class="" data-tree="true"   >
<option value="1">Testqueue</option>
</select>
',
        ResultList => '<select id="test" name="test">
  <option value="1">Testqueue</option>
</select>',
    },
    {
        Name   => 'Posible empty selection',
        Params => {
            Name => 'test',
            Data => {
                1     => 'Testqueue',
                '||-' => '-',
            },
        },
        ResultTree => '<select name="test" id="test" class="" data-tree="true"   >
<option value="||-">-</option>
<option value="1">Testqueue</option>
</select>
',
        ResultList => '<select id="test" name="test">
  <option value="||-">-</option>
  <option value="1">Testqueue</option>
</select>',
    },
    {
        Name   => 'Special empty selection: - Move -',
        Params => {
            Name => 'test',
            Data => {
                1     => 'Testqueue',
                '||-' => '- Move -',
            },
        },
        ResultTree => '<select name="test" id="test" class="" data-tree="true"   >
<option value="||-">- Move -</option>
<option value="1">Testqueue</option>
</select>
',
        ResultList => '<select id="test" name="test">
  <option value="||-">- Move -</option>
  <option value="1">Testqueue</option>
</select>',
    },
    {
        Name   => 'Special characters',
        Params => {
            Name => 'test',
            Data => {
                '1||"><script>alert(\'hey there\');</script>' => '"><script>alert(\'hey there\');</script>',
            },
        },
        ResultTree => q{<select name="test" id="test" class="" data-tree="true"   >
<option value="1||&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;">&quot;&gt;&lt;script&gt;alert('hey there');&lt;/script&gt;</option>
</select>
},
        ResultList => q{<select id="test" name="test">
  <option value="1||"><script>alert('hey there');</script>">"><script>alert('hey there');</script></option>
</select>},
    },

);

for my $ListType (qw(tree list)) {

    $ConfigObject->Set(
        Key   => 'Ticket::Frontend::ListType',
        Value => $ListType,
    );

    my $ResultType = ( $ListType eq 'tree' ) ? 'ResultTree' : 'ResultList';

    # Test creating queue list option for tree/list ListType.
    for my $Test (@Tests) {
        my $Result = $LayoutObject->AgentQueueListOption( %{ $Test->{Params} } );

        $Self->Is(
            $Result,
            $Test->{$ResultType},
            $Test->{Name} . ' ' . $ListType . ' ListType',
        );
    }
}

$Self->DoneTesting();
