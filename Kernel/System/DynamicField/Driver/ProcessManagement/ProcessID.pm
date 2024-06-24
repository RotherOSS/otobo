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

package Kernel::System::DynamicField::Driver::ProcessManagement::ProcessID;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseText);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Main',
    'Kernel::System::ProcessManagement::Process',
    'Kernel::System::ProcessManagement::DB::Process',
    'Kernel::System::Ticket::ColumnFilter',
);

=head1 NAME

Kernel::System::DynamicField::Driver::ProcessManagement::ProcessID - driver for the ProcessID dynamic field.

=head1 DESCRIPTION

ProcessID dynamic field.

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ($Type) = @_;

    # Call conststructor of the base class.
    my $Self = $Type->SUPER::new(
        ExtensionClass => 'Text',
    );

    # set ProcessID specific field behaviours unless an extension already set it
    $Self->{Behaviours}->{IsSortable}            //= 1;
    $Self->{Behaviours}->{IsFiltrable}           //= 1;
    $Self->{Behaviours}->{IsLikeOperatorCapable} //= 0;
    $Self->{Behaviours}->{IsSetCapable}          //= 0;

    return $Self;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # activate HTMLOutput when it wasn't specified
    my $HTMLOutput = $Param{HTMLOutput} // 1;

    # get raw Title and Value strings from field value
    # convert the ProcessEntityID to the Process name
    my $Process;
    if ( $Param{Value} ) {
        $Process = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessGet(
            ProcessEntityID => $Param{Value},
        );
    }

    my $Value = $Process->{Name} // '';

    my $Title = $Value;

    # HTMLOutput transformations
    if ($HTMLOutput) {
        $Value = $Param{LayoutObject}->Ascii2Html(
            Text => $Value,
            Max  => $Param{ValueMaxChars} || '',
        );

        $Title = $Param{LayoutObject}->Ascii2Html(
            Text => $Title,
            Max  => $Param{TitleMaxChars} || '',
        );
    }
    else {
        if ( $Param{ValueMaxChars} && length($Value) > $Param{ValueMaxChars} ) {
            $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '...';
        }
        if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
            $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
        }
    }

    # set field link form config
    my $Link = $Param{DynamicFieldConfig}->{Config}->{Link} || '';

    # return a data structure
    return {
        Value => $Value,
        Title => $Title,
        Link  => $Link,
    };
}

sub ColumnFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};

    # set PossibleValues
    my $SelectionData = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessList(
        ProcessState => [ 'Active', 'FadeAway', 'Inactive' ],
        Interface    => 'all',
    );

    # get column filter values from database
    my $ColumnFilterValues = $Kernel::OM->Get('Kernel::System::Ticket::ColumnFilter')->DynamicFieldFilterValuesGet(
        TicketIDs => $Param{TicketIDs},
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text',
    );

    # get the display value if still exist in dynamic field configuration
    for my $Key ( sort keys %{$ColumnFilterValues} ) {
        if ( $SelectionData->{$Key} ) {
            $ColumnFilterValues->{$Key} = $SelectionData->{$Key};
        }
    }

    return $ColumnFilterValues;
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # Get field value.
    my $Value = $Self->SearchFieldValueGet(%Param);

    # Set operator.
    my $Operator = 'Equals';

    # Search for a wild card in the value.
    if ( $Value && ( $Value =~ m{\*} || $Value =~ m{\|\|} ) ) {

        # Change operator.
        $Operator = 'Like';
    }

    if ( $Param{DynamicFieldConfig}->{Name} eq 'ProcessManagementProcessID' && $Value ) {

        my $ProcessEntityIDs = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessSearch(
            ProcessName => $Value,
        );

        if ( IsArrayRefWithData($ProcessEntityIDs) ) {

            # Add search term from input field.
            push @{$ProcessEntityIDs}, $Value;

            # Return search parameter structure.
            return {
                Parameter => {
                    $Operator => $ProcessEntityIDs,
                },
                Display => $Value,
            };
        }

    }

    # Return search parameter structure.
    return {
        Parameter => {
            $Operator => $Value,
        },
        Display => $Value,
    };

}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Value = $Param{Value};

    # set operator
    my $Operator = 'Equals';

    # search for a wild card in the value
    if ( $Value && $Value =~ m{\*} ) {

        # change operator
        $Operator = 'Like';
    }

    if ( $Param{DynamicFieldConfig}->{Name} eq 'ProcessManagementProcessID' && $Value ) {

        my $ProcessEntityIDs = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessSearch(
            ProcessName => $Value,
        );

        if ( IsArrayRefWithData($ProcessEntityIDs) ) {

            # Add search term from input field.
            push @{$ProcessEntityIDs}, $Value;

            # Return search parameter structure.
            return {
                $Operator => $ProcessEntityIDs,

            };
        }
    }

    return {
        $Operator => $Value,
    };
}

1;
