# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Modules::AdminTicketMask;

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

    # get needed objecs
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MaskObject   = $Kernel::OM->Get('Kernel::System::Ticket::Mask');

    # get mask list
    my $MaskConfigs = $ConfigObject->Get('Frontend::TicketMasks') || {};
    my %ValidMasks;

    for my $Config ( values $MaskConfigs->%* ) {
        %ValidMasks = (
            %ValidMasks,
            map { $_ => $_ } $Config->@*,
        );
    }

    # get needed objects
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # ------------------------------------------------------------ #
    # definition change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'DefinitionChange' ) {

        # get definition
        my $Mask = $ParamObject->GetParam( Param => 'Mask' );

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" ) if !$Mask;

        # get definition
        my $Definition = $MaskObject->DefinitionGet(
            Mask   => $Mask,
            Return => 'STRING',
        );

        my $DefinitionHTML = $LayoutObject->Ascii2Html(
            Text => $Definition,
        );

        # generate MaskOptionStrg
        my $MaskOptionStrg = $LayoutObject->BuildSelection(
            Data         => \%ValidMasks,
            Name         => 'Mask',
            PossibleNone => 1,
            Translation  => 0,
            SelectedID   => $Mask,
            Class        => 'Modernize',
        );

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                MaskOptionStrg => $MaskOptionStrg,
                MaskSelected   => $Mask,
                Edit           => 1,
            },
        );

        # output overview result
        $LayoutObject->Block(
            Name => 'DefinitionChange',
            Data => {
                Definition => $DefinitionHTML,
                Mask       => $Mask,
                Rows       => 40,
            },
        );

        # ActionOverview
        $LayoutObject->Block(
            Name => 'ActionOverview',
        );

        # output header
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # generate output
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTicketMask',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # definition save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DefinitionSave' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %GetParam;

        # get params
        for my $Param (qw(Mask Definition)) {
            $GetParam{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }

        if ( !$GetParam{Mask} || !$ValidMasks{ $GetParam{Mask} } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need valid mask!"
            );
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
        }

        if ( !$GetParam{Definition} ) {
            $MaskObject->DefinitionDelete(
                Mask => $GetParam{Mask},
            );
        }
        else {
            # add to database
            my $Success = $MaskObject->DefinitionSet(
                Mask             => $GetParam{Mask},
                DefinitionString => $GetParam{Definition},
                UserID           => $Self->{UserID},
            );

            return $LayoutObject->ErrorScreen() if !$Success;
        }

        my $ContinueAfterSave = $ParamObject->GetParam( Param => 'ContinueAfterSave' );
        if ($ContinueAfterSave) {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=DefinitionChange;Mask=$GetParam{Mask}",
            );
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # ticket mask overview
    # ------------------------------------------------------------ #
    else {

        # generate ClassOptionStrg
        my $MaskOptionStrg = $LayoutObject->BuildSelection(
            Data         => \%ValidMasks,
            Name         => 'Mask',
            PossibleNone => 1,
            Translation  => 0,
            Class        => 'Modernize',
        );

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                MaskOptionStrg => $MaskOptionStrg,
            },
        );

        # output overview result
        $LayoutObject->Block(
            Name => 'OverviewList',
        );

        for my $Mask ( sort $MaskObject->ConfiguredMasksList() ) {
            $LayoutObject->Block(
                Name => 'OverviewListRow',
                Data => {
                    Mask => $Mask,
                },
            );
        }

        # output header
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # generate output
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTicketMask',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }
}

1;
