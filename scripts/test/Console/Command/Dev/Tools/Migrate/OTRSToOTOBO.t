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
use v5.24;
use utf8;

# core modules
use File::Copy;

# CPAN modules
use Test2::V0;
use Path::Class qw(dir file);

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM

plan( tests => 4 );

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Migrate::OTRSToOTOBO');
my $Home          = $Kernel::OM->Get('Kernel::Config')->Get('Home');

subtest
    'error with missing parameter --target',
    sub {
        my ( $ExitCode, $Stderr );
        {
            local *STDERR;
            open STDERR, '>:encoding(UTF-8)', \$Stderr;    ## no critic qw(OTOBO::ProhibitOpen)
            $ExitCode = $CommandObject->Execute(
                "--source" => "$Home/Kernel/Config/Files/NotExisting/Source",
                '--cleanxmlconfig',
            );
        }

        #note( $Stderr );

        # exit code 1 indicates failure
        is( $ExitCode, 1, 'exit code ' );
        like( $Stderr, qr/Error: please provide option '--target'/, 'error message' );
    };

subtest
    'error with extra parameter --source',
    sub {
        my ( $ExitCode, $Stderr );
        {
            local *STDERR;
            open STDERR, '>:encoding(UTF-8)', \$Stderr;    ## no critic qw(OTOBO::ProhibitOpen)
            $ExitCode = $CommandObject->Execute(
                "--target" => "$Home/Kernel/Config/Files/NotExisting/Target",
                "--source" => "$Home/Kernel/Config/Files/NotExisting/Source",
                '--cleanxmlconfig',
            );
        }

        #note( $Stderr );

        # exit code 1 indicates failure
        is( $ExitCode, 1, 'exit code' );
        like( $Stderr, qr/found unknown argument/, 'error message' );
    };

subtest
    'error with non-existing source dir',
    sub {
        my ( $ExitCode, $Stderr );
        {
            local *STDERR;
            open STDERR, '>:encoding(UTF-8)', \$Stderr;    ## no critic qw(OTOBO::ProhibitOpen)
            $ExitCode = $CommandObject->Execute(
                "--target" => "$Home/Kernel/Config/Files/NotExisting/Target",
                '--cleanxmlconfig',
                "$Home/Kernel/Config/Files/NotExisting/Source",
            );
        }

        #note( $Stderr );

        # exit code 1 indicates failure
        is( $ExitCode, 1, 'exit code' );
        like( $Stderr, qr/Error: File .* does not exist/, 'error message' );
    };

subtest
    'actual migration',
    sub {
        # copy a sample file to a testdir
        my $TestDir   = dir($Home)->subdir('tmp/Test/Migrate/OTRSToOTOBO');
        my $SourceDir = $TestDir->subdir('Source');
        $SourceDir->mkpath();
        my $TargetDir = $TestDir->subdir('Target');
        $TargetDir->mkpath();

        # copy the sample file to the test dir, the workfile will be modified later
        my $SampleFile = dir($Home)->file('scripts/test/sample/SysConfig/MigrateOTRSToOTOBO.xml');
        my $SourceFile = $SampleFile->copy_to( $SourceDir->file('MigrateOTRSToOTOBO.xml') );
        my $TargetFile = $TargetDir->file('MigrateOTRSToOTOBO.xml');

        my ( $ExitCode, $Stderr );
        {
            local *STDERR;
            open STDERR, '>:encoding(UTF-8)', \$Stderr;    ## no critic qw(OTOBO::ProhibitOpen)
            $ExitCode = $CommandObject->Execute(
                '--cleanxmlconfig',
                '--target' => $TargetDir->stringify(),
                $SourceDir->stringify(),
            );
        }
        note("stderr: $Stderr");

        # exit code 0 indicates success
        is( $ExitCode, 0, 'success' );

        # check whether to migrated file exists
        ok( -e $SourceFile, "$SourceFile exists" );

        # Content of the migrated file
        my $ExpectedResultFile = dir($Home)->file('scripts/test/sample/SysConfig/MigrateOTRSToOTOBOResult.xml');
        is(
            [ $TargetFile->slurp() ],
            [ $ExpectedResultFile->slurp() ],
            "Content of $TargetFile"
        );
    };
