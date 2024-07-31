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

package Kernel::System::ImportExport::ObjectBackend::Translations;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::HTMLUtils',
    'Kernel::System::CSV',
    'Kernel::System::User',
    'Kernel::System::Group',
    'Kernel::System::Translations',
    'Kernel::Config',
    'Kernel::System::ImportExport',
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::SLA',
    'Kernel::System::Service',
    'Kernel::System::StandardTemplate',
    'Kernel::System::State',
    'Kernel::System::Type'
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;

}

sub ObjectAttributesGet {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed object
    if ( !$Param{UserID} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    my %FormatList = (
        "plain" => "PlainText"
    );

    my $Attributes = [
        {
            Key   => 'Format',
            Name  => 'Format',
            Input => {
                Type         => 'Selection',
                Data         => \%FormatList,
                Required     => 1,
                Translation  => 1,
                PossibleNone => 0,
            },
        },
        {
            Key   => 'EmptyFieldsLeaveTheOldValues',
            Name  => 'Empty fields indicate that the current values are kept',
            Input => {
                Type => 'Checkbox',
            },
        },
    ];

    return $Attributes;
}

sub MappingObjectAttributesGet {
    my ( $Self, %Param ) = @_;

    #Load defined Languages for the system
    my %SystemLanguages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };

    #Fill hash data for language Dropdown
    my @ElementList = (
        {
            Key   => 'Content',
            Value => 'Source String',
        },
        ( map { { Key => $_, Value => "Translation $SystemLanguages{$_} ($_)" } } sort keys %SystemLanguages ),
    );

    my $Attributes = [
        {
            Key   => 'Key',
            Name  => 'Key',
            Input => {
                Type         => 'Selection',
                Data         => \@ElementList,
                Required     => 1,
                Translation  => 1,
                PossibleNone => 1,
            },
        },
    ];

    return $Attributes;
}

=head2 SearchAttributesGet()

get the search object attributes of an object as array/hash reference

    my $AttributeList = $ObjectBackend->SearchAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub SearchAttributesGet {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my %UntranslatedOptions = %{ $Kernel::OM->Get('Kernel::Config')->Get('Translations::ObjectList') };

    delete $UntranslatedOptions{'GeneralLabel'};

    my $DynamicFieldContent = delete $UntranslatedOptions{'DynamicFieldContent'};
    my $DynamicFieldLabel   = delete $UntranslatedOptions{'DynamicFieldLabel'};

    if ( $DynamicFieldContent || $DynamicFieldLabel ) {
        my $DynamicFields = $Kernel::OM->Get('Kernel::System::Translations')->WithContentDynamicFields() // {};

        %UntranslatedOptions = (
            %UntranslatedOptions,
            ( map { 'DynamicField_' . $_ => 'DynamicField_' . $_ } values $DynamicFields->%* ),
        );
    }

    my $AttributeList = [
        {
            Key   => 'Untranslated',
            Name  => 'Export Untranslated strings of',
            Input => {
                Type         => 'Selection',
                Data         => \%UntranslatedOptions,
                Required     => 1,
                Translation  => 1,
                PossibleNone => 1,
                Class        => 'Modernize',
                Multiple     => 1
            },
        },
    ];

    return $AttributeList;
}

=head2 ExportDataGet()

get export data as 2ND-array-hash reference

    my $ExportData = $ObjectBackend->ExportDataGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub ExportDataGet {
    my ( $Self, %Param ) = @_;

    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');
    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get object data
    my $ObjectData = $ImportExportObject->ObjectDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check object data
    if ( !$ObjectData || ref $ObjectData ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "No object data found for the template id $Param{TemplateID}",
        );
        return;
    }

    # get the mapping list
    my $MappingList = $ImportExportObject->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check the mapping list
    if ( !$MappingList || ref $MappingList ne 'ARRAY' || !@{$MappingList} ) {

        $LogObject->Log(
            Priority => 'error',
            Message  => "No valid mapping list found for the template id $Param{TemplateID}",
        );
        return;
    }

    # create the mapping object list
    my @MappingObjectList;
    for my $MappingID ( @{$MappingList} ) {

        # get mapping object data
        my $MappingObjectData =
            $ImportExportObject->MappingObjectDataGet(
                MappingID => $MappingID,
                UserID    => $Param{UserID},
            );

        # check mapping object data
        if ( !$MappingObjectData || ref $MappingObjectData ne 'HASH' ) {

            $LogObject->Log(
                Priority => 'error',
                Message  => "No valid mapping list found for the template id $Param{TemplateID}",
            );
            return;
        }

        push( @MappingObjectList, $MappingObjectData );
    }

    # get search data
    my $SearchData = $ImportExportObject->SearchDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    if ( $SearchData && ref($SearchData) ne 'HASH' ) {
        $SearchData = 0;
        $LogObject->Log(
            Priority => 'error',
            Message  =>
                "Translations: search data is not a hash ref - ignoring search limitation.",
        );
    }

    my @SearchObjects;
    if ( $SearchData && $SearchData->{Untranslated} ) {
        @SearchObjects = split( /\#\#\#\#\#/, $SearchData->{Untranslated} );
    }

    my @MappingKeys        = map  { $_->{Key} } values @MappingObjectList;
    my @MappingLanguageIDs = grep { $_ ne 'Content' } @MappingKeys;

    my @LanguageData = @{
        $TranslationsObject->DraftTranslationsExport(
            Language => \@MappingLanguageIDs
        )
    };

    my %TranslatedStrings;

    if (@LanguageData) {
        for my $Data (@LanguageData) {
            my $SourceString = ( keys $Data->%* )[0];

            $TranslatedStrings{$SourceString} = $Data->{$SourceString};
            $TranslatedStrings{$SourceString}{Content} = $SourceString;
        }
    }

    my %ObjectKeys;
    if ( $SearchData->{Untranslated} ) {
        my @Opts = split( /\#\#\#\#\#/, $SearchData->{Untranslated} );
        %ObjectKeys = map { $Opts[$_] => $Opts[$_] } 0 .. $#Opts;
    }

    # export data...
    my @ExportData;
    my %Seen = (
        ''  => 1,
        '-' => 1,
    );

    my $IncludeInExport = sub {
        my @Strings = @_;

        STRING:
        for my $String (@_) {
            next STRING if $Seen{$String};

            if ( $TranslatedStrings{$String} ) {
                push @ExportData, [ map { $TranslatedStrings{$String}{$_} // '' } @MappingKeys ];
            }
            else {
                push @ExportData, [ map { $_ eq 'Content' ? $String : '' } @MappingKeys ];
            }

            $Seen{$String} = 1;
        }
    };

    if ( $ObjectKeys{'Type'} || !keys %ObjectKeys ) {
        my %TypeList = $Kernel::OM->Get('Kernel::System::Type')->TypeList( Valid => 0 );

        $IncludeInExport->( sort values %TypeList );
    }

    if ( $ObjectKeys{'Queue'} || !keys %ObjectKeys ) {
        my %QueueList = $Kernel::OM->Get('Kernel::System::Queue')->QueueList();

        $IncludeInExport->( sort values %QueueList );
    }

    if ( $ObjectKeys{'Service'} || !keys %ObjectKeys ) {
        my %ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            Valid  => 0,
            UserID => 1
        );

        $IncludeInExport->( sort values %ServiceList );
    }

    if ( $ObjectKeys{'SLA'} || !keys %ObjectKeys ) {
        my %SLAList = $Kernel::OM->Get('Kernel::System::SLA')->SLAList( UserID => 1 );

        $IncludeInExport->( sort values %SLAList );
    }

    if ( $ObjectKeys{'Priority'} || !keys %ObjectKeys ) {
        my %PriorityList = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList( Valid => 0 );

        $IncludeInExport->( sort values %PriorityList );
    }

    if ( $ObjectKeys{'State'} || !keys %ObjectKeys ) {
        my %StateList = $Kernel::OM->Get('Kernel::System::State')->StateList( UserID => 1 );

        $IncludeInExport->( sort values %StateList );
    }

    if ( $ObjectKeys{'Template'} || !keys %ObjectKeys ) {
        my %TemplateList = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList( Valid => 0 );

        $IncludeInExport->( sort values %TemplateList );
    }

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %UntranslatedOptions = %{ $Kernel::OM->Get('Kernel::Config')->Get('Translations::ObjectList') };

    my $DynamicFieldContent = delete $UntranslatedOptions{'DynamicFieldContent'};
    my $DynamicFieldLabel   = delete $UntranslatedOptions{'DynamicFieldLabel'};

    my @DynamicFields;
    if (%ObjectKeys) {
        KEY:
        for my $Key ( keys %ObjectKeys ) {
            if ( $Key =~ /^DynamicField_(.+)$/ ) {
                push @DynamicFields, $1;
            }
            else {
                next KEY;
            }
        }
    }
    elsif ( $DynamicFieldLabel || $DynamicFieldContent ) {
        my $DynamicFieldList = $DynamicFieldObject->DynamicFieldList(
            ResultType => 'HASH'
        );

        @DynamicFields = values %{ $DynamicFieldList || {} };
    }

    DYNAMICFIELD:
    for my $Name (@DynamicFields) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Name,
        );

        next KEY if !IsHashRefWithData($DynamicField);

        my @Strings;

        if ($DynamicFieldLabel) {
            push @Strings, $DynamicField->{Label};
        }

        if ($DynamicFieldContent) {
            my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicField,
            );

            next DYNAMICFIELD if !$PossibleValues;

            push @Strings, sort values $PossibleValues->%*;
        }

        $IncludeInExport->(@Strings);
    }

    # include existing general label translations
    $IncludeInExport->( sort keys %TranslatedStrings );

    return \@ExportData;
}

=head2 ImportDataSave()

import one row of the import data

    my $ConfigItemID = $ObjectBackend->ImportDataSave(
        TemplateID    => 123,
        ImportDataRow => $ArrayRef,
        UserID        => 1,
    );

=cut

sub ImportDataSave {
    my ( $Self, %Param ) = @_;

    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');
    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

    # check needed stuff
    for my $Argument (qw(TemplateID ImportDataRow UserID)) {
        if ( !$Param{$Argument} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return ( undef, 'Failed' );
        }
    }

    # check import data row
    if ( ref $Param{ImportDataRow} ne 'ARRAY' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'ImportDataRow must be an array reference',
        );
        return ( undef, 'Failed' );
    }

    # get object data
    my $ObjectData = $ImportExportObject->ObjectDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check object data
    if ( !$ObjectData || ref $ObjectData ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "No object data found for the template id $Param{TemplateID}",
        );
        return ( undef, 'Failed' );
    }

    # get the mapping list
    my $MappingList = $ImportExportObject->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check the mapping list
    if ( !$MappingList || ref $MappingList ne 'ARRAY' || !@{$MappingList} ) {

        $LogObject->Log(
            Priority => 'error',
            Message  => "No valid mapping list found for the template id $Param{TemplateID}",
        );
        return ( undef, 'Failed' );
    }

    # create the mapping object list
    my $SourceString;
    my %NewTranslation;
    for my $i ( 0 .. $#{$MappingList} ) {
        my $ImportData = $Param{ImportDataRow}[$i];
        my $MappingID  = $MappingList->[$i];

        # get mapping object data
        my $MappingObjectData =
            $ImportExportObject->MappingObjectDataGet(
                MappingID => $MappingID,
                UserID    => $Param{UserID},
            );

        # check mapping object data
        if ( !$MappingObjectData || ref $MappingObjectData ne 'HASH' ) {

            $LogObject->Log(
                Priority => 'error',
                Message  => "No valid mapping list found for the template id $Param{TemplateID}",
            );
            return;
        }

        if ( $MappingObjectData->{Key} eq 'Content' ) {
            $SourceString = $ImportData;
        }
        else {
            $NewTranslation{ $MappingObjectData->{Key} } = $ImportData;
        }
    }

    if ( !$SourceString ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Can't import entity $Param{Counter}: "
                . "Need source string in import data.",
        );

        return ( undef, 'Failed' );
    }

    my %SystemLanguages = %{ $ConfigObject->Get('DefaultUsedLanguages') // {} };
    my $ReturnCode      = 'Skipped';

    LANGUAGE:
    for my $Language ( keys %NewTranslation ) {

        if ( !$SystemLanguages{$Language} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Can't import entity $Param{Counter}: "
                    . "Language: '$Language' ins't defined on DefaultUsedLanguages!",
            );
            return ( undef, 'Failed' );
        }

        # skip empty translations if configured
        if (
            ( !defined $NewTranslation{$Language} || $NewTranslation{$Language} eq '' || $NewTranslation{$Language} eq '-' )
            && $ObjectData->{EmptyFieldsLeaveTheOldValues}
            )
        {
            next LANGUAGE;
        }

        if ( !defined $Self->{DraftTranslations}{$Language} ) {
            my $DraftTranslations = $TranslationsObject->DraftTranslationsGet(
                Language => $Language,
            );
            my $ActiveTranslations = $TranslationsObject->DraftTranslationsGet(
                Language => $Language,
                Active   => 1
            );

            $Self->{DraftTranslations}{$Language}  = { map { $_->{Content} => $_->{Translation} } $DraftTranslations->@* };
            $Self->{ActiveTranslations}{$Language} = { map { $_->{Content} => $_->{Translation} } $ActiveTranslations->@* };
        }

        # skip if nothing changed
        next LANGUAGE if ( $Self->{ActiveTranslations}{$Language}{$SourceString} // '' ) eq $NewTranslation{$Language};

        if ( $Self->{DraftTranslations}{$Language}{$SourceString} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Could not update translation content: '$SourceString' in "
                    . "line $Param{Counter}, because is being edited by an Agent!",
            );

            $ReturnCode = "Failed";

            next LANGUAGE;
        }

        my $Success = $TranslationsObject->DraftTranslationsAdd(
            Language    => $Language,
            Content     => $SourceString,
            Translation => $NewTranslation{$Language},
            Edit        => $Self->{ActiveTranslations}{$Language}{$SourceString} ? 1 : 0,
            Deployed    => 0,
            UserID      => 1,
        );

        if ( !$Success ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Could not update translation content: '$SourceString' in "
                    . "line $Param{Counter}, error storing the draft",
            );

            $ReturnCode = "Failed";

            next LANGUAGE;
        }

        $Success = $TranslationsObject->WriteTranslationFile(
            UserLanguage         => $Language,
            Import               => 0,
            TranslateParentChild => 1,
        ) || 0;

        if ( !$Success ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Could not update translation content: '$SourceString' in "
                    . "line $Param{Counter}, error writing the translation file",
            );

            $ReturnCode = "Failed";

            next LANGUAGE;
        }

        $ReturnCode = $ReturnCode eq 'Failed'
            ? 'Failed'
            : $Self->{ActiveTranslations}{$Language}{$SourceString} || $ReturnCode eq 'Updated' ? 'Updated'
            :                                                                                     'Added';
    }

    return ( 1, $ReturnCode );
}

1;
