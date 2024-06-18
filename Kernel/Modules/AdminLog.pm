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

package Kernel::Modules::AdminLog;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Print form.
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # Get log data.
    my $Log = $Kernel::OM->Get('Kernel::System::Log')->GetLog() || '';

    # Split data to lines.
    my $Limit    = 400;
    my @Messages = split /\n/, $Log;
    splice @Messages, $Limit;

    # Create months map.
    my %MonthMap;
    my @Months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    @MonthMap{@Months} = ( 1 .. 12 );

    # Get current user time zone.
    my $TimeZone = $Self->{UserTimeZone} || $Kernel::OM->Create('Kernel::System::DateTime')->UserDefaultTimeZoneGet();

    # Create table.
    ROW:
    for my $Row (@Messages) {

        my @Parts = split /;;/, $Row;

        next ROW if !$Parts[3];

        my $ErrorClass = ( $Parts[1] =~ /error/ ) ? 'Error' : '';

        # Create date and time object from ctime log stamp.
        my @Time = split ' ', $Parts[0];    # pattern ' ' is treated as /\s+/
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => "$Time[4]-$MonthMap{$Time[1]}-$Time[2] $Time[3]",
            },
        );

        # Converts the date and time of this object to the user time zone.
        $DateTimeObject->ToTimeZone(
            TimeZone => $TimeZone,
        );

        # Output time back as ctime string with time zone.
        $Parts[0] = $DateTimeObject->ToCTimeString() . " ($TimeZone)";

        $LayoutObject->Block(
            Name => 'Row',
            Data => {
                ErrorClass => $ErrorClass,
                Time       => $Parts[0],
                Priority   => $Parts[1],
                Facility   => $Parts[2],
                Message    => $Parts[3],
            },
        );
    }

    # Print no data found message.
    if ( !@Messages ) {
        $LayoutObject->Block(
            Name => 'AdminLogNoDataRow',
            Data => {},
        );
    }

    # Create & return output.
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminLog',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
