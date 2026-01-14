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

package Kernel::System::Console::Command::Admin::ImportExport::ImportProcess;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::ProcessManagement::DB::Entity',
    'Kernel::System::ProcessManagement::DB::Process',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Import a process from a YAML file.');
    $Self->AddOption(
        Name        => 'update',
        Description => "Flag if an existing process should be overwritten.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'deploy',
        Description => "Flag if imported processes should be deployed.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'source',
        Description => "Specify the path to the file which contains the data for importing.",
        Required    => 1,
        ValueRegex  => qr/.*/,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->GetArgument('source');
    if ( !$Source ) {

        # source is optional, even if an import without source is unsatisfying
    }
    elsif ( -r $Source ) {

        # a readable file is fine
    }
    else {
        die "The source $Source does not exist or can not be read.";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Start importing Process...</yellow>\n");

    my $EntityObject  = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity');
    my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

    my $File                      = $Self->GetArgument('source') || '';
    my $OverwriteExistingEntities = $Self->GetOption('update')   || 0;
    my $Deploy                    = $Self->GetOption('deploy')   || 0;

    # shortcut for error printing
    my $Error = sub {
        $Self->Print("<red>$_[0]</red>\n");

        $Self->ExitCodeError();
    };

    my $Content = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
        Mode     => 'utf8',
    );

    # import the process YAML file
    my %ProcessImport = $ProcessObject->ProcessImport(
        Content                   => ${$Content},
        OverwriteExistingEntities => $OverwriteExistingEntities,
        UserID                    => 1,
    );
    if ( !$ProcessImport{Success} ) {
        $Error->("$ProcessImport{Message}\n$ProcessImport{Comment}");
    }

    if ($Deploy) {

        my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZProcessManagement.pm';

        my $ProcessDump = $ProcessObject->ProcessDump(
            ResultType => 'FILE',
            Location   => $Location,
            UserID     => 1,
        );

        if ($ProcessDump) {

            my $Success = $EntityObject->EntitySyncStatePurge(
                UserID => 1,
            );

            if ( !$Success ) {

                # show error if can't set state
                $Error->('There was an error setting the entity sync status.');
            }
        }
        else {

            # show error if can't sync
            $Error->('There was an error synchronizing the processes.');
        }
    }

    # # set entity sync state
    # my $Success = $EntityObject->EntitySyncStateSet(
    #     EntityType => 'Process',
    #     EntityID   => $EntityID,
    #     SyncState  => 'not_sync',
    #     UserID     => $Self->{UserID},
    # );

    # # show error if can't set
    # if ( !$Success ) {
    #     return $LayoutObject->ErrorScreen(
    #         Message => $LayoutObject->{LanguageObject}->Translate(
    #             'There was an error setting the entity sync status for Process entity: %s', $EntityID
    #         ),
    #     );
    # }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
