# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

subtest 'ParseAddressLine()' => sub {

    my $EmailAddressObject = $Kernel::OM->Get('Kernel::System::EmailAddress');

    # Sample address line for testing ParseAddressLine().
    # Note that whitespace gets normalized into a single space. Line breaks are allowed.
    # Note that the address does not require the existence of an '@'.
    # A double quote character may appear in a phrase when it is escaped. This is a quoted-pairl
    my $Line = <<'END_OF_THE_LINE';
Juergen Weber <juergen.weber@air.com>, "Julia Weber" <julia.weber@air.com>,
 me@example.com, hans@example.com (Hans Huber),
  Juergen "quoted name" Weber <juergen.weber@air.com>    ,
   my     "🍏 🌳"<apple.tree@air.com>,
    no  at   symbol    <alice>  ( my team    lead   ) ,
END_OF_THE_LINE

    # Not adding
    # -->   " that \" is part of quoted pair" travelling@wilburys.org, <--
    # as Mail::Address seems to be confused about quoted pairs

    my @MailAddressObjects         = $EmailAddressObject->ParseAddressLine( Line => $Line );
    my @ExpectedMailAddressObjects = (
        bless(
            [
                'Juergen Weber',
                'juergen.weber@air.com',
                ''
            ],
            'Mail::Address'
        ),
        bless(
            [
                '"Julia Weber"',
                'julia.weber@air.com',
                ''
            ],
            'Mail::Address'
        ),
        bless(
            [
                '',
                'me@example.com',
                ''
            ],
            'Mail::Address'
        ),
        bless(
            [
                '',
                'hans@example.com',
                '(Hans Huber)'
            ],
            'Mail::Address'
        ),
        bless(
            [
                'Juergen "quoted name" Weber',
                'juergen.weber@air.com',
                ''
            ],
            'Mail::Address'
        ),
        bless(
            [
                "my \"\x{1f34f} \x{1f333}\"",
                'apple.tree@air.com',
                ''
            ],
            'Mail::Address'
        ),
        bless(
            [
                "no at symbol",
                'alice',
                '( my team    lead   )'
            ],
            'Mail::Address'
        ),
    );
    is(
        \@MailAddressObjects,
        \@ExpectedMailAddressObjects,
        'ParseAddressLine()',
    );
};

subtest 'GetAddress()' => sub {

    my $EmailAddressObject = $Kernel::OM->Get('Kernel::System::EmailAddress');

    is(
        $EmailAddressObject->GetAddress( Email => 'Juergen Weber <juergen.weber@air.com>' ),
        'juergen.weber@air.com',
        'with phrase and address',
    );

    is(
        $EmailAddressObject->GetAddress( Email => 'Juergen Weber <juergen+weber@air.com>' ),
        'juergen+weber@air.com',
        'address contains a +',
    );

    is(
        $EmailAddressObject->GetAddress(
            Email => 'Juergen Weber <juergen+weber@air.com> (Comment)'
        ),
        'juergen+weber@air.com',
        'with comment',
    );

    is(
        $EmailAddressObject->GetAddress( Email => 'juergen+weber@air.com (Comment)' ),
        'juergen+weber@air.com',
        'without a phrase and with comment',
    );

    is(
        $EmailAddressObject->GetAddress( Email => 'oil and <water> (do not mix)' ),
        undef,
        'address without @',
    );

    is(
        $EmailAddressObject->GetAddress(
            AddressObject => Mail::Address->new(
                'August Ausprobierer',
                'gustl@testanything.org'
            ),
        ),
        'gustl@testanything.org',
        'with an instance of Mail::Address'
    );

    is(
        $EmailAddressObject->GetAddress(
            AddressObject => Mail::Address->new(
                'oil and',
                'water',
                'do not mix',
            ),
        ),
        undef,
        'with an instance of Mail::Address, address without @'
    );
};

done_testing;
