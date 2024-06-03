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
use v5.24;
use utf8;

# core modules
use Encode();

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self (unused) and $Kernel::OM

# get needed objects
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

# disable DNS lookups
$ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# email address checks
my @Tests = (

    # Invalid
    {
        Email => 'somebody',
        Valid => 0,
    },
    {
        Email => 'somebod y@somehost.com',
        Valid => 0,
    },
    {
        Email => 'ä@somehost.com',
        Valid => 0,
    },
    {
        Email => '.somebody@somehost.com',
        Valid => 0,
    },
    {
        Email => 'somebody.@somehost.com',
        Valid => 0,
    },
    {
        Email => 'some..body@somehost.com',
        Valid => 0,
    },
    {
        Email => 'some@body@somehost.com',
        Valid => 0,
    },
    {
        Email => '',
        Valid => 0,
    },
    {
        Email => 'foo=bar@[192.1233.22.2]',
        Valid => 0,
    },
    {
        Email => 'foo=bar@[192.22.2]',
        Valid => 0,
    },

    # Valid
    {
        Email => 'somebody@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some.body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some+body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some-body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some_b_o_d_y@somehost.com',
        Valid => 1,
    },
    {
        Email => 'Some.Bo_dY.test.TesT@somehost.com',
        Valid => 1,
    },
    {
        Email => '_some.name@somehost.com',
        Valid => 1,
    },
    {
        Email => '-some.name-@somehost.com',
        Valid => 1,
    },
    {
        Email => 'name.surname@sometext.sometext.sometext',
        Valid => 1,
    },
    {
        Email => 'user/department@somehost.com',
        Valid => 1,
    },
    {
        Email => '#helpdesk@foo.com',
        Valid => 1,
    },
    {
        Email => 'foo=bar@domain.de',
        Valid => 1,
    },
    {
        Email => 'foo=bar@[192.123.22.2]',
        Valid => 1,
    },

    # Unicode domains
    {
        Email => 'mail@xn--f1aefnbl.xn--p1ai',
        Valid => 1,
    },
    {
        Email => 'mail@кц.рф',    # must be converted to IDN
        Valid => 0,
    },

    # Local part of email address is too long according to RFC.
    # See http://isemail.info/modperl-uc.1384763750.ffhelkebjhfdihihkbce-michiel.beijen%3Dotobo.org%40perl.apache.org
    {
        Email =>
            'modperl-uc.1384763750.ffhelkebjhfdihihkbce-michiel.beijen=otobo.org@perl.apache.org',
        Valid => 0,
    },

    # Complex addresses
    {
        Email => 'test@home.com (Test)',
        Valid => 1,
    },
    {
        Email => '"Test Test" <test@home.com>',
        Valid => 1,
    },
    {
        Email => '"Test Test" <test@home.com> (Test)',
        Valid => 1,
    },
    {
        Email => 'Test <test@home(Test).com>',
        Valid => 1,
    },
    {
        Email => '<test@home.com',
        Valid => 0,
    },
    {
        Email => 'test@home.com>',
        Valid => 0,
    },
    {
        Email => 'test@home.com(Test)',
        Valid => 1,
    },
    {
        Email => 'test@home.com>(Test)',
        Valid => 0,
    },
    {
        Email => 'Test <test@home.com> (Test)',
        Valid => 1,
    },

);

for my $Test (@Tests) {

    # check address
    my $Valid = $CheckItemObject->CheckEmail( Address => $Test->{Email} );

    # execute unit test
    if ( $Test->{Valid} ) {
        ok( $Valid, "CheckEmail() - $Test->{Email}" );
    }
    else {
        ok( !$Valid, "CheckEmail() - $Test->{Email}" );
    }
}

# string clean tests
@Tests = (
    {
        String => ' ',
        Params => {},
        Result => '',
    },
    {
        String => undef,
        Params => {},
        Result => undef,
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {},
        Result => "Test\n\r\t test\n\r\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 1,
            TrimRight => 0,
        },
        Result => "Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 0,
            TrimRight => 1,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 0,
            TrimRight => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "Test\t test\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 0,
        },
        Result => "Test\n\r test\n\r Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 1,
        },
        Result => "Test\n\r\ttest\n\r\tTest",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "\t Test\t test\t Test\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 0,
        },
        Result => "\n\r Test\n\r test\n\r Test\n\r ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 1,
        },
        Result => "\n\r\tTest\n\r\ttest\n\r\tTest\n\r\t",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        },
        Result => "TesttestTest",
    },

    # strip invalid utf8 characters
    {
        String => 'aäöüß€z',
        Params => {},
        Result => 'aäöüß€z',
    },
    {
        String => eval { my $String = "a\372z"; Encode::_utf8_on($String); $String },    # iso-8859 string
        Params => {},
        Result => undef,
    },
    {
        String => eval {'aúz'},                                                         # utf-8 string
        Params => {},
        Result => 'aúz',
    },
);

for my $Test (@Tests) {

    # copy string to leave the original untouched
    my $String = $Test->{String};

    # start string preparation
    my $StringRef = $CheckItemObject->StringClean(
        StringRef => \$String,
        %{ $Test->{Params} },
    );

    # check result
    is(
        ${$StringRef},
        $Test->{Result},
        'TrimTest',
    );
}

# credit card tests
@Tests = (
    {
        String => '4111 1111 1111 1111',
        Found  => 1,
        Result => '4111 XXXX XXXX 1111',
    },
    {
        String => '4111+1111+1111+1111',
        Found  => 1,
        Result => '4111+XXXX+XXXX+1111',
    },
    {
        String => '-4111+1111+1111+1111-',
        Found  => 1,
        Result => '-4111+XXXX+XXXX+1111-',
    },
    {
        String => '-4111+1111+1111+11-',
        Found  => 0,
        Result => '-4111+1111+1111+11-',
    },
    {
        String => '6011.0000/0000.0004',
        Found  => 1,
        Result => '6011.XXXX/XXXX.0004',
    },
    {
        String => '3400/0000/0000/009',
        Found  => 1,
        Result => '3400/XXXX/XXXX/009',
    },
    {
        String => '#5500.00000000.0004',
        Found  => 1,
        Result => '#5500.XXXXXXXX.0004',
    },
    {
        String => '#5500.00000000.0004.',
        Found  => 1,
        Result => '#5500.XXXXXXXX.0004.',
    },
    {
        String => "#5500.00000000.0004\n",
        Found  => 1,
        Result => "#5500.XXXXXXXX.0004\n",
    },
    {
        String => ":5500.00000000.0004\n",
        Found  => 1,
        Result => ":5500.XXXXXXXX.0004\n",
    },
    {
        String => "(5500.00000000.0004)\n",
        Found  => 1,
        Result => "(5500.XXXXXXXX.0004)\n",
    },
    {
        String => '#5500.00000000.00045.',
        Found  => 0,
        Result => '#5500.00000000.00045.',
    },
    {
        String => 'A5500.00000000.00045.',
        Found  => 0,
        Result => 'A5500.00000000.00045.',
    },
);
for my $Test (@Tests) {

    # copy string to leave the original untouched
    my $String = $Test->{String};

    # start string preparation
    my ( $StringRef, $Found ) = $CheckItemObject->CreditCardClean( StringRef => \$String );

    # check result
    is(
        $Found,
        $Test->{Found},
        'CreditCardClean - Found',
    );
    is(
        ${$StringRef},
        $Test->{Result},
        'CreditCardClean - String',
    );
}

# reenable DNS lookups
$ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 1,
);

my $Result = $CheckItemObject->CheckEmail( Address => 'some..body@example.com' );

# Execute unit test.
ok(
    !$Result,
    "CheckEmail() - 'some..body\@example.com'",
);

is(
    $CheckItemObject->CheckError(),
    'invalid some..body@example.com (Invalid syntax)! ',
    "CheckError() - 'some..body\@example.com'",
);

$Result = $CheckItemObject->CheckEmail( Address => 'somebody123456789@otobo.org' );

# Execute unit test.
ok(
    $Result,
    "CheckEmail() - 'somebody123456789\@otobo.org'",
);

done_testing();
