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

package Kernel::Modules::PublicCalendar;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # check needed parameters
    for my $Needed (qw(CalendarID User Token)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->PublicErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'No %s!', $Needed ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
    }

    # get user
    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        User  => $GetParam{User},
        Valid => 1,
    );
    if ( !%User ) {
        return $LayoutObject->PublicErrorScreen(
            Message => Translatable('No such user!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

    # get calendar
    my %Calendar = $CalendarObject->CalendarGet(
        CalendarID => $GetParam{CalendarID},
        UserID     => $User{UserID},
    );

    if ( !%Calendar ) {
        return $LayoutObject->PublicErrorScreen(
            Message => Translatable('No permission!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    if ( $Calendar{ValidID} != 1 ) {
        return $LayoutObject->PublicErrorScreen(
            Message => Translatable('Invalid calendar!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # check access token
    my $AccessToken = $CalendarObject->GetAccessToken(
        CalendarID => $GetParam{CalendarID},
        UserLogin  => $GetParam{User},
    );

    if ( $AccessToken ne $GetParam{Token} ) {
        return $LayoutObject->PublicErrorScreen(
            Message => Translatable('Invalid URL!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get iCalendar string
    my $ICalString = $Kernel::OM->Get('Kernel::System::Calendar::Export::ICal')->Export(
        CalendarID => $Calendar{CalendarID},
        UserID     => $User{UserID},
    );

    if ( !$ICalString ) {
        return $LayoutObject->PublicErrorScreen(
            Message => Translatable('There was an error exporting the calendar!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # prepare the file name
    my $Filename = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
        Filename => "$Calendar{CalendarName}.ics",
        Type     => 'Attachment',
    );

    # send iCal response
    return $LayoutObject->Attachment(
        ContentType => 'text/calendar',
        Charset     => $LayoutObject->{Charset},
        Content     => $ICalString,
        Filename    => $Filename,
        NoCache     => 1,
    );
}

1;
