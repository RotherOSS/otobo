# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Modules::AdminQueueAutoResponse;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Output      = '';
    $Param{ID}     = $ParamObject->GetParam( Param => 'ID' ) || '';
    $Param{Action} = $ParamObject->GetParam( Param => 'Action' )
        || 'AdminQueueAutoResponse';
    $Param{Filter} = $ParamObject->GetParam( Param => 'Filter' ) || '';

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $QueueObject        = $Kernel::OM->Get('Kernel::System::Queue');
    my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');

    # get Type Auto Responses data
    my %TypeResponsesData = $AutoResponseObject->AutoResponseTypeList();

    if ( $Self->{Subaction} eq 'Change' ) {
        $Output .= $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # get queue data
        my %QueueData = $QueueObject->QueueGet(
            ID => $Param{ID},
        );
        if ( $Self->{LightAdmin} ) {
            $QueueData{Permission} = $QueueObject->QueueListPermission(
                QueueIDs => [ $Param{ID} ],
                UserID   => $Self->{UserID},
            );

            # No permission for the queue.
            if ( !$QueueData{Permission} ) {
                %QueueData = ();
            }
            elsif ( $QueueData{Permission} eq 'ro' ) {
                $Output .= $LayoutObject->Notify(
                    Priority => 'Notice',
                    Data     => $LayoutObject->{LanguageObject}->Translate('No permission to edit auto responses for this queue.'),
                );
            }
        }

        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                Subaction => $Self->{Subaction},
                QueueName => $QueueData{Name},
            },
        );
        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionOverview' );

        $LayoutObject->Block(
            Name => 'Selection',
            Data => {
                Queue => $QueueData{Name},
                %QueueData,
                %Param,
                ActionHome => 'AdminQueue',
            },
        );
        for my $TypeID ( sort keys %TypeResponsesData ) {

            if (%QueueData) {

                # get all valid Auto Responses data for appropriate Auto Responses type
                my %AutoResponseListByType = $AutoResponseObject->AutoResponseList(
                    TypeID => $TypeID,
                );

                if ( $Self->{LightAdmin} ) {
                    for my $AutoResponseID ( sort keys %AutoResponseListByType ) {
                        my %Queues     = $AutoResponseObject->QueueAutoResponseMemberList( AutoResponseID => $AutoResponseID );
                        my $Permission = $QueueObject->QueueListPermission(
                            QueueIDs => [ keys %Queues ],
                            UserID   => $Self->{UserID},
                            Default  => 'rw',
                        );
                        if ( $Permission ne 'rw' ) {
                            delete $AutoResponseListByType{$AutoResponseID};
                        }
                    }
                }

                # get selected Auto Responses for appropriate Auto Responses type and Queue
                my %AutoResponseData = $AutoResponseObject->AutoResponseGetByTypeQueueID(
                    QueueID => $Param{ID},
                    Type    => $TypeResponsesData{$TypeID},
                );

                $Param{DataStrg} = $LayoutObject->BuildSelection(
                    Name         => "IDs_$TypeID",
                    SelectedID   => $AutoResponseData{AutoResponseID} || '',
                    Data         => \%AutoResponseListByType,
                    Size         => 1,
                    PossibleNone => 1,
                    Class        => 'Modernize W50pc',
                );
            }
            $LayoutObject->Block(
                Name => 'ChangeItemList',
                Data => {
                    Type   => $TypeResponsesData{$TypeID},
                    TypeID => $TypeID,
                    %Param,
                },
            );
        }
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueueAutoResponse',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
    }

    # queues to queue_auto_responses
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();
        if ( $Self->{LightAdmin} ) {

            # check if user has rw permissions on the QueueID
            my $Permission = $QueueObject->QueueListPermission(
                QueueIDs => [ $Param{ID} ],
                UserID   => $Self->{UserID},
            );

            # no permission to change.
            if ( $Permission ne 'rw' ) {
                return $LayoutObject->Redirect(
                    OP => "Action=$Self->{Action};Subaction=Change;ID=$Param{ID}"
                );
            }

            # check if user has permissions on every AutoResponseID
            CHECK_AUTO_RESPONSE_ID:
            for my $TypeID ( sort keys %TypeResponsesData ) {
                my $ParamAutoResponseID = $ParamObject->GetParam( Param => "IDs_$TypeID" );

                next CHECK_AUTO_RESPONSE_ID if !$ParamAutoResponseID;
                my %AutoResponseListByType = $AutoResponseObject->AutoResponseList( TypeID => $TypeID );

                for my $AutoResponseID ( keys %AutoResponseListByType ) {
                    my %Queues     = $AutoResponseObject->QueueAutoResponseMemberList( AutoResponseID => $AutoResponseID );
                    my $Permission = $QueueObject->QueueListPermission(
                        QueueIDs => [ keys %Queues ],
                        UserID   => $Self->{UserID},
                        Default  => 'rw',
                    );
                    if ( $Permission ne 'rw' ) {
                        delete $AutoResponseListByType{$AutoResponseID};
                    }
                }

                # no permission to change.
                if ( !$AutoResponseListByType{$ParamAutoResponseID} ) {
                    return $LayoutObject->Redirect(
                        OP => "Action=$Self->{Action};Subaction=Change;ID=$Param{ID}"
                    );
                }
            }
        }

        my @NewIDs = ();

        # get Type Auto Responses data
        my %TypeResponsesData = $AutoResponseObject->AutoResponseTypeList();

        # set Auto Responses IDs for this queue.
        for my $TypeID ( sort keys %TypeResponsesData ) {
            push( @NewIDs, $ParamObject->GetParam( Param => "IDs_$TypeID" ) );
        }

        $AutoResponseObject->AutoResponseQueue(
            QueueID         => $Param{ID},
            AutoResponseIDs => \@NewIDs,
            UserID          => $Self->{UserID},
        );

        # if the user would like to continue editing the queue - auto response relation, just redirect to the edit screen
        # otherwise return to overview
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Subaction=Change;ID=$Param{ID}" );
        }
        else {
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
        }
    }

    # else ! print form
    else {
        $Output .= $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # get queue data
        my %QueueData;
        my $QueueHeader;

        # filter queues without auto responses
        if ( $Param{Filter} eq 'QueuesWithoutAutoResponses' ) {

            %QueueData = $AutoResponseObject->AutoResponseWithoutQueue();

            # use appropriate header
            $QueueHeader = Translatable('Queues ( without auto responses )');

        }
        else {
            %QueueData   = $QueueObject->QueueList( Valid => 1 );
            $QueueHeader = Translatable('Queues');
        }

        $LayoutObject->Block(
            Name => 'Overview',
            Data => { %QueueData, %Param, }
        );

        $LayoutObject->Block( Name => 'FilterQueues' );
        $LayoutObject->Block( Name => 'FilterAutoResponses' );
        $LayoutObject->Block( Name => 'ActionList' );

        if ( $Param{Filter} eq 'QueuesWithoutAutoResponses' ) {
            $LayoutObject->Block( Name => 'ShowAllQueues' );
        }
        else {
            $LayoutObject->Block( Name => 'QueuesWithoutAutoResponses' );
        }

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => {
                QueueHeader => $QueueHeader,
            },
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
        }

        # if there are any queues, they are shown
        if (%QueueData) {
            for ( sort { $QueueData{$a} cmp $QueueData{$b} } keys %QueueData ) {
                $LayoutObject->Block(
                    Name => 'Item',
                    Data => {
                        Queue   => $QueueData{$_},
                        QueueID => $_,
                        %QueueData,
                        %Param,
                    },
                );
            }
        }

        # otherwise a no data found message is displayed
        else {
            $LayoutObject->Block(
                Name => 'NoQueuesFoundMsg',
                Data => {},
            );
        }

        # get valid Auto Response IDs
        my %AutoResponseList = $AutoResponseObject->AutoResponseList();
        if ( $Self->{LightAdmin} ) {
            for my $AutoResponseID ( sort keys %AutoResponseList ) {
                my %Queues     = $AutoResponseObject->QueueAutoResponseMemberList( AutoResponseID => $AutoResponseID );
                my $Permission = $QueueObject->QueueListPermission(
                    QueueIDs => [ keys %Queues ],
                    UserID   => $Self->{UserID},
                    Default  => 'rw',
                );
                if ( $Permission ne 'rw' ) {
                    delete $AutoResponseList{$AutoResponseID};
                }
            }
        }

        # if there are any auto responses, they are shown
        if ( keys %AutoResponseList ) {
            for my $AutoResponseID ( sort keys %AutoResponseList ) {

                my %Data = $AutoResponseObject->AutoResponseGet(
                    ID => $AutoResponseID,
                );

                my %ResponseDataItem = (
                    ID   => $Data{ID},
                    Type => $Data{Type},
                    Name => $Data{Name},
                );

                $LayoutObject->Block(
                    Name => 'ItemList',
                    Data => \%ResponseDataItem,
                );
            }
        }

        # otherwise a no data found message is displayed
        else {
            $LayoutObject->Block(
                Name => 'NoAutoResponsesFoundMsg',
                Data => {},
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueueAutoResponse',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
    }
    return $Output;
}

1;
