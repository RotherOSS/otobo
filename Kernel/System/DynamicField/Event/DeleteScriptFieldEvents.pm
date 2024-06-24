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

package Kernel::System::DynamicField::Event::DeleteScriptFieldEvents;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
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
    for my $Argument (qw(Data Event Config UserID)) {
        if ( !$Param{$Argument} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $DynamicFieldConfig = $Param{Data}{NewData};

    my $IsScriptField = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->HasBehavior(
        DynamicFieldConfig => $DynamicFieldConfig,
        Behavior           => 'IsScriptField',
    );

    return 1 unless $IsScriptField;
    return if $Param{Event} ne 'DynamicFieldDelete';

    # when deleting a script field, corresponding events need to be deleted also
    my $DriverObject = $Kernel::OM->Get("Kernel::System::DynamicField::Driver::$DynamicFieldConfig->{FieldType}");

    # calling SetUpdateEvents without param Events will delete existing events
    my $Success = $DriverObject->SetUpdateEvents(
        FieldID => $DynamicFieldConfig->{ID},
    );

    return $Success;
}

1;
