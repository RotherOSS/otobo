# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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


package Kernel::Output::HTML::Layout::Datepicker;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Datepicker - Datepicker data

=head1 DESCRIPTION

All valid functions.

=head1 PUBLIC INTERFACE

=head2 DatepickerGetVacationDays()

Returns a hash of all vacation days defined in the system.

    $LayoutObject->DatepickerGetVacationDays();

=cut

sub DatepickerGetVacationDays {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get the defined vacation days
    my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $TimeVacationDays        = $ConfigObject->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $ConfigObject->Get(
                "TimeVacationDaysOneTime::Calendar" . $Param{Calendar}
            );
        }
    }

    # translate the vacation description if possible
    for my $Month ( sort keys %{$TimeVacationDays} ) {
        for my $Day ( sort keys %{ $TimeVacationDays->{$Month} } ) {
            $TimeVacationDays->{$Month}->{$Day}
                = $Self->{LanguageObject}->Translate( $TimeVacationDays->{$Month}->{$Day} );
        }
    }

    for my $Year ( sort keys %{$TimeVacationDaysOneTime} ) {
        for my $Month ( sort keys %{ $TimeVacationDaysOneTime->{$Year} } ) {
            for my $Day ( sort keys %{ $TimeVacationDaysOneTime->{$Year}->{$Month} } ) {
                $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} = $Self->{LanguageObject}->Translate(
                    $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day}
                );
            }
        }
    }
    return {
        'TimeVacationDays'        => $TimeVacationDays,
        'TimeVacationDaysOneTime' => $TimeVacationDaysOneTime,
    };
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
