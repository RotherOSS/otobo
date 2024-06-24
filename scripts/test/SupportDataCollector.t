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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use Time::HiRes ();

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::SupportDataCollector::PluginBase ();

# get needed objects
my $CacheObject                = $Kernel::OM->Get('Kernel::System::Cache');
my $MainObject                 = $Kernel::OM->Get('Kernel::System::Main');
my $SupportDataCollectorObject = $Kernel::OM->Get('Kernel::System::SupportDataCollector');
my $Helper                     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# test the support data collect asynchronous function
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SupportDataCollector::DisablePlugins',
    Value => [
        'Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment',
    ],
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SupportDataCollector::IdentifierFilterBlacklist',
    Value => [
        'Kernel::System::SupportDataCollector::Plugin::OTOBO::TimeSettings::UserDefaultTimeZone',
    ],
);

diag 'testing CollectAsynchronous';
{
    my $TimeStart   = [ Time::HiRes::gettimeofday() ];
    my %ResultAsync = $SupportDataCollectorObject->CollectAsynchronous();

    is(
        $ResultAsync{Success},
        1,
        "Asynchronous data collection status",
    );

    my $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

    # Look for all plug-ins in the FS
    my @PluginFiles = $MainObject->DirectoryRead(
        Directory => $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/Kernel/System/SupportDataCollector/PluginAsynchronous",
        Filter    => "*.pm",
        Recursive => 1,
    );

    # Execute all plug-ins
    PLUGIN_FILE:
    for my $PluginFile (@PluginFiles) {

        # Convert file name => package name
        $PluginFile =~ s{^.*(Kernel/System.*)[.]pm$}{$1}xmsg;
        $PluginFile =~ s{/+}{::}xmsg;

        if ( !$MainObject->Require($PluginFile) ) {
            diag "Could not load $PluginFile!";

            next PLUGIN_FILE;
        }
        my $PluginObject     = $PluginFile->new;
        my $AsynchronousData = $PluginObject->_GetAsynchronousData();

        ok( defined $AsynchronousData, "$PluginFile - asynchronous data exists." );
    }

    ok(
        $TimeElapsed < 240,
        "CollectAsynchronous() - Should take less than 240 seconds, it took $TimeElapsed"
    );
}

# test the support data collect function
$CacheObject->CleanUp(
    Type => 'SupportDataCollector',
);

my $TimeStart = [ Time::HiRes::gettimeofday() ];
my %Result    = $SupportDataCollectorObject->Collect(
    WebTimeout => 240,
    Hostname   => $Helper->GetTestHTTPHostname(),
);

my $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

is( $Result{Success},      1,     "Data collection status" );
is( $Result{ErrorMessage}, undef, "There is no error message" );
ok( scalar @{ $Result{Result} || [] } >= 1, "Data collection result count" );

my %SeenIdentifier;
for my $ResultEntry ( @{ $Result{Result} || [] } ) {
    ok(
        (
            $ResultEntry->{Status} == $Kernel::System::SupportDataCollector::PluginBase::StatusUnknown
                ||
                $ResultEntry->{Status} == $Kernel::System::SupportDataCollector::PluginBase::StatusOK
                ||
                $ResultEntry->{Status} == $Kernel::System::SupportDataCollector::PluginBase::StatusWarning
                ||
                $ResultEntry->{Status} == $Kernel::System::SupportDataCollector::PluginBase::StatusProblem
                ||
                $ResultEntry->{Status} == $Kernel::System::SupportDataCollector::PluginBase::StatusInfo
        ),
        "$ResultEntry->{Identifier} - status ($ResultEntry->{Status}).",
    );

    is(
        $SeenIdentifier{ $ResultEntry->{Identifier} }++,
        0,
        "$ResultEntry->{Identifier} - identifier only used once.",
    );
}

# Check if the identifier from the disabled plugions are not present.
subtest 'SupportDataCollector::DisablePlugins disabled plugins should not be present' => sub {
    for my $DisabledPluginsIdentifier (
        'Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment',
        'Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment::Verification',
        'Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment::FrameworkVersion',
        )
    {
        ok( !$SeenIdentifier{$DisabledPluginsIdentifier}, "$DisabledPluginsIdentifier not present" );
    }
};

# Check if the identifiers from the identifier filter blacklist are not present.
ok(
    !$SeenIdentifier{'Kernel::System::SupportDataCollector::Plugin::OTOBO::TimeSettings::UserDefaultTimeZone'},
    "Collect() - SupportDataCollector::IdentifierFilterBlacklist - Kernel::System::SupportDataCollector::Plugin::OTOBO::TimeSettings::UserDefaultTimeZone should not be present"
);

# cache tests
my $CacheResult = $CacheObject->Get(
    Type => 'SupportDataCollector',
    Key  => 'DataCollect',
);
is( $CacheResult, \%Result, "Collect() - Cache" );
ok( $TimeElapsed < 240, "Collect() - Should take less than 240 seconds, it took $TimeElapsed" );

my $TimeStartCache = [ Time::HiRes::gettimeofday() ];
%Result = $SupportDataCollectorObject->Collect(
    UseCache => 1,
);
my $TimeElapsedCache = Time::HiRes::tv_interval($TimeStartCache);

$CacheResult = $CacheObject->Get(
    Type => 'SupportDataCollector',
    Key  => 'DataCollect',
);
is( $CacheResult, \%Result, "Collect() - Cache", );
ok( $TimeElapsedCache < $TimeElapsed, "Collect() - Should take less than $TimeElapsed seconds, it took $TimeElapsedCache", );

# cleanup cache
$CacheObject->CleanUp();

done_testing();
