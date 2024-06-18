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

package Kernel::System::PostMaster::LoopProtection;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub SendEmail {
    my ( $Self, %Param ) = @_;

    # get configured backend module
    my $BackendModule = $Kernel::OM->Get('Kernel::Config')->Get('LoopProtectionModule')
        || 'Kernel::System::PostMaster::LoopProtection::DB';

    # get backend object
    my $BackendObject = $Kernel::OM->Get($BackendModule);

    if ( !$BackendObject ) {

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        $MainObject->Die("Can't load loop protection backend module $BackendModule!");
    }

    return $BackendObject->SendEmail(%Param);
}

sub Check {
    my ( $Self, %Param ) = @_;

    # get configured backend module
    my $BackendModule = $Kernel::OM->Get('Kernel::Config')->Get('LoopProtectionModule')
        || 'Kernel::System::PostMaster::LoopProtection::DB';

    # get backend object
    my $BackendObject = $Kernel::OM->Get($BackendModule);

    if ( !$BackendObject ) {

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        $MainObject->Die("Can't load loop protection backend module $BackendModule!");
    }

    return $BackendObject->Check(%Param);
}

1;
