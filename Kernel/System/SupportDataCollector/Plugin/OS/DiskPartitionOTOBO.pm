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

package Kernel::System::SupportDataCollector::Plugin::OS::DiskPartitionOTOBO;

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

    # Check if used OS is a Linux system
    return $Self->GetResults() unless $^O =~ m/linux|unix|netbsd|freebsd|darwin/i;

    # Find OTOBO partition. "df -P" returns something like:
    #   Filesystem     1024-blocks     Used Available Capacity Mounted on
    #   /dev/sda5         76371740 60836612  11612544      84% /
    # The complete command then gives /dev/sda5
    my $Home           = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $OTOBOPartition = `df -P $Home | tail -1 | cut -d' ' -f 1`;
    chomp $OTOBOPartition;

    $Self->AddResultInformation(
        Label => Translatable('OTOBO Disk Partition'),
        Value => $OTOBOPartition,
    );

    return $Self->GetResults();
}

1;
