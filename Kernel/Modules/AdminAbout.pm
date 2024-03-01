# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Modules::AdminAbout;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
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

    my $Output = join '',
        $LayoutObject->Header,
        $LayoutObject->NavigationBar;

    my %GetParam;
    my %Data = $DataStorageObject->Get(
        Type => 'AboutMessage',
    );

    if ( $Self->{Subaction} && $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $DataStorageObject->Delete(
            Type => 'AboutMessage',
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
                    Type   => 'AboutMessage',
                    Key    => $LanguageID,
                    Value  => $GetParam{Message}->{$LanguageID},
                    UserID => $Self->{UserID},
                );

                if ( !$Success ) {
                    $Error = 1;
                }
            }
        }

        %Data = $GetParam{Message}->%*;

        if ($Error) {
            $Output .= $LayoutObject->Notify(
                Info     => Translatable('Could not update About message!'),
                Priority => 'Error',
            );
        }
        else {
            $Output .= $LayoutObject->Notify( Info => Translatable('About message updated!') );
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

    my %Languages = $LayoutObject->{LanguageObject}->LanguageList;

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
            Name => 'AboutLanguage',
            Data => {
                %Param,
                Body            => $Data{$LanguageID}->{Body} || '',
                LanguageID      => $LanguageID,
                Language        => $Languages{$LanguageID},
                BodyServerError => $GetParam{ $LanguageID . '_BodyServerError' } || '',
            },
        );

        $LayoutObject->Block(
            Name => 'AboutLanguageRemoveButton',
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
        TemplateFile => 'AdminAbout',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
