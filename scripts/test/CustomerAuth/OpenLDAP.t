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
use Test2::Tools::Explain;
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

my $RandomID = $Helper->GetRandomID;

# Some LDAP related settings
my $LDAPHost          = 'testing-openldap';
my $LDAPPort          = 1389;
my $LDAPBaseDN        = 'dc=otobotesting';
my $LDAPAdminDn       = 'cn=admin,dc=otobotesting';
my $LDAPAdminPassword = 'admin';

# Set up the initial configuration.
{
    my @Settings;

    # disable email checks when an new user is created
    push @Settings,
        [ 'CheckEmailAddresses' => 0 ],
        ;

    # eradicate customer user backends
    push @Settings, map { [ "CustomerUser$_" => undef ] } ( '', 1 .. 10 );

    # Set up customer user backend with LDAP in slot 5
    push @Settings, [
        CustomerUser5 => {
            Name   => 'LDAP Backend',
            Module => 'Kernel::System::CustomerUser::LDAP',
            Params => {
                Host         => $LDAPHost,
                BaseDN       => $LDAPBaseDN,
                SSCOPE       => 'sub',
                UserDN       => $LDAPAdminDn,
                UserPw       => $LDAPAdminPassword,
                AlwaysFilter => '',
                Die          => 0,
                Params       => {
                    port    => $LDAPPort,
                    timeout => 120,
                    async   => 0,
                    version => 3,
                    verify  => 'none',
                },
            },
            CustomerKey                          => 'uid',
            CustomerID                           => 'mail',
            CustomerUserListFields               => [ 'cn',  'mail' ],
            CustomerUserSearchFields             => [ 'uid', 'cn', 'mail' ],
            CustomerUserSearchPrefix             => '',
            CustomerUserSearchSuffix             => '*',
            CustomerUserSearchListLimit          => 250,
            CustomerUserPostMasterSearchFields   => ['mail'],
            CustomerUserNameFields               => [ 'givenname', 'sn' ],
            CustomerUserNameFieldsJoin           => ' ',
            CustomerUserExcludePrimaryCustomerID => 0,
            TranslateManagerTo                   => 'sAMAccountName',
            AdminSetPreferences                  => 0,

            # cache time to live in sec. - cache any ldap queries
            CacheTTL => 0,
            Map      => [

                # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly, http-link-target, link class(es)
                [ 'UserTitle',      'Title or salutation', 'title',           1, 0, 'var', '', 1, undef, undef ],
                [ 'UserFirstname',  'Firstname',           'givenname',       1, 1, 'var', '', 1, undef, undef ],
                [ 'UserLastname',   'Lastname',            'sn',              1, 1, 'var', '', 1, undef, undef ],
                [ 'UserLogin',      'Username',            'uid',             1, 1, 'var', '', 1, undef, undef ],
                [ 'UserEmail',      'Email',               'mail',            1, 1, 'var', '', 1, undef, undef ],
                [ 'UserCustomerID', 'CustomerID',          'mail',            0, 1, 'var', '', 1, undef, undef ],
                [ 'UserPhone',      'Phone',               'telephonenumber', 1, 0, 'var', '', 1, undef, undef ],
                [ 'UserAddress',    'Address',             'postaladdress',   1, 0, 'var', '', 1, undef, undef ],
                [ 'UserComment',    'Comment',             'description',     1, 0, 'var', '', 1, undef, undef ],

                # this is needed, if "SMIME::FetchFromCustomer" is active
                # [ 'UserSMIMECertificate', 'SMIMECertificate',             'userSMIMECertificate', 0, 1, 'var', '', 1, undef, undef ],
            ],
        }
    ];

    # eradicate all customer auth backends
    push @Settings, map { [ "Customer::AuthModule$_" => undef ] } ( '', 1 .. 10 );

    # Set up authentication backend in the slot 7.
    # The settings must conform to the settings in docker-compose/testing/openldap.yml
    # in the docker-compose repository.
    # See Kernel/Config/Defaults.pm for documentation.
    push @Settings,
        [ 'Customer::AuthModule7'                 => 'Kernel::System::CustomerAuth::LDAP' ],
        [ 'Customer::AuthModule::UseSyncBackend7' => 0 ],
        [
            'Customer::AuthModule::LDAP::Host7' => $LDAPHost,
        ],
        [
            'Customer::AuthModule::LDAP::BaseDN7' => $LDAPBaseDN,
        ],
        [ 'Customer::AuthModule::LDAP::UID7'          => 'uid' ],
        [ 'Customer::AuthModule::LDAP::SearchUserDN7' => $LDAPAdminDn ],
        [ 'Customer::AuthModule::LDAP::SearchUserPw7' => $LDAPAdminPassword ],
        [ 'Customer::AuthModule::LDAP::Params7'       => { port => $LDAPPort } ],
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
            Name             => 'correct user and password keeperscabin',
            UserLogin        => 'keeperscabin',
            UserPassword     => 'keeperscabin',
            AuthResult       => 'keeperscabin',
            ExpectedUserData => {
                CompanyConfig => {},
                Config        => {
                    AdminSetPreferences => 0,
                    Map                 => [],
                    Module              => 'Kernel::System::CustomerUser::LDAP',
                    Name                => 'LDAP Backend',
                    Params              => {
                        BaseDN => $LDAPBaseDN,
                        Host   => $LDAPHost,
                        Params => {
                            port => $LDAPPort,
                        },
                        UserDN => $LDAPAdminDn,
                    },
                },
                Source          => 'CustomerUser5',
                UserAuthBackend => '7',
                UserCustomerID  => 'keeperscabin.peacockgarden@otobotesting',
                UserEmail       => 'keeperscabin.peacockgarden@otobotesting',
                UserFirstname   => 'Holger',
                UserFullname    => 'Holger Heger',
                UserID          => 'keeperscabin',
                UserLastname    => 'Heger',
                UserLogin       => 'keeperscabin',
            }
        },
        {
            Name             => 'correct user and password mansion',
            UserLogin        => 'mansion',
            UserPassword     => 'mansion',
            AuthResult       => 'mansion',
            ExpectedUserData => {
                CompanyConfig => {},
                Config        => {},
                UserLogin     => 'mansion',
            },
        },
    );

    # create the auth object and the user object only after the config adaptions
    my $AuthObject         = $Kernel::OM->Get('Kernel::System::CustomerAuth');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

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

            if ( $Test->{ExpectedUserData} ) {
                my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $Test->{UserLogin},
                );

                #diag explain( \%CustomerUserData );
                like(
                    \%CustomerUserData,
                    $Test->{ExpectedUserData},
                    'CustomerUserDataGet'
                );
            }
        }
    }
}

done_testing;
