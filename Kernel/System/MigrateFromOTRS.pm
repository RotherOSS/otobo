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

    my $Result;
    my $PrevResult;

    $PrevResult = $Self->_ExecutePreCheck(
        Component => 'CheckPreviousRequirement',
        %Param,
    );

    if ($PrevResult == 1) {
        $Result = $Self->_ExecuteComponent(
            Component => 'Run',
            %Param,
        );
    }

    return $Result;
}

sub _ExecutePreCheck {
    my ( $Self, %Param ) = @_;

    my $Result = 0;

    my @Tasks = $Self->_TasksGet();

    if ($Param{Task} ne 'All' ) {
        # laufe rückwärts über die indizes
        for my $i (reverse 0 .. $#Tasks) {
            # bedingung trifft zu
            my %TaskModul = %{$Tasks[$i]};
            my $Module = $TaskModul{Module};
            if ( $Param{Task} ne $Module ) {
                # entferne genau ein element ein stelle $i
                splice @Tasks, $i, 1;
            }
        }
    }

    if ( !$Tasks[0]->{Module} ) {
        print STDERR "No valid Module " . $Tasks[0]->{Module} . " found. Perhaps you need to add the new check to ".'$Self->_TasksGet().';
        $Result = 0;
    }
#    use Data::Dumper;
#    print STDERR "Tasks: ".Dumper(\@Tasks)."\n";
    # Get the number of total steps.
    my $Steps               = scalar @Tasks;
    my $CurrentStep         = 1;

    TASK:
    for my $Task (@Tasks) {

        next TASK if !$Task;
        next TASK if !$Task->{Module};

        my $ModuleName = "Kernel::System::MigrateFromOTRS::$Task->{Module}";

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            last TASK;
        }

        # Run module.
#        $Kernel::OM->ObjectParamAdd(
#            "Kernel::System::MigrateFromOTRS::$Task->{Module}" => {
#                Opts => $Self->{Opts},
#            },
#        );

        $Self->{TaskObjects}->{$ModuleName} //= $Kernel::OM->Create($ModuleName);
        if ( !$Self->{TaskObjects}->{$ModuleName} ) {
            last TASK;
        }

        # Execute previous check, printing a different message
        elsif ( $Self->{TaskObjects}->{$ModuleName}->can("CheckPreviousRequirement") ) {

            $Result = $Self->{TaskObjects}->{$ModuleName}->CheckPreviousRequirement(%Param);

        }

        # Do not handle timing if task has no appropriate component.
        else {
            next TASK;
        }

        $CurrentStep++;
    }

    return $Result;
}

sub _ExecuteComponent {
    my ( $Self, %Param ) = @_;

    my %Result;

    my @Tasks = $Self->_TasksGet();

    if ($Param{Task} ne 'All' ) {
        # laufe rückwärts über die indizes
        for my $i (reverse 0 .. $#Tasks) {
            # bedingung trifft zu
            my %TaskModul = %{$Tasks[$i]};
            my $Module = $TaskModul{Module};
            if ( $Param{Task} ne $Module ) {
                # entferne genau ein element ein stelle $i
                splice @Tasks, $i, 1;
            }
        }
    }

    if ( !$Tasks[0]->{Module} ) {
        $Result{Message}    = $Tasks[0]->{Module};
        $Result{Comment}    = "No valid Module " . $Tasks[0]->{Module} . " found. Perhaps you need to add the new check to ".'$Self->_TasksGet().';
        $Result{Successful} = 0;

    }
#    use Data::Dumper;
#    print STDERR "Tasks: ".Dumper(\@Tasks)."\n";
    # Get the number of total steps.
    my $Steps               = scalar @Tasks;
    my $CurrentStep         = 1;

    TASK:
    for my $Task (@Tasks) {

        next TASK if !$Task;
        next TASK if !$Task->{Module};

        my $ModuleName = "Kernel::System::MigrateFromOTRS::$Task->{Module}";

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            last TASK;
        }

        $Self->{TaskObjects}->{$ModuleName} //= $Kernel::OM->Create($ModuleName);
        if ( !$Self->{TaskObjects}->{$ModuleName} ) {
            last TASK;
        }

        # Execute Run-Component
        if ( $Self->{TaskObjects}->{$ModuleName}->can("Run") ) {
            # print STDERR "    Step $CurrentStep of $Steps: $Task->{Message} ...\n";
            $Result{$Task->{Module}} = $Self->{TaskObjects}->{$ModuleName}->Run(%Param);

            # Add counter to $Result.
            $Result{$Task->{Module}}->{CurrentStep} = $CurrentStep;
        }
        # Do not handle timing if task has no appropriate component.
        else {
            next TASK;
        }
        $CurrentStep++;
    }
    return \%Result;
}

sub _TasksGet {
    my ( $Self, %Param ) = @_;

    my @Tasks = (
        {
            Message => 'Check filesystem connect',
            Module  => 'OTOBOOTRSConnectionCheck',
        },
        {
            Message => 'Check database connect',
            Module  => 'OTOBOOTRSDBCheck',
        },
        {
            Message => 'Check framework version',
            Module  => 'OTOBOFrameworkVersionCheck',
        },
        {
            Message => 'Check required Perl modules',
            Module  => 'OTOBOPerlModulesCheck',
        },
        {
            Message => 'Check installed CPAN modules for known vulnerabilities',
            Module  => 'OTOBOOTRSPackageCheck',
        },
        {
            Message => 'Copy needed files from OTRS',
            Module  => 'OTOBOCopyFilesFromOTRS',
        },
        {
            Message => 'Check if database has been backed up',
            Module  => 'OTOBOOTRSPackageMigration',
        },
        {
            Message => 'Migrate database to OTOBO',
            Module  => 'OTOBODatabaseMigrate',
        },
        {
            Message => 'Migrate notification tags in Ticket notifications',
            Module  => 'OTOBONotificationMigrate',
        },
        {
            Message => 'Migrate salutations to OTOBO style',
            Module  => 'OTOBOSalutationsMigrate',
        },
        {
            Message => 'Migrate signatures to OTOBO style',
            Module  => 'OTOBOSignaturesMigrate',
        },
        {
            Message => 'Migrate response templates to OTOBO style',
            Module  => 'OTOBOResponseTemplatesMigrate',
        },
        {
            Message => 'Migrate auto response templates to OTOBO style',
            Module  => 'OTOBOAutoResponseTemplatesMigrate',
        },
        {
            Message => 'Migrate webservices and add OTOBO ElasticSearch services.',
            Module  => 'OTOBOMigrateWebServiceConfiguration',
        },
        {
            Message => 'Clean up the cache',
            Module  => 'OTOBOCacheCleanup',
        },
        {
            Message => 'Refresh configuration cache',
            Module  => 'OTOBORebuildConfigCleanup',
        },
        {
            Message => 'Migrate OTRS configuration',
            Module  => 'OTOBOMigrateConfigFromOTRS',
        },
        {
            Message => 'Refresh configuration cache after migration of OTRS 6 settings',
            Module  => 'OTOBORebuildConfig',
        },
        {
            Message => 'Clean up the cache',
            Module  => 'OTOBOCacheCleanup',
        },
        {
            Message => 'Refresh configuration cache another time',
            Module  => 'OTOBORebuildConfigCleanup',
        },
        {
            Message => 'Deploy ACLs',
            Module  => 'OTOBOACLDeploy',
        },
        {
            Message => 'Deploy processes',
            Module  => 'OTOBOProcessDeploy',
        },
        {
            Message => 'Check invalid settings',
            Module  => 'OTOBOInvalidSettingsCheck',
        },
    );

    return @Tasks;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
