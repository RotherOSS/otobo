# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

package Test2::Require::OTOBO::Selenium;

use v5.24;
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

Test2::Require::OTOBO::Selenium - run tests only when Selenium is available

=head1 SYNOPSIS

    # to be included on top of a test script
    use Test2::Require::OTOBO::Selenium;

=head1 DESCRIPTION

This module requires that Selenium is present. Actually it is only checking whether
the SysConfig contains an non-empty setting C<SeleniumTestConfig>.

=head1 PUBLIC INTERFACE

=head2 skip()

Check whether C<SeleniumTestConfig> is there.

=cut

sub skip {
    my ($Class, @ImportArgs) = @_;

    my $SeleniumTestsConfig = $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {};
    my $SeleniumActive = $SeleniumTestsConfig->%*;

    # We have Selenium, do not skip
    return undef if $SeleniumActive;

    # No Selenium, skip the test
    return 'Skipped because Selenium is not available';
}

1;
