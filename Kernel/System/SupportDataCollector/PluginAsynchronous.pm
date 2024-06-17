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

package Kernel::System::SupportDataCollector::PluginAsynchronous;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::JSON',
    'Kernel::System::SystemData',
);

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

sub _GetAsynchronousData {
    my ( $Self, %Param ) = @_;

    my $Identifier = Scalar::Util::blessed($Self);

    my $AsynchronousDataString = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => $Identifier,
    );

    return if !defined $AsynchronousDataString;

    # get asynchronous data as array ref
    my $AsynchronousData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $AsynchronousDataString,
    ) || [];

    return $AsynchronousData;
}

sub _StoreAsynchronousData {
    my ( $Self, %Param ) = @_;

    return 1 if !$Param{Data};

    my $Identifier = Scalar::Util::blessed($Self);

    my $CurrentAsynchronousData = $Self->_GetAsynchronousData();

    my $AsynchronousDataString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Data},
    );

    # get system data object
    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    if ( !defined $CurrentAsynchronousData ) {

        $SystemDataObject->SystemDataAdd(
            Key    => $Identifier,
            Value  => $AsynchronousDataString,
            UserID => 1,
        );
    }
    else {

        $SystemDataObject->SystemDataUpdate(
            Key    => $Identifier,
            Value  => $AsynchronousDataString,
            UserID => 1,
        );
    }

    return 1;
}

1;
