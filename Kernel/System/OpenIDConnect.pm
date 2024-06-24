# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::OpenIDConnect;

use strict;
use warnings;

# core modules

# CPAN modules
use HTTP::Request::Common qw(POST);
use LWP::UserAgent        ();
use URI::Escape           qw(uri_escape_utf8);
use Crypt::JWT            qw(decode_jwt);

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::JSON',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::OpenIDConnect - methods for OpenIDConnect

=head1 SYNOPSIS

All functions for OpenID Connect

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {
        OpenIDProviderData => {},
        SSLOptionMap       => {
            SSLCertificate    => 'SSL_cert_file',
            SSLKey            => 'SSL_key_file',
            SSLPassword       => 'SSL_passwd_cb',
            SSLCAFile         => 'SSL_ca_file',
            SSLCADir          => 'SSL_ca_path',
            SSLVerifyHostname => 'verify_hostname',
        },
    };
    bless( $Self, $Type );

    return $Self;
}

=head2 BuildRedirectURL()

Build the redirect url to the authorization endpoint of the OpenID provider

    my $RedirectURL = $OpenIDConnectObject->BuildRedirectURL(
        AuthRequest => {
            %Data,
            %{$RequestConfig},
        },
        ClientSettings   => $OpenIDConfig->{ClientSettings},
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );

=cut

sub BuildRedirectURL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AuthRequest ClientSettings ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{AuthRequest}{ResponseType} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ResponseType must be an array ref with data!",
        );

        return;
    }

    my $ProviderKey        = 'ProviderData' . ( $Param{ProviderSettings}{Name} // '' );
    my $OpenIDProviderData = $Self->{OpenIDProviderData}{$ProviderKey} // $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'OpenIDConnect',
        Key  => $ProviderKey,
    );

    # if nothing is cached, get the data
    if ( !$OpenIDProviderData ) {
        $OpenIDProviderData = $Self->_ProviderDataGet(
            ProviderSettings => $Param{ProviderSettings},
        );
    }

    if ( !$OpenIDProviderData->{OpenIDConfiguration}{authorization_endpoint} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not retrieve the authorization endpoint!',
        );

        return;
    }

    my $RedirectURL = $OpenIDProviderData->{OpenIDConfiguration}{authorization_endpoint};
    $RedirectURL .= '?response_type=' . join( '%20', @{ $Param{AuthRequest}{ResponseType} } );
    $RedirectURL .= '&scope=' . join( '%20', ( 'openid', @{ $Param{AuthRequest}{AdditionalScope} // [] } ) );
    $RedirectURL .= '&client_id=' . $Param{ClientSettings}{ClientID};
    $RedirectURL .= '&state=' . $Param{AuthRequest}{State};
    $RedirectURL .= '&redirect_uri=' . uri_escape_utf8( $Param{ClientSettings}{RedirectURI} );

    if ( $Param{AuthRequest}{Nonce} ) {
        $RedirectURL .= '&nonce=' . $Param{AuthRequest}{Nonce};
    }

    if ( grep { $_ eq 'id_token' } @{ $Param{AuthRequest}{ResponseType} } ) {
        $RedirectURL .= '&response_mode=form_post';
    }

    return $RedirectURL;
}

=head2 RequestIDToken()

Build the redirect url to the authorization endpoint of the OpenID provider

    my $IDToken = $OpenIDConnectObject->RequestIDToken(
        AuthorizationCode => $GetParam{Code},
        ProviderSettings  => $ProviderSettings,
        ClientSettings    => $ClientSettings,
    );

=cut

sub RequestIDToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AuthorizationCode ClientSettings ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $ProviderKey        = 'ProviderData' . ( $Param{ProviderSettings}{Name} // '' );
    my $OpenIDProviderData = $Self->{OpenIDProviderData}{$ProviderKey} // $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'OpenIDConnect',
        Key  => $ProviderKey,
    );

    # if nothing is cached, get the data
    if ( !$OpenIDProviderData ) {
        $OpenIDProviderData = $Self->_ProviderDataGet(
            ProviderSettings => $Param{ProviderSettings},
        );
    }

    if ( !$OpenIDProviderData->{OpenIDConfiguration}{token_endpoint} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not get the token_endpoint',
        );

        return;
    }

    my $UserAgent = LWP::UserAgent->new();

    if ( $Param{ProviderSettings}{SSLOptions} ) {
        OPTION:
        for my $Key ( keys $Param{ProviderSettings}{SSLOptions}->%* ) {
            next OPTION if !$Self->{SSLOptionMap}{$Key};

            if ( $Key eq 'SSLPassword' ) {
                $UserAgent->ssl_opts(
                    $Self->{SSLOptionMap}{$Key} => sub { $Param{ProviderSettings}{SSLOptions}{$Key} },
                );

                next OPTION;
            }

            $UserAgent->ssl_opts(
                $Self->{SSLOptionMap}{$Key} => $Param{ProviderSettings}{SSLOptions}{$Key},
            );
        }
    }

    # send the data form-encoded
    my $Request = POST(
        $OpenIDProviderData->{OpenIDConfiguration}{token_endpoint},
        [
            grant_type   => 'authorization_code',
            code         => $Param{AuthorizationCode},
            redirect_uri => $Param{ClientSettings}{RedirectURI},
        ]
    );

    if ( !$Param{ClientSettings}{ClientID} || !$Param{ClientSettings}{ClientSecret} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ClientID and ClientSecret!',
        );

        return;
    }

    $Request->authorization_basic( $Param{ClientSettings}{ClientID}, $Param{ClientSettings}{ClientSecret} );

    my $Response = $UserAgent->request($Request);
    my $Content  = $Response->content();

    if ( !$Content ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got no content when requesting IDToken. Response Code: $Response->code();",
        );

        return;
    }

    my $DecodedContent = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $Content,
    );

    if ( $DecodedContent->{error} || !$DecodedContent->{id_token} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got error when requesting IDToken. Error: $DecodedContent->{error}; Description: $DecodedContent->{error_description};",
        );

        return;
    }

    return $DecodedContent->{id_token};
}

=head2 ValidateIDToken()

Extracts IDToken data and validates it

    my $Return = $OpenIDConnectObject->ValidateIDToken(
        IDToken          => $IDToken,
        ProviderSettings => $ProviderSettings,
        ClientSettings   => $ClientSettings,
    );

=cut

sub ValidateIDToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/IDToken ProviderSettings ClientSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Return    = { Success => 0 };
    my $TokenData = $Self->DecodeIDToken(%Param);

    return $Return if !$TokenData;

    for my $Needed (qw/iss sub aud exp iat/) {
        if ( !$TokenData->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "IDToken invalid: <$Needed> not included.",
            );

            return $Return;
        }
    }

    my $ProviderKey        = 'ProviderData' . ( $Param{ProviderSettings}{Name} // '' );
    my $OpenIDProviderData = $Self->{OpenIDProviderData}{$ProviderKey} // $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'OpenIDConnect',
        Key  => $ProviderKey,
    );

    # if nothing is cached, get the data
    if ( !$OpenIDProviderData ) {
        $OpenIDProviderData = $Self->_ProviderDataGet(
            ProviderSettings => $Param{ProviderSettings},
        );
    }

    my $Issuer = $OpenIDProviderData->{OpenIDConfiguration}{issuer};

    # do the validation
    if ( $TokenData->{iss} ne $Issuer ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "<iss> wrong. IDToken is issued by '$TokenData->{iss}', but '$Issuer' is required.",
        );

        return $Return;
    }

    my @Audience = ref $TokenData->{aud} ? @{ $TokenData->{aud} } : ( $TokenData->{aud} );
    if ( !grep { $_ eq $Param{ClientSettings}{ClientID} } @Audience ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "<aud> wrong. IDToken is addressed to '@Audience' which does not contain '$Param{ClientSettings}{ClientID}'.",
        );

        return $Return;
    }

    if ( ref $TokenData->{aud} && !$TokenData->{azp} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "<aud> is an array but <azp> not present.",
        );

        return $Return;
    }

    if ( $TokenData->{azp} && $TokenData->{azp} ne $Param{ClientSettings}{ClientID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "<azp> present and wrong. Authorized party is specified as '$TokenData->{azp}', we are '$Param{ClientSettings}{ClientID}'.",
        );

        return $Return;
    }

    my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
    my $Leeway      = int( $Param{Leeway} // 2 );

    if ( $TokenData->{iat} - $Leeway > $CurrentTime ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "<iat> invalid. IDToken creation time is in the future. Token: $TokenData->{iat}; Current: $CurrentTime;",
        );

        return $Return;
    }

    if ( $TokenData->{exp} + $Leeway <= $CurrentTime ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "<exp> invalid. IDToken expired. Expiration Time: $TokenData->{exp}; Current: $CurrentTime;",
        );
        $Return->{Error} = 'exp';

        return $Return;
    }

    if ( $Param{UseNonce} ) {
        if ( !$TokenData->{nonce} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "No nonce in IDToken.",
            );

            return $Return;
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        my %Nonce       = (
            Type => 'OpenIDConnect_Nonce',
            Key  => $TokenData->{nonce},
        );

        if ( $CacheObject->Get(%Nonce) ) {
            $CacheObject->Delete(%Nonce);
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "<nonce> invalid.",
            );
            $Return->{Error} = 'nonce';

            return $Return;
        }
    }

    return {
        Success   => 1,
        TokenData => $TokenData,
    };
}

=head2 DecodeIDToken()

Returns the decoded token

    my $TokenData = $OpenIDConnectObject->DecodeIDToken(
        IDToken          => $IDToken,
        ProviderSettings => $ProviderSettings,
    );

=cut

sub DecodeIDToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/IDToken ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get the OpenIDConfiguration and Keys
    my $Try                = 0;
    my $ProviderKey        = 'ProviderData' . ( $Param{ProviderSettings}{Name} // '' );
    my $OpenIDProviderData = $Self->{OpenIDProviderData}{$ProviderKey} // $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'OpenIDConnect',
        Key  => $ProviderKey,
    );

    # if nothing is cached, get the data
    if ( !$OpenIDProviderData || !$OpenIDProviderData->{KeyData} ) {
        $OpenIDProviderData = $Self->_ProviderDataGet(
            ProviderSettings => $Param{ProviderSettings},
        );
        $Try++;
    }

    # decode the token; retry once if it doesn't work for cached config
    my $TokenData;
    while ( $Try++ < 2 ) {

        # if we already tried receiving the data do not try again
        if ( !$OpenIDProviderData->{KeyData} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not retrieve valid kid_keys!",
            );

            return;
        }

        # decode id_token, check key
        $TokenData = decode_jwt(
            token    => $Param{IDToken},
            kid_keys => $OpenIDProviderData->{KeyData},
        ) // {};

        # check whether the issuer is correct - if not the cached data might just be outdated
        if ( $TokenData->{iss} && $TokenData->{iss} eq $OpenIDProviderData->{OpenIDConfiguration}{issuer} ) {
            $Try = 100;
        }
        elsif ( $Try < 2 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Cached IDToken wrong; retrying once.",
            );

            $OpenIDProviderData = $Self->_ProviderDataGet(
                ProviderSettings => $Param{ProviderSettings},
            );
        }
    }

    return $TokenData if $TokenData;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Failed to decode id_token!',
    );

    return;
}

=head2 GetLogoutURL()

Return the logout url of the OpenID provider

    my $RedirectURL = $OpenIDConnectObject->GetLogoutURL(
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );

=cut

sub GetLogoutURL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $ProviderKey        = 'ProviderData' . ( $Param{ProviderSettings}{Name} // '' );
    my $OpenIDProviderData = $Self->{OpenIDProviderData}{$ProviderKey} // $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'OpenIDConnect',
        Key  => $ProviderKey,
    );

    # if nothing is cached, get the data
    if ( !$OpenIDProviderData ) {
        $OpenIDProviderData = $Self->_ProviderDataGet(
            ProviderSettings => $Param{ProviderSettings},
        );
    }

    if ( !$OpenIDProviderData->{OpenIDConfiguration} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not retrieve OpenIDConfiguration!",
        );

        return;
    }

    return $OpenIDProviderData->{OpenIDConfiguration}{end_session_endpoint};
}

sub _ProviderDataGet {
    my ( $Self, %Param ) = @_;

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    if ( !$Param{ProviderSettings}{OpenIDConfiguration} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need OpenIDConfiguration in provider settings!',
        );

        return;
    }

    my $UserAgent = LWP::UserAgent->new();

    if ( $Param{ProviderSettings}{SSLOptions} ) {
        OPTION:
        for my $Key ( keys $Param{ProviderSettings}{SSLOptions}->%* ) {
            next OPTION if !$Self->{SSLOptionMap}{$Key};

            if ( $Key eq 'SSLPassword' ) {
                $UserAgent->ssl_opts(
                    $Self->{SSLOptionMap}{$Key} => sub { $Param{ProviderSettings}{SSLOptions}{$Key} },
                );

                next OPTION;
            }

            $UserAgent->ssl_opts(
                $Self->{SSLOptionMap}{$Key} => $Param{ProviderSettings}{SSLOptions}{$Key},
            );
        }
    }

    my $Response = $UserAgent->get( $Param{ProviderSettings}{OpenIDConfiguration} );
    my $Content  = $Response->content;

    if ( !$Response->is_success || !$Content ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error in retrieving OpenIDConfiguration: " . $Response->status_line,
        );

        return;
    }

    my $OpenIDConfiguration = $JSONObject->Decode(
        Data => $Content,
    );

    if ( !$OpenIDConfiguration || !$OpenIDConfiguration->{jwks_uri} || !$OpenIDConfiguration->{issuer} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Erroneous OpenIDConfiguration!',
        );

        return;
    }

    $Response = $UserAgent->get( $OpenIDConfiguration->{jwks_uri} );
    $Content  = $Response->content;

    if ( !$Response->is_success || !$Content ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error in retrieving jwks: " . $Response->status_line,
        );

        return;
    }

    my $KeyData = $JSONObject->Decode(
        Data => $Content,
    );

    if ( !$KeyData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Error in retrieving key data!',
        );

        return;
    }

    my $Return = {
        OpenIDConfiguration => $OpenIDConfiguration,
        KeyData             => $KeyData,
    };

    # store in $Self
    my $ProviderKey = 'ProviderData' . ( $Param{ProviderSettings}{Name} // '' );
    $Self->{OpenIDProviderData}{$ProviderKey} = $Return;

    # set cache for 30 minutes or configured time
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'OpenIDConnect',
        Key   => 'ProviderData' . ( $Param{ProviderSettings}{Name} // '' ),
        Value => $Return,
        TTL   => $Param{ProviderSettings}{TTL} // 1800,
    );

    return $Return;
}

1;
