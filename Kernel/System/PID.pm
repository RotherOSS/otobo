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

package Kernel::System::PID;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::PID - to manage PIDs

=head1 DESCRIPTION

All functions to manage process ids

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get fqdn
    $Self->{Host} = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    return $Self;
}

=head2 PIDCreate()

create a new process id lock

    $PIDObject->PIDCreate(
        Name => 'PostMasterPOP3',
    );

    or to create a new PID forced, without check if already exists (this will delete any process
    with the same name from any other host)

    $PIDObject->PIDCreate(
        Name  => 'PostMasterPOP3',
        Force => 1,
    );

    or to create a new PID with extra TTL time

    $PIDObject->PIDCreate(
        Name  => 'PostMasterPOP3',
        TTL   => 60 * 60 * 24 * 3, # for 3 days, per default 1h is used
    );

=cut

sub PIDCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return;
    }

    # check if already exists
    my %ProcessID = $Self->PIDGet(%Param);

    if ( %ProcessID && !$Param{Force} ) {

        my $TTL = $Param{TTL} || 3600;
        if ( $ProcessID{Created} > ( time() - $TTL ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Can't create PID $ProcessID{Name}, because it's already running "
                    . "($ProcessID{Host}/$ProcessID{PID})!",
            );
            return;
        }

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  =>
                "Removed PID ($ProcessID{Name}/$ProcessID{Host}/$ProcessID{PID}, because the TTL ($TTL sec) was exceeded!",
        );
    }

    # do nothing if PID is the same
    my $PIDCurrent = $$;
    return 1 if $ProcessID{PID} && $PIDCurrent eq $ProcessID{PID};

    # delete if exists
    $Self->PIDDelete(%Param);

    # add new entry
    my $Time = time();
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO process_id
            (process_name, process_id, process_host, process_create, process_change)
            VALUES (?, ?, ?, ?, ?)',
        Bind => [ \$Param{Name}, \$PIDCurrent, \$Self->{Host}, \$Time, \$Time ],
    );

    return 1;
}

=head2 PIDGet()

get process id lock info

    my %PID = $PIDObject->PIDGet(
        Name => 'PostMasterPOP3',
    );

=cut

sub PIDGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => '
            SELECT process_name, process_id, process_host, process_create, process_change
            FROM process_id
            WHERE process_name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        %Data = (
            PID     => $Row[1],
            Name    => $Row[0],
            Host    => $Row[2],
            Created => $Row[3],
            Changed => $Row[4],
        );
    }

    return %Data;
}

=head2 PIDDelete()

delete the process id lock

    my $Success = $PIDObject->PIDDelete(
        Name  => 'PostMasterPOP3',
    );

    or to force delete even if the PID is registered by another host
    my $Success = $PIDObject->PIDDelete(
        Name  => 'PostMasterPOP3',
        Force => 1,
    );

=cut

sub PIDDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return;
    }

    # set basic SQL statement
    my $SQL = '
        DELETE FROM process_id
        WHERE process_name = ?';

    my @Bind = ( \$Param{Name} );

    # delete only processes from this host if Force option was not set
    if ( !$Param{Force} ) {
        $SQL .= '
        AND process_host = ?';

        push @Bind, \$Self->{Host};
    }

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return 1;
}

=head2 PIDUpdate()

update the process id change time.
this might be useful as a keep alive signal.

    my $Success = $PIDObject->PIDUpdate(
        Name    => 'PostMasterPOP3',
    );

=cut

sub PIDUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return;
    }

    my %PID = $Self->PIDGet( Name => $Param{Name} );

    if ( !%PID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Can not get PID'
        );
        return;
    }

    # sql
    my $Time = time();
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE process_id
            SET process_change = ?
            WHERE process_name = ?',
        Bind => [ \$Time, \$Param{Name} ],
    );

    return 1;
}

1;
