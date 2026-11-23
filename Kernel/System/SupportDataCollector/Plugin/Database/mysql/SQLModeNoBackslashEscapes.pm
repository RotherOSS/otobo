# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::SQLModeNoBackslashEscapes;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Only relevant for MariaDB and MySQL
    return $Self->GetResults() unless $DBObject->GetDatabaseFunction('Type') eq 'mysql';

    # Check the global variable as the global variable should be adapted.
    my $SQLMode = '';
    $DBObject->Prepare( SQL => 'SELECT @@GLOBAL.sql_mode' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $SQLMode = $Row[0];
    }

    if ( $SQLMode =~ m/NO_BACKSLASH_ESCAPES/ ) {
        $Self->AddResultProblem(
            Label   => Translatable('SQL mode NO_BACKSLASH_ESCAPES'),
            Value   => Translatable('Active'),
            Message => Translatable('The SQL mode NO_BACKSLASH_ESCAPES must be turned off.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('SQL mode NO_BACKSLASH_ESCAPES'),
            Value => Translatable('Inactive'),
        );
    }

    return $Self->GetResults;
}

1;
