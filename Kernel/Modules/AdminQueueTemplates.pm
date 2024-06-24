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

package Kernel::Modules::AdminQueueTemplates;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    if ( !$Param{AccessRw} && $Param{AccessRo} ) {
        $Self->{LightAdmin} = 1;
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject            = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject           = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $QueueObject            = $Kernel::OM->Get('Kernel::System::Queue');
    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

    # ------------------------------------------------------------ #
    # template <-> queues 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Template' ) {

        # get template data
        my $ID                   = $ParamObject->GetParam( Param => 'ID' );
        my %StandardTemplateData = $StandardTemplateObject->StandardTemplateGet( ID => $ID );

        # get queues
        my %QueueData = $QueueObject->QueueList( Valid => 1 );

        # get assigned queues
        my %Member = $QueueObject->QueueStandardTemplateMemberList(
            StandardTemplateID => $ID,
        );

        my $StandardTemplateType = $LayoutObject->{LanguageObject}->Translate(
            $StandardTemplateData{TemplateType},
        );

        if ( $Self->{LightAdmin} ) {

            # Filter out queues without permission.
            my %RwQueues = $QueueObject->GetAllQueues(
                UserID => $Self->{UserID},
                Type   => 'rw',
            );

            for my $QueueID ( keys %QueueData ) {
                delete $QueueData{$QueueID} if !$RwQueues{$QueueID};
            }

            # Check the permission.
            my %Queues     = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $ID );
            my $Permission = $QueueObject->QueueListPermission(
                QueueIDs => [ keys %Queues ],
                UserID   => $Self->{UserID},
                Default  => 'rw',
            );

            if ( $Permission ne 'rw' ) {
                undef %StandardTemplateData;
                undef %Member;
                $StandardTemplateType = '';
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%QueueData,
            ID       => $StandardTemplateData{ID},
            Name     => $StandardTemplateType . ' - ' . $StandardTemplateData{Name},
            Type     => 'Template',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # templates <-> Queue n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Queue' ) {

        # get queue data
        my $ID        = $ParamObject->GetParam( Param => 'ID' );
        my %QueueData = $QueueObject->QueueGet( ID => $ID );

        # get templates
        my %StandardTemplateData = $StandardTemplateObject->StandardTemplateList(
            Valid => 1,
        );

        if (%StandardTemplateData) {
            for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
                my %Data = $StandardTemplateObject->StandardTemplateGet(
                    ID => $StandardTemplateID
                );
                $StandardTemplateData{$StandardTemplateID} = $LayoutObject->{LanguageObject}->Translate( $Data{TemplateType} )
                    . ' - '
                    . $Data{Name};
            }
        }

        # get assigned templates
        my %Member = $QueueObject->QueueStandardTemplateMemberList(
            QueueID => $ID,
        );

        if ( $Self->{LightAdmin} ) {

            # Filter out templates without permission.
            for my $StandardTemplateID ( keys %StandardTemplateData ) {
                my %Queues     = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $StandardTemplateID );
                my $Permission = $QueueObject->QueueListPermission(
                    QueueIDs => [ keys %Queues ],
                    UserID   => $Self->{UserID},
                    Default  => 'rw',
                );
                if ( $Permission ne 'rw' ) {
                    delete $StandardTemplateData{$StandardTemplateID};
                }
            }

            # Check the permission.
            my %RwQueues = $QueueObject->GetAllQueues(
                UserID => $Self->{UserID},
                Type   => 'rw',
            );

            if ( !$RwQueues{$ID} ) {
                undef %QueueData;
                undef %Member;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%StandardTemplateData,
            ID       => $QueueData{QueueID},
            Name     => $QueueData{Name},
            Type     => 'Queue',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add templates to queue
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeQueue' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new templates
        my @TemplatesSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @TemplatesAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $QueueID = $ParamObject->GetParam( Param => 'ID' );

        # create hash with selected templates
        my %TemplatesSelected = map { $_ => 1 } @TemplatesSelected;

        if ( $Self->{LightAdmin} ) {
            ID:
            for my $StandardTemplateID ( keys %TemplatesSelected ) {
                next ID if !$StandardTemplateID;    # Can contain empty string.

                my %Queues     = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $StandardTemplateID );
                my $Permission = $QueueObject->QueueListPermission(
                    QueueIDs => [ keys %Queues ],
                    UserID   => $Self->{UserID},
                    Default  => 'rw',
                );
                if ( $Permission ne 'rw' ) {
                    return $LayoutObject->Redirect(
                        OP => "Action=$Self->{Action}"
                    );
                }
            }
        }

        # check all used templates
        for my $TemplateID (@TemplatesAll) {
            my $Active = $TemplatesSelected{$TemplateID} ? 1 : 0;

            # set customer user service member
            $QueueObject->QueueStandardTemplateMemberAdd(
                QueueID            => $QueueID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        # if the user would like to continue editing the templates - queue relation just redirect to the edit screen
        # otherwise return to relations overview
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=Queue;ID=$QueueID"
            );
        }
        else {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # add queues to template
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeTemplate' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new queues
        my @QueuesSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @QueuesAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $TemplateID = $ParamObject->GetParam( Param => 'ID' );

        # create hash with selected queues
        my %QueuesSelected = map { $_ => 1 } @QueuesSelected;

        # backend check to prevent saving without permission.
        if ( $Self->{LightAdmin} ) {
            my %RwQueues = $QueueObject->GetAllQueues(
                UserID => $Self->{UserID},
                Type   => 'rw',
            );
            ID:
            for my $QueueID ( keys %QueuesSelected ) {
                next ID if !$QueueID;    # Can contain empty string.
                if ( !$RwQueues{$QueueID} ) {
                    return $LayoutObject->Redirect(
                        OP => "Action=$Self->{Action}"
                    );
                }
            }
        }

        # check all used queues
        for my $QueueID (@QueuesAll) {
            my $Active = $QueuesSelected{$QueueID} ? 1 : 0;

            # set customer user service member
            $QueueObject->QueueStandardTemplateMemberAdd(
                QueueID            => $QueueID,
                StandardTemplateID => $TemplateID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        # if the user would like to continue editing the queue - templates relation just redirect to the edit screen
        # otherwise return to relations overview
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=Template;ID=$TemplateID"
            );
        }
        else {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'Template';
    my $NeType = $Type eq 'Queue' ? 'Template' : 'Queue';

    my %VisibleType = (
        Template => 'Template',
        Queue    => 'Queue',
    );

    my $MyType       = $VisibleType{$Type};
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $BreadcrumbTitle = $LayoutObject->{LanguageObject}->Translate('Change Queue Relations for Template');

    if ( $VisibleType{$Type} eq 'Queue' ) {
        $BreadcrumbTitle = $LayoutObject->{LanguageObject}->Translate('Change Template Relations for Queue');
    }

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            Name            => $Param{Name},
            BreadcrumbTitle => $BreadcrumbTitle,
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );
    $LayoutObject->Block( Name => 'Filter' );

    #fixed link
    my $QueueTag;

    $QueueTag = $Type eq 'Queue' ? 'Queue' : '';

    $LayoutObject->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome      => 'Admin' . $Type,
            NeType          => $NeType,
            VisibleType     => $VisibleType{$Type},
            VisibleNeType   => $VisibleType{$NeType},
            Queue           => $QueueTag,
            BreadcrumbTitle => $BreadcrumbTitle,
        },
    );

    # check if there are queue/template
    if ( !%Data ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgList',
            Data => {
                ColSpan => 2,
            },
        );
    }

    $LayoutObject->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type          => $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        my $Selected = $Param{Selected}->{$ID} ? ' checked ' : '';

        $QueueTag = $Type ne 'Queue' ? 'Queue' : '';

        $LayoutObject->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name          => $Param{Data}->{$ID},
                NeType        => $NeType,
                Type          => $Type,
                ID            => $ID,
                Selected      => $Selected,
                VisibleType   => $VisibleType{$Type},
                VisibleNeType => $VisibleType{$NeType},
                Queue         => $QueueTag,
            },
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AdminQueueTemplates',
        Data         => \%Param,
        VisibleType  => $MyType,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );

    # no actions in action list
    #    $LayoutObject->Block(Name=>'ActionList');
    $LayoutObject->Block( Name => 'FilterTemplate' );
    $LayoutObject->Block( Name => 'FilterQueue' );
    $LayoutObject->Block( Name => 'OverviewResult' );

    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

    # get std template list
    my %StandardTemplateData = $StandardTemplateObject->StandardTemplateList(
        Valid => 1,
    );

    # if there are results to show
    if (%StandardTemplateData) {
        for my $StandardTemplateID ( sort keys %StandardTemplateData ) {
            my %Data = $StandardTemplateObject->StandardTemplateGet(
                ID => $StandardTemplateID,
            );
            $StandardTemplateData{$StandardTemplateID} = $LayoutObject->{LanguageObject}->Translate( $Data{TemplateType} )
                . ' - '
                . $Data{Name};
        }
        ID:
        for my $StandardTemplateID (
            sort { uc( $StandardTemplateData{$a} ) cmp uc( $StandardTemplateData{$b} ) }
            keys %StandardTemplateData
            )
        {
            if ( $Self->{LightAdmin} ) {
                my %Queues     = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $StandardTemplateID );
                my $Permission = $QueueObject->QueueListPermission(
                    QueueIDs => [ keys %Queues ],
                    UserID   => $Self->{UserID},
                    Default  => 'rw',
                );
                if ( $Permission ne 'rw' ) {
                    next ID;
                }
            }

            # set output class
            $LayoutObject->Block(
                Name => 'List1n',
                Data => {
                    Name      => $StandardTemplateData{$StandardTemplateID},
                    Subaction => 'Template',
                    ID        => $StandardTemplateID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoTemplatesFoundMsg',
            Data => {},
        );
    }

    # get queue data
    my %QueueData = $Kernel::OM->Get('Kernel::System::Queue')->QueueList( Valid => 1 );

    if ( $Self->{LightAdmin} ) {

        # Filter out queues without permission.
        my %RwQueues = $QueueObject->GetAllQueues(
            UserID => $Self->{UserID},
            Type   => 'rw',
        );

        for my $QueueID ( keys %QueueData ) {
            delete $QueueData{$QueueID} if !$RwQueues{$QueueID};
        }
    }

    # if there are results to show
    if (%QueueData) {
        for my $QueueID ( sort { uc( $QueueData{$a} ) cmp uc( $QueueData{$b} ) } keys %QueueData ) {

            # set output class
            $LayoutObject->Block(
                Name => 'Listn1',
                Data => {
                    Name      => $QueueData{$QueueID},
                    Subaction => 'Queue',
                    ID        => $QueueID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoQueuesFoundMsg',
            Data => {},
        );
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminQueueTemplates',
        Data         => \%Param,
    );
}

1;
