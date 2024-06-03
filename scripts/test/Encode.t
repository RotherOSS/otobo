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

use Kernel::System::VariableCheck qw(:all);

# get encode object
my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

# convert tests
{
    use utf8;
    my @Tests = (
        {
            Name          => 'Convert()',
            Input         => 'abc123',
            Result        => 'abc123',
            InputCharset  => 'ascii',
            ResultCharset => 'utf8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123',
            Result        => 'abc123',
            InputCharset  => 'us-ascii',
            ResultCharset => 'utf8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123���',
            Result        => 'abc123���',
            InputCharset  => 'utf8',
            ResultCharset => 'utf8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123���',
            Result        => 'abc123���',
            InputCharset  => 'iso-8859-15',
            ResultCharset => 'utf8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123���',
            Result        => 'abc123���',
            InputCharset  => 'utf8',
            ResultCharset => 'utf-8',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123���',
            Result        => 'abc123���',
            InputCharset  => 'utf8',
            ResultCharset => 'iso-8859-15',
            UTF8          => 1,
        },
        {
            Name          => 'Convert()',
            Input         => 'abc123���',
            Result        => 'abc123???',
            InputCharset  => 'utf8',
            ResultCharset => 'iso-8859-1',
            Force         => 1,
            UTF8          => '',
        },
    );
    for my $Test (@Tests) {
        my $Result = $EncodeObject->Convert(
            Text  => $Test->{Input},
            From  => $Test->{InputCharset},
            To    => $Test->{ResultCharset},
            Force => $Test->{Force},
        );
        my $IsUTF8 = Encode::is_utf8($Result);
        $Self->True(
            $IsUTF8 eq $Test->{UTF8},
            $Test->{Name} . " is_utf8",
        );
        $Self->True(
            $Result eq $Test->{Result},
            $Test->{Name},
        );
    }
}

$Self->True(
    $EncodeObject->EncodingIsAsciiSuperset( Encoding => 'UTF-8' ),
    'UTF-8 is a superset of ASCII',
);
$Self->False(
    $EncodeObject->EncodingIsAsciiSuperset( Encoding => 'UTF-16-LE' ),
    'UTF-16 is a not superset of ASCII',
);

$Self->Is(
    $EncodeObject->FindAsciiSupersetEncoding(
        Encodings => [ 'UTF-7', 'UTF-16-LE', 'ISO-8859-1' ],
    ),
    'ISO-8859-1',
    'FindAsciiSupersetEncoding',
);

$Self->Is(
    $EncodeObject->FindAsciiSupersetEncoding(
        Encodings => ['UTF-7'],
    ),
    'ASCII',
    'FindAsciiSupersetEncoding falls back to ASCII',
);

$Self->DoneTesting();
