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

=head1 NAME

Console/Command/Admin/ImportExport/Export.t - testing the Export console command

=head1 SYNOPSIS

    # a test script
    prove --verbose scripts/test/Console/Command/Admin/ImportExport/Export.t

=head1 DESCRIPTION

A sanity for exporting data. Custom translations are used in the test script
as this is the only object type that is supported out of the box.

=cut

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use Path::Class qw(dir file);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::ImportExport::Export');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();
ok( $RandomID, 'got a random ID' );
diag("RandomID: $RandomID");

# test command without --template-number option
my $ExitCode = $CommandObject->Execute;

is(
    $ExitCode,
    1,
    "No --template-number  - exit code",
);

# get ImportExport object
my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

# add test template
my $TemplateID = $ImportExportObject->TemplateAdd(
    Object  => 'Translations',
    Format  => 'CSV',
    Name    => 'Template' . $RandomID,
    ValidID => 1,
    Comment => 'Comment',
    UserID  => 1,
);
ok( $TemplateID, "Import/Export template is created" );
diag("TemplateID: $TemplateID");

# no object data for test template is needed
# add the format data of the test template
my %FormatData = (
    Charset              => 'UTF-8',
    ColumnSeparator      => 'Dot',
    IncludeColumnHeaders => 1,
);
my $FormatDataSaveSuccess = $ImportExportObject->FormatDataSave(
    TemplateID => $TemplateID,
    FormatData => \%FormatData,
    UserID     => 1,
);
ok( $FormatDataSaveSuccess, "format data for test template is added" );

# no search data is needed
# add mapping data for test template
for my $ObjectDataValue (qw( Content de )) {

    my $MappingID = $ImportExportObject->MappingAdd(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    my $Success = $ImportExportObject->MappingObjectDataSave(
        MappingID         => $MappingID,
        MappingObjectData => { Key => $ObjectDataValue },
        UserID            => 1,
    );

    ok( $Success, "ObjectData for test template is mapped - $ObjectDataValue" );
}

# make directory for export file
my $Home            = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $TempDir         = $Kernel::OM->Get('Kernel::Config')->Get('TempDir');
my $DestinationPath = join '/', $TempDir, 'ImportExport';
my $ExportFilename  = "$DestinationPath/ExportTranslations_de_$RandomID.csv";
ok( !-f $ExportFilename, 'no leftover export file' );
dir($DestinationPath)->mkpath;
ok( -d $DestinationPath, 'export dir was created' );

# test command with wrong template number
$ExitCode = $CommandObject->Execute(
    '--template-number', $Helper->GetRandomNumber,
    $ExportFilename
);

is(
    $ExitCode,
    1,
    "Command with wrong template number - exit code",
);
ok( !-e $ExportFilename, 'no export file was generated' );

# test command without destination argument
$ExitCode = $CommandObject->Execute( '--template-number', $TemplateID );

is(
    $ExitCode,
    1,
    "No destination argument - exit code",
);
ok( !-e $ExportFilename, 'no export file was generated' );

# test command with --template-number option and destination argument
$ExitCode = $CommandObject->Execute( '--template-number', $TemplateID, $ExportFilename );

is(
    $ExitCode,
    0,
    "Option - --template-number option and destination argument",
);
ok( -e $ExportFilename, 'export file was finally generated' );

# Content of the exported file, with considering potential random ids in the data.
# Note that this expects a system without any custom translations and with
# the original set of states and types.
{
    my $ExpectedResultFile = dir($Home)->file('scripts/test/sample/ImportExport/ExportTranslations_de.csv');
    my @ExpectedLines      = map {s/<<RANDOM_ID>>/$RandomID/r} $ExpectedResultFile->slurp;
    is( scalar @ExpectedLines, 22, 'got some expected content' );
    my @Lines = file($ExportFilename)->slurp;
    $Lines[-1] .= "\n";
    is(
        \@Lines,
        \@ExpectedLines,
        "Content of $ExportFilename"
    );
}

# remove test destination path
diag("deleting $DestinationPath");
dir($DestinationPath)->rmtree;
ok( !-d $DestinationPath, 'test directory deleted' );

done_testing;
