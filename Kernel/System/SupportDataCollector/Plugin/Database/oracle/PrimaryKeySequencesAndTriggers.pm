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

package Kernel::System::SupportDataCollector::Plugin::Database::oracle::PrimaryKeySequencesAndTriggers;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') ne 'oracle' ) {
        return $Self->GetResults();
    }

    # Get all table names.
    my @Tables = $DBObject->ListTables();

    my %SequenceNameFromTableName;
    for my $TableName (@Tables) {

        my $Sequence = $DBObject->{Backend}->_SequenceName(
            TableName => $TableName,
        );

        # Convert to lower case.
        $Sequence = lc $Sequence;

        $SequenceNameFromTableName{$Sequence} = 1;
    }

    # Get all sequence names.
    $DBObject->Prepare(
        SQL => 'SELECT sequence_name FROM user_sequences',
    );

    my @SequenceNames;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # Convert to lower case.
        push @SequenceNames, lc $Row[0];
    }

    my @WrongSequenceNames;
    SEQUENCE:
    for my $SequenceName (@SequenceNames) {

        next SEQUENCE if $SequenceNameFromTableName{$SequenceName};

        # Remember wrong sequence name.
        push @WrongSequenceNames, $SequenceName;
    }

    # Get all trigger names.
    $DBObject->Prepare(
        SQL => 'SELECT trigger_name FROM user_triggers',
    );

    my @TriggerNames;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # Convert to lower case.
        push @TriggerNames, lc $Row[0];
    }

    my @WrongTriggerNames;
    TRIGGER:
    for my $TriggerName (@TriggerNames) {

        my $SequenceName = $TriggerName;

        # Remove the last part of the sequence name.
        $SequenceName =~ s{ _t \z }{}xms;

        next TRIGGER if $SequenceNameFromTableName{$SequenceName};

        # Remember wrong trigger name.
        push @WrongTriggerNames, $TriggerName;
    }

    my $Error;
    if (@WrongSequenceNames) {

        $Error .= "Seqences:\n";
        $Error .= join "\n", @WrongSequenceNames;
        $Error .= "\n\n";
    }

    if (@WrongTriggerNames) {
        $Error .= "Triggers:\n";
        $Error .= join "\n", @WrongTriggerNames;
        $Error .= "\n\n";
    }

    if ($Error) {
        $Self->AddResultProblem(
            Identifier => 'PrimaryKeySequencesAndTriggers',
            Label      => Translatable('Primary Key Sequences and Triggers'),
            Value      => $Error,
            Message    => Translatable(
                'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.'
            ),
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'PrimaryKeySequencesAndTriggers',
            Label      => Translatable('Primary Key Sequences and Triggers'),
            Value      => '',
        );
    }

    return $Self->GetResults();
}

1;
