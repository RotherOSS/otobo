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
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name   => 'Simple Data',
        Input  => { 'Key1' => 'Value1' },
        Result => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":"Value1"});
//]]></script>
END_HTML
    },
    {
        Name  => 'More complex Data',
        Input => {
            'Key1' => {
                '1' => '2',
                '3' => '4'
            },
        },
        Result => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":{"1":"2","3":"4"}});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: empty string',
        Input => {
            'Key1' => '',
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":false});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: undef',
        Input => {
            'Key1' => undef,
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":false});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: 0',
        Input => {
            'Key1' => 0,
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":false});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: "0"',
        Input => {
            'Key1' => "0",
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":false});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: 1',
        Input => {
            'Key1' => 1,
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":true});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: -1',
        Input => {
            'Key1' => -1,
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":true});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: 2 > 1',
        Input => {
            'Key1' => 2 > 1,
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":true});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: "0 but true"',
        Input => {
            'Key1' => "0 but true",
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":true});
//]]></script>
END_HTML
    },
    {
        Name  => 'Boolean: "Blubber"',
        Input => {
            'Key1' => "Blubber",
        },
        AddJSBoolean => 1,
        Result       => <<'END_HTML',

<script type="text/javascript">//<![CDATA[
"use strict";
Core.Config.AddConfig({"Key1":true});
//]]></script>
END_HTML
    },
);

for my $Test (@Tests) {

    for my $Key ( sort keys %{ $Test->{Input} } ) {
        if ( $Test->{AddJSBoolean} ) {
            $LayoutObject->AddJSBoolean(
                Key   => $Key,
                Value => $Test->{Input}->{$Key}
            );
        }
        else {
            $LayoutObject->AddJSData(
                Key   => $Key,
                Value => $Test->{Input}->{$Key}
            );
        }
    }

    my $Output = $LayoutObject->Output(
        Template => '',
        Data     => {},
        AJAX     => 1,
    );
    is(
        $Output,
        $Test->{Result},
        $Test->{Name},
    );
}

done_testing;
