# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::ObjectManager;

my @Tests = (
    {
        Description         => 'empty table name',
        UnquotedTable       => q{},
        ExpectedQuotedTable => undef,
    },
    {
        Description         => 'strange numeric table name, but can be quoted',
        UnquotedTable       => q{17},
        ExpectedQuotedTable => q{`17`},
    },
    {
        Description         => 'groups is reserved on MySQL 8',
        UnquotedTable       => q{groups},
        ExpectedQuotedTable => q{`groups`},
    },
    {
        Description         => 'funny name with space',
        UnquotedTable       => q{funny name},
        ExpectedQuotedTable => q{`funny name`},
    },
    {
        Description         => 'funny name with single quote',
        UnquotedTable       => q{funny'name},
        ExpectedQuotedTable => q{`funny'name`},
    },
    {
        Description         => 'funny name with backtick',
        UnquotedTable       => q{funny`name},
        ExpectedQuotedTable => q{`funny``name`},
    },
);

plan( scalar @Tests );

$Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-otobo.UnitTest',
    },
);

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

for my $Test ( @Tests ) {
    is(
        $DBObject->QuoteIdentifier( Table => $Test->{UnquotedTable} ),
        $Test->{ExpectedQuotedTable},
        $Test->{Description},
    );
}
