# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new();

$Selenium->RunTest(
    sub {

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');

        # Get 'Location' catalog class IDs.
        my $ConfigItemDataRef = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ConfigItem::Class',
            Name  => 'Location',
        );
        my $LocationConfigItemID = $ConfigItemDataRef->{ItemID};

        # Get 'Production' deployment state ID.
        my $DeplStateDataRef = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ConfigItem::DeploymentState',
            Name  => 'Production',
        );
        my $ProductionDeplStateID = $DeplStateDataRef->{ItemID};

        my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');
        my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');

        # Create ConfigItem number.
        my $ConfigItemNumber = $ConfigItemObject->ConfigItemNumberCreate(
            Type    => $ConfigObject->Get('ITSMConfigItem::NumberGenerator'),
            ClassID => $LocationConfigItemID,
        );

        ok(
            $ConfigItemNumber,
            "ConfigItem number is created - $ConfigItemNumber",
        );

        # Add 'Location' test ConfigItem.
        my $ConfigItemID = $ConfigItemObject->ConfigItemAdd(
            Number  => $ConfigItemNumber,
            ClassID => $LocationConfigItemID,
            UserID  => 1,
        );

        ok(
            $ConfigItemID,
            "ConfigItem 'Location' is created - ID $ConfigItemID",
        );

        # Add a new version.
        my $VersionName = "Selenium" . $Helper->GetRandomID();
        my $VersionID   = $ConfigItemObject->VersionAdd(
            Name         => $VersionName,
            DefinitionID => 1,
            DeplStateID  => $ProductionDeplStateID,
            InciStateID  => 1,
            UserID       => 1,
            ConfigItemID => $ConfigItemID,
        );

        ok(
            $VersionID,
            "Test version of the ConfigItem is created - ID $VersionID",
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'itsm-configitem' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AdminImportExport screen.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminImportExport");

        # Check screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Click on 'Add template'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminImportExport;Subaction=TemplateEdit' )]")->VerifiedClick();

        # Check and input step 1 of 5 screen.
        for my $StepOneID (
            qw(Name Object Format ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$StepOneID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        my $ImportExportName = "ImportExport" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name", 'css' )->send_keys($ImportExportName);
        $Selenium->execute_script(
            "\$('#Object').val('ITSMConfigItem').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script("\$('#Format').val('CSV').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->send_keys('SeleniumTest');
        $Selenium->find_element("//button[\@class='Primary CallForAction'][\@type='submit']")->VerifiedClick();

        # Check and input step 2 of 5 screen.
        for my $StepTwoID (
            qw(ClassID CountMax EmptyFieldsLeaveTheOldValues)
            )
        {
            my $Element = $Selenium->find_element( "#$StepTwoID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        $Selenium->execute_script(
            "\$('#ClassID').val('$LocationConfigItemID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@class='Primary CallForAction'][\@type='submit']")->VerifiedClick();

        # Check and input step 3 of 5 screen.
        for my $StepThreeID (
            qw(ColumnSeparator Charset IncludeColumnHeaders)
            )
        {
            my $Element = $Selenium->find_element( "#$StepThreeID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        $Selenium->execute_script(
            "\$('#ColumnSeparator').val('Comma').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@class='Primary CallForAction'][\@type='submit']")->VerifiedClick();

        # Check and input step 4 of 5 screen.
        $Selenium->find_element( "#MappingAddButton", 'css' )->VerifiedClick();
        for my $StepFourID (
            qw(Key Identifier)
            )
        {
            my $Element = $Selenium->find_element(".//*[\@id='Object::0::$StepFourID']");

            $Element->is_enabled();
            $Element->is_displayed();
        }

        for my $StepFourClass (
            qw(ArrowUp ArrowDown DeleteColumn)
            )
        {
            my $Element = $Selenium->find_element( ".$StepFourClass", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Select 'Number' mapping element.
        $Selenium->find_element(".//*[\@id='Object::0::Key']/option[2]")->click();

        # Add and select 'Name' mapping element.
        $Selenium->find_element( "#MappingAddButton", 'css' )->VerifiedClick();
        $Selenium->find_element(".//*[\@id='Object::1::Key']/option[3]")->click();

        # Add and select 'Deployment State' mapping element.
        $Selenium->find_element( "#MappingAddButton", 'css' )->VerifiedClick();
        $Selenium->find_element(".//*[\@id='Object::2::Key']/option[4]")->click();

        # Add and select 'Incident State' mapping element.
        $Selenium->find_element( "#MappingAddButton", 'css' )->VerifiedClick();
        $Selenium->find_element(".//*[\@id='Object::3::Key']/option[5]")->click();
        $Selenium->find_element( "#SubmitNextButton", 'css' )->VerifiedClick();

        # Check step 5 of 5 screen.
        for my $StepFourID (
            qw(RestrictExport Number Name DeplStateIDs InciStateIDs Type Phone1 Phone2
            Fax E-Mail Address Note)
            )
        {
            my $Element = $Selenium->find_element( "#$StepFourID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Search ConfigItem by number and deployment state.
        $Selenium->find_element( "#RestrictExport", 'css' )->click();
        $Selenium->find_element( "#Number",         'css' )->send_keys($ConfigItemNumber);
        $Selenium->find_element( "#Name",           'css' )->send_keys($VersionName);
        $Selenium->execute_script(
            "\$('#DeplStateIDs').val('$ProductionDeplStateID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script("\$('#InciStateIDs').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@class='Primary CallForAction'][\@type='submit']")->VerifiedClick();

        # Get needed objects.
        my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');
        my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');

        # Get TemplateID of created test template.
        $DBObject->Prepare(
            SQL   => 'SELECT id FROM imexport_template WHERE name = ?',
            Bind  => [ \$ImportExportName ],
            Limit => 1,
        );

        # Fetch the result.
        my $TemplateID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TemplateID = $Row[0];
        }

        # Navigate to test created ConfigItem and verify it.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentITSMConfigItemZoom;ConfigItemID=$ConfigItemID");
        $Selenium->content_contains(
            $VersionName,
            "Test ConfigItem name $VersionName - found",
        );

        # Export created test template.
        my $ExportResultRef = $ImportExportObject->Export(
            TemplateID => $TemplateID,
            UserID     => 1,
        );

        # Delete created test ConfigItem, so it can be imported back.
        $ConfigItemObject->ConfigItemDelete(
            ConfigItemID => $ConfigItemID,
            UserID       => 1,
        );

        my $ConfigItem = $ConfigItemObject->ConfigItemGet(
            ConfigItemID => $ConfigItemID,
            Cache        => 0,
        );

        # Check if ConfigItem is deleted.
        ok( !$ConfigItem, "ConfigItem is deleted - ID $ConfigItemID" );

        # Refresh screen and verify that test ConfigItem does not exist anymore.
        $Selenium->VerifiedRefresh();
        $Selenium->content_contains(
            "Can\'t show item, no access rights for ConfigItem are given!",
            "Test ConfigItem name $VersionName is not found",
        );

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        # Create test Exported file to a system.
        my $ExportFileName = "ITSMExport" . $Helper->GetRandomID() . ".csv";
        my $ExportLocation = $ConfigObject->Get('Home') . "/var/tmp/" . $ExportFileName;
        my $Success        = $MainObject->FileWrite(
            Location   => $ExportLocation,
            Content    => \$ExportResultRef->{DestinationContent}->[0],
            Mode       => 'utf8',
            Type       => 'Attachment',
            Permission => '664',
        );
        ok(
            $Success,
            "Export file $ExportFileName '$ExportLocation' is created",
        );

        # Navigate to AdminImportExport screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminImportExport");

        # Click on 'Import'.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ImportInformation;TemplateID=$TemplateID' )]")->VerifiedClick();

        # Select Exported file and start importing.
        $Selenium->find_element("//input[contains(\@name, \'SourceFile' )]")->send_keys($ExportLocation);

        $Selenium->find_element("//button[\@value='Start Import'][\@type='submit']")->VerifiedClick();

        # Check for expected outcome.
        $Selenium->content_contains(
            '(Created: 1)',
            "Import test ConfigItem - success",
        );

        # Navigate to imported test created ConfigItem and verify it.
        my $ImportedConfigItemID = $ConfigItemID + 1;
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentITSMConfigItemZoom;ConfigItemID=$ImportedConfigItemID"
        );
        $Selenium->content_contains(
            $VersionName,
            "Test ConfigItem name $VersionName is found",
        );

        # Navigate to AdminImportExport screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminImportExport");

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "a.ImportExportDelete[data-id='$TemplateID']",
        );

        # Click to delete test template.
        $Selenium->find_element( "a.ImportExportDelete[data-id='$TemplateID']", 'css' )->click();

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#DialogButton1:visible",
        );

        $Selenium->find_element( '#DialogButton1', 'css' )->click();
        $Selenium->WaitFor( ElementMissing => [ "a.ImportExportDelete[data-id='$TemplateID']", 'css' ] );

        # Check if test template is deleted.
        ok(
            !$Selenium->execute_script(
                "return \$('a.ImportExportDelete[data-id*=\"$TemplateID\"]').length;"
            ),
            "Test template is deleted",
        );

        # Delete test imported ConfigItem.
        $Success = $ConfigItemObject->ConfigItemDelete(
            ConfigItemID => $ImportedConfigItemID,
            UserID       => 1,
        );
        ok(
            $Success,
            "ConfigItem is deleted - ID $ImportedConfigItemID",
        );

        # delete test Exported file from system.
        $Success = $MainObject->FileDelete(
            Location => $ExportLocation,
            Type     => 'Attachment',
        );
        ok(
            $Success,
            "Export file $ExportFileName is deleted",
        );

    }
);

done_testing;
