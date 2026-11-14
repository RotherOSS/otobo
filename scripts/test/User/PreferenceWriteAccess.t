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
use Kernel::Output::HTML::Preferences::Generic;

sub RunPreference {
    my (%Param) = @_;

    my $UserObject = Local::Preference::User->new();
    my $Session    = Local::Preference::AuthSession->new();
    my $Config     = Local::Preference::Config->new();

    local $Kernel::OM = Local::Preference::ObjectManager->new(
        Objects => {
            'Kernel::Config'              => $Config,
            'Kernel::System::AuthSession' => $Session,
        },
    );

    my %ConfigItem = ( PrefKey => 'UserLDAPUUID' );
    $ConfigItem{Active} = $Param{Active} if exists $Param{Active};

    my $Backend = Kernel::Output::HTML::Preferences::Generic->new(
        UserID              => $Param{TargetUserID} // 7,
        UserObject          => $UserObject,
        ConfigItem          => \%ConfigItem,
        EditingAnotherAgent => $Param{EditingAnotherAgent} // 0,
        SessionID           => 'mock-session',
    );
    my $Result = $Backend->Run(
        GetParam => { UserLDAPUUID => ['ldap-uuid-42'] },
        UserData => { UserID       => $Param{TargetUserID} // 7 },
    );

    return {
        Result         => $Result,
        Error          => $Backend->Error(),
        User           => $UserObject,
        SessionUpdates => $Session->{Updates},
    };
}

my $InactiveSelf = RunPreference(
    Active       => 0,
    TargetUserID => 7,
);

is( $InactiveSelf->{Result}, undef, 'inactive preference rejects self-write' );
like( $InactiveSelf->{Error}, qr/not allowed/i, 'inactive preference returns an authorization error' );
is( $InactiveSelf->{User}->{Writes}, [], 'rejected self-write does not write a preference' );
is( $InactiveSelf->{SessionUpdates}, [], 'rejected self-write does not update the session' );

my $PrivilegedEdit = RunPreference(
    Active              => 0,
    EditingAnotherAgent => 1,
    TargetUserID        => 42,
);

is( $PrivilegedEdit->{Result}, 1, 'editing another agent can write an inactive preference' );
is(
    $PrivilegedEdit->{User}->{Writes},
    [ { UserID => 42, Key => 'UserLDAPUUID', Value => 'ldap-uuid-42' } ],
    'privileged write targets the other agent'
);

my $ActiveSelf = RunPreference(
    Active       => 1,
    TargetUserID => 7,
);

is( $ActiveSelf->{Result},                        1, 'active preference retains self-write behavior' );
is( $ActiveSelf->{User}->{Writes}->[0]->{UserID}, 7, 'active self-write stores the preference for the current user' );
is(
    $ActiveSelf->{SessionUpdates},
    [ { SessionID => 'mock-session', Key => 'UserLDAPUUID', Value => 'ldap-uuid-42' } ],
    'active self-write updates the authentication session'
);

my $MissingActive = RunPreference(
    TargetUserID => 7,
);

is( $MissingActive->{Result},                     1,              'missing Active keeps legacy self-write behavior' );
is( $MissingActive->{User}->{Writes}->[0]->{Key}, 'UserLDAPUUID', 'missing Active still writes the preference' );
is( scalar @{ $MissingActive->{SessionUpdates} }, 1,              'missing Active still updates the authentication session' );

package Local::Preference::ObjectManager;

sub new { my ( $Class, %Param )      = @_; return bless \%Param, $Class }
sub Get { my ( $Self,  $ObjectName ) = @_; return $Self->{Objects}->{$ObjectName} }

package Local::Preference::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new { my ($Class) = @_; return bless {}, $Class }
sub Get {return}

package Local::Preference::User;      ## no critic qw(Modules::ProhibitMultiplePackages)

sub new { my ($Class) = @_; return bless { Writes => [] }, $Class }
sub SetPreferences { my ( $Self, %Param ) = @_; push @{ $Self->{Writes} }, \%Param; return 1 }

package Local::Preference::AuthSession;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new { my ($Class) = @_; return bless { Updates => [] }, $Class }
sub UpdateSessionID { my ( $Self, %Param ) = @_; push @{ $Self->{Updates} }, \%Param; return 1 }

package main;                              ## no critic qw(Modules::ProhibitMultiplePackages)

done_testing();
