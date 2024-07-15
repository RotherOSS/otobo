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

package Kernel::Language;

use v5.24;
use strict;
use warnings;

# use namespace::autoclean; no yet activated as there might be unwanted side effects
use utf8;

# core modules
use Exporter    qw(import);
use File::stat  qw(stat);
use Digest::MD5 qw(md5_hex);

# CPAN modules

# OTOBO modules
use Kernel::System::DateTime qw(OTOBOTimeZoneGet);

our @EXPORT_OK = qw(Translatable);    ## no critic qw(OTOBO::RequireCamelCase)

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Log
    Kernel::System::Main
    Kernel::System::ReferenceData
);

=head1 NAME

Kernel::Language - global language interface

=head1 DESCRIPTION

All language functions.

=head1 PUBLIC INTERFACE

=head2 new()

create a language object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::Language' => {
            UserLanguage => 'de',
        },
    );
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {%Param}, $Type;

    # 0=off; 1=on; 2=get all not translated words; 3=get all requests
    $Self->{Debug} = 0;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    # user language
    $Self->{UserLanguage} = $Param{UserLanguage}
        || $ConfigObject->Get('DefaultLanguage')
        || 'en';

    # check if language is configured
    my %Languages = %{ $ConfigObject->Get('DefaultUsedLanguages') };
    if ( !$Languages{ $Self->{UserLanguage} } ) {
        $Self->{UserLanguage} = 'en';
    }

    # take time zone
    $Self->{TimeZone} = $Param{UserTimeZone} || $Param{TimeZone} || OTOBOTimeZoneGet();

    # fetch localization setting
    $Self->{TimeShowLocalization} = $ConfigObject->Get('TimeShowLocalization') || 0;

    # Debug
    if ( $Self->{Debug} > 0 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "UserLanguage = $Self->{UserLanguage}",
        );
    }

    my $Home = $ConfigObject->Get('Home') . '/';

    my $LanguageFile = "Kernel::Language::$Self->{UserLanguage}";

    # load text catalog ...
    if ( !$MainObject->Require($LanguageFile) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Sorry, can't locate or load $LanguageFile "
                . "translation! Check the Kernel/Language/$Self->{UserLanguage}.pm (perl -cw)!",
        );
    }
    else {
        push @{ $Self->{LanguageFiles} }, "$Home/Kernel/Language/$Self->{UserLanguage}.pm";
    }

    my $LanguageFileDataMethod = $LanguageFile->can('Data');

    # Execute translation map by calling language file data method via reference.
    if ($LanguageFileDataMethod) {
        if ( $LanguageFileDataMethod->($Self) ) {

            # Debug info.
            if ( $Self->{Debug} > 0 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "Kernel::Language::$Self->{UserLanguage} load ... done.",
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

    # load action text catalog ...
    my $CustomTranslationModule = '';
    my $CustomTranslationFile   = '';

    # do not include addition translation files, a new translation file gets created
    if ( !$Param{TranslationFile} ) {

        # looking to addition translation files
        my @Files = $MainObject->DirectoryRead(
            Directory => $Home . "Kernel/Language/",
            Filter    => "$Self->{UserLanguage}_*.pm",
        );
        FILE:
        for my $File (@Files) {

            # get module name based on file name
            my $Module = $File =~ s/^$Home(.*)\.pm$/$1/rg;
            $Module =~ s/\/\//\//g;
            $Module =~ s/\//::/g;

            # Do we have a toplevel language without country code?
            if ( length $Self->{UserLanguage} == 2 ) {

                # Ignore sub-language translation files like (en_GB, en_CA, ...).
                #
                # This will not work for sr_Cyrl and sr_Latn, but in this case there is no "parent"
                #   language where this could be problematic.
                next FILE if $Module =~ /^Kernel::Language::[a-z]{2}_[A-Z]{2}$/;    # en_GB
                next FILE if $Module =~ /^Kernel::Language::[a-z]{2}_[A-Z]{2}_/;    # en_GB_ITSM*
            }

            # Remember custom files to load at the end.
            if ( $Module =~ /_Custom$/ ) {
                $CustomTranslationModule = $Module;
                $CustomTranslationFile   = $File;
                next FILE;
            }

            # load translation module
            if ( !$MainObject->Require($Module) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Sorry, can't load $Module! Check the $File (perl -cw)!",
                );
                next FILE;
            }
            else {
                push @{ $Self->{LanguageFiles} }, $File;
            }

            my $ModuleDataMethod = $Module->can('Data');

            if ( !$ModuleDataMethod ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Sorry, can't load $Module! Check if it provides Data method.",
                );
                next FILE;
            }

            # Execute translation map by calling module data method via reference.
            if ( eval { $ModuleDataMethod->($Self) } ) {

                # debug info
                if ( $Self->{Debug} > 0 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => "$Module load ... done.",
                    );
                }
            }
        }

        # load custom text catalog ...
        if ( $CustomTranslationModule && $MainObject->Require($CustomTranslationModule) ) {

            push @{ $Self->{LanguageFiles} }, $CustomTranslationFile;

            my $CustomTranslationDataMethod = $CustomTranslationModule->can('Data');

            # Execute translation map by calling custom module data method via reference.
            if ($CustomTranslationDataMethod) {
                if ( eval { $CustomTranslationDataMethod->($Self) } ) {

                    # Debug info.
                    if ( $Self->{Debug} > 0 ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'Debug',
                            Message  => "$CustomTranslationModule load ... done.",
                        );
                    }
                }
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Sorry, can't load $CustomTranslationModule! Check if it provides Data method.",
                );
            }
        }
    }

    # get source file charset
    # what charset should I use (take it from translation file)!
    if ( $Self->{Charset} && ref $Self->{Charset} eq 'ARRAY' ) {
        $Self->{TranslationCharset} = $Self->{Charset}->[-1];
    }

    return $Self;
}

=head2 Translatable()

this is a no-op to mark a text as translatable in the Perl code.

Returns the first parameter.

=cut

sub Translatable {
    return shift;
}

=head2 Translate()

translate a text with placeholders.
Valid placeholders are '%s' and '%d'.

    my $TranslatedText = $LanguageObject->Translate('Hello %s!', 'world');

=cut

sub Translate {
    my ( $Self, $Text, @Replacements ) = @_;

    $Text //= '';
    $Text = $Self->{Translation}->{$Text} || $Text;

    # Expecting that the replacements do not contain a '%'.
    # That the substitutions stop at the first undefined replacement can be considered a bug.
    for my $Replacement (@Replacements) {
        return $Text unless defined $Replacement;

        $Text =~ s/\%(?:s|d)/$Replacement/;
    }

    return $Text;
}

=head2 FormatTimeString()

formats a timestamp according to the specified date format for the current
language (locale).

    my $Date = $LanguageObject->FormatTimeString(
        '2009-12-12 12:12:12',  # timestamp
        'DateFormat',           # which date format to use, e. g. DateFormatLong
        0,                      # optional, hides the seconds from the time output
    );

Please note that the TimeZone will not be applied in the case of DateFormatShort (date only)
to avoid switching to another date.

If you only pass an ISO date ('2009-12-12'), it will be returned unchanged.
Invalid strings will also be returned with an error logged.

=cut

sub FormatTimeString {
    my ( $Self, $String, $Config, $Short ) = @_;

    return '' if !$String;

    $Config ||= 'DateFormat';
    $Short  ||= 0;

    # Valid timestamp
    if ( $String =~ /(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})/ ) {
        my $ReturnString = $Self->{$Config} || "$Config needs to be translated!";

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $String,
            },
        );

        if ( !$DateTimeObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid date/time string $String.",
            );

            return $String;
        }

        # Convert to time zone, but only if we actually display the time!
        # Otherwise the date might be off by one day because of the TimeZone diff.
        if ( $Self->{TimeZone} && $Config ne 'DateFormatShort' ) {
            $DateTimeObject->ToTimeZone( TimeZone => $Self->{TimeZone} );
        }

        my $DateTimeValues = $DateTimeObject->Get();

        my $Year      = $DateTimeValues->{Year};
        my $Month     = sprintf "%02d", $DateTimeValues->{Month};
        my $MonthAbbr = $DateTimeValues->{MonthAbbr};
        my $Day       = sprintf "%02d", $DateTimeValues->{Day};
        my $DayAbbr   = $DateTimeValues->{DayAbbr};
        my $Hour      = sprintf "%02d", $DateTimeValues->{Hour};
        my $Minute    = sprintf "%02d", $DateTimeValues->{Minute};
        my $Second    = sprintf "%02d", $DateTimeValues->{Second};

        if ($Short) {
            $ReturnString =~ s/\%T/$Hour:$Minute/g;
        }
        else {
            $ReturnString =~ s/\%T/$Hour:$Minute:$Second/g;
        }
        $ReturnString =~ s/\%D/$Day/g;
        $ReturnString =~ s/\%M/$Month/g;
        $ReturnString =~ s/\%Y/$Year/g;

        $ReturnString =~ s{(\%A)}{$Self->Translate($DayAbbr);}egx;
        $ReturnString
            =~ s{(\%B)}{$Self->Translate($MonthAbbr);}egx;

        # output time zone only if it differs from OTOBO' time zone
        if (
            $Self->{'TimeShowLocalization'}
            && $Config ne 'DateFormatShort'
            && $Self->{TimeZone}
            && $Self->{TimeZone} ne OTOBOTimeZoneGet()
            )
        {
            return $ReturnString . " ($Self->{TimeZone})";
        }

        return $ReturnString;
    }

    # Invalid string passed? (don't log for ISO dates)
    if ( $String !~ /^(\d{2}:\d{2}:\d{2})$/ ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No FormatTimeString() translation found for '$String' string!",
        );
    }

    return $String;

}

=head2 GetPossibleCharsets()

Returns an array of possible charsets (based on translation file).

    my @Charsets = $LanguageObject->GetPossibleCharsets().

=cut

sub GetPossibleCharsets {
    my $Self = shift;

    return @{ $Self->{Charset} } if $Self->{Charset};
    return;
}

=head2 Time()

Returns a time string in language format (based on translation file).

    $Time = $LanguageObject->Time(
        Action => 'GET',
        Format => 'DateFormat',
    );

    $TimeLong = $LanguageObject->Time(
        Action => 'GET',
        Format => 'DateFormatLong',
    );

    $TimeLong = $LanguageObject->Time(
        Action => 'RETURN',
        Format => 'DateFormatLong',
        Year   => 1977,
        Month  => 10,
        Day    => 27,
        Hour   => 20,
        Minute => 10,
        Second => 05,
    );

These tags are supported: %A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;

Note that %A only works correctly with Action GET, it might be dropped otherwise.

Also note that it is also possible to pass HTML strings for date input:

    $TimeLong = $LanguageObject->Time(
        Action => 'RETURN',
        Format => 'DateInputFormatLong',
        Mode   => 'NotNumeric',
        Year   => '<input value="2014"/>',
        Month  => '<input value="1"/>',
        Day    => '<input value="10"/>',
        Hour   => '<input value="11"/>',
        Minute => '<input value="12"/>',
        Second => '<input value="13"/>',
    );

Note that %B may not work in NonNumeric mode.

=cut

sub Time {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Action Format)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    my $ReturnString = $Self->{ $Param{Format} } || 'Need to be translated!';
    my ( $Year, $Month, $MonthAbbr, $Day, $DayAbbr, $Hour, $Minute, $Second );

    # set or get time
    if ( lc $Param{Action} eq 'get' ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                TimeZone => $Self->{TimeZone},
            },
        );
        my $DateTimeValues = $DateTimeObject->Get();

        $Year      = $DateTimeValues->{Year};
        $Month     = sprintf "%02d", $DateTimeValues->{Month};
        $MonthAbbr = $DateTimeValues->{MonthAbbr};
        $Day       = sprintf "%02d", $DateTimeValues->{Day};
        $DayAbbr   = $DateTimeValues->{DayAbbr};
        $Hour      = sprintf "%02d", $DateTimeValues->{Hour};
        $Minute    = sprintf "%02d", $DateTimeValues->{Minute};
        $Second    = sprintf "%02d", $DateTimeValues->{Second};
    }
    elsif ( lc $Param{Action} eq 'return' ) {
        $Year   = $Param{Year}   || 0;
        $Month  = $Param{Month}  || 0;
        $Day    = $Param{Day}    || 0;
        $Hour   = $Param{Hour}   || 0;
        $Minute = $Param{Minute} || 0;
        $Second = $Param{Second} || 0;

        my @MonthAbbrs = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        $MonthAbbr = defined $Month && $Month =~ m/^\d+$/ ? $MonthAbbrs[ $Month - 1 ] : '';
    }

    # do replace
    if ( ( lc $Param{Action} eq 'get' ) || ( lc $Param{Action} eq 'return' ) ) {
        my $Time = '';
        if ( $Param{Mode} && $Param{Mode} =~ /^NotNumeric$/i ) {
            if ( !$Second ) {
                $Time = "$Hour:$Minute";
            }
            else {
                $Time = "$Hour:$Minute:$Second";
            }
        }
        else {
            $Time  = sprintf( "%02d:%02d:%02d", $Hour, $Minute, $Second );
            $Day   = sprintf( "%02d", $Day );
            $Month = sprintf( "%02d", $Month );
        }
        $ReturnString =~ s/\%T/$Time/g;
        $ReturnString =~ s/\%D/$Day/g;
        $ReturnString =~ s/\%M/$Month/g;
        $ReturnString =~ s/\%Y/$Year/g;
        $ReturnString =~ s{(\%A)}{defined $DayAbbr ? $Self->Translate($DayAbbr) : '';}egx;
        $ReturnString
            =~ s{(\%B)}{defined $MonthAbbr ? $Self->Translate($MonthAbbr) : '';}egx;
        return $ReturnString;
    }

    return $ReturnString;
}

=head2 LanguageChecksum()

This function returns an MD5 sum that is generated from all loaded language files and their modification timestamps.
Whenever a file is changed, added or removed, this checksum will change.

=cut

sub LanguageChecksum {
    my $Self = shift;

    # Create a string with filenames and file modification times of the loaded language files.
    my $LanguageString = '';
    for my $File ( @{ $Self->{LanguageFiles} } ) {

        # get file metadata
        my $Stat = stat $File;

        if ( !$Stat ) {
            print STDERR "Error: cannot stat file '$File': $!";
            return;
        }

        $LanguageString .= $File . $Stat->mtime;
    }

    return md5_hex($LanguageString);
}

=head2 LanguageList()

This function returns a hash mapping language codes to a label. The label contains the native language name
and the translation into the user language. This hash is intended for language selection.

    my %Languages = $LanguageObject->LanguageList(
        WithInProcessIndicator => 1, # 0|1, optional, default is 0, whether (in process) is displayed for sparsely translated languages
    );

=cut

sub LanguageList {
    my ( $Self, %Param ) = @_;

    my %Languages;
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $ReferenceDataObject = $Kernel::OM->Get('Kernel::System::ReferenceData');

    # get names of languages in English
    my %DefaultUsedLanguages = ( $ConfigObject->Get('DefaultUsedLanguages') || {} )->%*;

    # get native names of languages
    my %DefaultUsedLanguagesNative = ( $ConfigObject->Get('DefaultUsedLanguagesNative') || {} )->%*;

    my $InProcessText = $Self->Translate('(in process)');

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
        my $TextTranslated;
        if ( $ConfigObject->Get('ReferenceData::TranslatedLanguageNames') ) {
            $TextTranslated = $ReferenceDataObject->LanguageCode2Name(
                LanguageCode => $LanguageID,
                Language     => $Self->{UserLanguage},
            );
        }

        # fall back to the default translation
        $TextTranslated //= $Self->Translate($TextEnglish);

        if ( $TextTranslated && $TextTranslated ne $Text ) {
            $Text .= ' - ' . $TextTranslated;
        }

        # next language if there is neither English nor native name of language set.
        next LANGUAGEID unless $Text;

        # add the (in process) message if requested
        if ( $Param{WithInProcessIndicator} ) {
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $LanguageID,
            );

            next LANGUAGEID unless $LanguageObject;

            my $Completeness = $LanguageObject->{Completeness};

            # mark all languages with < 25% coverage as "in process" (not for en_ variants).
            if ( defined $Completeness && $Completeness < 0.25 && $LanguageID !~ m{^en_}smx ) {
                $Text .= ' ' . $InProcessText;
            }
        }

        # This will be used in the selection
        $Languages{$LanguageID} = $Text;
    }

    return %Languages;
}

1;
