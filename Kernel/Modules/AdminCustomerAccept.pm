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

package Kernel::Modules::AdminCustomerAccept;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $RichText     = $ConfigObject->Get('Frontend::RichText');

    # set type for notifications
    my $ContentType = 'text/plain';
    if ($RichText) {
        $ContentType = 'text/html';
    }

    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $DataStorageObject = $Kernel::OM->Get('Kernel::System::DataStorage');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    my %GetParam;
    my %Data = $DataStorageObject->Get(
        Type => 'CustomerAccept',
    );

    if ( $Self->{Subaction} && $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $DataStorageObject->Delete(
            Type => 'CustomerAccept',
        );

        my @LanguageIDs = $ParamObject->GetArray( Param => 'LanguageID' );
        $GetParam{LanguageID} = \@LanguageIDs;

        my $Error;

        # get the subject and body for all languages
        for my $LanguageID ( @{ $GetParam{LanguageID} } ) {

            my $Body = $ParamObject->GetParam( Param => $LanguageID . '_Body' ) || '';

            $GetParam{Message}->{$LanguageID} = {
                Body        => $Body,
                ContentType => $ContentType,
            };

            if ( !$Body ) {
                $GetParam{ $LanguageID . '_BodyServerError' } = "ServerError";
                $Error = 1;
            }
            else {
                my $Success = $DataStorageObject->Set(
                    Type   => 'CustomerAccept',
                    Key    => $LanguageID,
                    Value  => $GetParam{Message}->{$LanguageID},
                    UserID => $Self->{UserID},
                );

                if ($Success) {
                    $Data{$LanguageID} = $GetParam{Message}->{$LanguageID};
                }
                else {
                    $Error = 1;
                }
            }
        }

        %Data = $GetParam{Message}->%*;

        if ($Error) {
            $Output .= $LayoutObject->Notify(
                Info     => Translatable('Could not update Privacy Policy!'),
                Priority => 'Error',
            );
        }
        else {
            $Output .= $LayoutObject->Notify( Info => Translatable('Privacy Policy updated!') );
        }
    }

    # add rich text editor
    if ($RichText) {

        # set up rich text editor
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }

    # get names of languages in English
    my %DefaultUsedLanguages = %{ $ConfigObject->Get('DefaultUsedLanguages') || {} };

    # get language ids from message parameter, use English if no message is given
    # make sure English is the first language
    my @LanguageIDs;
    if (%Data) {
        if ( $Data{en} ) {
            push @LanguageIDs, 'en';
        }
        LANGUAGEID:
        for my $LanguageID ( sort keys %Data ) {
            next LANGUAGEID if $LanguageID eq 'en';
            push @LanguageIDs, $LanguageID;
        }
    }
    elsif ( $DefaultUsedLanguages{en} ) {
        push @LanguageIDs, 'en';
    }
    else {
        push @LanguageIDs, ( sort keys %DefaultUsedLanguages )[0];
    }

    # get native names of languages
    my %DefaultUsedLanguagesNative = %{ $ConfigObject->Get('DefaultUsedLanguagesNative') || {} };

    my %Languages;
    LANGUAGEID:
    for my $LanguageID ( sort keys %DefaultUsedLanguages ) {

        # next language if there is not set any name for current language
        if ( !$DefaultUsedLanguages{$LanguageID} && !$DefaultUsedLanguagesNative{$LanguageID} ) {
            next LANGUAGEID;
        }

        # get texts in native and default language
        my $Text        = $DefaultUsedLanguagesNative{$LanguageID} || '';
        my $TextEnglish = $DefaultUsedLanguages{$LanguageID}       || '';

        # translate to current user's language
        my $TextTranslated =
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate($TextEnglish);

        if ( $TextTranslated && $TextTranslated ne $Text ) {
            $Text .= ' - ' . $TextTranslated;
        }

        # next language if there is not set English nor native name of language.
        next LANGUAGEID if !$Text;

        $Languages{$LanguageID} = $Text;
    }

    # copy original list of languages which will be used for rebuilding language selection
    my %OriginalDefaultUsedLanguages = %Languages;

    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    for my $LanguageID (@LanguageIDs) {

        # format the content according to the content type
        if ($RichText) {

            # make sure body is rich text (if body is based on config)
            if (
                $Data{$LanguageID}->{ContentType}
                && $Data{$LanguageID}->{ContentType} =~ m{text\/plain}xmsi
                )
            {
                $Data{$LanguageID}->{Body} = $HTMLUtilsObject->ToHTML(
                    String => $Data{$LanguageID}->{Body},
                );
            }
        }
        else {

            # reformat from HTML to plain
            if (
                $Data{$LanguageID}->{ContentType}
                && $Data{$LanguageID}->{ContentType} =~ m{text\/html}xmsi
                && $Data{$LanguageID}->{Body}
                )
            {
                $Data{$LanguageID}->{Body} = $HTMLUtilsObject->ToAscii(
                    String => $Data{$LanguageID}->{Body},
                );
            }
        }

        # show the notification for this language
        $LayoutObject->Block(
            Name => 'PrivacyPolicyLanguage',
            Data => {
                %Param,
                Body            => $Data{$LanguageID}->{Body} || '',
                LanguageID      => $LanguageID,
                Language        => $Languages{$LanguageID},
                BodyServerError => $GetParam{ $LanguageID . '_BodyServerError' } || '',
            },
        );

        $LayoutObject->Block(
            Name => 'PrivacyPolicyLanguageRemoveButton',
            Data => {
                %Param,
                LanguageID => $LanguageID,
            },
        );

        # delete language from drop-down list because it is already shown
        delete $Languages{$LanguageID};
    }

    $Param{LanguageStrg} = $LayoutObject->BuildSelection(
        Data         => \%Languages,
        Name         => 'Language',
        Class        => 'Modernize W50pc LanguageAdd',
        Translation  => 1,
        PossibleNone => 1,
        HTMLQuote    => 0,
    );
    $Param{LanguageOrigStrg} = $LayoutObject->BuildSelection(
        Data         => \%OriginalDefaultUsedLanguages,
        Name         => 'LanguageOrig',
        Translation  => 1,
        PossibleNone => 1,
        HTMLQuote    => 0,
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminCustomerAccept',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
