# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::SupportDataCollector::Plugin::OS::Load;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    # Check if used OS is a supported system. See https://perldoc.perl.org/perlport#PLATFORMS.
    return $Self->GetResults() unless $^O =~ m/(linux|unix|netbsd|freebsd)/i;

    my @Loads;

    # If used OS is a linux system
    if ( $^O =~ /(linux|unix|netbsd|freebsd)/i ) {

        # linux systems
        if ( -e '/proc/loadavg' ) {
            open( my $LoadFile, '<', '/proc/loadavg' );    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
            while (<$LoadFile>) {
                @Loads = split( " ", $_ );
            }
        }

        if (@Loads) {
            $Self->AddResultInformation(
                Label   => Translatable('System Load'),
                Value   => $Loads[2],
                Message =>
                    Translatable(
                        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).'
                    ),
            );
        }
    }

    return $Self->GetResults();
}

1;
