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

Console/Command/Admin/ImportExport/Import.t - testing the Import console command

=head1 SYNOPSIS

    # a test script
    prove --verbose scripts/test/Console/Command/Admin/ImportExport/Import.t

=head1 DESCRIPTION

A sanity for exporting data. Custom translations are used in the test script
as this is the only object type that is supported out of the box.

Not that this is only a sanity test whether the command completes. The effect
of the import is not checked.

=cut

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $CommandObject      = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::ImportExport::Import');
my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

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

# no object data is needed for test template

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

# use same sample file as in Export.t
my $SourcePath = $Kernel::OM->Get('Kernel::Config')->Get('Home') . "/scripts/test/sample/ImportExport/ExportTranslations_de.csv";

# test command with wrong template number
$ExitCode = $CommandObject->Execute( '--template-number', $Helper->GetRandomID(), $SourcePath . 'TemplateExport.csv' );

is(
    $ExitCode,
    1,
    "Command with wrong template number - exit code",
);

# test command without source argument
$ExitCode = $CommandObject->Execute( '--template-number', $TemplateID );

is(
    $ExitCode,
    1,
    "No source argument - exit code",
);

# test command with --template-number option and Source argument
$ExitCode = $CommandObject->Execute( '--template-number', $TemplateID, $SourcePath );

is(
    $ExitCode,
    0,
    "Option - --template-number option and Source argument",
);

# TODO: test the effect of the import

done_testing;
