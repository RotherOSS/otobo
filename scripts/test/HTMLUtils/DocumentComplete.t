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
use CSS::Minifier::XS        ();

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

### Setting up

my $TestCustomCSS = ':root{color:red;}';
my $TestCKEditorContentCSS = 'div{color:blue;}';

my $TestCKEditorContentCSSPath = 'test_styles.css';
my $StandardContentCSSPath = $ConfigObject->Get('Home') . '/var/httpd/htdocs/skins/Agent/default/css/RichTextArticleContent.css';

$Helper->ConfigSettingChange(
    Key   => 'Frontend::RichText::DefaultCSS',
    Value => $TestCustomCSS,
    Valid => 1,
);
$Helper->ConfigSettingChange(
    Key   => 'Frontend::RichTextArticleStyles',
    Value => $TestCKEditorContentCSSPath,
    Valid => 1,
);

$MainObject->FileWrite(
    Location => $ConfigObject->Get('Home') . '/var/httpd/htdocs/' . $TestCKEditorContentCSSPath,
    Content  => \$TestCKEditorContentCSS,
);

my $StandardContentCSS = ${$MainObject->FileRead(
    Location => $StandardContentCSSPath,
)};
my $testpath = $ConfigObject->Get('Frontend::RichTextArticleStyles');

our $MinifiedCSS = CSS::Minifier::XS::minify( $TestCKEditorContentCSS ) . "\n" . CSS::Minifier::XS::minify( $StandardContentCSS ) . "\n";



# DocumentComplete tests
my @Tests = (
    # test if regular text is correctly wrapped in html 
    {
        Input  => 'Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
        Result => '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>' . $MinifiedCSS . '</style></head><body class="ck-content" style=":root{color:red;}">Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>' . "\n",
        Name => 'text without markup'
    },
    # test if text containing markup tags is correctly wrapped in html 
    {
        Input  => 'Some <b> Bold Text</b> ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
        Result => '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>' . $MinifiedCSS . '</style></head><body class="ck-content" style=":root{color:red;}">Some <b> Bold Text</b> ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>' . "\n",
        Name => 'text with markup'
    },
    # test if text wrapped in html and body tags is returned unchanged
    {
        Input  => '<html><body>Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>',
        Result => '<html><body>Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>' . "\n",
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

$MainObject->FileDelete(
    Location => $ConfigObject->Get('Home') . '/var/httpd/htdocs/' . $TestCKEditorContentCSSPath,
    NoLog    => 1,
);

done_testing;