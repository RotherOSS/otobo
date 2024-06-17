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

package Kernel::System::SupportDataCollector::Plugin::OS::DiskSpacePartitions;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Operating System') . '/' . Translatable('Disk Partitions Usage');
}

sub Run {
    my $Self = shift;

    # Check if used OS is a Linux system
    return $Self->GetResults() unless $^O =~ m/linux|unix|netbsd|freebsd|darwin/i;

    my $Commandline = "df -lHx tmpfs -x iso9660 -x udf -x squashfs";

    # current MacOS and FreeBSD does not support the -x flag for df
    if ( $^O =~ /(darwin|freebsd)/i ) {
        $Commandline = "df -lH";
    }

    # run the command an store the result on an array
    my @Lines;
    if ( open( my $In, '-|', "$Commandline" ) ) {    ## no critic qw(OTOBO::ProhibitOpen)
        @Lines = <$In>;
        close $In;
    }

    # clean results, in some systems when partition is too long it splits the line in two, it is
    #   needed to have all partition information in just one line for example
    #   From:
    #   /dev/mapper/system-tmp
    #                   2064208    85644   1873708   5% /tmp
    #   To:
    #   /dev/mapper/system-tmp                   2064208    85644   1873708   5% /tmp
    my @CleanLines;
    my $PreviousLine;

    LINE:
    for my $Line (@Lines) {

        chomp $Line;

        # if line does not have percent number (then it should only contain the partition)
        if ( $Line !~ m{\d+%} ) {

            # remember the line
            $PreviousLine = $Line;
            next LINE;
        }

        # if line starts with just spaces and have a percent number
        elsif ( $Line =~ m{\A \s+ (?: \d+ | \s+)+ \d+ % .+? \z}msx ) {

            # concatenate previous line and store it
            push @CleanLines, $PreviousLine . $Line;
            $PreviousLine = '';
            next LINE;
        }

        # otherwise store the line as it is
        push @CleanLines, $Line;
        $PreviousLine = '';
    }

    my %SeenPartitions;
    LINE:
    for my $Line (@CleanLines) {

        # remove leading white spaces in line
        $Line =~ s{\A\s+}{};

        if ( $Line =~ m{\A .+? \s .* \s \d+ % .+? \z}msx ) {
            my ( $Partition, $Size, $UsedPercent, $MountPoint ) = $Line =~ m{\A (.+?) \s+ ([\d\.KGMT]*) \s+ .*? \s+ (\d+)%.+? (\/.*) \z}msx;

            $MountPoint //= '';

            $Partition = "$MountPoint ($Partition)";

            next LINE if $SeenPartitions{$Partition}++;

            $Self->AddResultInformation(
                Identifier => $Partition,
                Label      => $Partition,
                Value      => $Size . ' (Used: ' . $UsedPercent . '%)',
            );
        }
    }

    return $Self->GetResults();
}

1;
