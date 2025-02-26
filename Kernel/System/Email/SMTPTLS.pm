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

package Kernel::System::Email::SMTPTLS;

use v5.24;
use strict;
use warnings;

use parent qw(Kernel::System::Email::SMTP);

# core modules

# CPAN modules
use Net::SMTP;
use IO::Socket::SSL ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

sub _Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(MailHost FQDN)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # Remove a possible port from the FQDN value
    my $FQDN = $Param{FQDN};
    $FQDN =~ s{:\d+}{}smx;

    # Do not verify the mail server per default
    my $SSLVerifyMode = $Kernel::OM->Get('Kernel::Config')->Get('SendmailModule::SSLVerifyMode') // IO::Socket::SSL::SSL_VERIFY_NONE();

    # set up connection connection
    my $SMTP = Net::SMTP->new(
        $Param{MailHost},
        Hello   => $FQDN,
        Port    => $Param{SMTPPort} || 587,
        Timeout => 30,
        Debug   => $Param{SMTPDebug},
    );

    return unless $SMTP;

    $SMTP->starttls(
        SSL_verify_mode => $SSLVerifyMode,
    );

    return $SMTP;
}

1;
