# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::Layout::CustomerUser;

use strict;
use warnings;
use namespace::autoclean;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::CustomerUser - all CustomerUser related HTML functions

=head1 SYNOPSIS

    # No instances of this class should be created directly.
    # Instead the module is loaded implicitly by Kernel::Output::HTML::Layout
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

=head1 PUBLIC INTERFACE

=head2 CustomerUserAddressBookListShow()

Returns a list of customer user as sort-able list with pagination.

    my $Output = $LayoutObject->CustomerUserAddressBookListShow(
        CustomerUserIDs => $CustomerUserIDsRef,                      # total list of customer user ids, that can be listed
        Total           => scalar @{ $CustomerUserIDsRef },          # total number of customer user ids
        View            => $Self->{View},                            # optional, the default value is 'AddressBook'
        Filter          => 'All',
        Filters         => \%NavBarFilter,
        LinkFilter      => $LinkFilter,
        TitleName       => 'Overview: CustomerUsers',
        TitleValue      => $Self->{Filter},
        Env             => $Self,
        LinkPage        => $LinkPage,
        LinkSort        => $LinkSort,
        Frontend        => 'Agent',                                  # optional (Agent|Customer), default: Agent, indicates from which frontend this function was called
    );

=cut

sub CustomerUserAddressBookListShow {
    my ( $Self, %Param ) = @_;

    # Take object ref to local, remove it from %Param (prevent memory leak).
    my $Env = delete $Param{Env};

    my $Frontend = $Param{Frontend} || 'Agent';

    # Set defaut view mode to 'AddressBook'.
    my $View = $Param{View} || 'AddressBook';

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get backend from config
    my $Backends = $ConfigObject->Get('CustomerUser::Frontend::Overview');
    if ( !$Backends ) {
        return $Self->FatalError(
            Message => 'Need config option CustomerUser::Frontend::Overview',
        );
    }

    # check for hash-ref
    if ( ref $Backends ne 'HASH' ) {
        return $Self->FatalError(
            Message => 'Config option CustomerUser::Frontend::Overview needs to be a HASH ref!',
        );
    }

    # check for config key
    if ( !$Backends->{$View} ) {
        return $Self->FatalError(
            Message => "No config option found for the view '$View'!",
        );
    }

    # nav bar
    my $StartHit = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
        Param => 'StartHit',
    ) || 1;

    # get personal page shown count
    my $PageShown = $ConfigObject->Get("CustomerUser::Frontend::$Self->{Action}")->{PageShown} || 100;

    # check start option, if higher then elements available, set
    # it to the last overview page (Thanks to Stefan Schmidt!)
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # set page limit and build page nav
    my $Limit   = $Param{Limit} || 20_000;
    my %PageNav = $Self->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Self->{Action},
        Link      => $Param{LinkPage},
    );

    # build navbar content
    $Self->Block(
        Name => 'OverviewNavBar',
        Data => \%Param,
    );

    # back link
    if ( $Param{LinkBack} ) {
        $Self->Block(
            Name => 'OverviewNavBarPageBack',
            Data => \%Param,
        );
    }

    # check if page nav is available
    if (%PageNav) {
        $Self->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );

        # don't show context settings in AJAX case (e. g. in customer ticket history),
        #   because the submit with page reload will not work there
        if ( !$Param{AJAX} ) {
            $Self->Block(
                Name => 'ContextSettings',
                Data => {
                    %PageNav,
                    %Param,
                },
            );
        }
    }

    # build html content
    # As of OTOBO 10.0.x some content was printed early.
    # This has changed in OTOBO 10.1.1.
    my $Output = $Self->Output(
        TemplateFile => 'AgentCustomerUserAddressBookOverviewNavBar',
        Data         => {%Param},
    );

    # load module
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Backends->{$View}->{Module} ) ) {
        return $Self->FatalError();
    }

    # check for backend object
    my $Object = $Backends->{$View}->{Module}->new( %{$Env} );

    return unless $Object;

    # run module
    $Output .= $Object->Run(
        %Param,
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Frontend  => $Frontend,
    );

    # create overview nav bar
    $Self->Block(
        Name => 'OverviewNavBar',
        Data => {%Param},
    );

    # return content if available
    return $Output;
}

1;
