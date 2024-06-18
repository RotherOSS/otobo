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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $main::Self

our $Self;

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# ------------------------------------------------------------ #
# column name tests
# ------------------------------------------------------------ #

my @Tests = (
    {
        Name   => 'SELECT with named columns',
        SQL    => 'SELECT id, name FROM groups_table',
        Result => [qw(id name)],
    },
    {
        Name   => 'SELECT with all columns',
        SQL    => 'SELECT * FROM groups_table',
        Result => [qw(id name comments valid_id create_time create_by change_time change_by)],
    },
    {
        Name   => 'SELECT with unicode characters',
        SQL    => 'SELECT name AS äöüüßüöä FROM groups_table',
        Result => ['äöüüßüöä'],
    },
);

for my $Test (@Tests) {
    my $Result = $DBObject->Prepare(
        SQL => $Test->{SQL},
    );

    # get the column names of the current statement handle
    my @Names = $DBObject->GetColumnNames();

    # compare with the expected column names
    my $Counter = 0;
    for my $Field ( $Test->{Result}->@* ) {

        $Self->Is(
            lc $Names[$Counter],
            $Field,
            "GetColumnNames - field $Field - $Test->{Name}",
        );
        $Counter++;
    }
}

$Self->DoneTesting();
