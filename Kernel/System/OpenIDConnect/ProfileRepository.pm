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

package Kernel::System::OpenIDConnect::ProfileRepository;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::YAML',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::OpenIDConnect::ProfileRepository - DB backend for OIDC Profiles for Invokers (outgoing calls)

=head1 SYNOPSIS

Profiles DB abstraction for OpenID Connect

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ProfileRepositoryObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::ProfileRepository');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};

    bless( $Self, $Type );

    return $Self;
}

=head2 GetList()

return a List of Profiles

=for stopwords openid TTL ssl

my $ArrayRef = $ProfileRepositoryObject->GetList();

returns

my $ArrayRef = [
{
   ProfileID => database id,
    ClientSettings => {
      ClientSecret => '',
      ClientID => '',
      RedirectURI => '',
    },
    ProviderSettings => {
       OpenIDConfiguration => 'https://keycloak:8080/auth/realms/MyRealm/.well-known/openid-configuration',
       TTL                 => 60 * 30,      # optional: time period the extracted openid-configuration is cached
       Name                => 'Intern4',    # optional: necessary only if one needs to differentiate between User and CustomerUser configuration e.g.
       SSLOptions          => {             # if special ssl options are needed; SSLVerifyHostname => 0 and SSLVerifyMode => 0 are also possible but should only be used for testing purposes
           SSLCertificate => 'SSL_cert_file',     # client certificate
           SSLKey         => 'SSL_key_file',      # client cert key
           SSLPassword    => 'SSL_passwd_cb',     # password for client cert key
           SSLCAFile      => 'SSL_ca_file',       # CA certificate
           SSLCADir       => 'SSL_ca_path',       # CA cert directory
           SSLVerifyHostname => 0,
           SSLVerifyMode => 0
       }
    },
    Misc => {
        UseNonce   => 1,      # add a nonce to request and token (this is primarily important for the implicit flow where it is enabled by default)
        RandLength => 22,     # length for state and nonce random strings - default: 22
        RandTTL    => 60 * 5, # valid time period for state and nonce (roughly the time a user can take to authenticate) - default: 300 s
        Leeway     => 2,      # leeway for small time differences between the OTOBO server and the OpenID provider - default: 2 s
    },
},
...
];

=cut

sub GetList {

    my ( $Self, %Param ) = @_;

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    $DBObject->Prepare(
        SQL => "SELECT id, valid_id, name, client_id, client_secret,
                    redirect_uri, openid_config, ttl, ssl_options, misc
                FROM oidc_profiles ",
    );

    my @Result;
    while ( my ( $ID, $Valid, $Name, $ClientID, $ClientSecret, $RedirectURI, $OpenIDConfig, $TTL, $SSLOptions, $Misc ) = $DBObject->FetchrowArray ) {

        my $Item = {
            ProfileID      => $ID,
            Valid          => $Valid,
            ClientSettings => {

                ClientID     => $ClientID,
                ClientSecret => $ClientSecret,
                RedirectURI  => $RedirectURI,
            },
            ProviderSettings => {
                OpenIDConfiguration => $OpenIDConfig,
                TTL                 => $TTL,
                Name                => $Name,
                SSLOptions          => $YAMLObject->Load( Data => $SSLOptions || {} ),
            },
            Misc => $YAMLObject->Load( Data => $Misc || {} ),
        };

        push @Result, $Item;
    }

    return \@Result;
}

=head2 GetProfile()

    Return an OIDC Profile from DB ny Name or ProfileID

    my $Profile = $ProfileRepositoryObject->GetProfile( Name => $Name );

    or

    my $Profile = $ProfileRepositoryObject->GetProfile( ProfileID => $ID );

    see GetList() above for response formant (single entity).

=cut

sub GetProfile {

    my ( $Self, %Param ) = @_;

    my $Name      = $Param{Name};
    my $ProfileID = $Param{ProfileID};

    if ( $Name && $ProfileID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need either Name or ProfileID but got both!",
        );

        return;
    }

    if ( !$Name && !$ProfileID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need either Name or ProfileID!",
        );

        return;
    }

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my $SQL = "SELECT id, valid_id, name, client_id, client_secret, redirect_uri, openid_config, ttl, ssl_options, misc
                FROM oidc_profiles WHERE 1=1 AND ";

    my @Bind;

    if ($Name) {
        $SQL .= "name = ? ";
        push @Bind, \$Name;
    }
    elsif ($ProfileID) {
        $SQL .= "id = ? ";
        push @Bind, \$ProfileID;
    }

    $DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,

        #            Limit => 1
    );

    if ( my ( $ID, $Valid, $Name, $ClientID, $ClientSecret, $RedirectURI, $OpenIDConfig, $TTL, $SSLOptions, $Misc ) = $DBObject->FetchrowArray ) {

        my $Item = {
            ProfileID      => $ID,
            Valid          => $Valid,
            ClientSettings => {

                ClientID     => $ClientID,
                ClientSecret => $ClientSecret,
                RedirectURI  => $RedirectURI,
            },
            ProviderSettings => {
                OpenIDConfiguration => $OpenIDConfig,
                TTL                 => $TTL,
                Name                => $Name,
                SSLOptions          => $YAMLObject->Load( Data => $SSLOptions || {} ),
            },
            Misc => $YAMLObject->Load( Data => $Misc || {} ),
        };

        return $Item;
    }

    return;
}

=head2 Exists()

    Checks whether a named OIDC Profile already exists.

    my $Exists = $ProfileRepositoryObject->Exists( Name => $Name );

=cut

sub Exists {

    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Needed (qw/Name/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name = $Param{Name};

    $DBObject->Prepare(
        SQL  => "SELECT id FROM oidc_profiles WHERE name = ? ",
        Bind => [ \$Name ],

        #            Limit => 1
    );

    if ( my ($ID) = $DBObject->FetchrowArray ) {
        return $ID;
    }

    return;
}

=head2 AddProfile()

    Insert a new OIDC Profile record into DB.

    my $Success = $ProfileRepositoryObject->AddProfile(

        Name => '<Unique Name>',
        ClientSettings => {
            ClientSecret => '',
            ClientID => '',
            RedirectURI => '',
        },
        ProviderSettings => {
            OpenIDConfiguration => 'https://keycloak:8080/auth/realms/MyRealm/.well-known/openid-configuration',
            TTL                 => 60 * 30,      # optional: time period the extracted openid-configuration is cached
            SSLOptions          => {             # if special ssl options are needed; SSLVerifyHostname => 0 and SSLVerifyMode => 0 are also possible but should only be used for testing purposes
                SSLCertificate => 'SSL_cert_file',     # client certificate
                SSLKey         => 'SSL_key_file',      # client cert key
                SSLPassword    => 'SSL_passwd_cb',     # password for client cert key
                SSLCAFile      => 'SSL_ca_file',       # CA certificate
                SSLCADir       => 'SSL_ca_path',       # CA cert directory
                SSLVerifyHostname => 0,
                SSLVerifyMode => 0
            }
        },
        Misc => {
                    UseNonce   => 1,      # add a nonce to request and token (this is primarily important for the implicit flow where it is enabled by default)
                    RandLength => 22,     # length for state and nonce random strings - default: 22
                    RandTTL    => 60 * 5, # valid time period for state and nonce (roughly the time a user can take to authenticate) - default: 300 s
                    Leeway     => 2,      # leeway for small time differences between the OTOBO server and the OpenID provier - default: 2 s
        },
        UserID => $UserID
    );

=cut

sub AddProfile {
    my ( $Self, %Param ) = @_;

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    for my $Needed (qw/Name ClientSettings ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name   = $Param{Name};
    my $Valid  = $Param{Valid};
    my $UserID = $Param{UserID};

    my $ClientSettings   = $Param{ClientSettings}   // {};
    my $ProviderSettings = $Param{ProviderSettings} // {};

    my $ClientID     = $ClientSettings->{ClientID};
    my $ClientSecret = $ClientSettings->{ClientSecret};
    my $RedirectURI  = $ClientSettings->{RedirectURI} // '';

    my $OpenIDConfiguration = $ProviderSettings->{OpenIDConfiguration};
    my $TTL                 = $ProviderSettings->{TTL} // 60 * 30;
    my $SSLOptions          = $YAMLObject->Dump( Data => $ProviderSettings->{SSLOptions} // {} );

    my $Misc = $YAMLObject->Dump( Data => $Param{Misc} // {} );

    my $SQL = "INSERT INTO oidc_profiles
        ( name, client_id, client_secret, redirect_uri, openid_config, ttl,
          ssl_options, misc, valid_id, create_time, create_by, change_time, change_by )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ? ) ";

    my $InsertSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => [
            \$Name,                \$ClientID, \$ClientSecret, \$RedirectURI,
            \$OpenIDConfiguration, \$TTL,      \$SSLOptions,
            \$Misc,                \$Valid,    \$UserID, \$UserID,
        ],
    );

    return $InsertSuccess;
}

=head2 UpdateProfile()

    Update an existing OIDC Profile record in DB.

    my $Success = $ProfileRepositoryObject->UpdateProfile(

        Name => '<Unique Name>',
        ClientSettings => {
            ClientSecret => '',
            ClientID => '',
            RedirectURI => '',
        },
        ProviderSettings => {
            OpenIDConfiguration => 'https://keycloak:8080/auth/realms/MyRealm/.well-known/openid-configuration',
            TTL                 => 60 * 30,      # optional: time period the extracted openid-configuration is cached
            SSLOptions          => {             # if special ssl options are needed; SSLVerifyHostname => 0 and SSLVerifyMode => 0 are also possible but should only be used for testing purposes
                SSLCertificate => 'SSL_cert_file',     # client certificate
                SSLKey         => 'SSL_key_file',      # client cert key
                SSLPassword    => 'SSL_passwd_cb',     # password for client cert key
                SSLCAFile      => 'SSL_ca_file',       # CA certificate
                SSLCADir       => 'SSL_ca_path',       # CA cert directory
                SSLVerifyHostname => 0,
                SSLVerifyMode => 0
            }
        },
        Misc => {
                    UseNonce   => 1,      # add a nonce to request and token (this is primarily important for the implicit flow where it is enabled by default)
                    RandLength => 22,     # length for state and nonce random strings - default: 22
                    RandTTL    => 60 * 5, # valid time period for state and nonce (roughly the time a user can take to authenticate) - default: 300 s
                    Leeway     => 2,      # leeway for small time differences between the OTOBO server and the OpenID provier - default: 2 s
        },
        UserID => $UserID
    );

=cut

sub UpdateProfile {
    my ( $Self, %Param ) = @_;

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    for my $Needed (qw/Name ClientSettings ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name   = $Param{Name};
    my $Valid  = $Param{Valid};
    my $UserID = $Param{UserID};

    my $ClientSettings   = $Param{ClientSettings}   // {};
    my $ProviderSettings = $Param{ProviderSettings} // {};

    my $ClientID     = $ClientSettings->{ClientID};
    my $ClientSecret = $ClientSettings->{ClientSecret};
    my $RedirectURI  = $ClientSettings->{RedirectURI} // '';

    my $OpenIDConfiguration = $ProviderSettings->{OpenIDConfiguration};
    my $TTL                 = $ProviderSettings->{TTL} // 60 * 30;
    my $SSLOptions          = $YAMLObject->Dump( Data => $ProviderSettings->{SSLOptions} // {} );

    my $Misc = $YAMLObject->Dump( Data => $Param{Misc} // {} );

    my $SQL = "UPDATE oidc_profiles SET client_id = ?, client_secret = ?, redirect_uri = ?, openid_config = ?,
        ttl = ?, ssl_options = ?, misc = ?, valid_id = ?, change_time = current_timestamp, change_by = ?
        WHERE name = ? ";

    my $UpdateSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => [
            \$ClientID,            \$ClientSecret, \$RedirectURI,
            \$OpenIDConfiguration, \$TTL,          \$SSLOptions,
            \$Misc,                \$Valid,        \$UserID, \$Name
        ],
    );

    return $UpdateSuccess;
}

=head2 DeleteProfile()

    Removes an named OIDC Profile record from DB.

    This will error out early if there are any references to this Profile
    from Functional Accounts. The Profile will *not* be deleted in that case.

    my $Success = $ProfileRepositoryObject->DeleteProfile( Name => $Name );

=cut

sub DeleteProfile {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Needed (qw/Name/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name = $Param{Name};

    $DBObject->Prepare(
        SQL => "SELECT COUNT(op.id)
                FROM oidc_functional_accounts ofa
                LEFT JOIN oidc_profiles op
                ON op.id = ofa.oidc_profile_id
                WHERE op.name = ? ",
        Bind => [ \$Name ],
    );

    my ($COUNT) = $DBObject->FetchrowArray();

    if ( $COUNT > 0 ) {
        return;
    }

    my $SQL  = "DELETE FROM oidc_profiles WHERE name = ? ";
    my $Bind = [ \$Name, ];

    my $DeleteSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => $Bind,
    );

    return $DeleteSuccess;
}

1;
