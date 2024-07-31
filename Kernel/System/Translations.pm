# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::System::Translations;

use strict;
use warnings;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::ModuleRefresh ();

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Queue',
    'Kernel::System::Service',
);

=head1 NAME

Kernel::System::Translations -  Translations lib

=head1 DESCRIPTION

All Translations functions. E. g. to add Translations or to get Translations.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::TranslationsDebug') || 0;

    return $Self;
}

=head2 DraftTranslationsAdd()

add translation items

    my $Success = $TranslationsObject->DraftTranslationsAdd(
        Language    => 'en',
        Content     => 'Red',
        Translation => 'Rojo',
        UserID      => 1,
        Edit        => 0,
        Import      => (1|0),
    );

Returns:

    $Success = 1; #1: Successful, #0: Unsuccessful

=cut

sub DraftTranslationsAdd {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Language Content Translation UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Param{Edit}   ||= '';
    $Param{Import} ||= 0;
    my $Flag = $Param{Edit} ? 'e' : 'n';

    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL =>
            "INSERT INTO translation_item (language, content, translation, flag, create_by, create_time, change_by, change_time, import_param) VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [ \$Param{Language}, \$Param{Content}, \$Param{Translation}, \$Flag, \$Param{UserID}, \$Param{UserID}, \$Param{Import} ]
    );

    return $Success;
}

=head2 DraftTranslationsChange()

change translation items

    my $Success = $TranslationsObject->DraftTranslationsChange(
        ID           => 100,
        Language     => 'en',
        Content      => 'Red',
        Translation  => 'Rojo',
        UserID       => 1
    );

Returns:

    $Success = 1; #1: Successful, #0: Unsuccessful

=cut

sub DraftTranslationsChange {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Language Content Translation ID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "UPDATE translation_item SET translation = ?, change_by = ?, change_time = current_timestamp WHERE id = ? AND content = ? AND language = ?",
        Bind => [ \$Param{Translation}, \$Param{UserID}, \$Param{ID}, \$Param{Content}, \$Param{Language} ]
    );

    return $Success;
}

=head2 DraftTranslationsGet()

get all draft translation items

    my $DraftTranslations = $TranslationsObject->DraftTranslationsGet(
        Language => 'en',
        Active   => 1, #1: Active, #0: Draft
        Import   => (0|1),
    );

Returns:

    $DraftTranslations = [
        {
            ID          => 32,
            Language    => 'en',
            Content     => 'Earth',
            Translation => 'Tierra',
            Flag        => 'n', #n: New, #d: Marked for deletion, #e: Editing
            CreateBy    => 1,
            CreateTime  => '2023-01-01 07:00:00',
            ChangeBy    => 1,
            ChangeTime  => '2023-01-01 07:00:00',
            Import      => 1,
        },
        ...
    ]

=cut

sub DraftTranslationsGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Language} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Language!",
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my @DraftItems;

    $Param{Import} ||= 0;
    my $Flag = $Param{Active} ? "'a'" : "'n','e','d'";

    return \@DraftItems
        if !$DBObject->Prepare(
            SQL =>
            "SELECT id, language, content, translation, flag, create_by, create_time, change_by, change_time FROM translation_item WHERE language = ? and import_param = ? and flag in($Flag) ORDER BY flag, content ASC",
            Bind => [ \$Param{Language}, \$Param{Import} ]
        );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Item = (
            ID          => $Row[0],
            Language    => $Row[1],
            Content     => $Row[2],
            Translation => $Row[3],
            Flag        => $Row[4],
            CreateBy    => $Row[5],
            CreateTime  => $Row[6],
            ChangeBy    => $Row[7],
            ChangeTime  => $Row[8]
        );
        push @DraftItems, \%Item;
    }

    return \@DraftItems;
}

=head2 DraftTranslationsExport()

get all draft translation items for Export process

    my $DraftTranslations = $TranslationsObject->DraftTranslationsExport(
        Language     => ['en', 'de', 'es_CO'],
    );

Returns:

    $DraftTranslations = [
        {
            Language    => 'en',
            Content     => 'Earth',
            en          => 'Earth',
            de          => 'Tierra',
            es          => 'Erde',
        },
        ...
    ]

=cut

sub DraftTranslationsExport {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Language} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Language!",
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my @DraftItems;
    my %Strings;
    my @LanguageIDsQuoted;

    for my $LanguageID ( @{ $Param{Language} } ) {
        push @LanguageIDsQuoted, $DBObject->Quote($LanguageID);
    }

    if ( !@LanguageIDsQuoted ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No Language received!",
        );

        return \@DraftItems;
    }

    my $SQLIn = "'" . join( "', '", @LanguageIDsQuoted ) . "'";

    return \@DraftItems
        if !$DBObject->Prepare(
            SQL => "SELECT distinct(content) FROM translation_item WHERE language in ($SQLIn) and import_param = 0 and flag = 'a' ORDER BY 1 ASC",
        );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Strings{ $Row[0] } = $Row[0];
    }

    for my $Content ( sort keys %Strings ) {
        my %Record;
        my %DraftElement;

        for my $DestLang ( @{ $Param{Language} } ) {
            $DBObject->Prepare(
                SQL  => "SELECT translation FROM translation_item WHERE language = ? and content = ? and import_param = 0 and flag = 'a' ORDER BY content ASC",
                Bind => [ \$DestLang, \$Content ]
            );

            while ( my @Row = $DBObject->FetchrowArray() ) {
                $Record{$DestLang} = $Row[0];
            }

            if ( !$Record{$DestLang} ) {
                $Record{$DestLang} = '';
            }
        }

        $DraftElement{$Content} = \%Record;
        push @DraftItems, \%DraftElement;
    }

    return \@DraftItems;
}

=head2 DraftTranslationDelete()

delete a draft translation item

    my $Success = $TranslationsObject->DraftTranslationDelete(
        Language     => 'en'
        ID           => 100,
        Mark         => '1',    #Optional
        Content     => 'White', #Optional
        Translation => 'Blanco' #Optional
    );

Returns:

    $Success = 1; #1: Successful, #2, #3: Unsuccessful

=cut

sub DraftTranslationDelete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Language UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Param{Mark} ||= '';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Exists   = 0;
    my $Success;

    if ( !$Param{Mark} ) {

        if ( !$Param{ID} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need ID!",
            );

            return;
        }

        #Check if item ID/Language exists in db
        $DBObject->Prepare(
            SQL  => "SELECT id FROM translation_item WHERE language = ? AND id = ? and flag in ('n','e')",
            Bind => [ \$Param{Language}, \$Param{ID} ]
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Exists = 1;
        }

        return 2 if !$Exists;

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM translation_item WHERE id = ?",
            Bind => [ \$Param{ID} ]
        );
    }
    else {

        if ( !$Param{Content} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need Content!",
            );

            return;
        }

        #Check if item Language/Content exists in db
        $DBObject->Prepare(
            SQL  => "SELECT id FROM translation_item WHERE language = ? AND content = ? and flag <> 'a' ",
            Bind => [ \$Param{Language}, \$Param{Content} ]
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Exists = 1;
        }

        return 3 if $Exists;

        $Success = $DBObject->Do(
            SQL =>
                "INSERT INTO translation_item (content, translation, language, flag, create_by, create_time, change_by, change_time, import_param) VALUES (?, ?, ?, 'd', ?, current_timestamp, ?, current_timestamp, 0)",
            Bind =>
                [ \$Param{Content}, \$Param{Translation}, \$Param{Language}, \$Param{UserID}, \$Param{UserID} ]
        );
    }

    return $Success;
}

=head2 DraftTranslationUndoDelete()

undo delete translation item

    my $Success = $TranslationsObject->DraftTranslationUndoDelete(
        Language     => 'en'
        Content      => 'Black'
    );

Returns:

    $Success = 1; #1: Successful, #0: Unsuccessful

=cut

sub DraftTranslationUndoDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Language} || !$Param{Content} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Language and Content!",
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Success = $DBObject->Do(
        SQL  => "DELETE FROM translation_item WHERE language = ? AND content = ? AND flag ='d'",
        Bind => [ \$Param{Language}, \$Param{Content} ]
    );

    return $Success;
}

=head2 WithContentDynamicFields()

get translatable content only dynamic fields

    my $DynamicFieldList = $TranslationsObject->WithContentDynamicFields();

Returns:

    $DynamicFieldList = {
        1 => 'Field a',
        2 => 'Field b',
        3 => 'Field c'
    };

=cut

sub WithContentDynamicFields {
    my ( $Self, %Param ) = @_;

    my %DynamicFieldList;
    my @List = @{
        $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
            Valid      => 0,
            ResultType => 'ARRAY',
        )
    };

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    DYNAMICFIELD:
    for my $FieldID (@List) {
        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
            ID => $FieldID
        );
        my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
            DynamicFieldConfig => $DynamicField,
        );

        next DYNAMICFIELD if !IsHashRefWithData($PossibleValues);

        $DynamicFieldList{$FieldID} = $DynamicField->{Name};
    }

    return \%DynamicFieldList;
}

=head2 ReadExistingTranslationFile()

read existing translation file

    my $Translations = $TranslationsObject->ReadExistingTranslationFile(
        UserLanguage => 'en'
    );

Returns:

    $Self = {
        'Translations' => {

        }
    }

=cut

sub ReadExistingTranslationFile {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for my $Needed (qw(UserLanguage)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $File       = "$Home/Kernel/Language/$Param{UserLanguage}";

    # get customized language file from fs
    my $LanguageFile = "Kernel::Language::$Param{UserLanguage}";

    my $FileExists = -e "$File.pm" || '';

    if ( !$FileExists ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Sorry, can't load $LanguageFile. File does not exists!"
        );
        return $Self;
    }

    # load text catalog ...
    if ( !$MainObject->Require($LanguageFile) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Sorry, can't locate or load $LanguageFile "
                . "translation! Check the Kernel/Language/$Param{UserLanguage}.pm (perl -cw)!",
        );
        return $Self;
    }

    # Verify method
    my $LanguageFileDataMethod = $LanguageFile->can('Data');

    # Execute translation map by calling language file data method via reference.
    if ($LanguageFileDataMethod) {
        if ( $LanguageFileDataMethod->($Self) ) {

            # Debug info.
            if ( $Self->{Debug} > 0 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "Kernel::Language::$Param{UserLanguage}_ZZZAAuto load ... done.",
                );
            }
        }
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Sorry, can't load $LanguageFile! Check if it provides Data method",
        );
    }

    return $Self;
}

=head2 WriteTranslationFile()

write translation file

    my $Success = $TranslationsObject->WriteTranslationFile(
        UserLanguage => 'en',
        Data         => { .. } #Hash of Content/Translation values,
        Import       => (0|1),
    );

Returns:

    $Success = 1; #1: Successful, #0: Unsuccessful

=cut

sub WriteTranslationFile {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserLanguage} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserLanguage!",
        );

        return;
    }

    my %Strings;
    my $Data                = '';
    my $BreakLineAfterChars = 60;
    my $Home                = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    $Param{Import} ||= 0;

    #Check if there are draft translations to write
    my @DraftTranslations = @{
        $Self->DraftTranslationsGet(
            Language => $Param{UserLanguage},
            Import   => $Param{Import},
            Active   => 0
        )
    };

    if ( !@DraftTranslations ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Nothing to deploy",
        );

        return 2;
    }

    # Get existing translations
    my %Collected;
    my $Indent            = ' ' x 4;
    my $JavascriptStrings = $Indent . "push \@{ \$Self->{JavaScriptStrings} // [] }, (\n";

    my @LanguageData = @{
        $Self->DraftTranslationsGet(
            Language => $Param{UserLanguage},
            Import   => 0,
            Active   => 1
        )
    };

    my %BaseTranslations;

    # Get base translations from core installation
    my %BaseData = %{
        $Self->ReadExistingTranslationFile(
            UserLanguage => $Param{UserLanguage},
        )
    };

    # if there are any custom translations, they are collected
    if ( %BaseData && defined $BaseData{Translation} ) {
        my %Strings = %{ $BaseData{Translation} };

        for my $Custom ( sort keys %Strings ) {
            $BaseTranslations{$Custom} = $Strings{$Custom};
        }
    }

    for my $Existing (@LanguageData) {
        my %Item = %{$Existing};
        $Collected{ $Item{Content} } = $Item{Translation};
    }

    for my $DraftItem (@DraftTranslations) {
        my %Item = %{$DraftItem};

        my $Source = $Item{Content};

        if ( $Item{Flag} eq 'n' || $Item{Flag} eq 'e' ) {

            #Add or overwrite existing translation
            $Collected{ $Item{Content} } = $Item{Translation};

            my ( $CreateBy, $CreateTime ) = '';

            $Kernel::OM->Get('Kernel::System::DB')->Prepare(
                SQL  => "SELECT create_by, create_time FROM translation_item WHERE language = ? and content = ? and flag = 'a'",
                Bind => [ \$Param{UserLanguage}, \$Source ]
            );

            while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
                $CreateBy   = $Row[0];
                $CreateTime = $Row[1];
            }

            if ($CreateBy) {
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL  => "DELETE FROM translation_item WHERE language = ? and content = ? and flag = 'a'",
                    Bind => [ \$Param{UserLanguage}, \$Source ]
                );

                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL =>
                        "UPDATE translation_item SET content = ?, translation = ?, import_param = 0, change_time = current_timestamp, create_by = ?, create_time = ?, flag = 'a'
                            WHERE language = ? and content = ? and flag in('e','n')",
                    Bind => [ \$Item{Content}, \$Item{Translation}, \$CreateBy, \$CreateTime, \$Param{UserLanguage}, \$Source ]
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::DB')->Do(
                    SQL  => "UPDATE translation_item SET content = ?, translation = ?, import_param = 0, flag = 'a' WHERE language = ? and content = ? and flag in('e','n')",
                    Bind => [ \$Item{Content}, \$Item{Translation}, \$Param{UserLanguage}, \$Source ]
                );
            }
        }
        else {
            delete $Collected{ $Item{Content} };

            $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL  => "DELETE FROM translation_item WHERE language = ? and content = ?",
                Bind => [ \$Param{UserLanguage}, \$Source ]
            );
        }
    }

    # Generate translation data in required structure
    KEY:
    for my $Key ( keys %Collected ) {
        $Collected{$Key} =~ s{\\}{\\\\}xmsg;
        $Collected{$Key} =~ s{\'}{\\'}xmsg;

        my $SourceKey = $Key;

        $Key =~ s{\\}{\\\\}xmsg;
        $Key =~ s{\'}{\\'}xmsg;

        if (
            index( $SourceKey, "\n" )
            > -1
            || length($SourceKey) < $BreakLineAfterChars
            )
        {
            $Data .= $Indent
                . "\$Self->{Translation}->{'$Key'} = '$Collected{$SourceKey}';\n";
        }
        else {
            $Data .= $Indent . "\$Self->{Translation}->{'$Key'} =\n";
            $Data .= $Indent . '    ' . "'$Collected{$SourceKey}';\n";
        }

        # skip adding to javascript strings if item exists in core translations
        next KEY if $BaseTranslations{$Key};

        $JavascriptStrings .= $Indent x 2 . "'$Key',\n";
    }

    $JavascriptStrings .= $Indent . ");\n";

    # needed for cvs check-in filter
    my $Separator = "# --";

    my $NewOut = <<"EOF";
$Separator
# OTOBO is a web-based ticketing system for service organisations.
$Separator
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.io/
$Separator
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
$Separator

package Kernel::Language::$Param{UserLanguage}_ZZZAAuto;

use strict;
use warnings;
use utf8;

sub Data {
    my \$Self = shift;

$Data

$JavascriptStrings
}

1;
EOF

    my $ModuleName = "Kernel/Language/$Param{UserLanguage}_ZZZAAuto.pm";
    my $TargetFile = "$Home/$ModuleName";

    if ( -e $TargetFile ) {
        my $Rename = rename( $TargetFile, "$TargetFile.old" );

        if ( !$Rename ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error trying to make temporal file for deployment!",
            );

            return;
        }
    }

    my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => "$TargetFile.new",
        Content  => \$NewOut,
        Mode     => 'utf8',
    );

    #If not successful, rollback changes
    if ( $Success ne "$TargetFile.new" ) {
        if ( -e "$TargetFile.old" ) {
            my $Rename = rename( "$TargetFile.old", $TargetFile );

            if ( !$Rename ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Error trying to revert changes in the filesystem!",
                );

                return;
            }
        }
        $Success = 3;
    }
    else {
        rename( "$TargetFile.new", $TargetFile );

        Kernel::System::ModuleRefresh->refresh_module($ModuleName);

        $Kernel::OM->Get('Kernel::System::Main')->FileDelete(
            Location        => "$TargetFile.old",
            Type            => 'Local',
            DisableWarnings => 1,
        );

        $Success = 1;
    }

    # # generate chained translations for queues and services automatically
    my %SystemLanguages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };

    # NOTE valid defaults to 1
    my %Queues  = $Kernel::OM->Get('Kernel::System::Queue')->QueueList();
    my @Strings = values %Queues;

    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service') ) {

        # NOTE valid defaults to 1
        my %Services = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            UserID => 1,
        );
        push @Strings, values %Services;
    }

    # iterate over all languages
    for my $LanguageID ( sort keys %SystemLanguages ) {
        $Self->TranslateParentChildElements(
            LanguageID => $LanguageID,
            Strings    => \@Strings,
        );
    }

    return $Success;
}

=head2 GetTranslationUniqueValues()

get unique values to filter additions

    my $UniqueValues = $TranslationsObject->GetTranslationUniqueValues(
        LanguageID => 'en'
    );

Returns:

    $UniqueValues = {
        'Content A' = 'Translation A',
        'Content B' = 'Translation B',
    }

=cut

sub GetTranslationUniqueValues {
    my ( $Self, %Param ) = @_;

    my %UniqueValues;

    my @LanguageData = @{
        $Self->DraftTranslationsGet(
            Language => $Param{LanguageID},
            Active   => 1
        )
    };

    # if there are any custom translations, they are shown
    if (@LanguageData) {

        # Write values from translation file into tt
        for my $Custom (@LanguageData) {
            my %Strings = %{$Custom};
            $UniqueValues{ $Strings{Content} } = $Strings{Translation};
        }
    }

    my @DraftTranslations = @{
        $Self->DraftTranslationsGet(
            Language => $Param{LanguageID},
            Active   => 0
        )
    };

    # Write undeployed values from translation_item table into tt
    for my $DraftItem (@DraftTranslations) {
        my %Item = %{$DraftItem};
        $UniqueValues{ $Item{Content} } = $Item{Content};
    }

    return \%UniqueValues;

}

=head2 TranslateParentChildElements()

generate chained translations automatically based on translations of single elements

    my $Success = $TranslationsObject->TranslateParentChildElements(
        LanguageID => 'en',
        Strings    => [
            'Test1',
            'Test1::Test2',
        ],
    );

=cut

sub TranslateParentChildElements {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for my $Needed (qw(LanguageID Strings)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # create local language object
    my $LocalLanguageObject = $Kernel::OM->Create(
        'Kernel::Language',
        ObjectParams => {
            UserLanguage => $Param{LanguageID},
        },
    );
    my $DeployLanguage = 0;

    STRING:
    for my $String ( $Param{Strings}->@* ) {

        # split chained strings into individual elements
        my @NameElements = split /::/, $String;
        my @TranslatedElements;
        for my $NameElement (@NameElements) {

            # translate individual elements
            push @TranslatedElements, $LocalLanguageObject->Translate($NameElement);
        }
        my $TranslatedString = join( '::', @TranslatedElements );

        # check if translation has changed to prevent recursive deployment
        if ( $TranslatedString ne $LocalLanguageObject->Translate($String) ) {

            my $Success = $Self->DraftTranslationsAdd(
                Language    => $Param{LanguageID},
                Content     => $String,
                Translation => $TranslatedString,
                UserID      => 1,
                Edit        => 1,
            );
            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Not able to add translation for string $String in language $Param{LanguageID}!",
                );
                next STRING;
            }
            $DeployLanguage = 1;
        }
    }

    # check if language need to be deployed to prevent recursive deployment
    if ($DeployLanguage) {
        my $DeploySuccess = $Self->WriteTranslationFile(
            UserLanguage => $Param{LanguageID},
        );
    }

    return 1;
}

1;
