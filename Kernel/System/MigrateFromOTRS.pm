# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::MigrateFromOTRS;    ## no critic

use strict;
use warnings;

#use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
    'Kernel::System::MigrateFromOTRS::Base',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS - Perform system migration from OTRS 6 to OTOBO 10.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $MigrateFromOTRSObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

run migration task

    my $Success = $MigrateFromOTRSObject->Run (
        Task          => 'All' # or only one Task
        UserID        => 123,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Task UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # don't attempt to run when the pre check failed
    return unless $Self->_ExecutePreCheck( %Param );

    return $Self->_ExecuteRun( %Param );
}

sub _ExecutePreCheck {
    my ( $Self, %Param ) = @_;

    # determine the relevant tasks
    my @Tasks;
    {
        my @AllTasks = grep { $_ && $_->{Module} } $Self->_TasksGet();

        if ( $Param{Task} eq 'All' ) {
            @Tasks = @AllTasks;
        }
        else {
            @Tasks = grep { $_->{Module} eq $Param{Task} } @AllTasks;
        }
    }

    if ( !@Tasks ) {
        print STDERR "No valid Module $Param{Task} found. ",
            q{Perhaps you need to add the new check to $Self->_TasksGet().};

        return 0;
    }

    my $IsOK = 0;

    TASK:
    for my $Task (@Tasks) {

        my $ModuleName = "Kernel::System::MigrateFromOTRS::$Task->{Module}";

        # NOTE: This looks strange. When one check succeeded and next check can't be loaded that the
        # check succeeds altogether.
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            last TASK;
        }

        # NOTE: see the note above
        $Self->{TaskObjects}->{$ModuleName} //= $Kernel::OM->Create($ModuleName);
        if ( !$Self->{TaskObjects}->{$ModuleName} ) {
            last TASK;
        }

        # Execute previous check, printing a different message
        # NOTE: when last check succeeds the the check succeeds altogether
        elsif ( $Self->{TaskObjects}->{$ModuleName}->can('CheckPreviousRequirement') ) {

            $IsOK = $Self->{TaskObjects}->{$ModuleName}->CheckPreviousRequirement(%Param);

        }

        # Do not handle CheckPreviousRequirement if task has no appropriate method.
        else {
            next TASK;
        }
    }

    return $IsOK;
}

sub _ExecuteRun {
    my ( $Self, %Param ) = @_;

    # determine the relevant tasks
    my @Tasks;
    {
        my @AllTasks = grep { $_ && $_->{Module} } $Self->_TasksGet();

        if ( $Param{Task} eq 'All' ) {
            @Tasks = @AllTasks;
        }
        else {
            @Tasks = grep { $_->{Module} eq $Param{Task} } @AllTasks;
        }
    }

    if ( !@Tasks ) {

        return {
            Message    => "invalid task $Param{Task}",
            Comment    => "No valid Module $Param{Task} found. "
                . qq{Perhaps you need to add the new check to $Self->_TasksGet().},
            Successful => 0,
        };
    }

    my $CurrentStep = 1;
    my %Result;

    TASK:
    for my $Task (@Tasks) {

        my $ModuleName = "Kernel::System::MigrateFromOTRS::$Task->{Module}";

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            last TASK;
        }

        $Self->{TaskObjects}->{$ModuleName} //= $Kernel::OM->Create($ModuleName);
        if ( !$Self->{TaskObjects}->{$ModuleName} ) {
            last TASK;
        }

        # Execute Run-Component
        if ( $Self->{TaskObjects}->{$ModuleName}->can('Run') ) {

            $Result{ $Task->{Module} } = $Self->{TaskObjects}->{$ModuleName}->Run(%Param);

            # Add counter to $Result.
            $Result{ $Task->{Module} }->{CurrentStep} = $CurrentStep;
        }

        # Do not handle Run if task has no appropriate method.
        else {
            next TASK;
        }
        $CurrentStep++;
    }

    return \%Result;
}

sub _TasksGet {
    my ( $Self, %Param ) = @_;

    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    my @SecurityCheck = $MigrationBaseObject->TaskSecurityCheck();

    return @SecurityCheck;
}

1;
