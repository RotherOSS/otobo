# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::Preferences::Language;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Web::Request',
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID UserObject ConfigItem)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get names of languages in English
    my %DefaultUsedLanguages = %{ $ConfigObject->Get('DefaultUsedLanguages') || {} };

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

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $LanguageID,
        );
        next LANGUAGEID if !$LanguageObject;

        my $Completeness = $LanguageObject->{Completeness};

        # mark all languages with < 25% coverage as "in process" (not for en_ variants).
        if ( defined $Completeness && $Completeness < 0.25 && $LanguageID !~ m{^en_}smx ) {
            $Text
                .= ' ' . $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate('(in process)');
        }
        $Languages{$LanguageID} = $Text;
    }

    my @Params;
    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            Data       => \%Languages,
            HTMLQuote  => 0,
            SelectedID => $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'UserLanguage' )
                || $Param{UserData}->{UserLanguage}
                || $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage}
                || $ConfigObject->Get('DefaultLanguage'),
            Block => 'Option',
            Class => 'W70pc',
            Max   => 200,
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for (@Array) {

            # pref update db
            if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $_,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $_,
                );
            }
        }
    }
    $Self->{Message} = Translatable('Preferences updated successfully!');
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
