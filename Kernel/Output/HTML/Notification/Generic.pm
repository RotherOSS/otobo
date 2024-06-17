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

package Kernel::Output::HTML::Notification::Generic;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
    'Kernel::Config',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # define default value
    my %Arguments = (
        Priority => 'Warning',
    );

    # Check which class to add
    if ( $Param{Config}->{Priority} && $Param{Config}->{Priority} eq 'Error' ) {
        $Arguments{Priority} = 'Error';
    }
    elsif ( $Param{Config}->{Priority} && $Param{Config}->{Priority} eq 'Success' ) {
        $Arguments{Priority} = 'Success';
    }
    elsif ( $Param{Config}->{Priority} && $Param{Config}->{Priority} eq 'Info' ) {
        $Arguments{Priority} = 'Info';
    }

    if ( $Param{Config}->{Text} ) {
        $Arguments{Info} = $Param{Config}->{Text};
    }
    elsif ( $Param{Config}->{File} ) {

        $Param{Config}->{File} =~ s{<OTOBO_CONFIG_(.+?)>}{$Kernel::OM->Get('Kernel::Config')->Get($1)}egx;

        return '' if !-e $Param{Config}->{File};

        # try to read the file
        my $FileContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Param{Config}->{File},
            Mode     => 'utf8',
            Type     => 'Local',
            Result   => 'SCALAR',
        );

        return '' if !$FileContent;
        return '' if ref $FileContent ne 'SCALAR';

        $Arguments{Info} = ${$FileContent};
    }
    else {
        return '';
    }

    # add link if available
    if ( $Param{Config}->{Link} ) {
        $Arguments{Link} = $Param{Config}->{Link};
    }

    return '' if !$Arguments{Info};

    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Notify(%Arguments);
}

1;
