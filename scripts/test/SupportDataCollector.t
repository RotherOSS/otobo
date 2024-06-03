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

use File::Basename;
use Time::HiRes ();

use Kernel::System::SupportDataCollector::PluginBase;

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

$Self->Note( Note => 'testing CollectAsynchronous' );
{
    my $TimeStart   = [ Time::HiRes::gettimeofday() ];
    my %ResultAsync = $SupportDataCollectorObject->CollectAsynchronous();

    $Self->Is(
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
            $Self->Note( Note => "Could not load $PluginFile!" );

            next PLUGIN_FILE;
        }
        my $PluginObject = $PluginFile->new( %{$Self} );

        my $AsynchronousData = $PluginObject->_GetAsynchronousData();

        $Self->True(
            defined $AsynchronousData,
            "$PluginFile - asynchronous data exists.",
        );
    }

    $Self->True(
        $TimeElapsed < 240,
        "CollectAsynchronous() - Should take less than 240 seconds, it took $TimeElapsed"
    );

}

# test the support data collect function
$CacheObject->CleanUp(
    Type => 'SupportDataCollector',
);

my $TimeStart = [ Time::HiRes::gettimeofday() ];

my %Result = $SupportDataCollectorObject->Collect(
    WebTimeout => 240,
    Hostname   => $Helper->GetTestHTTPHostname(),
);

my $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

$Self->Is(
    $Result{Success},
    1,
    "Data collection status",
);

$Self->Is(
    $Result{ErrorMessage},
    undef,
    "There is no error message",
);

$Self->True(
    scalar @{ $Result{Result} || [] } >= 1,
    "Data collection result count",
);

my %SeenIdentifier;

for my $ResultEntry ( @{ $Result{Result} || [] } ) {
    $Self->True(
        (
            $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusUnknown
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusOK
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusWarning
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusProblem
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusInfo

        ),
        "$ResultEntry->{Identifier} - status ($ResultEntry->{Status}).",
    );

    $Self->Is(
        $SeenIdentifier{ $ResultEntry->{Identifier} }++,
        0,
        "$ResultEntry->{Identifier} - identifier only used once.",
    );
}

# Check if the identifier from the disabled plugions are not present.
for my $DisabledPluginsIdentifier (
    qw(Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment::Verification Kernel::System::SupportDataCollector::Plugin::OTOBO::PackageDeployment::FrameworkVersion)
    )
{
    $Self->False(
        $SeenIdentifier{$DisabledPluginsIdentifier},
        "Collect() - SupportDataCollector::DisablePlugins - $DisabledPluginsIdentifier should not be present"
    );
}

# Check if the identifiers from the identifier filter blacklist are not present.
$Self->False(
    $SeenIdentifier{'Kernel::System::SupportDataCollector::Plugin::OTOBO::TimeSettings::UserDefaultTimeZone'},
    "Collect() - SupportDataCollector::IdentifierFilterBlacklist - Kernel::System::SupportDataCollector::Plugin::OTOBO::TimeSettings::UserDefaultTimeZone should not be present"
);

# cache tests
my $CacheResult = $CacheObject->Get(
    Type => 'SupportDataCollector',
    Key  => 'DataCollect',
);
$Self->IsDeeply(
    $CacheResult,
    \%Result,
    "Collect() - Cache"
);

$Self->True(
    $TimeElapsed < 240,
    "Collect() - Should take less than 240 seconds, it took $TimeElapsed"
);

my $TimeStartCache = [ Time::HiRes::gettimeofday() ];
%Result = $SupportDataCollectorObject->Collect(
    UseCache => 1,
);
my $TimeElapsedCache = Time::HiRes::tv_interval($TimeStartCache);

$CacheResult = $CacheObject->Get(
    Type => 'SupportDataCollector',
    Key  => 'DataCollect',
);
$Self->IsDeeply(
    $CacheResult,
    \%Result,
    "Collect() - Cache",
);

$Self->True(
    $TimeElapsedCache < $TimeElapsed,
    "Collect() - Should take less than $TimeElapsed seconds, it took $TimeElapsedCache",
);

# cleanup cache
$CacheObject->CleanUp();

$Self->DoneTesting();
