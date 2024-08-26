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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

### Setting up

my $TestCSSFilePath = 'scripts/test/HTMLUtils/CSSForTesting.css';
my $TestCustomCSS = ':root{color:red;}';
$Helper->ConfigSettingChange(
    Key   => 'Frontend::RichText::DefaultCSS',
    Value => $TestCustomCSS,
    Valid => 1,
);
$Helper->ConfigSettingChange(
    Key   => 'Frontend::RichTextArticleStyles',
    Value => $TestCSSFilePath,
    Valid => 1,
);



# DocumentComplete tests
my @Tests = (
    # test if regular text is correctly wrapped in html 
    {
        Input  => 'Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
        Result => <<'END_HTML',
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <style>div{color:red;background:blue;}</style>    
</head>
<body style="color:green;">
    Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW
</body>
</html>
END_HTML
        Name => 'text without markup'
    },
    # test if text containing markup tags is correctly wrapped in html 
    {
        Input  => 'Some <b> Bold Text</b> ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
        Result => <<'END_HTML',
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <style>div{color:red;background:blue;}</style>    
</head>
<body style="color:green;">
    Some <b> Bold Text</b> ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW
</body>
</html>
END_HTML
        Name => 'text with markup'
    },
    # test if text wrapped in html and body tags is returned unchanged
    {
        Input  => '<html><body>Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>',
        Result => <<'END_HTML',
<html>
<body>
    Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW
</body>
</html>
END_HTML
        Name => 'document already complete'
    },
);

for my $Test (@Tests) {
    my $CompletedHTML = $HTMLUtilsObject->DocumentComplete(
        String => $Test->{Input},
    );
    is(
        "$CompletedHTML\n",
        $Test->{Result},
        $Test->{Name},
    );
}

done_testing;
