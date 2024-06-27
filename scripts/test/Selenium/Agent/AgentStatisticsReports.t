# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and $Self
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $StatsObject  = $Kernel::OM->Get('Kernel::System::Stats');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Define needed variable.
        my $RandomID = $Helper->GetRandomID();
        my %VerifyStatsReportData;

        # Read sample statistics.
        my $StatisticContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $ConfigObject->Get('Home')
                . '/scripts/test/sample/Stats/Stats.TestTicketList.en.xml',
        );

        # Import test sample statistics.
        my $TestStatID = $StatsObject->Import(
            Content => $StatisticContent,
            UserID  => 1,
        );
        $Self->True(
            $TestStatID,
            "Successfully imported StatID $TestStatID",
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AgentStatisticsReports screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatisticsReports;Subaction=Overview");

        # Verify layout in overview screen.
        $Self->Is(
            $Selenium->execute_script('return $("div.ContentColumn").find("h2").text();'),
            'Statistics Reports',
            "ContentColumn header 'Statistics Reports' is found"
        );

        my $Count = 0;
        for my $TableHeader (qw(Name Description Delete Run)) {
            $Self->Is(
                $Selenium->execute_script("return \$('table thead tr').find('th:eq($Count)').text();"),
                $TableHeader,
                "Table header $TableHeader is found"
            );

            $Count++;
        }

        # Click on 'Add' action.
        $Selenium->find_element("//a[contains(\@href, 'AgentStatisticsReports;Subaction=Add')]")->VerifiedClick();

        # Verify ContentColumn layout.
        $Self->Is(
            $Selenium->execute_script('return $("div.ContentColumn").find("h2").text();'),
            'Add Report',
            "ContentColumn header 'Add Report' is found"
        );

        # Verify SidebarColumn layout.
        $Self->Is(
            $Selenium->execute_script('return $("div.SidebarColumn").find("h2").text();'),
            'Actions',
            "SidebarColumn header 'Actions' is found"
        );
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, 'AgentStatisticsReports;Subaction=Overview')]"),
            "SidebarColumn 'Go to overview' button is found"
        );

        # Create new statistic report.
        my %StatsReportData = (
            Name        => 'Selenium Stat Report ' . $RandomID,
            Description => 'Selenium Description ' . $RandomID,
        );

        # Add name and description.
        for my $AddNew ( sort keys %StatsReportData ) {
            $Selenium->find_element( "#$AddNew", 'css' )->send_keys( $StatsReportData{$AddNew} );
        }

        # Click on 'Save'.
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Verify ContentColumn layout in this step.
        $Count = 0;
        for my $ContentColumHeader (qw(Settings Statistics Save)) {

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('div.ContentColumn div.WidgetSimple:eq($Count)').find('h2').text();"
                ),
                $ContentColumHeader,
                "ContentColumn header '$ContentColumHeader' is found"
            );
            $Count++;
        }

        # Verify SidebarColumn layout.
        $Count = 0;
        for my $SidebarColumnHeader (qw(Actions Note)) {
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('div.SidebarColumn div.WidgetSimple:eq($Count)').find('h2').text();"
                ),
                $SidebarColumnHeader,
                "SidebarColumn header '$SidebarColumnHeader' is found"
            );
            $Count++;
        }

        my $BrowserFound = $ConfigObject->Get('GoogleChrome::Bin') ? 1 : 0;

        if ($BrowserFound) {
            $Self->True(
                $BrowserFound,
                "Browser is found, skip test case - SidebarColumn 'Note'"
            );
        }
        else {

            # Verify SidebarColumn 'Note' values.
            my $NotePartOne
                = 'Here you can combine several statistics to a report which you can generate as a PDF manually or automatically at configured times.';
            my $NotePartTwo
                = 'Please note that you can only select charts as statistics output format if you configured one of the renderer binaries on your system.';

            $Count = 0;
            for my $SidebarColumnNoteCheck ( $NotePartOne, $NotePartTwo ) {
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('div.SidebarColumn div.WidgetSimple div.Content').find('p.FieldExplanation:eq($Count)').text().trim();"
                    ),
                    $SidebarColumnNoteCheck,
                    "SidebarColumn note value is found"
                ) || die;
                $Count++;
            }

            # Verify button for 'Configure GoogleChrome'.
            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, 'Action=AdminSystemConfigurationGroup;RootNavigation=Core::GoogleChrome')]"
                ),
                "SidebarColumn note button for 'Configure GoogleChrome' is found"
            );
        }

        # Verify and input fields in 'Automatic generation settings'.
        my %AutomaticGenerationSettings = (
            CronDefinition => {
                Label            => 'Automatic generation times (cron):',
                Value            => '10 1 * * *',
                FieldExplanation =>
                    'Specify when the report should be automatically generated in cron format, e. g. "10 1 * * *" for every day at 1:10 am.',
                FieldExplanation2 => 'Times are in the system timezone.',
                FieldOrder        => 0,
            },
            LanguageID => {
                Label            => 'Automatic generation language:',
                FieldExplanation => 'The language to be used when the report is automatically generated.',
                FieldOrder       => 1,
            },
            EmailSubject => {
                Label            => 'Email subject:',
                Value            => 'Report Email Subject ' . $RandomID,
                FieldExplanation => 'Specify the subject for the automatically generated email.',
                FieldOrder       => 2,
            },
            EmailBody => {
                Label            => 'Email body:',
                Value            => 'Report Email Body ' . $RandomID,
                FieldExplanation => 'Specify the text for the automatically generated email.',
                FieldOrder       => 3,
            },
            EmailRecipients => {
                Label            => 'Email recipients:',
                Value            => $RandomID . '@localhost.com',
                FieldExplanation => 'Specify recipient email addresses (comma separated).',
                FieldOrder       => 4,
            },
        );

        for my $AutomaticGenerationField ( sort keys %AutomaticGenerationSettings ) {

            # Input field.
            if ( $AutomaticGenerationSettings{$AutomaticGenerationField}->{Value} ) {
                $Selenium->find_element( "#$AutomaticGenerationField", 'css' )
                    ->send_keys( $AutomaticGenerationSettings{$AutomaticGenerationField}->{Value} );
            }

            # Verify field label.
            $Self->Is(
                $Selenium->find_element("//label[\@for='$AutomaticGenerationField']")->get_text(),
                $AutomaticGenerationSettings{$AutomaticGenerationField}->{Label},
                "Label $AutomaticGenerationSettings{$AutomaticGenerationField}->{Label} is found"
            );

            # Verify field explanation value.
            my $FieldOrder = $AutomaticGenerationSettings{$AutomaticGenerationField}->{FieldOrder};
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('form#MainForm fieldset.TableLike:eq(2)').find('div.Field:eq($FieldOrder)').find('p.FieldExplanation:eq(0)').text().trim();"
                ),
                $AutomaticGenerationSettings{$AutomaticGenerationField}->{FieldExplanation},
                "Field explanation for field $AutomaticGenerationField is found"
            );

            if ( $AutomaticGenerationField eq 'CronDefinition' ) {

                # Verify added field explanation value for timezones.
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('form#MainForm fieldset.TableLike:eq(2)').find('div.Field:eq($FieldOrder)').find('p.FieldExplanation:eq(1)').text().trim();"
                    ),
                    $AutomaticGenerationSettings{$AutomaticGenerationField}->{FieldExplanation2},
                    "Field explanation for field $AutomaticGenerationField is found"
                );

                # Verify if you enter CronDefinition value that other AutomaticGeneration values are required.
                $Selenium->find_element("//button[\@id='SaveAndFinishButton']")->click();
                for my $RequiredFields (qw(EmailSubject EmailBody EmailRecipients)) {

                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#$RequiredFields').hasClass('Error')"
                        ),
                        '1',
                        "Client side validation correctly detected missing $RequiredFields input value",
                    );
                }
            }
        }

        # Verify and input fields in 'Output settings'.
        my %OutputSettings = (
            Headline => {
                Label     => 'Headline:',
                Value     => 'Selenium Headline ' . $RandomID,
                FieldType => 'input',
                Check     => 1,
            },
            Title => {
                Label     => 'Title:',
                Value     => 'Selenium Title ' . $RandomID,
                FieldType => 'input',
                Check     => 1,
            },
            PreambleCaption => {
                Label     => 'Caption for preamble:',
                Value     => 'Selenium Caption for preamble ' . $RandomID,
                FieldType => 'input',
                Check     => 1,
            },
            Preamble => {
                Label     => 'Preamble:',
                Value     => 'Selenium preamble ' . $RandomID,
                FieldType => 'textarea',
                Check     => 1,
            },
            EpilogueCaption => {
                Label     => 'Caption for epilogue:',
                Value     => 'Selenium Caption for epilogue ' . $RandomID,
                FieldType => 'input',
                Check     => 1,
            },
            Epilogue => {
                Label     => 'Epilogue:',
                Value     => 'Selenium epilogue ' . $RandomID,
                FieldType => 'textarea',
            },
        );

        for my $OutputField ( sort keys %OutputSettings ) {

            # Verify field label.
            $Self->Is(
                $Selenium->find_element("//label[\@for='$OutputField']")->get_text(),
                $OutputSettings{$OutputField}->{Label},
                "Label $OutputSettings{$OutputField}->{Label} is found"
            );

            # Input field.
            my $FieldType = $OutputSettings{$OutputField}->{FieldType};
            $Selenium->find_element("//$FieldType\[\@name='$OutputField']")
                ->send_keys( $OutputSettings{$OutputField}->{Value} );

            if ( $OutputSettings{$OutputField}->{Check} ) {

                # save inputed values for later check
                $VerifyStatsReportData{$OutputField} = $OutputSettings{$OutputField}->{Value};
            }
        }

        # Add test imported statistics to the report.
        $Selenium->execute_script("\$('#StatsAdd').val('$TestStatID').trigger('redraw.InputField').trigger('change');");

        # Wait for stat to load if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".StatRemove").length;'
        );

        # Verify and input fields for stats output setting.
        my %StatsOutputSettings = (
            Title => {
                Label            => 'Title:',
                Value            => 'Selenium Stats Title ' . $RandomID,
                FieldExplanation => "If you don't specify a title here, the title of the statistic will be used.",
                FieldType        => 'input',
                Check            => 1,
            },
            Preface => {
                Label     => 'Preface:',
                Value     => 'Selenium Stat preface ' . $RandomID,
                FieldType => 'textarea',
            },
            Postface => {
                Label     => 'Postface:',
                Value     => 'Selenium Stat postface ' . $RandomID,
                FieldType => 'textarea',
            },
        );

        for my $StatsOutputField ( sort keys %StatsOutputSettings ) {

            # Verify field label.
            $Self->Is(
                $Selenium->find_element("//label[\@for='$StatsOutputField']")->get_text(),
                $StatsOutputSettings{$StatsOutputField}->{Label},
                "Label $StatsOutputSettings{$StatsOutputField}->{Label} is found"
            );

            # Verify stats Title field explanation and input fields.
            if ( $StatsOutputField eq 'Title' ) {
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('div#StatsContainer fieldset.TableLike').find('div.Field:eq(0)').find('p.FieldExplanation').text().trim();"
                    ),
                    $StatsOutputSettings{$StatsOutputField}->{FieldExplanation},
                    "Field explanation for field $StatsOutputField is found"
                );

                # Input value and save it for later check.
                $Selenium->find_element( "#UseAsRestrictionQueueIDs_Search", 'css' )
                    ->send_keys( "\N{U+E004}", $StatsOutputSettings{$StatsOutputField}->{Value} );
                $VerifyStatsReportData{$StatsOutputField} = $StatsOutputSettings{$StatsOutputField}->{Value};
            }
            else {
                my $FieldType = $StatsOutputSettings{$StatsOutputField}->{FieldType};
                $Selenium->find_element("//$FieldType\[contains(\@name, '$StatsOutputField')]")
                    ->send_keys( $StatsOutputSettings{$StatsOutputField}->{Value} );
            }
        }

        # Click to 'Save and finish' test stats report.
        $Selenium->find_element("//button[\@id='SaveAndFinishButton']")->VerifiedClick();

        # Verify stats report is created.
        for my $ReportOverview ( sort keys %StatsReportData ) {
            $Self->True(
                index( $Selenium->get_page_source(), $StatsReportData{$ReportOverview} ) > -1,
                "$StatsReportData{$ReportOverview} is found",
            );
        }

        # Get created stats report data.
        my $CreatedStatsReportData = $Kernel::OM->Get('Kernel::System::StatsReport')->StatsReportGet(
            Name => $StatsReportData{Name},
        );

        # Click 'Run now' for test report in overview screen.
        $Selenium->find_element(
            "//a[contains(\@href, 'AgentStatisticsReports;Subaction=View;StatsReportID=$CreatedStatsReportData->{ID}')]"
        )->VerifiedClick();

        # Click 'Run now' in view screen.
        $Selenium->find_element("//button[\@name='Start'][\@type='submit']")->click();

        # Test PDF download on Firefox browser only.
        if ( $Selenium->{browser_name} eq 'firefox' ) {

            # Special approach is used for waiting for PDF document to be loaded fully before checking it's content.
            # Currently this is supported in Mozilla Firefox browser.
            $Selenium->WaitFor( JavaScript => 'return document.getElementsByClassName("endOfContent").length === 3;' );

            for my $Value ( sort keys %OutputSettings ) {

                # Verify values of created PDF report.
                $Self->True(
                    index( $Selenium->get_page_source(), $VerifyStatsReportData{$Value} ) > -1,
                    "PDF report value '$VerifyStatsReportData{$Value}' is found",
                );
            }
        }

        # Navigate back to AgentStatisticsReports overview screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentStatisticsReports;Subaction=Overview");

        # Click to edit test created stats report.
        $Selenium->find_element(
            "//a[contains(\@href, 'AgentStatisticsReports;Subaction=Edit;StatsReportID=$CreatedStatsReportData->{ID}')]"
        )->VerifiedClick();

        # Switch created stats report to invalid and save.
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");

        $Selenium->find_element("//button[\@id='SaveAndFinishButton']")->VerifiedClick();

        # Verify it's not possible to run invalid stats report.
        my $InvalidReportRun;
        eval {
            $InvalidReportRun = $Selenium->find_element(
                "//a[contains(\@href, 'AgentStatisticsReports;Subaction=View;StatsReportID=$CreatedStatsReportData->{ID}')]"
            );
        };
        $Self->False(
            $InvalidReportRun,
            "Is is not possible to run invalid stats report"
        );

        # Click on 'Add' again.
        $Selenium->find_element("//a[contains(\@href, 'AgentStatisticsReports;Subaction=Add')]")->VerifiedClick();

        # Try to add report with same name.
        for my $AddExisting ( sort keys %StatsReportData ) {
            $Selenium->find_element( "#$AddExisting", 'css' )->send_keys( $StatsReportData{$AddExisting} );
        }
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Click on dialog button to confirm error message.
        $Selenium->find_element("//button[\@id='DialogButton1']")->click();

        # Verify there is error class.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error');"
            ),
            '1',
            'Client side validation correctly detected existing report with same name',
        );

        # Click to return to overview screen again.
        $Selenium->find_element("//a[contains(\@href, 'AgentStatisticsReports;Subaction=Overview;')]")->VerifiedClick();

        # Click on delete icon.
        my $CheckConfirmJSBlock = <<"JAVASCRIPT";
(function () {
var lastConfirm = undefined;
window.confirm = function (message) {
    lastConfirm = message;
    return false; // stop procedure at first try
};
window.getLastConfirm = function () {
    var result = lastConfirm;
    lastConfirm = undefined;
    return result;
};
}());
JAVASCRIPT
        $Selenium->execute_script($CheckConfirmJSBlock);

        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=DeleteAction;StatsReportID=$CreatedStatsReportData->{ID}' )]"
        )->click();

        $Self->Is(
            $Selenium->execute_script("return window.getLastConfirm();"),
            "\"$CreatedStatsReportData->{Name}\"\n\nDo you really want to delete this report?",
            'Check for opened confirm text',
        );

        my $CheckConfirmJSProceed = <<"JAVASCRIPT";
(function () {
var lastConfirm = undefined;
window.confirm = function (message) {
    lastConfirm = message;
    return true; // allow procedure at second try
};
window.getLastConfirm = function () {
    var result = lastConfirm;
    lastConfirm = undefined;
    return result;
};
}());
JAVASCRIPT
        $Selenium->execute_script($CheckConfirmJSProceed);

        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=DeleteAction;StatsReportID=$CreatedStatsReportData->{ID}' )]"
        )->VerifiedClick();

        # Wait for delete dialog to disappear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # Check if stats report is deleted.
        $Self->True(
            index( $Selenium->get_page_source(), $CreatedStatsReportData->{Name} ) == -1,
            "$CreatedStatsReportData->{Name} is deleted",
        );

        # Delete test imported stats.
        $Self->True(
            $StatsObject->StatsDelete(
                StatID => $TestStatID,
                UserID => 1,
            ),
            "Imported stats is deleted - ID $TestStatID",
        );
    }

);

$Self->DoneTesting();
