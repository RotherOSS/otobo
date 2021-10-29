# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use if $ENV{OTOBO_SYNC_WITH_S3}, 'Kernel::System::Storage::S3';

# For now test only when running under Docker,
# even though this route could also be available outside Docker.
skip_all 'not running with S3 storage' unless $ENV{OTOBO_SYNC_WITH_S3};

plan(7);

ok( $INC{'Kernel/System/Storage/S3.pm'}, 'Kernel::System::Storage::S3 was loaded' );

my $StorageS3Object = Kernel::System::Storage::S3->new();
isa_ok( $StorageS3Object, 'Kernel::System::Storage::S3' );

# run a blocking GET request to S3
my $FilesPrefix     = join '/', 'OTOBO', 'Kernel', 'Config', 'Files', '';    # no bucket, with trailing '/'
my %Name2Properties = $StorageS3Object->ListObjects(
    Prefix => $FilesPrefix,
);

ok( exists $Name2Properties{'ZZZAAuto.pm'}, 'ZZZAAuto.pm found' );

my $Properties = $Name2Properties{'ZZZAAuto.pm'};

ref_ok( $Properties, 'HASH' );
ok( $Properties->{Size},  'got Size for ZZZAAuto.pm' );
ok( $Properties->{Mtime}, 'got Mtime for ZZZAAuto.pm' );
is( $Properties->{Key}, "${FilesPrefix}ZZZAAuto.pm", 'Key for ZZZAAuto.pm' );
