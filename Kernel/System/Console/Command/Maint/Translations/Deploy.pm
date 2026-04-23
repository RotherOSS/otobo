# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::Console::Command::Maint::Translations::Deploy;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Translations
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        'Deploy the translations. This needs to be execute as part of the upgrade procedure'
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject       = $Kernel::OM->Create('Kernel::Config');
    my $TranslationsObject = $Kernel::OM->Create('Kernel::System::Translations');

    my %LanguageID2Name = $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages')->%*;
    my $NumLanguages    = scalar keys %LanguageID2Name;

    $Self->Print("Handling $NumLanguages languages\n");

    my ( $NumSkipped, $NumFailures, $NumDeployed ) = ( 0, 0, 0 );
    LANGUAGE_ID:
    for my $LanguageID ( sort keys %LanguageID2Name ) {
        my $Name = $LanguageID2Name{$LanguageID};

        # fetch active translations, not draft translation as the name of the subroutine name suggests
        my $TranslationItems = $TranslationsObject->DraftTranslationsGet(
            Language => $LanguageID,
            Active   => 1
        );

        my %ActiveTranslations =
            map { $_->{Content} => $_->{Translation} }
            $TranslationItems->@*;

        if ( !%ActiveTranslations ) {
            $Self->PrintWarning("Skipping $Name $LanguageID as there are no active translations\n");
            $NumSkipped++;

            next LANGUAGE_ID;
        }

        # write the translation file unconditionally
        my $RetCode = $TranslationsObject->WriteActiveTranslationsToFile(
            UserLanguage => $LanguageID,
            Translations => \%ActiveTranslations,
        );

        if ( !$RetCode ) {
            $Self->PrintError("Could not write translations for $Name  $LanguageID\n");
            $NumFailures++;
        }
        elsif ( $RetCode == 3 ) {
            $Self->PrintError("Could not write translations for $Name  $LanguageID. Reverted back to the previous translations.\n");
            $NumFailures++;
        }
        else {
            $NumDeployed++;
        }
    }

    $Self->Print("Skipped deployment for $NumSkipped languages\n");
    $Self->Print("Deployed translations for $NumDeployed languages\n");

    if ($NumFailures) {
        $Self->PrintError("Deploying translations failed for $NumFailures languages\n");

        return $Self->ExitCodeError;
    }

    $Self->PrintOk('success');

    return $Self->ExitCodeOk;
}

1;
