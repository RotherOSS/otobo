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
use Email::Address::XS ();
use Mail::Address      ();

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
    # as Email::Address::XS seems to be confused about quoted pairs

    my @MailAddressObjects         = $EmailAddressObject->ParseAddressLine( Line => $Line );
    my @ExpectedMailAddressObjects = (
        bless(
            {
                comment  => undef,
                host     => "air.com",
                original => "Juergen Weber <juergen.weber\@air.com>",
                phrase   => "Juergen Weber",
                user     => "juergen.weber",
            },
            "Email::Address::XS"
        ),
        bless(
            {
                comment  => undef,
                host     => "air.com",
                original => "\"Julia Weber\" <julia.weber\@air.com>",
                phrase   => "Julia Weber",
                user     => "julia.weber",
            },
            "Email::Address::XS"
        ),
        bless(
            {
                comment  => undef,
                host     => "example.com",
                original => "me\@example.com",
                phrase   => undef,
                user     => "me",
            },
            "Email::Address::XS"
        ),
        bless(
            {
                comment  => "Hans Huber",
                host     => "example.com",
                original => "hans\@example.com (Hans Huber)",
                phrase   => undef,
                user     => "hans",
            },
            "Email::Address::XS"
        ),
        bless(
            {
                comment  => undef,
                host     => "air.com",
                original => "Juergen \"quoted name\" Weber <juergen.weber\@air.com>    ",
                phrase   => "Juergen quoted name Weber",
                user     => "juergen.weber",
            },
            "Email::Address::XS"
        ),
        bless(
            {
                comment  => undef,
                host     => "air.com",
                original => "my     \"\x{1F34F} \x{1F333}\"<apple.tree\@air.com>",
                phrase   => "my \x{1F34F} \x{1F333}",
                user     => "apple.tree",
            },
            "Email::Address::XS"
        ),
        bless(
            {
                comment  => " my team    lead   ",
                host     => undef,
                invalid  => 1,
                original => "no  at   symbol    <alice>  ( my team    lead   ) ",
                phrase   => "no at symbol",
                user     => "alice",
            },
            "Email::Address::XS"
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
        $EmailAddressObject->GetAddress( Email => 'Juergen Weber <juergen+weber@air.com> (Comment)' ),
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
            AddressObject => Email::Address::XS->new(
                'August Ausprobierer',
                'gustl@testanything.org'
            ),
        ),
        'gustl@testanything.org',
        'with an instance of Email::Address::XS'
    );

    is(
        $EmailAddressObject->GetAddress(
            AddressObject => Email::Address::XS->new(
                'oil and',
                'water',
                'do not mix',
            ),
        ),
        undef,
        'instance of Email::Address::XS, address without @'
    );
};

subtest 'GetRealName()' => sub {

    my $EmailAddressObject = $Kernel::OM->Get('Kernel::System::EmailAddress');

    is(
        $EmailAddressObject->GetRealName( Email => '"Juergen "quoted name" Weber" <juergen.weber@air.com>' ),
        'Juergen  quoted name  Weber',
        q{space after 'Juergen' and before 'Weber' is protected},
    );

    is(
        $EmailAddressObject->GetRealName( Email => '"Juergen " quoted name " Weber" <juergen.weber@air.com>' ),
        'Juergen  quoted name  Weber',
        q{space after 'Juergen' and before 'Weber' is protected, other spaces aren't},
    );

    note 'tests with parts of the phrase in quotes';

    is(
        $EmailAddressObject->GetRealName( Email => q{bronce silver "gold" <medals@olympic.games>} ),
        'bronce silver gold',
        'last word in quotes',
    );

    is(
        $EmailAddressObject->GetRealName( Email => q{bronce "silver" gold <medals@olympic.games>} ),
        'bronce silver gold',
        'middle word in quotes',
    );

    is(
        $EmailAddressObject->GetRealName( Email => q{bronce "silver gold" <medals@olympic.games>} ),
        'bronce silver gold',
        'last two words in quotes',
    );

    is(
        $EmailAddressObject->GetRealName( Email => q{bronce "silver" "gold" <medals@olympic.games>} ),
        'bronce silver gold',
        'last two words each in quotes',
    );

    is(
        $EmailAddressObject->GetRealName( Email => q{"bronce silver gold" <medals@olympic.games>} ),
        'bronce silver gold',
        'three words in quotes',
    );

    is(
        $EmailAddressObject->GetRealName( Email => q{"bronce" silver "gold" <medals@olympic.games>} ),
        'bronce silver gold',
        'first and last word in quotes',
    );

    is(
        $EmailAddressObject->GetRealName( Email => q{"bronce""silver""gold" <medals@olympic.games>} ),
        'bronce silver gold',
        'each word in quotes, no spaces',
    );

    is(
        $EmailAddressObject->GetRealName( Email => q{"\\"bronce\\"\\"silver\\"\\"gold\\"" <medals@olympic.games>} ),
        q{"bronce""silver""gold"},
        'each word in quoted quotes, no spaces',
    );

    note 'tests passing an address object';

    is(
        $EmailAddressObject->GetRealName(
            AddressObject => Email::Address::XS->new(
                'Erna Extremtesterin',
                'extremerna@testanything.org'
            ),
        ),
        'Erna Extremtesterin',
        'with an instance of Email::Address::XS'
    );
};

subtest 'Format()' => sub {

    my $EmailAddressObject = $Kernel::OM->Get('Kernel::System::EmailAddress');

    my $AddressObject = Email::Address::XS->new(
        'Erna Extremtesterin',
        'extremerna@testanything.org',
        'extreme testing is good',
    );
    my $FormattedAddress = $EmailAddressObject->Format(
        AddressObject => $AddressObject,
    );
    is(
        $FormattedAddress,
        '"Erna Extremtesterin" <extremerna@testanything.org> (extreme testing is good)',
        'Format phrase, address, and comment'
    );

    is(
        $EmailAddressObject->Format(
            Email => 'dummy <dummy@testanything.org>,  Erna Extremtesterin     <extremerna@testanything.org>   ',
        ),
        '"Erna Extremtesterin" <extremerna@testanything.org>',
        'last address in address list',
    );

    is(
        $EmailAddressObject->Format(
            Some => 'Dummy',
            Para => 'Meter'
        ),
        '',
        'empty string as fallback'
    );

    is(
        $EmailAddressObject->Format( RealName => 'Ben 🐛 Bugfinder' ),
        '',
        'only the phrase'
    );

    is(
        $EmailAddressObject->Format( Address => 'bugfinder@testanything.org' ),
        'bugfinder@testanything.org',
        'only the address'
    );

    is(
        $EmailAddressObject->Format(
            RealName => 'Ben 🐛 Bugfinder',
            Address  => 'bugfinder@testanything.org'
        ),
        '"Ben 🐛 Bugfinder" <bugfinder@testanything.org>',
        'phrase and address'
    );
};

subtest 'Email::Address::XS vs Mail::AddressⅠ' => sub {
    diag q{Email::Address::XS requires an '@' in the address};

    my $Phrase           = 'August Ausprobierer';
    my $AddressWithoutAt = 'gustl';

    my $OldObject = Mail::Address->new( $Phrase, $AddressWithoutAt );

    is(
        $OldObject->phrase,
        $Phrase,
        'phrase for Mail::Address'
    );
    is(
        $OldObject->address,
        $AddressWithoutAt,
        'Mail::Address accepts no @ in address'
    );
    is(
        $OldObject->format,
        q{August Ausprobierer <gustl>},
        'Mail::Address has formatted address without quotes and address without @',
    );

    my $NewObject = Email::Address::XS->new( $Phrase, $AddressWithoutAt );

    is(
        $NewObject->phrase,
        $Phrase,
        'phrase for Email::Address::XS'
    );
    is(
        $NewObject->address,
        undef,
        'Email::Address::XS requires @ in address'
    );
    is(
        $NewObject->format,
        q{},
        'Email::Address::XS requires @ in address for the formatted address',
    );
};

subtest 'Email::Address::XS vs Mail::Address Ⅱ' => sub {
    diag 'quotes around phrase with a space';

    my $PhraseWithSpaces = 'Евгений Васильев Новоподзалупинский';
    my $Address          = 'xxzzyy@gmail.com';

    my $OldObject = Mail::Address->new( $PhraseWithSpaces, $Address );

    is(
        $OldObject->phrase,
        $PhraseWithSpaces,
        'phrase for Mail::Address'
    );
    is(
        $OldObject->address,
        $Address,
        'Mail::Address with a regular address'
    );
    is(
        $OldObject->format,
        q{Евгений Васильев Новоподзалупинский <xxzzyy@gmail.com>},
        'Mail::Address does not add quotes when there are spaces',
    );

    my $NewObject = Email::Address::XS->new( $PhraseWithSpaces, $Address );

    is(
        $NewObject->phrase,
        $PhraseWithSpaces,
        'phrase for Email::Address::XS'
    );
    is(
        $NewObject->address,
        $Address,
        'Email::Address::XS with a regular address'
    );
    is(
        $NewObject->format,
        q{"Евгений Васильев Новоподзалупинский" <xxzzyy@gmail.com>},
        'Email::Address::XS adds quotes when there are spaces',
    );
};

done_testing;
