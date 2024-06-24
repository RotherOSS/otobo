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

package Kernel::System::Console::Command::Maint::Elasticsearch::Migration;

use strict;
use warnings;

use Time::HiRes();

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::Console::BaseCommand);

## nofilter(TidyAll::Plugin::OTOBO::Perl::ForeachToFor)

# Inform the object manager about the hard dependencies.
# This module must be discarded when one of the hard dependencies has been discarded.
our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerCompany',
    'Kernel::System::CustomerUser',
    'Kernel::System::Elasticsearch',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Package',
);

# Inform the CodePolicy about the soft dependencies that are intentionally not in @ObjectDependencies.
# Soft dependencies are modules that used by this object, but who don't affect the state of this object.
# There is no need to discard this module when one of the soft dependencies is discarded.
our @SoftObjectDependencies = (
    'Kernel::System::GeneralCatalog',
    'Kernel::System::ITSMConfigItem',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Migrate existing tickets, customers and customerusers to Elasticsearch.');
    $Self->AddOption(
        Name        => 'target',
        Description =>
            "Specify which objects will be migrated. t: Tickets; u: CustomerUsers; c: CustomerCompanies; i: ITSMConfigItems; If not specified, 'tuci' (all four) will be handled.",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/^[tuci]+$/smx,
    );
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    $Self->AddOption(
        Name        => 'use-customer-batches',
        Description =>
            "Some LDAP or AD servers limit the return of results. In this case we can still get all the results by splitting the queries. 1: splits the queries into searches for a-z, a0-z9, 0-9. 2: aa-zz, a0-z9 and 0-9.",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/^\d$/smx,
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

    my $ESObject            = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $Config              = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::ArticleIndexCreationSettings');
    my $ConfigIndexSettings = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::IndexSettings');
    my $IndexTemplates      = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::IndexTemplate');

    # prefer Elasticsearch::IndexSettings###Default over Elasticsearch::ArticleIndexCreationSettings
    if ( $ConfigIndexSettings && $ConfigIndexSettings->{Default} ) {
        $Config = $ConfigIndexSettings->{Default};
    }

    # test the connection to the server
    if ( !$ESObject->TestConnection() ) {
        $Self->Print("<red>Connection could not be established!</red>\n");

        return 0;
    }

    my $Targets            = $Self->GetOption('target') || 'tuci';
    my $MicroSleep         = $Self->GetOption('micro-sleep');
    my $CustomerLimitLevel = $Self->GetOption('use-customer-batches') || '0';

    if ( $Targets =~ m/t|i/ ) {
        $Self->CreateAttachmentPipeline(
            ESObject => $ESObject,
        );
    }

    if ( $Targets =~ m/c/ ) {
        $Self->MigrateCompanies(
            ESObject => $ESObject,
            Config   => $ConfigIndexSettings->{Customer} // $Config,
            Template => $IndexTemplates->{Customer}      // $IndexTemplates->{Default},
            Sleep    => $MicroSleep,
        );
    }

    if ( $Targets =~ /u/ ) {
        $Self->MigrateCustomerUsers(
            ESObject   => $ESObject,
            Config     => $ConfigIndexSettings->{CustomerUser} // $Config,
            Template   => $IndexTemplates->{CustomerUser}      // $IndexTemplates->{Default},
            Sleep      => $MicroSleep,
            LimitLevel => $CustomerLimitLevel
        );
    }

    if ( $Targets =~ /t/ ) {
        $Self->MigrateTickets(
            ESObject => $ESObject,
            Config   => $ConfigIndexSettings->{Ticket} // $Config,
            Template => $IndexTemplates->{Ticket}      // $IndexTemplates->{Default},
            Sleep    => $MicroSleep,
        );
    }

    if ( $Targets =~ /i/ ) {
        $Self->MigrateConfigItems(
            ESObject => $ESObject,
            Config   => $ConfigIndexSettings->{ConfigItem} // $Config,
            Template => $IndexTemplates->{ConfigItem}      // $IndexTemplates->{Default},
            Sleep    => $MicroSleep,
        );
    }

    return $Self->ExitCodeOk();
}

sub CreateAttachmentPipeline {
    my ( $Self, %Param ) = @_;

    # setup the attachment pipeline
    my $Success = $Param{ESObject}->DeletePipeline();

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

    $Success = $Param{ESObject}->CreatePipeline(
        Request => \%Pipeline,
    );

    if ($Success) {
        $Self->Print("<green>Attachment pipeline set up.</green>\n");
    }
    else {
        $Self->Print("<red>Attachment pipeline could not be set up!</red>\n");

        return 0;
    }

    return 1;
}

sub MigrateCompanies {
    my ( $Self, %Param ) = @_;

    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my %CustomerCompanyList   = $CustomerCompanyObject->CustomerCompanyList(
        Limit => 0,
    );

    my %IndexName = (
        index => 'customer',
    );
    my $Success = $Param{ESObject}->DropIndex(
        IndexName => \%IndexName,
    );
    if ( !$Success ) {
        $Self->Print(
            "<yellow>The previous error messages are likely the result of trying to drop a nonexistent index and can then be ignored.</yellow>\n"
        );
    }

    my $IndexSettings = $Param{ESObject}->IndexSettingsGet(%Param);
    if ( !$IndexSettings ) {

        # Error is shown in IndexSettingsGet
        return 0;
    }

    my %Request = (
        settings => $IndexSettings,
        mappings => {
            properties => {
                CustomerID => {
                    type => 'keyword',
                },
            }
        },
    );

    $Success = $Param{ESObject}->CreateIndex(
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

    # return if no StoreFields are defined
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::CustomerCompanyStoreFields') ) {
        $Self->Print("<yellow>No CustomerCompanyStoreFields are defined.</yellow>\n");

        return 1;
    }

    my $Count         = 0;
    my $CustomerCount = scalar keys %CustomerCompanyList;

    my $Errors = 0;
    CUSTOMERID:
    for my $CustomerID ( sort keys %CustomerCompanyList ) {

        $Count++;

        # create the company in Elasticsearch
        if ( !$Param{ESObject}->CustomerCompanyAdd( CustomerID => $CustomerID ) ) {
            $Errors++;
        }

        # show progress and potentially sleep
        if ( $Count % 500 == 0 ) {
            my $Percent = int( $Count / ( $CustomerCount / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$CustomerCount</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }

        Time::HiRes::usleep( $Param{Sleep} ) if $Param{Sleep};
    }

    if ($Errors) {
        $Self->Print("<yellow>CustomerCompany transfer complete. $Errors error(s) occured!</yellow>\n");
    }
    else {
        $Self->Print("<green>CustomerCompany transfer complete. Transferred $Count companies.</green>\n");
    }

    return 1;
}

sub MigrateCustomerUsers {
    my ( $Self, %Param ) = @_;

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my %CustomerUserList;
    my $CustomerLimitLevel = $Param{LimitLevel};

    # No special search, search all customers together
    if ( $CustomerLimitLevel == 0 ) {
        %CustomerUserList = $CustomerUserObject->CustomerSearch(
            Search => '*',
            Valid  => 1,
            Limit  => 4_000_000,
        );
    }
    elsif ( $CustomerLimitLevel >= 1 ) {

        # Search with CustomerUserLimit x a..z
        for my $Letter ( "a" x $CustomerLimitLevel .. "z" x $CustomerLimitLevel, 'a0' .. 'z9', '0' .. '9' ) {

            $Self->Print(
                "<green>Search for all customeruser like: $Letter*.</green>\n"
            );

            my %CustomerUserListNew = $CustomerUserObject->CustomerSearch(
                Search => $Letter . '*',
                Valid  => 1,
                Limit  => 4_000_000,
            );

            %CustomerUserList = ( %CustomerUserList, %CustomerUserListNew );
        }
    }

    my %IndexName = (
        index => 'customeruser',
    );
    my $Success = $Param{ESObject}->DropIndex(
        IndexName => \%IndexName
    );
    if ( !$Success ) {
        $Self->Print(
            "<yellow>Previous error messages are likely the result of trying to drop a nonexistent index and can then be ignored.</yellow>\n"
        );
    }

    my $IndexSettings = $Param{ESObject}->IndexSettingsGet(%Param);
    if ( !$IndexSettings ) {

        # Error is shown in IndexSettingsGet
        return 0;
    }

    my %Request = (
        settings => $IndexSettings,
        mappings => {
            properties => {
                UserLogin => {
                    type => 'keyword',
                },
            }
        }
    );

    $Success = $Param{ESObject}->CreateIndex(
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

    # return if no StoreFields are defined
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::CustomerUserStoreFields') ) {
        $Self->Print("<yellow>No CustomerUserStoreFields are defined.</yellow>\n");
        return 1;
    }

    my $Count             = 0;
    my $CustomerUserCount = scalar keys %CustomerUserList;

    my $Errors = 0;
    CUSTOMERUSERID:
    for my $CustomerUserID ( sort keys %CustomerUserList ) {

        $Count++;

        # create the customer user in Elasticsearch
        if ( !$Param{ESObject}->CustomerUserAdd( UserLogin => $CustomerUserID ) ) {
            $Errors++;
        }

        # show progress and potentially sleep
        if ( $Count % 500 == 0 ) {
            my $Percent = int( $Count / ( $CustomerUserCount / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$CustomerUserCount</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }

        Time::HiRes::usleep( $Param{Sleep} ) if $Param{Sleep};
    }

    if ($Errors) {
        $Self->Print("<yellow>CustomerUser transfer complete. $Errors error(s) occured!</yellow>\n");
    }
    else {
        $Self->Print("<green>CustomerUser transfer complete. Transferred $Count customer users.</green>\n");
    }

    return 1;
}

sub MigrateTickets {
    my ( $Self, %Param ) = @_;

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

    my $Success = $Param{ESObject}->DropIndex(
        IndexName => \%IndexName,
    );
    if ( !$Success ) {
        $Self->Print(
            "<yellow>Previous error messages are likely the result of trying to drop a nonexistent index and can then be ignored.</yellow>\n"
        );
    }

    my $IndexSettings = $Param{ESObject}->IndexSettingsGet(%Param);
    if ( !$IndexSettings ) {

        # Error is shown in IndexSettingsGet
        return 0;
    }

    my %Request = (
        settings => $IndexSettings,
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

    $Success = $Param{ESObject}->CreateIndex(
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

    # return if no StoreFields are defined
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::TicketStoreFields') ) {
        $Self->Print("<yellow>No TicketStoreFields are defined.</yellow>\n");

        return 1;
    }

    my $Count     = 0;
    my $Percent10 = ( sort { $a <=> $b } ( 10, int( $#TicketIDs / 10 ) ) )[1];
    my $Percent1  = ( sort { $a <=> $b } ( 1,  int( $#TicketIDs / 100 ) ) )[1];

    if ( $#TicketIDs > 100 ) {
        $Self->Print(
            "<yellow>Tickets are transfered. This can take several hours, depending on the number of tickets.</yellow>\n"
        );
    }

    my $Errors = 0;
    TICKETID:
    for my $TicketID (@TicketIDs) {

        $Count++;

        # create the ticket
        if ( !$Param{ESObject}->TicketCreate( TicketID => $TicketID ) ) {
            $Errors++;
        }

        # create the articles
        my @ArticleList = $ArticleObject->ArticleList( TicketID => $TicketID );
        for my $Article (@ArticleList) {
            $Success = $Param{ESObject}->ArticleCreate(
                TicketID  => $TicketID,
                ArticleID => $Article->{ArticleID},
            );
            $Errors++ if !$Success;
        }

        # show progress and potentially sleep
        if ( $Count % $Percent10 == 0 ) {
            my $Percent = int( $Count / ( $#TicketIDs / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$#TicketIDs</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }
        elsif ( $#TicketIDs > 50 && $Count % $Percent1 == 0 ) {
            $Self->Print('. ');
            select()->flush();    # show the dot immediately
        }

        Time::HiRes::usleep( $Param{Sleep} ) if $Param{Sleep};
    }

    if ($Errors) {
        $Self->Print("<yellow>Ticket transfer complete. $Errors error(s) occured!</yellow>\n");
    }
    else {
        $Self->Print("<green>Ticket transfer complete. Transferred $Count tickets.</green>\n");
    }

    return 1;
}

sub MigrateConfigItems {
    my ( $Self, %Param ) = @_;

    # check whether ITSMConfigurationManagment is installed
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $IsInstalled   = $PackageObject->PackageIsInstalled(
        Name => 'ITSMConfigurationManagement',
    );
    if ( !$IsInstalled ) {
        $Self->Print("<green>Skipping ITSMConfigItems (ITSMConfigurationManagment not installed)...</green>\n");

        return 1;
    }

    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ClassList            = $GeneralCatalogObject->ItemList(
        Class => 'ITSM::ConfigItem::Class',
    );

    my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');

    my $ExcludedClasses = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::ExcludedCIClasses');
    $ExcludedClasses = { map { $_ => 1 } @{$ExcludedClasses} };

    my @ActiveClasses;
    CLASS:
    for my $Class ( keys %{$ClassList} ) {
        next CLASS if $ExcludedClasses->{$Class};
        push @ActiveClasses, $Class;
    }

    my %IndexName = (
        index => 'configitem',
    );
    my $Success = $Param{ESObject}->DropIndex(
        IndexName => \%IndexName,
    );
    if ( !$Success ) {
        $Self->Print(
            "<yellow>The previous error messages are likely the result of trying to drop a nonexistent index and can then be ignored.</yellow>\n"
        );
    }

    my $IndexSettings = $Param{ESObject}->IndexSettingsGet(%Param);
    if ( !$IndexSettings ) {

        # Error is shown in IndexSettingsGet
        return 0;
    }

    my %Request = (
        settings => $IndexSettings,
        mappings => {
            properties => {
                ConfigItemID => {
                    type => 'integer',
                },
                ClassID => {
                    type => 'integer',
                },
                CurDeplStateID => {
                    type => 'integer',
                },
            }
        },
    );

    $Success = $Param{ESObject}->CreateIndex(
        IndexName => \%IndexName,
        Request   => \%Request,
    );

    if ($Success) {
        $Self->Print("<green>ConfigItem index created.</green>\n");
    }
    else {
        $Self->Print("<red>ConfigItem index could not be created!</red>\n");

        return 0;
    }

    # return if no StoreFields are defined
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::ConfigItemStoreFields') ) {
        $Self->Print("<yellow>No ConfigItemStoreFields are defined.</yellow>\n");

        return 1;
    }

    # if currently no active classes are defined, return
    return 1 if !@ActiveClasses;

    my @ConfigItems = $ConfigItemObject->ConfigItemSearch(
        ClassIDs => [@ActiveClasses],
        Result   => 'ARRAY',
    );

    my $Count   = 0;
    my $CICount = scalar @ConfigItems;

    my $Errors = 0;
    for my $ConfigItemID (@ConfigItems) {

        $Count++;

        # create the config item in Elasticsearch
        if ( !$Param{ESObject}->ConfigItemCreate( ConfigItemID => $ConfigItemID ) ) {
            $Errors++;
        }

        # show progress and potentially sleep
        if ( $Count % 1000 == 0 ) {
            my $Percent = int( $Count / ( $CICount / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$CICount</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }

        Time::HiRes::usleep( $Param{Sleep} ) if $Param{Sleep};
    }

    if ($Errors) {
        $Self->Print("<yellow>ConfigItem transfer complete. $Errors error(s) occured!</yellow>\n");
    }
    else {
        $Self->Print("<green>ConfigItem transfer complete. Transferred $Count config items.</green>\n");
    }

    return 1;
}

1;
