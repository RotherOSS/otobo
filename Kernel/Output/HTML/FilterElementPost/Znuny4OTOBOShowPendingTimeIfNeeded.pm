# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2018 Znuny GmbH, http://znuny.com/
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

package Kernel::Output::HTML::FilterElementPost::Znuny4OTOBOShowPendingTimeIfNeeded;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::JSON',
    'Kernel::System::State',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Action} = $Param{Action} || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');
    my $StateObject  = $Kernel::OM->Get('Kernel::System::State');

    my @StateList = $StateObject->StateGetStatesByType(
        StateType => [ 'pending reminder', 'pending auto' ],
        Result    => 'ID',
    );

    my $StateListString = $JSONObject->Encode(
        Data => \@StateList,
    );

    my $JSBlock = <<"JS_BLOCK";
    Core.Agent.Znuny4OTOBOShowPendingTimeIfNeeded.Init({ PendingStates : $StateListString });
JS_BLOCK

    my $Success = $LayoutObject->AddJSOnDocumentCompleteIfNotExists(
        Key  => 'Znuny4OTOBOShowPendingTimeIfNeeded',
        Code => $JSBlock,
    );

    return 1;
}

1;
