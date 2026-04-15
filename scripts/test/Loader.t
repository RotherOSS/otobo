# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use Kernel::System::UnitTest::Diff qw(TextEqOrDiff);
use Kernel::Config;

# the question whether there is a S3 backend must the resolved early
my ($S3Active);
{
    my $ClearConfigObject = Kernel::Config->new( Level => 'Clear' );
    $S3Active = $ClearConfigObject->Get('Storage::S3::Active');
}

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $LoaderObject = $Kernel::OM->Get('Kernel::System::Loader');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $ConfigObject->Get('Home');

subtest 'MinifyCSS' => sub {
    my $SampleCSSFile         = "$Home/scripts/test/sample/Loader/OTOBO.Reset.css";
    my $SampleMinifiedCSSFile = "$Home/scripts/test/sample/Loader/OTOBO.Reset.min.css";

    my $CSS = $MainObject->FileRead(
        Location => $SampleCSSFile,
    )->$*;

    my $ExpectedCSS = $MainObject->FileRead(
        Location => $SampleMinifiedCSSFile,
    )->$*;
    chomp $ExpectedCSS;

    my $MinifiedCSS = $LoaderObject->MinifyCSS( Code => $CSS );

    TextEqOrDiff( $MinifiedCSS, $ExpectedCSS, 'MinifyCSS()' );

    # empty cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Loader',
    );

    my $MinifiedCSSFile = $LoaderObject->GetMinifiedFile(
        Location => $SampleCSSFile,
        Type     => 'CSS',
    );
    TextEqOrDiff( $MinifiedCSSFile, $ExpectedCSS, 'GetMinifiedFile() for CSS, no cache' );

    my $MinifiedCSSFileCached = $LoaderObject->GetMinifiedFile(
        Location => $SampleCSSFile,
        Type     => 'CSS',
    );
    TextEqOrDiff( $MinifiedCSSFileCached, $ExpectedCSS, 'GetMinifiedFile() for CSS, with cache' );

    # No second minification is attempted. This means that the trailing newline is not dropped.
    my $TwiceMinifiedCSSFile = $LoaderObject->GetMinifiedFile(
        Location => $SampleMinifiedCSSFile,
        Type     => 'CSS',
    );
    TextEqOrDiff( $TwiceMinifiedCSSFile, $ExpectedCSS . "\n", 'GetMinifiedFile() for CSS, already minified' );
};

subtest 'MinifyJavaScript' => sub {
    my $SampleJSFile         = "$Home/scripts/test/sample/Loader/OTOBO.Agent.App.Login.js";
    my $SampleMinifiedJSFile = "$Home/scripts/test/sample/Loader/OTOBO.Agent.App.Login.min.js";
    my $JavaScript           = $MainObject->FileRead(
        Location => $SampleJSFile,
    )->$*;

    # make sure line endings are standardized
    $JavaScript =~ s{\r\n}{\n}xmsg;

    my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

    my $ExpectedJS = $MainObject->FileRead(
        Location => $SampleMinifiedJSFile,
    )->$*;

    # make sure line endings are standardized
    $ExpectedJS =~ s{\r\n}{\n}xmsg;

    chomp $ExpectedJS;    # newline after the last line

    TextEqOrDiff( $MinifiedJS, $ExpectedJS, 'MinifyJavaScript()' );

    # empty cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Loader',
    );

    my $MinifiedJSFile = $LoaderObject->GetMinifiedFile(
        Location => $SampleJSFile,
        Type     => 'JavaScript',
    );
    TextEqOrDiff( $MinifiedJSFile, $ExpectedJS, 'GetMinifiedFile() for JavaScript, no cache' );

    my $MinifiedJSFileCached = $LoaderObject->GetMinifiedFile(
        Location => $SampleJSFile,
        Type     => 'JavaScript',
    );
    TextEqOrDiff( $MinifiedJSFileCached, $ExpectedJS, 'GetMinifiedFile() for JavaScript, with cache' );

    # No second minification is attempted. This means that the trailing newline is not dropped.
    my $TwiceMinifiedJSFile = $LoaderObject->GetMinifiedFile(
        Location => $SampleMinifiedJSFile,
        Type     => 'JavaScript',
    );
    TextEqOrDiff( $TwiceMinifiedJSFile, $ExpectedJS . "\n", 'GetMinifiedFile() for JavaScript, already minified' );
};

subtest 'MinifyFiles' => sub {
    my @List               = map {"$Home/scripts/test/sample/Loader/OTOBO.Agent.App.$_.js"} qw(Login Dashboard);
    my $MinifiedJSFilename = $LoaderObject->MinifyFiles(
        List            => \@List,
        Type            => 'JavaScript',
        TargetDirectory => $ConfigObject->Get('TempDir'),
    );

    ok( $MinifiedJSFilename, 'no cache' );

    # minify the same files a second time
    my $MinifiedJSFilename2 = $LoaderObject->MinifyFiles(
        List            => \@List,
        Type            => 'JavaScript',
        TargetDirectory => $ConfigObject->Get('TempDir'),
    );

    ok( $MinifiedJSFilename2, 'with cache' );
    is( $MinifiedJSFilename, $MinifiedJSFilename2, 'compare cache and no cache' );

    my $Location = $ConfigObject->Get('TempDir') . "/$MinifiedJSFilename";

    if ($S3Active) {
        my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');
        my $FilePath        = $Location =~ s!^$Home/!!r;
        $StorageS3Object->SaveObjectToFile(
            Key      => $FilePath,
            Location => $Location,
        );
    }

    my $MinifiedJS = $MainObject->FileRead(
        Location => $Location
    );
    $MinifiedJS = $MinifiedJS->$*;
    $MinifiedJS =~ s{\r\n}{\n}xmsg;
    chomp $MinifiedJS;

    my $Expected = $MainObject->FileRead(
        Location => "$Home/scripts/test/sample/Loader/CombinedJavaScript.min.js",
    );
    $Expected = $Expected->$*;
    $Expected =~ s{\r\n}{\n}xmsg;
    $Expected =~ s{\n$}{};          # newline after the last line

    TextEqOrDiff( $MinifiedJS, $Expected, 'result content' );

    $MainObject->FileDelete(
        Location => $ConfigObject->Get('TempDir') . "/$MinifiedJSFilename",
    );
};

subtest 'specific JavaScript minification' => sub {
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
        TextEqOrDiff( $Result, $Test->{Result}, $Test->{Name} );
    }
};

done_testing;
