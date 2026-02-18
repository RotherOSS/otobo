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
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');
my $ValidObject        = $Kernel::OM->Get('Kernel::System::Valid');

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

my %GenericAgentData = (
    ChangeTimeSearchType             => '',
    CloseTimeSearchType              => '',
    CustomerID                       => '',
    CustomerUserLogin                => '',
    EscalationResponseTimeSearchType => '',
    EscalationSolutionTimeSearchType => '',
    EscalationTimeSearchType         => '',
    EscalationUpdateTimeSearchType   => '',
    LastChangeTimeSearchType         => '',
    LastCloseTimeSearchType          => '',
    MIMEBase_Body                    => '',
    MIMEBase_Cc                      => '',
    MIMEBase_From                    => '',
    MIMEBase_Subject                 => '',
    MIMEBase_To                      => '',
    Name                             => 'TestGenericAgent1' . $RandomID,
    NewCustomerID                    => '',
    NewCustomerUserLogin             => '',
    NewDelete                        => '0',
    NewModule                        => '',
    NewNoteBody                      => '',
    NewNoteFrom                      => '',
    NewNoteSubject                   => '',
    NewNoteTimeUnits                 => '',
    NewParamKey1                     => '',
    NewParamKey2                     => '',
    NewParamKey3                     => '',
    NewParamKey4                     => '',
    NewParamKey5                     => '',
    NewParamKey6                     => '',
    NewParamValue1                   => '',
    NewParamValue2                   => '',
    NewParamValue3                   => '',
    NewParamValue4                   => '',
    NewParamValue5                   => '',
    NewParamValue6                   => '',
    NewPendingTime                   => '',
    NewPendingTimeType               => '60',
    NewSendNoNotification            => '0',
    NewTitle                         => '',
    ScheduleLastRun                  => '',
    TicketNumber                     => '',
    TimePendingSearchType            => '',
    TimeSearchType                   => '',
    Title                            => '',
    Valid                            => $ValidID,
);

# create test generic agent
my $AddSuccess = $GenericAgentObject->JobAdd(
    Name   => 'TestGenericAgent1' . $RandomID,
    Data   => \%GenericAgentData,
    UserID => $TestUserID,
);
ok( $AddSuccess, 'generic agent created successfully' );

# testing export
my $ExportData = $GenericAgentObject->ExportGenericAgents();
is(
    $ExportData,
    hash {
        field 'TestGenericAgent1' . $RandomID => \%GenericAgentData;

        etc();
    },
    'exported data looks like expected'
);

# testing import
my %ImportData = (
    ChangeTimeSearchType             => '',
    CloseTimeSearchType              => '',
    CustomerID                       => '',
    CustomerUserLogin                => '',
    EscalationResponseTimeSearchType => '',
    EscalationSolutionTimeSearchType => '',
    EscalationTimeSearchType         => '',
    EscalationUpdateTimeSearchType   => '',
    LastChangeTimeSearchType         => '',
    LastCloseTimeSearchType          => '',
    MIMEBase_Body                    => '',
    MIMEBase_Cc                      => '',
    MIMEBase_From                    => '',
    MIMEBase_Subject                 => '',
    MIMEBase_To                      => '',
    Name                             => 'TestGenericAgent2' . $RandomID,
    NewCustomerID                    => '',
    NewCustomerUserLogin             => '',
    NewDelete                        => '0',
    NewModule                        => '',
    NewNoteBody                      => '',
    NewNoteFrom                      => '',
    NewNoteSubject                   => '',
    NewNoteTimeUnits                 => '',
    NewParamKey1                     => '',
    NewParamKey2                     => '',
    NewParamKey3                     => '',
    NewParamKey4                     => '',
    NewParamKey5                     => '',
    NewParamKey6                     => '',
    NewParamValue1                   => '',
    NewParamValue2                   => '',
    NewParamValue3                   => '',
    NewParamValue4                   => '',
    NewParamValue5                   => '',
    NewParamValue6                   => '',
    NewPendingTime                   => '',
    NewPendingTimeType               => '60',
    NewSendNoNotification            => '0',
    NewTitle                         => '',
    ScheduleLastRun                  => '',
    TicketNumber                     => '',
    TimePendingSearchType            => '',
    TimeSearchType                   => '',
    Title                            => '',
    Valid                            => $ValidID,
);

my $ImportSuccess = $GenericAgentObject->ImportGenericAgents(
    GenericAgents => {
        'TestGenericAgent2' . $RandomID => \%ImportData,
    },
    UserID => $TestUserID,
);
ok( $ImportSuccess, 'imported generic agent successfully' );

my %ImportedJob = $GenericAgentObject->JobGet(
    Name => 'TestGenericAgent2' . $RandomID,
);
is(
    \%ImportedJob,
    \%ImportData,
    'imported data looks as expected'
);

done_testing;
