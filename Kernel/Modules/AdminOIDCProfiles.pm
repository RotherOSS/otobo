# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Modules::AdminOIDCProfiles;

use strict;
use warnings;

use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $LanguageObject    = $Kernel::OM->Get('Kernel::Language');
    my $LogObject         = $Kernel::OM->Get('Kernel::System::Log');
    my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ProfileRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::ProfileRepository');
    my $Configuration     = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Errors = ();

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # ------------------------------------------------------------ #
    # AddProfile
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'AddProfile' ) {

        my %GetParam = $Self->_GetDefaults()->%*;

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_EditProfile(
            Action => 'AddProfile',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminOIDCProfiles',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # Edit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Edit' ) {

        my %GetParam = ();

        $GetParam{ProfileName} = $ParamObject->GetParam( Param => 'ProfileName' );
        my $Profile = $ProfileRepository->GetProfile( Name => $GetParam{ProfileName} );

        $GetParam{ValidID}             = $Profile->{Valid};
        $GetParam{ClientID}            = $Profile->{ClientSettings}->{ClientID};
        $GetParam{ClientSecret}        = $Profile->{ClientSettings}->{ClientSecret};
        $GetParam{RedirectURI}         = $Profile->{ClientSettings}->{RedirectURI};
        $GetParam{ProviderMetadataUrl} = $Profile->{ProviderSettings}->{OpenIDConfiguration};
        $GetParam{CacheTTL}            = $Profile->{ProviderSettings}->{TTL};
        $GetParam{SSLCertificate}      = $Profile->{ProviderSettings}->{SSLOptions}->{SSLCertificate};
        $GetParam{SSLKey}              = $Profile->{ProviderSettings}->{SSLOptions}->{SSLKey};
        $GetParam{SSLPassword}         = $Profile->{ProviderSettings}->{SSLOptions}->{SSLPassword};
        $GetParam{SSLCAFile}           = $Profile->{ProviderSettings}->{SSLOptions}->{SSLCAFile};
        $GetParam{SSLCADir}            = $Profile->{ProviderSettings}->{SSLOptions}->{SSLCADir};
        $GetParam{SSLVerifyHostname}   = $Profile->{ProviderSettings}->{SSLOptions}->{SSLVerifyHostname};
        $GetParam{SSLVerifyMode}       = $Profile->{ProviderSettings}->{SSLOptions}->{SSLVerifyMode};
        $GetParam{UseNonce}            = $Profile->{Misc}->{UseNonce};
        $GetParam{RandLength}          = $Profile->{Misc}->{RandLength};
        $GetParam{RandTTL}             = $Profile->{Misc}->{RandTTL};
        $GetParam{Leeway}              = $Profile->{Misc}->{Leeway};

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Self->_EditProfile(
            Action => 'EditProfile',
            %GetParam,
        );

        $LayoutObject->Block(
            Name => 'ActionDelete',
            Data => \%GetParam
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminOIDCProfiles',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # AddProfileAction and EditProfileAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddProfileAction' || $Self->{Subaction} eq 'EditProfileAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # fetch and validate parameters
        my %GetParam = ();

        $GetParam{ProfileName} = $ParamObject->GetParam( Param => 'ProfileName' );
        if ( !$GetParam{ProfileName} ) {
            $Errors{ProfileNameServerError} = $LanguageObject->Translate('Profile Name is missing!');
        }

        $GetParam{ProviderMetadataUrl} = $ParamObject->GetParam( Param => 'ProviderMetadataUrl' );
        if ( !$GetParam{ProviderMetadataUrl} ) {
            $Errors{ProviderMetadataUrlServerError} = $LanguageObject->Translate('Provider metadata url is missing!');
        }

        $GetParam{ClientID} = $ParamObject->GetParam( Param => 'ClientID' );
        if ( !$GetParam{ClientID} ) {
            $Errors{ClientIDServerError} = $LanguageObject->Translate('Provider client id is missing!');
        }

        $GetParam{ClientSecret} = $ParamObject->GetParam( Param => 'ClientSecret' );
        if ( !$GetParam{ClientSecret} ) {
            $Errors{ClientSecretServerError} = $LanguageObject->Translate('Provider client secret is missing!');
        }

        # the remaining ones have reasonable defaults, no validation
        $GetParam{CacheTTL}          = $ParamObject->GetParam( Param => 'CacheTTL' ) || 60 * 30;
        $GetParam{SSLCertificate}    = $ParamObject->GetParam( Param => 'SSLCertificate' );
        $GetParam{SSLKey}            = $ParamObject->GetParam( Param => 'SSLKey' );
        $GetParam{SSLPassword}       = $ParamObject->GetParam( Param => 'SSLPassword' );
        $GetParam{SSLCAFile}         = $ParamObject->GetParam( Param => 'SSLCAFile' );
        $GetParam{SSLCADir}          = $ParamObject->GetParam( Param => 'SSLCADir' );
        $GetParam{SSLVerifyHostname} = $ParamObject->GetParam( Param => 'SSLVerifyHostname' );
        $GetParam{SSLVerifyMode}     = $ParamObject->GetParam( Param => 'SSLVerifyMode' );
        $GetParam{UseNonce}          = $ParamObject->GetParam( Param => 'UseNonce' );
        $GetParam{RandLength}        = $ParamObject->GetParam( Param => 'RandLength' ) || 22;
        $GetParam{RandTTL}           = $ParamObject->GetParam( Param => 'RandTTL' )    || 60 * 5;
        $GetParam{Leeway}            = $ParamObject->GetParam( Param => 'Leeway' )     || 2;

        # prevent duplicate account names
        if ( $Self->{Subaction} eq 'AddProfileAction' ) {

            my $Existing = $ProfileRepository->Exists( Name => $GetParam{ProfileName} );

            if ($Existing) {
                $Errors{ProfileNameServerError} = $LanguageObject->Translate('Profile Name is taken!');
            }
        }

        # return if we have form validate errors
        if ( scalar keys %Errors ) {

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            $Self->_EditProfile(
                Action => $Self->{Subaction} eq 'AddProfileAction' ? 'AddProfile' : 'EditProfile',
                %GetParam,
                %Errors,
            );

            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminOIDCProfiles',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        # do save config

        my $Profile = {

            Name           => $GetParam{ProfileName},
            ClientSettings => {
                ClientSecret => $GetParam{ClientSecret},
                ClientID     => $GetParam{ClientID},
                RedirectURI  => $GetParam{RedirectURI},
            },
            ProviderSettings => {
                OpenIDConfiguration => $GetParam{ProviderMetadataUrl},
                TTL                 => $GetParam{CacheTTL},
                SSLOptions          => {
                    SSLCertificate    => $GetParam{SSLCertificate},
                    SSLKey            => $GetParam{SSLKey},
                    SSLPassword       => $GetParam{SSLPassword},
                    SSLCAFile         => $GetParam{SSLCAFile},
                    SSLCADir          => $GetParam{SSLCADir},
                    SSLVerifyHostname => $GetParam{SSLVerifyHostname},
                    SSLVerifyMode     => $GetParam{SSLVerifyMode},
                }
            },
            Misc => {
                UseNonce   => $GetParam{UseNonce},
                RandLength => $GetParam{RandLength},
                RandTTL    => $GetParam{RandTTL},
                Leeway     => $GetParam{Leeway},
            },
            UserID => $Self->{UserID},
            Valid  => $GetParam{ValidID} // 1,
        };

        my $Success;
        if ( $Self->{Subaction} eq 'AddProfileAction' ) {

            $Success = $ProfileRepository->AddProfile(%$Profile);
        }
        else {

            $Success = $ProfileRepository->UpdateProfile(%$Profile);
        }

        if ( !$Success ) {
            $Output .= $LayoutObject->Notify(
                Info     => $LanguageObject->Translate( "Error creating/updating Profile %s!", $GetParam{ProfileName} ),
                Priority => 'Error'
            );
        }
    }

    # ------------------------------------------------------------ #
    # Delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ProfileName = $ParamObject->GetParam( Param => 'ProfileName' ) || '';

        my $Success = $ProfileRepository->DeleteProfile( Name => $ProfileName );

        if ($Success) {
            $Output .= $LayoutObject->Notify(
                Info     => $LanguageObject->Translate( "Profile %s deleted!", $ProfileName ),
                Priority => 'Success'
            );
        }
        else {
            $Output .= $LayoutObject->Notify(
                Info     => $LanguageObject->Translate( "Profile %s could not be deleted - do you have any Functional Accounts referencing this Profile?", $ProfileName ),
                Priority => 'Error',
                Link     => $ConfigObject->Get('HttpType')
                    . '://'
                    . $ConfigObject->Get('FQDN')
                    . '/'
                    . $ConfigObject->Get('ScriptAlias')
                    . 'index.pl?Action=AdminOAuthTokenStore',
            );
        }
    }

    # ------------------------------------------------------------ #
    # show overview actions - assemble Profile Overview data
    # ------------------------------------------------------------ #

    # Prepare view data

    my $Profiles = $Configuration->GetOAuthProfiles();

    my @ViewData;

    PROFILE:
    for my $Profile (@$Profiles) {

        my $ProfileName = $Profile->{ProviderSettings}->{Name};
        my $ClientID    = $Profile->{ClientSettings}->{ClientID};
        my $MetadataUrl = $Profile->{ProviderSettings}->{OpenIDConfiguration};
        my $Valid       = $Profile->{Valid} == 1 ? 'Valid' : 'Invalid';

        push @ViewData, {
            ProfileName => $ProfileName,
            ClientID    => $ClientID,
            MetadataUrl => $MetadataUrl,
            Valid       => $Valid,
        };
    }

    my $ListSize = scalar @ViewData;

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            AllItemsCount => $ListSize,
            %Param,
        },
    );

    $LayoutObject->Block( Name => 'ActionAddProfile' );

    $LayoutObject->Block(
        Name => 'OverviewHeader',
        Data => {
            AllItemsCount => $ListSize,
            %Errors,
        },
    );

    # if there is data available, it is shown
    if ($ListSize) {

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        for my $Data (@ViewData) {

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => $Data,
            );
        }
    }

    # otherwise, a message is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoAccountsDefined',
            Data => {},
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminOIDCProfiles',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _EditProfile {
    my ( $Self, %Param ) = @_;

    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $OIDCProfiles      = $OIDCConfiguration->GetOAuthProfiles();

    my %Profiles;
    for my $Profile (@$OIDCProfiles) {

        $Profiles{ $Profile->{ProfileID} } = $Profile->{ProviderSettings}->{Name};
    }

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        Class      => 'Modernize',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    $Param{SSLVerifyHostnameOption} = $LayoutObject->BuildSelection(
        Data => {
            1 => 'Verify Hostname',
            0 => 'Skip',
        },
        Name       => 'SSLVerifyHostname',
        Class      => 'Modernize',
        SelectedID => $Param{SSLVerifyHostname} // 1,
    );

    $Param{SSLVerifyModeOption} = $LayoutObject->BuildSelection(
        Data => {
            1 => 'Verify Certificates',
            0 => 'Skip',
        },
        Name       => 'SSLVerifyMode',
        Class      => 'Modernize',
        SelectedID => $Param{SSLVerifyMode} // 1,
    );

    $Param{UseNonceOption} = $LayoutObject->BuildSelection(
        Data => {
            1 => 'Use Nonce',
            0 => 'Do not use Nonce',
        },
        Name       => 'UseNonce',
        Class      => 'Modernize',
        SelectedID => $Param{UseNonce} // 1,
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdateProfile',
        Data => \%Param,
    );

    return 1;
}

sub _GetDefaults {

    my ( $Self, %Param ) = @_;

    my $Defaults = {
        ClientID     => '',
        ClientSecret => '',

        #        $GetParam{RedirectURI}         = $Profile->{ClientSettings}->{RedirectURI};
        ProviderMetadataUrl => '',
        CacheTTL            => 60 * 30,
        UseNonce            => 1,
        RandLength          => 22,
        RandTTL             => 300,
        Leeway              => 2,
        SSLVerifyHostname   => 1,
        SSLVerifyMode       => 1,
        SSLCertificate      => '',
        SSLKey              => '',
        SSLPassword         => '',
        SSLCAFile           => '',
        SSLCADir            => '',
    };

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $OpenIDConfig = $ConfigObject->Get('AuthModule::OpenIDConnect::Config');

    if ( !IsHashRefWithData($OpenIDConfig) ) {
        return $Defaults;
    }

    $Defaults = {
        ClientID => $OpenIDConfig->{ClientSettings}->{ClientID},

        # would be convinient, but we do not do it for security purposes
        # ClientSecret => $OpenIDConfig->{ClientSettings}->{ClientSecret},

        ProviderMetadataUrl => $OpenIDConfig->{ProviderSettings}->{OpenIDConfiguration},
        CacheTTL            => $OpenIDConfig->{ProviderSettings}->{TTL} || 60 * 30,
        UseNonce            => $OpenIDConfig->{Misc}->{UseNonce} // 1,
        RandLength          => $OpenIDConfig->{Misc}->{RandLength} || 22,
        RandTTL             => $OpenIDConfig->{Misc}->{RandTTL}    || 300,
        Leeway              => $OpenIDConfig->{Misc}->{Leeway}     || 2,
        SSLVerifyHostname   => $OpenIDConfig->{ProviderSettings}->{SSLOptions}->{SSLVerifyHostname} // 1,
        SSLVerifyMode       => $OpenIDConfig->{ProviderSettings}->{SSLOptions}->{SSLVerifyMode}     // 1,
        SSLCertificate      => $OpenIDConfig->{ProviderSettings}->{SSLOptions}->{SSLCertificate} || '',
        SSLKey              => $OpenIDConfig->{ProviderSettings}->{SSLOptions}->{SSLKey}         || '',
        SSLPassword         => $OpenIDConfig->{ProviderSettings}->{SSLOptions}->{SSLPassword}    || '',
        SSLCAFile           => $OpenIDConfig->{ProviderSettings}->{SSLOptions}->{SSLCAFile}      || '',
        SSLCADir            => $OpenIDConfig->{ProviderSettings}->{SSLOptions}->{SSLCADir}       || '',
        HasDefault          => 1,
    };

    return $Defaults;
}

1;
