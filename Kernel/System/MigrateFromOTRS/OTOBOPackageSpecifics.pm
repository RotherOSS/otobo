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

package Kernel::System::MigrateFromOTRS::OTOBOPackageSpecifics;

use strict;
use warnings;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::FAQ',
    'Kernel::System::Package',
    'Kernel::System::Console::Command::Maint::ITSM::Configitem::DefinitionPerl2YAML',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOPackageSpecifics - Migrate response table to OTOBO.

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
    my $CacheObject   = $Kernel::OM->Get('Kernel::System::Cache');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my @SubTasks = (
        {
            Package     => 'FAQ',
            Description => 'Change source path of inline images.',
            Result      => 'Changed path of inline images.',
            Sub         => \&_FAQ_InlineImg,
        },
        {
            Package     => 'ITSMConfigurationManagement',
            Description => 'Change ConfigItem definition from perl to yaml.',
            Result      => 'Changed ConfigItem definition from perl to yaml.',
            Sub         => \&_ITSM_ChangeDefinition,
        },

        #        {
        #            Package     => 'Name of Package required',
        #            Description => 'What are we doing?',
        #            Result      => 'What was done in case of success.',
        #            Sub         => \&Subroutine,
        #        },
    );

    my %Done;
    my %Failed;
    SUBTASK:
    for my $SubTask (@SubTasks) {

        next SUBTASK if !$PackageObject->PackageIsInstalled( Name => $SubTask->{Package} );

        my $Epoch = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task      => 'OTOBOPackageSpecifics',
                SubTask   => $SubTask->{Description},
                StartTime => $Epoch,
            },
        );

        if ( $SubTask->{Sub}->($Self) ) {
            push @{ $Done{ $SubTask->{Package} } }, $SubTask->{Result};
        }
        else {
            push @{ $Failed{ $SubTask->{Package} } }, $SubTask->{Description};
        }

    }

    my %Result = (
        Message    => $Self->{LanguageObject}->Translate('Package specific tasks'),
        Successful => 1,
    );

    if (%Done) {
        $Result{Comment} = $Self->{LanguageObject}->Translate('Done -');
        for my $Package ( sort keys %Done ) {
            $Result{Comment} .= " $Package:";
            for my $Task ( @{ $Done{$Package} } ) {
                $Result{Comment} .= " $Task";
            }
        }
    }

    if (%Failed) {
        $Result{Comment} .= $Result{Comment} ? ' ' : '';
        $Result{Comment} .= $Self->{LanguageObject}->Translate('Failed at -');
        for my $Package ( sort keys %Failed ) {
            $Result{Comment} .= " $Package:";
            for my $Task ( @{ $Failed{$Package} } ) {
                $Result{Comment} .= " $Task";
            }
        }

        $Result{Successful} = 0;
    }

    return \%Result;
}

sub _FAQ_InlineImg {
    my ( $Self, %Param ) = @_;

    my %Substitutions = (
        qr/src="\/otrs\/index\.pl/ => 'src="/otobo/index.pl',
    );

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');
    my @FAQIDs    = $FAQObject->FAQSearch(
        Number => '*',
        Limit  => '1000000',
        UserID => 1,
    );

    my $Success = 1;

    FAQ:
    for my $FAQID (@FAQIDs) {
        my %FAQ = $FAQObject->FAQGet(
            ItemID     => $FAQID,
            ItemFields => 1,
            UserID     => 1,
        );

        my $Substituded = 0;

        for my $i ( 1 .. 6 ) {
            for my $RegEx ( keys %Substitutions ) {
                $Substituded = 1 if ( $FAQ{"Field$i"} && $FAQ{"Field$i"} =~ s/$RegEx/$Substitutions{ $RegEx }/g );
            }
        }

        next FAQ if !$Substituded;

        $Success = 0 if ( !$FAQObject->FAQUpdate( %FAQ, UserID => 1 ) );
    }

    return $Success;
}

sub _ITSM_ChangeDefinition {
    my ( $Self, %Param ) = @_;

    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::ITSM::Configitem::DefinitionPerl2YAML');
    my $Success       = 0;

    my ( $Result, $ExitCode );

    {
        local *STDOUT;                      ## no critic qw(Variables::RequireInitializationForLocalVars)
        open STDOUT, '>:utf8', \$Result;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)
        $ExitCode = $CommandObject->Execute();
    }

    $Success = 1 if !$ExitCode;

    return $Success;
}

1;
