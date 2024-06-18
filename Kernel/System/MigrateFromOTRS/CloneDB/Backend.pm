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

package Kernel::System::MigrateFromOTRS::CloneDB::Backend;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ObjectManagerCreation)

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager ();
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::Log',
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
    my ( $Class, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Class;

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

creates the source DB object.

    my $OTRSDBObject = $BackendObject->CreateOTRSDBConnection(
        OTRSDBSettings => $OTRSDBSettings, # a hash refs including target DB settings
    );

Return C<undef> in case of a problem. The actual error can be found in the log.

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

    NEEDED:
    for my $Needed (qw(DBType)) {

        next NEEDED if $Param{OTRSDBSettings}->{$Needed};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed in OTRSDBSettings!",
        );

        return;
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

    # Call CreateOTRSDBConnection on the specific backend.
    # The migration from Oracle is a bit exceptional as it is based on the DSN, the Data Source Name.
    # MySQL and Postgresql rely on the database host and name.
    # Thus the required settings are checked by the actual backend object itself.
    return $Self->{$CloneDBBackend}->CreateOTRSDBConnection(
        $Param{OTRSDBSettings}->%*,
    );
}

=head2 DataTransfer()

transfers information from a OTRS DB to the OTOBO DB.

    my $Success = $BackendObject->DataTransfer(
        OTRSDBObject   => $OTRSDBObject,   # mandatory, instance of Kernel::System::DB
        OTRSDBSettings => $OTRSDBSettings, # mandatory
    );

=cut

sub DataTransfer {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Needed (qw(OTRSDBObject OTRSDBSettings)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # choose the source db specific backend
    my $SourceDBBackend = $Self->{ 'CloneDB' . $Param{OTRSDBObject}->{'DB::Type'} . 'Object' };
    if ( !$SourceDBBackend ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Backend " . $Param{OTRSDBObject}->{'DB::Type'} . " is invalid!",
        );

        return;
    }

    # get OTOBO db object
    # We need to disable FOREIGN_KEY_CHECKS, because we truncate tables and copy rows.
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::DB' => {
            DeactivateForeignKeyChecks => 1,
        },
    );

    my $OTOBODBObject = $Kernel::OM->Get('Kernel::System::DB');

    # set the target db specific backend
    my $OTOBODBBackend = 'CloneDB' . $OTOBODBObject->{'DB::Type'} . 'Object';

    if ( !$Self->{$OTOBODBBackend} ) {
        $LogObject->Log(
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

perform some sanity checks before cloning the database

    my $SanityCheck = $BackendObject->SanityChecks(
        OTRSDBObject => $OTRSDBObject, # mandatory
        Message      => $Self->{LanguageObject}->Translate("Try database connect and sanity checks."),
    );

The returned value is a hash ref with the fields I<Message>, I<Comment>, and I<Successful>.

    my $SanityCheck = {
        Message    => $Self->{LanguageObject}->Translate("Try database connect and sanity checks."),
        Comment    => $Self->{LanguageObject}->Translate("Connect to OTRS database or sanity checks failed."),
        Successful => 0
    };

=cut

sub SanityChecks {
    my ( $Self, %Param ) = @_;

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    $Param{Message} ||= $Self->{LanguageObject}->Translate('Sanity checks for database.');

    # check needed stuff
    if ( !$Param{OTRSDBObject} ) {
        my $Comment = 'Need OTRSDBObject!';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Message} $Comment",
        );

        return {
            Message    => $Param{Message},
            Comment    => $Comment,
            Successful => 0,
        };
    }

    # set the clone db specific backend
    my $CloneDBBackend = 'CloneDB' . $Param{OTRSDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        my $Comment = "Backend " . $Param{OTRSDBObject}->{'DB::Type'} . " is invalid!";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Message} $Comment",
        );

        return {
            Message    => $Param{Message},
            Comment    => $Comment,
            Successful => 0,
        };
    }

    # actually perform sanity checks
    return $Self->{$CloneDBBackend}->SanityChecks(
        OTRSDBObject => $Param{OTRSDBObject},
        Message      => $Param{Message},
        Force        => $Param{Force},
    );
}

1;
