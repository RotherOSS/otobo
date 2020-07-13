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
use Kernel::System::VariableCheck qw(:all);

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

    my %CheckEncodingColumns;
    $CheckEncodingColumns{"article_data_mime.a_body"}              = 1;
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
    my $SourceDBBackend = 'CloneDB' . $Param{OTRSDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$SourceDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend " . $Param{OTRSDBObject}->{'DB::Type'} . " is invalid!",
        );

        return;
    }

    # get OTOBO db object
    my $OTOBODBObject = $Kernel::OM->Get('Kernel::System::DB');

    # set the target db specific backend
    my $OTOBODBBackend = 'CloneDB' . $OTOBODBObject->{'DB::Type'} . 'Object';

    if ( !$Self->{$OTOBODBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend $OTOBODBObject->{'DB::Type'} is invalid!",
    );

        return;
    }

    # call DataTransfer on the specific backend
    my $DataTransfer = $Self->{$SourceDBBackend}->DataTransfer(
        OTRSDBObject  => $Param{OTRSDBObject},
        OTOBODBObject  => $OTOBODBObject,
        OTOBODBBackend => $Self->{$OTOBODBBackend},
        DBInfo        => $Param{OTRSDBSettings},
        DryRun        => $Param{DryRun},
        Force         => $Param{Force},
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
    my $CloneDBBackend = 'CloneDB' . $Param{OTRSDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend " . $Param{OTRSDBObject}->{'DB::Type'} . " is invalid!",
        );

        return;
    }

    # perform sanity checks
    my $SanityChecks = $Self->{$CloneDBBackend}->SanityChecks(
        OTRSDBObject => $Param{OTRSDBObject},
        DryRun       => $Param{DryRun},
        Force        => $Param{Force},
    );

    return $SanityChecks;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
