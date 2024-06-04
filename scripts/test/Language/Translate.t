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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# create language object which contains all translations
$Kernel::OM->ObjectParamAdd(
    'Kernel::Language' => {
        UserLanguage => 'de',
    },
);
my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

# test cases
my @Tests = (
    {
        OriginalString    => '0',    # test with zero
        TranslationString => '',     # test without a translation string
        TranslationResult => '0',
    },
    {
        OriginalString    => 'OTOBOLanguageUnitTest::Test1',
        TranslationString => 'Test1',
        TranslationResult => 'Test1',
        Parameters        => ['Hallo'],                        # test with not needed parameter
    },
    {
        OriginalString    => 'OTOBOLanguageUnitTest::Test2',
        TranslationString => 'Test2 [%s]',
        TranslationResult => 'Test2 [Hallo]',
        Parameters        => ['Hallo'],
    },
    {
        OriginalString    => 'OTOBOLanguageUnitTest::Test3',
        TranslationString => 'Test3 [%s] (A=%s)',
        TranslationResult => 'Test3 [Hallo] (A=A)',
        Parameters        => [ 'Hallo', 'A' ],
    },
    {
        OriginalString    => 'OTOBOLanguageUnitTest::Test4',
        TranslationString => 'Test4 [%s] (A=%s;B=%s)',
        TranslationResult => 'Test4 [Hallo] (A=A;B=B)',
        Parameters        => [ 'Hallo', 'A', 'B' ],
    },
    {
        OriginalString    => 'OTOBOLanguageUnitTest::Test5',
        TranslationString => 'Test5 [%s] (A=%s;B=%s;C=%s)',
        TranslationResult => 'Test5 [Hallo] (A=A;B=B;C=C)',
        Parameters        => [ 'Hallo', 'A', 'B', 'C' ],
    },
    {
        OriginalString    => 'OTOBOLanguageUnitTest::Test6',
        TranslationString => 'Test6 [%s] (A=%s;B=%s;C=%s;D=%s)',
        TranslationResult => 'Test6 [Hallo] (A=A;B=B;C=C;D=D)',
        Parameters        => [ 'Hallo', 'A', 'B', 'C', 'D' ],
    },
    {
        OriginalString    => 'OTOBOLanguageUnitTest::Test7 [% test %] {" special characters %s"}',
        TranslationString => 'Test7 [% test %] {" special characters %s"}',
        TranslationResult => 'Test7 [% test %] {" special characters test"}',
        Parameters        => ['test'],
    },
);

for my $Test (@Tests) {

    # add translation string to language object
    $LanguageObject->{Translation}->{ $Test->{OriginalString} } = $Test->{TranslationString};

    # get the translation
    my $TranslatedString;

    # test cases with parameters
    if ( $Test->{Parameters} ) {

        $TranslatedString = $LanguageObject->Translate(
            $Test->{OriginalString},
            @{ $Test->{Parameters} },
        );
    }

    # test cases without a parameter
    else {
        $TranslatedString = $LanguageObject->Translate(
            $Test->{OriginalString},
        );
    }

    # compare with expected translation
    $Self->Is(
        $TranslatedString // '',
        $Test->{TranslationResult},
        'Translation of ' . $Test->{OriginalString},
    );
}

$Self->DoneTesting();
