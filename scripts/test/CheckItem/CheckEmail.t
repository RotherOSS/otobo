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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Email::Address::XS ();

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
my @CheckEmailTests = (

    # Invalid
    {
        Line  => __LINE__,
        Email => 'somebody',
        Valid => 0,
    },
    {
        Line        => __LINE__,
        Description => 'with phrase and with @ in address',
        Email       => '"just another" <somebody@somehost.com>',
        Valid       => 1,
    },
    {
        Line        => __LINE__,
        Description => 'with phrase and without @ in address',
        Email       => '"just another" <somebody>',
        Valid       => 0,
    },
    {
        Line  => __LINE__,
        Email => 'somebod y@somehost.com',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'ä@somehost.com',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => '.somebody@somehost.com',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'somebody.@somehost.com',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'some..body@somehost.com',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'some@body@somehost.com',
        Valid => 0,
    },
    {
        Line        => __LINE__,
        Description => 'Email is empty string',
        Email       => '',
        Valid       => 0,
    },
    {
        Line  => __LINE__,
        Email => 'foo=bar@[192.1233.22.2]',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'foo=bar@[192.22.2]',
        Valid => 0,
    },

    # Valid
    {
        Line  => __LINE__,
        Email => 'somebody@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'some.body@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'some+body@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'some-body@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'some_b_o_d_y@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'Some.Bo_dY.test.TesT@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => '_some.name@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => '-some.name-@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'name.surname@sometext.sometext.sometext',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'user/department@somehost.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => '#helpdesk@foo.com',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'foo=bar@domain.de',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'foo=bar@[192.123.22.2]',
        Valid => 1,
    },

    # Unicode domains
    {
        Line  => __LINE__,
        Email => 'mail@xn--f1aefnbl.xn--p1ai',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'mail@кц.рф',    # must be converted to IDN
        Valid => 0,
    },

    # Local part of email address is too long according to RFC.
    # See http://isemail.info/modperl-uc.1384763750.ffhelkebjhfdihihkbce-michiel.beijen%3Dotobo.org%40perl.apache.org
    {
        Line  => __LINE__,
        Email =>
            'modperl-uc.1384763750.ffhelkebjhfdihihkbce-michiel.beijen=otobo.org@perl.apache.org',
        Valid => 0,
    },

    # Complex addresses
    {
        Line  => __LINE__,
        Email => 'test@home.com (Test)',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => '"Test Test" <test@home.com>',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => '"Test Test" <test@home.com> (Test)',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'Test <test@home(Test).com>',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => '<test@home.com',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'test@home.com>',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'test@home.com(Test)',
        Valid => 1,
    },
    {
        Line  => __LINE__,
        Email => 'test@home.com>(Test)',
        Valid => 0,
    },
    {
        Line  => __LINE__,
        Email => 'Test <test@home.com> (Test)',
        Valid => 1,
    },

    # Tests with Email::Address::XS objects
    {
        Line          => __LINE__,
        Description   => 'AddressObject with @ in address',
        AddressObject => Email::Address::XS->new(
            'August Ausprobierer',
            'gustl@testanything.org'
        ),
        Valid => 1,
    },
    {
        Line          => __LINE__,
        Description   => 'AddressObject with @ in address and a comment',
        AddressObject => Email::Address::XS->new(
            'August Ausprobierer',
            'gustl@testanything.org',
            'probiert es aus',
        ),
        Valid => 1,
    },
    {

        # Email::Address::XS does not recognise an address without '@'
        Line          => __LINE__,
        Description   => 'AddressObject without @ in address and a comment',
        AddressObject => Email::Address::XS->new(
            'oil and',
            'water',
            'do not mix',
        ),
        Valid => 0,
    },
);

for my $Test (@CheckEmailTests) {

    # check address
    my $Valid = exists $Test->{AddressObject}
        ?
        $CheckItemObject->CheckEmail( AddressObject => $Test->{AddressObject} )
        :
        $CheckItemObject->CheckEmail( Address => $Test->{Email} );

    # some diagnostics
    if ( !$Valid ) {
        my $CheckErrorType = $CheckItemObject->CheckErrorType;
        diag "CheckErrorType: $CheckErrorType";

        my $CheckError = $CheckItemObject->CheckError;
        diag "CheckError: $CheckError";
    }

    # execute unit test
    my $Description = join ' - ', ( $Test->{Description} // $Test->{Email} // 'no description' ), "line $Test->{Line}";
    if ( $Test->{Valid} ) {
        ok( $Valid, "CheckEmail() valid - $Description" );
    }
    else {
        ok( !$Valid, "CheckEmail() invalid  - $Description" );
    }
}

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

done_testing;
