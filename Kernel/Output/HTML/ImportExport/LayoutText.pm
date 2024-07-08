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

package Kernel::Output::HTML::ImportExport::LayoutText;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::Output::HTML::ImportExport::LayoutText - layout backend module

=head1 DESCRIPTION

All layout functions for text elements in Import/Export.

=cut

=head2 new()

Create an object

    my $BackendObject = Kernel::Output::HTML::ImportExport::LayoutText->new(
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
        Item     => $ItemRef,
        Prefix   => 'Prefix::',  # (optional)
        Value    => 'Value',     # (optional)
        Readonly => 1,           # (optional)
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

    $Param{Prefix} ||= '';

    my $Value = $Param{Value}                 || $Param{Item}->{Input}->{ValueDefault};
    my $Size  = $Param{Item}->{Input}->{Size} || 40;
    my $SizeClass;
    if ( $Size < 15 ) {
        $SizeClass = 'W10pc';
    }
    elsif ( $Size < 35 ) {
        $SizeClass = 'W33pc';
    }
    elsif ( $Size < 50 ) {
        $SizeClass = 'W50pc';
    }
    else {
        $SizeClass = 'W75pc';
    }

    # prepare data
    my $ID    = ( $Param{Prefix} || '' ) . ( $Param{Item}->{Key} );
    my $Name  = ( $Param{Prefix} || '' ) . ( $Param{Name}  || $ID );
    my $Class = ( $SizeClass     || '' ) . ( $Param{Class} || '' );

    my $String = "<input id=\"$ID\" type=\"text\" name=\"$Name\" class=\"$Class\" ";

    if ($Value) {

        # get layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        # translate
        if ( $Param{Item}->{Input}->{Translation} ) {
            $Value = $LayoutObject->{LanguageObject}->Translate($Value);
        }

        # transform ascii to html
        $Value = $LayoutObject->Ascii2Html(
            Text           => $Value,
            HTMLResultMode => 1,
        );

        $String .= "value=\"$Value\" ";
    }

    # add maximum length
    if ( $Param{Item}->{Input}->{MaxLength} ) {
        $String .= "maxlength=\"$Param{Item}->{Input}->{MaxLength}\" ";
    }

    # add readonly
    if ( $Param{Item}->{Input}->{Readonly} ) {
        $String .= 'readonly ';
    }

    $String .= "/> ";

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
    my $FormData = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
        Param => $Param{Prefix} . $Param{Item}->{Key},
    );

    # regex check
    if ( $Param{Item}->{Input}->{Regex} && $FormData !~ $Param{Item}->{Input}->{Regex} ) {

        $Param{Item}->{Form}->{Invalid} = 1;
        return $FormData;
    }

    return $FormData if $FormData;
    return $FormData if !$Param{Item}->{Input}->{Required};

    # set invalid param
    $Param{Item}->{Form}->{Invalid} = 1;

    return $FormData;
}

1;
