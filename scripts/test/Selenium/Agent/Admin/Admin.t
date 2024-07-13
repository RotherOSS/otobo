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
use v5.24;
use utf8;

# core modules
use File::Path qw(mkpath rmtree);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Test2::Require::OTOBO::Selenium;
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

# get needed objects
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

# create directory for certificates and private keys
my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
mkpath( [$CertPath],    0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
mkpath( [$PrivatePath], 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

# make sure to enable cloud services
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CloudServices::Disabled',
    Value => 0,
);

# enable SMIME in config
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SMIME',
    Value => 1
);

# set SMIME paths in sysConfig
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SMIME::CertPath',
    Value => $CertPath,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SMIME::PrivatePath',
    Value => $PrivatePath,
);

# create test user and login
my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

$Selenium->Login(
    Type     => 'Agent',
    User     => $TestUserLogin,
    Password => $TestUserLogin,
);

# get script alias
my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

# get configured agent frontend modules
my $FrontendModules = $ConfigObject->Get('Frontend::Module');

# get test data
my @AdminModules = qw(
    AdminACL
    AdminAttachment
    AdminAutoResponse
    AdminCustomerCompany
    AdminCustomerUser
    AdminCustomerUserGroup
    AdminCustomerUserService
    AdminDynamicField
    AdminEmail
    AdminGenericAgent
    AdminGenericInterfaceWebservice
    AdminGroup
    AdminLog
    AdminMailAccount
    AdminNotificationEvent
    AdminPGP
    AdminPackageManager
    AdminPerformanceLog
    AdminPostMasterFilter
    AdminPriority
    AdminProcessManagement
    AdminQueue
    AdminQueueAutoResponse
    AdminQueueTemplates
    AdminTemplate
    AdminTemplateAttachment
    AdminRegistration
    AdminRole
    AdminRoleGroup
    AdminRoleUser
    AdminSLA
    AdminSMIME
    AdminSalutation
    AdminSelectBox
    AdminService
    AdminSupportDataCollector
    AdminSession
    AdminSignature
    AdminState
    AdminSystemConfiguration
    AdminSystemConfigurationGroup
    AdminSystemAddress
    AdminSystemMaintenance
    AdminType
    AdminUser
    AdminUserGroup
);

ADMINMODULE:
for my $AdminModule (@AdminModules) {

    # Navigate to appropriate screen in the test
    $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$AdminModule");

    # Check if needed frontend module is registered in sysconfig.
    # Skip test for unregistered modules (e.g. OTOBO Business)
    if ( !$FrontendModules->{$AdminModule} ) {

        ok(
            index(
                $Selenium->get_page_source(),
                "Module Kernel::Modules::$AdminModule not registered in Kernel/Config.pm!"
            ) > 0,
            "Module $AdminModule is not registered in sysconfig, skipping test..."
        );
        next ADMINMODULE;
    }

    # Guess if the page content is ok or an error message. Here we
    #   check for the presence of div.SidebarColumn because all Admin
    #   modules have this sidebar column present.
    $Selenium->find_element( "div.SidebarColumn", 'css' );

    # check if a breadcrumb is present
    $Selenium->find_element( "ul.BreadCrumb", 'css' );

    # Also check if the navigation is present (this is not the case
    #   for error messages and has "Admin" highlighted
    $Selenium->find_element( "li#nav-Admin.Selected", 'css' );
}

# Delete needed test directories.
for my $Directory ( $CertPath, $PrivatePath ) {
    my $Success = rmtree( [$Directory] );
    ok(
        $Success,
        "Directory deleted - '$Directory'",
    );
}

# Go to grid view.
$Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Admin");

# Add AdminACL to favourites.
$Selenium->execute_script(
    "\$('span[data-module=AdminACL]').trigger('click')"
);

# Wait until AdminACL gets class IsFavourite.
$Selenium->WaitFor(
    JavaScript =>
        "return typeof(\$) === 'function' && \$('li[data-module=\"AdminACL\"]').hasClass('IsFavourite');"
);

# Remove AdminACL from favourites.
$Selenium->execute_script(
    "\$('.DataTable .RemoveFromFavourites').trigger('click')"
);

# Checks if Add as Favourite star is visible again.
ok(
    $Selenium->execute_script(
        "return \$('span[data-module=AdminACL]').length === 1"
    ),
    "AddAsFavourite (Star) button is displayed as expected.",
);

$Selenium->WaitFor(
    JavaScript => "return typeof(\$) === 'function' && \$('.RemoveFromFavourites').length === 1;"
);

# Removes AdminACL from favourites.
$Selenium->execute_script(
    "\$('.DataTable .RemoveFromFavourites').trigger('click')"
);

# Wait until IsFavourite class is removed from AdminACL row.
$Selenium->WaitFor(
    JavaScript =>
        "return typeof(\$) === 'function' && !\$('tr[data-module=\"AdminACL\"]').hasClass('IsFavourite');"
);

# Check if AddAsFavourite on list view has IsFavourite class, false is expected.
ok(
    $Selenium->execute_script(
        "return !\$('tr[data-module=\"AdminACL\"] a.AddAsFavourite').hasClass('IsFavourite')"
    ),
    "AddAsFavourite (star) on list view is visible.",
);

# Apply a text filter to the admin tiles and wait until it's done.
#   We do this by subscribing to a specific event that will be raised when the filter is applied. When the
#   filter text has been set, the test will until a global flag variable is set to a true value. In the end,
#   event subscription will be cleared.
my $ApplyFilter = sub {
    my $FilterText = shift;

    return if !$FilterText;

    # Set up a callback on the filter change event.
    my $Handle = $Selenium->execute_script(
        "return Core.App.Subscribe('Event.UI.Table.InitTableFilter.Change', function () {
                    window.Filtered = true;
                });"
    );

    # Reset the flag.
    $Selenium->execute_script('window.Filtered = false;');

    # Apply a filter.
    $Selenium->find_element( 'input#Filter', 'css' )->clear();
    $Selenium->find_element( 'input#Filter', 'css' )->send_keys($FilterText);

    # Wait until the flag is set.
    $Selenium->WaitFor( JavaScript => 'return window.Filtered;' );

    my $HandleJSON = $JSONObject->Encode(
        Data => $Handle,
    );

    # Clear the callback.
    $Selenium->execute_script("Core.App.Unsubscribe($HandleJSON);");

    return 1;
};

# Check a count of visible tiles in specific category.
my $CheckTileCount = sub {
    my ( $ContainerTitle, $ExpectedTileCount ) = @_;

    return if !$ContainerTitle || !$ExpectedTileCount;

    is(
        $Selenium->execute_script(
            "return \$('.Header h2:contains(\"$ContainerTitle\")').parents('.WidgetSimple').find('.ItemListGrid li:visible').length;"
        ),
        $ExpectedTileCount,
        "Tile count for '$ContainerTitle'"
    );

    return 1;
};

# Filter a complete category (see bug#14039 for more information).
$ApplyFilter->('users');

# Verify 12 tiles from affected category are shown.
$CheckTileCount->( 'Users, Groups & Roles', 12 );

# Filter a couple of tiles.
$ApplyFilter->('customer');

# Verify 6 tiles from affected category are shown.
$CheckTileCount->( 'Users, Groups & Roles', 6 );

# Filter just a single tile.
$ApplyFilter->('Communication Log');

# Verify only one tile from affected category is shown.
$CheckTileCount->( 'Communication & Notifications', 1000 );

done_testing;
