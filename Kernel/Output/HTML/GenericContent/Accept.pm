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

package Kernel::Output::HTML::GenericContent::Accept;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Content {
    my ( $Self, %Param ) = @_;

    if ( !$Param{LayoutObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need LayoutObject!',
        );

        return;
    }

    my $DataStorageObject = $Kernel::OM->Get('Kernel::System::DataStorage');

    my @Languages = (
        $Param{LayoutObject}{UserLanguage},
        $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage'),
        'en',
    );

    LANGUAGE:
    for my $Language (@Languages) {
        next LANGUAGE if !$Language;

        my $Content = $DataStorageObject->Get(
            Type => 'CustomerAccept',
            Key  => $Language,
        );

        next LANGUAGE if !$Content;

        return $Content->{Body} if $Content->{Body};
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "No Content found for @Languages!",
    );

    return;
}

1;
