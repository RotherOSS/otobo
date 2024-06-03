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

package Kernel::Modules::AgentAppointmentPluginSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->ChallengeTokenCheck();

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get needed params
    my $Search     = $ParamObject->GetParam( Param => 'Term' ) || '';
    my $PluginKey  = $ParamObject->GetParam( Param => 'PluginKey' );
    my $MaxResults = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 20 );

    # workaround, all auto completion requests get posted by utf8 anyway
    # convert any to 8bit string if application is not running in utf8
    $Search = $Kernel::OM->Get('Kernel::System::Encode')->Convert2CharsetInternal(
        Text => $Search,
        From => 'utf-8',
    );

    my $ResultList;

    if ($PluginKey) {

        # get plugin object
        my $PluginObject = $Kernel::OM->Get('Kernel::System::Calendar::Plugin');

        $ResultList = $PluginObject->PluginSearch(
            Search    => $Search,
            PluginKey => $PluginKey,
            UserID    => $Self->{UserID},
        );
    }

    # build data
    my @Data;
    my $MaxResultCount = $MaxResults;

    OBJECTID:
    for my $ObjectID (
        sort { $ResultList->{$a} cmp $ResultList->{$b} }
        keys %{$ResultList}
        )
    {
        push @Data, {
            Key   => $ObjectID,
            Value => $ResultList->{$ObjectID},
        };

        $MaxResultCount--;
        last OBJECTID if $MaxResultCount <= 0;
    }

    # build JSON output
    my $JSON = $LayoutObject->JSONEncode(
        Data => \@Data || {},
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
