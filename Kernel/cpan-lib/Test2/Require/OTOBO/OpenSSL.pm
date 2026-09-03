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

package Test2::Require::OTOBO::OpenSSL;

use v5.26;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use base 'Test2::Require';

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

=head1 NAME

Test2::Require::OTOBO::OpenSSL - run tests only when openssl is available

=head1 SYNOPSIS

    # to be included on top of a test script
    use Test2::Require::OTOBO::OpenSSL;

=head1 DESCRIPTION

This module requires that the executable openssl is present.

=head1 PUBLIC INTERFACE

=head2 skip()

Check whether openssl is available,

=cut

sub skip {
    my ($Class, @ImportArgs) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin') || '/usr/bin/openssl';

    return 'Skipped because $OpenSSLBin does not exist' unless -e $OpenSSLBin;

    # not skipping
    return undef;
}

1;
