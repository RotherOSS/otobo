# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::SupportDataCollector::Plugin::OS::Swap;

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
    return $Self->GetResults() unless $^O =~ m/linux|unix|netbsd|freebsd/i;

    my $MemInfoFile;
    my ( $MemTotal, $MemFree, $SwapTotal, $SwapFree );

    # If used OS is a linux system
    if ( -e "/proc/meminfo" && open( $MemInfoFile, '<', "/proc/meminfo" ) ) {    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)
        while ( my $TmpLine = <$MemInfoFile> ) {
            if ( $TmpLine =~ m/MemTotal/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $MemTotal = int($TmpLine);
            }
            elsif ( $TmpLine =~ m/MemFree/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $MemFree = int($TmpLine);
            }
            elsif ( $TmpLine =~ m/SwapTotal/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $SwapTotal = int($TmpLine);
            }
            elsif ( $TmpLine =~ m/SwapFree/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $SwapFree = int($TmpLine);
            }
        }
        close($MemInfoFile);
    }

    if ($MemTotal) {

        if ( !$SwapTotal ) {
            $Self->AddResultProblem(
                Identifier => 'SwapFree',
                Label      => Translatable('Free Swap Space (%)'),
                Value      => 0,
                Message    => Translatable('No swap enabled.'),
            );
            $Self->AddResultProblem(
                Identifier => 'SwapUsed',
                Label      => Translatable('Used Swap Space (MB)'),
                Value      => 0,
                Message    => Translatable('No swap enabled.'),
            );
        }
        else {
            my $SwapFreeRelative = int( $SwapFree / $SwapTotal * 100 );
            if ( $SwapFreeRelative < 60 ) {
                $Self->AddResultProblem(
                    Identifier => 'SwapFree',
                    Label      => Translatable('Free Swap Space (%)'),
                    Value      => $SwapFreeRelative,
                    Message    => Translatable('There should be more than 60% free swap space.'),
                );
            }
            else {
                $Self->AddResultOk(
                    Identifier => 'SwapFree',
                    Label      => Translatable('Free Swap Space (%)'),
                    Value      => $SwapFreeRelative,
                );
            }

            my $SwapUsed = ( $SwapTotal - $SwapFree ) / 1024;

            if ( $SwapUsed > 200 ) {
                $Self->AddResultProblem(
                    Identifier => 'SwapUsed',
                    Label      => Translatable('Used Swap Space (MB)'),
                    Value      => $SwapUsed,
                    Message    => Translatable('There should be no more than 200 MB swap space used.'),
                );
            }
            else {
                $Self->AddResultOk(
                    Identifier => 'SwapUsed',
                    Label      => Translatable('Used Swap Space (MB)'),
                    Value      => $SwapUsed,
                );
            }
        }
    }

    return $Self->GetResults();
}

1;
