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

package Kernel::System::SupportDataCollector::Plugin::Database::oracle::NLS;

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

    if ( $DBObject->GetDatabaseFunction('Type') ne 'oracle' ) {
        return $Self->GetResults();
    }

    if ( $ENV{NLS_LANG} && $ENV{NLS_LANG} =~ m/al32utf-?8/i ) {
        $Self->AddResultOk(
            Identifier => 'NLS_LANG',
            Label      => Translatable('NLS_LANG Setting'),
            Value      => $ENV{NLS_LANG},
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_LANG',
            Label      => Translatable('NLS_LANG Setting'),
            Value      => $ENV{NLS_LANG},
            Message    => Translatable('NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).'),
        );
    }

    if ( $ENV{NLS_DATE_FORMAT} && $ENV{NLS_DATE_FORMAT} eq "YYYY-MM-DD HH24:MI:SS" ) {
        $Self->AddResultOk(
            Identifier => 'NLS_DATE_FORMAT',
            Label      => Translatable('NLS_DATE_FORMAT Setting'),
            Value      => $ENV{NLS_DATE_FORMAT},
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_DATE_FORMAT',
            Label      => Translatable('NLS_DATE_FORMAT Setting'),
            Value      => $ENV{NLS_DATE_FORMAT},
            Message    => Translatable("NLS_DATE_FORMAT must be set to 'YYYY-MM-DD HH24:MI:SS'."),
        );
    }

    my $CreateTime;
    $DBObject->Prepare(
        SQL   => "SELECT create_time FROM valid",
        Limit => 1
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CreateTime = $Row[0];
    }

    if (
        $CreateTime
        && $CreateTime =~ /^\d\d\d\d-(\d|\d\d)-(\d|\d\d)\s(\d|\d\d):(\d|\d\d):(\d|\d\d)/
        )
    {
        $Self->AddResultOk(
            Identifier => 'NLS_DATE_FORMAT_SELECT',
            Label      => Translatable('NLS_DATE_FORMAT Setting SQL Check'),
            Value      => $ENV{NLS_DATE_FORMAT},                               # use environment variable to avoid different values
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_DATE_FORMAT_SELECT',
            Label      => Translatable('NLS_DATE_FORMAT Setting SQL Check'),
            Value      => $CreateTime,
            Message    => Translatable("NLS_DATE_FORMAT must be set to 'YYYY-MM-DD HH24:MI:SS'."),
        );
    }

    return $Self->GetResults();
}

1;
