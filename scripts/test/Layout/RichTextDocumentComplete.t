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

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name   => 'Empty document',
        String => '123',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123</body></html>',
    },
    {
        Name   => 'Image with ContentID, no session',
        String =>
            '123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
    {
        Name   => 'Image with ContentID, with session',
        String =>
            '123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost;SessionID=123" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
    {
        Name   => 'Image with ContentID, with session',
        String =>
            '123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost&SessionID=123" /> 234',
        Result =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234</body></html>',
    },
);

for my $Test (@Tests) {
    my $Result = $LayoutObject->RichTextDocumentComplete(
        String => $Test->{String},
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name}",
    );
}

$Self->DoneTesting();
