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

package Kernel::Output::HTML::ImportExport::LayoutSelection;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::Output::HTML::ImportExport::LayoutSelection - layout backend module

=head1 DESCRIPTION

All layout functions for selection elements in Import/Export.

=cut

=head2 new()

Create an object

    my $BackendObject = Kernel::Output::HTML::ImportExport::LayoutSelection->new(
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

    # set default value
    $Param{Prefix} ||= '';

    # zero is a valid value (occurs e.g. with selecting 'No' for Attribute IncludeColumnHeaders)
    $Param{Value} //= $Param{Item}->{Input}->{ValueDefault};

    if ( $Param{Value} && $Param{Value} =~ m{ ##### }xms ) {
        my @Values = split /#####/, $Param{Value};
        $Param{Value} = \@Values;
    }

    # generate option string
    my $String = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        ID           => $Param{Prefix} . $Param{Item}->{Key},
        Class        => $Param{Class},
        Name         => $Param{Prefix} . $Param{Item}->{Key},
        Data         => $Param{Item}->{Input}->{Data} || {},
        SelectedID   => $Param{Value},
        Translation  => $Param{Item}->{Input}->{Translation},
        TreeView     => $Param{Item}->{Input}->{TreeView} || 0,
        PossibleNone => $Param{Item}->{Input}->{PossibleNone},
        Multiple     => $Param{Item}->{Input}->{Multiple},
        Size         => $Param{Item}->{Input}->{Size},
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

    $Param{Prefix} ||= '';

    # get form data
    my @FormDatas = $Kernel::OM->Get('Kernel::System::Web::Request')->GetArray(
        Param => $Param{Prefix} . $Param{Item}->{Key},
    );

    my $FormData = join '#####', @FormDatas;

    return $FormData if $FormData;
    return $FormData if !$Param{Item}->{Input}->{Required};

    # set invalid param
    $Param{Item}->{Form}->{Invalid} = 1;

    return $FormData;
}

1;
