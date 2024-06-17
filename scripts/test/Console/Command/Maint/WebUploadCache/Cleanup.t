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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Digest::MD5 qw(md5_hex);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::WebUploadCache::Cleanup');

my ( $Result, $ExitCode );

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Module (qw(DB FS)) {

    # make sure that the $UploadCacheObject gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::UploadCache'] );

    $ConfigObject->Set(
        Key   => 'WebUploadCacheModule',
        Value => "Kernel::System::Web::UploadCache::$Module",
    );

    # get a new upload cache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    $Self->True(
        $UploadCacheObject->{Backend}->isa("Kernel::System::Web::UploadCache::$Module"),
        "Upload cache created with correct object",
    );

    my $FormID = $UploadCacheObject->FormIDCreate();

    $Self->True(
        $FormID,
        "#$Module - FormIDCreate()",
    );

    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/WebUploadCache/WebUploadCache-Test1.txt";

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
    );
    my $Content = ${$ContentRef};
    $EncodeObject->EncodeOutput( \$Content );

    my $MD5         = md5_hex($Content);
    my $ContentID   = undef;
    my $Disposition = 'attachment';

    my $Add = $UploadCacheObject->FormIDAddFile(
        FormID      => $FormID,
        Filename    => 'UploadCache Test1äöüß.txt',
        Content     => $Content,
        ContentType => 'text/html',
        ContentID   => $ContentID,
        Disposition => $Disposition,
    );

    $Self->True(
        $Add || '',
        "#$Module - FormIDAddFile()",
    );

    # delete upload cache - should not remove cached form
    $ExitCode = $CommandObject->Execute();
    $Self->Is(
        $ExitCode,
        0,
        "#$Module - delete upload cache",
    );

    my @Data = $UploadCacheObject->FormIDGetAllFilesData(
        FormID => $FormID,
    );

    $Self->True(
        scalar @Data,
        "#$Module - FormIDGetAllFilesData() check if formid is present",
    );

    @Data = $UploadCacheObject->FormIDGetAllFilesMeta( FormID => $FormID );

    $Self->True(
        scalar @Data,
        "#$Module - FormIDGetAllFilesMeta() check if formid is present",
    );

    # set fixed time
    FixedTimeSet();

    # wait 24h+1s to expire upload cache
    FixedTimeAddSeconds(86401);

    # delete upload cache - should remove cached form
    $ExitCode = $CommandObject->Execute();
    $Self->Is(
        $ExitCode,
        0,
        "#$Module - delete upload cache",
    );

    @Data = $UploadCacheObject->FormIDGetAllFilesData(
        FormID => $FormID,
    );

    $Self->False(
        scalar @Data,
        "#$Module - FormIDGetAllFilesData() check if formid is absent",
    );

    @Data = $UploadCacheObject->FormIDGetAllFilesMeta(
        FormID => $FormID,
    );

    $Self->False(
        scalar @Data,
        "#$Module - FormIDGetAllFilesMeta() check if formid is absent",
    );

    # unset fixed time
    FixedTimeUnset();

}

$Self->DoneTesting();
