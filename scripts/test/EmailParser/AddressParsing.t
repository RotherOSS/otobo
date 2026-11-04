# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use Kernel::System::EmailParser ();

# as stand alone mode, without parsing emails
my $EmailParserObject = Kernel::System::EmailParser->new(
    Mode  => 'Standalone',
    Debug => 0,
);

my @Addresses = $EmailParserObject->SplitAddressLine(
    Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber),
    Juergen "quoted name" Weber <juergen.qeber@air.com>',
);

is(
    $Addresses[2],
    'hans@example.com (Hans Huber)',
    "SplitAddressLine()",
);

is(
    $Addresses[3],
    'Juergen "quoted name" Weber <juergen.qeber@air.com>',
    "SplitAddressLine() with quoted name",
);

is(
    $EmailParserObject->GetEmailAddress( Email => 'Juergen Weber <juergen.qeber@air.com>' ),
    'juergen.qeber@air.com',
    "GetEmailAddress()",
);

is(
    $EmailParserObject->GetEmailAddress( Email => 'Juergen Weber <juergen+qeber@air.com>' ),
    'juergen+qeber@air.com',
    "GetEmailAddress() again",
);

is(
    $EmailParserObject->GetEmailAddress(
        Email => 'Juergen Weber <juergen+qeber@air.com> (Comment)'
    ),
    'juergen+qeber@air.com',
    "GetEmailAddress() with comment",
);

is(
    $EmailParserObject->GetEmailAddress( Email => 'juergen+qeber@air.com (Comment)' ),
    'juergen+qeber@air.com',
    "GetEmailAddress() with comment again",
);

is(
    $EmailParserObject->GetRealname( Email => '"Juergen "quoted name" Weber" <juergen.qeber@air.com>' ),
    'Juergen "quoted name" Weber',
    "GetRealname() with quoted name",
);

is(
    $EmailParserObject->GetRealname( Email => '"Juergen " quoted name " Weber" <juergen.qeber@air.com>' ),
    'Juergen "quoted name" Weber',
    "GetRealname() with quoted name",
);

done_testing;
