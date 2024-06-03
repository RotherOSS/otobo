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

package Kernel::System::SupportDataCollector::Plugin::Database::TablePresence;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::XML',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    # table check
    my $File = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/database/otobo-schema.xml';
    if ( !-f $File ) {
        $Self->AddResultProblem(
            Label   => Translatable('Table Presence'),
            Value   => '',
            Message => Translatable("Internal Error: Could not open file."),
        );
    }

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
        Mode     => 'utf8',
    );
    if ( !ref $ContentRef && !${$ContentRef} ) {
        $Self->AddResultProblem(
            Label   => Translatable('Table Check'),
            Value   => '',
            Message => Translatable("Internal Error: Could not read file."),
        );
    }

    my @XMLHash = $Kernel::OM->Get('Kernel::System::XML')->XMLParse2XMLHash( String => ${$ContentRef} );

    my %ExistingTables = map { lc($_) => 1 } $Kernel::OM->Get('Kernel::System::DB')->ListTables();

    my @MissingTables;
    TABLE:
    for my $Table ( @{ $XMLHash[1]->{database}->[1]->{Table} } ) {
        next TABLE if !$Table;

        if ( !$ExistingTables{ lc( $Table->{Name} ) } ) {
            push( @MissingTables, $Table->{Name} );
        }
    }
    if ( !@MissingTables ) {
        $Self->AddResultOk(
            Label => Translatable('Table Presence'),
            Value => '',
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => Translatable('Table Presence'),
            Value   => join( ', ', @MissingTables ),
            Message => Translatable("Tables found which are not present in the database."),
        );
    }

    return $Self->GetResults();
}

1;
