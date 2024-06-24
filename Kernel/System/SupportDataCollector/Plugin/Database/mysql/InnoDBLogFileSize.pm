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

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::InnoDBLogFileSize;

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

    # Default storage engine variable has changed its name in MySQL 5.5.3, we need to support both of them for now.
    #   <= 5.5.2 storage_engine
    #   >= 5.5.3 default_storage_engine
    my $DefaultStorageEngine = '';
    $DBObject->Prepare( SQL => "show variables like 'storage_engine'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DefaultStorageEngine = $Row[1];
    }

    if ( !$DefaultStorageEngine ) {
        $DBObject->Prepare( SQL => "show variables like 'default_storage_engine'" );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $DefaultStorageEngine = $Row[1];
        }
    }

    if ( lc $DefaultStorageEngine ne 'innodb' ) {
        return $Self->GetResults();
    }

    $DBObject->Prepare( SQL => "show variables like 'innodb_log_file_size'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if (
            !$Row[1]
            || $Row[1] < 1024 * 1024 * 256
            )
        {
            $Self->AddResultProblem(
                Label   => Translatable('InnoDB Log File Size'),
                Value   => $Row[1] / 1024 / 1024 . ' MB',
                Message =>
                    Translatable("The setting innodb_log_file_size must be at least 256 MB."),
            );
        }
        else {
            $Self->AddResultOk(
                Label => Translatable('InnoDB Log File Size'),
                Value => $Row[1] / 1024 / 1024 . ' MB',
            );
        }
    }

    return $Self->GetResults();
}

1;
