# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::OpenIDConnect::TokenProvider;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::JSON',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::OpenIDConnect::Token',
    'Kernel::System::OpenIDConnect::OAuth2',
    'Kernel::System::OpenIDConnect::Configuration',
    'Kernel::System::OpenIDConnect::TokenRepository',
    'Kernel::System::OpenIDConnect::FunctionalAccounts',
);

=head1 NAME

Kernel::System::OpenIDConnect::TokenProvider - methods for OpenIDConnect::TokenProvider

=head1 SYNOPSIS

High level interface for Invoker and outgoing calls to fetch a valid access_token
(or id_token) to pass along.

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TokenProviderObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenProvider');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Fetch()

Main interface for client code. Just use fetch to get a valid token from cache, from DB, via refresh_token,
or from scratch if credentials are known (like for password and client_credential grants).

Accounts using ahtorization_code grant might get undef and then have to initiate a browser based flow redirecting
the clients browser to the result from GetAuthURL()

FOr now only Provider and Invoker  accounts are allowed.

    my $TokenResult = $TokenProviderObject->Fetch(
        AccountName  => '<SomeAccountName>',
    );

    where TokenResult:

    my $TokenResult = {
        Success => 0|1,
        Token   => <token value on success>,
        Error   => <Error msg on error>
    };
=cut

sub Fetch {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AccountName/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return {
                Success => 0,
                Error   => "Invalid Parameters",
            };
        }
    }

    my $AccountName = $Param{AccountName};

    my $LanguageObject           = $Kernel::OM->Get('Kernel::Language');
    my $FunctionalAccountsObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccounts');
    my $TokenObject              = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');
    my $Account                  = $FunctionalAccountsObject->GetAccount( Name => $AccountName );

    if ( !IsHashRefWithData($Account) ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invoker AccountName $AccountName not found!",
        );

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "AccountName %s not found!", $AccountName ),
        };
    }

    my $TokenType = $Param{TokenType} || $Account->{TokenType} || 'access_token';

    # 1) try fetch from Cache

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "Try fetch OAuth2 Token from Cache for Account $AccountName",
    );

    my $Token = $Self->_FetchTokenFromCache(
        AccountName => $AccountName,
        TokenType   => $TokenType,
    );

    if ($Token) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Found OAuth2 Token in Cache for Account $AccountName",
        );

        return {
            Success => 1,
            Token   => $Token,
            Origin  => 'cache',
        };
    }

    # 2) try fetch from DB

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "Try fetch OAuth2 Token from DB for Account $AccountName",
    );

    my $TokenRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');

    my $TokenData = $TokenRepository->GetToken(
        AccountName => $AccountName,
        TokenType   => $TokenType,
    );

    if ( $TokenData && $TokenData->{Token} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Found OAuth2 Token in DB for Account $AccountName",
        );

        return {
            Success => 1,
            Token   => $TokenData->{Token},
            Origin  => 'db',
        };
    }

    # 3) try refresh_token, if any

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "Try fetch OAuth2 Token via refresh_token for Account $AccountName",
    );

    my $RefreshToken = $TokenRepository->GetToken(
        AccountName => $AccountName,
        TokenType   => 'refresh_token',
    );

    if ( $RefreshToken && $RefreshToken->{Token} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Trading in refresh_token for Account $AccountName",
        );

        my $Result = $Self->FetchToken(
            AccountName  => $AccountName,
            TokenType    => $TokenType,
            RefreshToken => $RefreshToken->{Token},
        );

        if ( $Result->{Success} && $Result->{Token} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Got OAuth2 Token via refresh_token for Account $AccountName",
            );

            return {
                Success => 1,
                Token   => $Result->{Token},
                Origin  => 'refresh_token'
            };
        }
    }

    # 4) if grant_type is not 'authorization_code' try fetch fresh token
    # using configured credentials

    if ( $Account->{GrantType} eq 'authorization_code' ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No valid refresh_token for Account $AccountName using grant_tpye 'authorization code' !",
        );

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "No valid refresh_token for Account %s using grant_tpye 'authorization code' !", $AccountName ),
        };
    }

    return $Self->FetchToken(
        AccountName => $AccountName,
        TokenType   => $TokenType,
    );
}

=head2 sub FetchToken()

    Called internaly when password or client_credential grant are configured.
    Also called internaly when refreshing via refresh_token.

    Callled directly from client code when completing the authorization_code
    browser flow, passing the received Code parameter.

    my $TokenResult = $TokenProviderObject->FetchToken(
        AccountName  => '<SomeAccountName>',
    );

    or

    my $TokenResult = $TokenProviderObject->FetchToken(
        AccountName  => '<SomeAccountName>',
        RefreshToken => $Token,
    );

    or

    my $TokenResult = $TokenProviderObject->FetchToken(
        AccountName   => '<SomeAccountName>',
        Code        => '<authorization_code "code" query parameter value>',
        RedirectURL => $RedirectURL, # redirect url used when initiating the browser flow
    );


    where TokenResult:

    my $TokenResult = {
        Success => 0|1,
        Token   => <token value on success>,
        Error   => <Error msg on error>
    };

=cut

sub FetchToken {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AccountName/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return {
                Success => 0,
                Error   => "Invalid Parameters !",
            };
        }
    }

    my $LanguageObject           = $Kernel::OM->Get('Kernel::Language');
    my $TokenObject              = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');
    my $FunctionalAccountsObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccounts');

    # Fetch config data from account
    my $AccountName = $Param{AccountName};
    my $Account     = $FunctionalAccountsObject->GetAccount( Name => $AccountName );

    if ( !IsHashRefWithData($Account) ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need functional account Invoker settings in System Configuration for $AccountName.",
        );

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "Need functional account Invoker settings in System Configuration for %s.", $AccountName ),
        };
    }

    my $TokenType = $Account->{TokenType} || 'access_token';

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "Retrieve OAuth2 Token $TokenType for Account $AccountName",
    );

    my $OpenIDConfig = $Account->{OIDCProfile};

    # fetch the token
    my $Result = $Self->FetchTokenFromConfig(
        TokenType         => $TokenType,
        OpenIDConfig      => $OpenIDConfig,
        ResourceParamName => $Account->{ResourceParamName} || 'resource',
        Resources         => $Account->{Resources},
        Scope             => $Account->{Scope},
        GrantType         => $Account->{GrantType},
        Username          => $Account->{Username},
        Password          => $Account->{Password},
        RefreshToken      => $Param{RefreshToken},
        Code              => $Param{Code},
        RedirectURL       => $Param{RedirectURL},
    );

    if ( !$Result->{Success} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Failed to tetrieve OAuth2 Token from Provider for Account $AccountName",
        );

        return $Result;
    }

    my $DecodedContent = $Result->{DecodedContent};

    my $Token = $DecodedContent->{$TokenType};
    if ( !$Token ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Did not receive the desired TokenType '$TokenType' in provider response!",
        );

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "Did not receive the desired TokenType '%s' in OIDC provider response for Invoker %s!", $TokenType, $AccountName ),
        };
    }

    # check time left
    my $TimeLeft = $TokenObject->TimeLeft(
        Token => $Token,
    );

    if ( !$TimeLeft || $TimeLeft < 1 ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Time left on fresh token is: $TimeLeft s!",
        );

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "Time left on fresh token is: %s s for Invoker %s!", $TimeLeft, $AccountName ),
        };
    }

    # process and persist the Tokens
    if ( $DecodedContent->{id_token} ) {

        my $Result = $Self->_ProcessNewToken(
            OpenIDConfig => $OpenIDConfig,
            AccountName  => $AccountName,
            Account      => $Account,
            TokenType    => 'id_token',
            Token        => $DecodedContent->{id_token},
        );

        return {
            Success => 0,
            Error   => "Invalid Parameters !",
        } if !$Result;
    }

    if ( $DecodedContent->{access_token} ) {

        $Self->_ProcessNewToken(
            OpenIDConfig => $OpenIDConfig,
            AccountName  => $AccountName,
            Account      => $Account,
            TokenType    => 'access_token',
            Token        => $DecodedContent->{access_token},
        );
    }

    if ( $DecodedContent->{refresh_token} ) {

        $Self->_ProcessNewToken(
            OpenIDConfig => $OpenIDConfig,
            AccountName  => $AccountName,
            Account      => $Account,
            TokenType    => 'refresh_token',
            Token        => $DecodedContent->{refresh_token},
        );
    }

    return {
        Success => 1,
        Token   => $Token,
        Origin  => 'fresh_token',
    };
}

=head2 sub FetchTokenFromConfig()

Low level FetchToken helper

This fetches token only based on OpenIDConfig + Parameters,
no dependency on Functional Accounts.

Used internally by FetchToken() above, but also from
Kernel::System::Console::Command::Admin::OAuth2::ImportUser.pm

returns the JSON response decoded as a Perl data structure,
any further validation is supposed to happen by the caller.


    my $Result = $TokenProviderObject->FetchTokenFromConfig(

        OpenIDConfig      => $OpenIDConfig, # from SysSetting
        GrantType         => 'client_credential' | 'authorization_code' | 'password' | 'refresh_token'
        TokenType         => 'access_token' | 'id_token',
        ResourceParamName => 'resource',                 # defaults
        Resources         => '<space separated list>',
        Scope             => '<space separated list>',
        Username          => '',
        Password          => '',
        RefreshToken      => $RefreshToken, # optional
        Code              => '<the code from oauth callback>',
        RedirectURL       => 'the redirect url used with autorization endpoint',
    );

    with:

    my $Result = {
        Success => 1,
        DecodedContent => {} # JSON result from token request, decoded to Perl
    };

=cut

sub FetchTokenFromConfig {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/OpenIDConfig GrantType/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return {
                Success => 0,
                Error   => "Invalid Parameters !",
            };
        }
    }

    my $LanguageObject    = $Kernel::OM->Get('Kernel::Language');
    my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');

    my $ResourceParamName = $Param{ResourceParamName} || 'resource';
    my $OpenIDConfig      = $Param{OpenIDConfig};

    my $TokenEndpoint = $OIDCConfiguration->GetTokenEndpoint(
        OpenIDConfig => $OpenIDConfig,
    );
    if ( !$TokenEndpoint ) {

        return {
            Success => 0,
            Error   => $LanguageObject->Translate("Could not get the OAuth2 token_endpoint for Invoker "),
        };
    }

    my $OAuth2Object = $Kernel::OM->Get('Kernel::System::OpenIDConnect::OAuth2');

    return $OAuth2Object->RequestToken(
        TokenEndpoint     => $TokenEndpoint,
        ClientID          => $OpenIDConfig->{ClientSettings}{ClientID},
        ClientSecret      => $OpenIDConfig->{ClientSettings}{ClientSecret},
        Scope             => $Param{Scope},
        Resources         => $Param{Resources},
        ResourceParamName => $ResourceParamName,
        GrantType         => $Param{GrantType},
        Username          => $Param{Username},
        Password          => $Param{Password},
        RefreshToken      => $Param{RefreshToken},
        Code              => $Param{Code},
        RedirectURL       => $Param{RedirectURL},
        SSLOptions        => $OpenIDConfig->{ProviderSettings}{SSLOptions},
    );
}

=head2 GetAuthURL()

Build the URL to request an authorization code.

Example:
    my $AuthURL = $TokenProviderObject->GetAuthURL(
        AccountName => '<FunctionalAccountName>',
        RedirectURI => 'https://your.otobo.url/otobo/index.pl?Action=AdminOAuthTokenStore&Subaction=OAuth',
        Nonce => $Nonce, # optional
        State => $State, # optional, uses this state instead of random string (for testing)
    );

Returns:
    $AuthURL = https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=077d2059-219...

=cut

sub GetAuthURL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AccountName/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $AccountName = $Param{AccountName};

    my $FunctionalAccountsObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccounts');
    my $Account                  = $FunctionalAccountsObject->GetAccount( Name => $AccountName );

    if ( !IsHashRefWithData($Account) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need functional account Invoker settings in System Configuration.',
        );

        return;
    }

    my $ResourceParamName = $Account->{ResourceParamName} || 'resource';
    my $OpenIDConfig      = $Account->{OIDCProfile};
    my $UseNonce          = $Param{Nonce} // $OpenIDConfig->{Misc}->{UseNonce};

    my $AuthEndpoint = $FunctionalAccountsObject->GetAuthorizationEndpoint(
        Name => $AccountName,
    );

    my $OAuth2Object = $Kernel::OM->Get('Kernel::System::OpenIDConnect::OAuth2');

    return $OAuth2Object->GetAuthURL(
        %Param,
        AuthorizationEndpoint => $AuthEndpoint,
        ClientID              => $OpenIDConfig->{ClientSettings}{ClientID},
        ResponseType          => 'code',
        Scope                 => $Account->{Scope},
        Resources             => $Account->{Resources},
        ResourceParamName     => $ResourceParamName,
        Login                 => $Param{Login},
        Prompt                => $Param{Prompt},
        Nonce                 => $UseNonce,
        RandLength            => $OpenIDConfig->{Misc}->{RandLength},
        RandTTL               => $OpenIDConfig->{Misc}->{RandTTL},
        RedirectURL           => $Param{RedirectURI},
        State                 => $Param{State},
    );
}

=head2 EmptyCache()

Empty cached tokens and provider data in case of re-configuration

Example:
    $TokenProviderObject->EmptyCache(
        AccountName   => '<FunctionalAccountName>',
    );


=cut

sub EmptyCache {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AccountName/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $AccountName = $Param{AccountName};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    for my $TokenType (qw/access_token id_token refresh_token/) {

        my $CacheType = "TokenProvider";
        my $CacheKey  = join( ',', 'Invoker', $AccountName, $TokenType );

        my $Token = $CacheObject->Delete(
            Type => $CacheType,
            Key  => $CacheKey,
        );
    }

    # clear provider data cache as well
    my $FunctionalAccounts = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccounts');
    $FunctionalAccounts->ClearCache(
        Name => $AccountName,
    );

    return;
}

# helpers

sub _FetchTokenFromCache {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AccountName TokenType/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $AccountName = $Param{AccountName};
    my $TokenType   = $Param{TokenType};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = "TokenProvider";
    my $CacheKey  = join( ',', 'Invoker', $AccountName, $TokenType );

    my $Token = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    if ( !$Token ) {
        return;
    }

    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');
    if ( $TokenObject->IsTokenStillValid( Token => $Token ) ) {

        return $Token;
    }

    $CacheObject->Delete(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return;
}

sub _PopulateCache {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AccountName TokenType Token/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $AccountName = $Param{AccountName};
    my $TokenType   = $Param{TokenType};
    my $Token       = $Param{Token};
    my $ExpiresAt   = $Param{ExpiresAt} || 600;    # 10 mins

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

    my $CacheType = "TokenProvider";
    my $CacheKey  = join( ',', 'Invoker', $AccountName, $TokenType );

    # check time left
    my $TimeLeft = $TokenObject->TimeLeft(
        Token => $Token,
    );

    if ( !$TimeLeft || $TimeLeft < 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Time left on fresh token is: $TimeLeft s!",
        );
        return;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => $Token,
        TTL   => $TimeLeft,
    );

    return $Token;
}

sub _ProcessNewToken {

    my ( $Self, %Param ) = @_;

    my $Account      = $Param{Account};
    my $AccountName  = $Param{AccountName};
    my $OpenIDConfig = $Param{OpenIDConfig};
    my $TokenType    = $Param{TokenType};
    my $Token        = $Param{Token};

    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

    my $TokenData;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "Process new OAuth2 Token $TokenType for Account $AccountName",
    );

    if ( $TokenType eq 'refresh_token' ) {

        # skip
    }
    elsif ( $TokenType eq 'access_token' ) {

        $TokenData = $TokenObject->Inspect(
            Token  => $Token,
            Leeway => $Account->{Misc}->{Leeway},
        );
    }
    else {

        my $Result = $TokenObject->Validate(
            Token            => $Token,
            OpenIDConfig     => $OpenIDConfig,
            ExpectedAudience => $TokenType eq 'id_token' ? $OpenIDConfig->{ClientSettings}->{ClientID} : undef,
            AuthorizedParty  => $OpenIDConfig->{ClientSettings}->{ClientID},
            ExpectedScopes   => $Account->{Scope},
            Leeway           => $Account->{Misc}->{Leeway},
        );

        if ( $Result->{Success} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Validated IDToken for Account $AccountName.",
            );
        }
        else {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Invalid IDToken for Account $AccountName!",
            );
        }

        return unless $Result->{Success};

        $TokenData = $Result->{TokenData};
    }

    my $ExpiresAt = $TokenData->{exp};

    my $TokenRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');

    my $Success = $TokenRepository->SaveToken(
        AccountName => $AccountName,
        AccountID   => $Account->{AccountID},
        TokenType   => $TokenType,
        Token       => $Token,
        ExpiresAt   => $ExpiresAt,
    );

    return unless $Success;

    if ( $TokenType ne 'refresh_token' ) {
        $Self->_PopulateCache(
            AccountName => $AccountName,
            TokenType   => $TokenType,
            Token       => $Token,
            ExpiresAt   => $ExpiresAt,
        );
    }

    return 1;
}

1;
