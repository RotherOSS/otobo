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

package Kernel::Modules::AgentSearch;

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

    # get params
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Referrer    = $ParamObject->GetParam( Param => 'Referrer' );
    my $Profile     = $ParamObject->GetParam( Param => 'Profile' );

    # set default backend
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $DefaultBackend = $ConfigObject->Get('Frontend::SearchDefault');

    # config
    my $Config = $ConfigObject->Get('Frontend::Search');

    # get target backend
    my $Redirect = $DefaultBackend;
    if ( $Config && $Referrer ) {
        for my $Group ( sort keys %{$Config} ) {
            REGEXP:
            for my $RegExp ( sort keys %{ $Config->{$Group} } ) {
                if ( $Referrer =~ /$RegExp/ ) {
                    $Redirect = $Config->{$Group}->{$RegExp};
                    last REGEXP;
                }
            }
        }
    }

    # add profile
    if ($Profile) {
        $Redirect .= ';Profile=' . $Profile;
    }

    # redirect to new backend
    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect( OP => $Redirect );
}

1;
