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

package Kernel::Modules::AdminOAuthTokenStore;

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

    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $LanguageObject     = $Kernel::OM->Get('Kernel::Language');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TokenRepository    = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');
    my $TokenProvider      = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenProvider');
    my $FunctionalAccounts = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccounts');
    my $Configuration      = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Errors = ();

    my $Profiles = $Configuration->GetOAuthProfiles();

    my $HasProfiles = scalar @$Profiles;

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # ------------------------------------------------------------ #
    # AddInvoker
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'AddInvoker' ) {

        my %GetParam = ();

        $GetParam{AccountName}   = $ParamObject->GetParam( Param => 'AccountName' );
        $GetParam{GrantType}     = 'client_credentials';
        $GetParam{InvokerScopes} = 'openid offline_access';
        $GetParam{TokenType}     = 'access_token';

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_EditInvoker(
            Action => 'AddInvoker',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminOAuthTokenStore',
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
        $GetParam{AccountName} = $ParamObject->GetParam( Param => 'AccountName' );

        my $Account = $FunctionalAccounts->GetAccount( Name => $GetParam{AccountName} );

        $GetParam{ProviderID} = $Account->{OIDCProfileID};

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $GetParam{GrantType} = $Account->{GrantType};

        if ( $GetParam{GrantType} eq 'password' ) {

            $GetParam{Username} = $Account->{Username};
            $GetParam{Password} = $Account->{Password};
        }

        $GetParam{InvokerScopes} = $Account->{Scope};
        $GetParam{Resources}     = $Account->{Resources};
        $GetParam{ResourceParam} = $Account->{ResourceParamName};
        $GetParam{TokenType}     = $Account->{TokenType};

        $Self->_EditInvoker(
            Action => 'EditInvoker',
            %GetParam,
        );

        $LayoutObject->Block(
            Name => 'ActionDelete',
            Data => \%GetParam
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminOAuthTokenStore',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # AddInvokerAction and EditInvokerAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddInvokerAction' || $Self->{Subaction} eq 'EditInvokerAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # fetch and validate parameters
        my %GetParam = ();

        $GetParam{AccountName} = $ParamObject->GetParam( Param => 'AccountName' );

        if ( !$GetParam{AccountName} ) {
            $Errors{AccountNameServerError} = $LanguageObject->Translate('Account Name is missing!');
        }

        $GetParam{ProviderID}    = $ParamObject->GetParam( Param => 'ProviderID' );
        $GetParam{GrantType}     = $ParamObject->GetParam( Param => 'GrantType' );
        $GetParam{Username}      = $ParamObject->GetParam( Param => 'Username' );
        $GetParam{Password}      = $ParamObject->GetParam( Param => 'Password' );
        $GetParam{TokenType}     = $ParamObject->GetParam( Param => 'TokenType' );
        $GetParam{InvokerScopes} = $ParamObject->GetParam( Param => 'InvokerScopes' );
        $GetParam{Resources}     = $ParamObject->GetParam( Param => 'Resources' );
        $GetParam{ResourceParam} = $ParamObject->GetParam( Param => 'ResourceParam' );

        if ( $GetParam{GrantType} eq 'password' ) {
            if ( !$GetParam{Username} && $GetParam{EnableInvoker} ) {
                $Errors{UsernameServerError} = $LanguageObject->Translate('Username is required!');
            }
            if ( !$GetParam{Password} && $GetParam{EnableInvoker} ) {
                $Errors{PasswordServerError} = $LanguageObject->Translate('Password is required!');
            }
        }

        # prevent duplicate account names
        if ( $Self->{Subaction} eq 'AddInvokerAction' ) {

            my $ExistingAccount = $FunctionalAccounts->GetAccount( Name => $GetParam{AccountName} );

            if ($ExistingAccount) {
                $Errors{AccountNameServerError} = $LanguageObject->Translate('Account Name is taken!');
            }
        }

        # return if we have form validate errors
        if ( scalar keys %Errors ) {

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            $Self->_EditInvoker(
                Action => $Self->{Subaction} eq 'AddInvokerAction' ? 'AddInvoker' : 'EditInvoker',
                %GetParam,
                %Errors,
            );

            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminOAuthTokenStore',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        # do save config

        # clean cache and database
        $TokenRepository->DeleteToken(
            AccountName => $GetParam{AccountName},
        );

        $TokenProvider->EmptyCache(
            AccountName => $GetParam{AccountName}
        );

        # actually persist the data in DB
        my $Success = $FunctionalAccounts->SaveAccount(
            Name              => $GetParam{AccountName},
            UserID            => $Self->{UserID},
            OIDCProfileID     => $GetParam{ProviderID},
            Scope             => $GetParam{InvokerScopes},
            ResourceParamName => $GetParam{ResourceParam},
            %GetParam,
        );

        if ( !$Success ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Error creating/updating OAuth2 Account " . $GetParam{AccountName},
            );

            $Output .= $LayoutObject->Notify(
                Info     => $LanguageObject->Translate( "Error creating/updating %s!", $GetParam{AccountName} ),
                Priority => 'Error'
            );
        }

        # post save actions - attempt to refresh token
        if ( $GetParam{GrantType} eq 'authorization_code' ) {

            # for authorization_code redirect the browser
            my $AuthURL = $TokenProvider->GetAuthURL(
                %GetParam,
                AccountName => $GetParam{AccountName},
                Prompt      => 1,
                Subaction   => $Self->{Subaction},
                RedirectURI => $ConfigObject->Get('HttpType')
                    . '://'
                    . $ConfigObject->Get('FQDN')
                    . '/'
                    . $ConfigObject->Get('ScriptAlias')
                    . 'index.pl?Action=AdminOAuthTokenStore&Subaction=OAuth'
            );

            if ($AuthURL) {

                return $LayoutObject->Redirect(
                    ExtURL => $AuthURL
                );
            }
            else {
                # oh boy, we cannot event generate a valid redirect url. invalid usser config!

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "Unable to generate OIDC Provider Authentication URL for Login. Invalid OICD Configuration!",
                );

                $Output .= $LayoutObject->Notify(
                    Info     => $LanguageObject->Translate('Unable to generate OIDC Provider Authentication URL for Login. Invalid OICD Configuration!'),
                    Priority => 'Error'
                );

                $Self->_EditInvoker(
                    Action => 'EditInvoker',
                    %GetParam,
                    TokenError => $LanguageObject->Translate('Unable to generate OIDC Provider Authentication URL for Login. Invalid OICD COnfiguration!'),
                );

                $LayoutObject->Block(
                    Name => 'ActionDelete',
                    Data => \%GetParam
                );

                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminOAuthTokenStore',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # post save action if grant_type is not 'authorization_code'
        else {

            # just fetch the token
            my $TokenResult = $TokenProvider->Fetch( AccountName => $GetParam{AccountName} );

            # oh girl, fetch token failed, invalid user config!
            if ( !$TokenResult->{Success} ) {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => $TokenResult->{Error},
                );

                my $Notification = $LayoutObject->Notify(
                    Info     => $TokenResult->{Error},
                    Priority => 'Error'
                );

                $Output .= $Notification;

                $LayoutObject->Block(
                    Name => 'ActionDelete',
                    Data => \%GetParam
                );

                $Self->_EditInvoker(
                    Action => 'EditInvoker',
                    %GetParam,
                    TokenError => $TokenResult->{Error},
                );

                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminOAuthTokenStore',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();

                return $Output;
            }
        }
    }

    # ------------------------------------------------------------ #
    # Delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $AccountName = $ParamObject->GetParam( Param => 'AccountName' ) || '';

        my $Success = $FunctionalAccounts->DeleteAccount(
            Name   => $AccountName,
            UserID => $Self->{UserID},
        );

        if ($Success) {
            $Output .= $LayoutObject->Notify(
                Info     => $LanguageObject->Translate( "Account %s deleted!", $AccountName ),
                Priority => 'Success'
            );
        }
        else {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Failed to delete OAuth2 Account " . $AccountName,
            );
        }
    }

    # ------------------------------------------------------------ #
    # Refresh
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Refresh' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $AccountName = $ParamObject->GetParam( Param => 'AccountName' ) || '';

        my $Account = $FunctionalAccounts->GetAccount( Name => $AccountName );

        if ( IsHashRefWithData($Account) )
        {
            my $GrantType = $Account->{GrantType};

            # clean cache and database
            $TokenRepository->DeleteToken(
                AccountName => $AccountName,
            );

            $TokenProvider->EmptyCache(
                AccountName => $AccountName,
            );

            # authorization_code uses browser based flow
            # redirect the browser to the identity provider
            # login page
            if ( $GrantType eq 'authorization_code' ) {

                my $AuthURL = $TokenProvider->GetAuthURL(
                    AccountName => $AccountName,
                    Prompt      => 1,
                    Subaction   => 'Refresh',
                    RedirectURI => $ConfigObject->Get('HttpType')
                        . '://'
                        . $ConfigObject->Get('FQDN')
                        . '/'
                        . $ConfigObject->Get('ScriptAlias')
                        . 'index.pl?Action=AdminOAuthTokenStore&Subaction=OAuth'
                );

                return $LayoutObject->Redirect(
                    ExtURL => $AuthURL
                );
            }

            # for client_credentials and password flows,
            # we can just fetch an new token right now
            else {

                my $TokenResult = $TokenProvider->Fetch( AccountName => $AccountName );

                if ( $TokenResult->{Success} ) {

                    $Output .= $LayoutObject->Notify(
                        Info     => $LanguageObject->Translate( "Token %s updated!", $AccountName ),
                        Priority => 'Success'
                    );
                }
                else {

                    $TokenRepository->DeleteToken(
                        AccountName => $AccountName,
                    );

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'debug',
                        Message  => "Failed to refresh OAuth2 Token for Account " . $AccountName,
                    );

                    $Output .= $LayoutObject->Notify(
                        Info     => $TokenResult->{Error},
                        Priority => 'Error'
                    );
                }
            }
        }
    }

    # ------------------------------------------------------------ #
    # oauth action - callback when using authorization_code
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'OAuth' ) {

        my $State  = $ParamObject->GetParam( Param => 'state' );
        my $Code   = $ParamObject->GetParam( Param => 'code' );
        my $Issuer = $ParamObject->GetParam( Param => 'iss' );

        my $CachedState = $CacheObject->Get(
            Type => 'TokenProvider',
            Key  => "TokenProvider::OAuth2State::$State",
        );

        if ( !$CachedState ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Invalid OAuth State $State from $Issuer",
            );

            return join '',
                $LayoutObject->Header( Title => 'Error' ),
                $LayoutObject->Warning(
                    Message => $LanguageObject->Translate('Invalid OAuth State!')
                ),
                $LayoutObject->Footer();
        }

        my $AccountName = $CachedState->{AccountName};
        my $RedirectURL = $CachedState->{RedirectURL};
        my $Subaction   = $CachedState->{Subaction};

        my $Account = $FunctionalAccounts->GetAccount( Name => $AccountName );

        if ( !IsHashRefWithData($Account) )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Invalid Account for Token: " . $AccountName,
            );

            return join '',
                $LayoutObject->Header( Title => 'Error' ),
                $LayoutObject->Warning(
                    Message => $LanguageObject->Translate( "Invalid Account %s for Token!", $AccountName )
                ),
                $LayoutObject->Footer();
        }

        # validate the issuer
        if ($Issuer) {
            my $ProviderIssuer = $FunctionalAccounts->GetIssuer(
                Name => $AccountName,
            );

            if ( $Issuer ne $ProviderIssuer ) {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "Invalid Issuer $Issuer for Account $AccountName",
                );

                return join '',
                    $LayoutObject->Header( Title => 'Error' ),
                    $LayoutObject->Warning(
                        Message => $LanguageObject->Translate( "Invalid Issuer %s for Token %s!", $Issuer, $AccountName )
                    ),
                    $LayoutObject->Footer();
            }
        }

        my $TokenResult = $TokenProvider->FetchToken(
            AccountName => $AccountName,
            Code        => $Code,
            RedirectURL => $RedirectURL,
        );

        if ( $TokenResult->{Success} ) {

            $Output .= $LayoutObject->Notify(
                Info     => $LanguageObject->Translate( "Token %s updated!", $AccountName ),
                Priority => 'Success'
            );

        }
        else {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Error fetching initial Token for $AccountName!"
            );

            $Output .= $LayoutObject->Notify(
                Info     => $LanguageObject->Translate("Error fetching initial Token for $AccountName!"),
                Priority => 'Error'
            );

            $LayoutObject->Block(
                Name => 'ActionDelete',
                Data => \%$CachedState,
            );

            $Self->_EditInvoker(
                %$CachedState,
                TokenError => $TokenResult->{Error},
                Action     => 'EditInvoker',
            );

            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminOAuthTokenStore',
                Data         => \%$CachedState,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # show overview actions - assemble Account Overview data
    # ------------------------------------------------------------ #

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            HasProfiles => $HasProfiles,
            %Param,
        }
    );

    if ($HasProfiles) {

        $LayoutObject->Block( Name => 'ActionAddInvoker' );
    }

    # Get List of refreshable Tokens from DB
    my $GenericInterfaceTokens = $TokenRepository->GetList( TokenType => 'all' );

    # Build a lookup index as we map Tokens to their
    # configured Functional Accounts
    my %GenericInterfaceTokenLookup = ();

    for my $GenericInterfaceToken (@$GenericInterfaceTokens) {

        if ( !exists $GenericInterfaceTokenLookup{ $GenericInterfaceToken->{AccountID} } )
        {
            $GenericInterfaceTokenLookup{ $GenericInterfaceToken->{AccountID} } = {};
        }

        $GenericInterfaceTokenLookup{ $GenericInterfaceToken->{AccountID} }->{ $GenericInterfaceToken->{TokenType} } = $GenericInterfaceToken;
    }

    # Prepare view data
    my @AccountsForDisplay;

    # Get OAuth Invoker accounts from Config
    my $InvokerAccounts = $FunctionalAccounts->GetAccounts();

    OAUTHACCOUNT:
    for my $Account (@$InvokerAccounts) {

        my $AccountName = $Account->{Name};
        my $AccountID   = $Account->{AccountID};

        my $GrantType = $Account->{GrantType};
        my $HasToken  = exists $GenericInterfaceTokenLookup{$AccountID};

        my $Token = $GenericInterfaceTokenLookup{$AccountID}->{refresh_token};
        my $Time  = "";

        if ( $Token && $Token->{ExpiresAt} ) {

            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Epoch => $Token->{ExpiresAt},
                }
            );

            my $Success = $DateTimeObject->ToTimeZone(
                TimeZone => $Self->{UserTimeZone}
            );

            $Time = $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S' );
        }

        $HasToken = $HasToken ? 'Yes' : 'No';

        my $AccountData = {
            AccountName => $AccountName,
            ProfileName => $Account->{OIDCProfile}->{ProviderSettings}->{Name},
            Flow        => $GrantType,
            TokenID     => $Token->{TokenID},
            Token       => $Token->{Token},
            HasToken    => $HasToken,
            NeedToken   => $GrantType eq 'authorization_code' && !$HasToken ? 'Error' : '',
            ExpiresAt   => $Time,
            IsInvoker   => 1,
        };

        push @AccountsForDisplay, $AccountData;
    }

    my $ListSize = keys @AccountsForDisplay;

    $LayoutObject->Block(
        Name => 'OverviewHeader',
        Data => {
            AllItemsCount => $ListSize,
            HasProfiles   => $HasProfiles,
            %Errors,
        },
    );

    # if there is data available, it is shown
    if ($ListSize) {

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        for my $Account (@AccountsForDisplay) {

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => $Account,
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
        TemplateFile => 'AdminOAuthTokenStore',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _EditInvoker {
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

    $Param{ProviderNames} = $LayoutObject->BuildSelection(
        Data       => \%Profiles,
        Name       => 'ProviderID',
        Class      => 'Modernize',
        SelectedID => $Param{ProviderID},
    );

    $Param{GrantTypes} = $LayoutObject->BuildSelection(
        Data       => [ 'client_credentials', 'password', 'authorization_code' ],
        Name       => 'GrantType',
        Class      => 'Modernize',
        SelectedID => $Param{GrantType} || 'client_credentials',
    );

    $Param{TokenType}     = $Param{TokenType}     || 'access_token';
    $Param{ResourceParam} = $Param{ResourceParam} || 'resource';

    $LayoutObject->Block(
        Name => 'OverviewUpdateInvoker',
        Data => \%Param,
    );

    return 1;
}

1;
