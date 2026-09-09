# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use utf8;

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::Cache::Redis;

{
    package Local::Redis;

    sub new {
        return bless {
            Deleted => [],
            Scans   => [],
        }, shift;
    }

    sub scan {
        my ( $Self, $Cursor, %Param ) = @_;

        push @{ $Self->{Scans} }, [ $Cursor, \%Param ];
        die "simulated Redis failure\n" if $Self->{Fail};

        my $Type = $Param{MATCH};
        $Type =~ s{:\*$}{};

        return ( 42, ["$Type:a"] )             if $Cursor == 0;
        return ( 99, [] )                       if $Cursor == 42;
        return ( 0,  [ "$Type:a", "$Type:b" ] );
    }

    sub del {
        my $Self = shift;

        push @{ $Self->{Deleted} }, [@_];

        return scalar @_;
    }

    sub flushdb {
        $_[0]->{Flushed}++;

        return 1;
    }

    sub smembers {
        return qw(Target Retained);
    }
}

{
    package Local::Log;

    sub Log {
        $_[0]->{Errors}++;

        return;
    }
}

{
    package Local::ObjectManager;

    sub Get {
        return $_[0]->{LogObject};
    }
}

$Kernel::OM = bless {
    LogObject => bless( {}, 'Local::Log' ),
}, 'Local::ObjectManager';

sub CacheBackendCreate {
    my $RedisObject = Local::Redis->new();

    return (
        bless( { Redis => $RedisObject }, 'Kernel::System::Cache::Redis' ),
        $RedisObject,
    );
}

my ( $CacheObject, $RedisObject ) = CacheBackendCreate();
ok( $CacheObject->CleanUp( Type => 'Target' ), 'target cleanup succeeds' );
is(
    $RedisObject->{Scans},
    [
        [ 0,  { MATCH => 'Target:*', COUNT => 1000 } ],
        [ 42, { MATCH => 'Target:*', COUNT => 1000 } ],
        [ 99, { MATCH => 'Target:*', COUNT => 1000 } ],
    ],
    'all SCAN calls use the batch hint and continue through an empty page',
);
is(
    $RedisObject->{Deleted},
    [ ['Target:a'], [ 'Target:a', 'Target:b' ] ],
    'all returned keys are deleted and an empty page does not issue DEL',
);
is( $RedisObject->{Flushed} || 0, 0, 'target cleanup does not flush the database' );

( $CacheObject, $RedisObject ) = CacheBackendCreate();
ok( $CacheObject->CleanUp( KeepTypes => ['Retained'] ), 'KeepTypes cleanup succeeds' );
is(
    [ map { $_->[1]->{MATCH} } @{ $RedisObject->{Scans} } ],
    [ ('Target:*') x 3 ],
    'the retained namespace is not scanned',
);

( $CacheObject, $RedisObject ) = CacheBackendCreate();
ok( $CacheObject->CleanUp( Expired => 1 ), 'expiry cleanup is a no-op' );
is( $RedisObject->{Scans}, [], 'expiry cleanup does not scan' );
ok( $CacheObject->CleanUp(), 'full cleanup succeeds' );
is( $RedisObject->{Flushed}, 1, 'full cleanup retains FLUSHDB behavior' );

( $CacheObject, $RedisObject ) = CacheBackendCreate();
$RedisObject->{Fail} = 1;
ok( !$CacheObject->CleanUp( Type => 'Target' ), 'Redis errors fail cleanup' );
is( $Kernel::OM->{LogObject}->{Errors}, 1, 'Redis errors are logged' );
is( $RedisObject->{Deleted}, [], 'keys are not deleted after a failed SCAN' );

done_testing();
