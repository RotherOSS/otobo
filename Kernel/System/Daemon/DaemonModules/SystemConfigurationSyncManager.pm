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

package Kernel::System::Daemon::DaemonModules::SystemConfigurationSyncManager;

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use File::Basename qw(basename);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::Daemon::BaseDaemon Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SystemConfigurationSyncManager - daemon to keep system configuration deployments in sync

=head1 DESCRIPTION

This Daemon module performs two tasks. The first task is to check whether there is a new deployment in the database
that is for some reason not reflected in the config cache F<Kernel/Config/Files/ZZZAAuto.pm>. It performs a new deployment when there
is a discrepancy. When the S3 backend is active then the new ZZZ files are deployed first to the S3 compatible storage.
This means that potential other nodes don't need to sync the deployment again. But they should restart because the config cache has changed.

The second task is to reload the Daemon in case there is a change in the F<Kernel/Config/Files/*.pm> files. This happens
after a deployment sync.

=head1 PUBLIC INTERFACE

=head2 new()

Create system configuration deployment sync object.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = bless {}, $Type;

    # Get objects in constructor in order to increase performance.
    $Self->{ConfigObject}    = $Kernel::OM->Get('Kernel::Config');
    $Self->{CacheObject}     = $Kernel::OM->Get('Kernel::System::Cache');
    $Self->{DBObject}        = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{SysConfigObject} = $Kernel::OM->Get('Kernel::System::SysConfig');
    $Self->{MainObject}      = $Kernel::OM->Get('Kernel::System::Main');

    # Disable in memory cache to be clusterable.
    $Self->{CacheObject}->Configure(
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # Get the NodeID from the SysConfig settings, this is used on High Availability systems.
    $Self->{NodeID} = $Self->{ConfigObject}->Get('NodeID') || 1;

    # Check NodeID, if does not match is impossible to continue.
    if ( $Self->{NodeID} !~ m{ \A \d+ \z }xms && $Self->{NodeID} > 0 && $Self->{NodeID} < 1000 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "NodeID '$Self->{NodeID}' is invalid!",
        );
        return;
    }

    # Do not change the following values!
    $Self->{SleepPost} = 60;    # sleep 1 minute after each loop
    my $Discard = 60 * 60;      # discard every hour
    $Self->{DiscardCount} = $Discard / $Self->{SleepPost};

    $Self->{Debug}      = $Param{Debug};
    $Self->{DaemonName} = 'Daemon: SystemConfigurationSyncManager';

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # Check if database is on-line.
    return 1 if $Self->{DBObject}->Ping();

    sleep 10;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::Config', ],
    );

    # DeploymentID before the call to ConfigurationDeploySync()
    my $OldDeploymentID = $Kernel::OM->Get('Kernel::Config')->Get('CurrentDeploymentID') || 0;

    # Execute the deployment sync
    my $ErrorMessage;
    my $Success;
    if ( $Self->{Debug} ) {
        print "    $Self->{DaemonName} Executes function: ConfigurationDeploySync\n";
    }

    eval {

        # Restore child signal to default, main daemon set it to 'IGNORE' to be able to create
        #   multiple process at the same time, but in workers this causes problems if function does
        #   system calls (on linux), since system calls returns -1. See bug#12126.
        local $SIG{CHLD} = 'DEFAULT';

        # Localize the standard error, everything will be restored after the eval block.
        local *STDERR;    ## no critic qw(Variables::RequireInitializationForLocalVars)

        # Redirect the standard error to a variable.
        open STDERR, '>>', \$ErrorMessage;    ## no critic qw(OTOBO::ProhibitOpen)

        $Success = $Self->{SysConfigObject}->ConfigurationDeploySync();
    };

    # Check if there are errors.
    # Do not log debug messages as Daemon errors. See bug#14722 (https://bugs.otrs.org/show_bug.cgi?id=14722).
    if ( ( $ErrorMessage && $ErrorMessage !~ /Debug: /g ) || !$Success ) {
        $Self->_HandleError(
            TaskName     => 'ConfigurationDeploySync',
            TaskType     => 'SystemConfigurationSyncManager',
            LogMessage   => "There was an error executing ConfigurationDeploySync: $ErrorMessage",
            ErrorMessage => $ErrorMessage || 'ConfigurationDeploySync returns failure.',
        );

        return 1;
    }

    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::Config', ],
    );

    my $NewDeploymentID = $Kernel::OM->Get('Kernel::Config')->Get('CurrentDeploymentID') || 0;

    my $ConfigChange;
    if ( $OldDeploymentID ne $NewDeploymentID ) {
        $ConfigChange = 1;
    }

    my $ConfigDirectory        = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files';
    my %KnownConfigFilesMD5Sum = %{ $Self->{ConfigFilesMD5Sum} // {} };
    my @ChangedFiles;

    # If there is no record for new config files let it run
    my $InitialRun;
    if ( !defined $Self->{ConfigFilesMD5Sum} ) {
        $InitialRun = 1;
    }

    # Check all (perl) config files for changes.
    my @ConfigFiles = $Self->{MainObject}->DirectoryRead(
        Directory => $ConfigDirectory,
        Filter    => '*.pm',
    );

    my $ConfigFileChanged;
    my %NewConfigFilesMD5Sum;
    FILE:
    for my $File (@ConfigFiles) {
        my $Basename = basename($File);

        # Skip deployment based files.
        next FILE if $Basename eq 'ZZZAAuto.pm';

        # Check MD5 against (potentially) stored value.
        my $KnownMD5Sum = delete $KnownConfigFilesMD5Sum{$Basename};
        $NewConfigFilesMD5Sum{$Basename} = $Self->{MainObject}->MD5sum(
            Filename => $File,
        );
        if (
            !$InitialRun
            && (
                !$KnownMD5Sum || $KnownMD5Sum ne $NewConfigFilesMD5Sum{$Basename}
            )
            )
        {
            $ConfigFileChanged = 1;
            push @ChangedFiles, $Basename;
        }
    }

    # Check for missing files.
    if ( scalar keys %KnownConfigFilesMD5Sum ) {
        $ConfigFileChanged = 1;
    }

    $Self->{ConfigFilesMD5Sum} = \%NewConfigFilesMD5Sum;

    # If there was no change in the configuration, do nothing and return gracefully.
    return 1 if ( !$ConfigChange && !$ConfigFileChanged );

    # Stop all daemons and reload configuration from main daemon.
    kill 'HUP', getppid;

    return 1;
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    sleep $Self->{SleepPost};

    $Self->{DiscardCount}--;

    if ( $Self->{Debug} && $Self->{DiscardCount} == 0 ) {
        print "  $Self->{DaemonName} will be stopped and set for restart!\n";
    }

    return if $Self->{DiscardCount} <= 0;    # force a reload of this daemon module
    return 1;
}

sub Summary {
    my ( $Self, %Param ) = @_;

    return (
        {
            Header        => "System configuration sync:",
            Column        => [],
            Data          => [],
            NoDataMessage => "Daemon is active.",
        },
    );
}

sub DESTROY {
    my $Self = shift;

    return 1;
}

1;
