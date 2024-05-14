# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::EmailParser ();

our $Self;

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#1970
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/NestedMessage-Test1.box";    ## no critic qw(OTOBO::ProhibitOpen)
my @Array = <$IN>;
close $IN;

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    Email => \@Array,
);

my @Attachments = $EmailParserObject->GetAttachments();
$Self->Is(
    scalar @Attachments,
    3,
    "Found 3 files (plain, html and attachment for nested message)",
);

$Self->Is(
    $Attachments[2]->{Filename} || '',
    '_Presse-Greenpeace__Morgen_wird_Greenpeace-Einspruch_gegenEmbryonen-Patent_verhandelt_-_NeueDokumentation_ueber_Patente_auf_Leben.eml',
    "Nested message filename",
);

$Self->DoneTesting();
