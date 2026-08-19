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
my $LDAPBaseDN        = "dc=bigband_$RandomID,dc=otobotesting";
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

    AlterConfig( \@Settings );
}

# read the fixtures from a ldif file, LDAP Data Interchange Format
# Inject a random ID into the distinct name, in order to allow successive runs.
{
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Home         = $ConfigObject->Get('Home');
    my $LdifPath     = "$Home/scripts/test/sample/LDAP/CustomerUserOpenLDAP.ldif";
    note "Importing LDIF file $LdifPath";
    ok( -f $LdifPath, 'LDIF file exists' );
    ok( -r $LdifPath, 'LDIF file is readable' );

    my $Ldap       = Net::LDAP->new("$LDAPHost:$LDAPPort");
    my $BindResult = $Ldap->bind(
        dn       => $LDAPAdminDn,
        password => $LDAPAdminPassword,
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
            for my $Attr (qw(dc)) {
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

# create the user object only after the config adaptions
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
    User => 'trombone_shorty',
);

diag explain( \%CustomerUserData );

my $ExpectedUserData = {
    CompanyConfig  => {},
    Config         => {},
    Source         => 'CustomerUser5',
    UserCustomerID => 'trombone.shorty@otobotesting',
    UserEmail      => 'trombone.shorty@otobotesting',
    UserFirstname  => 'Troy',
    UserFullname   => 'Troy Andrews',
    UserID         => 'trombone_shorty',
    UserLastname   => 'Andrews',
    UserLogin      => 'trombone_shorty',
    UserMailString => 'trombone.shorty@otobotesting',
};
like(
    \%CustomerUserData,
    $ExpectedUserData,
    'CustomerUserDataGet() for trombone_shorty'
);

done_testing;
