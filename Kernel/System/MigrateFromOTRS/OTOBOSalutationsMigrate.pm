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

package Kernel::System::MigrateFromOTRS::OTOBOSalutationsMigrate;

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

Kernel::System::MigrateFromOTRS::OTOBOSalutationsMigrate - Migrate salutations table to OTOBO.

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
            Task      => 'OTOBOSalutationsMigrate',
            SubTask   => "Migrate salutation templates to OTOBO.",
            StartTime => $Epoch,
        },
    );

    # map wrong to correct tags
    my %OldTag2NewTag = (

        # ATTENTION, don't use opening or closing tags here (< or >)
        # because old salutations can contain quoted tags (&lt; or &gt;)
        'OTRS' => 'OTOBO',
    );

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name, text FROM salutation',
    );

    # get all notification messages
    my @Salutations;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        push @Salutations, {
            ID   => $Row[0],
            Name => $Row[1],
            Text => $Row[2],
        };
    }

    SALUTATION:
    for my $Salutation (@Salutations) {

        # remember if we need to replace something
        my $NeedToReplace;

        # get old tag
        for my $OldTag ( sort keys %OldTag2NewTag ) {

            # get new tag
            my $NewTag = $OldTag2NewTag{$OldTag};

            # replace tags in Subject and Text
            ATTRIBUTE:
            for my $Attribute (qw(Name Text)) {

                # only if old tags are found
                next ATTRIBUTE if $Salutation->{$Attribute} !~ m{$OldTag}xms;

                # replace the wrong tags
                $Salutation->{$Attribute} =~ s{$OldTag}{$NewTag}gxms;

                # remember that we replaced something
                $NeedToReplace = 1;
            }
        }

        # only change the database if something has been really replaced
        next SALUTATION unless $NeedToReplace;

        # update the database
        $DBObject->Do(
            SQL => 'UPDATE salutation
                SET name = ?, text = ?
                WHERE id = ?',
            Bind => [
                \$Salutation->{Name},
                \$Salutation->{Text},
                \$Salutation->{ID},
            ],
        );
    }

    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate database table salutation.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Migration completed, perfect!");
    $Result{Successful} = 1;

    return \%Result;
}

1;
