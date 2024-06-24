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

package Kernel::System::DynamicField::Driver::ScriptTemplateToolkit;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::DynamicField::Driver::BaseScript);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::ScriptTemplateToolkit

=head1 DESCRIPTION

DynamicFields Script Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=cut

sub Evaluate {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{DynamicFieldConfig}{Config}{Expression} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => "Need DynamicFieldConfig->Config->Expression\n",
        );
        return;
    }
    if ( !$Param{Object} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => "Need Object\n",
        );
        return;
    }

    my %DynamicFields = ref $Param{Object}{DynamicField} eq 'HASH' ? $Param{Object}{DynamicField}->%* : ();

    my $Value = $Kernel::OM->Create('Kernel::Output::HTML::Layout')->Output(
        Template => $Param{DynamicFieldConfig}{Config}{Expression},
        Data     => {
            $Param{Object}->%*,
            %DynamicFields,
        },
    );

    # remove newlines and carriage returns to enable matching with edit field value
    $Value =~ s/(\n|\r)//g;

    return $Value;
}

1;
