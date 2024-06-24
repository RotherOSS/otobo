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

package Kernel::System::MigrateFromOTRS::OTOBONotificationMigrate;

use strict;
use warnings;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBONotificationMigrate - Migrate Notification table to OTOBO.

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

=head2 Run()

Execute the migration task. Called by C<Kernel::System::MigrateFromOTRS::_ExecuteRun()>.

=cut

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
            Task      => 'OTOBONotificationMigrate',
            SubTask   => "Migrate notifications to OTOBO.",
            StartTime => $Epoch,
        },
    );

    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate database table notification.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Migration failed.");
    $Result{Successful} = 0;

    # map wrong to correct tags
    my %OldTag2NewTag = (

        # ATTENTION, don't use opening or closing tags here (< or >)
        # because old notifications can contain quoted tags (&lt; or &gt;)
        'OTRS_' => 'OTOBO_',
    );

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return \%Result if !$DBObject->Prepare(
        SQL => 'SELECT id, subject, text FROM notification_event_message',
    );

    # get all notification messages
    my @NotificationMessages;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        push @NotificationMessages, {
            ID      => $Row[0],
            Subject => $Row[1],
            Text    => $Row[2],
        };
    }

    NOTIFICATION_MESSAGE:
    for my $NotificationMessage (@NotificationMessages) {

        # remember if we need to replace something
        my $NeedToReplace;

        # get old tag
        for my $OldTag ( sort keys %OldTag2NewTag ) {

            # get new tag
            my $NewTag = $OldTag2NewTag{$OldTag};

            # replace tags in Subject and Text
            ATTRIBUTE:
            for my $Attribute (qw(Subject Text)) {

                # only if old tags are found
                next ATTRIBUTE if $NotificationMessage->{$Attribute} !~ m{$OldTag}xms;

                # replace the wrong tags
                $NotificationMessage->{$Attribute} =~ s{$OldTag}{$NewTag}gxms;

                # remember that we replaced something
                $NeedToReplace = 1;
            }
        }

        # only change the database if something has been really replaced
        next NOTIFICATION_MESSAGE unless $NeedToReplace;

        # update the database
        $DBObject->Do(
            SQL => 'UPDATE notification_event_message
                SET subject = ?, text = ?
                WHERE id = ?',
            Bind => [
                \$NotificationMessage->{Subject},
                \$NotificationMessage->{Text},
                \$NotificationMessage->{ID},
            ],
        );
    }

    $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate database table notification.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Migration completed, perfect!");
    $Result{Successful} = 1;

    return \%Result;
}

1;
