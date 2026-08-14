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

package scripts::DBUpdateTo11_1::DeprecateMailAccountOAuth2;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Package',
);

=head1 NAME

scripts::DBUpdateTo11_1::DeprecateMailAccountOAuth2 - Issue a Warning about DeprecateMailAccountOAuth2 being deprecated and no longer supported.

=cut

use parent qw(scripts::DBUpdateTo11_1::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    # check if this needs to be executed

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # see if OAuth2 package is installed
    my $IsInstalled = $PackageObject->PackageIsInstalled(
        Name => 'MailAccount-OAuth2',
    );

    if ($IsInstalled) {

        print <<'WARNING';

    Detected deprecated package 'MailAccount-OAuth2'.
    The MailAccount-OAuth2 package is no longer supported
    starting OTOBO 11.1.0.
    Please migrate to using the OIDC/OAuth2
    functionality built into OTOBO core 11.1.x.

WARNING
    }

    return 1;
}

1;
