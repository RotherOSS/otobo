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
use v5.24;
use namespace::autoclean;
use utf8;

# core modules
use Scalar::Util qw(weaken);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::CloneDB::Backend

=head1 SYNOPSIS

    # helper for migration

=head1 PUBLIC INTERFACE

=head2 new()

create a CloneDB backend object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::CloneDB::Backend');

=cut

sub new {
    my $Class = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = bless {}, $Class;

    my %CheckEncodingColumns = (
        'article_data_mime.a_body'               => 1,
        'article_data_mime_attachment.filename'  => 1,
    );

    # create all registered backend modules
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
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
                CheckEncodingColumns => \%CheckEncodingColumns,
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

=head2 CreateOTRSDBConnection()

creates the target db object.

    my $Success = $BackendObject->CreateOTRSDBConnection(
        OTRSDBSettings             => $OTRSDBSettings, # a hash refs including target DB settings
    );

=cut

sub CreateOTRSDBConnection {
    my $Self = shift;
    my %Param = @_;

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
    return $Self->{$CloneDBBackend}->CreateOTRSDBConnection(
        %{ $Param{OTRSDBSettings} },
    );
}

=head2 DataTransfer()

transfers information from a OTRS DB to the OTOBO DB.

    my $Success = $BackendObject->DataTransfer(
        OTRSDBObject   => $OTRSDBObject,   # mandatory
        OTRSDBSettings => $OTRSDBSettings, # mandatory
    );

=cut

sub DataTransfer {
    my $Self = shift;
    my %Param = @_;

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

    # choose the source db specific backend
    my $SourceDBBackend = $Self->{ 'CloneDB' . $Param{OTRSDBObject}->{'DB::Type'} . 'Object' };
    if ( ! $SourceDBBackend ) {
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
    return $SourceDBBackend->DataTransfer(
        OTRSDBObject   => $Param{OTRSDBObject},
        OTOBODBObject  => $OTOBODBObject,
        OTOBODBBackend => $Self->{$OTOBODBBackend},
        DBInfo         => $Param{OTRSDBSettings},
        Force          => $Param{Force},
    );
}

=head2 SanityChecks()

perform some sanity check before db cloning.

    my $SuccessSanityChecks = $BackendObject->SanityChecks(
        OTRSDBObject => $OTRSDBObject, # mandatory
    );

=cut

sub SanityChecks {
    my $Self = shift;
    my %Param = @_;

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
    return $Self->{$CloneDBBackend}->SanityChecks(
        OTRSDBObject => $Param{OTRSDBObject},
        Force        => $Param{Force},
    );
}

1;
