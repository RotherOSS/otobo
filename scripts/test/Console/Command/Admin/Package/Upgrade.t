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

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# clear the cache, as PackageVerify() caches by the md5sum of the opm file
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

# One test of this test script is to make sure that the package verification is actually called.
# Therefore we make sure that cloud services are enabled and that unverified packages are not
# installable.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CloudServices::Disabled',
    Value => 0,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Package::AllowNotVerifiedPackages',
    Value => 0,
);

# Override Request() from WebUserAgent to always return some test data without making any
# actual web service calls. This should prevent instability in case cloud services are
# unavailable at the exact moment of this test run.
my $Identifier = sprintf 'AdminPackageUpgrade%s', $Helper->GetRandomID();
my $CustomCode = <<"END_CODE";
sub Kernel::Config::Files::ZZZZUnitTest${Identifier}::Load {} # no-op, avoid warning logs
use Kernel::System::WebUserAgent;
package Kernel::System::WebUserAgent;
use strict;
use warnings;
## nofilter(TidyAll::Plugin::OTOBO::Perl::TestSubs)
{
    no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
    sub Request {

        # set a global variable just to indicate that this sub has been called
        \$main::SubRequestHasBeenCalled = 137;

        my \$Content = '{"Success":1,"Results":{"PackageManagement":[{"Operation":"PackageVerify","Data":{"Test":"not_verified","TestPackageIncompatible":"not_verified"},"Success":"1"}]},"ErrorMessage":""}';

        return (
            Status  => '200 OK',
            Content => \\\$Content,
        );
    }
}
1;
END_CODE

$Helper->CustomCodeActivate(
    Code       => $CustomCode,
    Identifier => $Identifier,
);

# CustomCodeActivate does not actually run the custom code.
# Running the custom code is triggered by recreating an instance of Kernel::Config.
# But make sure that Kernel::System::WebUserAgent is already loaded when
# overriding the Request() method. Otherwise WebUserAgent.pm is loaded by the object manager later
# and the method Request() is back to normal.
my $RequestObject = $Kernel::OM->Get('Kernel::System::WebUserAgent');
$Kernel::OM->Create('Kernel::Config');

my $Location             = $ConfigObject->Get('Home') . '/scripts/test/sample/PackageManager/TestPackage.opm';
my $UpgradeCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Upgrade');

# will be set to 137 in the custom method Kernel::System::WebUserAgent::Request()
$main::SubRequestHasBeenCalled = 0;

my $ExitCodeNotVerified = $UpgradeCommandObject->Execute($Location);

is( $main::SubRequestHasBeenCalled, 137, 'Kernel::System::WebUserAgent::Request() has been called' );
is(
    $ExitCodeNotVerified,
    1,
    'Admin::Package::Upgrade exit code - package is not verified',
);

# TODO: change the custom code so that the sample package is verified. ExitCode must be 0 then.

# clear the cache, as PackageVerify() caches by the md5sum of the opm file
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my $ExitCode = $UpgradeCommandObject->Execute($Location);

is(
    $ExitCode,
    1,
    'Admin::Package::Upgrade exit code - package is still not verified',
);

done_testing();
