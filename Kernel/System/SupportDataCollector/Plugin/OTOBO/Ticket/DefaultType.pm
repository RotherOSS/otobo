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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::Ticket::DefaultType;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Type',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    # check, if Ticket::Type is enabled
    my $TicketType = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type');

    # if not enabled, stop here
    if ( !$TicketType ) {
        return $Self->GetResults();
    }

    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

    # get default ticket type from config
    my $DefaultTicketType = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type::Default');

    # get list of all ticket types
    my %AllTicketTypes = reverse $TypeObject->TypeList();

    if ( $AllTicketTypes{$DefaultTicketType} ) {
        $Self->AddResultOk(
            Label => Translatable('Default Ticket Type'),
            Value => $DefaultTicketType,
        );
    }
    else {
        $Self->AddResultWarning(
            Label   => Translatable('Default Ticket Type'),
            Value   => $DefaultTicketType,
            Message =>
                Translatable(
                    'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.'
                ),
        );
    }

    return $Self->GetResults();
}

1;
