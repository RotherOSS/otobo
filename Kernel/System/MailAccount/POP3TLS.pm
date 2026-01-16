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

package Kernel::System::MailAccount::POP3TLS;

use strict;
use warnings;

use parent qw(Kernel::System::MailAccount::POP3);

# core modules

# CPAN modules
use Net::POP3;
use IO::Socket::SSL ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Login Password Host Timeout Debug)) {
        if ( !defined $Param{$_} ) {
            return (
                Successful => 0,
                Message    => "Need $_!",
            );
        }
    }

    my $Type          = 'POP3STLS';
    my $SSLVerifyMode = $Kernel::OM->Get('Kernel::Config')->Get('PostMasterSSLVerifyMode') // IO::Socket::SSL::SSL_VERIFY_NONE();

    # connect to host
    # A IO::Socket::INET socket is created first, later a STLS command will be dispatched and
    # the socket is upgraded to IO::Socket::SSL.
    my $PopObject = Net::POP3->new(
        $Param{Host},
        Timeout => $Param{Timeout},
        Debug   => $Param{Debug},
    );

    return (
        Successful => 0,
        Message    => "$Type: Can't connect to $Param{Host}"
    ) unless $PopObject;

    # upgrade to SSL
    $PopObject->starttls(
        SSL             => 1,
        SSL_verify_mode => $SSLVerifyMode,
    );

    # authentication
    my $NOM = $PopObject->login( $Param{Login}, $Param{Password} );
    if ( !defined $NOM ) {
        $PopObject->quit();
        return (
            Successful => 0,
            Message    => "$Type: Auth for user $Param{Login}/$Param{Host} failed!"
        );
    }

    return (
        Successful => 1,
        PopObject  => $PopObject,
        NOM        => $NOM,
        Type       => $Type,
    );
}

1;
