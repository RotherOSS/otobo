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

package Kernel::System::OpenIDConnect::OAuth2MailExtensions;

use v5.24;
use strict;
use warnings;

# core modules
use MIME::Base64;

# CPAN modules
use Net::SMTP;
use Mail::IMAPClient ();
use IO::Socket::SSL  ();

# OTOBO modules

# the actual routines to encode OAuth2 in a XOAUTH2 resp. OAUTHBEARER conforming way
# see https://documentation.open-xchange.com/7.10.2/middleware/mail/dovecot/oauth_2.0_with_postfix_and_dovecot.html

sub EncodeXOAuth2 {

    my ( $User, $Token ) = @_;

    my $Auth = "user=$User\001auth=Bearer $Token\001\001";

    my $Encoded = encode_base64( $Auth, '' );

    return $Encoded;
}

sub EncodeOAuthBearer {

    my ( $User, $Token, $Host, $Port ) = @_;

    my $Auth = "n,a=$User,\001host=$Host\001port=$Port\001auth=Bearer $Token\001\001";

    my $Encoded = encode_base64( $Auth, '' );

    return $Encoded;
}

# the missing method in Net::Cmd to athenticate using XOAUTH2 or OAUTHBEARER
# this will be monkey patched in Kernel::System::Email::SMTP and
# Kernel::System::MAilAccount::POP3

sub NetCmdOAuth2 {

    my ( $Self, $Mechanism, $User, $Token, $Host, $Port ) = @_;

    my $Encoded = $Mechanism eq 'XOAUTH2'
        ? EncodeXOAuth2( $User, $Token )
        : EncodeOAuthBearer( $User, $Token, $Host, $Port );

    $Self->command( 'AUTH', $Mechanism );

    my $Response = $Self->response();
    if ( $Response != 3 ) {
        die "SMTP starting $Mechanism failed. ";
    }

    $Self->command($Encoded);
    $Response = $Self->response();
    if ( $Response != 2 ) {
        die "SMTP auth via $Mechanism failed. ";
    }
    return $Response;
}

# the missing method in Mail::IMAPClient to athenticate using XOAUTH2 or OAUTHBEARER
# this will be monkey patched in Kernel::System::MAilAccount::IMAP

sub ImapClientOAuth2 {

    my ( $Self, %Param ) = @_;

    my $Mechanism = $Param{Mechanism};
    my $User      = $Param{User};
    my $Token     = $Param{Token};
    my $Host      = $Param{Host};
    my $Port      = $Param{Port};

    my $Encoded = $Mechanism eq 'XOAUTH2'
        ? EncodeXOAuth2( $User, $Token )
        : EncodeOAuthBearer( $User, $Token, $Host, $Port );

    my $Result = $Self->authenticate(
        $Mechanism,
        sub {

            return $Encoded;
        }
    );

    return $Result;
}

1;
