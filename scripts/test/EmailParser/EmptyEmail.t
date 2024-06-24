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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::EmailParser ();

our $Self;

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#9989
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/EmptyEmail.eml";    ## no critic qw(OTOBO::ProhibitOpen)
my @Array = <$IN>;
close $IN;

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    Email => \@Array,
);

my @Attachments = $EmailParserObject->GetAttachments();
$Self->Is(
    scalar @Attachments,
    2,
    "Attachments",
);

$Self->Is(
    $Attachments[0]->{Filename},
    'file-1',
    "Empty body name",
);

$Self->Is(
    $Attachments[0]->{Filesize},
    '0',
    "Empty body size",
);

$Self->Is(
    $Attachments[1]->{Filename},
    'Łatwa_sprawa.txt',
    "Empty attachment name",
);

$Self->Is(
    $Attachments[1]->{Filesize},
    '0',
    "Empty attachment size",
);

$Self->DoneTesting();
