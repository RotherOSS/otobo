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

package Kernel::System::MigrateFromOTRS::CloneDB::Backend;

use strict;
use warnings;

use Scalar::Util qw(weaken);
#use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::DateTime',
    'Kernel::System::XML',
    'Kernel::System::Cache',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::CloneDB::Backend

=head1 SYNOPSIS

DynamicFields backend interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a CloneDB backend object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::CloneDB::Backend');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # OTRS stores binary data in some columns. On some database systems,
    #   these are handled differently (data is converted to base64-encoding before
    #   it is stored. Here is the list of these columns which need special treatment.

    # Create function BlobColumnsList to get this info.
    # TODO: Remove after testing
    #my %BlobColumns;
    #$BlobColumns{"article_data_mime_plain.body"} = 1;
    #$BlobColumns{"article_data_mime_attachment.content"} = 1;
    #$BlobColumns{"virtual_fs_db.content"} = 1;
    #$BlobColumns{"web_upload_cache.content"} = 1;
    #$BlobColumns{"standard_attachment.content"} = 1;
    #$BlobColumns{"faq_attachment.content"} = 1;
    #$BlobColumns{"change_template.content"} = 1;
    #$BlobColumns{"mail_queue.raw_message"} = 1;

    my %CheckEncodingColumns;
    $CheckEncodingColumns{"article_data_mime.a_body"} = 1;
    $CheckEncodingColumns{"article_data_mime_attachment.filename"} = 1;

#    $Self->{BlobColumns}          = \%BlobColumns;
    $Self->{CheckEncodingColumns} = \%CheckEncodingColumns;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # create all registered backend modules
    for my $DBType (qw(mysql oracle postgresql)) {

        my $BackendModule = 'Kernel::System::MigrateFromOTRS::CloneDB::Driver::' . $DBType;

        # check if database backend exists
        if ( !$MainObject->Require($BackendModule) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't load Clone DB backend module for DBMS $DBType!",
            );

            return;
        }

        # sanity action
        $Kernel::OM->ObjectsDiscard(
            Objects => [$BackendModule],
        );

        $Kernel::OM->ObjectParamAdd(
            $BackendModule => {
                BlobColumns          => $Self->{BlobColumns},
                CheckEncodingColumns => $Self->{CheckEncodingColumns},
            },
        );

        # create a backend object
        my $BackendObject = $Kernel::OM->Get($BackendModule);

        if ( !$BackendObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Couldn't create a backend object for DBMS $DBType!",
            );

            return;
        }

        # remember the backend object
        $Self->{ 'CloneDB' . $DBType . 'Object' } = $BackendObject;
    }

    return $Self;
}

=item CreateOTRSDBConnection()

creates the target db object.

    my $Success = $BackendObject->CreateOTRSDBConnection(
        OTRSDBSettings             => $OTRSDBSettings, # a hash refs including target DB settings
    );

=cut

sub CreateOTRSDBConnection {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OTRSDBSettings} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBSettings!",
        );

        return;
    }

    # check OTRSDBSettings (internally)
    for my $Needed (
        qw(DBHost DBName DBUser DBPassword DBType)
        )
    {
        if ( !$Param{OTRSDBSettings}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in OTRSDBSettings!",
            );

            return;
        }
    }

    # set the clone db specific backend
    my $CloneDBBackend = 'CloneDB' . $Param{OTRSDBSettings}->{DBType} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend $Param{OTRSDBSettings}->{DBType} is invalid!",
        );

        return;
    }

    # call CreateOTRSDBConnection on the specific backend
    my $OTRSDBConnection = $Self->{$CloneDBBackend}->CreateOTRSDBConnection(
        %{ $Param{OTRSDBSettings} },
    );

    return $OTRSDBConnection;
}

=item DataTransfer()

transfers information from a OTRS DB to the OTOBO DB.

    my $Success = $BackendObject->DataTransfer(
        OTRSDBObject => $OTRSDBObject, # mandatory
    );

=cut

sub DataTransfer {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(OTRSDBObject OTRSDBSettings)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # set the source db specific backend
    my $SourceDBBackend = 'CloneDB' . $Param{OTRSDBSettings}->{DBType} . 'Object';

    if ( !$Self->{$SourceDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend " . $Param{OTRSDBSettings}->{DBType} . " is invalid!",
        );

        return;
    }

#    # set the target db specific backend
#    my $OTOBODBBackend = 'CloneDB' . $Param{DBInfo}->{'OTOBODBType'} . 'Object';
#
#    if ( !$Self->{$OTOBODBBackend} ) {
#        $Kernel::OM->Get('Kernel::System::Log')->Log(
#            Priority => 'error',
#            Message  => "Backend $Param{DBInfo}->{'OTOBODBType'} is invalid!",
#        );
#
#        return;
#    }

    # call DataTransfer on the specific backend
    my $DataTransfer = $Self->{$SourceDBBackend}->DataTransfer(
        OTRSDBObject  => $Param{OTRSDBObject},
        OTRSDBBackend => $Self->{$SourceDBBackend},
        DBInfo        => $Param{OTRSDBSettings},
        DryRun          => $Param{DryRun},
        Force           => $Param{Force},
    );

    return $DataTransfer;
}

=item SanityChecks()

perform some sanity check before db cloning.

    my $SuccessSanityChecks = $BackendObject->SanityChecks(
        OTRSDBObject => $OTRSDBObject, # mandatory
    );

=cut

sub SanityChecks {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OTRSDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBObject!",
        );

        return;
    }

    # set the clone db specific backend
    my $CloneDBBackend = 'CloneDB' . $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend " . $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} . " is invalid!",
        );

        return;
    }

    # perform sanity checks
    my $SanityChecks = $Self->{$CloneDBBackend}->SanityChecks(
        OTRSDBObject => $Param{OTRSDBObject},
        DryRun         => $Param{DryRun},
        Force          => $Param{Force},
    );

    return $SanityChecks;
}

sub _GenerateOTRSStructuresSQL {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OTRSDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBObject!",
        );

        return;
    }

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create( 'Kernel::System::DateTime');
    my $Epoch = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task        => 'OTOBODatabaseMigrate',
            SubTask     => "Generating DDL for OTOBO.",
            StartTime   => $Epoch,
        },
    );

    # SourceDBObject get data
    my $SQLDirectory = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/database';

    if ( !-f "$SQLDirectory/otrs-schema.xml" ) {
        die "SQL directory $SQLDirectory not found.";
    }

    # keep next lines here due this time we need the source db object
    # get repository list
    my @Packages = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList();

    # attention!!!
    # switch database object to target object to use the xml
    # object of the target database
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
            'Kernel::System::XML',
        ],
    );
    $Kernel::OM->ObjectInstanceRegister(
        Package => 'Kernel::System::DB',
        Object  => $Param{OTRSDBObject},
    );

    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');    # of target database

    # get XML structure
    my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Directory => $SQLDirectory,
        Filename  => 'otrs-schema.xml',
    );
    my @XMLArray = $XMLObject->XMLParse(
        String => $XML,
    );

    $Self->{SQL} = [];
    push @{ $Self->{SQL} }, $Param{OTRSDBObject}->SQLProcessor(
        Database => \@XMLArray,
    );
    $Self->{SQLPost} = [];
    push @{ $Self->{SQLPost} }, $Param{OTRSDBObject}->SQLProcessorPost();

    # first step: get the dependencies into a single hash,
    # so that the topological sorting goes faster
    my %ReverseDependencies;
    for my $Package (@Packages) {
        my $Dependencies = $Package->{PackageRequired} // [];

        for my $Dependency (@$Dependencies) {

            # undef happens to be the value that uses the least amount
            # of memory in Perl, and we are only interested in the keys
            $ReverseDependencies{ $Dependency->{Content} }->{ $Package->{Name}->{Content} } = undef;
        }
    }

    # second step: sort packages based on dependencies
    my $Sort = sub {
        if (
            exists $ReverseDependencies{ $a->{Name}->{Content} }
            && exists $ReverseDependencies{ $a->{Name}->{Content} }->{ $b->{Name}->{Content} }
            )
        {
            return -1;
        }
        if (
            exists $ReverseDependencies{ $b->{Name}->{Content} }
            && exists $ReverseDependencies{ $b->{Name}->{Content} }->{ $a->{Name}->{Content} }
            )
        {
            return 1;
        }
        return 0;
    };
    @Packages = sort { $Sort->() } @Packages;

    # TODO Rother OSS: Is this right and needed?
    # loop all locally installed packages
    PACKAGE:
    for my $Package (@Packages) {

        # Set cache object with taskinfo and starttime to show current state in frontend
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        my $DateTimeObject = $Kernel::OM->Create( 'Kernel::System::DateTime');
        my $Epoch = $DateTimeObject->ToEpoch();

        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task        => 'OTOBODatabaseMigrate',
                SubTask     => "Generating DDL for package $Package->{Name}->{Content}.",
                StartTime   => $Epoch,
            },
        );

        next PACKAGE if !$Package->{DatabaseInstall};

        TYPE:
        for my $Type (qw(pre post)) {
            next TYPE if !$Package->{DatabaseInstall}->{$Type};

            push @{ $Self->{SQL} }, $Param{OTRSDBObject}->SQLProcessor(
                Database => $Package->{DatabaseInstall}->{$Type},
            );
            push @{ $Self->{SQLPost} }, $Param{OTRSDBObject}->SQLProcessorPost();
        }
    }

    # discard objects of target database to switch back to source object
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
            'Kernel::System::XML',
        ],
    );

    return;
}

sub PopulateOTRSStructuresPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OTRSDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBObject!",
        );
        return;
    }

    $Self->_GenerateOTRSStructuresSQL(%Param);

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create( 'Kernel::System::DateTime');
    my $Epoch = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task        => 'OTOBODatabaseMigrate',
            SubTask     => "Creating structures in target database (phase 1/2).",
            StartTime   => $Epoch,
        },
    );

    STATEMENT:
    for my $Statement ( @{ $Self->{SQL} } ) {
        next STATEMENT if $Statement =~ m{^INSERT}smxi;
        my $Result = $Param{OTRSDBObject}->Do( SQL => $Statement );

        if ( !$Result ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not generate structures in target database! Please make sure the target database is empty.",
            );
            return;
        }
    }

    return 1;
}

sub PopulateOTRSStructuresPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(OTRSDBObject)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create( 'Kernel::System::DateTime');
    my $Epoch = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task        => 'OTOBODatabaseMigrate',
            SubTask     => "Creating structures in target database (phase 2/2).",
            StartTime   => $Epoch,
        },
    );

    for my $Statement ( @{ $Self->{SQLPost} } ) {
        my $Result = $Param{OTRSDBObject}->Do( SQL => $Statement );

        if ( !$Result ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not generate structures in target database.",
            );
            return;
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
