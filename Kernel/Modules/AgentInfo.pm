# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Modules::AgentInfo;

use v5.24;
use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {%Param}, $Type;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    $Self->{InfoKey}  = $ConfigObject->Get('InfoKey');
    $Self->{InfoFile} = $ConfigObject->Get('InfoFile');

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # default value
    $Self->{RequestedURL} ||= 'Action=';

    # avoid recursive redirection when the AgentInfo frontend is requested
    return if $Self->{Action} eq 'AgentInfo';

    # no redirect when the InfoKey already is in the User preferences
    return if $Self->{ $Self->{InfoKey} };

    # The originally requested URL will be needed when presenting AgentInfo.
    # Therefore remember the requesed URL in the user session.
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserRequestedURL',
        Value     => $Self->{RequestedURL},
    );

    # show the AgentInfo page, usually asking for confirmation that the page had been seen
    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect(
        OP => 'Action=AgentInfo'
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{RequestedURL} ) {
        $Self->{RequestedURL} = 'Action=';
    }

    my $Accept        = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Accept' ) || '';
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    if ( $Self->{ $Self->{InfoKey} } ) {

        # remove requested url from session storage
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect
        return $LayoutObject->Redirect( OP => "$Self->{UserRequestedURL}" );
    }
    elsif ($Accept) {

        # set session
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $Self->{InfoKey},
            Value     => 1,
        );

        # remember that the user has seen the AgentInfo message
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{InfoKey},
            Value  => 1,
        );

        # remove requested url from session storage
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect
        return $LayoutObject->Redirect( OP => "$Self->{RequestedURL}" );
    }
    else {

        # show info
        return join '',
            $LayoutObject->Header,
            $LayoutObject->Output(
                TemplateFile => $Self->{InfoFile},
                Data         => \%Param
            ),
            $LayoutObject->Footer;
    }
}

1;
