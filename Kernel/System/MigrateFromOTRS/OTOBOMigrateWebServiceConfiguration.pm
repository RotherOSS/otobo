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

package Kernel::System::MigrateFromOTRS::OTOBOMigrateWebServiceConfiguration;    ## no critic

use strict;
use warnings;

use parent qw(Kernel::System::MigrateFromOTRS::Base);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::XML',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOMigrateWebServiceConfiguration -  Migrate web service configuration (parameter change for REST/SOAP).

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

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

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Epoch          = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOMigrateWebServiceConfiguration',
            SubTask   => "Migrate webservices and add OTOBO ElasticSearch services.",
            StartTime => $Epoch,
        },
    );

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $WebserviceList = $WebserviceObject->WebserviceList(
        Valid => 0,
    );
    if ( !IsHashRefWithData($WebserviceList) ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Migrate web service configuration.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("No web service existent, done.");
        $Result{Successful} = 1;
        return \%Result;
    }
    WEBSERVICEID:
    for my $WebserviceID ( sort keys %{$WebserviceList} ) {

        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );
        next WEBSERVICEID if !IsHashRefWithData($WebserviceData);

        # Check if web service is using an old configuration type and upgrade if necessary.
        $WebserviceObject->_WebserviceConfigUpgrade( %{$WebserviceData} );

        # set and write updated config
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => 1,
        );
    }

    # Add webservice for ElasticSearch
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Create database tables and insert initial values.
    my @SQLPost;

    # Check/get SQL schema directory
    my $DBXMLFile = $ConfigObject->Get('Home') . '/scripts/webservices/otobo-initial_insert-webservice.xml';

    if ( ! -f $DBXMLFile ) {
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Migrate web service configuration.");
        $Result{Comment} = $Self->{LanguageObject}
            ->Translate( 'Can\'t add web service for Elasticsearch. File %s not found!', $DBXMLFile );
        $Result{Successful} = 0;

        return \%Result;
    }
    my $XML = $MainObject->FileRead(
        Location => $DBXMLFile,
    );
    my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse(
        String => $XML,
    );

    my @SQL = $DBObject->SQLProcessor(
        Database => \@XMLArray,
    );

    my %Result;
    $Result{Message} = $Self->{LanguageObject}->Translate("Migrate web service configuration.");
    $Result{Comment} = $Self->{LanguageObject}->Translate(
        "Migration completed. Please activate the web service in Admin -> Web Service when ElasticSearch installation is completed."
    );
    $Result{Successful} = 1;

    return \%Result;
}

1;
