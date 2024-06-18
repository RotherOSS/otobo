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

package var::processes::examples::Office_Materials_Procurement_pre;
## nofilter(TidyAll::Plugin::OTOBO::Perl::PerlCritic)

use strict;
use warnings;

use parent qw(var::processes::examples::Base);

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Dynamic fields definition
    my @DynamicFields = (
        {
            Name       => 'PreProcMaterialsProcurementstate',
            Label      => 'Materials Procurement State',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-delivered' => 'delivered',
                    'otobo5s-ordered'   => 'ordered',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcMaterialsProcurementItems',
            Label      => 'Materials Procurement Items',
            FieldType  => 'Multiselect',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-envelope'        => 'Flipchart',
                    'otobo5s-flip chart'      => 'flip chart',
                    'otobo5s-highlighter'     => 'highlighter',
                    'otobo5s-hole puncher'    => 'hole puncher',
                    'otobo5s-labeling device' => 'labeling device',
                    'otobo5s-paper clip'      => 'paper clip',
                    'otobo5s-postits'         => 'postits',
                    'otobo5s-scotch tape'     => 'scotch tape',
                    'otobo5s-sheet protector' => 'sheet protector',
                    'otobo5s-stamps'          => 'stamps',
                    'otobo5s-staple gun'      => 'staple gun',
                    'otobo5s-staves'          => 'staves',
                    'otobo5s-storage box'     => 'storage box',
                    'otobo5s-toner'           => 'toner',
                    'otobo5s-white board'     => 'white board',
                },
                TranslatableValues => 0,
            },
        },
    );

    my %Response = $Self->DynamicFieldsAdd(
        DynamicFieldList => \@DynamicFields,
    );

    return %Response;
}

1;
