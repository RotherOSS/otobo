# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::Ticket::Event::EvaluateScriptFields;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::DynamicField::Driver::BaseScript',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Data Event)) {
        if ( !$Param{$Argument} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    return if !$Param{Data}{TicketID};

    my $Events = $Kernel::OM->Get('Kernel::System::DynamicField::Driver::BaseScript')->GetUpdateEvents();

    return 1 if !IsHashRefWithData($Events);
    return 1 if !$Events->{ $Param{Event} };

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{Data}{TicketID},
        DynamicFields => 1,
        UserID        => 1,
    );

    FIELDID:
    for my $FieldID ( $Events->{ $Param{Event} }->@* ) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $FieldID,
        );

        # if we store set values, store as many values as there are in ticket data for the set
        my $Value;
        if ( $DynamicField->{Config}{PartOfSet} ) {
            my @Values;
            my $SetConfig = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicField->{Config}{PartOfSet},
            );

            my $ValueEvaluated = 0;

            SETVALUE:
            for my $SetValue ( $Ticket{"DynamicField_$SetConfig->{Name}"}->@* ) {
                my %SetValuesMapped = map { ( "DynamicField_$_" => $SetValue->{$_} ) } keys $SetValue->%*;

                # the required args have to be present
                for my $Required ( @{ $DynamicField->{Config}{RequiredArgs} // [] } ) {
                    my $RequirementValue = exists $SetValuesMapped{$Required} ? $SetValuesMapped{$Required} : $Ticket{$Required};

                    if (
                        ( !ref $RequirementValue && ( !defined $RequirementValue || !length $RequirementValue ) )
                        || ( ref $RequirementValue && !IsArrayRefWithData($RequirementValue) )
                        )
                    {
                        # keep old value in case that requirements are not fulfilled
                        push @Values, $SetValuesMapped{"DynamicField_$DynamicField->{Name}"};

                        next SETVALUE;
                    }
                }

                push @Values, $DynamicFieldBackendObject->Evaluate(
                    DynamicFieldConfig => $DynamicField,
                    Object             => {
                        %Ticket,
                        %SetValuesMapped,
                    },
                );
                $ValueEvaluated = 1;
            }

            next FIELDID unless $ValueEvaluated;

            $Value = \@Values;
        }
        else {

            # the required args have to be present
            for my $Required ( @{ $DynamicField->{Config}{RequiredArgs} // [] } ) {
                my $RequirementValue = $Ticket{$Required};

                next FIELDID if ( !ref $RequirementValue && ( !defined $RequirementValue || !length $RequirementValue ) );
                next FIELDID if ( ref $RequirementValue  && !IsArrayRefWithData($RequirementValue) );
            }

            $Value = $DynamicFieldBackendObject->Evaluate(
                DynamicFieldConfig => $DynamicField,
                Object             => \%Ticket,
            );
        }

        $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $Param{Data}{TicketID},
            Value              => $Value,
            Set                => $DynamicField->{Config}{PartOfSet},
            UserID             => 1,
            Store              => 1,
        );
    }

    return 1;
}

1;
