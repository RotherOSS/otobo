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

use v5.24;
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../..";

use Test2::V0;
use Kernel::System::Auth::OpenIDConnect;

sub AuthCase {
    my (%Param) = @_;

    my $State   = 'CSRF1234';
    my $Request = Local::OIDC::Request->new(
        Params => {
            code  => 'authorization-code',
            state => $State . 'https%3A%2F%2Fotobo.example%2Fotobo%2Findex.pl%3FAction%3DPrefs',
        },
        Cookies => { 'OIDCCSRF-' . $State => $State },
    );
    my $Cache = Local::OIDC::Cache->new( Values => { $State => 1 } );

    my %Config = (
        'AuthModule::OpenIDConnect::UID'         => $Param{UID} // 'preferred_username',
        'AuthModule::OpenIDConnect::AuthRequest' => {
            ResponseType => ['code'],
        },
        'AuthModule::OpenIDConnect::Config' => {
            ProviderSettings => {},
            ClientSettings   => {},
            Misc             => { RandLength => length $State },
        },
        'AuthModule::OpenIDConnect::UserMap' => $Param{UserMap},
        'AuthModule::OpenIDConnect::RoleMap' => $Param{RoleMap},
    );
    if ( exists $Param{UserLookupPreference} ) {
        $Config{'AuthModule::OpenIDConnect::UserLookupPreference'} = $Param{UserLookupPreference};
    }

    my $ConfigObject = Local::OIDC::Config->new( Values => \%Config );
    my $UserObject   = Local::OIDC::User->new(
        Users       => $Param{Users}       // {},
        Preferences => $Param{Preferences} // {},
    );
    my $OIDCObject = Local::OIDC::Provider->new(
        TokenData => $Param{TokenData} // {},
        Success   => exists $Param{Success} ? $Param{Success} : 1,
    );
    my $GroupObject = Local::OIDC::Group->new();
    my $LogObject   = Local::OIDC::Log->new();

    local $Kernel::OM = Local::OIDC::ObjectManager->new(
        Objects => {
            'Kernel::Config'                => $ConfigObject,
            'Kernel::System::Cache'         => $Cache,
            'Kernel::System::Web::Request'  => $Request,
            'Kernel::System::OpenIDConnect' => $OIDCObject,
            'Kernel::System::User'          => $UserObject,
            'Kernel::System::Group'         => $GroupObject,
            'Kernel::System::Log'           => $LogObject,
        },
    );

    my $Backend  = Kernel::System::Auth::OpenIDConnect->new();
    my $Result   = $Backend->Auth();
    my $PostAuth = $Backend->PostAuth();

    return {
        Result   => $Result,
        PostAuth => $PostAuth,
        User     => $UserObject,
        Provider => $OIDCObject,
        Group    => $GroupObject,
        Cache    => $Cache,
        Log      => $LogObject,
    };
}

my $DefaultUser = {
    10 => {
        UserID        => 10,
        UserLogin     => 'existing.agent',
        UserPw        => 'stored-password-hash',
        UserFirstname => 'Existing',
        ValidID       => 1,
    },
};

for my $ConfigState ( [ 'unset', undef ], [ 'empty', '' ] ) {
    my ( $Label, $Preference ) = @{$ConfigState};
    my %LookupConfig = defined $Preference ? ( UserLookupPreference => $Preference ) : ();
    my $Result       = AuthCase(
        %LookupConfig,
        TokenData => { preferred_username => 'existing.agent' },
        Users     => $DefaultUser,
    );

    is( $Result->{Result},                                 'existing.agent', "default UserLogin lookup works with preference config $Label" );
    is( scalar @{ $Result->{User}->{PreferenceSearches} }, 0,                'default lookup does not search preferences' );
}

my $Mapped = AuthCase(
    UID                  => 'ldap-entry-uuid',
    UserLookupPreference => 'UserLDAPUUID',
    TokenData            => {
        'ldap-entry-uuid'  => 'ldap-uuid-42',
        preferred_username => 'legacy.login',
        given_name         => 'Updated',
        mapped_id          => '900',
        mapped_password    => 'new-password-hash',
        mapped_login       => 'replacement.login',
        roles              => ['otobo-agent'],
    },
    Preferences => {
        21 => 'prefix-ldap-uuid-42-suffix',
        22 => 'LDAP-UUID-42',
        42 => 'ldap-uuid-42',
    },
    Users => {
        21 => {
            UserID    => 21,
            UserLogin => 'substring.agent',
            ValidID   => 1
        },
        22 => {
            UserID    => 22,
            UserLogin => 'case.agent',
            ValidID   => 1
        },
        42 => {
            UserID        => 42,
            UserLogin     => 'target.agent',
            UserPw        => 'stored-password-hash',
            UserFirstname => 'Old',
            UserLDAPUUID  => 'stale-admin-value',
            ValidID       => 1,
        },
        99 => {
            UserID    => 99,
            UserLogin => 'legacy.login',
            ValidID   => 1
        },
    },
    UserMap => {
        given_name        => 'UserFirstname',
        mapped_id         => 'UserID',
        mapped_password   => 'UserPw',
        mapped_login      => 'UserLogin',
        'ldap-entry-uuid' => 'UserLDAPUUID',
    },
    RoleMap => { roles => { 'otobo-agent' => 'Agent' } },
);

is( $Mapped->{Result}, 'target.agent', 'UUID preference maps to the different existing account login' );
is(
    $Mapped->{User}->{PreferenceSearches}->[0],
    { Key => 'UserLDAPUUID' },
    'lookup reads all values for the configured preference before exact matching'
);
is( $Mapped->{User}->{UserAdds},                0, 'mapped account is not created' );
is( scalar @{ $Mapped->{User}->{UserUpdates} }, 1, 'profile claims update the mapped account' );
is(
    [ @{ $Mapped->{User}->{UsersByID}->{42} }{qw(UserID UserLogin UserPw UserFirstname UserLDAPUUID)} ],
    [ 42, 'target.agent', 'stored-password-hash', 'Updated', 'stale-admin-value' ],
    'profile update preserves user ID, login, password and admin-managed UUID'
);
ok(
    !exists $Mapped->{User}->{UserUpdates}->[0]->{UserPw},
    'profile update does not pass the stored password hash back to UserUpdate'
);
ok(
    !exists $Mapped->{User}->{UserUpdates}->[0]->{UserLDAPUUID},
    'profile update ignores a token mapping for the admin-managed UUID preference'
);
is( $Mapped->{User}->{UserUpdates}->[0]->{UserLogin}, 'target.agent', 'profile update keeps the matched UserLogin' );
is( $Mapped->{Group}->{RoleAssignments}->[0]->{UID},  42,             'role mapping targets the matched user ID' );
is(
    $Mapped->{PostAuth}->{RequestedURL},
    'https://otobo.example/otobo/index.pl?Action=Prefs',
    'requested URL survives state validation'
);
is( $Mapped->{Provider}->{TokenValidations}, 1,                      'Auth validates the ID token before mapping' );
is( $Mapped->{Provider}->{RequestedCodes},   ['authorization-code'], 'Auth exchanges the authorization code' );

my $LiteralPreference = AuthCase(
    UID                  => 'identity',
    UserLookupPreference => 'UserLDAPUUID',
    TokenData            => { identity => 'DOMAIN\\user_name' },
    Preferences          => {
        51 => 'DOMAIN\\user_name',
        52 => 'DOMAIN\\userXname',
    },
    Users => {
        51 => {
            UserID    => 51,
            UserLogin => 'literal.agent',
            ValidID   => 1
        },
        52 => {
            UserID    => 52,
            UserLogin => 'wildcard.agent',
            ValidID   => 1
        },
    },
);

is( $LiteralPreference->{Result}, 'literal.agent', 'literal backslash and underscore claim maps exactly' );
is(
    $LiteralPreference->{User}->{PreferenceSearches}->[0],
    { Key => 'UserLDAPUUID' },
    'literal identity lookup avoids SQL LIKE value matching'
);

my $InvalidToken = AuthCase(
    UID                  => 'ldap-entry-uuid',
    UserLookupPreference => 'UserLDAPUUID',
    Success              => 0,
    TokenData            => { 'ldap-entry-uuid' => 'ldap-uuid-42' },
    Preferences          => { 42                => 'ldap-uuid-42' },
    Users                => {
        42 => {
            UserID    => 42,
            UserLogin => 'target.agent',
            ValidID   => 1
        }
    },
);

is( $InvalidToken->{Result},                                 undef, 'failed token validation rejects authentication' );
is( scalar @{ $InvalidToken->{User}->{PreferenceSearches} }, 0,     'failed token validation does not look up an account' );

my @RejectedLookupCases = (
    {
        Name        => 'missing preference',
        Preferences => {},
    },
    {
        Name        => 'LIKE and case-insensitive candidates without an exact UUID',
        Preferences => {
            21 => 'prefix-ldap-uuid-42-suffix',
            22 => 'LDAP-UUID-42',
        },
    },
    {
        Name        => 'duplicate exact UUID preferences',
        Preferences => {
            42 => 'ldap-uuid-42',
            43 => 'ldap-uuid-42',
        },
    },
);

for my $Case (@RejectedLookupCases) {
    my $Result = AuthCase(
        UID                  => 'ldap-entry-uuid',
        UserLookupPreference => 'UserLDAPUUID',
        TokenData            => {
            'ldap-entry-uuid'  => 'ldap-uuid-42',
            preferred_username => 'legacy.login',
        },
        Preferences => $Case->{Preferences},
        Users       => {
            99 => {
                UserID    => 99,
                UserLogin => 'legacy.login',
                ValidID   => 1
            },
        },
        UserMap => { given_name => 'UserFirstname' },
    );

    is( $Result->{Result},           undef, "$Case->{Name} rejects authentication" );
    is( $Result->{User}->{UserAdds}, 0,     'failed preference lookup does not create an account' );
    ok(
        !grep( { ( $_->{User} // '' ) eq 'legacy.login' } @{ $Result->{User}->{UserDataLookups} } ),
        'failed preference lookup does not fall back to username'
    );
}

for my $Case (
    {
        Name  => 'missing user',
        Users => {}
    },
    {
        Name  => 'inactive user',
        Users => {
            42 => {
                UserID    => 42,
                UserLogin => 'inactive.agent',
                ValidID   => 2
            }
        }
    },
    )
{
    my $Result = AuthCase(
        UID                  => 'ldap-entry-uuid',
        UserLookupPreference => 'UserLDAPUUID',
        TokenData            => {
            'ldap-entry-uuid'  => 'ldap-uuid-42',
            preferred_username => 'legacy.login'
        },
        Preferences => { 42 => 'ldap-uuid-42' },
        Users       => $Case->{Users},
        UserMap     => { given_name => 'UserFirstname' },
    );

    is( $Result->{Result},           undef, "$Case->{Name} cannot authenticate through UUID preference" );
    is( $Result->{User}->{UserAdds}, 0,     "$Case->{Name} is not auto-created" );
}

for my $TokenData (
    {
        'ldap-entry-uuid'  => '',
        preferred_username => 'legacy.login'
    },
    { preferred_username => 'legacy.login' },
    {
        'ldap-entry-uuid'  => ['ldap-uuid-42'],
        preferred_username => 'legacy.login'
    },
    {
        'ldap-entry-uuid'  => { value => 'ldap-uuid-42' },
        preferred_username => 'legacy.login'
    },
    )
{
    my $Result = AuthCase(
        UID                  => 'ldap-entry-uuid',
        UserLookupPreference => 'UserLDAPUUID',
        TokenData            => $TokenData,
        Preferences          => { 42 => 'ldap-uuid-42' },
        Users                => {
            99 => {
                UserID    => 99,
                UserLogin => 'legacy.login',
                ValidID   => 1
            }
        },
        UserMap => { given_name => 'UserFirstname' },
    );

    is( $Result->{Result},           undef, 'missing or non-scalar identity claim rejects authentication' );
    is( $Result->{User}->{UserAdds}, 0,     'missing or non-scalar identity claim does not create an account' );
}

package Local::OIDC::ObjectManager;

sub new { my ( $Class, %Param )      = @_; return bless \%Param, $Class }
sub Get { my ( $Self,  $ObjectName ) = @_; return $Self->{Objects}->{$ObjectName} }

package Local::OIDC::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new { my ( $Class, %Param ) = @_; return bless \%Param, $Class }
sub Get { my ( $Self,  $Name )  = @_; return $Self->{Values}->{$Name} }

package Local::OIDC::Request;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new       { my ( $Class, %Param ) = @_; return bless \%Param, $Class }
sub GetParam  { my ( $Self,  %Param ) = @_; return $Self->{Params}->{ $Param{Param} } }
sub GetCookie { my ( $Self,  %Param ) = @_; return $Self->{Cookies}->{ $Param{Key} } }

package Local::OIDC::Cache;      ## no critic qw(Modules::ProhibitMultiplePackages)

sub new    { my ( $Class, %Param ) = @_; return bless \%Param, $Class }
sub Get    { my ( $Self,  %Param ) = @_; return $Self->{Values}->{ $Param{Key} } }
sub Delete { my ( $Self, %Param ) = @_; delete $Self->{Values}->{ $Param{Key} }; return 1 }

package Local::OIDC::Provider;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        TokenData        => $Param{TokenData},
        Success          => $Param{Success},
        TokenValidations => 0,
        RequestedCodes   => [],
    }, $Class;
}

sub RequestIDToken {
    my ( $Self, %Param ) = @_;
    push @{ $Self->{RequestedCodes} }, $Param{AuthorizationCode};
    return 'mock-id-token';
}

sub ValidateIDToken {
    my ($Self) = @_;
    $Self->{TokenValidations}++;
    return {
        Success   => $Self->{Success},
        TokenData => $Self->{TokenData}
    };
}

package Local::OIDC::User;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    my %UsersByID = map { $_ => { %{ $Param{Users}->{$_} } } } keys %{ $Param{Users} };
    return bless {
        UsersByID          => \%UsersByID,
        Preferences        => $Param{Preferences},
        PreferenceSearches => [],
        UserDataLookups    => [],
        UserUpdates        => [],
        UserAdds           => 0,
    }, $Class;
}

sub SearchPreferences {
    my ( $Self, %Param ) = @_;
    push @{ $Self->{PreferenceSearches} }, \%Param;
    return %{ $Self->{Preferences} };
}

sub GetUserData {
    my ( $Self, %Param ) = @_;
    push @{ $Self->{UserDataLookups} }, \%Param;

    USER: for my $User ( values %{ $Self->{UsersByID} } ) {
        next USER       if $Param{Valid}  && ( $User->{ValidID} // 0 ) != 1;
        return %{$User} if $Param{UserID} && $User->{UserID} eq $Param{UserID};
        return %{$User} if $Param{User}   && $User->{UserLogin} eq $Param{User};
    }
    return;
}

sub UserAdd {
    my ($Self) = @_;
    $Self->{UserAdds}++;
    return 900;
}

sub UserUpdate {
    my ( $Self, %Param ) = @_;
    push @{ $Self->{UserUpdates} }, \%Param;
    my $User = $Self->{UsersByID}->{ $Param{UserID} };
    if ($User) {
        $User->{$_} = $Param{$_} for grep { exists $Param{$_} } keys %{$User};
    }
    return 1;
}

package Local::OIDC::Group;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new                   { my ($Class) = @_; return bless { RoleAssignments => [] }, $Class }
sub RoleList              { return ( 1 => 'Agent', 2 => 'Admin' ) }
sub PermissionRoleUserAdd { my ( $Self, %Param ) = @_; push @{ $Self->{RoleAssignments} }, \%Param; return 1 }

package Local::OIDC::Log;      ## no critic qw(Modules::ProhibitMultiplePackages)

sub new { my ($Class) = @_; return bless { Entries => [] }, $Class }
sub Log { my ( $Self, %Param ) = @_; push @{ $Self->{Entries} }, \%Param; return 1 }

package main;                  ## no critic qw(Modules::ProhibitMultiplePackages)

done_testing();
