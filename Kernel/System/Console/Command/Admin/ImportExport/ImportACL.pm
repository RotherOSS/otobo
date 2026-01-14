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

package Kernel::System::Console::Command::Admin::ImportExport::ImportACL;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::ACL::DB::ACL',
    'Kernel::System::Cache',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Import ACL data from a YAML file.');
    $Self->AddOption(
        Name        => 'update',
        Description => "Flag if existing ACLs should be overwritten.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'deploy',
        Description => "Flag if imported ACLs should be deployed.",
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

    $Self->Print("<yellow>Starting ACL import...</yellow>\n");

    # get object
    my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

    # fetch params
    my $File                      = $Self->GetArgument('source') || '';
    my $OverwriteExistingEntities = $Self->GetOption('update')   || 0;
    my $Deploy                    = $Self->GetOption('deploy')   || 0;

    # shortcut for error printing
    my $Error = sub {
        $Self->Print("<red>$_[0]</red>\n");

        $Self->ExitCodeError();
    };

    # read file
    my $ACLYAML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
    );

    # process content
    my $ACLImport = $ACLObject->ACLImport(
        Content                   => ${$ACLYAML},
        OverwriteExistingEntities => $OverwriteExistingEntities,
        UserID                    => 1,
    );
    if ( !$ACLImport->{Success} ) {
        my $Message = $ACLImport->{Message}
            || 'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information';
        return $Error->($Message);
    }

    if ( $ACLImport->{AddedACLs} ) {
        my $Message = sprintf(
            'The following ACLs have been added successfully: %s',
            $ACLImport->{AddedACLs}
        );
        $Self->Print("<green>$Message</green>\n");
    }
    if ( $ACLImport->{UpdatedACLs} ) {
        my $Message = sprintf(
            'The following ACLs have been updated successfully: %s',
            $ACLImport->{UpdatedACLs}
        );
        $Self->Print("<green>$Message</green>\n");
    }
    if ( $ACLImport->{ACLErrors} ) {
        my $Message = sprintf(
            'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.',
            $ACLImport->{ACLErrors}
        );
        return $Error->($Message);
    }

    if ($Deploy) {

        my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZACL.pm';

        my $ACLDumpSuccess = $ACLObject->ACLDump(
            ResultType => 'FILE',
            Location   => $Location,
            UserID     => 1,
        );

        if ($ACLDumpSuccess) {

            my $Success = $ACLObject->ACLsNeedSyncReset();

            # remove preselection cache TODO: rebuild the cache properly (a simple $FieldRestrictionsObject->SetACLPreselectionCache(); uses the old ACLs)
            my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
            for my $ObjectType (qw(Ticket ConfigItem)) {
                $CacheObject->Delete(
                    Type => $ObjectType . 'ACL',    # only [a-zA-Z0-9_] chars usable
                    Key  => 'Preselection',
                );

                if ( !$Success ) {

                    # show error if can't set state
                    my $Message = sprintf(
                        'There was an error setting the entity sync status.',
                        $ACLImport->{ACLErrors}
                    );
                    return $Error->($Message);
                }
            }
        }
        else {

            # show error if can't sync
            my $Message = sprintf(
                'There was an error synchronizing the ACLs.',
                $ACLImport->{ACLErrors}
            );
            return $Error->($Message);
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
