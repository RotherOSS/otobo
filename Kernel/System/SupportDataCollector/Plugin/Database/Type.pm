# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::SupportDataCollector::Plugin::Database::Type;

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

    my $Type = $DBObject->GetDatabaseFunction('Type') // '';

    # just a sanity check
    if ( $Type =~ m/[a-zA-Z]/ ) {
        $Self->AddResultOk(
            Identifier => 'DatabaseType',
            Label      => Translatable('Database Type'),
            Value      => $Type,
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'DatabaseType',
            Label      => Translatable('Database Type'),
            Value      => $Type,
            Message    => Translatable('The type auf the database looks strange as it contain no latin letters.')
        );
    }

    return $Self->GetResults();
}

1;
