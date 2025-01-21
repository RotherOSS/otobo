# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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
use CSS::Minifier::XS ();

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Diff qw(TextEqOrDiff);

my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

### Setting up

# Minimize amount of added CSS for testing
my $TestCustomCSS          = '';
my $TestCKEditorContentCSS = '';

my $TestCKEditorContentCSSPath = '';
my $StandardContentCSSPath     = $ConfigObject->Get('Home') . '/var/httpd/htdocs/skins/Agent/default/css/RichTextArticleContent.css';

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

my $StandardContentCSS = ${
    $MainObject->FileRead(
        Location => $StandardContentCSSPath,
    )
};

our $MinifiedCSS = CSS::Minifier::XS::minify($StandardContentCSS);

my @Tests = (
    {
        Line   => __LINE__,
        Name   => 'Empty document',
        String => '',
        Result => $HTMLUtilsObject->DocumentComplete(
            String => ''
        )
    },
    {
        Line   => __LINE__,
        Name   => 'Web Address without link tags',
        String => 'You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/ .',
        Result => $HTMLUtilsObject->DocumentComplete(
            String => 'You should have received a copy of the GNU General Public License along with this program. If not, see <a href="https://www.gnu.org/licenses/" target="_blank" title="https://www.gnu.org/licenses/">https://www.gnu.org/licenses/</a> .'
        )
    },
    {
        Line   => __LINE__,
        Name   => 'Image with ContentID, no session',
        String =>'123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234',
        Result => $HTMLUtilsObject->DocumentComplete(
            String => '123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234'
        )
    },
    {
        Line   => __LINE__,
        Name   => 'Image with ContentID, with session',
        String =>'123 <img src="index.pl?Action=SomeAction;FileID=0;ContentID=inline105816.238987884.1382708457.5104380.88084622@localhost;SessionID=123" /> 234',
        Result => $HTMLUtilsObject->DocumentComplete(
            String => '123 <img src="cid:inline105816.238987884.1382708457.5104380.88084622@localhost" /> 234'
        )
    },
);

for my $Test (@Tests) {

    my $Result = $Test->{Result};
    my $HTMLString = $Test->{String}

    #Remove OTOBO Copyright comment for easier testing 
    $Result =~ s/\/\*[\s\S]*?\*\///;
    $HTMLString =~ s/\/\*[\s\S]*?\*\///;

    $LayoutObject->RichTextDocumentComplete(
        String => $HTMLString,
    );
    

    TextEqOrDiff(
        "$HTMLString\n",
        "$Result\n",
        "$Test->{Name} (line $Test->{Line})",
    );
}

done_testing;
