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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::TimeSettings;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

# core modules
use POSIX qw(tzname);

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTOBO') . '/' . Translatable('Time Settings');
}

sub Run {
    my $Self = shift;

    # Server time zone
    my $ServerTimeZone = tzname();

    $Self->AddResultOk(
        Identifier => 'ServerTimeZone',
        Label      => Translatable('Server time zone'),
        Value      => $ServerTimeZone,
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # OTOBO time zone
    my $OTOBOTimeZone = $ConfigObject->Get('OTOBOTimeZone');
    if ( defined $OTOBOTimeZone ) {
        $Self->AddResultOk(
            Identifier => 'OTOBOTimeZone',
            Label      => Translatable('OTOBO time zone'),
            Value      => $OTOBOTimeZone,
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'OTOBOTimeZone',
            Label      => Translatable('OTOBO time zone'),
            Value      => '',
            Message    => Translatable('OTOBO time zone is not set.'),
        );
    }

    # User default time zone
    my $UserDefaultTimeZone = $ConfigObject->Get('UserDefaultTimeZone');
    if ( defined $UserDefaultTimeZone ) {
        $Self->AddResultOk(
            Identifier => 'UserDefaultTimeZone',
            Label      => Translatable('User default time zone'),
            Value      => $UserDefaultTimeZone,
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'UserDefaultTimeZone',
            Label      => Translatable('User default time zone'),
            Value      => '',
            Message    => Translatable('User default time zone is not set.'),
        );
    }

    # Calendar time zones
    my $Maximum = $ConfigObject->Get("MaximumCalendarNumber") || 50;

    COUNTER:
    for my $Counter ( '', 1 .. $Maximum ) {
        my $CalendarName = $ConfigObject->Get( 'TimeZone::Calendar' . $Counter . 'Name' );

        next COUNTER if !$CalendarName;

        my $CalendarTimeZone = $ConfigObject->Get( 'TimeZone::Calendar' . $Counter );

        if ( defined $CalendarTimeZone ) {
            $Self->AddResultOk(
                Identifier => "OTOBOTimeZone::Calendar$Counter",

                # Use of $LanguageObject->Translate() is not possible to avoid translated strings to be sent to OTOBO Team.
                Label => "OTOBO time zone setting for calendar $Counter",
                Value => $CalendarTimeZone,
            );
        }
        else {
            $Self->AddResultInformation(
                Identifier => "OTOBOTimeZone::Calendar$Counter",

                # Use of $LanguageObject->Translate() is not possible to avoid translated strings to be sent to OTOBO Team.
                Label   => "OTOBO time zone setting for calendar $Counter",
                Value   => '',
                Message => Translatable('Calendar time zone is not set.'),
            );
        }
    }

    return $Self->GetResults();
}

1;
