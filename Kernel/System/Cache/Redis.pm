# --
# Copyright (C) 2019 by Yuri Myasoedov <ymyasoedov@yandex.ru>
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

package Kernel::System::Cache::Redis;

use strict;
use warnings;

use Encode;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storable',
);

my $NamespaceKey = 'namespaces';

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # Store Redis config
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    $Self->{Config} = {
        Address        => $ConfigObject->Get('Cache::Redis')->{Server}         || '127.0.0.1:6379',
        DatabaseNumber => $ConfigObject->Get('Cache::Redis')->{DatabaseNumber} || 0,
        RedisFast      => $ConfigObject->Get('Cache::Redis')->{RedisFast}      || 0,
    };

    # Not connected yet
    $Self->{Redis} = undef;

    return $Self;
}

sub Set {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key Value TTL)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Connect to Redis if not connected
    return if !$Self->{Redis} && !$Self->_Connect();

    eval {

        $Self->{Redis}->sadd( $NamespaceKey, $Param{Type} );

        my $Key = encode( 'UTF-8', $Param{Type} . ':' . $Param{Key} );

        # Wrap the data, because we don't know, what user expects
        # to get from cache: reference to SCALAR or common SCALAR
        my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
        my $Data           = $StorableObject->Serialize(
            Data => {
                _Data => $Param{Value},
            },
        );

        $Self->{Redis}->set( $Key, $Data, 'EX', $Param{TTL} );

    };
    if ($@) {
        my $Message = $@;    # as $Kernel::OM->Get('Kernel::System::Log') might clear $@

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );

        return;
    }

    return 1;
}

sub Get {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Connect to Redis if not connected
    return if !$Self->{Redis} && !$Self->_Connect();

    my $Key = encode( 'UTF-8', $Param{Type} . ':' . $Param{Key} );
    my $Value;
    eval {
        $Value = $Self->{Redis}->get($Key);
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $@,
        );
        return;
    }
    return if !$Value;

    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
    my $Data           = $StorableObject->Deserialize(
        Data => $Value,
    );

    return $Data->{_Data};
}

sub Delete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Connect to Redis if not connected
    return if !$Self->{Redis} && !$Self->_Connect();

    my $Key = encode( 'UTF-8', $Param{Type} . ':' . $Param{Key} );

    my $Result;
    eval {
        $Result = $Self->{Redis}->del($Key);
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $@,
        );
        return;
    }

    return !!$Result;
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # Redis removes expired data itself and we don't care about it
    return 1 if $Param{Expired};

    # Connect to Redis if not connected
    return if !$Self->{Redis} && !$Self->_Connect();

    # Delete all types when $Param{KeepTypes} is not set or references an empty array.
    # Otherwise remove the kept types from the list of to be deleted types.
    my %TypeIsKept;
    if ( $Param{KeepTypes} && ref $Param{KeepTypes} eq 'ARRAY' ) {
        %TypeIsKept = map { $_ => 1 } ( $Param{KeepTypes}->@* );
    }
    eval {
        if ( !$Param{Type} && !%TypeIsKept ) {
            $Self->{Redis}->flushdb();

            return 1;
        }

        my @ToBeDeletedTypes;
        if ( $Param{Type} ) {
            push @ToBeDeletedTypes, $Param{Type};
        }
        else {
            @ToBeDeletedTypes = $Self->{Redis}->smembers($NamespaceKey);
        }

        # filter the types that should be kept
        if (%TypeIsKept) {
            @ToBeDeletedTypes = grep { !$TypeIsKept{$_} } @ToBeDeletedTypes;
        }

        return 1 if !@ToBeDeletedTypes;

        for my $Type (@ToBeDeletedTypes) {
            my ( $Cursor, $KeysRef ) = ( 0, [] );
            do {
                ( $Cursor, $KeysRef ) = $Self->{Redis}->scan( $Cursor, MATCH => "$Type:*" );
                $Self->{Redis}->del( @{$KeysRef} ) if @{$KeysRef};
            } while ($Cursor);
        }
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $@,
        );
        return;
    }

    return 1;
}

sub _Connect {
    my $Self = shift;

    return if $Self->{Redis};

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $Loaded     = $MainObject->Require(
        $Self->{Config}{RedisFast} ? 'Redis::Fast' : 'Redis',
    );
    return if !$Loaded;

    eval {
        if ( $Self->{Config}{RedisFast} ) {
            $Self->{Redis} = Redis::Fast->new( server => $Self->{Config}{Address} );
        }
        else {
            $Self->{Redis} = Redis->new( server => $Self->{Config}{Address} );
        }
        if (
            $Self->{Config}{DatabaseNumber}
            && !$Self->{Redis}->select( $Self->{Config}{DatabaseNumber} )
            )
        {
            die "Can't select database '$Self->{Config}{DatabaseNumber}'!";
        }
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Redis error: $@!",
        );
        $Self->{Redis} = undef;
        return;
    }

    return 1;
}

1;
