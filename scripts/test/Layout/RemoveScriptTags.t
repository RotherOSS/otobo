# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

# Tests for _RemoveScriptTags method
my @Tests = (
    {
        Input  => '',
        Result => '',
        Name   => '_RemoveScriptTags - empty test',
    },
    {
        Input  => '<script type="text/javascript"></script>',
        Result => '',
        Name   => '_RemoveScriptTags - just tags test',
    },
    {
        Input => '
<script type="text/javascript">
    123
    // 456
    789
</script>',
        Result => '

    123
    // 456
    789
',
        Name => '_RemoveScriptTags - some content test',
    },
    {
        Input => '
<script type="text/javascript">//<![CDATA[
    OTOBO.UI.Tables.InitTableFilter($(\'#FilterCustomers\'), $(\'#Customers\'));
    OTOBO.UI.Tables.InitTableFilter($(\'#FilterGroups\'), $(\'#Groups\'));
//]]></script>
        ',
        Result => '

    OTOBO.UI.Tables.InitTableFilter($(\'#FilterCustomers\'), $(\'#Customers\'));
    OTOBO.UI.Tables.InitTableFilter($(\'#FilterGroups\'), $(\'#Groups\'));

        ',
        Name => '_RemoveScriptTags - complete content test',
    },
    {
        Input => <<'EOF',
<!--DocumentReadyActionRowAdd-->
<script type="text/javascript">  //<![CDATA[
   alert();
//]]></script>
<!--/DocumentReadyActionRowAdd-->
<!--DocumentReadyStart-->
<script type="text/javascript">//  <![CDATA[
   alert();
//]]></script>
<!--/DocumentReadyStart-->
EOF
        Result => <<"EOF",

   alert();
\n
   alert();

EOF
        Name => '_RemoveScriptTags - complete content test with block comments',
    },
    {
        Input => <<'EOF',
<script type="text/javascript">  //<![CDATA[
<!--DocumentReadyActionRowAdd-->
   alert();
<!--/DocumentReadyActionRowAdd-->
//]]></script>
EOF
        Result => <<"EOF",

   alert();

EOF
        Name =>
            '_RemoveScriptTags - complete content test with block comments inside the script tags',
    },
);

for my $Test (@Tests) {
    my $LRST = $LayoutObject->_RemoveScriptTags(
        Code => $Test->{Input},
    );
    $Self->Is(
        $LRST,
        $Test->{Result},
        $Test->{Name},
    );
}

$Self->DoneTesting();
