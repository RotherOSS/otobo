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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Translations::Deploy');

# get helper object, so that the database is cleaned up
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# This test script adds a tranlation for two languages and then calls Maint::Translation::Deploy.
# It is then checked whether these translations are really deployed.
# Previously existing translation files are restored.

my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');
my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');
my $UserID             = 1;

my @TestTranslations = (
    {
        LanguageId  => 'gl',
        Content     => 'Good day',
        Translation => 'Bo dia',
        UserID      => $UserID,
    },
    {
        LanguageId  => 'pt',
        Content     => 'Good day',
        Translation => 'Bom dia',
        UserID      => $UserID,
    },
    {
        LanguageId  => 'pt_BR',
        Content     => 'Good day',
        Translation => 'Bom dia',
        UserID      => $UserID,
    },
);

for my $Test (@TestTranslations) {
    state $Count = 0;
    $Count++;

    my $Result = $TranslationsObject->DraftTranslationsAdd(
        Language    => $Test->{LanguageId},
        Content     => $Test->{Content},
        Translation => $Test->{Translation},
        UserID      => $Test->{UserID},
    );
    ok( $Result, "DraftTranslationsAdd $Test->{LanguageId} $Count" );

    # deploy the translation by setting the flag to 'a' for 'active'
    $DBObject->Do(
        SQL => <<'END_SQL',
UPDATE translation_item
  SET flag = 'a'
  WHERE language = ?
    AND content = ?
END_SQL
        Bind => [
            \$Test->{LanguageId},
            \$Test->{Content},
        ],
    );
}

# run the console command
my $ExitCode = $CommandObject->Execute();
is( $ExitCode, 0, "Maint::Translations::Deploy exit code" );

# Check whether the translation items are deployed
for my $Test (@TestTranslations) {

    # re-fetch Language object from OM after update
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Language'] );
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Language' => {
            UserLanguage => $Test->{LanguageId},
            Debug        => 1
        },
    );

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    isa_ok( $LanguageObject, ['Kernel::Language'], 'got a Kernel::Language object' );

    # test for the new translation to be actually applied
    my $Translated = $LanguageObject->Translate( $Test->{Content} );
    is(
        $Translated,
        $Test->{Translation},
        "Translation ($Test->{LanguageId})  <$Test->{Translation}> for <$Test->{Content}> applied successfully."
    );
}

done_testing;
