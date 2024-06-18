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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::FileSystemWritable;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my @TestDirectories = qw(
        /bin/
        /Kernel/
        /Kernel/System/
        /Kernel/Output/
        /Kernel/Output/HTML/
        /Kernel/Modules/
    );

    my @ReadonlyDirectories;

    for my $TestDirectory (@TestDirectories) {
        my $File = $Home . $TestDirectory . "check_permissions.$$";
        if ( open( my $FH, '>', "$File" ) ) {    ## no critic qw(OTOBO::ProhibitOpen)
            print $FH "test";
            close($FH);
            unlink $File;
        }
        else {
            push @ReadonlyDirectories, $TestDirectory;
        }
    }

    if (@ReadonlyDirectories) {
        $Self->AddResultProblem(
            Label   => Translatable('File System Writable'),
            Value   => join( ', ', @ReadonlyDirectories ),
            Message => Translatable('The file system on your OTOBO partition is not writable.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('File System Writable'),
            Value => '',
        );
    }

    return $Self->GetResults();
}

1;
