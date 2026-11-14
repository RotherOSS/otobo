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

use Test2::V0;

use Kernel::System::Auth::DB;
use Kernel::System::UnitTest::RegisterOM;

package Local::Auth::OIDCMapping;

sub new {
    my ( $Class, %Param ) = @_;
    return bless \%Param, $Class;
}

sub Auth {
    my ($Self)     = @_;
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my %UserIDs    = $UserObject->SearchPreferences(
        Key   => 'UserLDAPUUID',
        Value => $Self->{Subject},
    );
    my @MatchingUserIDs = grep { $UserIDs{$_} eq $Self->{Subject} } keys %UserIDs;

    return if @MatchingUserIDs != 1;

    return $UserObject->UserLookup(
        UserID => $MatchingUserIDs[0],
    );
}

1;

package main;    ## no critic qw(Modules::ProhibitMultiplePackages)

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'AuthModule',
    Value => 'Kernel::System::Auth::DB',
);
$ConfigObject->Set(
    Key   => 'DatabaseUserTable1',
    Value => 'users',
);
$ConfigObject->Set(
    Key   => 'DatabaseUserTableUserID1',
    Value => 'login',
);
for my $Count ( 1 .. 10 ) {
    $ConfigObject->Set(
        Key   => "AuthModule$Count",
        Value => undef,
    );
}

my $UserLogin = 'local-password-policy-' . $Helper->GetRandomID();
my $UserID    = $UserObject->UserAdd(
    UserFirstname => 'Local Password',
    UserLastname  => 'Policy Test',
    UserLogin     => $UserLogin,
    UserEmail     => $UserLogin . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

ok(
    $UserObject->SetPassword(
        UserLogin => $UserLogin,
        PW        => 'initial-password',
    ),
    'test password is set',
);

my $DBAuthObject  = Kernel::System::Auth::DB->new();
my $DBAuthObject1 = Kernel::System::Auth::DB->new( Count => 1 );

is(
    $DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    $UserLogin,
    'missing preference allows local DB password authentication',
);
ok(
    !$DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'wrong-password'
    ),
    'missing preference still rejects an incorrect password',
);
is(
    $DBAuthObject1->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    $UserLogin,
    'suffixed DB backend with a different row ID allows authentication',
);

ok(
    $UserObject->SetPreferences(
        Key    => 'UserAllowLocalPasswordLogin',
        Value  => 1,
        UserID => $UserID,
    ),
    'explicit allow preference is stored',
);
is(
    $DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    $UserLogin,
    'explicit 1 allows local DB password authentication',
);
is(
    $DBAuthObject1->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    $UserLogin,
    'explicit 1 allows through a suffixed backend with a different row ID',
);
ok(
    !$DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'wrong-password'
    ),
    'explicit 1 still rejects an incorrect password',
);

$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::System::Auth'],
);
my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');
is(
    $AuthObject->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    $UserLogin,
    'Auth dispatcher accepts an allowed local DB password',
);

ok(
    $UserObject->SetPreferences(
        Key    => 'UserAllowLocalPasswordLogin',
        Value  => 0,
        UserID => $UserID,
    ),
    'explicit deny preference is stored',
);
ok(
    !$DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    'explicit 0 denies the correct local DB password',
);
ok(
    !$DBAuthObject1->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    'explicit 0 denies through a suffixed backend after canonical user lookup',
);
ok(
    !$DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'wrong-password'
    ),
    'explicit 0 gives the same failed-auth result for an incorrect password',
);
ok(
    !$AuthObject->Auth(
        User => $UserLogin,
        Pw   => 'initial-password'
    ),
    'Auth dispatcher returns a generic failure when local DB password is denied',
);
is(
    $AuthObject->{LastErrorMessage},
    '',
    'local password policy does not expose a policy-specific auth error',
);

ok(
    $UserObject->SetPassword(
        UserLogin => $UserLogin,
        PW        => 'reset-password',
    ),
    'password can still be reset while local DB login is denied',
);
ok(
    !$DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'reset-password'
    ),
    'reset password remains denied by the local password preference',
);

my $OIDCSubject = 'mapped-oidc-subject-' . $Helper->GetRandomID();
ok(
    $UserObject->SetPreferences(
        Key    => 'UserLDAPUUID',
        Value  => $OIDCSubject,
        UserID => $UserID,
    ),
    'OIDC mapping preference is stored on the same internal user',
);
$AuthObject->{AuthBackend1} = Local::Auth::OIDCMapping->new( Subject => $OIDCSubject );
is(
    $AuthObject->Auth(
        User => $OIDCSubject,
        Pw   => 'ignored-by-external-backend'
    ),
    $UserLogin,
    'OIDC-style mapping can authenticate while local DB password login is disabled',
);

ok(
    $UserObject->SetPreferences(
        Key    => 'UserAllowLocalPasswordLogin',
        Value  => 1,
        UserID => $UserID,
    ),
    'explicit allow can be set for status test',
);
my $InvalidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( Valid => 'invalid' );
ok( $InvalidID, 'invalid user status is available' );
ok(
    $UserObject->UserUpdate(
        UserID        => $UserID,
        UserFirstname => 'Local Password',
        UserLastname  => 'Policy Test',
        UserLogin     => $UserLogin,
        ValidID       => $InvalidID,
        ChangeUserID  => 1,
    ),
    'test user can be made inactive',
);
ok(
    !$DBAuthObject->Auth(
        User => $UserLogin,
        Pw   => 'reset-password'
    ),
    'inactive user remains blocked even with the password preference set to 1',
);

done_testing();
