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

# Note:
#
# If you use this module, you should use as fallback the following
# config settings:
#
# See Kernel/System/Auth/HTTPBasicAuth.pm for a full description. In short: the HTTP
# header "Remote-User" is only accepted from a reverse proxy that proves itself with the
# shared secret 'WebServer::ProxySecret' (header X-OTOBO-Proxy-Secret), and only when
# 'Customer::AuthModule::HTTPBasicAuth::TrustProxyHeader' is enabled.
# Original note: if the user isn't logged in through apache ($ENV{REMOTE_USER})
# $Self->{CustomerPanelLoginURL} = 'http://host.example.com/not-authorised-for-otobo.html';
#
# $Self->{CustomerPanelLogoutURL} = 'http://host.example.com/thanks-for-using-otobo.html';

package Kernel::System::CustomerAuth::HTTPBasicAuth;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);
our @SoftObjectDependencies = (
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    $Self->{Count} = $Param{Count} || '';

    return $Self;
}

sub GetOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need What!"
        );
        return;
    }

    # module options
    my %Option = (
        PreAuth => 1,
    );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    my $RemoteAddr = $ParamObject->RemoteAddr() || 'Got no REMOTE_ADDR env!';

    # Source 1: identity set by the web server itself (PSGI REMOTE_USER).
    # Clients can not supply this value, so it is always trusted.
    my $User   = $ParamObject->RemoteUser();
    my $Source = 'REMOTE_USER';

    # Source 2: identity forwarded by a reverse proxy in the HTTP header "Remote-User".
    # Any client can send this header. Accept it only when explicitly enabled AND the
    # request carries the shared secret that identifies our reverse proxy.
    if ( !$User ) {

        my $HeaderUser = $ParamObject->HTTP('Remote-User');

        if ( defined $HeaderUser && length $HeaderUser ) {

            if ( !$ConfigObject->Get( 'Customer::AuthModule::HTTPBasicAuth::TrustProxyHeader' . $Self->{Count} ) ) {
                $LogObject->Log(
                    Priority => 'notice',
                    Message  =>
                        "User: Remote-User header ignored because 'Customer::AuthModule::HTTPBasicAuth::TrustProxyHeader$Self->{Count}' is not enabled (REMOTE_ADDR: $RemoteAddr).",
                );
                return;
            }

            if ( !$Self->_IsTrustedProxy() ) {
                $LogObject->Log(
                    Priority => 'notice',
                    Message  =>
                        "User: Remote-User header ignored because the request is not from a trusted proxy (REMOTE_ADDR: $RemoteAddr). Check 'WebServer::ProxySecret' and the proxy configuration.",
                );
                return;
            }

            # PSGI servers join repeated headers with ", ". A comma means that a client header
            # and a proxy header were both present, which the proxy should have prevented.
            if ( $HeaderUser =~ m/,/ ) {
                $LogObject->Log(
                    Priority => 'notice',
                    Message  =>
                        "User: Remote-User header ignored because it contains multiple values (REMOTE_ADDR: $RemoteAddr).",
                );
                return;
            }

            $User = $HeaderUser;
            $User =~ s/^\s+|\s+$//g;
            $Source = 'Remote-User header from trusted proxy';
        }
    }

    # return on no user
    if ( !$User ) {
        $LogObject->Log(
            Priority => 'notice',
            Message  => "User: No REMOTE_USER and no acceptable Remote-User header (REMOTE_ADDR: $RemoteAddr).",
        );
        return;
    }

    # replace parts of login
    my $Replace = $ConfigObject->Get(
        'Customer::AuthModule::HTTPBasicAuth::Replace' . $Self->{Count},
    );
    if ($Replace) {
        $User =~ s/^\Q$Replace\E//;
    }

    # regexp on login
    my $ReplaceRegExp = $ConfigObject->Get(
        'Customer::AuthModule::HTTPBasicAuth::ReplaceRegExp' . $Self->{Count},
    );
    if ($ReplaceRegExp) {
        $User =~ s/$ReplaceRegExp/$1/;
    }

    # log
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => "User: $User Authentication ok (REMOTE_ADDR: $RemoteAddr).",
    );

    return $User;
}

sub _IsTrustedProxy {
    my ( $Self, %Param ) = @_;

    my $ProxySecret = exists $Param{ProxySecret} ? $Param{ProxySecret} : $Self->_ProxySecret();

    # nothing configured means nothing is trusted
    return 0 unless defined $ProxySecret && length $ProxySecret;

    my $Secret = exists $Param{Secret}
        ? $Param{Secret}
        : $Kernel::OM->Get('Kernel::System::Web::Request')->HTTP('X-OTOBO-Proxy-Secret');

    return 0 unless defined $Secret;

    return $Self->_ConstantTimeEquals( $Secret, $ProxySecret );
}

sub _ProxySecret {
    my ($Self) = @_;

    my $Secret = $Kernel::OM ? $Kernel::OM->Get('Kernel::Config')->Get('WebServer::ProxySecret') : undef;

    return $Secret if defined $Secret && length $Secret;
    return $ENV{OTOBO_PROXY_SECRET};
}

# compare two strings without leaking the position of the first difference
sub _ConstantTimeEquals {
    my ( $Self, $A, $B ) = @_;

    return 0 unless defined $A && defined $B;
    return 0 unless length $A == length $B;

    my $Result = 0;
    for my $Index ( 0 .. length($A) - 1 ) {
        $Result |= ord( substr $A, $Index, 1 ) ^ ord( substr $B, $Index, 1 );
    }

    return $Result == 0 ? 1 : 0;
}

1;
