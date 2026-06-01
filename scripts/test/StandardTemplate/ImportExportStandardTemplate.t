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
use Test2::V0 qw(:DEFAULT), qw(etc);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $TemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
my $ValidObject    = $Kernel::OM->Get('Kernel::System::Valid');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# define needed variable
my $RandomID = $Helper->GetRandomID;

# create test user
my ( undef, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $ValidID = $ValidObject->ValidLookup(
    Valid => 'valid',
);

my %TemplateData = (
    Name         => 'TestTemplate1' . $RandomID,
    Comment      => 'TestComment1' . $RandomID,
    Template     => 'TestTemplateContent1' . $RandomID,
    ContentType  => 'text/plain; charset=utf-8',
    TemplateType => 'Answer',
    ValidID      => $ValidID,
);
my %TemplateExpectedData = (
    Name                     => 'TestTemplate1' . $RandomID,
    Comment                  => 'TestComment1' . $RandomID,
    Template                 => 'TestTemplateContent1' . $RandomID,
    ContentType              => 'text/plain; charset=utf-8',
    TemplateType             => 'Answer',
    Valid                    => 'valid',
    PreSelectedTicketStateID => undef,
);

# create test template
my $AddSuccess = $TemplateObject->StandardTemplateAdd(
    %TemplateData,
    UserID => $TestUserID,
);
ok( $AddSuccess, 'template created successfully' );

# testing export
my $ExportData = $TemplateObject->ExportTemplates();
is(
    $ExportData,
    hash {
        field 'TestTemplate1' . $RandomID => \%TemplateExpectedData;

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    Name         => 'TestTemplate2' . $RandomID,
    Comment      => 'TestComment2' . $RandomID,
    Template     => 'TestTemplateContent2' . $RandomID,
    ContentType  => 'text/plain; charset=utf-8',
    TemplateType => 'Answer',
    Valid        => 'valid',
);

my $ImportSuccess = $TemplateObject->ImportTemplates(
    Templates => {
        'TestTemplate2' . $RandomID => \%ImportData,
    },
    UserID => $TestUserID,
);
ok( $ImportSuccess, 'imported template successfully' );

my $TemplateID = $TemplateObject->StandardTemplateLookup(
    StandardTemplate => 'TestTemplate2' . $RandomID,
);
my %ImportedTemplate = $TemplateObject->StandardTemplateGet(
    ID => $TemplateID,
);
is(
    \%ImportedTemplate,
    hash {
        field 'Name'         => 'TestTemplate2' . $RandomID;
        field 'Comment'      => 'TestComment2' . $RandomID;
        field 'Template'     => 'TestTemplateContent2' . $RandomID;
        field 'ContentType'  => 'text/plain; charset=utf-8';
        field 'TemplateType' => 'Answer';
        field 'ValidID'      => $ValidID;

        etc();
    },
    'imported data looks as expected'
);

done_testing;
