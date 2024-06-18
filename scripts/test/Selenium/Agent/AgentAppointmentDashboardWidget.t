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

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

        # Dashboard widget config key.
        my $DashboardConfigKey = '0500-AppointmentCalendar';

        # Turn on dashboard widget by default.
        my $DashboardConfig = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend')->{$DashboardConfigKey};
        $DashboardConfig->{Default} = 1;
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "DashboardBackend###$DashboardConfigKey",
            Value => $DashboardConfig,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Created test group - $GroupID",
        );

        # Create test user.
        my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
            Groups => [$GroupName],
        );
        $Self->True(
            $UserID,
            "Created test user - $UserID",
        );

        # Create a test calendar.
        my %Calendar = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        $Self->True(
            $Calendar{CalendarID},
            "Created test calendar - $Calendar{CalendarID}",
        );

        # Get current time.
        my $StartTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        # Just before midnight today.
        my $TodayTimeObject = $StartTimeObject->Clone();
        $TodayTimeObject->Set(
            Hour   => 23,
            Minute => 59,
            Second => 59,
        );

        my $TomorrowTimeObject = $StartTimeObject->Clone();
        $TomorrowTimeObject->Add(
            Days => 1,
        );

        my $DayAfterTomorrowTimeObject = $StartTimeObject->Clone();
        $DayAfterTomorrowTimeObject->Add(
            Days => 2,
        );

        my $TwoDaysAfterTomorrowTimeObject = $StartTimeObject->Clone();
        $TwoDaysAfterTomorrowTimeObject->Add(
            Days => 3,
        );

        # Sample appointments.
        my @Appointments = (

            # Today.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $TodayTimeObject->ToString(),
                EndTime    => $TodayTimeObject->ToString(),
                Title      => "Today $RandomID",
                UserID     => $UserID,
                Filter     => 'Today',
            },

            # Tomorrow.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $TomorrowTimeObject->ToString(),
                EndTime    => $TomorrowTimeObject->ToString(),
                Title      => "Tomorrow $RandomID",
                UserID     => $UserID,
                Filter     => 'Tomorrow',
            },

            # Day after tomorrow.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $DayAfterTomorrowTimeObject->ToString(),
                EndTime    => $DayAfterTomorrowTimeObject->ToString(),
                Title      => "Day after tomorrow $RandomID",
                UserID     => $UserID,
                Filter     => 'Soon',
            },

            # Two days after tomorrow.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $TwoDaysAfterTomorrowTimeObject->ToString(),
                EndTime    => $TwoDaysAfterTomorrowTimeObject->ToString(),
                Title      => "Two days after tomorrow $RandomID",
                UserID     => $UserID,
                Filter     => 'Soon',
            },
        );

        # Create appointments.
        for my $Appointment (@Appointments) {
            my $AppointmentID = $AppointmentObject->AppointmentCreate(
                %{$Appointment},
            );
            $Self->True(
                $AppointmentID,
                "Created test appointment - $AppointmentID",
            );
            $Appointment->{AppointmentID} = $AppointmentID;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Verify widget is present.
        $Selenium->find_element( "#Dashboard$DashboardConfigKey", 'css' );

        # Check appointments.
        my %FilterCount;
        for my $Appointment (@Appointments) {

            my $AppointmentID = $Appointment->{AppointmentID};

            # Remember filter.
            $FilterCount{ $Appointment->{Filter} } += 1;

            # Switch filter.
            $Selenium->find_element("//a[\@id='Dashboard${DashboardConfigKey}$Appointment->{Filter}']")->click();

            # Wait until all AJAX calls finished.
            $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

            # Verify appointment is visible.
            $Selenium->find_element("//a[contains(\@href, \'AppointmentID=$Appointment->{AppointmentID}\')]");
        }

        # Refresh the AgentDashboard screen.
        $Selenium->VerifiedRefresh();

        # Check filter count.
        for my $Filter ( sort keys %FilterCount ) {

            # Get filter link.
            my $FilterLink = $Selenium->find_element( "#Dashboard${DashboardConfigKey}${Filter}", 'css' );

            $Self->Is(
                $FilterLink->get_text(),
                "$Filter ($FilterCount{$Filter})",
                "Filter count - $Filter",
            );
        }

        # Delete test appointments.
        for my $Appointment (@Appointments) {
            my $Success = $AppointmentObject->AppointmentDelete(
                AppointmentID => $Appointment->{AppointmentID},
                UserID        => $UserID,
            );
            $Self->True(
                $Success,
                "Deleted test appointment - $Appointment->{AppointmentID}",
            );
        }

        # Delete test calendar.
        if ( $Calendar{CalendarID} ) {
            my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL  => 'DELETE FROM calendar WHERE id = ?',
                Bind => [ \$Calendar{CalendarID} ],
            );
            $Self->True(
                $Success,
                "Deleted test calendar - $Calendar{CalendarID}",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Calendar Appointment)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

$Self->DoneTesting();
