# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
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

package Kernel::Modules::ExternalURLJump;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ExtURL = $ParamObject->GetParam( Param => 'URL' );

    # check whether the URL is defined in the Config - prevents using OTOBO for phishing attacks
    my $NavAgent    = $ConfigObject->Get('Frontend::Navigation');
    my $NavCustomer = $ConfigObject->Get('CustomerFrontend::Navigation');

    my @URLSets;
    push @URLSets, ( $NavAgent    && $NavAgent->{ExternalURLJump} )    ? ( values %{ $NavAgent->{ExternalURLJump} } )    : ();
    push @URLSets, ( $NavCustomer && $NavCustomer->{ExternalURLJump} ) ? ( values %{ $NavCustomer->{ExternalURLJump} } ) : ();

    for my $Set (@URLSets) {
        LINK:
        for my $Links ( $Set->@* ) {
            next LINK if $Links->{Link} !~ m/$ExtURL/;

            # redirecting because the requested link was found
            return $LayoutObject->Redirect( ExtURL => $ExtURL );
        }
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Prevented ExternalURLJump to '$ExtURL' because the link is not configured.",
    );

    # redirect to the base link
    return $LayoutObject->Redirect;
}

1;
