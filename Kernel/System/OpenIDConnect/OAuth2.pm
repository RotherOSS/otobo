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

package Kernel::System::OpenIDConnect::OAuth2;

use strict;
use warnings;

# core modules

# CPAN modules

use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request::Common;
use URI::Escape qw(uri_escape_utf8);
use Crypt::JWT  qw(decode_jwt);
use JSON;

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
);

=head1 NAME

Kernel::System::OpenIDConnect::OAuth2 - methods for OpenIDConnect::OAuth2

=head1 SYNOPSIS

OAuth2 basic functionality
- make endpoint POST calls
- build login redirect url for authorization_code flow
- build logout url

=for stopwords OIDC

this is a low level interface that only knows about OAuth2,
but is completely ignorant of OIDC stuff. all necessary params
have to be passed in.

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $OAuth2Object = $Kernel::OM->Get('Kernel::System::OpenIDConnect::OAuth2');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {
        SSLOptionMap => {
            SSLCertificate    => 'SSL_cert_file',
            SSLKey            => 'SSL_key_file',
            SSLPassword       => 'SSL_passwd_cb',
            SSLCAFile         => 'SSL_ca_file',
            SSLCADir          => 'SSL_ca_path',
            SSLVerifyHostname => 'verify_hostname',
            SSLVerifyMode     => 'SSL_verify_mode',
        },
    };
    bless( $Self, $Type );

    return $Self;
}

=head2 RequestToken()

Request a Token from token endpoint

    my $TokenResult = $OAuth2Object->RequestToken(
        TokenEndpoint     => $Endpoint,                           # usually from OpenIDConfig
        ClientID          => '<oauth client id>',
        ClientSecret      => '<oauth client secret>',
        Scope             => <space separate list>,
        Resources         => '<space separated list>',            # optional
        ResourceParamName => 'resource',                          # optional
        GrantType         => 'client_credentials' | 'authorization_code' | 'password' | 'refresh_token',
        Username          => '',                                  # for password grant
        Password          => '',                                  # for password grant
        RefreshToken      => $RefreshToken,                       # the refresh_token to use for 'refresh_token' grant
        Code              => '<code from authorization callback>, # for authorization_code  grant',
        RedirectURL       => '<the redirect used',                # -.-
        SSLOptions        => {                                    #optional
            SSLCertificate    => 'SSL_cert_file',
            SSLKey            => 'SSL_key_file',
            SSLPassword       => 'SSL_passwd_cb',
            SSLCAFile         => 'SSL_ca_file',
            SSLCADir          => 'SSL_ca_path',
            SSLVerifyHostname => 0|1,
            SSLVerifyMode     => 0|1,
        },
    );

=cut

sub RequestToken {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/TokenEndpoint ClientID ClientSecret GrantType/) {
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

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $TokenObject    = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

    my $Scope             = $Param{Scope};
    my $ResourceIds       = $Param{Resources};
    my $ResourceParamName = $Param{ResourceParamName} || 'resource';

    # prepare the fetch token request
    my $UserAgent = $Self->_GetUserAgent( SSLOptions => $Param{SSLOptions} );

    # prepare post data
    my $PostData;

    if ( $Param{RefreshToken} ) {

        # refresh_token flow
        $PostData = [
            grant_type    => 'refresh_token',
            refresh_token => $Param{RefreshToken},
        ];
    }
    elsif ( $Param{GrantType} eq 'authorization_code' && $Param{Code} ) {

        # authorization code
        $PostData = [
            grant_type   => 'authorization_code',
            code         => $Param{Code},
            redirect_uri => $Param{RedirectURL},
        ];
    }
    elsif (
        $Param{GrantType} eq 'password'
        &&
        IsStringWithData( $Param{Username} ) &&
        IsStringWithData( $Param{Password} )
        )
    {

        # password flow
        $PostData = [
            grant_type => 'password',
            username   => $Param{Username},
            password   => $Param{Password},
        ];
    }
    elsif ( $Param{GrantType} eq 'client_credentials' ) {

        # client_credentials flow
        $PostData = [
            grant_type => 'client_credentials',
        ];
    }
    else {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Unknown grant_type $Param{GrantType} !",
        );
    }

    if ( !$Param{RefreshToken} && $ResourceIds && $ResourceIds ne '' ) {

        push @$PostData, "$ResourceParamName" => $ResourceIds;
    }

    if ( !$Param{RefreshToken} && $Scope && $Scope ne '' ) {

        push @$PostData, scope => $Scope;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "Using TokenEndpoint $Param{TokenEndpoint} !",
    );

    # actually send the request
    my $Response = $Self->_SendRequest(
        ClientID     => $Param{ClientID},
        ClientSecret => $Param{ClientSecret},
        UserAgent    => $UserAgent,
        Endpoint     => $Param{TokenEndpoint},
        PostData     => $PostData,
    );

    if ( !$Response->{Success} ) {

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "Error fetching Token: %s", $Response->{Error} ),
        };
    }

    return {
        Success        => 1,
        DecodedContent => $Response->{Content}
    };
}

=head2 GetAuthURL()

Build the URL to request an authorization code.

Example:
    my $AuthURL = $OAuth2Object->GetAuthURL(

        AuthorizationEndpoint => $Endpoint,                       # usually from OpenIDConfig
        ClientID          => '<oauth client id>',
        Scope             => <space separate list>,
        ResponseType      => 'code',                              # optional, defaults to code
        Resources         => '<space separated list>',            # optional
        ResourceParamName => 'resource',                          # optional
        Login             => '<login_hint>',                      # optional
        Prompt            => '<prompt=login>',                    # optional, forces login
        Nonce             => '<nonce>',                           # optional
        RandLength        => <length for random state and nonces> # optional
        RandTTL           => <timeout for login purposes>         # optional

        RedirectURL => 'https://your.otobo.url/otobo/index.pl?Action=AdminOAuthTokenStore&Subaction=OAuth'

        State             => '<use this vale for state instead of random string>', # optional
    );

Returns:
    $AuthURL = https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=077d2059-219...

=cut

sub GetAuthURL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AuthorizationEndpoint ClientID Scope/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # Create a random string to prevent cross-site requests.
    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => $Param{RandLength} || 22
    );

    my $ResourceParamName = $Param{ResourceParamName} || 'resource';
    my $State             = $Param{State}             || $RandomString;

    my $ResponseType = $Param{ResponseType} || ['code'];
    if ( ref $ResponseType ne 'ARRAY' ) {
        $ResponseType = [$ResponseType];
    }

    my $RedirectURL = $Param{AuthorizationEndpoint};
    $RedirectURL .= '?response_type=' . join( '%20', @{$ResponseType} );

    if ( $Param{Scope} ) {
        $RedirectURL .= '&scope=' . uri_escape_utf8( $Param{Scope} );
    }

    $RedirectURL .= '&client_id=' . uri_escape_utf8( $Param{ClientID} );

    if ( $Param{Resources} ) {
        $RedirectURL .= "&" . uri_escape_utf8($ResourceParamName)
            . "=" . uri_escape_utf8( $Param{Resources} );
    }

    if ( $Param{Nonce} ) {
        $RedirectURL .= '&nonce=' . uri_escape_utf8( $Param{Nonce} );
    }

    # hybrid mode
    # if ( grep { $_ eq 'id_token' } @{$ResponseType} ) {
    #    $RedirectURL .= '&response_mode=form_post';
    # }

    if ( $Param{Login} ) {
        $RedirectURL .= '&login_hint=' . uri_escape_utf8( $Param{Login} );
    }

    if ( $Param{Prompt} ) {
        $RedirectURL .= '&prompt=login';
    }

    $RedirectURL .= '&state=' . uri_escape_utf8($State);
    $RedirectURL .= '&redirect_uri=' . uri_escape_utf8( $Param{RedirectURL} );

    # Save all parameters to use after successful authorization.
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'TokenProvider',
        TTL   => $Param{RandTTL} || 60 * 15,
        Key   => "TokenProvider::OAuth2State::$State",
        Value => \%Param,
    );

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "OAuth2 authentication redirect URL: $RedirectURL !",
    );

# TODO: endsession_endpoint in provider info ?
# my $LogoutURL = "https://keycloak:8443/realms/master/protocol/openid-connect/logout?client_id=otobo&post_logout_redirect_uri=";
# $LogoutURL .= uri_escape_utf8($RedirectURL);
# https://auth-server/auth/realms/{realm-name}/protocol/openid-connect/logout?redirect_uri=https://auth-server/auth/realms/{realm-name}/protocol/openid-connect/auth?client_id=client_id&redirect_uri
# print STDERR "WRAPPED: $LogoutURL\n";

    return $RedirectURL;
}

sub _GetUserAgent {

    my ( $Self, %Param ) = @_;

    my $SSLOptions = $Param{SSLOptions};

    # prepare the fetch token request
    my $UserAgent = LWP::UserAgent->new();

    # SSL options
    if ($SSLOptions) {
        OPTION:
        for my $Key ( keys $SSLOptions->%* ) {
            next OPTION if !$Self->{SSLOptionMap}{$Key};

            if ( $Key eq 'SSLPassword' ) {
                $UserAgent->ssl_opts(
                    $Self->{SSLOptionMap}{$Key} => sub { $SSLOptions->{$Key} },
                );

                next OPTION;
            }

            $UserAgent->ssl_opts(
                $Self->{SSLOptionMap}{$Key} => $SSLOptions->{$Key},
            );
        }
    }

    return $UserAgent;
}

sub _SendRequest {

    my ( $Self, %Param ) = @_;

    my $Endpoint     = $Param{Endpoint};
    my $ClientID     = $Param{ClientID};
    my $ClientSecret = $Param{ClientSecret};
    my $UserAgent    = $Param{UserAgent};
    my $PostData     = $Param{PostData};

    # send the data form-encoded
    my $Request = POST(
        $Endpoint,
        $PostData
    );

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # add client_id and client_secret to authenticate the client
    if ( !$ClientID || !$ClientSecret ) {

        return {
            Success => 0,
            Error   => $LanguageObject->Translate('Need ClientID and ClientSecret!'),
        };
    }

    $Request->authorization_basic( $ClientID, $ClientSecret );

    # execute request
    my $Response = $UserAgent->request($Request);
    my $Content  = $Response->content();

    if ( !$Content ) {

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "Got no content when requesting Token. Response Code: %s", $Response->code() ),
        };
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'debug',
        Message  => "Received Content: $Content",
    );

    # decode content
    my $DecodedContent = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $Content,
    );

    if ( !IsHashRefWithData($DecodedContent) ) {

        return {
            Success => 0,
            Error   => $LanguageObject->Translate( "Got no JSON object when requesting Token. Response: %s", $Content ),
        };
    }

    # fetch the desired token (access_token (default) or id_token)
    if ( $DecodedContent->{error} ) {
        return {
            Success => 0,
            Error   => "Error: " . $DecodedContent->{error} . ". Description: " . $DecodedContent->{error_description},
        };
    }

    return {
        Success => 1,
        Content => $DecodedContent,
    };
}

1;
