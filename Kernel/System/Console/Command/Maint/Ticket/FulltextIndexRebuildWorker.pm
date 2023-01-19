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

## nofilter(TidyAll::Plugin::OTOBO::Perl::NoExitInConsoleCommands)

package Kernel::System::Console::Command::Maint::Ticket::FulltextIndexRebuildWorker;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

use POSIX ":sys_wait_h";
use Time::HiRes qw();
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::PID',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Rebuild the article search index for needed articles.');
    $Self->AddOption(
        Name        => 'children',
        Description => "Specify the number of child processes to be used for indexing (default: 4, maximum: 20).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'limit',
        Description => "Maximum number of ArticleIDs to process (default: 20000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'force-pid',
        Description => "Start even if another process is still registered in the database.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Children = $Self->GetOption('children') // 4;

    if ( $Children > 20 ) {
        die "The allowed maximum amount of child processes is 20!\n";
    }

    my $ForcePID = $Self->GetOption('force-pid');

    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

    my %PID = $PIDObject->PIDGet(
        Name => 'ArticleSearchIndexRebuild',
    );

    if ( %PID && !$ForcePID ) {
        die "Active indexing process already running! Skipping...\n";
    }

    my $Success = $PIDObject->PIDCreate(
        Name  => 'ArticleSearchIndexRebuild',
        Force => $Self->GetOption('force-pid'),
    );

    if ( !$Success ) {
        die "Unable to register indexing process! Skipping...\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Children = $Self->GetOption('children') // 4;
    my $Limit    = $Self->GetOption('limit')    // 20000;

    my %ArticleTicketIDs = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchIndexRebuildFlagList(
        Value => 1,
        Limit => $Limit,
    );

    # perform the indexing if needed
    if (%ArticleTicketIDs) {
        $Self->ArticleIndexRebuild(
            ArticleTicketIDs => \%ArticleTicketIDs,
            Children         => $Children,
        );
    }
    else {
        $Self->Print("<yellow>No indexing needed! Skipping...</yellow>\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub ArticleIndexRebuild {
    my ( $Self, %Param ) = @_;

    my @ArticleIDs = keys %{ $Param{ArticleTicketIDs} };

    $Kernel::OM->Get('Kernel::System::DB')->Disconnect();

    # Destroy objects for the child processes.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
        ],
        ForcePackageReload => 0,
    );

    # Split ArticleIDs into equal arrays for the child processes.
    my @ArticleChunks;
    my $Count = 0;

    for my $ArticleID (@ArticleIDs) {
        push @{ $ArticleChunks[ $Count++ % $Param{Children} ] }, $ArticleID;
    }

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my %ActiveChildPID;

    ARTICLEIDCHUNK:
    for my $ArticleIDChunk (@ArticleChunks) {

        # Create a child process.
        my $PID = fork;

        # Could not create child.
        if ( $PID < 0 ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Unable to fork to a child process for article index rebuild!"
            );
            last ARTICLEIDCHUNK;
        }

        # We're in the child process.
        if ( !$PID ) {

            # Add the chunk of article data to the index.
            for my $ArticleID ( @{$ArticleIDChunk} ) {

                my $Success = 0;

                if (
                    $ConfigObject->Get('Ticket::ArchiveSystem')
                    && !$ConfigObject->Get('Ticket::SearchIndex::IndexArchivedTickets')
                    && $TicketObject->TicketArchiveFlagGet( TicketID => $Param{ArticleTicketIDs}->{$ArticleID} )
                    )
                {
                    $Success = $ArticleObject->ArticleSearchIndexDelete(
                        ArticleID => $ArticleID,
                        UserID    => 1,
                    );
                }
                else {
                    $Success = $ArticleObject->ArticleSearchIndexBuild(
                        TicketID  => $Param{ArticleTicketIDs}->{$ArticleID},
                        ArticleID => $ArticleID,
                        UserID    => 1,
                    );
                }

                if ( !$Success ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Could not rebuild index for ArticleID '$ArticleID'!"
                    );
                }
                else {
                    $ArticleObject->ArticleSearchIndexRebuildFlagSet(
                        ArticleIDs => [$ArticleID],
                        Value      => 0,
                    );
                }
            }

            # Close child process at the end.
            exit 0;
        }

        $ActiveChildPID{$PID} = {
            PID => $PID,
        };
    }

    # Check the status of all child processes every 0.1 seconds.
    # Wait for all child processes to be finished.
    WAIT:
    while (1) {

        last WAIT if !%ActiveChildPID;

        Time::HiRes::sleep 0.1;

        PID:
        for my $PID ( sort keys %ActiveChildPID ) {

            my $WaitResult = waitpid( $PID, WNOHANG );

            if ( $WaitResult == -1 ) {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Child process exited with errors: $?",
                );

                delete $ActiveChildPID{$PID};

                next PID;
            }

            delete $ActiveChildPID{$PID} if $WaitResult;
        }
    }

    return 1;
}

sub PostRun {
    my ($Self) = @_;

    my $Success = $Kernel::OM->Get('Kernel::System::PID')->PIDDelete(
        Name => 'ArticleSearchIndexRebuild',
    );

    if ( !$Success ) {
        $Self->PrintError("Unable to unregister indexing process! Skipping...\n");
        return $Self->ExitCodeError();
    }

    return $Success;
}

1;
