# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package scripts::DBUpdateTo6::InitializeDefaultCronjobs;    ## no critic

use strict;
use warnings;

use File::Copy ();

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdateTo6::InitializeDefaultCronjobs - Creates default cron jobs if they don't exist yet.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    for my $DistFile ( glob "$Home/var/cron/*.dist" ) {
        my $TargetFile = $DistFile =~ s{.dist$}{}r;
        if ( !-e $TargetFile ) {
            print "    Copying $DistFile to $TargetFile...\n";
            my $Success = File::Copy::copy( $DistFile, $TargetFile );
            if ( !$Success ) {
                print "\n    Error: Could not copy $DistFile to $TargetFile: $!\n";
                return;
            }
            print "    done.\n";
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
