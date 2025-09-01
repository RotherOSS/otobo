# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use Net::LDAP       ();
use Net::LDAP::LDIF ();

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Test2::Require::OTOBO::OpenLDAP;         # run OpenLDAP tests only when testing-openldap is reachable

sub AlterConfig {
    my ($Settings) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    for my $Setting ( $Settings->@* ) {
        my ( $Key, $Value ) = $Setting->@*;

        $ConfigObject->Set(
            Key   => $Key,
            Value => $Value,
        );
    }

    return;
}

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

my $AdminDn       = 'cn=openldap_admin,dc=otobotesting';
my $AdminPassword = 'openldap_admin';
my $RandomID      = $Helper->GetRandomID;

# Set up the initial configuration.
{
    my @Settings;

    # disable email checks when an new user is created
    push @Settings,
        [ 'CheckEmailAddresses' => 0 ],
        ;

    # first eradicate all auth backends
    push @Settings, map { [ "AuthModule$_" => undef ] } ( '', 1 .. 10 );

    # Set up authentication backend in the slot 7.
    # The settings must conform to the settings in docker-compose/testing/openldap.yml
    # in the docker-compose repository.
    # See Kernel/Config/Defaults.pm for documentation.
    push @Settings,
        [ 'AuthModule7'                     => 'Kernel::System::Auth::LDAP' ],
        [ 'AuthModule::UseSyncBackend7'     => 0 ],
        [ 'AuthModule::LDAP::Host7'         => 'testing-openldap' ],
        [ 'AuthModule::LDAP::BaseDN7'       => 'dc=otobotesting' ],
        [ 'AuthModule::LDAP::UID7'          => 'uid' ],
        [ 'AuthModule::LDAP::SearchUserDN7' => $AdminDn ],
        [ 'AuthModule::LDAP::SearchUserPw7' => $AdminPassword ],
        [ 'AuthModule::LDAP::Params7'       => { port => 1389 } ],
        ;

    AlterConfig( \@Settings );
}

# set up groups, needed for testing UserSyncInitialGroups UserSyncGroupsDefinition
my %GroupName2ID;
{
    for my $Name (qw(test_sync_group_1 test_sync_group_2)) {
        $GroupName2ID{$Name} = $GroupObject->GroupAdd(
            Name    => $Name,
            Comment => ( sprintf 'created by %s line %s', __FILE__, __LINE__ ),
            ValidID => 1,
            UserID  => 1,
        );
        ok( $GroupName2ID{$Name}, "created group $Name" );
    }
}

# Test authentication for the test users that had been created
# during startup of the LDAP server.
{
    my @Tests = (
        {
            Name         => 'wrong password',
            UserLogin    => 'otobotestuser1',
            UserPassword => 'otobotestuser1AAAA',
            AuthResult   => undef,
        },
        {
            Name         => 'wrong user',
            UserLogin    => 'otobotestuser1BBBB',
            UserPassword => 'otobotestuser1',
            AuthResult   => undef,
        },
        {
            Name         => 'correct user and password otobotestuser1',
            UserLogin    => 'otobotestuser1',
            UserPassword => 'otobotestuser1',
            AuthResult   => 'otobotestuser1',
        },
        {
            Name         => 'correct user and password otobotestuser2',
            UserLogin    => 'otobotestuser2',
            UserPassword => 'otobotestuser2',
            AuthResult   => 'otobotestuser2',
        },
    );

    my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

    for my $Test (@Tests) {
        subtest $Test->{Name} => sub {
            my $AuthResult = $AuthObject->Auth(
                User => $Test->{UserLogin},
                Pw   => $Test->{UserPassword},
            );
            is(
                $AuthResult,
                $Test->{AuthResult},
                "authentication",
            );
        };
    }
}

# read the fixtures from a ldif file, LDAP Data Interchange Format
# Inject a random ID into the distinct name, in order to allow successive runs.
{
    # for the tests that follow we want to stay in a subtree of 'dc=otobotesting'
    $ConfigObject->Set(
        Key   => 'AuthModule::LDAP::BaseDN7',
        Value => "dc=wirtshaus_$RandomID,dc=otobotesting",
    );

    my $Home     = $ConfigObject->Get('Home');
    my $LdifPath = "$Home/scripts/test/sample/LDAP/AuthOpenLDAP.ldif";
    note "Importing LDIF file $LdifPath";
    ok( -f $LdifPath, 'LDIF file exists' );
    ok( -r $LdifPath, 'LDIF file is readable' );

    my $Ldap       = Net::LDAP->new('testing-openldap:1389');
    my $BindResult = $Ldap->bind(
        dn       => $AdminDn,
        password => $AdminPassword,
    );
    ok( !$BindResult->code(), 'LDAP bind was succesful' );
    diag $BindResult->error;
    my $Ldif = Net::LDAP::LDIF->new( $LdifPath, 'r', onerror => 'undef' );
    while ( !$Ldif->eof ) {
        my $Entry = $Ldif->read_entry;
        if ( $Ldif->error() ) {
            fail('read entry from ldif file');
            diag "Error msg: ",    $Ldif->error;
            diag "Error lines:\n", $Ldif->error_lines;
        }
        else {
            # The ldif file contains placeholder for the random id. Replace those.
            my $Dn = $Entry->dn;
            $Dn =~ s/\Q[[RANDOM_ID]]\E/$RandomID/g;
            $Entry->dn($Dn);

            ATTR:
            for my $Attr (qw(dc member)) {
                my @Values = map {s/\Q[[RANDOM_ID]]\E/$RandomID/rg} $Entry->get_value($Attr);

                next ATTR unless @Values;

                $Entry->replace( $Attr => \@Values );
            }

            my $AddResult = $Ldap->add($Entry);
            if ( $AddResult->code ) {
                fail("added entry $Dn");
                diag $AddResult->error;
            }
            else {
                pass("added entry $Dn");
            }
        }
    }

    # clean up
    $Ldif->done;
    $Ldap->unbind;
}

# Tests using the imported fixtures and temporary config changes.
# The altered config settings are rolled back per default,
{
    my @Tests;

    # simple authentication tests
    push @Tests,
        {
            Name         => 'imported person Karl Kellner',
            UserLogin    => 'karl',
            UserPassword => 'karl',
            AuthResult   => 'karl',
        },
        {
            Name         => 'imported person Karl Kellner with incorrect password',
            UserLogin    => 'karl',
            UserPassword => 'karlXXX',
            AuthResult   => undef,
        };

    # testing AlwaysFilter
    push @Tests,
        {
            Name     => 'Karl Kellner speaking Bavarian',
            Settings => [
                [ 'AuthModule::LDAP::AlwaysFilter7' => '( preferredLanguage = bar )' ],
            ],
            DoRollBackSettings => 0,
            UserLogin          => 'karl',
            UserPassword       => 'karl',
            AuthResult         => 'karl',
        },
        {
            Name     => 'Karl Kellner not speaking Saterland Frisian',
            Settings => [
                [ 'AuthModule::LDAP::AlwaysFilter7' => '( preferredLanguage = stq )' ],
            ],
            DoRollBackSettings => 0,
            UserLogin          => 'karl',
            UserPassword       => 'karl',
            AuthResult         => undef,
        },
        {
            Name         => 'Karl Kellner still not speaking Saterland Frisian',
            UserLogin    => 'karl',
            UserPassword => 'karl',
            AuthResult   => undef,
        },
        {
            Name         => 'Karl Kellner with restored settings, speaking Bavarian',
            UserLogin    => 'karl',
            UserPassword => 'karl',
            AuthResult   => 'karl',
        };

    # test switching the UID setting, that is the attribute holding the OTOBO user name
    push @Tests,
        {
            Name         => 'not finding waiter_karl as UID is still set to uid',
            UserLogin    => 'waiter_karl',
            UserPassword => 'karl',
            AuthResult   => undef,
        },
        {
            Name     => 'finding waiter_karl as UID is set to cn',
            Settings => [
                [ 'AuthModule::LDAP::UID7' => 'cn' ],
            ],
            DoRollBackSettings => 0,
            UserLogin          => 'waiter_karl',
            UserPassword       => 'karl',
            AuthResult         => 'waiter_karl',
        },
        {
            Name         => 'finding waiter_karl as UID is still set to cn',
            UserLogin    => 'waiter_karl',
            UserPassword => 'karl',
            AuthResult   => 'waiter_karl',
        },
        {
            Name         => 'not finding waiter_karl as UID is rolled back to uid',
            UserLogin    => 'waiter_karl',
            UserPassword => 'karl',
            AuthResult   => undef,
        };

    # Testing the non-effect of UseLowerCase
    push @Tests,
        {
            Name         => 'finding KarL as the attribute uid is case insensive per default',
            UserLogin    => 'KarL',
            UserPassword => 'karl',
            AuthResult   => 'karl',
        },
        {
            Name     => 'UseLowerCase has no effect, uid is case insensitive',
            Settings => [
                [ 'AuthModule::LDAP::UseLowerCase7' => 1 ],
            ],
            UserLogin    => 'KarL',
            UserPassword => 'karl',
            AuthResult   => 'karl',
        };

    # Testing the setting UserSuffix
    push @Tests,
        {
            Name         => 'not finding kar as the l is missing',
            UserLogin    => 'kar',
            UserPassword => 'karl',
            AuthResult   => undef,
        },
        {
            Name     => 'UseLowerCase has no effect, uid is case insensitive',
            Settings => [
                [ 'AuthModule::LDAP::UserSuffix7' => 'l' ],
            ],
            UserLogin    => 'kar',
            UserPassword => 'karl',
            AuthResult   => 'karl',
        },
        {
            Name         => 'not finding kar as UserSuffix had been rolled back',
            UserLogin    => 'kar',
            UserPassword => 'karl',
            AuthResult   => undef,
        };

    # Testing AccessAttr and GroupDn
    push @Tests,
        {
            Name         => 'authenticate boris without checking the group',
            UserLogin    => 'boris',
            UserPassword => 'boris',
            AuthResult   => 'boris',
        },
        {
            Name         => 'authenticate bogdan without checking the group',
            UserLogin    => 'bogdan',
            UserPassword => 'bogdan',
            AuthResult   => 'bogdan',
        },
        {
            Name     => 'boris is denied as he is not in otoboallow',
            Settings => [
                [ 'AuthModule::LDAP::AccessAttr7' => 'member' ],
                [ 'AuthModule::LDAP::UserAttr7'   => 'DN' ],
                [ 'AuthModule::LDAP::GroupDN7'    => qq{ cn=otoboallow , ou=café sans souci , dc=wirtshaus_$RandomID , dc=otobotesting } ],
            ],
            DoRollBackSettings => 0,
            UserLogin          => 'boris',
            UserPassword       => 'boris',
            AuthResult         => undef,
        },
        {
            Name         => 'bogdan is granted as he is in otoboallow',
            UserLogin    => 'bogdan',
            UserPassword => 'bogdan',
            AuthResult   => 'bogdan',
        };

    # Configure the auth sync backend and autenticate Robert Ober
    push @Tests,
        sub {
            my @Settings = (
                [ 'AuthModule::UseSyncBackend7'         => 'AuthSyncBackend7' ],
                [ 'AuthSyncModule7'                     => 'Kernel::System::Auth::Sync::LDAP' ],
                [ 'AuthSyncModule::LDAP::Host7'         => 'testing-openldap' ],
                [ 'AuthSyncModule::LDAP::BaseDN7'       => "dc=wirtshaus_$RandomID,dc=otobotesting" ],
                [ 'AuthSyncModule::LDAP::UID7'          => 'uid' ],
                [ 'AuthSyncModule::LDAP::SearchUserDN7' => $AdminDn ],
                [ 'AuthSyncModule::LDAP::SearchUserPw7' => $AdminPassword ],
                [ 'AuthSyncModule::LDAP::Params7'       => { port => 1389 } ],
                [
                    'AuthSyncModule::LDAP::UserSyncMap7' => {
                        UserFirstname => 'givenName',
                        UserLastname  => 'sn',
                        UserEmail     => 'mail',
                    }
                ],
            );

            AlterConfig( \@Settings );

            return;
        },
        {
            Name         => 'Robert Ober should be synced to DB',
            UserLogin    => 'robert',
            UserPassword => 'robert',
            AuthResult   => 'robert',
        },
        sub {
            my $UserObject = $Kernel::OM->Get('Kernel::System::User');
            my %UserData   = $UserObject->GetUserData( User => 'robert' );
            like(
                \%UserData,
                {
                    UserLogin     => 'robert',
                    UserFirstname => 'Robert',
                    UserLastname  => 'Ober',
                    UserFullname  => 'Robert Ober',
                    UserEmail     => 'robert@dining_hall.wirtshaus.otobotesting.food',
                    UserTitle     => 'Mr/Mrs',
                    UserType      => 'User',
                    ValidID       => 1,
                },
                'got synced user from database'
            );
        };

    # Testing UserSyncInitialGroups.
    # UserSyncInitialGroups has no effect for robert as he already logged on before.
    # For samuel it is the initial login.
    push @Tests,
        sub {
            my %UserData = $UserObject->GetUserData( User => 'robert' );
            ok( $UserData{UserID}, 'got UserID for robert' );
            my $HasPermission = $GroupObject->PermissionCheck(
                UserID    => $UserData{UserID},
                GroupName => 'test_sync_group_1',
                Type      => 'rw',
            );
            ok( !$HasPermission, 'no permission as UserSyncInitialGroups was not set up' );
        },
        {
            Name     => 'robert synced to DB with UserSyncInitialGroups',
            Settings => [
                [ 'AuthSyncModule::LDAP::UserSyncInitialGroups7' => ['test_sync_group_1'] ],
            ],
            UserLogin    => 'robert',
            UserPassword => 'robert',
            AuthResult   => 'robert',
        },
        sub {
            my %UserData = $UserObject->GetUserData( User => 'robert' );
            ok( $UserData{UserID}, 'still got UserID for robert' );
            my $HasPermission = $GroupObject->PermissionCheck(
                UserID    => $UserData{UserID},
                GroupName => 'test_sync_group_1',
                Type      => 'rw',
            );
            ok( !$HasPermission, 'no permission as UserSyncInitialGroups is only on initial login' );
        },
        sub {
            my %UserData = $UserObject->GetUserData( User => 'samuel' );
            ok( !$UserData{UserID}, 'samuel has never logged in before' );
        },
        {
            Name     => 'samuel synced to DB with UserSyncInitialGroups',
            Settings => [
                [ 'AuthSyncModule::LDAP::UserSyncInitialGroups7' => ['test_sync_group_1'] ],
            ],
            UserLogin    => 'samuel',
            UserPassword => 'samuel',
            AuthResult   => 'samuel',
        },
        sub {
            my %UserData = $UserObject->GetUserData( User => 'samuel' );
            ok( $UserData{UserID}, 'got UserID for samuel' );
            my $HasPermission = $GroupObject->PermissionCheck(
                UserID    => $UserData{UserID},
                GroupName => 'test_sync_group_1',
                Type      => 'rw',
            );
            ok( $HasPermission, 'user samuel created with rw permission on test_sync_group_1' );
        };

    # remember the original value of altered settings for the rollback
    my @AlteredSettingsStack;

    # run the test cases
    TEST:
    for my $Test (@Tests) {

        # special case: injecting subroutines
        if ( ref $Test eq 'CODE' ) {
            $Test->();

            next TEST;
        }

        $Test->{Settings}           //= [];
        $Test->{DoRollBackSettings} //= 1;

        # Kernel::System::Auth caches the backends during construction. Kernel::System::Auth::LDAP caches the config
        # during construction. Force recreation of these objects, so that config changes are not in vain.
        $Kernel::OM->ObjectsDiscard(
            Objects => [ 'Kernel::System::Auth', 'Kernel::System::Auth::LDAP' ]
        );

        for my $Setting ( $Test->{Settings}->@* ) {
            my ( $Key, $Value ) = $Setting->@*;

            # remember previous setting for the rollback
            my $PrevValue = $ConfigObject->Get($Key);
            push @AlteredSettingsStack, [ $Key => $PrevValue ];

            $ConfigObject->Set(
                Key   => $Key,
                Value => $Value,
            );
        }

        my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');
        my $AuthResult = $AuthObject->Auth(
            User => $Test->{UserLogin},
            Pw   => $Test->{UserPassword},
        );
        is(
            $AuthResult,
            $Test->{AuthResult},
            $Test->{Name},
        );

        # Altered settings are usually rolled back, except when not
        if ( $Test->{DoRollBackSettings} ) {
            while ( my $Setting = pop @AlteredSettingsStack ) {
                my ( $Key, $Value ) = $Setting->@*;

                $ConfigObject->Set(
                    Key   => $Key,
                    Value => $Value,
                );
            }
        }
    }
}

# TODO: set up LDAP sync
# TODO: test LDAP sync

done_testing;
