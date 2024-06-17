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

package Kernel::Modules::PublicSupportDataCollector;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use HTTP::Response;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # The request must be authenticated with the correct ChallengeToken
    my $SystemDataObject     = $Kernel::OM->Get('Kernel::System::SystemData');
    my $ChallengeToken       = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ChallengeToken' );
    my $StoredChallengeToken = $SystemDataObject->SystemDataGet( Key => 'SupportDataCollector::ChallengeToken' );

    # Immediately discard the token (only useable once).
    $SystemDataObject->SystemDataDelete(
        Key    => 'SupportDataCollector::ChallengeToken',
        UserID => 1,
    );

    my %Result;

    if ( !$ChallengeToken || $ChallengeToken ne $StoredChallengeToken ) {
        %Result = (
            Success      => 0,
            ErrorMessage => 'Forbidden',
        );
    }
    else {
        %Result = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect();
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $JSON         = $LayoutObject->JSONEncode(
        Data => \%Result,
    );

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
