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

package Kernel::Modules::Test;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get test page header
    my $Output = $LayoutObject->Header( Title => 'OTOBO Test Page' );

    # example blocks
    $LayoutObject->Block(
        Name => 'Row',
        Data => {
            Text    => 'Some Text for the first line',
            Counter => 1,
        },
    );
    $LayoutObject->Block(
        Name => 'Row',
        Data => {
            Text    => 'Some Text for the next line',
            Counter => 2,
        },
    );
    for ( 1 .. 2 ) {

        # fist block
        $LayoutObject->Block(
            Name => 'System',
            Data => {
                Type    => 'System',
                Counter => $_,
            },
        );

        # sub block of System
        $LayoutObject->Block(
            Name => 'User',
            Data => {
                Type    => 'User',
                Counter => $_,
            },
        );

        # sub blocks of User
        $LayoutObject->Block(
            Name => 'UserID',
            Data => {
                Type    => 'UserID',
                Counter => $_,
            },
        );

        # just if $_ > 1
        if ( $_ > 1 ) {
            $LayoutObject->Block(
                Name => 'UserID',
                Data => {
                    Type    => 'UserID',
                    Counter => $_,
                },
            );
        }

        # add this block 3 times
        for ( 4 .. 6 ) {
            $LayoutObject->Block(
                Name => 'UserIDA',
                Data => {
                    Type    => 'UserIDA',
                    Counter => $_,
                },
            );
        }
    }

    # add the times block at least
    $LayoutObject->Block(
        Name => 'Times',
        Data => {
            Type    => 'Times',
            Counter => 443,
        },
    );

    # get test page
    $Output .= $LayoutObject->Output(
        TemplateFile => 'Test',
        Data         => \%Param
    );

    # get test page footer
    $Output .= $LayoutObject->Footer();

    # return test page
    return $Output;
}

1;
