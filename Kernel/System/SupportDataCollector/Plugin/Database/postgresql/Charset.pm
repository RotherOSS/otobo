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

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::Charset;

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

    $DBObject->Prepare( SQL => 'show client_encoding' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] =~ /(UNICODE|utf-?8)/i ) {
            $Self->AddResultOk(
                Identifier => 'ClientEncoding',
                Label      => Translatable('Client Connection Charset'),
                Value      => $Row[0],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ClientEncoding',
                Label      => Translatable('Client Connection Charset'),
                Value      => $Row[0],
                Message    => Translatable('Setting client_encoding needs to be UNICODE or UTF8.'),
            );
        }
    }

    $DBObject->Prepare( SQL => 'show server_encoding' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] =~ /(UNICODE|utf-?8)/i ) {
            $Self->AddResultOk(
                Identifier => 'ServerEncoding',
                Label      => Translatable('Server Database Charset'),
                Value      => $Row[0],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ServerEncoding',
                Label      => Translatable('Server Database Charset'),
                Value      => $Row[0],
                Message    => Translatable('Setting server_encoding needs to be UNICODE or UTF8.'),
            );
        }
    }

    return $Self->GetResults();
}

1;
