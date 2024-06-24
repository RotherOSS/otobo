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

package Kernel::Output::HTML::ImportExport::LayoutDateTime;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::Output::HTML::ImportExport::LayoutDateTime - layout backend module

=head1 DESCRIPTION

All layout functions for DateTime elements in Import/Export.

=cut

=head2 new()

Create an object

    my $BackendObject = Kernel::Output::HTML::ImportExport::LayoutDateTime->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 FormInputCreate()

Create a input string

    my $Value = $BackendObject->FormInputCreate(
        Item   => $ItemRef,
        Prefix => 'Prefix::',  # (optional)
        Value  => 'Value',     # (optional)
        Class  => 'Modernize'  # (optional)
    );

=cut

sub FormInputCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Item!',
        );
        return;
    }

    my $Prefix = $Param{Prefix} || $Param{Item}{Input}{Prefix} || '';
    $Prefix .= $Param{Item}{Key};

    # set default value
    $Param{Value} ||= $Param{Item}->{Input}->{ValueDefault};

    if ( $Param{Value} ) {
        my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $Param{Value} =~
            m{ \A ( \d{4} ) - ( \d{2} ) - ( \d{2} ) \s ( \d{2} ) : ( \d{2} ) : ( \d{2} ) \z }xms;

        # If a value is sent this value must be active, then the Used part needs to be set to 1
        #   otherwise user can easily forget to mark the checkbox and this could lead into data
        #   lost (Bug#8258).
        $Param{ $Prefix . 'Used' }   = 1;
        $Param{ $Prefix . 'Year' }   = $Year;
        $Param{ $Prefix . 'Month' }  = $Month;
        $Param{ $Prefix . 'Day' }    = $Day;
        $Param{ $Prefix . 'Hour' }   = $Hour;
        $Param{ $Prefix . 'Minute' } = $Minute;
    }

    $Param{ $Prefix . 'Value' }    = $Param{Item}{Input}{Required};
    $Param{ $Prefix . 'Optional' } = $Param{Item}{Input}{Optional};
    $Param{ $Prefix . 'Class' }    = $Param{Item}{Input}{Class};

    # generate option string
    my $String = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildDateSelection(
        %Param,
        Prefix => $Prefix,
        Format => 'DateInputFormatLong',
    );

    return $String;
}

=head2 FormDataGet()

Get form data

    my $FormData = $BackendObject->FormDataGet(
        Item   => $ItemRef,
        Prefix => 'Prefix::',  # (optional)
    );

=cut

sub FormDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Item!',
        );
        return;
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $Prefix = $Param{Prefix} || $Param{Item}{Input}{Prefix} || '';
    $Prefix .= $Param{Item}{Key};

    my %Values;
    for my $Type (qw(Used Year Month Day Hour Minute)) {
        $Values{ $Prefix . $Type } = $ParamObject->GetParam(
            Param => $Prefix . $Type,
        ) || 0;
    }

    my $FormData;
    if ( $Values{ $Prefix . 'Used' } ) {

        # add a leading zero for date parts that could be less than ten to generate a correct
        # time stamp
        for my $Type (qw(Month Day Hour Minute Second)) {
            $Values{ $Prefix . $Type } = sprintf "%02d", $Values{ $Prefix . $Type };
        }

        my $Year   = $Values{ $Prefix . 'Year' }   || '0000';
        my $Month  = $Values{ $Prefix . 'Month' }  || '00';
        my $Day    = $Values{ $Prefix . 'Day' }    || '00';
        my $Hour   = $Values{ $Prefix . 'Hour' }   || '00';
        my $Minute = $Values{ $Prefix . 'Minute' } || '00';
        my $Second = $Values{ $Prefix . 'Second' } || '00';

        $FormData =
            $Year . '-' . $Month . '-' . $Day . ' ' . $Hour . ':' . $Minute . ':' . $Second;
    }

    return $FormData if $FormData;
    return $FormData if !$Param{Item}{Input}{Required};

    # set invalid param
    $Param{Item}->{Form}->{Invalid} = 1;

    return $FormData;
}

1;
