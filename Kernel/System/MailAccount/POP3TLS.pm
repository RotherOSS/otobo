# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::MailAccount::POP3);

# core modules

# CPAN modules

# OTOBO modules

# same dependencies as in IMAP.pm
our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::PostMaster',
);

# these private subs override the subs in the parant class

sub _Type {
    return 'POP3TLS';
}

sub _StartTLS {
    my ( undef, $PopObject ) = @_;

    # upgrade to SSL
    my $SSLVerifyMode = $Kernel::OM->Get('Kernel::Config')->Get('PostMasterSSLVerifyMode') // IO::Socket::SSL::SSL_VERIFY_NONE();
    $PopObject->starttls(
        SSL             => 1,
        SSL_verify_mode => $SSLVerifyMode,
    );

    return;
}

1;
