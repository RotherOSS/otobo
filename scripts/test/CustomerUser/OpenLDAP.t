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
use Test::utf8      qw(isnt_flagged_utf8 is_flagged_utf8 is_sane_utf8 is_valid_string);
use Net::LDAP       ();
use Net::LDAP::LDIF ();
use File::Path      qw(mkpath);
use Path::Class     qw(file);
use JSON            qw(decode_json);

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

sub GetEmailAndCertificate {
    my ( $Home, $SMIMEObject ) = @_;

    # That test data is also used in scripts/test/SMIME.t
    my $TestConfigJSON = file("$Home/scripts/test/sample/SMIME/smime_test.json")->slurp;
    my $TestConfig     = decode_json($TestConfigJSON);
    my $Pem            = $TestConfig->{'1'}->{'Pem'};

    # Create DER string from PEM, binary
    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');
    my ( $FileHandle, $TmpPemFn ) = $FileTempObject->TempFile();
    print $FileHandle $Pem;
    close $FileHandle;
    my $Der = qx~$SMIMEObject->{Cmd} x509 -outform der -in $TmpPemFn 2>&1~;

    return ( $TestConfig->{'1'}->{'Email'}, $Pem, $Der );
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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# create directory for certificates and private keys
my $Home        = $ConfigObject->Get('Home');
my $CertPath    = "$Home/var/tmp/certs_$RandomID";
my $PrivatePath = "$Home/var/tmp/private_$RandomID";
mkpath( [$CertPath], 0, 0770 );       ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
ok( -d $CertPath, 'cert dir was created' );
mkpath( [$PrivatePath], 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
ok( -d $PrivatePath, 'private dir was created' );

# Set up the initial configuration.
{
    my @Settings;

    # disable email checks when an new user is created
    push @Settings, [ 'CheckEmailAddresses' => 0 ];

    # activate fetching of certificates from LDAP
    # FetchFromCustomer() will be called in CustomerUserDataGet()
    push @Settings,
        [ 'SMIME'                    => 1 ],
        [ 'SMIME::FetchFromCustomer' => 1 ],
        [ 'SMIME::CertPath'          => $CertPath ],
        [ 'SMIME::PrivatePath'       => $PrivatePath ];

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
                    raw     => qr/(?:userCertificate|;binary)/i,
                },
            },
            CustomerKey                          => 'uid',
            CustomerID                           => 'mail',
            CustomerUserListFields               => [ 'givenName', 'sn', 'physicalDeliveryOfficeName', 'mail' ],
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
                [ 'UserTitle',            'Title or salutation', 'title',                      1, 0, 'var', '', 1, undef, undef ],
                [ 'UserFirstname',        'Firstname',           'givenname',                  1, 1, 'var', '', 1, undef, undef ],
                [ 'UserLastname',         'Lastname',            'sn',                         1, 1, 'var', '', 1, undef, undef ],
                [ 'UserLogin',            'Username',            'uid',                        1, 1, 'var', '', 1, undef, undef ],
                [ 'UserEmail',            'Email',               'mail',                       1, 1, 'var', '', 1, undef, undef ],
                [ 'UserCustomerID',       'CustomerID',          'mail',                       0, 1, 'var', '', 1, undef, undef ],
                [ 'UserPhone',            'Phone',               'telephonenumber',            1, 0, 'var', '', 1, undef, undef ],
                [ 'UserAddress',          'Address',             'postaladdress',              1, 0, 'var', '', 1, undef, undef ],
                [ 'UserComment',          'Comment',             'description',                1, 0, 'var', '', 1, undef, undef ],
                [ 'UserDeliveryOffice',   'Delivery Office',     'physicalDeliveryOfficeName', 1, 0, 'var', '', 1, undef, undef ],
                [ 'UserSMIMECertificate', 'SMIMECertificate',    'userCertificate;binary',     0, 1, 'var', '', 1, undef, undef ],
            ],
        }
    ];
    AlterConfig( \@Settings );
}

# some test data
my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
my ( $Email, $Pem, $Der ) = GetEmailAndCertificate( $Home, $SMIMEObject );
ok( $Der =~ m/Straubing1/, 'DER contains sensible string Straubing1' );

# read the fixtures from a ldif file, LDAP Data Interchange Format
# Inject a random ID into the distinct name, in order to allow successive runs.
{
    my $Home     = $ConfigObject->Get('Home');
    my $LdifPath = "$Home/scripts/test/sample/LDAP/CustomerUserOpenLDAP.ldif";
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

    is( $Ldap->version(), 3, 'Communication protocol is LDAPv3' );

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

            # Add the certificate here in the test script as LDIF demands
            # that date containing newlines is encoded in Base64. And encoding
            # Base64 text in Base64 again is just too much messing with the mind.
            #
            # LDAP requires that userCertificate is formatted as DER, which is a binary format.

            if ( $Dn =~ m/trombone_shorty/ ) {

                $Entry->add( 'userCertificate;binary' => $Der );
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

#diag explain(\%CustomerUserData);

my $ExpectedUserData = {
    CompanyConfig        => {},
    Config               => {},
    Source               => 'CustomerUser5',
    UserCustomerID       => $Email,
    UserEmail            => $Email,
    UserFirstname        => 'Troy',
    UserFullname         => 'Troy Andrews',
    UserID               => 'trombone_shorty',
    UserLastname         => 'Andrews',
    UserLogin            => 'trombone_shorty',
    UserMailString       => q{"Troy Andrews Cold Room \"The Fridge\"    🥶" <unittest@example.org>},
    UserSMIMECertificate => $Der,
    UserAddress          => q{Schneemannstraße 24 ☃$Dezemberdorf ㋋$Weihnachtsland ⭐},
    UserDeliveryOffice   => q{Cold Room "The Fridge"    🥶},
};
like(
    \%CustomerUserData,
    $ExpectedUserData,
    'CustomerUserDataGet() for trombone_shorty'
);

# check the encoding of some attributes
for my $Attr (qw(UserFirstname UserLastname UserEmail UserAddress)) {
    subtest "UTF-8 checking '$Attr'" => sub {
        is_valid_string( $CustomerUserData{$Attr} );
        is_flagged_utf8( $CustomerUserData{$Attr} );
        is_sane_utf8( $CustomerUserData{$Attr} );
    };
}
subtest "UserSMIMECertificate shouldn't be UTF-8" => sub {
    my $Attr = 'UserSMIMECertificate';
    is_valid_string( $CustomerUserData{$Attr} );
    isnt_flagged_utf8( $CustomerUserData{$Attr} );
    like( $CustomerUserData{$Attr}, qr/Straubing1/, 'sanity check for substring Straubing1' );
};

# Add a sanity test for the user certificate
{
    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => $Email,
        Valid            => 1,
    );
    ok( ( scalar keys %List ) > 0, "found a customer user with mail = $Email" );

    CUSTOMERUSER:
    for my $CustomerUser ( sort keys %List ) {
        my %User = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerUser,
        );

        ok( $User{UserSMIMECertificate}, "got certificate for $CustomerUser" );

        next CUSTOMERUSER unless $User{UserSMIMECertificate};

        # 1st try with CertificateSearch
        my @CertificateFilename = $SMIMEObject->CertificateSearch(
            Search => $Email,
        );

        ok( $CertificateFilename[0]{Filename},                "Certificate for $Email was imported in CustomerUserDataGet()" );
        ok( -f "$CertPath/$CertificateFilename[0]{Filename}", "Certificate for $Email exists" );

        # check
        my $Certificate = $SMIMEObject->CertificateGet(
            Filename => $CertificateFilename[0]{Filename},
        );

        like(
            $Certificate,
            qr/BEGIN CERTIFICATE.*END CERTIFICATE/s,
            'found the certificate'
        );

        # remove
        my %Remove = $SMIMEObject->CertificateRemove(
            Filename => $CertificateFilename[0]{Filename},
        );
        ok( $Remove{Successful},                   "$Remove{Message}" );
        ok( !-e $CertificateFilename[0]{Filename}, "Certificate for $Email no longer exists" );
    }
}

done_testing;
