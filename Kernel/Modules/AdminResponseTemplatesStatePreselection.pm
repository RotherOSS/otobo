# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Modules::AdminResponseTemplatesStatePreselection;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ResponseTicketStatePreSelectionObject
        = $Kernel::OM->Get('Kernel::System::ResponseTemplatesStatePreselection');

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID   = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data = $ResponseTicketStatePreSelectionObject->StandardTemplateGet(
            ID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ( $ParamObject->GetParam( Param => 'NotifyUpdate' ) || '' eq '1' ) {
            $Output .= $LayoutObject->Notify(
                Info => Translatable('Template updated!'),
            );
        }

        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminResponseTemplatesStatePreselection',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $PreSelectedTicketStateID = $ParamObject->GetParam( Param => 'PreSelectedTicketStateID' )
            || undef;

        my $TemplateID = $ParamObject->GetParam( Param => 'ID' );

        # Update response.
        $ResponseTicketStatePreSelectionObject->StandardTemplateUpdate(
            ID                       => $TemplateID,
            PreSelectedTicketStateID => $PreSelectedTicketStateID,
            UserID                   => $Self->{UserID},
        );

        # If the user would like to continue editing the state pre-selection, just redirect to the change screen.
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=Change;Subaction=Change;ID=$TemplateID;NotifyUpdate=1"
            );
        }

        # Otherwise, redirect to the overview with the notification.
        else {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};NotifyUpdate=1"
            );
        }
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ( $ParamObject->GetParam( Param => 'NotifyUpdate' ) || '' eq '1' ) {
            $Output .= $LayoutObject->Notify(
                Info => Translatable('Template updated!'),
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminResponseTemplatesStatePreselection',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    my %States = $Kernel::OM->Get('Kernel::System::State')->StateList(
        UserID => $Self->{UserID},
    );
    $Param{States} = $LayoutObject->BuildSelection(
        Data         => \%States,
        Name         => 'PreSelectedTicketStateID',
        PossibleNone => 1,
        SelectedID   => $Param{PreSelectedTicketStateID},
        Class        => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
        },
    );

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my %List = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList(
        UserID => 1,
        Type   => 'Answer',
        Valid  => 0,
    );

    # If there are any results, they are shown.
    if (%List) {

        my $StateObject = $Kernel::OM->Get('Kernel::System::State');
        my $ResponseTicketStatePreSelectionObject
            = $Kernel::OM->Get('Kernel::System::ResponseTemplatesStatePreselection');

        for my $ID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $ResponseTicketStatePreSelectionObject->StandardTemplateGet(
                ID => $ID,
            );

            $Data{PreSelectedTicketState} = '-';
            if ( $Data{PreSelectedTicketStateID} ) {
                my %State = $StateObject->StateGet(
                    ID => $Data{PreSelectedTicketStateID},
                );
                if (%State) {
                    $Data{PreSelectedTicketState} = $State{Name};
                }
            }

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    %Data,
                },
            );
        }
    }

    # Otherwise it displays a no data found message.
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    return 1;
}

1;
