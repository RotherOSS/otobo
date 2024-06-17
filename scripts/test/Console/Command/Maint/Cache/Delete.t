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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Cache::Delete');

my ( $Result, $ExitCode );

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create cache object and disable inmemory caching to force
# the cache to read from file system
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
$CacheObject->Configure(
    CacheInMemory => 0,
);

my $ObjectType = $Helper->GetRandomID();
my $ObjectKey  = $Helper->GetRandomNumber();

# create dummy cache entry
my $CacheSet = $CacheObject->Set(
    Type  => $ObjectType,
    Key   => $ObjectKey,
    Value => 'TestData',
);
$Self->Is(
    $CacheSet,
    1,
    "Delete all - Cache set",
);

# delete all cache files
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    0,
    "Delete all - exit code",
);

# check if entry is gone
my $CacheGet = $CacheObject->Get(
    Type => $ObjectType,
    Key  => $ObjectKey,
);

$Self->Is(
    $CacheGet,
    undef,
    "Delete all - check if file is still present",
);

# create another dummy cache entry with TTL 1 day
$ObjectType = $Helper->GetRandomID();
$ObjectKey  = $Helper->GetRandomNumber();

$CacheSet = $CacheObject->Set(
    Type  => $ObjectType,
    Key   => $ObjectKey,
    Value => 'TestData',
    TTL   => 60 * 60 * 24,
);
$Self->Is(
    $CacheSet,
    1,
    "Delete expired - Cache set",
);

# delete only expired cache files
$ExitCode = $CommandObject->Execute('--expired');
$Self->Is(
    $ExitCode,
    0,
    "Delete expired - exit code",
);

# entry should be still there
$CacheGet = $CacheObject->Get(
    Type => $ObjectType,
    Key  => $ObjectKey,
);

$Self->Is(
    $CacheGet,
    'TestData',
    "Delete expired - check if file is still present",
);

# create another dummy cache entry with TTL 1 day
$ObjectType = $Helper->GetRandomID();
$ObjectKey  = $Helper->GetRandomNumber();

$CacheSet = $CacheObject->Set(
    Type  => $ObjectType,
    Key   => $ObjectKey,
    Value => 'TestData',
);
$Self->Is(
    $CacheSet,
    1,
    "Delete only certain type - Cache set",
);
$CacheSet = $CacheObject->Set(
    Type  => $ObjectType . '_2',
    Key   => $ObjectKey,
    Value => 'TestData',
);
$Self->Is(
    $CacheSet,
    1,
    "Delete only certain type - Cache set (another type)",
);

# delete only expired cache files
$ExitCode = $CommandObject->Execute( '--type', $ObjectType );
$Self->Is(
    $ExitCode,
    0,
    "Delete only certain type - exit code",
);

# 1st entry should be deleted
$CacheGet = $CacheObject->Get(
    Type => $ObjectType,
    Key  => $ObjectKey,
);
$Self->Is(
    $CacheGet,
    undef,
    "Delete only certain type - check if file is still present",
);

# 2nd entry should be still there
$CacheGet = $CacheObject->Get(
    Type => $ObjectType . '_2',
    Key  => $ObjectKey,
);
$Self->Is(
    $CacheGet,
    'TestData',
    "Delete only certain type - check if file is still present (another type)",
);

# finally delete all caches
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    0,
    "Delete all remaining caches",
);

$Self->DoneTesting();
