# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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
use File::Path qw(mkpath rmtree);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;
use Kernel::Config;

# the question whether there is a S3 backend must the resolved early
{
    my $ClearConfigObject = Kernel::Config->new( Level => 'Clear' );
    my $S3Active          = $ClearConfigObject->Get('Storage::S3::Active');

    skip_all('Key management not implemented for the S3 case. See https://github.com/RotherOSS/otobo/issues/1799') if $S3Active;
}

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable SMIME in config
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # create directory for certificates and private keys
        my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
        my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
        mkpath( [$CertPath],    0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
        mkpath( [$PrivatePath], 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

        # set SMIME paths in sysConfig
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::CertPath',
            Value => $CertPath,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::PrivatePath',
            Value => $PrivatePath,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # go to customer preferences
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # change customer SMIME certificate preference
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/SMIME/SMIMECertificate-1.asc";
        $Selenium->find_element( "#UserSMIMEKey",       'css' )->send_keys($Location);
        $Selenium->find_element( "#UserSMIMEKeyUpdate", 'css' )->VerifiedClick();

        # check for update SMIME certificate preference on screen
        ok(
            index( $Selenium->get_page_source(), 'Certificate uploaded' ) > -1,
            'Customer preference SMIME certificate - updated'
        ) || die "Could not upload certificate";

        # delete needed test directories
        for my $Directory ( $CertPath, $PrivatePath ) {
            my $Success = rmtree( [$Directory] );
            ok( $Success, "Directory deleted - '$Directory'" );
        }
    }
);

done_testing;
