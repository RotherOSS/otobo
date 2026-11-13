# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Helper->ConfigSettingChange(
            Key   => 'AuthModule::OpenIDConnect::AutoRedirect',
            Value => 0,
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Login");
        my $Page = $Selenium->get_page_source();
        $Self->False( index( $Page, 'Authentication error.' ) > -1, 'bare login GET has no authentication error' );
        $Self->True( index( $Page, 'id="User"' ) > -1, 'password form remains available with the default DB backend' );
        $Self->False( index( $Page, 'id="OIDCLoginButton"' ) > -1, 'DB-only configuration has no OIDC button' );

        $Selenium->find_element( 'input#User',     'css' )->send_keys('nonexistent-login-choice-user');
        $Selenium->find_element( 'input#Password', 'css' )->send_keys('invalid-password');
        $Selenium->find_element( '#LoginButton',   'css' )->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), 'Login failed!' ) > -1,
            'submitted invalid password keeps the login error',
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=LoginOIDC");
        $Page = $Selenium->get_page_source();
        $Self->True( index( $Page, 'Authentication error.' ) > -1, 'OIDC action rejects a non-OIDC primary backend' );

        $Helper->ConfigSettingChange(
            Key   => 'AuthModule',
            Value => 'Kernel::System::Auth::OpenIDConnect',
        );
        $Helper->ConfigSettingChange(
            Key   => 'AuthModule1',
            Value => 'Kernel::System::Auth::DB',
        );

        $Helper->ConfigSettingChange(
            Key   => 'AuthModule::OpenIDConnect::AutoRedirect',
            Value => 1,
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Login");
        $Page = $Selenium->get_page_source();
        $Self->False( index( $Page, 'Authentication error.' ) > -1, 'bare Action=Login stays clean when automatic redirect is enabled' );
        $Self->True( index( $Page, 'id="OIDCLoginButton"' ) > -1, 'manual OIDC choice remains visible with automatic redirect enabled' );

        $Helper->ConfigSettingChange(
            Key   => 'AuthModule::OpenIDConnect::AutoRedirect',
            Value => 0,
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl");
        $Page = $Selenium->get_page_source();
        $Self->True( index( $Page, 'id="User"' ) > -1,            'disabled auto redirect shows the password form' );
        $Self->True( index( $Page, 'id="OIDCLoginButton"' ) > -1, 'disabled auto redirect shows the OIDC button' );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Login");
        $Page = $Selenium->get_page_source();
        $Self->True( index( $Page, 'id="User"' ) > -1,            'OIDC primary with DB secondary keeps the password form' );
        $Self->True( index( $Page, 'id="OIDCLoginButton"' ) > -1, 'OIDC primary shows a login choice button' );
        $Self->False( index( $Page, 'Authentication error.' ) > -1, 'bare OIDC login GET does not attempt authentication' );
        $Self->True( index( $Page, 'Log in with OpenID Connect' ) > -1, 'OIDC button has its neutral default label' );
        $Self->True( index( $Page, 'value="LoginOIDC"' ) > -1,          'OIDC button submits the explicit OIDC action' );

        $Helper->ConfigSettingChange(
            Key   => 'AuthModule::OpenIDConnect::AuthRequest',
            Value => { ResponseType => ['code'] },
        );
        $Helper->ConfigSettingChange(
            Key   => 'AuthModule::OpenIDConnect::Config',
            Value => {
                ProviderSettings => {},
                ClientSettings   => {},
                Misc             => {},
            },
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Login&code=callback-without-state");
        $Self->True(
            index( $Selenium->get_page_source(), 'Authentication error.' ) > -1,
            'OIDC callback missing state keeps its authentication error',
        );

        $Helper->ConfigSettingChange(
            Key   => 'AuthModule::OpenIDConnect::LoginButtonText',
            Value => '<script>alert("x")</script>',
        );
        $Selenium->VerifiedRefresh();
        $Page = $Selenium->get_page_source();
        $Self->True( index( $Page, '&lt;script&gt;' ) > -1, 'configured OIDC button label is HTML-escaped' );
        $Self->False( index( $Page, '<script>alert' ) > -1, 'configured OIDC button label cannot inject markup' );

        $Helper->ConfigSettingChange(
            Key   => 'AuthModule1',
            Valid => 0,
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Login");
        $Page = $Selenium->get_page_source();
        $Self->False( index( $Page, 'id="User"' ) > -1, 'OIDC-only configuration hides the password form' );
        $Self->True( index( $Page, 'id="OIDCLoginButton"' ) > -1, 'OIDC-only configuration keeps the OIDC button' );
    }
);

done_testing();
