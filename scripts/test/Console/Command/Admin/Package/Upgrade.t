# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

use v5.23;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

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

my $RandomID = $Helper->GetRandomID();

# Override Request() from WebUserAgent to always return some test data without making any
# actual web service calls. This should prevent instability in case cloud services are
# unavailable at the exact moment of this test run.
my $CustomCode = <<"END_CODE";
sub Kernel::Config::Files::ZZZZUnitTestAdminPackageManager${RandomID}::Load {} # no-op, avoid warning logs
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
    Identifier => 'Admin::Package::Upgrade' . $RandomID,
);

my $Location             = $ConfigObject->Get('Home') . '/scripts/test/sample/PackageManager/TestPackage.opm';
my $UpgradeCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Upgrade');

# will be set to 137 in Kernel::System::WebUserAgent::Request()
$main::SubRequestHasBeenCalled = 0;

my $ExitCode = $UpgradeCommandObject->Execute($Location);

is( $main::SubRequestHasBeenCalled, 137, 'Kernel::System::WebUserAgent::Request() has been called' );
is(
    $ExitCode,
    1,
    "Admin::Package::Upgrade exit code - package is not verified",
);

$ExitCode = $UpgradeCommandObject->Execute($Location);

is(
    $ExitCode,
    1,
    "Admin::Package::Upgrade exit code without arguments",
);

done_testing();
