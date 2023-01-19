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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::DatabaseRecords;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Ticket',
);

sub GetDisplayPath {
    return Translatable('OTOBO') . '/' . Translatable('Database Records');
}

sub Run {
    my $Self = shift;

    my @Checks = (
        {
            SQL        => "SELECT count(*) FROM ticket",
            Identifier => 'TicketCount',
            Label      => Translatable("Tickets"),
        },
        {
            SQL        => "SELECT count(*) FROM ticket_history",
            Identifier => 'TicketHistoryCount',
            Label      => Translatable("Ticket History Entries"),
        },
        {
            SQL        => "SELECT count(*) FROM article",
            Identifier => 'ArticleCount',
            Label      => Translatable("Articles"),
        },
        {
            SQL =>
                "SELECT count(*) from article_data_mime_attachment WHERE content_type NOT LIKE 'text/html%'",
            Identifier => 'AttachmentCountDBNonHTML',
            Label      => Translatable("Attachments (DB, Without HTML)"),
        },
        {
            SQL        => "SELECT count(DISTINCT(customer_user_id)) FROM ticket",
            Identifier => 'DistinctTicketCustomerCount',
            Label      => Translatable("Customers With At Least One Ticket"),
        },
        {
            SQL        => "SELECT count(*) FROM queue",
            Identifier => 'QueueCount',
            Label      => Translatable("Queues"),
        },
        {
            SQL        => "SELECT count(*) FROM service",
            Identifier => 'ServiceCount',
            Label      => Translatable("Services"),
        },
        {
            SQL        => "SELECT count(*) FROM users",
            Identifier => 'AgentCount',
            Label      => Translatable("Agents"),
        },
        {
            SQL        => "SELECT count(*) FROM roles",
            Identifier => 'RoleCount',
            Label      => Translatable("Roles"),
        },
        {
            SQL        => "SELECT count(*) FROM groups_table",
            Identifier => 'GroupCount',
            Label      => Translatable("Groups"),
        },
        {
            SQL        => "SELECT count(*) FROM dynamic_field",
            Identifier => 'DynamicFieldCount',
            Label      => Translatable("Dynamic Fields"),
        },
        {
            SQL        => "SELECT count(*) FROM dynamic_field_value",
            Identifier => 'DynamicFieldValueCount',
            Label      => Translatable("Dynamic Field Values"),
        },
        {
            SQL        => "SELECT count(*) FROM dynamic_field WHERE valid_id > 1",
            Identifier => 'InvalidDynamicFieldCount',
            Label      => Translatable("Invalid Dynamic Fields"),
        },
        {
            SQL => "
                SELECT count(*)
                FROM dynamic_field_value
                    JOIN dynamic_field ON dynamic_field.id = dynamic_field_value.field_id
                WHERE dynamic_field.valid_id > 1",
            Identifier => 'InvalidDynamicFieldValueCount',
            Label      => Translatable("Invalid Dynamic Field Values"),
        },
        {
            SQL        => "SELECT count(*) FROM gi_webservice_config",
            Identifier => 'WebserviceCount',
            Label      => Translatable("GenericInterface Webservices"),
        },
        {
            SQL        => "SELECT count(*) FROM pm_process",
            Identifier => 'ProcessCount',
            Label      => Translatable("Processes"),
        },
        {
            SQL => "
                SELECT count(*)
                FROM dynamic_field df
                    LEFT JOIN dynamic_field_value dfv ON df.id = dfv.field_id
                    RIGHT JOIN ticket t ON t.id = dfv.object_id
                WHERE df.name = '"
                . $Kernel::OM->Get('Kernel::Config')->Get("Process::DynamicFieldProcessManagementProcessID") . "'",
            Identifier => 'ProcessTickets',
            Label      => Translatable("Process Tickets"),
        },
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %Counts;
    CHECK_RECORDS:
    for my $Check (@Checks) {
        $DBObject->Prepare( SQL => $Check->{SQL} );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Counts{ $Check->{Identifier} } = $Row[0];
        }

        if ( defined $Counts{ $Check->{Identifier} } ) {
            $Self->AddResultInformation(
                Identifier => $Check->{Identifier},
                Label      => $Check->{Label},
                Value      => $Counts{ $Check->{Identifier} },
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => $Check->{Identifier},
                Label      => $Check->{Label},
                Value      => $Counts{ $Check->{Identifier} },
                Message    => Translatable('Could not determine value.'),
            );
        }
    }

    $DBObject->Prepare(
        SQL => "SELECT max(create_time), min(create_time) FROM ticket WHERE id > 1 ",
    );
    my $TicketWindowTime = 1;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] && $Row[1] ) {
            my $OldestCreateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Row[0],
                },
            );
            my $NewestCreateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Row[1],
                },
            );
            my $Delta = $NewestCreateTimeObject->Delta( DateTimeObject => $OldestCreateTimeObject );
            $TicketWindowTime = ( $Delta->{Years} * 12 ) + $Delta->{Months};
        }
    }
    $TicketWindowTime = 1 if $TicketWindowTime < 1;

    $Self->AddResultInformation(
        Identifier => 'TicketWindowTime',
        Label      => Translatable('Months Between First And Last Ticket'),
        Value      => $TicketWindowTime,
    );
    $Self->AddResultInformation(
        Identifier => 'TicketsPerMonth',
        Label      => Translatable('Tickets Per Month (avg)'),
        Value      => sprintf( "%d", $Counts{TicketCount} / $TicketWindowTime ),
    );

    my $OpenTickets = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        Result    => 'COUNT',
        StateType => 'Open',
        UserID    => 1,
    ) || 0;

    $Self->AddResultInformation(
        Identifier => 'TicketOpenCount',
        Label      => Translatable('Open Tickets'),
        Value      => $OpenTickets,
    );

    return $Self->GetResults();
}

1;
