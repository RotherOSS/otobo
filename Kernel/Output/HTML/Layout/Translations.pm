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

package Kernel::Output::HTML::Layout::Translations;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Translations - all Translations-related HTML functions

=head1 SYNOPSIS

    # No instances of this class should be created directly.
    # Instead the module is loaded implicitly by Kernel::Output::HTML::Layout
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

=head1 DESCRIPTION

All Translations-related HTML functions

=head1 PUBLIC INTERFACE

=head2 TranslationsTableCreate()

create a simple output table

    my $String = $LayoutObject->TranslationsTableCreate(
        Data  => $TranslationData
    );

=cut

sub TranslationsTableCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Data} || ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    $Param{Data}->{ExistingIDs} ||= '';
    $Param{Data}->{CountNew}    ||= 0;
    $Param{Data}->{Edit}        ||= 0;

    # show no data found table
    if ( !int( @{ $Param{Data}->{Values} } ) ) {
        $Self->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }
    else {
        for my $Item ( sort { lc( $$a{Content} ) cmp lc( $$b{Content} ) } @{ $Param{Data}->{Values} } ) {
            $Self->Block(
                Name => 'TableDataContent',
                Data => {
                    ID      => $Item->{ID},
                    Content => $Item->{Content},
                    Value   => $Item->{Value}
                }
            );
        }
    }

    return $Self->Output(
        TemplateFile => 'Translations/TranslationsTable',
        Data         => {
            ItemCount   => int( @{ $Param{Data}->{Values} } ),
            Object      => $Param{Data}->{Object},
            ExistingIDs => $Param{Data}->{ExistingIDs},
            CountNew    => $Param{Data}->{CountNew}
        }
    );
}

=head2 TranslationsDynamicField()

create fields for translations

    my $String = $LayoutObject->TranslationsDynamicField(
        Data        => $TranslationData
    );

=cut

sub TranslationsDynamicField {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Data} || ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    my $DynamicFieldStrg = $Self->BuildSelection(
        Data         => $Param{Data}->{PossibleValues},
        Name         => $Param{Data}->{Name},
        SelectedID   => 0,
        PossibleNone => 1,
        Translation  => 1,
        Sort         => 'AlphanumericValue',
        Class        => 'Modernize Validate_Required' . ( $Param{Errors}->{"$Param{Data}->{Name}Invalid"} || '' )
    );

    # show data
    $Self->Block(
        Name => 'DynamicField',
        Data => {
            Name             => $Param{Data}->{Name},
            DynamicFieldStrg => $DynamicFieldStrg,
        }
    );

    return $Self->Output(
        TemplateFile => 'Translations/TranslationsDynamicField',
        Data         => {
            Object => $Param{Data}->{Object}
        }
    );
}

=head2 TranslationsGeneral()

create fields for translations

    my $String = $LayoutObject->TranslationsGeneral(
        Data        => $TranslationData
    );

=cut

sub TranslationsGeneral {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Data} || ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    my $Readonly = '';

    if ( $Param{Data}->{Object} eq 'Edit' ) {
        $Readonly = 'readonly';
    }

    # show data
    $Self->Block(
        Name => 'General',
        Data => {
            ID       => $Param{Data}->{ID} || '',
            Content  => $Param{Data}->{Content},
            Value    => $Param{Data}->{Value},
            Object   => $Param{Data}->{Object},
            Readonly => $Readonly
        }
    );

    return $Self->Output(
        TemplateFile => 'Translations/TranslationsGeneral',
        Data         => {}
    );
}

1;
