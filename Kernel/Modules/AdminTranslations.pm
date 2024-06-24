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

package Kernel::Modules::AdminTranslations;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Store last entity screen.
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenEntity',
        Value     => $Self->{RequestedURL},
    );

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');
    my $AllowAll           = $Kernel::OM->Get('Kernel::Config')->Get('Translations::AllowModifyAll') || 0;

    # ------------------------------------------------------------ #
    # Ajax RenderField
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'RenderField' ) {

        return $Self->_RenderField(
            Object   => $ParamObject->GetParam( Param => 'Object' )  || '',
            Content  => $ParamObject->GetParam( Param => 'Content' ) || '',
            Value    => $ParamObject->GetParam( Param => 'Value' )   || '',
            AllowAll => $AllowAll
        );

    }

    # ------------------------------------------------------------ #
    # Ajax GetDraftTable
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'GetDraftTable' ) {

        return $Self->_GetDraftTable(
            Object         => $ParamObject->GetParam( Param => 'Object' )         || '',
            DynamicFieldID => $ParamObject->GetParam( Param => 'DynamicFieldID' ) || '',
            AllowAll       => $AllowAll,
            LanguageID     => $ParamObject->GetParam( Param => 'LanguageID' )
        );

        # ------------------------------------------------------------ #
        # Delete
        # ------------------------------------------------------------ #
    }
    elsif ( $Self->{Subaction} eq 'Delete' ) {
        $Param{ID}            = $ParamObject->GetParam( Param => 'DeleteID' )    || '';
        $Param{UserLanguage}  = $ParamObject->GetParam( Param => 'LanguageID' )  || '';
        $Param{MarkForDelete} = $ParamObject->GetParam( Param => 'Mark' )        || '';
        $Param{Content}       = $ParamObject->GetParam( Param => 'Content' )     || '';
        $Param{Translation}   = $ParamObject->GetParam( Param => 'Translation' ) || '';

        my $Success;
        my $Message = '';

        if ( $Param{UserLanguage} ) {
            $Success = $Kernel::OM->Get('Kernel::System::Translations')->DraftTranslationDelete(
                Language    => $Param{UserLanguage},
                ID          => $Param{ID},
                Mark        => $Param{MarkForDelete},
                Content     => $Param{Content},
                Translation => $Param{Translation},
                UserID      => $Self->{UserID}
            );
        }

        $Self->_Overview(%Param);
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ( $Success == 1 ) {
            $Message = $Param{MarkForDelete} ? 'Translation marked for deletion!' : 'Draft translation deleted!';
            $Output .= $LayoutObject->Notify( Info => Translatable($Message) );
        }
        elsif ( $Success == 2 ) {
            $Message = $Param{MarkForDelete} ? 'Error trying to mark translation for deletion!' : 'Error trying to delete draft translation!';
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Info     => Translatable($Message),
            );
        }
        elsif ( $Success == 3 ) {
            $Message = 'Translation it\'s already on draft translations table!';
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Info     => Translatable($Message),
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTranslations',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;

    }

    # ------------------------------------------------------------ #
    # Undo delete (Works only for existing translations)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UndoDelete' ) {
        $Param{UserLanguage} = $ParamObject->GetParam( Param => 'LanguageID' ) || '';
        $Param{Content}      = $ParamObject->GetParam( Param => 'Content' )    || '';
        my $Success;

        if ( $Param{UserLanguage} && $Param{Content} ) {
            $Success = $Kernel::OM->Get('Kernel::System::Translations')->DraftTranslationUndoDelete(
                Language => $Param{UserLanguage},
                Content  => $Param{Content},
                UserID   => $Self->{UserID}
            );
        }

        $Self->_Overview(%Param);
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ($Success) {
            $Output .= $LayoutObject->Notify( Info => Translatable('Translation unmarked for deletion!') );
        }
        else {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Info     => Translatable('Error trying unmark translation for delete!'),
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTranslations',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Change' ) {
        my %GetParam;

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $GetParam{ID}           = $ParamObject->GetParam( Param => 'ID' )              || '';
        $GetParam{Content}      = $ParamObject->GetParam( Param => 'EditContent' )     || '';
        $GetParam{Translation}  = $ParamObject->GetParam( Param => 'EditTranslation' ) || '';
        $GetParam{UserLanguage} = $ParamObject->GetParam( Param => 'LanguageID' )
            || $ParamObject->GetParam( Param => 'UserLanguage' ) || '';

        #Load defined Languages for the system
        my %SystemLanguages       = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
        my %SystemLanguagesNative = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguagesNative') };
        my %UserPreferences       = $Kernel::OM->Get('Kernel::System::User')->GetPreferences( UserID => $Self->{UserID} );

        #Fill hash data for Label generation
        for my $Language ( keys %SystemLanguages ) {
            $SystemLanguages{$Language} = "($Language) - $SystemLanguagesNative{$Language}";
        }

        $GetParam{UserLanguageLabel} = $SystemLanguages{ $GetParam{UserLanguage} } || $SystemLanguages{ $UserPreferences{UserLanguage} };

        $Self->_Edit(
            Action => 'Change',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTranslations',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        $LayoutObject->ChallengeTokenCheck();

        $Param{UserLanguage} = $ParamObject->GetParam( Param => 'LanguageID' )  || '';
        $Param{CountNew}     = $ParamObject->GetParam( Param => 'CountNew' )    || 0;
        $Param{ExistingIDs}  = $ParamObject->GetParam( Param => 'ExistingIDs' ) || 0;
        $Param{Object}       = $ParamObject->GetParam( Param => 'Object' )      || 0;
        $Param{ID}           = $ParamObject->GetParam( Param => 'ID' )          || 0;

        my %Errors;
        my $Changed = 0;

        # Evaluate data table when ID is not provided
        if ( !$Param{ID} ) {

            # Loop over change additions
            CHANGEADDITION:
            for ( my $Count = 1; $Count <= $Param{CountNew}; $Count++ ) {
                my $Content        = $ParamObject->GetParam( Param => 'TranslateInput_Content_Change_' . $Count ) || '';
                my $OldTranslation = $ParamObject->GetParam( Param => 'TranslateInput_Old_Change_' . $Count )     || '';
                my $NewTranslation = $ParamObject->GetParam( Param => 'TranslateInput_Change_' . $Count )         || '';

                $Content        =~ s/^\s+|\s+$//g;
                $OldTranslation =~ s/^\s+|\s+$//g;
                $NewTranslation =~ s/^\s+|\s+$//g;

                next CHANGEADDITION if $OldTranslation eq $NewTranslation;

                if ( $Content && $NewTranslation && $Param{UserLanguage} ) {
                    my $Success = $TranslationsObject->DraftTranslationsAdd(
                        Language    => $Param{UserLanguage},
                        Content     => $Content,
                        Translation => $NewTranslation,
                        Edit        => 1,
                        UserID      => $Self->{UserID}
                    );

                    $Changed++;
                }
            }

            if ( $Param{ExistingIDs} ) {
                my @ChangeIDs = split /,/, $Param{ExistingIDs};

                # Change existing draft translations
                DRAFTCHANGES:
                for my $ID (@ChangeIDs) {
                    my $Content        = $ParamObject->GetParam( Param => 'TranslateInput_Content_' . $ID );
                    my $OldTranslation = $ParamObject->GetParam( Param => 'TranslateInput_Old_' . $ID );
                    my $NewTranslation = $ParamObject->GetParam( Param => 'TranslateInput_' . $ID );

                    $Content        =~ s/^\s+|\s+$//g;
                    $OldTranslation =~ s/^\s+|\s+$//g;
                    $NewTranslation =~ s/^\s+|\s+$//g;

                    next DRAFTCHANGES if $OldTranslation eq $NewTranslation;

                    if ( $Content && $NewTranslation && $Param{UserLanguage} ) {
                        my $Success = $TranslationsObject->DraftTranslationsChange(
                            ID          => $ID,
                            Language    => $Param{UserLanguage},
                            Content     => $Content,
                            Translation => $NewTranslation,
                            UserID      => $Self->{UserID}
                        );

                        $Changed++;
                    }
                }
            }
        }
        else {
            $Param{Content}        = $ParamObject->GetParam( Param => 'Content' )        || '';
            $Param{Translation}    = $ParamObject->GetParam( Param => 'Translation' )    || '';
            $Param{OldTranslation} = $ParamObject->GetParam( Param => 'OldTranslation' ) || '';

            $Param{Content}        =~ s/^\s+|\s+$//g;
            $Param{Translation}    =~ s/^\s+|\s+$//g;
            $Param{OldTranslation} =~ s/^\s+|\s+$//g;

            my $Success;

            if ( $Param{Translation} ne $Param{OldTranslation} ) {
                if ( $Param{ID} eq 'Edit' ) {
                    $Success = $TranslationsObject->DraftTranslationsAdd(
                        Language    => $Param{UserLanguage},
                        Content     => $Param{Content},
                        Translation => $Param{Translation},
                        UserID      => $Self->{UserID},
                        Edit        => 1
                    );
                }
                else {
                    $Success = $TranslationsObject->DraftTranslationsChange(
                        ID          => $Param{ID},
                        Language    => $Param{UserLanguage},
                        Content     => $Param{Content},
                        Translation => $Param{Translation},
                        UserID      => $Self->{UserID}
                    );
                }

                if ( !$Success ) {
                    $Errors{"$Param{Object}Invalid"} = 'ServerError';
                }
                else {
                    $Changed++;
                }
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            $Self->_Overview(%Param);
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            if ($Changed) {
                $Output .= $LayoutObject->Notify( Info => Translatable('Translations changed!') );
            }
            else {
                $Output .= $LayoutObject->Notify( Info => Translatable('No translations were changed!') );
            }

            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminTranslations',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify(
            Priority => 'Error',
            Info     => Translatable('Errors trying to change translations!')
        );

        $Param{UserLanguageLabel} = $ParamObject->GetParam( Param => 'UserLanguageLabel' );

        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %Param,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTranslations',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;

    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTranslations',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        $LayoutObject->ChallengeTokenCheck();

        $Param{Object}         = $ParamObject->GetParam( Param => 'WorkObject' )     || '';
        $Param{UserLanguage}   = $ParamObject->GetParam( Param => 'LanguageID' )     || '';
        $Param{DynamicFieldID} = $ParamObject->GetParam( Param => 'DynamicFieldID' ) || '';
        $Param{ItemCount}      = $ParamObject->GetParam( Param => 'ItemCount' )      || 0;

        my %Errors;
        my $Added = 0;

        #Get Unique values (Double check)
        my %UniqueValues = %{
            $TranslationsObject->GetTranslationUniqueValues(
                LanguageID => $Param{UserLanguage}
            )
        };

        if ( $Param{Object} eq 'GeneralLabel' || ( $Param{Object} eq 'DynamicFieldLabel' && $Param{DynamicFieldID} ne 'ListAll' ) ) {
            $Param{Content}     = $ParamObject->GetParam( Param => 'Content' );
            $Param{Translation} = $ParamObject->GetParam( Param => 'Translation' );

            $Param{Content}     =~ s/^\s+|\s+$//g;
            $Param{Translation} =~ s/^\s+|\s+$//g;

            if ( !$UniqueValues{ $Param{Content} } ) {

                my $Success = $TranslationsObject->DraftTranslationsAdd(
                    Language    => $Param{UserLanguage},
                    Content     => $Param{Content},
                    Translation => $Param{Translation},
                    UserID      => $Self->{UserID}
                );

                if ( !$Success ) {
                    $Errors{"$Param{Object}Invalid"} = 'ServerError';
                }
                else {
                    $Added++;
                }
            }
            else {
                $Errors{"$Param{Object}Invalid"} = 'ServerError';
            }

        }
        else {
            # Loop over field data
            for ( my $Count = 1; $Count <= $Param{ItemCount}; $Count++ ) {
                my $Content     = $ParamObject->GetParam( Param => 'TranslateInput_Content_' . $Count );
                my $Translation = $ParamObject->GetParam( Param => 'TranslateInput_' . $Count );

                $Content     =~ s/^\s+|\s+$//g;
                $Translation =~ s/^\s+|\s+$//g;

                if ( $Content && $Translation && !$UniqueValues{$Content} ) {
                    my $Success = $TranslationsObject->DraftTranslationsAdd(
                        Language    => $Param{UserLanguage},
                        Content     => $Content,
                        Translation => $Translation,
                        UserID      => $Self->{UserID}
                    );

                    $Added++;
                }
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            $Self->_Overview(%Param);
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            if ($Added) {
                $Output .= $LayoutObject->Notify( Info => Translatable('Translations added!') );
            }
            else {
                $Output .= $LayoutObject->Notify( Info => Translatable('No translations were given to add!') );
            }

            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminTranslations',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify(
            Priority => 'Error',
            Info     => Translatable('Translation already exists!')
        );

        $Param{UserLanguageLabel} = $ParamObject->GetParam( Param => 'UserLanguageLabel' );

        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %Param,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTranslations',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;

    }

    # ------------------------------------------------------------ #
    # deploy action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Deploy' ) {

        $LayoutObject->ChallengeTokenCheck();

        $Param{UserLanguage}        = $ParamObject->GetParam( Param => 'UserLanguage' )        || '';
        $Param{OTOBOAgentInterface} = $ParamObject->GetParam( Param => 'OTOBOAgentInterface' ) || '';

        my $Message;
        my $Success = $TranslationsObject->WriteTranslationFile(
            UserLanguage => $Param{UserLanguage}
        ) || 0;

        if ( $Success == 1 ) {
            $Message = $LayoutObject->{LanguageObject}->Translate('Translations deployed successfuly!');
        }
        elsif ( $Success == 2 ) {
            $Message = $LayoutObject->{LanguageObject}->Translate('Nothing to do!');
        }
        else {
            $Message = $LayoutObject->{LanguageObject}->Translate('Errors ocurred when trying to deploy translation. Please check system logs!');
        }

        my %Response = (
            Success => $Success,
            Message => $Message
        );

        my $JSON = $LayoutObject->JSONEncode(
            Data => \%Response,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview(%Param);
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTranslations',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    return;
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');

    if ( !$Param{UserLanguage} ) {
        $Param{UserLanguage} = $ParamObject->GetParam( Param => 'UserLanguage' );
    }

    if ( !$Param{UserLanguageLabel} ) {
        $Param{UserLanguageLabel} = $ParamObject->GetParam( Param => 'UserLanguageLabel' );
    }

    $Param{CCSFieldContainer}            = 'Hidden';
    $Param{CCSFieldContainerSingle}      = 'Hidden';
    $Param{CCSTranslationTableContainer} = 'Hidden';

    if ( $Param{Errors}->{GeneralLabelInvalid} ) {
        $Param{CCSFieldContainer} = '';

        $Param{ErrorFieldContainer} = $Self->_RenderField(
            Object       => $Param{Object},
            Content      => $Param{Content},
            Value        => $Param{Translation},
            AllowAll     => $Param{AllowAll},
            ErrorControl => 1
        );
    }

    $Param{Which} = ': ' . ( $Param{Content} || $LayoutObject->{LanguageObject}->Translate('All Items') );

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => \%Param
    );
    $LayoutObject->Block(
        Name => 'ActionHints',
        Data => \%Param
    );

    # get object list
    my %ObjectList = %{ $Kernel::OM->Get('Kernel::Config')->Get('Translations::ObjectList') };

    $Param{ObjectStrg} = $LayoutObject->BuildSelection(
        Data         => \%ObjectList,
        Name         => 'Object',
        SelectedID   => $Param{Object} || '',
        PossibleNone => 1,
        Translatable => 1,
        Sort         => 'AlphanumericValue',
        Class        => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ObjectInvalid'} || '' ),
    );

    my $DraftTable = '';
    my $SingleData = '';
    my @ExistingIDs;

    if ( $Param{Action} eq 'Change' ) {
        my @DataValues;
        my %Collected;
        my $IDs = 1;

        # Generate translations data table if not ID is provided
        if ( !$Param{ID} ) {
            $Param{CCSTranslationTableContainer} = '';

            # Get draft translations for language and collect it
            my @DraftTranslations = @{
                $TranslationsObject->DraftTranslationsGet(
                    Language => $Param{UserLanguage},
                    Active   => 0
                )
            };

            if (@DraftTranslations) {
                for my $DraftItem (@DraftTranslations) {
                    my %Item = %{$DraftItem};
                    $Collected{ $Item{Content} } = $Item{Translation};

                    if ( $Item{Flag} ne 'd' ) {
                        my $Reference = {
                            ID      => $Item{ID},
                            Content => $Item{Content},
                            Value   => $Item{Translation}
                        };
                        push @DataValues,  $Reference;
                        push @ExistingIDs, $Item{ID};
                    }
                }
            }

            # Get existing translations for language
            my @LanguageData = @{
                $TranslationsObject->DraftTranslationsGet(
                    Language => $Param{UserLanguage},
                    Active   => 1
                )
            };

            # if there are any custom translations, they are collected
            if (@LanguageData) {
                for my $Custom (@LanguageData) {

                    my %Strings = %{$Custom};

                    if ( !$Collected{ $Strings{Content} } ) {
                        my $Reference = {
                            ID      => "Change_$IDs",
                            Content => $Strings{Content},
                            Value   => $Strings{Translation}
                        };
                        push @DataValues, $Reference;
                        $IDs++;
                    }
                }
            }

            $DraftTable = $LayoutObject->TranslationsTableCreate(
                Data => {
                    Values      => \@DataValues,
                    Object      => 'Edit',
                    ExistingIDs => join( ',', @ExistingIDs ) || '',
                    CountNew    => $IDs
                }
            );

        }

        # Generate single translation data fields
        else {
            $Param{CCSFieldContainerSingle} = '';

            $SingleData = $LayoutObject->TranslationsGeneral(
                Data => {
                    Content => $Param{Content}     || '',
                    Value   => $Param{Translation} || '',
                    Object  => 'Edit',
                    ID      => $Param{ID} || ''
                }
            );
        }
    }

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            TableContainerData       => $DraftTable,
            FieldContainerSingleData => $SingleData,
            %{ $Param{Errors} },
        },
    );

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TranslationsObject = $Kernel::OM->Get('Kernel::System::Translations');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');

    if ( !$Param{UserLanguage} ) {
        $Param{UserLanguage} = $ParamObject->GetParam( Param => 'UserLanguage' ) || '';
    }

    #Load defined Languages for the system
    my %SystemLanguages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };

    #Load language descriptions
    my %SystemLanguagesNative = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguagesNative') };

    #Load user preferences
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences( UserID => $Self->{UserID} );

    #Fill hash data for language Dropdown
    for my $Language ( keys %SystemLanguages ) {
        $SystemLanguages{$Language} = "($Language) - $SystemLanguagesNative{$Language}";
    }

    $UserPreferences{UserLanguage} ||= 'en';

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionLegend' );

    $Param{UserLanguagesStrg} = $LayoutObject->BuildSelection(
        Data         => \%SystemLanguages,
        Name         => 'UserLanguage',
        SelectedID   => $Param{UserLanguage} || $UserPreferences{UserLanguage},
        PossibleNone => 0,
        Class        => 'Modernize Validate_Required ' . ( $Param{Errors}->{'UserLanguageInvalid'} || '' ),
        Translatable => 0
    );

    my $LanguageID = $Param{UserLanguage} || $UserPreferences{UserLanguage};
    $Param{UserLanguageLabel} = $SystemLanguages{ $Param{UserLanguage} } || $SystemLanguages{ $UserPreferences{UserLanguage} };
    $Param{Total}             = 0;

    $LayoutObject->Block(
        Name => 'ActionLanguage',
        Data => \%Param
    );

    $LayoutObject->Block(
        Name => 'ActionAdd',
        Data => {
            %Param,
            UserLanguage => $LanguageID
        }
    );

    $LayoutObject->Block(
        Name => 'ActionEdit',
        Data => {
            %Param,
            UserLanguage => $LanguageID
        }
    );

    $LayoutObject->Block(
        Name => 'ActionDeploy',
        Data => {
            %Param,
            UserLanguage => $LanguageID
        }
    );

    $LayoutObject->Block(
        Name => 'OverviewHeader',
        Data => \%Param
    );

    $LayoutObject->Block(
        Name => 'FormOverviewData',
        Data => {
            %Param,
            UserLanguage => $LanguageID,
            DeployHeader => $LayoutObject->{LanguageObject}->Translate('Deployment Results'),
        }
    );

    my %Collected;
    my %CollectedDraft;
    my %BaseTranslations;

    # Get base translations from core installation
    my %BaseData = %{
        $TranslationsObject->ReadExistingTranslationFile(
            UserLanguage => $LanguageID
        )
    };

    # if there are any custom translations, they are collected
    if ( %BaseData && defined $BaseData{Translation} ) {
        my %Strings = %{ $BaseData{Translation} };

        for my $Custom ( sort keys %Strings ) {
            $BaseTranslations{$Custom} = $Strings{$Custom};
        }
    }

    my @DraftTranslations = @{
        $TranslationsObject->DraftTranslationsGet(
            Language => $LanguageID,
            Active   => 0
        )
    };

    if (@DraftTranslations) {

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => {
                %Param,
                UserLanguage => $LanguageID,
                Form         => 'UndoForm',
                Table        => 'DraftTranslationsTable',
                Total        => int(@DraftTranslations) || 0
            }
        );

        # Write undeployed values from translation_item table into tt
        for my $DraftItem (@DraftTranslations) {

            my %Item      = %{$DraftItem};
            my $Overwrite = 0;

            $CollectedDraft{ $Item{Content} } = $Item{Content};

            if ( $BaseTranslations{ $Item{Content} } ) {
                $Overwrite = 1;
            }

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    ID                => $Item{ID},
                    Content           => $Item{Content},
                    Translation       => $Item{Translation},
                    ContentQuoted     => quotemeta( $Item{Content} ),
                    TranslationQuoted => quotemeta( $Item{Translation} ),
                    Flag              => $Item{Flag},
                    LanguageID        => $Item{Language},
                    Overwrite         => $Overwrite
                },
            );
        }

    }

    my @LanguageData = @{
        $TranslationsObject->DraftTranslationsGet(
            Language => $LanguageID,
            Active   => 1
        )
    };

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => {
            %Param,
            UserLanguage => $LanguageID,
            Form         => 'DeleteForm',
            Table        => 'TranslationsTable',
            Total        => int(@LanguageData) || 0
        }
    );

    # if there are any custom translations, they are shown
    if (@LanguageData) {

        # Write values from translation file into tt
        for my $Active (@LanguageData) {

            my %Item = %{$Active};

            my $ID        = '';
            my $Flag      = 'Exists';
            my $Overwrite = 0;

            if ( !$CollectedDraft{ $Item{Content} } ) {
                $ID   = 'Edit';
                $Flag = '';
            }

            $Collected{ $Item{Content} } = $Item{Content};

            if ( $BaseTranslations{ $Item{Content} } ) {
                $Overwrite = 1;
            }

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    ID                => $ID,
                    Content           => $Item{Content},
                    Translation       => $Item{Translation},
                    ContentQuoted     => quotemeta( $Item{Content} ),
                    TranslationQuoted => quotemeta( $Item{Translation} ),
                    Flag              => $Flag,
                    LanguageID        => $LanguageID,
                    Overwrite         => $Overwrite
                },
            );
        }
    }

    # if no Custom translations were written, a no data found msg is displayed
    if ( !keys %Collected ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {
                ColSpan => 4
            },
        );
    }

    return 1;
}

sub _RenderField {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $DynamicFieldContent;
    my $DynamicFieldName;

    if ( $Param{Object} eq 'DynamicFieldContent' || $Param{Object} eq 'DynamicFieldLabel' ) {

        if ( $Param{Object} eq 'DynamicFieldLabel' ) {
            $DynamicFieldContent = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
                ResultType => 'HASH'
            );
            $DynamicFieldName = 'DynamicFieldID';
        }
        else {
            $DynamicFieldContent = $Kernel::OM->Get('Kernel::System::Translations')->WithContentDynamicFields();
            $DynamicFieldName    = 'DynamicFieldListWithContent';
        }

        if ( $Param{AllowAll} && $Param{Object} eq 'DynamicFieldContent' ) {
            $DynamicFieldContent->{'ListAll'} = '- List all possible values from all Dynamic Fields -';
        }
        elsif ( $Param{AllowAll} && $Param{Object} eq 'DynamicFieldLabel' ) {
            $DynamicFieldContent->{'ListAll'} = '- List all possible labels from all Dynamic Fields -';
        }

        my $FieldData = $LayoutObject->TranslationsDynamicField(
            Data => {
                Name           => $DynamicFieldName,
                PossibleValues => $DynamicFieldContent,
                Object         => $Param{Object}
            }
        );

        if ( $Param{ErrorControl} ) {
            return $FieldData;
        }

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => $FieldData,
            Type        => 'inline',
            NoCache     => 1,
        );

    }
    elsif ( $Param{Object} eq 'GeneralLabel' ) {
        my $FieldData = $LayoutObject->TranslationsGeneral(
            Data => {
                Content => $Param{Content} || '',
                Value   => $Param{Value}   || '',
                Object  => $Param{Object}
            }
        );

        if ( $Param{ErrorControl} ) {
            return $FieldData;
        }

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => $FieldData,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    return;
}

sub _GetDraftTable {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $IDs          = 1;
    my $DraftTable   = '';
    my @DataValues;

    my %UniqueValues = %{
        $Kernel::OM->Get('Kernel::System::Translations')->GetTranslationUniqueValues(
            LanguageID => $Param{LanguageID}
        )
    };

    if ( $Param{Object} eq 'DynamicFieldContent' || $Param{Object} eq 'DynamicFieldLabel' ) {
        if ( $Param{DynamicFieldID} ne 'ListAll' ) {
            my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                ID => $Param{DynamicFieldID}
            );

            if ( $Param{Object} eq 'DynamicFieldContent' ) {
                my $PossibleValues = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicField,
                ) || {};

                for my $Row ( sort keys $PossibleValues->%* ) {
                    if ( $PossibleValues->{$Row} ne '-' && !$UniqueValues{$Row} ) {
                        my $Reference = {
                            ID      => $IDs,
                            Content => $PossibleValues->{$Row},
                            Value   => ''
                        };
                        push @DataValues, $Reference;
                        $IDs++;
                    }
                }
            }
            else {
                my $FieldData = $LayoutObject->TranslationsGeneral(
                    Data => {
                        Content => $DynamicField->{Label},
                        Value   => '',
                        Object  => $Param{Object}
                    }
                );

                return $LayoutObject->Attachment(
                    ContentType => 'text/html',
                    Content     => $FieldData,
                    Type        => 'inline',
                    NoCache     => 1,
                );
            }
        }
        else {
            my $DynamicFieldContent;
            my %AllValues;

            if ( $Param{Object} eq 'DynamicFieldLabel' ) {
                $DynamicFieldContent = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
                    ResultType => 'HASH'
                );

                for my $FieldID ( keys %{$DynamicFieldContent} ) {
                    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                        ID => $FieldID
                    );

                    if ( !$UniqueValues{ $DynamicField->{Label} } ) {
                        my $Reference = {
                            ID      => $IDs,
                            Content => $DynamicField->{Label},
                            Value   => ''
                        };
                        push @DataValues, $Reference;
                        $IDs++;
                    }
                }

            }
            else {
                $DynamicFieldContent = $Kernel::OM->Get('Kernel::System::Translations')->WithContentDynamicFields();

                my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
                my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

                for my $FieldID ( sort keys %{$DynamicFieldContent} ) {
                    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                        ID => $FieldID
                    );

                    my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                        DynamicFieldConfig => $DynamicField,
                    ) || {};

                    for my $Value ( values $PossibleValues->%* ) {
                        $AllValues{$Value} = $Value;
                    }
                }
            }

            for my $Row ( sort keys %AllValues ) {
                if ( $AllValues{$Row} ne '-' && !$UniqueValues{$Row} ) {
                    my $Reference = {
                        ID      => $IDs,
                        Content => $AllValues{$Row},
                        Value   => ''
                    };
                    push @DataValues, $Reference;
                    $IDs++;
                }
            }
        }
    }
    else {
        my %ObjectList;

        if ( $Param{Object} eq 'SLA' ) {
            %ObjectList = $Kernel::OM->Get('Kernel::System::SLA')->SLAList( UserID => 1 );
        }
        elsif ( $Param{Object} eq 'Queue' ) {
            %ObjectList = $Kernel::OM->Get('Kernel::System::Queue')->QueueList();
        }
        elsif ( $Param{Object} eq 'State' ) {
            %ObjectList = $Kernel::OM->Get('Kernel::System::State')->StateList( UserID => $Self->{UserID} );
        }
        elsif ( $Param{Object} eq 'Template' ) {
            %ObjectList = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList( Valid => 0 );
        }
        elsif ( $Param{Object} eq 'Priority' ) {
            %ObjectList = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList( Valid => 0 );
        }
        elsif ( $Param{Object} eq 'Service' ) {
            %ObjectList = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
                Valid  => 0,
                UserID => 1
            );
        }
        elsif ( $Param{Object} eq 'Type' ) {
            %ObjectList = $Kernel::OM->Get('Kernel::System::Type')->TypeList( Valid => 0 );
        }

        if ( keys %ObjectList ) {
            for my $Row ( sort keys %ObjectList ) {
                if ( !$UniqueValues{ $ObjectList{$Row} } ) {
                    my $Reference = {
                        ID      => $IDs,
                        Content => $ObjectList{$Row},
                        Value   => ''
                    };
                    push @DataValues, $Reference;
                    $IDs++;
                }
            }
        }
    }

    $DraftTable = $LayoutObject->TranslationsTableCreate(
        Data => {
            Values => \@DataValues,
            Object => $Param{Object}
        }
    );

    return $LayoutObject->Attachment(
        ContentType => 'text/html',
        Content     => $DraftTable,
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;
