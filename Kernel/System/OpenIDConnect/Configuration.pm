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

package Kernel::System::OpenIDConnect::Configuration;

use strict;
use warnings;

# core modules

# CPAN modules
use LWP::UserAgent ();

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::SysConfig',
    'Kernel::System::Cache',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::OpenIDConnect::ProfileRepository',
);

=head1 NAME

Kernel::System::OpenIDConnect::Configuration

=for stopwords OIDC
manage OIDC Configuration and Profiles

=head1 SYNOPSIS

Configuration Profiles for OpenID Connect

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');

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

=head2 GetOAuthProfiles()

Returns a list of the Name of the OpenID Connect Profiles
used for *outgoing* calls (Invoker) from database
with their OAuth2 Provider and Client Settings.

These 'Profiles' mirror the data structure used for the
OpenIDConnect Auth Module used by Authenticator.

    my $Profiles = $OIDCConfigurationObject->GetOAuthProfiles();

=cut

sub GetOAuthProfiles {

    my ( $Self, %Param ) = @_;

    my $ProfileRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::ProfileRepository');

    return $ProfileRepository->GetList();
}

=head2 GetProviderData()

Returns the OpenId dynamic Provider Data for a named OAuth Functional accounts configured in SysConfig.

    my $OpenIDProviderData = $OIDCConfigurationObject->GetProviderData(
        OpenIDConfig => {
            ... from Config.pm authmodule, eg 'AuthModule::OpenIDConnect::Config'
            ... or for Invokers from the DB ProfileRepository->GetProfile(...)
        },
    );

=cut

sub GetProviderData {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/OpenIDConfig/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $OpenIDConfig = $Param{OpenIDConfig};
    return unless IsHashRefWithData($OpenIDConfig);

    my $ProviderKey = 'ProviderData' . ( $OpenIDConfig->{ProviderSettings}{Name} // '' );

    my $OpenIDProviderData;

    if ( !$Param{NoCache} ) {
        $OpenIDProviderData = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => 'OpenIDConnect',
            Key  => $ProviderKey,
        );
    }

    # if nothing is cached, get the data
    if ( !$OpenIDProviderData ) {

        $OpenIDProviderData = $Self->_ProviderDataGet(
            OpenIDConfig => $OpenIDConfig,
        );
    }

    return $OpenIDProviderData;
}

=head2 GetIssuer()

=for stopwords iss

Returns the OpenId dynamic Provider Issuer value for a named OAuth Functional accounts configured in SysConfig.
This can be used to validate an 'iss' request parameter for incoming OAuth authorization_code callbacks.

    my $Issuer = $OIDCConfigurationObject->GetIssuer(
        OpenIDConfig => {
            ... from Config.pm authmodule, eg 'AuthModule::OpenIDConnect::Config'
            ... or for Invokers from the DB ProfileRepository->GetProfile(...)
        },
    );

    this method returns a simple string.

=cut

sub GetIssuer {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/OpenIDConfig/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $OpenIDProviderData = $Self->GetProviderData(%Param);
    return unless IsHashRefWithData($OpenIDProviderData);

    return $OpenIDProviderData->{OpenIDConfiguration}->{issuer};
}

=head2 GetTokenEndpoint()

Returns the token endpoint for this OpenIDConfig.

    my $Issuer = $OIDCConfigurationObject->GetTokenEndpoint(
        OpenIDConfig => {
            ... from Config.pm authmodule, eg 'AuthModule::OpenIDConnect::Config'
            ... or for Invokers from the DB ProfileRepository->GetProfile(...)
        },
    );

    this method returns a simple string.

=cut

sub GetTokenEndpoint {

    my ( $Self, %Param ) = @_;

    my $OpenIDConfig       = $Param{OpenIDConfig};
    my $OpenIDProviderData = $Self->GetProviderData(
        OpenIDConfig => $OpenIDConfig,
    );

    # fetch openid token endpoint

    return $OpenIDProviderData->{OpenIDConfiguration}->{token_endpoint};
}

=head2 GetAuthorizationEndpoint()

Returns the authorization (aka login) endpoint for this OpenIDConfig.

    my $Issuer = $OIDCConfigurationObject->GetAuthorizationEndpoint(
        OpenIDConfig => {
            ... from Config.pm authmodule, eg 'AuthModule::OpenIDConnect::Config'
            ... or for Invokers from the DB ProfileRepository->GetProfile(...)
        },
    );

    this method returns a simple string.

=cut

sub GetAuthorizationEndpoint {

    my ( $Self, %Param ) = @_;

    my $OpenIDConfig       = $Param{OpenIDConfig};
    my $OpenIDProviderData = $Self->GetProviderData(
        OpenIDConfig => $OpenIDConfig,
    );

    return $OpenIDProviderData->{OpenIDConfiguration}->{authorization_endpoint};
}

sub _ProviderDataGet {

    my ( $Self, %Param ) = @_;

    my $OpenIDConfig     = $Param{OpenIDConfig};
    my $ProviderSettings = $OpenIDConfig->{ProviderSettings};

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    if ( !$ProviderSettings->{OpenIDConfiguration} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need OpenIDConfiguration in provider settings!',
        );

        return;
    }

    my $UserAgent = LWP::UserAgent->new();

    if ( $ProviderSettings->{SSLOptions} ) {
        OPTION:
        for my $Key ( keys $ProviderSettings->{SSLOptions}->%* ) {
            next OPTION if !$Self->{SSLOptionMap}{$Key};

            if ( $Key eq 'SSLPassword' ) {
                $UserAgent->ssl_opts(
                    $Self->{SSLOptionMap}{$Key} => sub { $ProviderSettings->{SSLOptions}{$Key} },
                );

                next OPTION;
            }

            $UserAgent->ssl_opts(
                $Self->{SSLOptionMap}{$Key} => $ProviderSettings->{SSLOptions}{$Key},
            );
        }
    }

    my $Response = $UserAgent->get( $ProviderSettings->{OpenIDConfiguration} );
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
    my $ProviderKey = 'ProviderData' . ( $ProviderSettings->{Name} // '' );
    $Self->{OpenIDProviderData}{$ProviderKey} = $Return;

    # set cache for 30 minutes or configured time
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'OpenIDConnect',
        Key   => 'ProviderData' . ( $ProviderSettings->{Name} // '' ),
        Value => $Return,
        TTL   => $ProviderSettings->{TTL} // 1800,
    );

    return $Return;
}

1;
