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
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

my $AdminDn       = 'cn=admin,dc=otobotesting';
my $AdminPassword = 'admin';
my $RandomID      = $Helper->GetRandomID;

# Set up the initial configuration.
{
    my @Settings;

    # disable email checks when an new user is created
    push @Settings,
        [ 'CheckEmailAddresses' => 0 ],
        ;

    # first eradicate all custumer auth backends
    push @Settings, map { [ "Customer::AuthModule$_" => undef ] } ( '', 1 .. 10 );

    # Set up authentication backend in the slot 7.
    # The settings must conform to the settings in docker-compose/testing/openldap.yml
    # in the docker-compose repository.
    # See Kernel/Config/Defaults.pm for documentation.
    push @Settings,
        [ 'Customer::AuthModule7'                     => 'Kernel::System::CustomerAuth::LDAP' ],
        [ 'Customer::AuthModule::UseSyncBackend7'     => 0 ],
        [ 'Customer::AuthModule::LDAP::Host7'         => 'testing-openldap' ],
        [ 'Customer::AuthModule::LDAP::BaseDN7'       => 'dc=otobotesting' ],
        [ 'Customer::AuthModule::LDAP::UID7'          => 'uid' ],
        [ 'Customer::AuthModule::LDAP::SearchUserDN7' => $AdminDn ],
        [ 'Customer::AuthModule::LDAP::SearchUserPw7' => $AdminPassword ],
        [ 'Customer::AuthModule::LDAP::Params7'       => { port => 1389 } ],
        ;

    AlterConfig( \@Settings );
}

# Test authentication for the test users that had been created
# during startup of the LDAP server.
{
    my @Tests = (
        {
            Name         => 'wrong password',
            UserLogin    => 'keeperscabin',
            UserPassword => 'keeperscabinAAAA',
            AuthResult   => undef,
        },
        {
            Name         => 'wrong user',
            UserLogin    => 'keeperscabinBBBB',
            UserPassword => 'keeperscabin',
            AuthResult   => undef,
        },
        {
            Name         => 'correct user and password keeperscabin',
            UserLogin    => 'keeperscabin',
            UserPassword => 'keeperscabin',
            AuthResult   => 'keeperscabin',
        },
        {
            Name         => 'correct user and password mansion',
            UserLogin    => 'mansion',
            UserPassword => 'mansion',
            AuthResult   => 'mansion',
        },
    );

    my $AuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');

    for my $Test (@Tests) {
        subtest $Test->{Name} => sub {
            my $AuthResult = $AuthObject->Auth(
                User => $Test->{UserLogin},
                Pw   => $Test->{UserPassword},
            );
            is(
                $AuthResult,
                $Test->{AuthResult},
                'authentication',
            );
        };
    }
}

done_testing;
