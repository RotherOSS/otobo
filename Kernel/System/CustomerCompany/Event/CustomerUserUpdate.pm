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

package Kernel::System::CustomerCompany::Event::CustomerUserUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::CustomerUser',
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
    for (qw( Data Event Config UserID )) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw( CustomerID OldCustomerID )) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    return 1 if $Param{Data}->{CustomerID} eq $Param{Data}->{OldCustomerID};

    # get customer user object
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    my %CustomerUsers = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => $Param{Data}->{OldCustomerID},
        Valid         => 0,
    );

    for my $CustomerUserLogin ( sort keys %CustomerUsers ) {
        my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerUserLogin,
        );

        # we do not need to 'change' the password (this would re-hash it!)
        delete $CustomerData{UserPassword};
        $CustomerUserObject->CustomerUserUpdate(
            %CustomerData,
            ID             => $CustomerUserLogin,
            UserCustomerID => $Param{Data}->{CustomerID},
            UserID         => $Param{UserID},
        );
    }

    return 1;
}

1;
