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

package Kernel::System::Console::Command::Dev::Tools::Database::XMLExecute;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::XML',

);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Convert an OTOBO database XML file to SQL and execute it in the current database.');
    $Self->AddArgument(
        Name        => 'source-path',
        Description => "Specify the location of the database XML file to be executed.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'sql-part',
        Description => "Generate only 'pre' or 'post' SQL",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^(pre|post)$/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Self->GetArgument('source-path');
    if ( !-r $SourcePath ) {
        die "Source file $SourcePath does not exist / is not readable.\n";
    }
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Self->GetArgument('source-path'),
    );
    if ( !$XML ) {
        $Self->PrintError("Could not read XML source.");
        return $Self->ExitCodeError();
    }
    my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );
    my @SQL      = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessor(
        Database => \@XMLArray,
    );
    if ( !@SQL ) {
        $Self->PrintError("Could not generate SQL.");
        return $Self->ExitCodeError();
    }

    my @SQLPost = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessorPost();

    my $SQLPart = $Self->GetOption('sql-part') || 'both';
    my @SQLCollection;
    if ( $SQLPart eq 'both' ) {
        push @SQLCollection, @SQL, @SQLPost;
    }
    elsif ( $SQLPart eq 'pre' ) {
        push @SQLCollection, @SQL;
    }
    elsif ( $SQLPart eq 'post' ) {
        push @SQLCollection, @SQLPost;
    }

    for my $SQL (@SQLCollection) {
        $Self->Print("$SQL\n");
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do( SQL => $SQL );
        if ( !$Success ) {
            $Self->PrintError("Database action failed. Exiting.");
            return $Self->ExitCodeError();
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
