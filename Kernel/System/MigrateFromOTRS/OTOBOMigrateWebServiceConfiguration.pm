# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::MigrateFromOTRS::OTOBOMigrateWebServiceConfiguration;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::Elasticsearch',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Main',
    'Kernel::System::Package',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOMigrateWebServiceConfiguration -  Migrate web service configuration (parameter change for REST/SOAP).

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

=head1 DESCRIPTION

Currently only the web service I<Elasticsearch> is migrated.

=head1 PUBLIC INTERFACE

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success.

    my $RequirementIsMet = $MigrateFromOTRSObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 Run()

Execute the migration task. Called by C<Kernel::System::MigrateFromOTRS::_ExecuteRun()>.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $Epoch       = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOMigrateWebServiceConfiguration',
            SubTask   => 'Prepare.',
            StartTime => $Epoch,
        },
    );

    $CacheObject->CleanUp(
        Type => 'Webservice',
    );

    # Get configuration for the web service Elasticsearch
    my %Webservices = $Self->_GetWebserviceConfigs();
    my %Result      = (
        Message => $Self->{LanguageObject}->Translate('Migrate web service configuration.'),
        Comment => '',
    );

    # Keep track which web services were migrated,
    # because we might need to adapt the SysConfig for these services.
    my %WebserviceWasMigrated;

    WEBSERVICE:
    for my $Name ( sort keys %Webservices ) {

        $Epoch = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task      => 'OTOBOMigrateWebServiceConfiguration',
                SubTask   => "Migrate $Name.",
                StartTime => $Epoch,
            },
        );

        $Result{Comment} .= "$Name: ";

        # check if Elasticsearch is already present
        my $Webservice = $WebserviceObject->WebserviceGet(
            Name => $Name,
        );

        # nothing to do when the web service is already present
        if ( IsHashRefWithData($Webservice) ) {
            $Result{Comment} .= 'use existing; ';

            next WEBSERVICE;
        }

        my $ID = $WebserviceObject->WebserviceAdd(
            Name   => $Name,
            UserID => 1,
            $Webservices{$Name}->%*,
        );

        if ( !$ID ) {
            $Result{Comment} .= $Self->{LanguageObject}->Translate('Failed - see the log!');
            $Result{Successful} = 0;

            return \%Result;
        }

        $Result{Comment} .= 'added; ';
        $WebserviceWasMigrated{$Name} = 1;
    }

    # adapt the SysConfig for specific web services
    if ( $WebserviceWasMigrated{Elasticsearch} ) {
        $Self->_HandleElasticsearch();
    }

    $Result{Successful} = 1;

    return \%Result;
}

# Webservice configuration for Elasticsearch.
# This config assumes that Elasticsearch in running on the host 'elastic' in the Docker case.
# Otherwise Elasticsearch is assumed to run on localhost.
sub _GetWebserviceConfigs {

    my %Invoker = (
        Elasticsearch => {
            CustomerCompanyManagement => {
                Description => '',
                Events      => [
                    {
                        Asynchronous => '0',
                        Event        => 'CustomerCompanyAdd',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'CustomerCompanyUpdate',
                    },
                ],
                Type => 'Elasticsearch::CustomerCompanyManagement',
            },
            CustomerUserManagement => {
                Description => '',
                Events      => [
                    {
                        Asynchronous => '0',
                        Event        => 'CustomerUserAdd',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'CustomerUserUpdate',
                    },
                ],
                Type => 'Elasticsearch::CustomerUserManagement',
            },
            Search => {
                Description => '',
                Type        => 'Elasticsearch::Search',
            },
            TicketIngestAttachment => {
                Description => '',
                Type        => 'Elasticsearch::TicketManagement',
            },
            TicketManagement => {
                Description => '',
                Events      => [
                    {
                        Asynchronous => '0',
                        Event        => 'TicketCreate',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'ArticleCreate',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'TicketCustomerUpdate',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'TicketQueueUpdate',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'TicketTitleUpdate',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'QueueUpdate',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'TicketDelete',
                    },
                    {
                        Asynchronous => '0',
                        Event        => 'TicketArchiveFlagUpdate',
                    },
                ],
                Type => 'Elasticsearch::TicketManagement',
            },
            UtilsIngest_DELETE => {
                Description => '',
                Type        => 'Elasticsearch::Utils',
            },
            UtilsIngest_GET => {
                Description => '',
                Type        => 'Elasticsearch::Utils',
            },
            UtilsPipeline_DELETE => {
                Description => '',
                Type        => 'Elasticsearch::Utils',
            },
            UtilsPipeline_PUT => {
                Description => '',
                Type        => 'Elasticsearch::Utils',
            },
            Utils_DELETE => {
                Description => '',
                Type        => 'Elasticsearch::Utils',
            },
            Utils_GET => {
                Description => '',
                Type        => 'Elasticsearch::Utils',
            },
            Utils_PUT => {
                Description => '',
                Type        => 'Elasticsearch::Utils',
            },
        }
    );

    my %ICMapping = (
        Elasticsearch => {
            CustomerCompanyManagement => {
                Command    => 'POST',
                Controller => '/customer/:docapi/:id',
            },
            CustomerUserManagement => {
                Command    => 'POST',
                Controller => '/customeruser/:docapi/:id',
            },
            Search => {
                Command    => 'POST',
                Controller => '/:index/_search',
            },
            TicketIngestAttachment => {
                Command    => 'POST',
                Controller => '/tmpattachments/:docapi/:id?pipeline=:path',
            },
            TicketManagement => {
                Command    => 'POST',
                Controller => '/ticket/:docapi/:id',
            },
            UtilsIngest_DELETE => {
                Command    => 'DELETE',
                Controller => '/:index/:docapi/:id',
            },
            UtilsIngest_GET => {
                Command    => 'GET',
                Controller => '/:index/:docapi/:id',
            },
            UtilsPipeline_DELETE => {
                Command    => 'DELETE',
                Controller => '/_ingest/pipeline/Attachments',
            },
            UtilsPipeline_PUT => {
                Command    => 'PUT',
                Controller => '/_ingest/pipeline/Attachments',
            },
            Utils_DELETE => {
                Command    => 'DELETE',
                Controller => '/:index',
            },
            Utils_GET => {
                Command    => 'GET',
                Controller => '/:index',
            },
            Utils_PUT => {
                Command    => 'PUT',
                Controller => '/:index',
            },
        },
    );

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    if ( $PackageObject->PackageIsInstalled( Name => 'ITSMConfigurationManagement' ) ) {
        $Invoker{Elasticsearch}{ConfigItemIngestAttachment} = {
            Description => '',
            Type        => 'Elasticsearch::ConfigItemManagement',
        };
        $Invoker{Elasticsearch}{ConfigItemManagement} = {
            Description => '',
            Events      => [
                {
                    Asynchronous => '0',
                    Event        => 'ConfigItemCreate',
                },
                {
                    Asynchronous => '0',
                    Event        => 'VersionCreate',
                },
                {
                    Asynchronous => '0',
                    Event        => 'AttachmentAddPost',
                },
                {
                    Asynchronous => '0',
                    Event        => 'AttachmentDeletePost',
                },
                {
                    Asynchronous => '0',
                    Event        => 'ConfigItemDelete',
                },
            ],
            Type => 'Elasticsearch::ConfigItemManagement',
        };

        $ICMapping{Elasticsearch}{ConfigItemIngestAttachment} = {
            Command    => 'POST',
            Controller => '/tmpattachments/:docapi/:id?pipeline=:path',
        };
        $ICMapping{Elasticsearch}{ConfigItemManagement} = {
            Command    => 'POST',
            Controller => '/configitem/:docapi/:id',
        };
    }

    # some heuristics for where Elasticsearch is running.
    my $ElasticsearchPort = 9200;
    my $ElasticsearchHost = $ENV{OTOBO_RUNS_UNDER_DOCKER} ? 'elastic' : 'localhost';

    return
        Elasticsearch => {
            ValidID => 2,
            Config  => {
                Debugger => {
                    DebugThreshold => 'error',
                    TestMode       => '0',
                },
                Description => '',
                Provider    => {
                    Transport => {
                        Type => '',
                    },
                },
                RemoteSystem => '',
                Requester    => {
                    Invoker   => $Invoker{Elasticsearch},
                    Transport => {
                        Config => {
                            DefaultCommand           => 'POST',
                            Host                     => "http://$ElasticsearchHost:$ElasticsearchPort",
                            InvokerControllerMapping => $ICMapping{Elasticsearch},
                            Timeout                  => '30',
                        },
                        Type => 'HTTP::REST',
                    },
                }
            },
        };
}

# adapt the SysConfig for Elasticsearch
# no error handling is implemented
sub _HandleElasticsearch {
    my ($Self) = @_;

    # try initializing Elasticsearch
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $ESWebservice     = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    # activate it
    if ($ESWebservice) {
        my $Success = $WebserviceObject->WebserviceUpdate(
            %{$ESWebservice},
            ValidID => 1,
            UserID  => 1,
        );

        return unless $Success;
    }

    # test the connection
    my $ESObject = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    return unless $ESObject->TestConnection();

    # try to set up Elasticsearch, ignoring errors
    $ESObject->InitialSetup();

    return;
}

1;
