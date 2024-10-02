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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get HTMLUtils object
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

# DocumentCleanup tests
my @Tests = (
    {
        Input  => 'Some Tex<b>t</b>',
        Result => 'Some Tex<b>t</b>',
        Name   => 'DocumentCleanup - bold, no changes'
    },
    {
        Input  => '<blockquote>Some Tex<b>t</b></blockquote>',
        Result => '<blockquote>Some Tex<b>t</b></blockquote>',
        Name   => 'DocumentCleanup - blockquote - not replaced'
    },
    {
        Input  => '<blockquote>Some Tex<b>t</b><blockquote>test</blockquote> </blockquote>',
        Result => '<blockquote>Some Tex<b>t</b><blockquote>test</blockquote> </blockquote>',
        Name   => 'DocumentCleanup - nested blockquote - not replaced'
    },
    {
        Input  => '<head><base href=3D"file:///C:\Users\dol\AppData\Local\Temp\SnipFile-%7b102B7C0B-D396-440B-9DD6-DD3342805533%7d.HTML"></head>',
        Result => '<head></head>',
        Name   => 'DocumentCleanup - base tag',
    },
    {
        Input  => '<head><baSe href=3D"file:///C:\Users\dol\AppData\Local\Temp\SnipFile-%7b102B7C0B-D396-440B-9DD6-DD3342805533%7d.HTML"></head>',
        Result => '<head></head>',
        Name   => 'DocumentCleanup - baSe tag',
    },
    {
        Input =>
            '<HEAD><TITLE>Aufzeichnung</TITLE>
<META content=3D"text/html; charset=3Dus-ascii" http-equiv=3DContent-Type><=
BASE=20
href=3D"file:///C:/Users/goi/AppData/Local/Temp/SnipFile-%7B77CE7BE6-0C04-4=
CED-898D-4ECC17BCA028%7D.HTML">
</HEAD>',
        Result => '<HEAD><TITLE>Aufzeichnung</TITLE>
<META content=3D"text/html; charset=3Dus-ascii" http-equiv=3DContent-Type><=
BASE=20
href=3D"file:///C:/Users/goi/AppData/Local/Temp/SnipFile-%7B77CE7BE6-0C04-4=
CED-898D-4ECC17BCA028%7D.HTML">
</HEAD>',
        Name => 'DocumentCleanup - BASE tag',
    },
);

for my $Test (@Tests) {
    my $HTML = $HTMLUtilsObject->DocumentCleanup(
        String => $Test->{Input},
    );
    is(
        $HTML,
        $Test->{Result},
        $Test->{Name},
    );
}

done_testing;
