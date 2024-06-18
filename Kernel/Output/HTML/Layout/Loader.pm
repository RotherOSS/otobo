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

package Kernel::Output::HTML::Layout::Loader;

use strict;
use warnings;
use v5.24;

# core modules
use File::stat;
use Digest::MD5;

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Loader - CSS/JavaScript

=head1 DESCRIPTION

All valid functions.

=head1 PUBLIC INTERFACE

=head2 LoaderCreateAgentCSSCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Agent::CommonCSS config item.

    $LayoutObject->LoaderCreateAgentCSSCalls(
        Skin => 'MySkin', # optional, if not provided skin is the configured by default
    );

=cut

sub LoaderCreateAgentCSSCalls {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get host based default skin configuration
    my $SkinSelectedHostBased;
    my $DefaultSkinHostBased = $ConfigObject->Get('Loader::Agent::DefaultSelectedSkin::HostBased');
    my $ParamObject          = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Host                 = $ParamObject->HTTP('HOST');
    if ( $DefaultSkinHostBased && $Host ) {
        REGEXP:
        for my $RegExp ( sort keys %{$DefaultSkinHostBased} ) {

            # do not use empty regexp or skin directories
            next REGEXP if !$RegExp;
            next REGEXP if !$DefaultSkinHostBased->{$RegExp};

            # check if regexp is matching
            if ( $Host =~ m/$RegExp/i ) {
                $SkinSelectedHostBased = $DefaultSkinHostBased->{$RegExp};
            }
        }
    }

    # determine skin
    # 1. use UserSkin setting from Agent preferences, if available
    # 2. use HostBased skin setting, if available
    # 3. use default skin from configuration

    my $SkinSelected = $Self->{'UserSkin'};

    # check if the skin is valid
    my $SkinValid = 0;
    if ($SkinSelected) {
        $SkinValid = $Self->SkinValidate(
            SkinType => 'Agent',
            Skin     => $SkinSelected,
        );
    }

    if ( !$SkinValid ) {
        $SkinSelected = $SkinSelectedHostBased
            || $ConfigObject->Get('Loader::Agent::DefaultSelectedSkin')
            || 'default';
    }

    # save selected skin
    $Self->{SkinSelected} = $SkinSelected;

    my $SkinHome = $ConfigObject->Get('Home') . '/var/httpd/htdocs/skins';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::CSS');

    my $ToolbarModuleSettings    = $ConfigObject->Get('Frontend::ToolBarModule');
    my $CustomerUserItemSettings = $ConfigObject->Get('Frontend::CustomerUser::Item');

    {
        my @FileList;

        # get global css
        my $CommonCSSList = $ConfigObject->Get('Loader::Agent::CommonCSS');
        for my $Key ( sort keys %{$CommonCSSList} ) {
            push @FileList, @{ $CommonCSSList->{$Key} };
        }

        # get toolbar module css
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{CSS} ) {
                push @FileList, $ToolbarModuleSettings->{$Key}->{CSS};
            }
        }

        # get customer user item css
        for my $Key ( sort keys %{$CustomerUserItemSettings} ) {
            if ( $CustomerUserItemSettings->{$Key}->{CSS} ) {
                push @FileList, $CustomerUserItemSettings->{$Key}->{CSS};
            }
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
            Skin      => $SkinSelected,
        );
    }

    # now handle module specific CSS
    my $LoaderAction = $Self->{Action} || 'Login';
    $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

    {
        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{CSS} ne 'ARRAY';

            @FileList = ( @FileList, @{ $Setting->{$Module}->{CSS} || [] } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
            Skin      => $SkinSelected,
        );
    }

    # handle the responsive CSS
    {
        my @FileList;
        my $ResponsiveCSSList = $ConfigObject->Get('Loader::Agent::ResponsiveCSS');

        for my $Key ( sort keys %{$ResponsiveCSSList} ) {
            push @FileList, @{ $ResponsiveCSSList->{$Key} };
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ResponsiveCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
            Skin      => $SkinSelected,
        );
    }

    return 1;
}

=head2 LoaderCreateAgentJSCalls()

Generate the minified JavaScript files and the tags referencing them,
taking a list from the Loader::Agent::CommonJS config item.

    $LayoutObject->LoaderCreateAgentJSCalls();

=cut

sub LoaderCreateAgentJSCalls {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $JSHome   = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::JS');

    {
        my @FileList;

        # get global js
        my $CommonJSList = $ConfigObject->Get('Loader::Agent::CommonJS');

        KEY:
        for my $Key ( sort keys %{$CommonJSList} ) {
            next KEY if $Key eq '100-CKEditor' && !$ConfigObject->Get('Frontend::RichText');

            push @FileList, @{ $CommonJSList->{$Key} };
        }

        # get toolbar module js
        my $ToolbarModuleSettings = $ConfigObject->Get('Frontend::ToolBarModule');
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{JavaScript} ) {
                push @FileList, $ToolbarModuleSettings->{$Key}->{JavaScript};
            }
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonJS',
            JSHome    => $JSHome,
        );

    }

    # now handle module specific JavaScript
    {
        my $LoaderAction = $Self->{Action} || 'Login';
        $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{JavaScript} ne 'ARRAY';

            @FileList = ( @FileList, @{ $Setting->{$Module}->{JavaScript} || [] } );
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleJS',
            JSHome    => $JSHome,
        );

    }

    return 1;
}

=head2 LoaderCreateJavaScriptTemplateData()

Generate a minified file for the template data that
needs to be present on the client side for JavaScript based templates.

    $LayoutObject->LoaderCreateJavaScriptTemplateData();

=cut

sub LoaderCreateJavaScriptTemplateData {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # determine theme
    my $Theme = $Self->{UserTheme} || $ConfigObject->Get('DefaultTheme') || Translatable('Standard');

    # force a theme based on host name
    my $DefaultThemeHostBased = $ConfigObject->Get('DefaultTheme::HostBased');
    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Host                  = $ParamObject->HTTP('HOST');
    if ( $DefaultThemeHostBased && $Host ) {

        THEME:
        for my $RegExp ( sort keys %{$DefaultThemeHostBased} ) {

            # do not use empty regexp or theme directories
            next THEME if !$RegExp;
            next THEME if $RegExp eq '';
            next THEME if !$DefaultThemeHostBased->{$RegExp};

            # check if regexp is matching
            if ( $Host =~ m/$RegExp/i ) {
                $Theme = $DefaultThemeHostBased->{$RegExp};
            }
        }
    }

    # locate template files
    my $JSStandardTemplateDir = $ConfigObject->Get('TemplateDir') . '/JavaScript/Templates/' . 'Standard';
    my $JSTemplateDir         = $ConfigObject->Get('TemplateDir') . '/JavaScript/Templates/' . $Theme;

    # Check if 'Standard' fallback exists
    if ( !-e $JSStandardTemplateDir ) {
        $Self->FatalDie(
            Message =>
                "No existing template directory found ('$JSTemplateDir')! Check your Home in Kernel/Config.pm."
        );
    }

    if ( !-e $JSTemplateDir ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "No existing template directory found ('$JSTemplateDir')!.
                Default theme used instead.",
        );

        # Set TemplateDir to 'Standard' as a fallback.
        $Theme         = 'Standard';
        $JSTemplateDir = $JSStandardTemplateDir;
    }

    my $JSCustomStandardTemplateDir = $ConfigObject->Get('CustomTemplateDir') . '/JavaScript/Templates/' . 'Standard';
    my $JSCustomTemplateDir         = $ConfigObject->Get('CustomTemplateDir') . '/JavaScript/Templates/' . $Theme;

    my @TemplateFolders = (
        $JSCustomTemplateDir,
        $JSCustomStandardTemplateDir,
        $JSTemplateDir,
        $JSStandardTemplateDir,
    );

    my $JSHome               = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';
    my $TargetFilenamePrefix = 'TemplateJS';

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $CacheType   = 'Loader';
    my $CacheKey    = "LoaderCreateJavaScriptTemplateData:${Theme}";

    # Even getting the list of files recursively from the directories is expensive,
    #   so cache the checksum to avoid that. The cache is per theme.
    my $OldTemplateChecksum = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );
    if ($OldTemplateChecksum) {
        my $TemplateCacheFile = join '_',
            $TargetFilenamePrefix,
            $Theme,
            "$OldTemplateChecksum.js";

        # Check if loader cache already exists.
        if ( -e "$JSHome/js-cache/$TemplateCacheFile" ) {
            $Self->Block(
                Name => 'CommonJS',
                Data => {
                    JSDirectory => 'js-cache/',
                    Filename    => $TemplateCacheFile
                },
            );

            return 1;
        }
    }

    # if it doesnt exist, go through the folders and get the template content
    my ( %TemplateData, %ChecksumData );

    TEMPLATEFOLDER:
    for my $TemplateFolder (@TemplateFolders) {

        next TEMPLATEFOLDER unless -e $TemplateFolder;

        # get the names of the template files in the directory
        my @Templates = $MainObject->DirectoryRead(
            Directory => $TemplateFolder,
            Filter    => '*.tmpl',
            Recursive => 1,
        );

        TEMPLATE:
        for my $Template ( sort @Templates ) {

            next TEMPLATE unless -e $Template;

            my $Key = $Template;
            $Key =~ s/^$TemplateFolder\///xmsg;
            $Key =~ s/\.(\w+)\.tmpl$//xmsg;

            # check if a template with this name does already exist
            next TEMPLATE if $TemplateData{$Key};

            # get file metadata for the checksum data
            my $Stat = stat $Template;

            next TEMPLATE unless $Stat;

            $ChecksumData{$Key} = $Template . $Stat->mtime();

            my $TemplateContent = $MainObject->FileRead(
                Location => $Template,
                Result   => 'SCALAR',
            )->$*;

            # Remove DTL-style comments (lines starting with #)
            $TemplateContent =~ s/^#.*\n//gm;
            $TemplateData{$Key} = $TemplateContent;
        }
    }

    # generate a checksum only of the actual used files
    my $ChecksumInput = join
        '',
        map { $ChecksumData{$_} } sort keys %ChecksumData;
    my $TemplateChecksum = Digest::MD5::md5_hex($ChecksumInput);

    # remember the checksum, so that in the next iteration in doesn't have to be recomputed
    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        TTL   => 60 * 60 * 24,
        Value => $TemplateChecksum,
    );

    my $TemplateDataJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data   => \%TemplateData,
        Pretty => 0,
    );

    my $Content = <<"EOF";
// The content of this file is automatically generated, do not edit.
Core.Template.Load($TemplateDataJSON);
EOF
    my $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
        Checksum             => $TemplateChecksum,
        Content              => $Content,
        Type                 => 'JavaScript',
        TargetDirectory      => "$JSHome/js-cache/",
        TargetFilenamePrefix => "${TargetFilenamePrefix}_${Theme}",
    );

    $Self->Block(
        Name => 'CommonJS',
        Data => {
            JSDirectory => 'js-cache/',
            Filename    => $MinifiedFile,
        },
    );

    return 1;
}

=head2 LoaderCreateJavaScriptTranslationData()

Generate a minified file for the translation data that
needs to be present on the client side for JavaScript based translations.

    $LayoutObject->LoaderCreateJavaScriptTranslationData();

=cut

sub LoaderCreateJavaScriptTranslationData {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $JSHome       = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';

    my $UserLanguage     = $Self->{UserLanguage};
    my $LanguageObject   = $Self->{LanguageObject};
    my $LanguageChecksum = $LanguageObject->LanguageChecksum();

    my $TargetFilenamePrefix = "TranslationJS_$UserLanguage";

    # Check if cache already exists.
    if ( -e "$JSHome/js-cache/${TargetFilenamePrefix}_$LanguageChecksum.js" ) {
        $Self->Block(
            Name => 'CommonJS',
            Data => {
                JSDirectory => 'js-cache/',
                Filename    => "${TargetFilenamePrefix}_$LanguageChecksum.js",
            },
        );
        return 1;
    }

    # Now create translation data for JavaScript.
    my %TranslationData;
    STRING:
    for my $String ( @{ $LanguageObject->{JavaScriptStrings} // [] } ) {
        next STRING if $TranslationData{$String};

        $TranslationData{$String} = $LanguageObject->{Translation}->{$String};
    }

    my %LanguageMetaData = (
        LanguageCode        => $UserLanguage,
        DateFormat          => $LanguageObject->{DateFormat},
        DateFormatLong      => $LanguageObject->{DateFormatLong},
        DateFormatShort     => $LanguageObject->{DateFormatShort},
        DateInputFormat     => $LanguageObject->{DateInputFormat},
        DateInputFormatLong => $LanguageObject->{DateInputFormatLong},
        Completeness        => $LanguageObject->{Completeness},
        Separator           => $LanguageObject->{Separator},
        DecimalSeparator    => $LanguageObject->{DecimalSeparator},
    );

    my $LanguageMetaDataJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data     => \%LanguageMetaData,
        SortKeys => 1,
        Pretty   => 0,
    );

    my $TranslationDataJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data     => \%TranslationData,
        SortKeys => 1,
        Pretty   => 0,
    );

    my $Content = <<"EOF";
// The content of this file is automatically generated, do not edit.
Core.Language.Load($LanguageMetaDataJSON, $TranslationDataJSON);
EOF
    my $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
        Checksum             => $LanguageChecksum,
        Content              => $Content,
        Type                 => 'JavaScript',
        TargetDirectory      => "$JSHome/js-cache/",
        TargetFilenamePrefix => $TargetFilenamePrefix,
    );

    $Self->Block(
        Name => 'CommonJS',
        Data => {
            JSDirectory => 'js-cache/',
            Filename    => $MinifiedFile,
        },
    );

    return 1;
}

=head2 LoaderCreateCustomerCSSCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Customer::CommonCSS config item.

    $LayoutObject->LoaderCreateCustomerCSSCalls();

=cut

sub LoaderCreateCustomerCSSCalls {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SkinSelected = $ConfigObject->Get('Loader::Customer::SelectedSkin')
        || 'default';

    # force a skin based on host name
    my $DefaultSkinHostBased = $ConfigObject->Get('Loader::Customer::SelectedSkin::HostBased');
    my $ParamObject          = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Host                 = $ParamObject->HTTP('HOST');
    if ( $DefaultSkinHostBased && $Host ) {
        REGEXP:
        for my $RegExp ( sort keys %{$DefaultSkinHostBased} ) {

            # do not use empty regexp or skin directories
            next REGEXP if !$RegExp;
            next REGEXP if !$DefaultSkinHostBased->{$RegExp};

            # check if regexp is matching
            if ( $Host =~ m/$RegExp/i ) {
                $SkinSelected = $DefaultSkinHostBased->{$RegExp};
            }
        }
    }

    my $SkinHome = $ConfigObject->Get('Home') . '/var/httpd/htdocs/skins';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::CSS');

    {
        my $CommonCSSList = $ConfigObject->Get('Loader::Customer::CommonCSS');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSList} ) {
            push @FileList, @{ $CommonCSSList->{$Key} };
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
            Skin      => $SkinSelected,
        );
    }

    # now handle module specific CSS
    my $LoaderAction = $Self->{Action} || 'Login';
    $LoaderAction = 'Login'         if ( $LoaderAction eq 'Logout' );
    $LoaderAction = 'CustomerLogin' if ( $LoaderAction eq 'Login' );

    {
        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{CSS} ne 'ARRAY';

            @FileList = ( @FileList, @{ $Setting->{$Module}->{CSS} || [] } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
            Skin      => $SkinSelected,
        );
    }

    # handle the responsive CSS
    {
        my @FileList;
        my $ResponsiveCSSList = $ConfigObject->Get('Loader::Customer::ResponsiveCSS');

        for my $Key ( sort keys %{$ResponsiveCSSList} ) {
            push @FileList, @{ $ResponsiveCSSList->{$Key} };
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ResponsiveCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
            Skin      => $SkinSelected,
        );
    }

    return 1;
}

=head2 LoaderCreateCustomerJSCalls()

Generate the minified JavaScript files and the tags referencing them,
taking a list from the Loader::Customer::CommonJS config item.

    $LayoutObject->LoaderCreateCustomerJSCalls();

=cut

sub LoaderCreateCustomerJSCalls {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $JSHome   = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::JS');

    {
        my $CommonJSList = $ConfigObject->Get('Loader::Customer::CommonJS');

        my @FileList;

        KEY:
        for my $Key ( sort keys %{$CommonJSList} ) {
            next KEY if $Key eq '100-CKEditor' && !$ConfigObject->Get('Frontend::RichText');

            push @FileList, @{ $CommonJSList->{$Key} };
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonJS',
            JSHome    => $JSHome,
        );

    }

    # now handle module specific JS
    {
        my $LoaderAction = $Self->{Action} || 'CustomerLogin';
        $LoaderAction = 'CustomerLogin' if ( $LoaderAction eq 'Logout' );

        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{JavaScript} ne 'ARRAY';

            @FileList = ( @FileList, @{ $Setting->{$Module}->{JavaScript} || [] } );
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleJS',
            JSHome    => $JSHome,
        );

    }

    return;
}

sub _HandleCSSList {
    my ( $Self, %Param ) = @_;

    my @Skins = ('default');

    # validating selected custom skin, if any
    if ( $Param{Skin} && $Param{Skin} ne 'default' && $Self->SkinValidate(%Param) ) {
        push @Skins, $Param{Skin};
    }

    # load default css files
    for my $Skin (@Skins) {
        my @FileList;

        CSSFILE:
        for my $CSSFile ( @{ $Param{List} } ) {
            my $SkinFile = "$Param{SkinHome}/$Param{SkinType}/$Skin/css/$CSSFile";

            next CSSFILE unless -e $SkinFile;

            if ( $Param{DoMinify} ) {
                push @FileList, $SkinFile;
            }
            else {
                $Self->Block(
                    Name => $Param{BlockName},
                    Data => {
                        Skin         => $Skin,
                        CSSDirectory => 'css',
                        Filename     => $CSSFile,
                    },
                );
            }
        }

        if ( $Param{DoMinify} && @FileList ) {
            my $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'CSS',
                TargetDirectory      => "$Param{SkinHome}/$Param{SkinType}/$Skin/css-cache/",
                TargetFilenamePrefix => $Param{BlockName},
            );

            $Self->Block(
                Name => $Param{BlockName},
                Data => {
                    Skin         => $Skin,
                    CSSDirectory => 'css-cache',
                    Filename     => $MinifiedFile,
                },
            );
        }
    }

    return 1;
}

sub _HandleJSList {
    my ( $Self, %Param ) = @_;

    return unless $Param{List};

    my %UsedFiles;
    my @FilesToBeMinified;
    JSFILE:
    for my $JSFile ( @{ $Param{List} // [] } ) {

        # skip duplicates
        next JSFILE if $UsedFiles{$JSFile};

        if ( $Param{DoMinify} ) {
            push @FilesToBeMinified, "$Param{JSHome}/$JSFile";
        }
        else {
            $Self->Block(
                Name => $Param{BlockName},
                Data => {
                    JSDirectory => '',
                    Filename    => $JSFile,
                },
            );
        }

        # Save it for checking duplicates.
        $UsedFiles{$JSFile} = 1;
    }

    return 1 unless @FilesToBeMinified;

    # there are files to minify, let's do it
    my $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
        List                 => \@FilesToBeMinified,
        Type                 => 'JavaScript',
        TargetDirectory      => "$Param{JSHome}/js-cache/",
        TargetFilenamePrefix => $Param{FilenamePrefix} // $Param{BlockName},
    );

    $Self->Block(
        Name => $Param{BlockName},
        Data => {
            JSDirectory => 'js-cache/',
            Filename    => $MinifiedFile,
        },
    );

    return 1;
}

=head2 SkinValidate()

Returns 1 if skin is available for Agent or Customer frontends and 0 if not.

    my $SkinIsValid = $LayoutObject->SkinValidate(
        UserType => 'Agent'     #  Agent or Customer,
        Skin => 'ExampleSkin',
    );

=cut

sub SkinValidate {
    my ( $Self, %Param ) = @_;

    for my $Needed ( 'SkinType', 'Skin' ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed param: $Needed!",
                Priority => 'error',
            );

            return;
        }
    }

    if ( exists $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} } ) {
        return $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} };
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SkinType      = $Param{SkinType};
    my $PossibleSkins = $ConfigObject->Get("Loader::${SkinType}::Skin") || {};
    my $Home          = $ConfigObject->Get('Home');

    # prepare the list of active skins
    for my $PossibleSkin ( values %{$PossibleSkins} ) {
        if ( $PossibleSkin->{InternalName} eq $Param{Skin} ) {
            my $SkinDir = $Home . "/var/httpd/htdocs/skins/$SkinType/" . $PossibleSkin->{InternalName};
            if ( -d $SkinDir ) {
                $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} } = 1;

                return 1;
            }
        }
    }

    $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} } = undef;

    return;
}

1;
