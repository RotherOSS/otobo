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

package Kernel::System::CustomerUser::Event::ServiceMemberUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Service',
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
    for (qw( UserLogin NewData OldData )) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    # only update CustomerUser <> Service if fields have really changed
    if ( $Param{Data}->{OldData}->{UserLogin} ne $Param{Data}->{NewData}->{UserLogin} ) {

        # get service object
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        my @Services = $ServiceObject->CustomerUserServiceMemberList(
            CustomerUserLogin => $Param{Data}->{OldData}->{UserLogin},
            Result            => 'ARRAY',
            DefaultServices   => 0,
        );

        for my $ServiceID (@Services) {

            # first remove old customer id as service member
            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $Param{Data}->{OldData}->{UserLogin},
                ServiceID         => $ServiceID,
                Active            => 0,
                UserID            => 1,
            );

            # add new customer id as service member
            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $Param{Data}->{NewData}->{UserLogin},
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );
        }
    }

    return 1;
}

1;
