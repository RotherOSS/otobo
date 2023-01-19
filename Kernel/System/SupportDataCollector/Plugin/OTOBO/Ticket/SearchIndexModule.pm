# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::Ticket::SearchIndexModule;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    my $ForceUnfilteredStorage = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndex::ForceUnfilteredStorage');

    if ($ForceUnfilteredStorage) {
        $Self->AddResultWarning(
            Label   => Translatable('Ticket Search Index Module'),
            Value   => 'Ticket::SearchIndex::ForceUnfilteredStorage',
            Message =>
                Translatable(
                    'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.'
                ),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Ticket Search Index Module'),
            Value => 'Ticket::SearchIndex::ForceUnfilteredStorage',
        );
    }

    return $Self->GetResults();
}

1;
