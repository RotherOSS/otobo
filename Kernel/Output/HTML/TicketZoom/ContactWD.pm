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

package Kernel::Output::HTML::TicketZoom::ContactWD;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    # Get needed objects.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Ticket    = %{ $Param{Ticket} };
    my %AclAction = %{ $Param{AclAction} };

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # Check if edit functionality should be available.
    my $EditPermission;
    my $Groups = $ConfigObject->Get('Frontend::Module')->{'AdminContactWD'}->{Group};

    if ( IsArrayRefWithData($Groups) ) {
        GROUP:
        for my $Group ( @{$Groups} ) {

            my $HasPermission = $GroupObject->PermissionCheck(
                UserID    => $Self->{UserID},
                GroupName => $Group,
                Type      => 'rw',
            );
            next GROUP if !$HasPermission;

            $EditPermission = 1;
            last GROUP;
        }
    }

    # Get df config for zoom.
    my $DynamicFieldFilter = {
        %{ $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")->{DynamicField}                   || {} },
        %{ $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")->{DynamicFieldWidgetDynamicField} || {} },
        %{ $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")->{ProcessWidgetDynamicField}      || {} },
    };
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if $DynamicFieldConfig->{FieldType} ne 'ContactWD';
        next DYNAMICFIELD if $DynamicFieldConfig->{ValidID} ne 1;
        my $Value = $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
        next DYNAMICFIELD if !$Value;

        $LayoutObject->Block(
            Name => 'ContactWDZoom',
            Data => {
                DynamicFieldConfig => $DynamicFieldConfig,
            },
        );

        if ($EditPermission) {
            $LayoutObject->Block(
                Name => 'ContactWDZoomEdit',
                Data => {
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ContactID          => $Value,
                },
            );
        }

        my $PossibleAttributes = $DynamicFieldConfig->{Config}->{PossibleValues};
        my $ContactAttributes  = $DynamicFieldConfig->{Config}->{ContactsWithData}->{$Value};
        my $SortOrder          = $DynamicFieldConfig->{Config}->{SortOrderComputed};
        ATTRIBUTE:
        for my $Attribute ( @{$SortOrder} ) {
            next ATTRIBUTE if !$ContactAttributes->{$Attribute};
            next ATTRIBUTE if $Attribute eq 'ValidID';
            $LayoutObject->Block(
                Name => 'ContactWDZoomAttribute',
                Data => {
                    Attribute          => $Attribute,
                    ContactAttributes  => $ContactAttributes,
                    PossibleAttributes => $PossibleAttributes,
                },
            );
        }
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/ContactWD',
    );

    return {
        Output => $Output,
    };
}

1;
