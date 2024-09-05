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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# objects needed for test

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
isa_ok( $DBObject, ['Kernel::System::DB'], 'got a DB object' );
$DBObject->Connect();

my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');
isa_ok( $TranslationsObject, ['Kernel::System::Translations'], 'got a Translations object' );

my $Tz = Kernel::System::DateTime->UserDefaultTimeZoneGet();

# main test function executed for each scenario

sub TestAdminTranslation {

    my %Params = @_;

    # see if there is an existing translation
    my $OldTranslation = _GetExistingAdminTranslation(
        Content    => $Params{Content},
        LanguageId => $Params{LanguageId},
    );

    # set userid to translation owner, or use admin if new
    my $UserId = $OldTranslation ? $OldTranslation->{CreateBy} : 1;

    # delete any existing Translations for this $Content key
    if ($OldTranslation) {
        _DeleteTranslation(
            TranslationId => $OldTranslation->{Id},
            UserId        => $UserId,
            LanguageId    => $Params{LanguageId},
            Content       => $Params{Content},
            Translation   => $Params{Translation}
        );
    }

    # add a Translation Draft for the new translation key
    my $Result = $TranslationsObject->DraftTranslationsAdd(
        Language    => $Params{LanguageId},
        Content     => $Params{Content},
        Translation => $Params{Translation},
        UserID      => $UserId,
    );

    # is it expected to fail?
    if ( !defined $Params{ExpectedResult} ) {

        is(
            $Result,
            undef,
            "Translation ($Params{LanguageId}) draft for <$Params{Content}> failed as intended."
        );

        # cleanup
        if ($OldTranslation) {
            _RestoreOldTranslation($OldTranslation);
        }
        return;
    }

    # should have a valid Translation draft now
    is(
        $Result,
        1,
        "Translation ($Params{LanguageId}) draft for <$Params{Content}> added successfully."
    );

    # deploy Translation draft
    $Result = $TranslationsObject->WriteTranslationFile(
        UserLanguage => $Params{LanguageId},
    );

    is(
        $Result,
        1,
        "Translation ($Params{LanguageId}) draft for <$Params{Content}> deployed successfully."
    );

    # fetch the new translation so that we can clean it up later
    my $NewTranslation = _GetExistingAdminTranslation(
        Content    => $Params{Content},
        LanguageId => $Params{LanguageId},
    );
    ok( $NewTranslation, "have new Translation." );

    # re-fetch Language object from OM after update
    $Kernel::OM->ObjectsDiscard();

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Language' => {
            UserTimeZone => $Tz,
            UserLanguage => $Params{LanguageId},
            Action       => '',
            Debug        => 1
        },
    );
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    isa_ok(
        $LanguageObject,
        ['Kernel::Language'], 'got a Language object'
    );

    # test for the new translation to be actually applied
    my $Translated = $LanguageObject->Translate( $Params{Content} );
    is(
        $Translated,
        $Params{Translation},
        "Translation ($Params{LanguageId})  <$Params{Translation}> for <$Params{Content}> applied successfully."
    );

    # cleanup
    _DeleteTranslation(
        TranslationId => $NewTranslation->{Id},
        UserId        => $UserId,
        LanguageId    => $Params{LanguageId},
        Content       => $Params{Content},
        Translation   => $Params{Translation}
    );

    if ($OldTranslation) {
        _RestoreOldTranslation($OldTranslation);
    }

    return;
}

# all the Test Case scenarios

my @AdminTranslationTestCases = (
    {
        LanguageId     => 'en',
        Content        => 'Tickets',
        Translation    => 'TheWonderfulTranslationForTicket',
        ExpectedResult => 1
    },
    {
        LanguageId     => 'de',
        Content        => 'Tickets',
        Translation    => ' Tickets++',
        ExpectedResult => 1
    },
    {
        LanguageId     => 'de',
        Content        => 'Tickets',
        Translation    => 'Tickets++ ',
        ExpectedResult => 1
    },
    {
        LanguageId     => 'de',
        Content        => 'Tickets',
        Translation    => ' Tickets++ ',
        ExpectedResult => 1
    },
    {
        LanguageId     => 'en',
        Content        => ' Tickets',
        Translation    => 'TheWonderfulTranslationForTicket',
        ExpectedResult => 1
    },
    {
        LanguageId     => 'en',
        Content        => ' Tickets ',
        Translation    => 'TheWonderfulTranslationForTicket',
        ExpectedResult => 1
    },
    {
        LanguageId     => 'en',
        Content        => ' Tickets ',
        Translation    => 'TheWonderfulTranslationForTicket',
        ExpectedResult => 1
    },
    {
        LanguageId     => 'en',
        Content        => '',                                   # invalid
        Translation    => 'TheWonderfulTranslationForTicket',
        ExpectedResult => undef
    },
    {
        LanguageId     => 'en',
        Content        => 'Tickets',
        Translation    => '',                                   # invalid
        ExpectedResult => undef
    }
);

for my $TestCase (@AdminTranslationTestCases) {

    TestAdminTranslation(%$TestCase);
}

done_testing;

########################################
# test helpers
########################################

sub _GetExistingAdminTranslation {

    my %Params = @_;

    my $LanguageId = $Params{LanguageId};
    my $Content    = $Params{Content};

    $DBObject->Prepare(
        SQL  => "SELECT id, create_by, content, translation, language FROM translation_item WHERE language = ? AND content = ? ",
        Bind => [ \$LanguageId, \$Content ]
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {
        return {
            Id          => $Row[0],
            CreateBy    => $Row[1],
            Content     => $Row[2],
            Translation => $Row[3],
            Language    => $Row[4],
        };
    }
    return;
}

sub _DeleteTranslation {

    my %Params = @_;

    my $Result = $TranslationsObject->DraftTranslationDelete(
        Language    => $Params{LanguageId},
        UserID      => $Params{UserId},
        Mark        => 1,
        Content     => $Params{Content},
        Translation => $Params{Translation},
        ID          => $Params{TranslationId},
    );

    is( $Result, 1, "Translation ($Params{LanguageId}) deleted successfully" );

    $Result = $TranslationsObject->WriteTranslationFile(
        UserLanguage => $Params{LanguageId},
    );

    is( $Result, 1, "Translations ($Params{LanguageId}) deployed successfully after delete" );

    return;
}

sub _RestoreOldTranslation {

    my $OldTranslation = shift;

    my $Result = $TranslationsObject->DraftTranslationsAdd(
        Language    => $OldTranslation->{Language},
        Content     => $OldTranslation->{Content},
        Translation => $OldTranslation->{Translation},
        UserID      => $OldTranslation->{CreateBy},
    );

    is( $Result, 1, "Translation ($OldTranslation->{Language}) restored successfully" );

    $Result = $TranslationsObject->WriteTranslationFile(
        UserLanguage => 'en',
    );

    is( $Result, 1, "Translations ($OldTranslation->{Language}) file deployed successfully" );

    return;
}
