# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Test2::Require::OTOBO::OpenLDAP;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use base 'Test2::Require';

# core modules

# CPAN modules
use Net::Ping 2.43 ();

# OTOBO modules

=head1 NAME

Test2::Require::OTOBO::OpenLDAP - run tests only when the host I<testing-openldap> is reachable

=head1 SYNOPSIS

    # to be included on top of a test script
    use Test2::Require::OTOBO::OpenLDAP;

=head1 DESCRIPTION

This module requires that OpenLDAP is present. Actually it is only checking whether
the host I<testing-openldap> can be pinged. The use case is a Docker based installation
where the service I<testing-openldap> can be activated optionally.

=head1 PUBLIC INTERFACE

=head2 skip()

Check whether I<testing-openldap> is reachable.

=cut

sub skip {
    my ($Class, @ImportArgs) = @_;

    my $Host = 'testing-openldap';

    return undef if Net::Ping->new->ping($Host);

    # No Selenium, skip the test
    return 'Skipped because the host testing-openldap is not reachable';
}

1;
