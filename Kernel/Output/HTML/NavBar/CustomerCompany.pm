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

package Kernel::Output::HTML::NavBar::CustomerCompany;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if frontend module is registared
    my $Config = $ConfigObject->Get('Frontend::Module')->{AdminCustomerCompany};
    return if !$Config;

    # check if customer company support feature is active
    SOURCE:
    for my $Item ( '', 1 .. 10 ) {
        my $CustomerMap = $ConfigObject->Get( 'CustomerUser' . $Item );
        next SOURCE if !$CustomerMap;

        # return if CustomerCompany feature is used
        return if $CustomerMap->{CustomerCompanySupport};
    }

    # frontend module is enabled but not customer company support feature, then remove the menu entry
    my $NavBarName = $Config->{NavBarName};
    my %Return     = %{ $Param{NavBar}->{Sub} };

    # remove CustomerCompany from the CustomerMenu
    delete $Return{$NavBarName}->{ItemArea0009100};

    return ( Sub => \%Return );
}

1;
