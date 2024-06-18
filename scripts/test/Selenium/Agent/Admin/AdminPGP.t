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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::UnitTest::Selenium;
use Kernel::Config;

# the question whether there is a S3 backend must the resolved early
{
    my $ClearConfigObject = Kernel::Config->new( Level => 'Clear' );
    my $S3Active          = $ClearConfigObject->Get('Storage::S3::Active');

    skip_all('Key management not implemented for the S3 case. See https://github.com/RotherOSS/otobo/issues/1799') if $S3Active;
}

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Disable PGP in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP',
            Value => 0,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create test PGP path and set it in sysConfig.
        my $PGPPath = $ConfigObject->Get('Home') . "/var/tmp/pgp" . $Helper->GetRandomID();
        mkpath( [$PGPPath], 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminPGP screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPGP");

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Check widget sidebar when PGP sysconfig is disabled.
        $Self->True(
            $Selenium->find_element( 'h3 span.Warning', 'css' ),
            "Widget sidebar with warning message is displayed.",
        );
        $Self->True(
            $Selenium->find_element("//button[\@value='Enable it here!']"),
            "Button 'Enable it here!' to the PGP SysConfig is displayed.",
        );

        # Enable PGP in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP',
            Value => 1,
        );

        # Set PGP path in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP::Options',
            Value => "--homedir $PGPPath --batch --no-tty --yes",
        );

        # Refresh AdminSPGP screen.
        $Selenium->VerifiedRefresh();

        # Add first test PGP key.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPGP;Subaction=Add' )]")->VerifiedClick();

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'PGP Management', 'Add PGP Key' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        my $Location1 = $ConfigObject->Get('Home')
            . "/scripts/test/sample/Crypt/PGPPrivateKey-1.asc";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location1);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Add second test PGP key.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPGP;Subaction=Add' )]")->VerifiedClick();
        my $Location2 = $ConfigObject->Get('Home')
            . "/scripts/test/sample/Crypt/PGPPrivateKey-2.asc";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location2);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check if test PGP keys show on AdminPGP screen.
        my %PGPKey = (
            1 => "unittest\@example.com",
            2 => "unittest2\@example.com",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $PGPKey{1} ) > -1,
            "$PGPKey{1} test PGP key found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $PGPKey{2} ) > -1,
            "$PGPKey{2} test PGP key found on page",
        );

        # Test search filter.
        $Selenium->find_element( "#Search", 'css' )->send_keys( $PGPKey{1} );
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $PGPKey{1} ) > -1,
            "$PGPKey{1} test PGP key found on page",
        );
        $Self->False(
            index( $Selenium->get_page_source(), $PGPKey{2} ) > -1,
            "$PGPKey{2} test PGP key is not found on page",
        );

        # Clear search filter.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Set test PGP in config so we can delete them.
        $Helper->ConfigSettingChange(
            Key   => 'PGP',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Key   => 'PGP::Options',
            Value => "--homedir $PGPPath --batch --no-tty --yes",
        );

        # Delete test PGP keys.
        for my $Count ( 1 .. 2 ) {
            my @Keys = $Kernel::OM->Get('Kernel::System::Crypt::PGP')->KeySearch(
                Search => $PGPKey{$Count},
            );

            for my $Key (@Keys) {

                # Secure key should be deleted first.
                if ( $Key->{Type} eq 'sec' ) {

                    # Click on delete secure key and public key.
                    for my $Type (qw( sec pub )) {

                        $Selenium->find_element(
                            "//a[contains(\@href, \'Subaction=Delete;Type=$Type;Key=$Key->{FingerprintShort}' )]"
                        )->click();

                        $Selenium->WaitFor( AlertPresent => 1 );
                        $Selenium->accept_alert();

                        $Selenium->WaitFor(
                            JavaScript =>
                                "return typeof(\$) === 'function' && \$('a[href*=\"Delete;Type=$Type;Key=$Key->{FingerprintShort}\"]').length == 0;"
                        );
                        $Selenium->VerifiedRefresh();

                        # Check if PGP key is deleted.
                        $Self->False(
                            $Selenium->execute_script(
                                "return \$('a[href*=\"Delete;Type=$Type;Key=$Key->{FingerprintShort}\"]').length;"
                            ),
                            "PGPKey $Type - $Key->{Identifier} deleted",
                        );

                    }
                }
            }
        }

        # Remove test PGP path.
        my $Success = rmtree( [$PGPPath] );
        $Self->True(
            $Success,
            "Directory deleted - '$PGPPath'",
        );

    }

);

done_testing();
