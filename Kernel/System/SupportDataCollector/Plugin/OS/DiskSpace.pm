# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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


package Kernel::System::SupportDataCollector::Plugin::OS::DiskSpace;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    # This plugin is temporary disabled
    # A new logic is required to calculate the space
    # TODO: fix
    return $Self->GetResults();

    # # Check if used OS is a linux system
    # if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
    #     return $Self->GetResults();
    # }
    #
    # # find OTOBO partition
    # my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    #
    # my $OTOBOPartition = `df -P $Home | tail -1 | cut -d' ' -f 1`;
    # chomp $OTOBOPartition;
    #
    # my $Commandline = "df -lx tmpfs -x iso9660 -x udf -x squashfs";
    #
    # # current MacOS and FreeBSD does not support the -x flag for df
    # if ( $^O =~ /(darwin|freebsd)/i ) {
    #     $Commandline = "df -l";
    # }
    #
    # my $In;
    # if ( open( $In, "-|", "$Commandline" ) ) {
    #
    #     my ( @ProblemPartitions, $StatusProblem );
    #
    #     # TODO change from percent to megabytes used.
    #     while (<$In>) {
    #         if ( $_ =~ /^$OTOBOPartition\s.*/ && $_ =~ /^(.+?)\s.*\s(\d+)%.+?$/ ) {
    #             my ( $Partition, $UsedPercent ) = $_ =~ /^(.+?)\s.*?\s(\d+)%.+?$/;
    #             if ( $UsedPercent > 90 ) {
    #                 push @ProblemPartitions, "$Partition \[$UsedPercent%\]";
    #                 $StatusProblem = 1;
    #             }
    #             elsif ( $UsedPercent > 80 ) {
    #                 push @ProblemPartitions, "$Partition \[$UsedPercent%\]";
    #             }
    #         }
    #     }
    #     close($In);
    #     if (@ProblemPartitions) {
    #         if ($StatusProblem) {
    #             $Self->AddResultProblem(
    #                 Label   => Translatable('Disk Usage'),
    #                 Value   => join( ', ', @ProblemPartitions ),
    #                 Message => Translatable('The partition where OTOBO is located is almost full.'),
    #             );
    #         }
    #         else {
    #             $Self->AddResultWarning(
    #                 Label   => Translatable('Disk Usage'),
    #                 Value   => join( ', ', @ProblemPartitions ),
    #                 Message => Translatable('The partition where OTOBO is located is almost full.'),
    #             );
    #         }
    #     }
    #     else {
    #         $Self->AddResultOk(
    #             Label   => Translatable('Disk Usage'),
    #             Value   => '',
    #             Message => Translatable('The partition where OTOBO is located has no disk space problems.'),
    #         );
    #     }
    # }
    #
    # return $Self->GetResults();
}

1;
