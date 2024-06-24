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

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

        my $RandomID = $Helper->GetRandomID();
        my $Limit    = 10;

        # Set CalendarLimitOverview.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AppointmentCalendar::CalendarLimitOverview',
            Value => $Limit,
        );

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        # Create test user.
        my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
            Groups => [ 'users', $GroupName ],
        );

        my $InvalidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
            Valid => 'invalid',
        );

        # Get all valid calendars in the system and set them to invalid.
        # At the end of the test, set them back to valid state.
        my @OldCalendars = $CalendarObject->CalendarList(
            ValidID => 1,
        );
        for my $OldCalendar (@OldCalendars) {
            my $Success = $CalendarObject->CalendarUpdate(
                CalendarID   => $OldCalendar->{CalendarID},
                GroupID      => $OldCalendar->{GroupID},
                CalendarName => $OldCalendar->{CalendarName},
                Color        => $OldCalendar->{Color},
                UserID       => $UserID,
                ValidID      => $InvalidID,
            );
            $Self->True(
                $Success,
                "CalendarID $OldCalendar->{CalendarID} is set to invalid",
            );
        }

        # Create test calendars.
        my @Calendars;
        my $LastCalendarIndex = 15;
        for my $Count ( 0 .. $LastCalendarIndex ) {
            my $CalendarName = "Calendar$Count-$RandomID";
            my %Calendar     = $CalendarObject->CalendarCreate(
                CalendarName => $CalendarName,
                Color        => '#3A87AD',
                GroupID      => $GroupID,
                UserID       => $UserID,
                ValidID      => 1,
            );
            $Self->True(
                $Calendar{CalendarID},
                "CalendarID $Calendar{CalendarID} is created",
            );
            push @Calendars, {
                CalendarID   => $Calendar{CalendarID},
                CalendarName => $CalendarName,
            };

            $Count++;
        }

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Verify that only first calendars (limited by CalendarLimitOverview setting) are checked.
        for my $Index ( 0 .. $LastCalendarIndex ) {
            my $Length       = ( $Index < $Limit ) ? 1         : 0;
            my $Checked      = $Length             ? 'checked' : 'unchecked';
            my $CalendarID   = $Calendars[$Index]->{CalendarID};
            my $CalendarName = $Calendars[$Index]->{CalendarName};

            # Wait until checkbox and its change event has been loaded.
            $Selenium->WaitFor( JavaScript => "return \$('#Calendar$CalendarID:checked').length == $Length;" );

            $Self->Is(
                $Selenium->execute_script("return \$('#Calendar$CalendarID:checked').length;"),
                $Length,
                "By default - CalendarID $CalendarID, CalendarName $CalendarName - $Checked",
            ) || die;
        }

        my @CheckedIndices = ( 1, 2, 5, 8, 11, 12, 14 );

        # Uncheck all and then check calendars from the array.
        $Selenium->execute_script("\$('#Calendars tbody input[type=checkbox]').prop('checked', false);");

        # Wait until all checkboxes are unchecked.
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#Calendars tbody input[type=checkbox]').filter( function() { return \$(this).prop('checked') == true; } ).length === 0;"
        );

        $Self->True(
            $Selenium->execute_script(
                "return \$('#Calendars tbody input[type=checkbox]').filter( function() { return \$(this).prop('checked') == true; } ).length === 0;"
            ),
            "All checkboxes are unchecked",
        );

        for my $Index (@CheckedIndices) {
            my $CalendarID   = $Calendars[$Index]->{CalendarID};
            my $CalendarName = $Calendars[$Index]->{CalendarName};

            $Selenium->execute_script(
                "\$(\"#Calendar$CalendarID\")[0].scrollIntoView(true);",
            );
            $Self->True(
                $Selenium->execute_script("return !\$('#Calendar$CalendarID:checked').length;"),
                "Before checking - CalendarID $CalendarID, CalendarName $CalendarName - unchecked",
            );
            $Selenium->find_element( "#Calendar$CalendarID", 'css' )->click();

            $Selenium->WaitFor(
                JavaScript =>
                    "return !\$('.CalendarWidget.Loading').length && \$('#Calendar$CalendarID:checked').length;"
            );

            $Self->True(
                $Selenium->execute_script("return \$('#Calendar$CalendarID:checked').length;"),
                "Checking - CalendarID $CalendarID, CalendarName $CalendarName - checked",
            );
        }

        # Go again to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Create a hash from the array for easier comparison.
        my %CheckedIndicesHash = map { $_ => 1 } @CheckedIndices;

        # Verify that only calendars from the array are checked (see bug#14054).
        for my $Index ( 0 .. $LastCalendarIndex ) {
            my $Length       = $CheckedIndicesHash{$Index} ? 1         : 0;
            my $Checked      = $Length                     ? 'checked' : 'unchecked';
            my $CalendarID   = $Calendars[$Index]->{CalendarID};
            my $CalendarName = $Calendars[$Index]->{CalendarName};

            $Selenium->WaitFor( JavaScript => "return \$('#Calendar$CalendarID:checked').length == $Length;" );

            $Self->Is(
                $Selenium->execute_script("return \$('#Calendar$CalendarID:checked').length;"),
                $Length,
                "After changes - CalendarID $CalendarID, CalendarName $CalendarName - $Checked",
            ) || die;
        }

        # Set old calendar to valid state.
        for my $OldCalendar (@OldCalendars) {
            my $Success = $CalendarObject->CalendarUpdate(
                CalendarID   => $OldCalendar->{CalendarID},
                GroupID      => $OldCalendar->{GroupID},
                CalendarName => $OldCalendar->{CalendarName},
                Color        => $OldCalendar->{Color},
                UserID       => $UserID,
                ValidID      => 1,
            );
            $Self->True(
                $Success,
                "CalendarID $OldCalendar->{CalendarID} is set to valid",
            );
        }

        # Cleanup.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        # Delete test calendars.
        for my $Calendar (@Calendars) {
            my $CalendarID = $Calendar->{CalendarID};
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM calendar WHERE id = ?",
                Bind => [ \$CalendarID ],
            );
            $Self->True(
                $Success,
                "CalendarID $CalendarID is deleted",
            );
        }

        # Delete group-user relations.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group-user relation is deleted",
        );

        # Delete test group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups_table WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "GroupID $GroupID is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Calendar Group)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

$Self->DoneTesting();
