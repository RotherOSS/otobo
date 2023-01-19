# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $LoaderObject = $Kernel::OM->Get('Kernel::System::Loader');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $ConfigObject->Get('Home');

{
    my $CSS = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/Loader/OTOBO.Reset.css',
    );

    $CSS = ${$CSS};

    my $ExpectedCSS = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/Loader/OTOBO.Reset.min.css',
    );

    $ExpectedCSS = ${$ExpectedCSS};
    chomp $ExpectedCSS;

    my $MinifiedCSS = $LoaderObject->MinifyCSS( Code => $CSS );

    $Self->Is(
        $MinifiedCSS || '',
        $ExpectedCSS,
        'MinifyCSS()',
    );

    # empty cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Loader',
    );

    my $MinifiedCSSFile = $LoaderObject->GetMinifiedFile(
        Location => $Home . '/scripts/test/sample/Loader/OTOBO.Reset.css',
        Type     => 'CSS',
    );

    my $MinifiedCSSFileCached = $LoaderObject->GetMinifiedFile(
        Location => $Home . '/scripts/test/sample/Loader/OTOBO.Reset.css',
        Type     => 'CSS',
    );

    $Self->Is(
        $MinifiedCSSFile,
        $ExpectedCSS,
        'GetMinifiedFile() for CSS, no cache',
    );

    $Self->Is(
        $MinifiedCSSFile,
        $ExpectedCSS,
        'GetMinifiedFile() for CSS, with cache',
    );
}

{
    my $JavaScript = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/Loader/OTOBO.Agent.App.Login.js',
    );
    $JavaScript = ${$JavaScript};

    # make sure line endings are standardized
    $JavaScript =~ s{\r\n}{\n}xmsg;

    my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

    my $ExpectedJS = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/Loader/OTOBO.Agent.App.Login.min.js',
    );
    $ExpectedJS = ${$ExpectedJS};
    $ExpectedJS =~ s{\r\n}{\n}xmsg;

    #chomp $ExpectedJS;

    $Self->Is(
        $MinifiedJS || '',
        $ExpectedJS,
        'MinifyJavaScript()',
    );
}

{
    my $MinifiedJSFilename = $LoaderObject->MinifyFiles(
        List => [
            $Home . '/scripts/test/sample/Loader/OTOBO.Agent.App.Login.js',
            $Home . '/scripts/test/sample/Loader/OTOBO.Agent.App.Dashboard.js',
        ],
        Type            => 'JavaScript',
        TargetDirectory => $ConfigObject->Get('TempDir'),
    );

    $Self->True(
        $MinifiedJSFilename,
        'MinifyFiles() - no cache',
    );

    my $MinifiedJSFilename2 = $LoaderObject->MinifyFiles(
        List => [
            $Home . '/scripts/test/sample/Loader/OTOBO.Agent.App.Login.js',
            $Home . '/scripts/test/sample/Loader/OTOBO.Agent.App.Dashboard.js',
        ],
        Type            => 'JavaScript',
        TargetDirectory => $ConfigObject->Get('TempDir'),
    );

    $Self->True(
        $MinifiedJSFilename2,
        'MinifyFiles() - with cache',
    );

    $Self->Is(
        $MinifiedJSFilename,
        $MinifiedJSFilename2,
        'MinifyFiles() - compare cache and no cache',
    );

    my $MinifiedJS = $MainObject->FileRead(
        Location => $ConfigObject->Get('TempDir') . "/$MinifiedJSFilename",
    );
    $MinifiedJS = ${$MinifiedJS};
    $MinifiedJS =~ s{\r\n}{\n}xmsg;
    chomp $MinifiedJS;

    my $Expected = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/Loader/CombinedJavaScript.min.js',
    );
    $Expected = ${$Expected};
    $Expected =~ s{\r\n}{\n}xmsg;

    $Self->Is(
        $MinifiedJS,
        $Expected,
        'MinifyFiles() result content',
    );

    $MainObject->FileDelete(
        Location => $ConfigObject->Get('TempDir') . "/$MinifiedJSFilename",
    );
}

my @JSTests = (

    # this next test shows a case where the minification currently only works with
    # parents around the regular expression. Without them, CSS::Minifier (currently 1.05) will die.
    {
        Source => 'function test(s) { return (/\d{1,2}/).test(s); }',
        Result => 'function test(s){return(/\d{1,2}/).test(s);}',
        Name   => 'Regexp minification',
    }
);

for my $Test (@JSTests) {
    my $Result = $LoaderObject->MinifyJavaScript(
        Code => $Test->{Source},
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

# cleanup cache is done by RestoreDatabase

$Self->DoneTesting();
