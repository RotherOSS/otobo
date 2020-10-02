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

package Kernel::System::MigrateFromOTRS::OTOBOSignaturesMigrate;    ## no critic

use strict;
use warnings;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

use version;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOSignaturesMigrate - Migrate signature table to OTOBO.

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

=head1 PUBLIC INTERFACE

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success.

    my $RequirementIsMet = $MigrateFromOTRSObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    return 1;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Epoch          = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOSignaturesMigrate',
            SubTask   => "Migrate signature templates to OTOBO.",
            StartTime => $Epoch,
        },
    );

    # map wrong to correct tags
    my %NotificationTagsOld2New = (

        # ATTENTION, don't use opening or closing tags here (< or >)
        # because old notifications can contain quoted tags (&lt; or &gt;)
        'OTRS_' => 'OTOBO_',
        'OTRS'  => 'OTOBO',
    );

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name, text FROM signature',
    );

    # get all notification messages
    my @Signatures;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        push @Signatures, {
            ID   => $Row[0],
            Name => $Row[1],
            Text => $Row[2],
        };
    }

    NOTIFICATIONMESSAGE:
    for my $Signature (@Signatures) {

        # remember if we need to replace something
        my $NeedToReplace;

        # get old notification tag
        for my $OldTag ( sort keys %NotificationTagsOld2New ) {

            # get new notification tag
            my $NewTag = $NotificationTagsOld2New{$OldTag};

            # replace tags in Name and Text
            ATTRIBUTE:
            for my $Attribute (qw(Name Text)) {

                # only if old tags are found
                next ATTRIBUTE if $Signature->{$Attribute} !~ m{$OldTag}xms;

                # replace the wrong tags
                $Signature->{$Attribute} =~ s{$OldTag}{$NewTag}gxms;

                # remember that we replaced something
                $NeedToReplace = 1;
            }
        }

        # only change the database if something has been really replaced
        next NOTIFICATIONMESSAGE if !$NeedToReplace;

        # update the database
        $DBObject->Do(
            SQL => 'UPDATE signature
                SET name = ?, text = ?
                WHERE id = ?',
            Bind => [
                \$Signature->{Name},
                \$Signature->{Text},
                \$Signature->{ID},
            ],
        );
    }

    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate database table signature.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Migration completed, perfect!");
    $Result{Successful} = 1;

    return \%Result;
}

1;
