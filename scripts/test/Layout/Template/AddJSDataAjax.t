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
        Name   => 'Simple Data',
        Input  => { 'Key1' => 'Value1' },
        Result => '
<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":"Value1"});
//]]></script>',
    },
    {
        Name  => 'More complex Data',
        Input => {
            'Key1' => {
                '1' => '2',
                '3' => '4'
            }
        },
        Result => '
<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":{"1":"2","3":"4"}});
//]]></script>',
    },
);

for my $Test (@Tests) {

    for my $JSData ( sort keys %{ $Test->{Input} } ) {
        $LayoutObject->AddJSData(
            Key   => $JSData,
            Value => $Test->{Input}->{$JSData}
        );
    }

    my $Output = $LayoutObject->Output(
        Template => '',
        Data     => {},
        AJAX     => 1,
    );

    $Self->Is(
        $Output,
        $Test->{Result},
        $Test->{Name},
    );
}

$Self->DoneTesting();
