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

use Kernel::System::VariableCheck qw(:all);

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');

# clear some tables
for my $Table (qw(sysconfig_modified_version sysconfig_modified sysconfig_default_version sysconfig_default)) {
    my $DoSuccess = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM $Table",
    );

    skip_all("cannot delete from $Table") unless $DoSuccess;
}

# Initial call
my $Result = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/",
);

# Read a couple of configuration from Defaults
# and add a modified setting entry for each one

my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketPriority###ArticleTypes',
);

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
my $ModifiedSettingAddSuccess = $SysConfigDBObject->ModifiedSettingAdd(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);
$Self->True(
    $ModifiedSettingAddSuccess,
    "Add success.",
);

%DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketResponsible###StateType',
);

# Lock
$GuID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultSetting{DefaultID},
);

$Self->True(
    $GuID,
    "Check if locked before update."
);

# Update item
$ModifiedSettingAddSuccess = $SysConfigDBObject->ModifiedSettingAdd(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);
$Self->True(
    $ModifiedSettingAddSuccess,
    "Add success.",
);

# Call ConfigurationXML2DB with the same file as beginning

$Result = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/",
);

# Verify both modified setting are still there
my @ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingListGet();
my %ModifiedSettingsList = map { $_->{Name} => 1 } @ModifiedSettingsList;

$Self->True(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketPriority###ArticleTypes"},
    "ArticleTypes setting should be present.",
);
$Self->True(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketResponsible###StateType"},
    "StateType setting should be present.",
);

# Call ConfigurationXML2DB with the modified file
$Result = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XMLMod/",
);

# Verify one of the modified setting is gone

@ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingListGet();
%ModifiedSettingsList = map { $_->{Name} => 1 } @ModifiedSettingsList;

$Self->False(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketPriority###ArticleTypes"},
    "ArticleTypes setting is gone.",
);
$Self->True(
    $ModifiedSettingsList{"Ticket::Frontend::AgentTicketResponsible###StateType"},
    "StateType setting should be present.",
);

done_testing();
