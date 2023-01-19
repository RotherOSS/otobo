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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
            TestMode       => 1,
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    Name    => "$RandomID web service",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

# provide no objects
my $DebugLogObject;

# with just objects
$DebugLogObject = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog');
$Self->Is(
    ref $DebugLogObject,
    'Kernel::System::GenericInterface::DebugLog',
    'DebugLog::new() constructor failure, just objects.',
);

my $SystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $SetDebugLogEntries = sub {
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '1999-12-09 00:00:00',
        },
    );

    for my $Counter ( 1 .. 3 ) {
        my $Success = $DateTimeObject->Add(
            Days => 1,
        );
        FixedTimeSet($DateTimeObject);

        $Success = $DebugLogObject->LogAdd(
            CommunicationID => $MainObject->MD5sum(
                String => $SystemTime . $Helper->GetRandomID(),
            ),
            CommunicationType => 'Requester',
            Data              => 'additional data',
            DebugLevel        => 'info',
            RemoteIP          => '192.168.0.1',
            Summary           => 'description of log entry',
            WebserviceID      => $WebserviceID,
        );
    }
};

# General tests
my @Tests = (
    {
        Name    => 'Missing CreatedAtOrBefore',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong CreatedAtOrBefore',
        Config => {
            CreatedAtOrBefore => 'Hola',
        },
        Success => 0,
    },
    {
        Name   => 'Invalid Date CreatedAtOrBefore',
        Config => {
            CreatedAtOrBefore => '2017-02-31 00:00:00',
        },
        Success => 0,
    },
    {
        Name   => 'Correct Date CreatedAtOrBefore',
        Config => {
            CreatedAtOrBefore => '1997-12-12 00:00:00',
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $DebugLogObject->LogCleanup( %{ $Test->{Config} } );

    $Self->Is(
        $Success // 0,
        $Test->{Success},
        "$Test->{Name} LogCleanup() result",
    );
}

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $GetDebugLogEntries = sub {
    my %Param = @_;

    my %Result;

    for my $Table (qw(gi_debugger_entry gi_debugger_entry_content)) {
        $DBObject->Prepare(
            SQL  => "SELECT COUNT(id) FROM $Table WHERE create_time <= ?",
            Bind => [ \$Param{CreatedAtOrBefore} ],
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Result{$Table} = $Row[0];
        }
    }

    return %Result;
};

# Entry removal tests.
@Tests = (
    {
        Name            => 'From 1999-12-09 00:00:00',
        TargetTime      => '1999-12-09 00:00:00',
        ExpectedResults => {
            gi_debugger_entry         => 3,
            gi_debugger_entry_content => 3,
        },
    },
    {
        Name            => 'From 1999-12-09 00:00:01',
        TargetTime      => '1999-12-09 00:00:01',
        ExpectedResults => {
            gi_debugger_entry         => 3,
            gi_debugger_entry_content => 3,
        },
    },
    {
        Name            => 'From 1999-12-09 23:59:59',
        TargetTime      => '1999-12-09 23:59:59',
        ExpectedResults => {
            gi_debugger_entry         => 3,
            gi_debugger_entry_content => 3,
        },
    },
    {
        Name            => 'From 1999-12-10 00:00:00',
        TargetTime      => '1999-12-10 00:00:00',
        ExpectedResults => {
            gi_debugger_entry         => 2,
            gi_debugger_entry_content => 2,
        },
    },
    {
        Name            => 'From 1999-12-11 00:00:00',
        TargetTime      => '1999-12-11 00:00:00',
        ExpectedResults => {
            gi_debugger_entry         => 1,
            gi_debugger_entry_content => 1,
        },
    },
    {
        Name            => 'From 1999-12-12 00:00:00',
        TargetTime      => '1999-12-12 00:00:00',
        ExpectedResults => {
            gi_debugger_entry         => 0,
            gi_debugger_entry_content => 0,
        },
    },
);

my $FinalTime = '2000-01-01 00:00:00';

TEST:
for my $Test (@Tests) {

    $SetDebugLogEntries->();
    my %DebugLogEntries = $GetDebugLogEntries->( CreatedAtOrBefore => $FinalTime );
    $Self->IsDeeply(
        \%DebugLogEntries,
        {
            gi_debugger_entry         => 3,
            gi_debugger_entry_content => 3,
        },
        "$Test->{Name} DebugLog entries initial",
    );

    my $Success = $DebugLogObject->LogCleanup(
        CreatedAtOrBefore => $Test->{TargetTime},
    );
    %DebugLogEntries = $GetDebugLogEntries->( CreatedAtOrBefore => $FinalTime );
    $Self->IsDeeply(
        \%DebugLogEntries,
        $Test->{ExpectedResults},
        "$Test->{Name} DebugLog entries after cleanup",
    );

    $Success = $DebugLogObject->LogCleanup(
        CreatedAtOrBefore => $FinalTime,
    );
    %DebugLogEntries = $GetDebugLogEntries->( CreatedAtOrBefore => $FinalTime );
    $Self->IsDeeply(
        \%DebugLogEntries,
        {
            gi_debugger_entry         => 0,
            gi_debugger_entry_content => 0,
        },
        "$Test->{Name} DebugLog entries final",
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
