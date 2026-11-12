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

package Kernel::System::Web::InterfaceOIDCLogout;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

use parent qw(Plack::Component);

# core modules
use List::Util qw(any max);

# CPAN modules
use Plack::Request ();

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::OpenIDConnect::BackchannelLogout',
    'Kernel::System::OpenIDConnect::Token',
);

=head1 NAME

Kernel::System::Web::InterfaceOIDCLogout - OIDC back-channel logout endpoint

=head1 DESCRIPTION

Handles provider POST requests at C</otobo/oidc/backchannel-logout>.
Enable C<BackchannelLogout> in the agent OIDC configuration's C<Misc> settings.
Only sessions created after enabling this setting can be matched.

=head1 PUBLIC INTERFACE

=head2 call()

Return a PSGI response after validating the Logout Token and revoking matching
agent sessions. Browser cookies and query parameters are not authentication.

=cut

sub call {
    my ( $Self, $Env ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config       = $ConfigObject->Get('AuthModule::OpenIDConnect::Config') // {};
    my $Misc         = $Config->{Misc}                                         // {};

    return _Response(404) if !$Misc->{BackchannelLogout};
    return _Response(404) if !any {
        ( $ConfigObject->Get("AuthModule$_") // '' ) eq 'Kernel::System::Auth::OpenIDConnect'
    } ( '', 1 .. 10 );
    return _Response(404)                    if ( $Env->{PATH_INFO}      // '' ) !~ m{\A /? \z}xms;
    return _Response( 405, Allow => 'POST' ) if ( $Env->{REQUEST_METHOD} // '' ) ne 'POST';

    my $Request = Plack::Request->new($Env);
    return _Response(400) if ( $Request->content_type // '' ) !~ m{\A application/x-www-form-urlencoded (?: \s* ; .* )? \z}ixms;

    # Bound parsing before reading the form; never accept tokens from the URL.
    my $Length = $Env->{CONTENT_LENGTH} // '';
    return _Response(400) if $Length !~ m{\A [0-9]+ \z}xms || !$Length || $Length > 65536;
    my $Parameters = eval { $Request->body_parameters() };
    return _Response(400) if !$Parameters;
    my @Tokens = $Parameters->get_all('logout_token');
    return _Response(400) if @Tokens != 1 || !defined $Tokens[0] || ref $Tokens[0] || !length $Tokens[0];

    my $ClientID = $Config->{ClientSettings}{ClientID};
    return _Response(400) if !defined $ClientID || ref $ClientID || !length $ClientID;

    my $Claims = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token')->ValidateLogout(
        Token            => $Tokens[0],
        OpenIDConfig     => $Config,
        ExpectedAudience => $ClientID,
        SigningAlgorithm => $Misc->{BackchannelLogoutSigningAlgorithm} // 'RS256',
        Leeway           => $Misc->{Leeway}                            // 0,
    );
    return _Response(400) if !$Claims;

    # Keep revocations longer than a pending callback plus the session it could create.
    my $Retention = max( $ConfigObject->Get('SessionMaxTime') // 0, 86400 )
        + ( $Misc->{RandTTL} // 300 ) + 2 * ( $Misc->{Leeway} // 0 );
    my $Success = $Kernel::OM->Get('Kernel::System::OpenIDConnect::BackchannelLogout')->Revoke(
        Claims        => $Claims,
        ClientID      => $ClientID,
        Retention     => $Retention,
        Leeway        => $Misc->{Leeway} // 0,
        SessionObject => $Kernel::OM->Get('Kernel::System::AuthSession'),
    );

    return _Response( $Success ? 200 : 400 );
}

sub _Response {
    my ( $Status, %Headers ) = @_;

    return [
        $Status,
        [
            'Content-Type'  => 'text/plain; charset=utf-8',
            'Cache-Control' => 'no-store',
            %Headers
        ],
        [ $Status == 200 ? 'OK' : 'Logout request failed.' ],
    ];
}

1;
