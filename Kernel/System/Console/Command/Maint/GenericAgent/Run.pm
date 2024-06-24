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

package Kernel::System::Console::Command::Maint::GenericAgent::Run;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::GenericAgent',
    'Kernel::System::Main',
    'Kernel::System::PID',
);

# package variables
our %Jobs;    # set up in the generic agent job configuration file

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Run all generic agent jobs from a configuration file.');
    $Self->AddOption(
        Name        => 'configuration-module',
        Description =>
            "Specify the name of the generic agent configuration module (e.g. 'Kernel::System::GenericAgent')",
        Required   => 1,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'ticket-limit',
        Description => "Maximum number of tickets to process per job.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d+/smx,
    );
    $Self->AddOption(
        Name        => 'force-pid',
        Description => "Start even if another process is still registered in the database.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'debug',
        Description => "Print debug info to the OTOBO log.",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AdditionalHelp(
        "This script only runs file based generic agent jobs, database based jobs are handled by the OTOBO Daemon."
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check configuration module
    my $ConfigurationModule = $Self->GetOption('configuration-module');
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ConfigurationModule) ) {
        die "Could not load agent job file '$ConfigurationModule': $!\n";
    }

    $Self->{JobName} = substr 'GenericAgentFile-' . $ConfigurationModule, 0, 200;

    # create PID lock
    my $ForcePID = $Self->GetOption('force-pid');

    # get PID object
    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

    if ( !$ForcePID && !$PIDObject->PIDCreate( Name => $Self->{JobName} ) ) {
        die "Generic agent is already running for $ConfigurationModule module!\n";
    }
    elsif ( $ForcePID && !$PIDObject->PIDCreate( Name => $Self->{JobName} ) ) {
        $Self->Print(
            "NOTICE: generic agent is already running for $ConfigurationModule module, but is starting again!\n"
        );
    }

    # set new PID
    $PIDObject->PIDCreate(
        Name  => $Self->{JobName},
        Force => 1,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Running generic agent jobs...</yellow>\n");

    # make sure generic agent object is destroyed before continue
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::GenericAgent'],
    );

    my $Debug = $Self->GetOption('debug') ? 1 : 0;

    # add parameters to generic agent object
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::GenericAgent' => {
            NoticeSTDOUT => 1,
            Debug        => $Debug,
        },
    );

    # disable in memory cache
    $Kernel::OM->Get('Kernel::System::Cache')->Configure(
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # get generic agent config module (job file)
    my $ConfigurationModule = $Self->GetOption('configuration-module');

    # load/import config jobs
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ConfigurationModule) ) {
        $Self->PrintError("Could not load agent job file '$ConfigurationModule': $!\n");
        return $Self->ExitCodeError();
    }
    eval "import $ConfigurationModule";    ## no critic qw(BuiltinFunctions::ProhibitStringyEval)

    # set the maximum number of affected tickets
    my $Limit = $Self->GetOption('ticket-limit');

    # set generic agent UserID
    my $UserIDOfGenericAgent = 1;

    # get generic agent object
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    # process all config file jobs
    for my $Job ( sort keys %Jobs ) {

        # execute generic agent job
        $GenericAgentObject->JobRun(
            Job    => $Job,
            Limit  => $Limit,
            Config => $Jobs{$Job},
            UserID => $UserIDOfGenericAgent,
        );
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ($Self) = @_;

    # delete pid lock
    return $Kernel::OM->Get('Kernel::System::PID')->PIDDelete(
        Name => $Self->{JobName},
    );
}

1;
