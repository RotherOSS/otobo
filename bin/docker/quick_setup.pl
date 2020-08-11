#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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

=head1 NAME

quick_setup.pl - a quick OTOBO setup script

=head1 SYNOPSIS

    # get help
    bin/docker/quick_setup.pl --help

    # do it
    bin/docker/quick_setup.pl

=head1 DESCRIPTION

Useful for continous integration.

=head1 OPTIONS

=over 4

=item help

Print out the usage.

=back

=cut

use v5.24;
use warnings;
use utf8;

# core modules
use Getopt::Long;
use Pod::Usage qw(pod2usage);

# CPAN modules

# OTOBO modules

sub Main {
    my ( $HelpFlag );
    Getopt::Long::GetOptions(
        'help'             => \$HelpFlag,
    ) or pod2usage({ -exitval => 1, -verbose => 1 });

    if ( $HelpFlag ) {
        pod2usage({ -exitval => 0, -verbose => 2});
    }

    return 1 if ! CheckRequirements();

    return 1 if ! DbCreateUser();

    return 1 if ! DbCreateSchema();

    return 1 if ! DbInitialInsert();

    return 1 if ! AdaptConfig();
 
    return 1 if ! DeactivateElasticsearch();

    # looks good
    return 0;
}

sub CheckRequirements {
    return;
}

sub DbCreateUser {
    return;
}

sub DbCreateSchema {
    return;
}

sub DbInitialInsert {
    return;
}

sub AdaptConfig {
    return;
}

sub DeactivateElasticsearch {
    return;
}

# do it
my $RetCode = Main();

exit $RetCode;
