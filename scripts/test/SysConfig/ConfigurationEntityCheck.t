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
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# clear some tables
for my $Table (qw(sysconfig_modified_version sysconfig_modified sysconfig_default_version sysconfig_default)) {
    my $DoSuccess = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM $Table",
    );

    skip_all("cannot delete from $Table") unless $DoSuccess;
}

# Load setting from sample XML file
my $LoadSuccess = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/Entities",
);
$Self->True(
    $LoadSuccess,
    "Load settings from SampleEntities.xml."
);

# Basic tests
my @Tests1 = (
    {
        Description => 'Without EntityType',
        Config      => {
            EntityName => '3 normal',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Without EntityName',
        Config      => {
            EntityType => 'Priority',
        },
        ExpectedResult => undef,
    },
    {
        Description => '#1',
        Config      => {
            EntityName => 'open',
            EntityType => 'State',
        },
        ExpectedResult => [
            'Ticket::Frontend::AgentTicketPriority###ComplexEntity2',
            'Ticket::Frontend::AgentTicketPriority###StateDefault',
        ],
    },
    {
        Description => '#2',
        Config      => {
            EntityName => 'openßČĆ£øπ∂',
            EntityType => 'StateßČĆ£øπ∂',
        },
        ExpectedResult => [
            'Ticket::Frontend::AgentTicketPriority###EntityUnicode',
        ],
    },
);

# Caching tests (after updating item)
my @Tests2 = (
    {
        Description => 'Item updated - Check if cache is deleted',
        Config      => {
            EntityName => 'openßČĆ£øπ∂',
            EntityType => 'StateßČĆ£øπ∂',
        },
        ExpectedResult => [
            'Ticket::Frontend::AgentTicketPriority###EntityUnicode'
        ],
    },
);

# Caching tests (after item deleted)
my @Tests3 = (
    {
        Description => 'Item deleted - Check if cache is deleted',
        Config      => {
            EntityName => 'openßČĆ£øπ∂',
            EntityType => 'StateßČĆ£øπ∂',
        },
        ExpectedResult => [
        ],
    },
);

for my $Test (@Tests1) {
    my @Result = $SysConfigObject->ConfigurationEntityCheck( %{ $Test->{Config} } );

    if (@Result) {
        $Self->IsDeeply(
            \@Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
        );
    }
    else {
        $Self->False(
            $Test->{ExpectedResult},
            $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
        );
    }
}

my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketPriority###EntityUnicode',
);

# Update setting navigation
$DefaultSetting{Navigation} = 'AnyOtherValue';

# Lock
my $GuID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultSetting{DefaultID},
);

$Self->True(
    $GuID,
    "Check if locked before update."
);

# Update item
my $DefaultSettingUpdateSuccess = $SysConfigDBObject->DefaultSettingUpdate(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);
$Self->True(
    $DefaultSettingUpdateSuccess,
    "Update success.",
);

# Check result
for my $Test (@Tests2) {
    my @Result = $SysConfigObject->ConfigurationEntityCheck( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
    );
}

# Delete item
my $DefaultSettingDeleteSuccess = $SysConfigDBObject->DefaultSettingDelete(
    DefaultID => $DefaultSetting{DefaultID},
);
$Self->True(
    $DefaultSettingDeleteSuccess,
    "Delete setting.",
);

# Check result
for my $Test (@Tests3) {
    my @Result = $SysConfigObject->ConfigurationEntityCheck( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
    );
}

done_testing();
