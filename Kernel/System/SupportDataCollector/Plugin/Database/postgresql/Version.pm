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

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::Version;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') !~ m{^postgresql} ) {
        return $Self->GetResults();
    }

    my $Version = $DBObject->Version();
    my ( $VersionMajor, $VersionMinor ) = $Version =~ m/^PostgreSQL \s+ (\d{1,3}) \. (\d{1,3})/ismx;
    if ($VersionMajor) {
        if ( sprintf( '%03d%03d', $VersionMajor, $VersionMinor ) >= 9_002 ) {
            $Self->AddResultOk(
                Label => Translatable('Database Version'),
                Value => $Version,
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => Translatable('Database Version'),
                Value   => $Version,
                Message => Translatable('PostgreSQL 9.2 or higher is required.')
            );
        }
    }
    else {
        $Self->AddResultProblem(
            Label   => Translatable('Database Version'),
            Value   => $Version,
            Message => Translatable('Could not determine database version.')
        );
    }

    return $Self->GetResults();
}

1;
