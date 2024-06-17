# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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

use Kernel::Output::HTML::Layout;    ## no critic (Modules::RequireExplicitPackage)

package Kernel::Output::HTML::Layout;    ## no critic (Modules::RequireFilenameMatchesPackage)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
);

# disable redefine warnings in this scope
{
    no warnings 'redefine';    ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)

    # backup original Redirect()
    my $Redirect = \&Kernel::Output::HTML::Layout::Redirect;

    # redefine Redirect() of Kernel::Output::HTML::Layout::Redirect
    *Kernel::Output::HTML::Layout::Redirect = sub {
        my ( $Self, %Param ) = @_;

        return
            if $Param{OP}
            && $Param{OP} =~ /AgentTimeAccountingEdit/
            && $Self->{Action}
            =~ /^(CustomerPassword|AgentPassword|AdminPackage|AdminSystemConfiguration|CustomerAccept)/;
        return &{$Redirect}( $Self, %Param );
    }
}

1;
