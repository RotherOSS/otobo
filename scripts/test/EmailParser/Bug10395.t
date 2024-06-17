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

use Kernel::System::EmailParser;

# This test should verify that an email with an unknown encoding not cause a "die".

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#1970
my @Array;
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/Bug10395.box";    ## no critic qw(OTOBO::ProhibitOpen)
while (<$IN>) {
    push @Array, $_;
}
close $IN;

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    Email => \@Array,
);

$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'From' ),
    '"dev.mydomain.somewhere - Oddział 3 w Warszawie, testtes A1" <dev@ib.pl>',
    'Check complicated to header',
);

$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'Cc' ),
    '"dev.mydomain.somewhere - Oddział 3 w Warszawie, testtes A1" <dev@ib.pl>, "dev.mydomain.somewhere - Oddział 3 w Warszawie, testtes A1" <dev@ib.pl>, "dev.mydomain.somewhere - Oddział 3 w Warszawie, testtes A1" <dev@ib.pl>',
    'Check complicated to header',
);

$Self->DoneTesting();
