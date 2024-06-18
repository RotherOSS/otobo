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

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::InvalidDefaultValues;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    my $DatabaseName = $Kernel::OM->Get('Kernel::Config')->Get('Database');

    # Check for datetime fields with invalid default values
    #    (default values with a date of "0000-00-00 00:00:00").
    $DBObject->Prepare(
        SQL => '
            SELECT TABLE_NAME, COLUMN_NAME, COLUMN_DEFAULT
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE table_schema = ?
            AND DATA_TYPE = "datetime"
            AND COLUMN_DEFAULT = "0000-00-00 00:00:00"
        ',
        Bind => [ \$DatabaseName ],
    );

    # Collect all tables, their columns and default values like described above.
    my $ErrorMessage;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my $Table   = $Row[0];
        my $Column  = $Row[1];
        my $Default = $Row[2];
        $ErrorMessage .= "$Table ($Column) '$Default'\n";
    }

    if ($ErrorMessage) {

        $Self->AddResultProblem(
            Identifier => 'TablesWithInvalidDefaultValues',
            Label      => Translatable('Invalid Default Values'),
            Value      => $ErrorMessage,
            Message    => Translatable(
                'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair'
            ),
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'TablesWithInvalidDefaultValues',
            Label      => Translatable('Invalid Default Values'),
            Value      => '',
        );
    }

    return $Self->GetResults();
}

1;
