# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::CustomerUser::Generic;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    # check required params
    my @Params = split /;/, $Param{Config}->{Required};
    for my $Key (@Params) {
        return if !$Key;
        return if !$Param{Data}->{$Key};
    }

    # get all attributes
    @Params = split /;/, $Param{Config}->{Attributes};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build url
    my $URL = '';
    KEY:
    for my $Key (@Params) {
        next KEY if !$Param{Data}->{$Key};
        if ($URL) {
            $URL .= ', ';
        }
        $URL .= $LayoutObject->LinkEncode( $Param{Data}->{$Key} );
    }
    $URL = $Param{Config}->{URL} . $URL;

    my $IconName = $Param{Config}->{IconName};

    # generate block
    $LayoutObject->Block(
        Name => 'CustomerItemRow',
        Data => {
            %{ $Param{Config} },
            URL      => $URL,
            IconName => $IconName,
        },
    );

    return 1;
}

1;
