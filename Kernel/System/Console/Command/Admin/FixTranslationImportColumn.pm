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

package Kernel::System::Console::Command::Admin::FixTranslationImportColumn;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::XML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Rename column import of table translation_item to import_param if neccessary.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get neccessary objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check for column existence
    $DBObject->Prepare(
        SQL   => "SELECT * FROM translation_item",
        Limit => 1,
    );
    my %ColumnNames = map { lc $_ => 1 } $DBObject->GetColumnNames();

    # rename column import to import_param if neccessary
    if ( $ColumnNames{ lc 'import' } ) {

        my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

        my $ColumnChangeXML = <<'END_XML';
<TableAlter Name="translation_item">
  <ColumnChange NameOld="import" NameNew="import_param" Required="false" Type="SMALLINT" />
</TableAlter>
END_XML

        # Create database specific SQL and PostSQL commands out of XML.
        my @SQL;
        my @SQLPost;
        my @XMLARRAY = $XMLObject->XMLParse( String => $ColumnChangeXML );

        # Create database specific SQL.
        push @SQL, $DBObject->SQLProcessor(
            Database => \@XMLARRAY,
        );

        # Create database specific PostSQL.
        push @SQLPost, $DBObject->SQLProcessorPost();

        # Execute SQL.
        for my $SQL ( @SQL, @SQLPost ) {
            my $Success = $DBObject->Do( SQL => $SQL );
            if ( !$Success ) {
                $Self->Print("<red>Error during execution of '$SQL'!</red>\n");
                return $Self->ExitCodeError();
            }
        }
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    $Self->Print("<green>No renaming neccessary.</green>\n");
    return $Self->ExitCodeOk();
}

1;
