# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Console::Command::Maint::Elasticsearch::Migration;

use strict;
use warnings;

use Time::HiRes();

use parent qw(Kernel::System::Console::BaseCommand);

## nofilter(TidyAll::Plugin::OTOBO::Perl::ForeachToFor)

our @ObjectDependencies = (
    'Kernel::System::Elasticsearch',
    'Kernel::Config',
    'Kernel::System::CustomerCompany',
    'Kernel::System::CustomerUser',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Migrate existing tickets, customers and customerusers to Elasticsearch.');
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check whether elastic search web service is enabled and if not, activate it
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $ESWebservice = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    if ( !$ESWebservice ) {
        $Self->Print("<red>Elasticsearch webservice not found! Unable to continue.</red>\n");
        die;
    }

    if ( $ESWebservice->{ValidID} != 1 ) {
        $Self->Print(
            "<yellow>Elasticsearch webservice is now activated. If you don't want to keep it enabled, please disable it manually in the admin interface, after the migration is complete.</yellow>\n"
        );
        my $Success = $WebserviceObject->WebserviceUpdate(
            %{$ESWebservice},
            ValidID => 1,
            UserID  => 1,
        );

        if ( !$Success ) {
            $Self->Print("<red>Elasticsearch webservice could not be activated! Unable to continue.</red>\n");
            die;
        }
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ESObject     = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # test the connection to the server
    if ( !$ESObject->TestConnection() ) {
        $Self->Print("<red>Connection could not be established!</red>\n");
        return 0;
    }

    # Migrate ticket and articles
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my @TicketIDs = $TicketObject->TicketSearch(
        Result     => 'ARRAY',
        Limit      => 100_000_000,
        UserID     => 1,
        Permission => 'ro',
    );

    # Drop existing ticket index
    my %IndexName = (
        index => 'ticket',
    );

    my $Success = $ESObject->DropIndex(
        IndexName => \%IndexName,
    );

    # Create Index
    my $NShards   = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::ArticleIndexCreationSettings')->{NS};
    my $NReplicas = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::ArticleIndexCreationSettings')->{NR};

    my %Request = (
        settings => {
            index => {
                number_of_shards   => $NShards,
                number_of_replicas => $NReplicas,
            },
            'index.mapping.total_fields.limit' => 2000,
        },
        mappings => {
            properties => {
                GroupID => {
                    type => 'integer',
                },
                QueueID => {
                    type => 'integer',
                },
                CustomerID => {
                    type => 'keyword',
                },
                CustomerUserID => {
                    type => 'keyword',
                },
            }
        }
    );

    $Success = $ESObject->CreateIndex(
        IndexName => \%IndexName,
        Request   => \%Request,
    );

    if ($Success) {
        $Self->Print("<green>Ticket index created.</green>\n");
    }
    else {
        $Self->Print("<red>Ticket index could not be created!</red>\n");
        return 0;
    }

    # put the attachment pipeline to the ticket index
    $Success = $ESObject->DeletePipeline();

    my %Pipeline = (
        description => "Extract external attachment information",
        processors  => [
            {
                foreach => {
                    field     => "Attachments",
                    processor => {
                        attachment => {
                            target_field => "_ingest._value.attachment",
                            field        => "_ingest._value.data"
                        }
                    }
                }
            },
            {
                foreach => {
                    field     => "Attachments",
                    processor => {
                        remove => {
                            field => "_ingest._value.data"
                        }
                    }
                }
            }
        ]
    );
    $Success = $ESObject->CreatePipeline(
        Request => \%Pipeline,
    );
    if ($Success) {
        $Self->Print("<green>Pipeline set up.</green>\n");
    }
    else {
        $Self->Print("<red>Pipeline could not be set up!</red>\n");
        return 0;
    }

    my $Count      = 0;
    my $MicroSleep = $Self->GetOption('micro-sleep');

    my $Percent10 = ( sort { $a <=> $b } ( 10, int( $#TicketIDs / 10 ) ) )[1];
    my $Percent1  = ( sort { $a <=> $b } ( 1,  int( $#TicketIDs / 100 ) ) )[1];

    if ( $#TicketIDs > 100 ) {
        $Self->Print("<yellow>Tickets are transfered. This can take a while.</yellow>\n");
    }

    TICKETID:
    for my $TicketID (@TicketIDs) {

        $Count++;

        # create the ticket
        $ESObject->TicketCreate(
            TicketID => $TicketID,
        );

        # create the articles
        my @ArticleList = $ArticleObject->ArticleList( TicketID => $TicketID );
        for my $Article (@ArticleList) {
            $ESObject->ArticleCreate(
                TicketID  => $TicketID,
                ArticleID => $Article->{ArticleID},
            );
        }

        # show progress and potentially sleep
        if ( $Count % $Percent10 == 0 ) {
            my $Percent = int( $Count / ( $#TicketIDs / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$#TicketIDs</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }
        elsif ( $#TicketIDs > 50 && $Count % $Percent1 == 0 ) {
            $Self->Print(". ");
        }

        Time::HiRes::usleep($MicroSleep) if $MicroSleep;
    }

    $Self->Print("<green>Ticket transfer complete.</green>\n");

    # Migrate customercompany
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my %CustomerCompanyList   = $CustomerCompanyObject->CustomerCompanyList();

    %IndexName = (
        index => 'customer',
    );
    $Success = $ESObject->DropIndex(
        IndexName => \%IndexName,
    );

    %Request = (
        settings => {
            index => {
                number_of_shards   => $NShards,
                number_of_replicas => $NReplicas,
            },
            'index.mapping.total_fields.limit' => 2000,
        },
        mappings => {
            properties => {
                CustomerID => {
                    type => 'keyword',
                },
            }
        },
    );

    $Success = $ESObject->CreateIndex(
        IndexName => \%IndexName,
        Request   => \%Request,
    );

    if ($Success) {
        $Self->Print("<green>Customer index created.</green>\n");
    }
    else {
        $Self->Print("<red>Customer index could not be created!</red>\n");
        return 0;
    }

    $Count = 0;
    my $CustomerCount = scalar( keys %CustomerCompanyList );

    CUSTOMERID:
    for my $CustomerID ( sort keys %CustomerCompanyList ) {

        $Count++;

        # create the ticket
        $ESObject->CustomerCompanyAdd(
            CustomerID => $CustomerID,
        );

        # show progress and potentially sleep
        if ( $Count % 500 == 0 ) {
            my $Percent = int( $Count / ( $CustomerCount / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$CustomerCount</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }

        Time::HiRes::usleep($MicroSleep) if $MicroSleep;
    }

    $Self->Print("<green>CustomerCompany transfer complete.</green>\n");

    # Migrate customeruser
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my %CustomerUserList   = $CustomerUserObject->CustomerSearch(
        UserLogin => '*',
        Valid     => 1,
    );

    %IndexName = (
        index => 'customeruser',
    );
    $Success = $ESObject->DropIndex(
        IndexName => \%IndexName
    );

    %Request = (
        settings => {
            index => {
                number_of_shards   => $NShards,
                number_of_replicas => $NReplicas,
            },
            'index.mapping.total_fields.limit' => 2000,
        },
        mappings => {
            properties => {
                UserLogin => {
                    type => 'keyword',
                },
            }
        }
    );

    $Success = $ESObject->CreateIndex(
        IndexName => \%IndexName,
        Request   => \%Request,
    );

    if ($Success) {
        $Self->Print("<green>CustomerUser index created.</green>\n");
    }
    else {
        $Self->Print("<red>CustomerUser index could not be created!</red>\n");
        return 0;
    }

    $Count = 0;
    my $CustomerUserCount = scalar( keys %CustomerUserList );

    CUSTOMERUSERID:
    for my $CustomerUserID ( sort keys %CustomerUserList ) {

        $Count++;

        # create the ticket
        $ESObject->CustomerUserAdd(
            UserLogin => $CustomerUserID,
        );

        # show progress and potentially sleep
        if ( $Count % 500 == 0 ) {
            my $Percent = int( $Count / ( $CustomerUserCount / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$CustomerUserCount</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }

        Time::HiRes::usleep($MicroSleep) if $MicroSleep;
    }

    $Self->Print("<green>CustomerUser transfer complete.</green>\n");

    return $Self->ExitCodeOk();
}

1;
