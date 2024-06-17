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

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Performance;

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

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    $DBObject->Prepare( SQL => "show variables like 'query_cache_size'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if (
            !$Row[1]
            || $Row[1] < 1024 * 1024 * 10
            || $Row[1] > 1024 * 1024 * 600
            )
        {
            $Self->AddResultWarning(
                Identifier => 'QueryCacheSize',
                Label      => Translatable('Query Cache Size'),
                Value      => $Row[1],
                Message    =>
                    Translatable(
                        "The setting 'query_cache_size' should be used (higher than 10 MB but not more than 512 MB)."
                    ),
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => 'QueryCacheSize',
                Label      => Translatable('Query Cache Size'),
                Value      => $Row[1],
            );
        }
    }

    return $Self->GetResults();
}

1;
