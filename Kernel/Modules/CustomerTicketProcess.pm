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

package Kernel::Modules::CustomerTicketProcess;
## nofilter(TidyAll::Plugin::OTOBO::Perl::DBObject)

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless $Self, $Type;

    # global config hash for id dissolution
    $Self->{NameToID} = {
        Title          => 'Title',
        State          => 'StateID',
        StateID        => 'StateID',
        Priority       => 'PriorityID',
        PriorityID     => 'PriorityID',
        Lock           => 'LockID',
        LockID         => 'LockID',
        Queue          => 'QueueID',
        QueueID        => 'QueueID',
        Customer       => 'CustomerID',
        CustomerID     => 'CustomerID',
        CustomerNo     => 'CustomerID',
        CustomerUserID => 'CustomerUserID',
        Type           => 'TypeID',
        TypeID         => 'TypeID',
        SLA            => 'SLAID',
        SLAID          => 'SLAID',
        Service        => 'ServiceID',
        ServiceID      => 'ServiceID',
        Article        => 'Article',
    };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $TicketID               = $Self->{TicketID}              || $ParamObject->GetParam( Param => 'TicketID' );
    my $ActivityDialogEntityID = $Param{ActivityDialogEntityID} || $ParamObject->GetParam( Param => 'ActivityDialogEntityID' );
    my $ProcessEntityID        = $Param{ProcessEntityID}        || $ParamObject->GetParam( Param => 'ProcessEntityID' );

    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID',
        );

        return;
    }
    if ( !$ActivityDialogEntityID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ActivityDialogEntityID',
        );

        return;
    }
    if ( !$ProcessEntityID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ProcessEntityID',
        );

        return;
    }

    # extend used ids in html to enable multiple dialogs per page
    $Self->{IDSuffix} = $ActivityDialogEntityID ? $ActivityDialogEntityID =~ s/^ActivityDialog-/_/r : '';

    # get needed objects
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    # include extra fields should be skipped for follow ups
    for my $Item (qw(Service SLA Queue)) {
        push @{$SkipFields}, $Item;
    }

    # list Active processes, fetch also FadeAway processes to continue working with existing tickets
    my @ProcessStates = ( 'Active', 'FadeAway' );

    # get process object
    my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process');

    # get all follow up processes
    my $FollowupProcessList = $ProcessObject->ProcessList(
        ProcessState => \@ProcessStates,
        Interface    => 'all',
    );

    if ( !IsHashRefWithData($FollowupProcessList) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'No follow up process configured!',
        );

        return;
    }

    # we need a subaction as of OTOBO 10.1
    if ( !$Self->{Subaction} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Subaction!',
        );

        return;
    }

    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::FormCache')->PrepareFormID(
        ParamObject  => $ParamObject,
        LayoutObject => $LayoutObject,
    );

    # if invalid process is detected on a ActivityDilog popup screen show an error message
    if (
        $Self->{Subaction} eq 'DisplayActivityDialog'
        && !$FollowupProcessList->{$ProcessEntityID}
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Process $ProcessEntityID is invalid!",
        );

        return;
    }

    # Get the necessary parameters
    # collects a mixture of present values bottom to top:
    # SysConfig DefaultValues, ActivityDialog DefaultValues, TicketValues, SubmittedValues
    # including ActivityDialogEntityID and ProcessEntityID
    # is used for:
    # - Parameter checking before storing
    # - will be used for ACL checking later on
    my $GetParam = $Self->_GetParam(
        ProcessEntityID        => $ProcessEntityID,
        TicketID               => $TicketID,
        ActivityDialogEntityID => $ActivityDialogEntityID,
    );

    if ( $Self->{Subaction} eq 'StoreActivityDialog' && $ProcessEntityID ) {
        $LayoutObject->ChallengeTokenCheck( Type => 'Customer' );

        return $Self->_StoreActivityDialog(
            %Param,
            ProcessName     => $FollowupProcessList->{$ProcessEntityID},
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
    }
    elsif ( $Self->{Subaction} eq 'DisplayActivityDialog' && $ProcessEntityID ) {

        return $Self->_OutputActivityDialog(
            %Param,
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        return $Self->_RenderAjax(
            %Param,
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Subaction is invalid',
    );

    return;
}

sub _RenderAjax {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # FatalError is safe because a JSON structure is expecting, then it will result into a
    # communications error

    for my $Needed (qw(ProcessEntityID)) {
        if ( !$Param{$Needed} ) {
            $LayoutObject->CustomerFatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderAjax' ),
            );
        }
    }
    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};
    if ( !$ActivityDialogEntityID ) {
        $LayoutObject->CustomerFatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogEntityID', '_RenderAjax' ),
        );
    }
    my $ActivityDialog = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog')->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
    );

    if ( !IsHashRefWithData($ActivityDialog) ) {
        $LayoutObject->CustomerFatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No ActivityDialog configured for %s in _RenderAjax!', $ActivityDialogEntityID ),
        );
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my %FieldsProcessed;
    my @JSONCollector;
    my $Services;

    # All submitted DynamicFields
    # get dynamic field values form http request
    my %DynamicFieldValues;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    # Get the activity dialog's Submit Param's or Config Params
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        # Skip if we're working on a field that was already done with or without ID
        if (
            $Self->{NameToID}{$CurrentField}
            && $FieldsProcessed{ $Self->{NameToID}{$CurrentField} }
            )
        {
            next DIALOGFIELD;
        }

        next DIALOGFIELD if $CurrentField =~ m{^DynamicField_(.*)}xms;

        if ( $Self->{NameToID}{$CurrentField} eq 'QueueID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetQueues(
                %{ $Param{GetParam} },
            );

            # add Queue to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name         => $Self->{NameToID}{$CurrentField} . $Self->{IDSuffix},
                    Data         => $Data,
                    SelectedID   => $Param{GetParam}{ $Self->{NameToID}{$CurrentField} },
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }

        elsif ( $Self->{NameToID}{$CurrentField} eq 'StateID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetStates(
                %{ $Param{GetParam} },
            );

            # add State to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name        => 'StateID' . $Self->{IDSuffix},
                    Data        => $Data,
                    SelectedID  => $Param{GetParam}{ $Self->{NameToID}{$CurrentField} },
                    Translation => 1,
                    Max         => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'PriorityID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetPriorities(
                %{ $Param{GetParam} },
            );

            # add Priority to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name        => $Self->{NameToID}{$CurrentField} . $Self->{IDSuffix},
                    Data        => $Data,
                    SelectedID  => $Param{GetParam}{ $Self->{NameToID}{$CurrentField} },
                    Translation => 1,
                    Max         => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'ServiceID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetServices(
                %{ $Param{GetParam} },
            );
            $Services = $Data;

            # add Service to the JSONCollector (Use ServiceID from web request)
            push(
                @JSONCollector,
                {
                    Name         => $Self->{NameToID}{$CurrentField} . $Self->{IDSuffix},
                    Data         => $Data,
                    SelectedID   => $ParamObject->GetParam( Param => 'ServiceID' ) || '',
                    PossibleNone => 1,
                    Translation  => $TreeView,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'SLAID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            # if SLA is render before service (by it order in the fields) it needs to create
            # the service list
            if ( !IsHashRefWithData($Services) ) {
                $Services = $Self->_GetServices(
                    %{ $Param{GetParam} },
                );
            }

            my $Data = $Self->_GetSLAs(
                %{ $Param{GetParam} },
                Services  => $Services,
                ServiceID => $ParamObject->GetParam( Param => 'ServiceID' ) || '',
            );

            # add SLA to the JSONCollector (Use SelectedID from web request)
            push(
                @JSONCollector,
                {
                    Name         => $Self->{NameToID}{$CurrentField} . $Self->{IDSuffix},
                    Data         => $Data,
                    SelectedID   => $ParamObject->GetParam( Param => 'SLAID' ) || '',
                    PossibleNone => 1,
                    Translation  => 1,
                    Max          => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'TypeID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetTypes(
                %{ $Param{GetParam} },
            );

            # Add Type to the JSONCollector (Use SelectedID from web request).
            push(
                @JSONCollector,
                {
                    Name         => $Self->{NameToID}{$CurrentField} . $Self->{IDSuffix},
                    Data         => $Data,
                    SelectedID   => $ParamObject->GetParam( Param => 'TypeID' ) || '',
                    PossibleNone => 1,
                    Translation  => 1,
                    Max          => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
    }

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $FieldRestrictionsObject   = $Kernel::OM->Get('Kernel::System::Ticket::FieldRestrictions');

    # retrieve field restrictions for dynamic fields
    my $ACLPreselection;
    if ( $ConfigObject->Get('TicketACL::ACLPreselection') ) {

        # get cached preselection rules
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        $ACLPreselection = $CacheObject->Get(
            Type => 'TicketACL',
            Key  => 'Preselection',
        );
        if ( !$ACLPreselection ) {
            $ACLPreselection = $FieldRestrictionsObject->SetACLPreselectionCache();
        }
    }

    my $Autoselect      = $ConfigObject->Get('TicketACL::Autoselect') || undef;
    my $LoopProtection  = 100;
    my %ChangedElements = $Param{GetParam}{ElementChanged} ? ( $Param{GetParam}{ElementChanged} => 1 ) : ();

    # build hash of field configs without suffix attached to name
    my %FieldConfigsPlain = map { ( $_ => { $Self->{DynamicField}{$_}->%*, Name => $_ } ) } keys $Self->{DynamicField}->%*;

    # get values and visibility of dynamic fields
    my %DynFieldStates = $FieldRestrictionsObject->GetFieldStates(
        TicketObject              => $TicketObject,
        DynamicFields             => \%FieldConfigsPlain,
        DynamicFieldBackendObject => $Kernel::OM->Get('Kernel::System::DynamicField::Backend'),
        Action                    => $Self->{Action},
        ChangedElements           => \%ChangedElements,
        TicketID                  => $Param{TicketID},
        FormID                    => $Self->{FormID},
        CustomerUser              => $Self->{UserID},
        GetParam                  => $Param{GetParam},
        Autoselect                => $Autoselect,
        ACLPreselection           => $ACLPreselection // '',
        LoopProtection            => \$LoopProtection,
    );

    # set new values
    my $DFParam = {
        %{ $Param{GetParam}{DynamicField} // {} },
        $DynFieldStates{NewValues}->%*,
    };

    for my $SetField ( values $DynFieldStates{Sets}->%* ) {
        my $DynamicFieldConfig = $SetField->{DynamicFieldConfig};

        # the frontend name is the name of the inner field including its index or the '_Template' suffix
        DYNAMICFIELD:
        for my $FrontendName ( keys $SetField->{FieldStates}->%* ) {

            if ( $DynamicFieldConfig->{Config}{MultiValue} && ref $SetField->{Values}{$FrontendName} eq 'ARRAY' ) {
                for my $i ( 0 .. $#{ $SetField->{Values}{$FrontendName} } ) {
                    my $DataValues = $SetField->{FieldStates}{$FrontendName}{NotACLReducible}
                        ? $SetField->{Values}{$FrontendName}[$i]
                        :
                        (
                            $DynamicFieldBackendObject->BuildSelectionDataGet(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                PossibleValues     => $SetField->{FieldStates}{$FrontendName}{PossibleValues},
                                Value              => [ $SetField->{Values}{$FrontendName}[$i] ],
                            )
                            || $SetField->{FieldStates}{$FrontendName}{PossibleValues}
                        );

                    # add dynamic field to the list of fields to update
                    push @JSONCollector, {
                        Name        => 'DynamicField_' . $FrontendName . "_$i",
                        Data        => $DataValues,
                        SelectedID  => $SetField->{Values}{$FrontendName}[$i],
                        Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                        Max         => 100,
                    };
                }

                next DYNAMICFIELD;
            }

            my $DataValues = $SetField->{FieldStates}{$FrontendName}{NotACLReducible}
                ? $SetField->{Values}{$FrontendName}
                :
                (
                    $DynamicFieldBackendObject->BuildSelectionDataGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        PossibleValues     => $SetField->{FieldStates}{$FrontendName}{PossibleValues},
                        Value              => $SetField->{Values}{$FrontendName},
                    )
                    || $SetField->{FieldStates}{$FrontendName}{PossibleValues}
                );

            # add dynamic field to the list of fields to update
            push @JSONCollector, {
                Name        => 'DynamicField_' . $FrontendName,
                Data        => $DataValues,
                SelectedID  => $SetField->{Values}{$FrontendName},
                Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                Max         => 100,
            };
        }
    }

    # attach process suffix to dynamic field names in visibility hash
    my %VisibilitySuffixed = map { $_ . $Self->{IDSuffix} => $DynFieldStates{Visibility}{$_} } keys $DynFieldStates{Visibility}->%*;

    if ( IsHashRefWithData( $DynFieldStates{Visibility} ) ) {
        push @JSONCollector, {
            Name => 'Restrictions_Visibility',
            Data => \%VisibilitySuffixed,
        };
    }

    DYNAMICFIELD:
    for my $Name ( keys $DynFieldStates{Fields}->%* ) {
        my $DynamicFieldConfig = $Self->{DynamicField}{$Name};

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        if ( $DynamicFieldConfig->{Config}{MultiValue} && ref $DFParam->{"DynamicField_$Name"} eq 'ARRAY' ) {
            for my $i ( 0 .. $#{ $DFParam->{"DynamicField_$Name"} } ) {
                my $DataValues = $DynFieldStates{Fields}{$Name}{NotACLReducible}
                    ? $DFParam->{"DynamicField_$Name"}[$i]
                    :
                    (
                        $DynamicFieldBackendObject->BuildSelectionDataGet(
                            DynamicFieldConfig => $DynamicFieldConfig,
                            PossibleValues     => $DynFieldStates{Fields}{$Name}{PossibleValues},
                            Value              => [ $DFParam->{"DynamicField_$Name"}[$i] ],
                        )
                        || $DynFieldStates{Fields}{$Name}{PossibleValues}
                    );

                # add dynamic field to the list of fields to update
                push @JSONCollector, {
                    Name        => 'DynamicField_' . $DynamicFieldConfig->{Name} . "_$i",      # contains the id suffix
                    Data        => $DataValues,
                    SelectedID  => $DFParam->{"DynamicField_$Name"}[$i],
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                };
            }

            next DYNAMICFIELD;
        }

        my $DataValues = $DynFieldStates{Fields}{$Name}{NotACLReducible}
            ? $DFParam->{"DynamicField_$Name"}
            :
            (
                $DynamicFieldBackendObject->BuildSelectionDataGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    PossibleValues     => $DynFieldStates{Fields}{$Name}{PossibleValues},
                    Value              => $DFParam->{"DynamicField_$Name"},
                )
                || $DynFieldStates{Fields}{$Name}{PossibleValues}
            );

        # add dynamic field to the list of fields to update
        push @JSONCollector, {
            Name        => 'DynamicField_' . $DynamicFieldConfig->{Name},              # contains the id suffix
            Data        => $DataValues,
            SelectedID  => $DFParam->{"DynamicField_$Name"},
            Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
            Max         => 100,
        };
    }

    my $JSON = $LayoutObject->BuildSelectionJSON( [@JSONCollector] );

    return $LayoutObject->Attachment(
        ContentType => 'application/json',
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

# =item _GetParam()
#
# returns the current data state of the submitted information
#
# This contains the following data for the different callers:
#
#     Initial call with selected Process:
#         ProcessEntityID
#         ActivityDialogEntityID
#         DefaultValues for the configured Fields in that ActivityDialog
#         DefaultValues for the 4 required Fields Queue State Lock Priority
#
#     First Store call submitting an Activity Dialog:
#         ProcessEntityID
#         ActivityDialogEntityID
#         SubmittedValues for the current ActivityDialog
#         ActivityDialog DefaultValues for invisible fields of that ActivityDialog
#         DefaultValues for the 4 required Fields Queue State Lock Priority
#             if not configured in the ActivityDialog
#
#     ActivityDialog fillout request on existing Ticket:
#         ProcessEntityID
#         ActivityDialogEntityID
#         TicketValues
#
#     ActivityDialog store request or AjaxUpdate request on existing Tickets:
#         ProcessEntityID
#         ActivityDialogEntityID
#         TicketValues for all not-Submitted Values
#         Submitted Values
#
#     my $GetParam = _GetParam(
#         ProcessEntityID => $ProcessEntityID,
#     );
#
# =cut

sub _GetParam {
    my ( $Self, %Param ) = @_;

    #my $IsAJAXUpdate = $Param{AJAX} || '';

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Needed (qw(ProcessEntityID)) {
        if ( !$Param{$Needed} ) {
            $LayoutObject->CustomerFatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_GetParam' ),
            );
        }
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %GetParam;
    my %Ticket;
    my $ProcessEntityID        = $Param{ProcessEntityID};
    my $TicketID               = $Param{TicketID}               || $ParamObject->GetParam( Param => 'TicketID' );
    my $ActivityDialogEntityID = $Param{ActivityDialogEntityID} || $ParamObject->GetParam(
        Param => 'ActivityDialogEntityID',
    );
    my $ActivityEntityID;
    my %ValuesGotten;
    my $Value;

    # If we got no ActivityDialogEntityID and no TicketID
    # we have to get the Processes' Startpoint
    if ( !$ActivityDialogEntityID && !$TicketID ) {
        my $ActivityActivityDialog = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessStartpointGet(
            ProcessEntityID => $ProcessEntityID,
        );
        if (
            !$ActivityActivityDialog->{ActivityDialog}
            || !$ActivityActivityDialog->{Activity}
            )
        {
            my $Message = $LayoutObject->{LanguageObject}->Translate(
                'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!',
                $ProcessEntityID,
            );

            # does not show header and footer again
            if ( $Self->{IsMainWindow} ) {
                return $LayoutObject->CustomerError(
                    Message => $Message,
                );
            }

            $LayoutObject->CustomerFatalError(
                Message => $Message,
            );
        }
        $ActivityDialogEntityID = $ActivityActivityDialog->{ActivityDialog};
        $ActivityEntityID       = $ActivityActivityDialog->{Activity};
    }

    my $ActivityDialog = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog')->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
    );

    if ( !IsHashRefWithData($ActivityDialog) ) {
        return $LayoutObject->CustomerErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Couldn\'t get ActivityDialogEntityID "%s"!', $ActivityDialogEntityID ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # if there is a ticket then is not an AJAX request
    if ($TicketID) {
        %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $TicketID,
            UserID        => $ConfigObject->Get('CustomerPanelUserID'),
            DynamicFields => 1,
        );

        %GetParam = %Ticket;
        if ( !IsHashRefWithData( \%GetParam ) ) {
            $LayoutObject->CustomerFatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Couldn\'t get Ticket for TicketID: %s in _GetParam!', $TicketID ),
            );
        }

        $ActivityEntityID = $Ticket{
            'DynamicField_'
                . $ConfigObject->Get("Process::DynamicFieldProcessManagementActivityID")
        };
        if ( !$ActivityEntityID ) {
            $LayoutObject->CustomerFatalError(
                Message =>
                    Translatable('Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!'),
            );
        }

    }
    $GetParam{ActivityDialogEntityID} = $ActivityDialogEntityID;
    $GetParam{ActivityEntityID}       = $ActivityEntityID;
    $GetParam{ProcessEntityID}        = $ProcessEntityID;

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    # Get the activitydialogs's Submit Param's or Config Params
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        # Skip if we're working on a field that was already done with or without ID
        if ( $Self->{NameToID}{$CurrentField} && $ValuesGotten{ $Self->{NameToID}{$CurrentField} } )
        {
            next DIALOGFIELD;
        }

        # handle dynamic fields separately
        next DIALOGFIELD if $CurrentField =~ m{^DynamicField_(.*)}xms;

        # get article fields
        if ( $CurrentField eq 'Article' ) {

            $GetParam{Subject} = $ParamObject->GetParam( Param => 'Subject' );
            $GetParam{Body}    = $ParamObject->GetParam( Param => 'Body' );

            $ValuesGotten{Article} = 1 if ( $GetParam{Subject} && $GetParam{Body} );
        }

        # Non DynamicFields
        # 1. try to get the required param
        my $Value = $ParamObject->GetParam( Param => $Self->{NameToID}{$CurrentField} );

        if ($Value) {

            # if we have an ID field make sure the value without ID won't be in the
            # %GetParam Hash any more
            if ( $Self->{NameToID}{$CurrentField} =~ m{(.*)ID$}xms ) {
                $GetParam{$1} = undef;
            }
            $GetParam{ $Self->{NameToID}{$CurrentField} }     = $Value;
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            next DIALOGFIELD;
        }

        # If we got ticket params, the GetParam Hash was already filled before the loop
        # and we can next out
        if ( $GetParam{ $Self->{NameToID}{$CurrentField} } ) {
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            next DIALOGFIELD;
        }

        # if no Submitted nore Ticket Param get ActivityDialog Config's Param
        $Value = $ActivityDialog->{Fields}{$CurrentField}{DefaultValue};

        if ($Value) {
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            $GetParam{$CurrentField} = $Value;
            next DIALOGFIELD;
        }
    }
    REQUIREDFIELDLOOP:
    for my $CurrentField (qw(Queue State Lock Priority)) {
        $Value = undef;
        if ( !$ValuesGotten{ $Self->{NameToID}{$CurrentField} } ) {
            $Value = $ConfigObject->Get("Process::Default$CurrentField");
            if ( !$Value ) {

                my $Message = $LayoutObject->{LanguageObject}->Translate( 'Process::Default%s Config Value missing!', $CurrentField );

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Message,
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Message,
                );
            }
            $GetParam{$CurrentField} = $Value;
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
        }
    }

    # get also the IDs for the Required files (if they are not present)
    if ( $GetParam{Queue} && !$GetParam{QueueID} ) {
        $GetParam{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $GetParam{Queue} );
    }
    if ( $GetParam{State} && !$GetParam{StateID} ) {
        $GetParam{StateID} = $Kernel::OM->Get('Kernel::System::State')->StateLookup( State => $GetParam{State} );
    }
    if ( $GetParam{Lock} && !$GetParam{LockID} ) {
        $GetParam{LockID} = $Kernel::OM->Get('Kernel::System::Lock')->LockLookup( Lock => $GetParam{Lock} );
    }
    if ( $GetParam{Priority} && !$GetParam{PriorityID} ) {
        $GetParam{PriorityID} = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
            Priority => $GetParam{Priority},
        );
    }

    # and almost finally we'll have the special parameters:
    $GetParam{ResponsibleAll} = $ParamObject->GetParam( Param => 'ResponsibleAll' );
    $GetParam{OwnerAll}       = $ParamObject->GetParam( Param => 'OwnerAll' );
    $GetParam{ElementChanged} = $ParamObject->GetParam( Param => 'ElementChanged' ) || '';

    # cut suffix from name of changed element
    if ( $GetParam{ElementChanged} =~ /^(?<DFChanged>DynamicField_[A-Za-z0-9\-]+)$Self->{IDSuffix}$/ ) {
        $GetParam{ElementChanged} = $+{DFChanged};
    }

    # handle dynamic fields
    $Self->{DynamicField} = {};

    # Parse definition if present
    if ( $ActivityDialog->{InputFieldDefinition} ) {
        my $InputFieldDefinition = $Kernel::OM->Get('Kernel::System::YAML')->Load(
            Data => $ActivityDialog->{InputFieldDefinition},
        );

        my $DynamicFields = $Self->_GetInputDefinitionDynamicFields(
            InputFieldDefinition => $InputFieldDefinition,
        );

        $Self->{DynamicField} = $DynamicFields // {};
    }

    if ( IsHashRefWithData( $ActivityDialog->{Fields} ) ) {
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        DFNAME:
        for my $DFName ( map {/^DynamicField_(.+)$/} keys $ActivityDialog->{Fields}->%* ) {
            next DFNAME if $Self->{DynamicField}{$DFName};

            $Self->{DynamicField}{$DFName} = $DynamicFieldObject->DynamicFieldGet(
                Name => $DFName,
            );
        }
    }

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    DYNAMICFIELD:
    for my $DynamicFieldName ( keys $Self->{DynamicField}->%* ) {

        # Get the Config of the current DynamicField
        my $DynamicFieldConfig = $Self->{DynamicField}{$DynamicFieldName};

        if ( !IsHashRefWithData($DynamicFieldConfig) ) {
            my $Message =
                "DynamicFieldConfig missing for field: $DynamicFieldName, or is not a Ticket Dynamic Field!";

            # log error but does not stop the execution as it could be an old Article
            # DynamicField, see bug#11666
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Message,
            );

            next DYNAMICFIELD;
        }

        # include process id suffix into dynamic field configs
        $DynamicFieldConfig->{Name} .= $Self->{IDSuffix};
        $DynamicFieldConfig->{ProcessSuffix} = $Self->{IDSuffix};

        # Get DynamicField Values
        $GetParam{ 'DynamicField_' . $DynamicFieldName } = $DynamicFieldBackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
        );

        # ACLCompat
        $GetParam{DynamicField}{ 'DynamicField_' . $DynamicFieldName } = $GetParam{ 'DynamicField_' . $DynamicFieldName };
    }

    return \%GetParam;
}

sub _OutputActivityDialog {
    my ( $Self, %Param ) = @_;
    my $TicketID               = $Param{GetParam}{TicketID};
    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};

    # get necessary objects
    # CustomerTicketProcess gets only called by CustomerTicketZoom and returns its HTML to there
    # for HTML generation a separate LayoutObject is created; all JS-stuff has to be done with the one of CustomerTicketZoom (e.g. in dynamic fields)
    my $LayoutObjectZoom          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LayoutObject              = $Kernel::OM->Create('Kernel::Output::HTML::Layout');
    my $FieldRestrictionsObject   = $Kernel::OM->Get('Kernel::System::Ticket::FieldRestrictions');
    my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # Check needed parameters:
    # ProcessEntityID only
    # TicketID ActivityDialogEntityID
    if ( !$Param{ProcessEntityID} || ( !$TicketID && !$ActivityDialogEntityID ) ) {
        my $Message = Translatable('Got no ProcessEntityID or TicketID and ActivityDialogEntityID!');

        # does not show header and footer again
        if ( $Self->{IsMainWindow} ) {
            return $LayoutObject->CustomerError(
                Message => $Message,
            );
        }

        $LayoutObject->CustomerFatalError(
            Message => $Message,
        );
    }

    my $ActivityActivityDialog;
    my %Ticket;
    my %Error         = ();
    my %ErrorMessages = ();

    # If we had Errors, we got an Errorhash
    %Error         = %{ $Param{Error} }         if ( IsHashRefWithData( $Param{Error} ) );
    %ErrorMessages = %{ $Param{ErrorMessages} } if ( IsHashRefWithData( $Param{ErrorMessages} ) );

    # get needed objects
    my $ActivityObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity');
    my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');
    my $ProcessObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process');
    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');

    if ( !$TicketID ) {
        $ActivityActivityDialog = $ProcessObject->ProcessStartpointGet(
            ProcessEntityID => $Param{ProcessEntityID},
        );

        if ( !IsHashRefWithData($ActivityActivityDialog) ) {
            my $Message = $LayoutObject->{LanguageObject}->Translate(
                'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!',
                $Param{ProcessEntityID},
            );

            # does not show header and footer again
            if ( $Self->{IsMainWindow} ) {
                return $LayoutObject->CustomerError(
                    Message => $Message,
                );
            }

            $LayoutObject->CustomerFatalError(
                Message => $Message,
            );
        }
    }
    else {

        # no AJAX update in this part
        %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            UserID        => $ConfigObject->Get('CustomerPanelUserID'),
            DynamicFields => 1,
        );

        if ( !IsHashRefWithData( \%Ticket ) ) {
            $LayoutObject->CustomerFatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Can\'t get Ticket "%s"!', $Param{TicketID} ),
            );
        }

        my $DynamicFieldProcessID = 'DynamicField_'
            . $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID');
        my $DynamicFieldActivityID = 'DynamicField_'
            . $ConfigObject->Get('Process::DynamicFieldProcessManagementActivityID');

        if ( !$Ticket{$DynamicFieldProcessID} || !$Ticket{$DynamicFieldActivityID} ) {
            $LayoutObject->CustomerFatalError(
                Message =>
                    $LayoutObject->{LanguageObject}->Translate( 'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!', $Param{TicketID} ),
            );
        }

        $ActivityActivityDialog = {
            Activity       => $Ticket{$DynamicFieldActivityID},
            ActivityDialog => $ActivityDialogEntityID,
        };
    }

    my $Activity = $ActivityObject->ActivityGet(
        Interface        => 'CustomerInterface',
        ActivityEntityID => $ActivityActivityDialog->{Activity}
    );
    if ( !$Activity ) {
        my $Message = $LayoutObject->{LanguageObject}->Translate(
            'Can\'t get Activity configuration for ActivityEntityID "%s"!',
            $ActivityActivityDialog->{Activity},
        );

        # does not show header and footer again
        if ( $Self->{IsMainWindow} ) {
            return $LayoutObject->CustomerError(
                Message => $Message,
            );
        }

        $LayoutObject->CustomerFatalError(
            Message => $Message,
        );
    }

    my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityActivityDialog->{ActivityDialog},
        Interface              => 'CustomerInterface',
    );
    if ( !IsHashRefWithData($ActivityDialog) ) {
        my $Message = $LayoutObject->{LanguageObject}->Translate(
            'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!',
            $ActivityActivityDialog->{ActivityDialog},
        );

        # does not show header and footer again
        if ( $Self->{IsMainWindow} ) {
            return $LayoutObject->CustomerError(
                Message => $Message,
            );
        }

        $LayoutObject->CustomerFatalError(
            Message => $Message,
        );
    }

    # grep out Overwrites if defined on the Activity
    my @OverwriteActivityDialogNumber = grep {
        ref $Activity->{ActivityDialog}{$_} eq 'HASH'
            && $Activity->{ActivityDialog}{$_}{ActivityDialogEntityID}
            && $Activity->{ActivityDialog}{$_}{ActivityDialogEntityID} eq
            $ActivityActivityDialog->{ActivityDialog}
            && IsHashRefWithData( $Activity->{ActivityDialog}{$_}{Overwrite} )
    } keys %{ $Activity->{ActivityDialog} };

    # let the Overwrites Overwrite the ActivityDialog's Hash values
    if ( $OverwriteActivityDialogNumber[0] ) {
        %{$ActivityDialog} = (
            %{$ActivityDialog},
            %{ $Activity->{ActivityDialog}{ $OverwriteActivityDialogNumber[0] }{Overwrite} }
        );
    }

    # Add PageHeader, Navbar, Formheader (Process/ActivityDialogHeader)
    my $Output;
    my $MainBoxClass;

    $LayoutObject->Block(
        Name => 'Header',
        Data => {
            Name =>
                $LayoutObject->{LanguageObject}->Translate( $ActivityDialog->{Name} )
                || '',
        },
    );

    # show descriptions
    if ( $ActivityDialog->{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => 'DescriptionShort',
            Data => {
                DescriptionShort
                    => $LayoutObject->{LanguageObject}->Translate(
                        $ActivityDialog->{DescriptionShort},
                    ),
            },
        );
    }
    if ( $ActivityDialog->{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'DescriptionLong',
            Data => {
                DescriptionLong
                    => $LayoutObject->{LanguageObject}->Translate(
                        $ActivityDialog->{DescriptionLong},
                    ),
            },
        );
    }
    if ( $Param{RenderLocked} ) {
        $LayoutObject->Block(
            Name => 'PropertiesLock',
            Data => {
                %Param,
                TicketID => $TicketID,
            },
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'CancelLink',
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'ProcessManagement/CustomerActivityDialogHeader',
        Data         => {
            FormName               => 'ActivityDialogDialog' . $ActivityActivityDialog->{ActivityDialog},
            FormID                 => $Self->{FormID},
            Subaction              => 'StoreActivityDialog',
            TicketID               => $Ticket{TicketID} || '',
            ActivityDialogEntityID => $ActivityActivityDialog->{ActivityDialog},
            ProcessEntityID        => $Param{ProcessEntityID}
                || $Ticket{
                    'DynamicField_'
                    . $ConfigObject->Get(
                        'Process::DynamicFieldProcessManagementProcessID'
                    )
                },
            IsMainWindow => $Self->{IsMainWindow},
            MainBoxClass => $MainBoxClass || '',
        },
    );

    my %RenderedFields = ();

    my $InputDefinitionRendered = 0;
    my %DFPossibleValues        = %{ $Param{DFPossibleValues} // {} };
    my %Visibility              = %{ $Param{Visibility}       // {} };

    # if we are rendering a new mask and are not rerendering with errors get ticket and default dynamic field values
    if ( $Self->{Subaction} ne 'StoreActivityDialog' ) {

        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        my $NewTicket;

        # we are updating an existing ticket
        if (%Ticket) {

            DYNAMICFIELD:
            for my $Name ( keys $Self->{DynamicField}->%* ) {
                $Param{GetParam}{ 'DynamicField_' . $Name } = $Ticket{ 'DynamicField_' . $Name };
            }
        }

        else {
            $NewTicket = 1;
        }

        # fill empty values with defaults if applicable and prepare ACLCompat
        DYNAMICFIELD:
        for my $Name ( keys $Self->{DynamicField}->%* ) {
            if ( !defined $Param{GetParam}{ 'DynamicField_' . $Name } ) {
                my $DialogDefaultValue = $ActivityDialog->{Fields}{ 'DynamicField_' . $Name }{DefaultValue};

                if ($DialogDefaultValue) {
                    $Param{GetParam}{ 'DynamicField_' . $Name } = $DialogDefaultValue;
                }
                elsif ($NewTicket) {
                    $Param{GetParam}{ 'DynamicField_' . $Name } = $Self->{DynamicField}{$Name}{Config}{DefaultValue};
                }
            }

            $Param{GetParam}{DynamicField}{ 'DynamicField_' . $Name } = $Param{GetParam}{ 'DynamicField_' . $Name };
        }

        # retrieve field restrictions for dynamic fields
        my $FieldRestrictionsObject = $Kernel::OM->Get('Kernel::System::Ticket::FieldRestrictions');
        my $ACLPreselection;
        if ( $ConfigObject->Get('TicketACL::ACLPreselection') ) {

            # get cached preselection rules
            my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
            $ACLPreselection = $CacheObject->Get(
                Type => 'TicketACL',
                Key  => 'Preselection',
            );
            if ( !$ACLPreselection ) {
                $ACLPreselection = $FieldRestrictionsObject->SetACLPreselectionCache();
            }
        }

        my $Autoselect     = $ConfigObject->Get('TicketACL::Autoselect') || undef;
        my $LoopProtection = 100;

        # build hash of field configs without suffix attached to name
        my %FieldConfigsPlain = map { $_ => { $Self->{DynamicField}{$_}->%*, Name => $_ } } keys $Self->{DynamicField}->%*;

        # get values and visibility of dynamic fields
        my %DynFieldStates = $FieldRestrictionsObject->GetFieldStates(
            TicketObject              => $TicketObject,
            DynamicFields             => \%FieldConfigsPlain,
            DynamicFieldBackendObject => $DynamicFieldBackendObject,
            Action                    => $Self->{Action},
            ChangedElements           => {},
            TicketID                  => $Param{TicketID},
            FormID                    => $Self->{FormID},
            CustomerUser              => $Self->{UserID},
            GetParam                  => $Param{GetParam},
            Autoselect                => $Autoselect,
            ACLPreselection           => $ACLPreselection // '',
            LoopProtection            => \$LoopProtection,
            InitialRun                => 1,
        );

        %DFPossibleValues = map { $_ => $DynFieldStates{Fields}{PossibleValues} } keys $Self->{DynamicField}->%*;
        %Visibility       = $DynFieldStates{Visibility}->%*;
    }

    # Parse definition if present
    my $InputFieldDefinition = $Kernel::OM->Get('Kernel::System::YAML')->Load(
        Data => $ActivityDialog->{InputFieldDefinition},
    );
    my %DefinedFieldsList;
    if ( IsArrayRefWithData($InputFieldDefinition) ) {
        for my $Row ( $InputFieldDefinition->@* ) {
            if ( $Row->{DF} ) {
                $DefinedFieldsList{ 'DynamicField_' . $Row->{DF} } = 1;
            }
            if ( $Row->{Grid} ) {
                for my $GridRow ( $Row->{Grid}{Rows}->@* ) {
                    for my $Field ( grep { $_->{DF} } $GridRow->@* ) {
                        $DefinedFieldsList{ 'DynamicField_' . $Field->{DF} } = 1;
                    }
                }
            }
        }
    }

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    my %DynamicFieldValues = map { ( 'DynamicField_' . $_ => $Param{GetParam}->{ 'DynamicField_' . $_ } ) } keys $Self->{DynamicField}->%*;

    # Loop through ActivityDialogFields and render their output
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        if ( !IsHashRefWithData( $ActivityDialog->{Fields}{$CurrentField} ) ) {
            my $Message = $LayoutObject->{LanguageObject}->Translate(
                'Can\'t get data for Field "%s" of ActivityDialog "%s"!',
                $CurrentField, $ActivityActivityDialog->{ActivityDialog}
            );

            # does not show header and footer again
            if ( $Self->{IsMainWindow} ) {
                return $LayoutObject->CustomerError(
                    Message => $Message,
                );
            }

            $LayoutObject->CustomerFatalError(
                Message => $Message,
            );
        }

        next DIALOGFIELD if $RenderedFields{$CurrentField};

        my %FieldData = %{ $ActivityDialog->{Fields}{$CurrentField} };

        # We render just visible ActivityDialogFields
        next DIALOGFIELD if !$FieldData{Display};

        # Handle multicolumn field rendering
        if ( $DefinedFieldsList{$CurrentField} ) {
            $RenderedFields{$CurrentField} = 1;

            next DIALOGFIELD if $InputDefinitionRendered;

            $Output .= $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
                Content              => $InputFieldDefinition,
                DynamicFields        => $Self->{DynamicField},
                LayoutObject         => $LayoutObjectZoom,
                ParamObject          => $Kernel::OM->Get('Kernel::System::Web::Request'),
                DynamicFieldValues   => \%DynamicFieldValues,
                PossibleValuesFilter => \%DFPossibleValues,
                Errors               => $Param{DFErrors},
                Visibility           => \%Visibility,
                CustomerInterface    => 1,
                Object               => {
                    CustomerID     => $Self->{UserCustomerID},
                    CustomerUserID => $Self->{UserID},
                    %DynamicFieldValues,
                },
            );
            $InputDefinitionRendered = 1;

            next DIALOGFIELD;
        }

        # render DynamicFields
        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;
            my $Response         = $Self->_RenderDynamicField(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $DynamicFieldName,
                Value               => $Param{GetParam}{ 'DynamicField_' . $DynamicFieldName },
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket        || {},
                Error               => \%Error         || {},
                ErrorMessages       => \%ErrorMessages || {},
                FormID              => $Self->{FormID},
                PossibleValues      => $DFPossibleValues{ 'DynamicField_' . $DynamicFieldName },
                Visibility          => $Visibility{ 'DynamicField_' . $DynamicFieldName } // 0,
                LayoutObject        => $LayoutObject,
                Object              => {
                    CustomerID     => $Self->{UserCustomerID},
                    CustomerUserID => $Self->{UserID},
                    %DynamicFieldValues,
                },
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;

        }

        # render State
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'StateID' )
        {

            # We don't render Fields twice,
            # if there was already a Config without ID, skip this field
            # next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderState(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Queue
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'QueueID' )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderQueue(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Priority
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'PriorityID' )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderPriority(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Service
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'ServiceID' ) {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderService(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;
        }

        # render SLA
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'SLAID' ) {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderSLA(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Title
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'Title' ) {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderTitle(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;
        }

        # render Article
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'Article' ) {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderArticle(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;
        }

        # render Type
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'TypeID' ) {

            # We don't render Fields twice,
            # if there was already a Config without ID, skip this field
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderType(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error  || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                LayoutObject        => $LayoutObject,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }
    }

    # set submit button data
    my $ButtonText  = 'Submit';
    my $ButtonTitle = 'Save';
    my $ButtonID    = 'Submit' . $ActivityActivityDialog->{ActivityDialog};
    if ( $ActivityDialog->{SubmitButtonText} ) {
        $ButtonText  = $ActivityDialog->{SubmitButtonText};
        $ButtonTitle = $ActivityDialog->{SubmitButtonText};
    }

    $LayoutObject->Block(
        Name => 'Footer',
        Data => {
            ButtonText  => $ButtonText,
            ButtonTitle => $ButtonTitle,
            ButtonID    => $ButtonID
        },
    );

    if ( $ActivityDialog->{SubmitAdviceText} ) {
        $LayoutObject->Block(
            Name => 'SubmitAdviceText',
            Data => {
                AdviceText => $ActivityDialog->{SubmitAdviceText},
            },
        );
    }

    # Add the FormFooter
    $Output .= $LayoutObject->Output(
        TemplateFile => 'ProcessManagement/CustomerActivityDialogFooter',
        Data         => {},
    );

    return $Output;
}

sub _RenderDynamicField {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $LayoutObject              = $Param{LayoutObject};
    my $LayoutObjectZoom          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    for my $Needed (qw(FormID FieldName)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderDynamicField' ),
            };
        }
    }

    my $DynamicFieldConfig = $Self->{DynamicField}{ $Param{FieldName} };

    if ( !IsHashRefWithData($DynamicFieldConfig) ) {

        my $Message = "DynamicFieldConfig missing for field: $Param{FieldName}, or is not a Ticket Dynamic Field!";

        # log error but does not stop the execution as it could be an old Article
        # DynamicField, see bug#11666
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );

        return {
            Success => 1,
            HTML    => '',
        };
    }

    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) ) {
        if (
            defined $Param{Error}->{ $Param{FieldName} }
            && $Param{Error}->{ $Param{FieldName} } ne ''
            )
        {
            $ServerError = 1;
        }
    }

    my $ErrorMessage = '';
    if ( IsHashRefWithData( $Param{ErrorMessages} ) ) {
        if (
            defined $Param{ErrorMessages}->{ $Param{FieldName} }
            && $Param{ErrorMessages}->{ $Param{FieldName} } ne ''
            )
        {
            $ErrorMessage = $Param{ErrorMessages}->{ $Param{FieldName} };
        }
    }

    my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,
        PossibleValuesFilter => $Param{PossibleValues},
        Value                => $Param{Value},
        LayoutObject         => $LayoutObjectZoom,
        ParamObject          => $Kernel::OM->Get('Kernel::System::Web::Request'),
        AJAXUpdate           => 1,
        Mandatory            => $Param{ActivityDialogField}->{Display} == 2,
        ACLHidden            => ( $Param{ActivityDialogField}->{Display} == 2 && !$Param{Visibility} ),
        ServerError          => $ServerError,
        ErrorMessage         => $ErrorMessage,
        CustomerInterface    => 1,
        Object               => $Param{Object},
    );

    my %Data = (
        Name        => $DynamicFieldConfig->{Name},
        Label       => $DynamicFieldHTML->{Label},
        HiddenClass => !$Param{Visibility} ? ' oooACLHidden' : '',
    );

    # handle multivalue field
    if ( $DynamicFieldHTML->{MultiValue} ) {

        $LayoutObject->Block(
            Name => 'Row_DynamicField',
            Data => {
                TemplateColumns => '1fr',
                RowClasses      => ' MultiValue',
                HiddenClass     => !$Param{Visibility} ? ' oooACLHidden' : '',
            },
        );

        # Create one block for each multivalue item
        for my $MultiValueIndex ( 0 .. $#{ $DynamicFieldHTML->{MultiValue} } ) {

            $Data{Content} = $DynamicFieldHTML->{MultiValue}[$MultiValueIndex];
            $LayoutObject->Block(
                Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:DynamicField',
                Data => {
                    %Data,
                    MultiValue => 1,

                    # TODO ask about this
                    # RowReadOnly   => $DynamicFieldConfig->{Readonly},
                    ColumnClasses => ' MultiValue_' . $MultiValueIndex,
                    ColumnStyle   => 'grid-column: 1 / span 1',
                },
            );

            # render short description once for first element
            if ( !$MultiValueIndex ) {
                if ( $Param{DescriptionLong} ) {
                    $LayoutObject->Block(
                        Name => 'rw:DynamicField:DescriptionLong',
                        Data => {
                            DescriptionLong => $Param{DescriptionLong},
                        },
                    );
                }
            }

            # render long description once for last element
            if ( $MultiValueIndex == $#{ $DynamicFieldHTML->{MultiValue} } ) {
                if ( $Param{DescriptionShort} ) {
                    $LayoutObject->Block(
                        Name => $Param{ActivityDialogField}->{LayoutBlock}
                            || 'rw:DynamicField:DescriptionShort',
                        Data => {
                            DescriptionShort => $Param{DescriptionShort},
                        },
                    );
                }
            }
        }

        $LayoutObject->Block(
            Name => 'DynamicFieldMultiValueTemplate',
            Data => {
                Content     => $DynamicFieldHTML->{MultiValueTemplate},
                Label       => $DynamicFieldHTML->{Label},
                ColumnStyle => 'grid-column: 1 / span 1',
            },
        );

        # render short description once for first element
        if ( $Param{DescriptionLong} ) {
            $LayoutObject->Block(
                Name => 'rw:DynamicField:DescriptionLongTemplate',
                Data => {
                    DescriptionLong => $Param{DescriptionLong},
                },
            );
        }
    }
    else {
        $Data{Content} = $DynamicFieldHTML->{Field};

        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:DynamicField',
            Data => \%Data,
        );

        if ( $Param{DescriptionShort} ) {
            $LayoutObject->Block(
                Name => $Param{ActivityDialogField}->{LayoutBlock}
                    || 'rw:DynamicField:DescriptionShort',
                Data => {
                    DescriptionShort => $Param{DescriptionShort},
                },
            );
        }

        if ( $Param{DescriptionLong} ) {
            $LayoutObject->Block(
                Name => 'rw:DynamicField:DescriptionLong',
                Data => {
                    DescriptionLong => $Param{DescriptionLong},
                },
            );
        }
    }

    my $TemplateFile = 'ProcessManagement/' . ( $DynamicFieldConfig->{Config}{MultiValue} ? 'CustomerRowDynamicField' : 'CustomerDynamicField' );

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => $TemplateFile ),
    };
}

sub _RenderTitle {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Param{LayoutObject};

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderTitle' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderTitle' ),
        };
    }

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Title"),
        FieldID          => 'Title',
        FormID           => $Param{FormID},
        Value            => $Param{GetParam}{Title},
        Name             => 'Title',
        MandatoryClass   => '',
        ValidateRequired => '',
        IDSuffix         => $Self->{IDSuffix} || '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'Title'} ) {
        $Data{ServerError} = 'ServerError';
    }

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerTitle' ),
    };

}

sub _RenderArticle {
    my ( $Self, %Param ) = @_;

    # get layout objects
    my $LayoutObject     = $Param{LayoutObject};
    my $LayoutObjectZoom = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Needed (qw(FormID Ticket)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderArticle' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderArticle' ),
        };
    }

    # get all attachments meta data
    my @Attachments = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # show attachments
    ATTACHMENT:
    for my $Attachment (@Attachments) {
        if (
            $Attachment->{ContentID}
            && $LayoutObjectZoom->{BrowserRichText}
            && ( $Attachment->{ContentType} =~ /image/i )
            && ( $Attachment->{Disposition} eq 'inline' )
            )
        {
            next ATTACHMENT;
        }

        push @{ $Param{AttachmentList} }, $Attachment;
    }

    my %Data = (
        Name             => 'Article',
        MandatoryClass   => '',
        ValidateRequired => '',
        Subject          => $Param{GetParam}{Subject},
        Body             => $Param{GetParam}{Body},
        LabelSubject     => $Param{ActivityDialogField}->{Config}->{LabelSubject}
            || $LayoutObject->{LanguageObject}->Translate("Subject"),
        LabelBody => $Param{ActivityDialogField}->{Config}->{LabelBody}
            || $LayoutObject->{LanguageObject}->Translate("Text"),
        AttachmentList => $Param{AttachmentList},
        IDSuffix       => $Self->{IDSuffix} || '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ArticleSubject'} ) {
        $Data{SubjectServerError} = 'ServerError';
    }
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ArticleBody'} ) {
        $Data{BodyServerError} = 'ServerError';
    }

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Article',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpanSubject',
            Data => {},
        );
        $LayoutObject->Block(
            Name => 'LabelSpanBody',
            Data => {},
        );
    }

    # add rich text editor
    if ( $LayoutObjectZoom->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

        # set up customer rich text editor
        $LayoutObjectZoom->CustomerSetRichTextParameters(
            Data => \%Param,
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => 'rw:Article:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Article:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerArticle' ),
    };
}

sub _RenderSLA {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Param{LayoutObject};

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderSLA' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderSLA' ),
        };
    }

    my $Services = $Self->_GetServices(
        %{ $Param{GetParam} },
    );

    my $SLAs = $Self->_GetSLAs(
        %{ $Param{GetParam} },
        Services => $Services,
    );

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("SLA"),
        FieldID          => 'SLAID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
        IDSuffix         => $Self->{IDSuffix},
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get SLA object
    my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

    my $SLAIDParam = $Param{GetParam}{SLAID};
    if ($SLAIDParam) {
        $SelectedValue = $SLAObject->SLALookup( SLAID => $SLAIDParam );
    }

    if ( $Param{FieldName} eq 'SLA' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $SLAObject->SLALookup(
                    SLA => $Param{ActivityDialogField}->{DefaultValue},
                );
            }

            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $SLAObject->SLALookup(
                    SLA => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{SLA};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'SLAID'} ) {
        $ServerError = 'ServerError';
    }

    # build SLA string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $SLAs,
        Name          => 'SLAID',
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        Sort          => 'AlphanumericValue',
        Translation   => 1,
        Class         => "Modernize FormUpdate $ServerError",
        Max           => 200,
    );

    # extend IDs to enable simultaneous activities
    $Data{Content} =~ s/id="([\w\s_]+)"/id="$1$Self->{IDSuffix}"/;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:SLA',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:SLA:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:SLA:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerSLA' ),
    };
}

sub _RenderService {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Param{LayoutObject};

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderService' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderService' ),
        };
    }

    my $Services = $Self->_GetServices(
        %{ $Param{GetParam} },
    );

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Service"),
        FieldID          => 'ServiceID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
        IDSuffix         => $Self->{IDSuffix},
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get service object
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    my $ServiceIDParam = $Param{GetParam}{ServiceID};
    if ($ServiceIDParam) {
        $SelectedValue = $ServiceObject->ServiceLookup(
            ServiceID => $ServiceIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Service' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $ServiceObject->ServiceLookup(
                    Name => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $ServiceObject->ServiceLookup(
                    Service => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Service};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ServiceID'} ) {
        $ServerError = 'ServerError';
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build Service string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Services,
        Name          => 'ServiceID',
        Class         => "Modernize FormUpdate $ServerError",
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        TreeView      => $TreeView,
        Sort          => 'TreeView',
        Translation   => $TreeView,
        Max           => 200,
    );

    # extend IDs to enable simultaneous activities
    $Data{Content} =~ s/id="([\w\s_]+)"/id="$1$Self->{IDSuffix}"/;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Service',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Service:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Service:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerService' ),
    };

}

sub _RenderPriority {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Param{LayoutObject};

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderPriority' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderPriority' ),
        };
    }

    my $Priorities = $Self->_GetPriorities(
        %{ $Param{GetParam} },
    );

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Priority"),
        FieldID          => 'PriorityID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
        IDSuffix         => $Self->{IDSuffix},
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get priority object
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    my $PriorityIDParam = $Param{GetParam}{PriorityID};
    if ($PriorityIDParam) {
        $SelectedValue = $PriorityObject->PriorityLookup(
            PriorityID => $PriorityIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Priority' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $PriorityObject->PriorityLookup(
                Priority => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            $SelectedValue = $PriorityObject->PriorityLookup(
                PriorityID => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Priority};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'PriorityID'} ) {
        $ServerError = 'ServerError';
    }

    # build next Priorities string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Priorities,
        Name          => 'PriorityID',
        Translation   => 1,
        SelectedValue => $SelectedValue,
        Class         => "Modernize FormUpdate $ServerError",
    );

    # extend IDs to enable simultaneous activities
    $Data{Content} =~ s/id="([\w\s_]+)"/id="$1$Self->{IDSuffix}"/;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Priority',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Priority:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Priority:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerPriority' ),
    };
}

sub _RenderQueue {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Param{LayoutObject};

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderQueue' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderQueue' ),
        };
    }

    my $Queues = $Self->_GetQueues(
        %{ $Param{GetParam} },
    );

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("To queue"),
        FieldID          => 'QueueID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
        IDSuffix         => $Self->{IDSuffix},
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }
    my $SelectedValue;

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # if we got QueueID as Param from the GUI
    my $QueueIDParam = $Param{GetParam}{QueueID};
    if ($QueueIDParam) {
        $SelectedValue = $QueueObject->QueueLookup(
            QueueID => $QueueIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Queue' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $QueueObject->QueueLookup(
                Queue => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            $SelectedValue = $QueueObject->QueueLookup(
                QueueID => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Queue};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'QueueID'} ) {
        $ServerError = 'ServerError';
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build next queues string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Queues,
        Name          => 'QueueID',
        Translation   => $TreeView,
        SelectedValue => $SelectedValue,
        Class         => "Modernize FormUpdate $ServerError",
        TreeView      => $TreeView,
        Sort          => 'TreeView',
        PossibleNone  => 1,
    );

    # extend IDs to enable simultaneous activities
    $Data{Content} =~ s/id="([\w\s_]+)"/id="$1$Self->{IDSuffix}"/;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Queue',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Queue:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Queue:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerQueue' ),
    };
}

sub _RenderState {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Param{LayoutObject};

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderState' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderState' ),
        };
    }

    my $States = $Self->_GetStates( %{ $Param{Ticket} } );

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Next ticket state"),
        FieldID          => 'StateID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
        IDSuffix         => $Self->{IDSuffix},
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }
    my $SelectedValue;

    # get state object
    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    my $StateIDParam = $Param{GetParam}{StateID};
    if ($StateIDParam) {
        $SelectedValue = $StateObject->StateLookup( StateID => $StateIDParam );
    }

    if ( $Param{FieldName} eq 'State' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $StateObject->StateLookup(
                State => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            $SelectedValue = $StateObject->StateLookup(
                StateID => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{State};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'StateID'} ) {
        $ServerError = 'ServerError';
    }

    # build next states string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $States,
        Name          => 'StateID',
        Translation   => 1,
        SelectedValue => $SelectedValue,
        Class         => "Modernize FormUpdate $ServerError",
    );

    # extend IDs to enable simultaneous activities
    $Data{Content} =~ s/id="([\w\s_]+)"/id="$1$Self->{IDSuffix}"/;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:State',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:State:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:State:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerState' ),
    };
}

sub _RenderType {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Param{LayoutObject};

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', $Needed, '_RenderType' ),
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => $LayoutObject->{LanguageObject}->Translate( 'Parameter %s is missing in %s.', 'ActivityDialogField', '_RenderType' ),
        };
    }

    my $Types = $Self->_GetTypes(
        %{ $Param{GetParam} },
    );

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Type"),
        FieldID          => 'TypeID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
        IDSuffix         => $Self->{IDSuffix},
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get type object
    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

    my $TypeIDParam = $Param{GetParam}{TypeID};
    if ($TypeIDParam) {
        $SelectedValue = $TypeObject->TypeLookup(
            TypeID => $TypeIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Type' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $TypeObject->TypeLookup(
                    Type => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $TypeObject->TypeLookup(
                    Type => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Type};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'TypeID'} ) {
        $ServerError = 'ServerError';
    }

    # build Service string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Types,
        Name          => 'TypeID',
        Class         => "Modernize FormUpdate $ServerError",
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        Sort          => 'AlphanumericValue',
        Translation   => 1,
        Max           => 200,
    );

    # extend IDs to enable simultaneous activities
    $Data{Content} =~ s/id="([\w\s_]+)"/id="$1$Self->{IDSuffix}"/;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Type',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Type:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Type:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/CustomerType' ),
    };
}

sub _StoreActivityDialog {
    my ( $Self, %Param ) = @_;

    my $TicketID = $Param{GetParam}->{TicketID};
    my %Ticket;
    my $ProcessEntityID;
    my $ActivityEntityID;
    my %Error;
    my %ErrorMessages;

    my %TicketParam;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ActivityDialogEntityID = $Param{GetParam}->{ActivityDialogEntityID};
    if ( !$ActivityDialogEntityID ) {
        $LayoutObject->CustomerFatalError(
            Message => Translatable('ActivityDialogEntityID missing!'),
        );
    }

    # get activity dialog object
    my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');
    my $ActivityDialog       = $ActivityDialogObject->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
    );

    if ( !IsHashRefWithData($ActivityDialog) ) {
        $LayoutObject->CustomerFatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Couldn\'t get Config for ActivityDialogEntityID "%s"!', $ActivityDialogEntityID ),
        );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get upload cache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    # check each Field of an Activity Dialog and fill the error hash if something goes horribly wrong
    my %CheckedFields;
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        # handle dynamic fields separately
        next DIALOGFIELD if $CurrentField =~ m{^DynamicField_(.*)}xms;

        if (
            $Self->{NameToID}->{$CurrentField} eq 'CustomerID'
            || $Self->{NameToID}->{$CurrentField} eq 'CustomerUserID'
            )
        {

            next DIALOGFIELD if $CheckedFields{ $Self->{NameToID}->{'CustomerID'} };

            my $CustomerID = $Param{GetParam}->{CustomerID} || $Self->{UserCustomerID};
            if ( !$CustomerID ) {
                $Error{'CustomerID'} = 1;
            }
            $TicketParam{CustomerID} = $CustomerID;

            # Unfortunately TicketCreate needs 'CustomerUser' as param instead of 'CustomerUserID'
            my $CustomerUserID = $ParamObject->GetParam( Param => 'SelectedCustomerUser' )
                || $Self->{UserID};
            if ( !$CustomerUserID ) {
                $CustomerUserID = $ParamObject->GetParam( Param => 'SelectedUserID' );
            }
            if ( !$CustomerUserID ) {
                $Error{'CustomerUserID'} = 1;
            }
            else {
                $TicketParam{CustomerUser} = $CustomerUserID;
            }
            $CheckedFields{ $Self->{NameToID}->{'CustomerID'} }     = 1;
            $CheckedFields{ $Self->{NameToID}->{'CustomerUserID'} } = 1;

        }
        else {

            # skip if we've already checked ID or Name
            next DIALOGFIELD if $CheckedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Result = $Self->_CheckField(
                Field => $Self->{NameToID}->{$CurrentField},
                %{ $ActivityDialog->{Fields}->{$CurrentField} },
            );

            if ( !$Result ) {

                # special case for Article (Subject & Body)
                if ( $CurrentField eq 'Article' ) {
                    for my $ArticlePart (qw(Subject Body)) {
                        if ( !$Param{GetParam}->{$ArticlePart} ) {

                            # set error for each part (if any)
                            $Error{ 'Article' . $ArticlePart } = 1;
                        }
                    }
                }

                # all other fields
                elsif ( $ActivityDialog->{Fields}->{$CurrentField}->{Display} == 2 ) {
                    $Error{ $Self->{NameToID}->{$CurrentField} } = 1;
                }
            }
            else {
                $TicketParam{ $Self->{NameToID}->{$CurrentField} } = $Result;
            }
            $CheckedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }
    }

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # skip validation of hidden fields
    my %Visibility;

    # transform dynamic field data into DFName => DFName pair
    my %DynamicFieldAcl = map { $_ => $_ } keys $Self->{DynamicField}->%*;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # call ticket ACLs for DynamicFields to check field visibility
    my $ACLResult = $TicketObject->TicketAcl(
        $Param{GetParam}->%*,
        Action         => $Self->{Action},
        ReturnType     => 'Form',
        ReturnSubType  => '-',
        Data           => \%DynamicFieldAcl,
        CustomerUserID => $Self->{UserID},
    );
    if ($ACLResult) {
        %Visibility = map { 'DynamicField_' . $_ => 0 } keys $Self->{DynamicField}->%*;
        my %AclData = $TicketObject->TicketAclData();
        for my $Field ( sort keys %AclData ) {
            $Visibility{ 'DynamicField_' . $Field } = 1;
        }
    }
    else {
        %Visibility = map { 'DynamicField_' . $_ => 1 } keys $Self->{DynamicField}->%*;
    }

    my %DynamicFieldValidationResult;
    my %DynamicFieldPossibleValues;

    DYNAMICFIELD:
    for my $DynamicFieldName ( keys $Self->{DynamicField}->%* ) {

        # Get the Config of the current DynamicField (the first element of the grep result array)
        my $DynamicFieldConfig = $Self->{DynamicField}{$DynamicFieldName};

        if ( !IsHashRefWithData($DynamicFieldConfig) ) {

            my $Message = "DynamicFieldConfig missing for field: $Param{FieldName}, or is not a Ticket Dynamic Field!";

            # log error but does not stop the execution as it could be an old Article
            # DynamicField, see bug#11666
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Message,
            );

            next DYNAMICFIELD;
        }

        # Will be extended later on for ACL Checking:
        my $PossibleValuesFilter;

        my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );

        if ($IsACLReducible) {

            # get PossibleValues
            my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData($PossibleValues) ) {

                # convert possible values key => value to key => key for ACLs using a Hash slice
                my %AclData = %{$PossibleValues};
                @AclData{ keys %AclData } = keys %AclData;

                # set possible values filter from ACLs
                my $ACL = $TicketObject->TicketAcl(
                    $Param{GetParam}->%*,
                    Action         => $Self->{Action},
                    ReturnType     => 'Ticket',
                    ReturnSubType  => 'DynamicField_' . $DynamicFieldName,
                    Data           => \%AclData,
                    CustomerUserID => $Self->{UserID},
                );
                if ($ACL) {
                    my %Filter = $TicketObject->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                        keys %Filter;
                }
                else {
                    $PossibleValuesFilter = $PossibleValues;
                }
            }
        }

        $DynamicFieldPossibleValues{ 'DynamicField_' . $DynamicFieldName } = $PossibleValuesFilter;

        # if we have an invisible field, use config's default value
        if ( $ActivityDialog->{Fields}->{ 'DynamicField_' . $DynamicFieldName } && $ActivityDialog->{Fields}->{ 'DynamicField_' . $DynamicFieldName }->{Display} == 0 )
        {
            if (
                defined $ActivityDialog->{Fields}->{ 'DynamicField_' . $DynamicFieldName }->{DefaultValue}
                && length $ActivityDialog->{Fields}->{ 'DynamicField_' . $DynamicFieldName }->{DefaultValue}
                )
            {
                $TicketParam{ 'DynamicField_' . $DynamicFieldName } = $ActivityDialog->{Fields}->{ 'DynamicField_' . $DynamicFieldName }->{DefaultValue};
            }
            else {
                $TicketParam{ 'DynamicField_' . $DynamicFieldName } = '';
            }
        }

        # skip fields which are hidden by ACLs
        elsif ( !$Visibility{ 'DynamicField_' . $DynamicFieldName } ) {
            next DYNAMICFIELD;
        }

        # only validate visible fields
        else {
            my $Mandatory = $ActivityDialog->{Fields}->{ 'DynamicField_' . $DynamicFieldName }
                ? ( $ActivityDialog->{Fields}->{ 'DynamicField_' . $DynamicFieldName }->{Display} == 2 )
                : $DynamicFieldConfig->{Mandatory};

            # Check DynamicField Values
            my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                ParamObject          => $ParamObject,
                Mandatory            => $Mandatory,
            );

            if ( !IsHashRefWithData($ValidationResult) ) {
                $LayoutObject->CustomerFatalError(
                    Message =>
                        $LayoutObject->{LanguageObject}->Translate(
                            'Could not perform validation on field %s!', $DynamicFieldConfig->{Label}
                        ),
                );
            }

            if ( $ValidationResult->{ServerError} ) {
                $Error{ $DynamicFieldConfig->{Name} }                        = 1;
                $ErrorMessages{ $DynamicFieldConfig->{Name} }                = $ValidationResult->{ErrorMessage};
                $DynamicFieldValidationResult{ $DynamicFieldConfig->{Name} } = $ValidationResult;
            }

            $TicketParam{ 'DynamicField_' . $DynamicFieldName } =
                $DynamicFieldBackendObject->EditFieldValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $ParamObject,
                    LayoutObject       => $LayoutObject,
                );
        }
    }

    # get needed objects
    my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

    my @Notify;

    # Get Ticket to check TicketID was valid
    %Ticket = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        UserID        => $ConfigObject->Get('CustomerPanelUserID'),
        DynamicFields => 1,
    );

    if ( !IsHashRefWithData( \%Ticket ) ) {
        $LayoutObject->CustomerFatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Could not store ActivityDialog, invalid TicketID: %s!', $TicketID ),
        );
    }

    $ActivityEntityID = $Ticket{
        'DynamicField_'
            . $ConfigObject->Get('Process::DynamicFieldProcessManagementActivityID')
    };
    if ( !$ActivityEntityID )
    {

        return $Self->_ShowDialogError(
            Message => $LayoutObject->{LanguageObject}->Translate(
                'Missing ActivityEntityID in Ticket %s!',
                $Ticket{TicketID},
            ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # Make sure the activity dialog to save is still the correct activity
    my $Activity = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity')->ActivityGet(
        ActivityEntityID => $ActivityEntityID,
        Interface        => ['CustomerInterface'],
    );
    my %ActivityDialogs = reverse %{ $Activity->{ActivityDialog} // {} };
    if ( !$ActivityDialogs{$ActivityDialogEntityID} ) {
        my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
        my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');

        $Error{WrongActivity} = 1;
        push @Notify, {
            Priority => 'Error',
            Data     => $LayoutObject->{LanguageObject}->Translate(
                'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.',
                $TicketHook,
                $TicketHookDivider,
                $Ticket{TicketNumber},
            ),
        };
    }

    $ProcessEntityID = $Ticket{
        'DynamicField_'
            . $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID')
    };

    if ( !$ProcessEntityID )
    {
        return $Self->_ShowDialogError(
            Message => $LayoutObject->{LanguageObject}->Translate(
                'Missing ProcessEntityID in Ticket %s!',
                $Ticket{TicketID},
            ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # if we got errors go back to displaying the ActivityDialog
    if ( IsHashRefWithData( \%Error ) ) {
        return $Self->_OutputActivityDialog(
            ProcessEntityID        => $ProcessEntityID,
            TicketID               => $TicketID || undef,
            ActivityDialogEntityID => $ActivityDialogEntityID,
            Error                  => \%Error,
            ErrorMessages          => \%ErrorMessages,
            Visibility             => \%Visibility,
            DFErrors               => \%DynamicFieldValidationResult,
            DFPossibleValues       => \%DynamicFieldPossibleValues,
            GetParam               => $Param{GetParam},
            Notify                 => \@Notify,
        );
    }

    # Check if we deal with a Ticket Update
    my $UpdateTicketID = $Param{GetParam}->{TicketID};

    # We save only once, no matter if one or more configurations are set for the same param
    my %StoredFields;

    # Save loop for storing Ticket Values that were not required on the initial TicketCreate
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        if ( !IsHashRefWithData( $ActivityDialog->{Fields}->{$CurrentField} ) ) {
            $LayoutObject->CustomerFatalError(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Can\'t get data for Field "%s" of ActivityDialog "%s"!',
                    $CurrentField,
                    $ActivityDialogEntityID,
                ),
            );
        }

        next DIALOGFIELD if $CurrentField =~ m{^DynamicField_(.*)}xms;

        if ( $CurrentField eq 'Article' && $UpdateTicketID ) {

            my $TicketID = $UpdateTicketID;

            if ( $Param{GetParam}->{Subject} && $Param{GetParam}->{Body} ) {

                # add note
                my $ArticleID = '';
                my $MimeType  = 'text/plain';
                if ( $LayoutObject->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $Param{GetParam}->{Body} = $LayoutObject->RichTextDocumentComplete(
                        String => $Param{GetParam}->{Body},
                    );
                }

                my $CommunicationChannel = $ActivityDialog->{Fields}->{Article}->{Config}->{CommunicationChannel}
                    // 'Internal';

                my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
                    ChannelName => $CommunicationChannel,
                );

                # Change history type and comment accordingly to the process article.
                # Initial internal should be a web request, while follow-ups should be notes
                my $HistoryType    = 'WebRequestCustomer';
                my $HistoryComment = '%%';
                if ( $CommunicationChannel eq 'Phone' ) {
                    $HistoryType = 'PhoneCallCustomer';
                }
                elsif ($UpdateTicketID) {
                    $HistoryType = 'FollowUp';
                }

                my $From = "$Self->{UserFullname} <$Self->{UserEmail}>";
                $ArticleID = $ArticleBackendObject->ArticleCreate(
                    TicketID             => $TicketID,
                    SenderType           => 'customer',
                    IsVisibleForCustomer => $ActivityDialog->{Fields}->{Article}->{Config}->{IsVisibleForCustomer} // 0,
                    From                 => $From,
                    MimeType             => $MimeType,
                    Charset              => $LayoutObject->{UserCharset},
                    UserID               => $ConfigObject->Get('CustomerPanelUserID'),
                    HistoryType          => $HistoryType,
                    HistoryComment       => $HistoryComment,
                    Body                 => $Param{GetParam}->{Body},
                    Subject              => $Param{GetParam}->{Subject},
                );
                if ( !$ArticleID ) {
                    return $LayoutObject->CustomerErrorScreen();
                }

                # get pre loaded attachment
                my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
                    FormID => $Self->{FormID},
                );

                # get submit attachment
                my %UploadStuff = $ParamObject->GetUploadAll(
                    Param => 'FileUpload',
                );
                if (%UploadStuff) {
                    push @Attachments, \%UploadStuff;
                }

                # write attachments
                ATTACHMENT:
                for my $Attachment (@Attachments) {

                    # skip, deleted not used inline images
                    my $ContentID = $Attachment->{ContentID};
                    if (
                        $ContentID
                        && ( $Attachment->{ContentType} =~ /image/i )
                        && ( $Attachment->{Disposition} eq 'inline' )
                        )
                    {
                        my $ContentIDHTMLQuote = $LayoutObject->Ascii2Html(
                            Text => $ContentID,
                        );

                        # workaround for link encode of rich text editor, see bug#5053
                        my $ContentIDLinkEncode = $LayoutObject->LinkEncode($ContentID);
                        $Param{GetParam}->{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                        # ignore attachment if not linked in body
                        if ( $Param{GetParam}->{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i )
                        {
                            next ATTACHMENT;
                        }
                    }

                    # write existing file to backend
                    $ArticleBackendObject->ArticleWriteAttachment(
                        %{$Attachment},
                        ArticleID => $ArticleID,
                        UserID    => $ConfigObject->Get('CustomerPanelUserID'),
                    );
                }

                # remove all form data
                $Kernel::OM->Get('Kernel::System::Web::FormCache')->FormIDRemove( FormID => $Self->{FormID} );
            }
        }

        # If we have to Update a ticket, update the transmitted values
        elsif ($UpdateTicketID) {

            my $Success;
            if ( $Self->{NameToID}{$CurrentField} eq 'Title' ) {

                # if there is no title, nothig is needed to be done
                if (
                    !defined $TicketParam{'Title'}
                    || ( defined $TicketParam{'Title'} && $TicketParam{'Title'} eq '' )
                    )
                {
                    $Success = 1;
                }

                # otherwise set the ticket title
                else {
                    $Success = $TicketObject->TicketTitleUpdate(
                        Title    => $TicketParam{'Title'},
                        TicketID => $TicketID,
                        UserID   => $ConfigObject->Get('CustomerPanelUserID'),
                    );
                }
            }
            elsif (
                (
                    $Self->{NameToID}->{$CurrentField} eq 'CustomerID'
                    || $Self->{NameToID}->{$CurrentField} eq 'CustomerUserID'
                )
                )
            {
                next DIALOGFIELD if $StoredFields{ $Self->{NameToID}{$CurrentField} };

                if ( $ActivityDialog->{Fields}->{$CurrentField}{Display} == 1 ) {
                    $LayoutObject->CustomerFatalError(
                        Message => $LayoutObject->{LanguageObject}->Translate(
                            'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!',
                            $CurrentField
                        ),
                    );
                }

                # skip TicketCustomerSet() if there is no change in the customer
                if (
                    $Ticket{CustomerID} eq $TicketParam{CustomerID}
                    && $Ticket{CustomerUserID} eq $TicketParam{CustomerUser}
                    )
                {

                    # In this case we don't want to call any additional stores
                    # on Customer, CustomerNo, CustomerID or CustomerUserID
                    # so make sure both fields are set to "Stored" ;)
                    $StoredFields{ $Self->{NameToID}->{'CustomerID'} }     = 1;
                    $StoredFields{ $Self->{NameToID}->{'CustomerUserID'} } = 1;
                    next DIALOGFIELD;
                }

                $Success = $TicketObject->TicketCustomerSet(
                    No => $TicketParam{CustomerID},

                    # here too: unfortunately TicketCreate takes Param 'CustomerUser'
                    # instead of CustomerUserID, so our TicketParam hash
                    # has the CustomerUser Key instead of 'CustomerUserID'
                    User     => $TicketParam{CustomerUser},
                    TicketID => $TicketID,
                    UserID   => $ConfigObject->Get('CustomerPanelUserID'),
                );

                # In this case we don't want to call any additional stores
                # on Customer, CustomerNo, CustomerID or CustomerUserID
                # so make sure both fields are set to "Stored" ;)
                $StoredFields{ $Self->{NameToID}->{'CustomerID'} }     = 1;
                $StoredFields{ $Self->{NameToID}->{'CustomerUserID'} } = 1;
            }
            else {
                next DIALOGFIELD if $StoredFields{ $Self->{NameToID}{$CurrentField} };

                my $TicketFieldSetSub = $CurrentField;
                $TicketFieldSetSub =~ s{ID$}{}xms;
                $TicketFieldSetSub = 'Ticket' . $TicketFieldSetSub . 'Set';

                if ( $TicketObject->can($TicketFieldSetSub) )
                {
                    my $UpdateFieldName;

                    $UpdateFieldName = $Self->{NameToID}->{$CurrentField};

                    # to store if the field needs to be updated
                    my $FieldUpdate;

                    # only Service and SLA fields accepts empty values if the hash key is not
                    # defined set it to empty so the Ticket*Set function call will get the empty
                    # value
                    if (
                        ( $UpdateFieldName eq 'ServiceID' || $UpdateFieldName eq 'SLAID' )
                        && !defined $TicketParam{ $Self->{NameToID}->{$CurrentField} }
                        )
                    {
                        $TicketParam{ $Self->{NameToID}->{$CurrentField} } = '';
                        $FieldUpdate = 1;
                    }

                    # update Service an SLA fields if they have a defined value (even empty)
                    elsif ( $UpdateFieldName eq 'ServiceID' || $UpdateFieldName eq 'SLAID' )
                    {
                        $FieldUpdate = 1;
                    }

                    # update any other field that its value is defined and not empty
                    elsif (
                        $UpdateFieldName ne 'ServiceID'
                        && $UpdateFieldName ne 'SLAID'
                        && defined $TicketParam{ $Self->{NameToID}->{$CurrentField} }
                        && $TicketParam{ $Self->{NameToID}->{$CurrentField} } ne ''
                        )
                    {
                        $FieldUpdate = 1;
                    }

                    $Success = 1;

                    # check if field needs to be updated
                    if ($FieldUpdate) {
                        $Success = $TicketObject->$TicketFieldSetSub(
                            $UpdateFieldName => $TicketParam{ $Self->{NameToID}->{$CurrentField} },
                            TicketID         => $TicketID,
                            UserID           => $ConfigObject->Get('CustomerPanelUserID'),
                        );
                    }
                }
            }
            if ( !$Success ) {
                $LayoutObject->CustomerFatalError(
                    Message => $LayoutObject->{LanguageObject}->Translate(
                        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!',
                        $CurrentField, $TicketID, $ActivityDialogEntityID
                    ),
                );
            }
        }
    }

    DYNAMICFIELD:
    for my $DynamicFieldName ( keys $Self->{DynamicField}->%* ) {

        my $DynamicFieldConfig = $Self->{DynamicField}{$DynamicFieldName};
        if ( !IsHashRefWithData($DynamicFieldConfig) ) {

            my $Message = "DynamicFieldConfig missing for field: $DynamicFieldName, or is not a Ticket Dynamic Field!";

            # log error but does not stop the execution as it could be an old Article
            # DynamicField, see bug#11666
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Message,
            );

            next DYNAMICFIELD;
        }

        next DYNAMICFIELD if !$Visibility{ 'DynamicField_' . $DynamicFieldName };

        my $Success = $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $TicketID,
            Value              => $TicketParam{ 'DynamicField_' . $DynamicFieldName },
            UserID             => $ConfigObject->Get('CustomerPanelUserID'),
        );

        if ( !$Success ) {
            $LayoutObject->CustomerFatalError(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!',
                    $DynamicFieldName,
                    $TicketID,
                    $ActivityDialogEntityID,
                ),
            );
        }
    }

    # delete hidden fields cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'HiddenFields',
        Key  => $Self->{FormID},
    );

    # Transitions will be handled by ticket event module (TicketProcessTransitions.pm).

    my $NextScreen = $Self->{NextScreen} || $ConfigObject->Get('Ticket::Frontend::CustomerTicketProcess')->{'NextScreenAfterFollowUp'};
    return $LayoutObject->Redirect(
        OP => "Action=$NextScreen;TicketID=$TicketID",
    );
}

# =item _CheckField()
#
# checks all the possible ticket fields and returns the ID (if possible) value of the field, if valid
# and checks are successful
#
# if Display param is set to 0 or not given, it uses ActivityDialog field default value for all fields
# or global default value as fallback only for certain fields
#
# if Display param is set to 1 or 2 it uses the value from the web request
#
#     my $PriorityID = $CustomerTicketProcessObject->_CheckField(
#         Field        => 'PriorityID',
#         Display      => 1,                   # optional, 0 or 1 or 2
#         DefaultValue => '3 normal',          # ActivityDialog field default value (it uses global
#                                              #    default value as fall back for mandatory fields
#                                              #    (Queue, Sate, Lock and Priority)
#     );
#
# Returns:
#     $PriorityID = 1;                         # if PriorityID is set to 1 in the web request
#
#     my $PriorityID = $CustomerTicketProcessObject->_CheckField(
#         Field        => 'PriorityID',
#         Display      => 0,
#         DefaultValue => '3 normal',
#     );
#
# Returns:
#     $PriorityID = 3;                        # since ActivityDialog default value is '3 normal' and
#                                             #     field is hidden
#
# =cut

sub _CheckField {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Field)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # remove the ID and check if the given field is required for creating a ticket
    my $FieldWithoutID = $Param{Field};
    $FieldWithoutID =~ s{ID$}{}xms;
    my $TicketRequiredField = scalar grep { $_ eq $FieldWithoutID } qw(Queue State Lock Priority);

    my $Value;

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # if no Display (or Display == 0) is committed
    if ( !$Param{Display} ) {

        # Check if a DefaultValue is given
        if ( $Param{DefaultValue} ) {

            # check if the given field param is valid
            $Value = $Self->_LookupValue(
                Field => $FieldWithoutID,
                Value => $Param{DefaultValue},
            );
        }

        # if we got a required ticket field, check if we got a valid DefaultValue in the SysConfig
        if ( !$Value && $TicketRequiredField ) {
            $Value = $Kernel::OM->Get('Kernel::Config')->Get("Process::Default$FieldWithoutID");

            if ( !$Value ) {
                $LayoutObject->CustomerFatalError(
                    Message => $LayoutObject->{LanguageObject}->Translate( 'Default Config for Process::Default%s missing!', $FieldWithoutID ),
                );
            }
            else {

                # check if the given field param is valid
                $Value = $Self->_LookupValue(
                    Field => $FieldWithoutID,
                    Value => $Value,
                );
                if ( !$Value ) {
                    $LayoutObject->CustomerFatalError(
                        Message => $LayoutObject->{LanguageObject}->Translate( 'Default Config for Process::Default%s invalid!', $FieldWithoutID ),
                    );
                }
            }
        }
    }
    elsif ( $Param{Display} == 1 ) {

        # Display == 1 is logicality not possible for a ticket required field
        if ($TicketRequiredField) {
            $LayoutObject->CustomerFatalError(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!',
                    $Param{Field},
                ),
            );
        }

        # check if the given field param is valid
        if ( $Param{Field} eq 'Article' ) {

            # in case of article fields we need to fake a value
            $Value = 1;

            my ( $Body, $Subject, $AttachmentExists ) = (
                $ParamObject->GetParam( Param => 'Body' ),
                $ParamObject->GetParam( Param => 'Subject' ),
                $ParamObject->GetParam( Param => 'AttachmentExists' ),
            );

            # If attachment exists and body and subject not, it is error (see bug#13081).
            if ( $AttachmentExists && ( !$Body && !$Subject ) ) {
                $Value = 0;
            }
        }
        else {

            $Value = $Self->_LookupValue(
                Field => $Param{Field},
                Value => $ParamObject->GetParam( Param => $Param{Field} ) || '',
            );
        }
    }
    elsif ( $Param{Display} == 2 ) {

        # check if the given field param is valid
        if ( $Param{Field} eq 'Article' ) {

            my ( $Body, $Subject ) = (
                $ParamObject->GetParam( Param => 'Body' ),
                $ParamObject->GetParam( Param => 'Subject' )
            );

            $Value = 0;
            if ( $Body && $Subject ) {
                $Value = 1;
            }
        }
        else {
            $Value = $Self->_LookupValue(
                Field => $Param{Field},
                Value => $ParamObject->GetParam( Param => $Param{Field} ) || '',
            );
        }
    }

    return $Value;
}

# =item _LookupValue()
#
# returns the ID (if possible) of nearly all ticket fields and/or checks if its valid.
# Can handle IDs or Strings.
# Currently working with: State, Queue, Lock, Priority (possible more).
#
#     my $PriorityID = $CustomerTicketProcessObject->_LookupValue(
#         PriorityID => 1,
#     );
#     $PriorityID = 1;
#
#     my $StateID = $CustomerTicketProcessObject->_LookupValue(
#         State => 'open',
#     );
#     $StateID = 3;
#
#     my $PriorityID = $CustomerTicketProcessObject->_LookupValue(
#         Priority => 'unknownpriority1234',
#     );
#     $PriorityID = undef;
#
# =cut

sub _LookupValue {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Needed (qw(Field Value)) {
        if ( !defined $Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( !$Param{Field} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Field should not be empty!"
        );
        return;
    }

    # if there is no value, there is nothing to do
    return if !$Param{Value};

    # remove the ID for function name purpose
    my $FieldWithoutID = $Param{Field};
    $FieldWithoutID =~ s{ID$}{}xms;

    my $LookupFieldName;
    my $ObjectName;
    my $FunctionName;

    # service and SLA lookup needs Name as parameter (While ServiceID an SLAID uses standard)
    if ( scalar grep { $Param{Field} eq $_ } qw( Service SLA ) ) {
        $LookupFieldName = 'Name';
        $ObjectName      = $FieldWithoutID;
        $FunctionName    = $FieldWithoutID . 'Lookup';
    }

    # other fields can use standard parameter names as Priority or PriorityID
    else {
        $LookupFieldName = $Param{Field};
        $ObjectName      = $FieldWithoutID;
        $FunctionName    = $FieldWithoutID . 'Lookup';
    }

    # get appropriate object of field
    my $FieldObject;
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::' . $ObjectName, Silent => 1 ) ) {
        $FieldObject = $Kernel::OM->Get( 'Kernel::System::' . $ObjectName );
    }

    my $Value;

    # check if the backend module has the needed *Lookup sub
    if ( $FieldObject && $FieldObject->can($FunctionName) ) {

        # call the *Lookup sub and get the value
        $Value = $FieldObject->$FunctionName(
            $LookupFieldName => $Param{Value},
        );
    }

    # if we didn't have an object and the value has no ref a string e.g. Title and so on
    # return true
    elsif ( $Param{Field} eq $FieldWithoutID && !ref $Param{Value} ) {
        return $Param{Value};
    }
    else {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Error while checking with " . $FieldWithoutID . "Object!"
        );
        return;
    }

    return if ( !$Value );

    # return the given ID value if the *Lookup result was a string
    if ( $Param{Field} ne $FieldWithoutID ) {
        return $Param{Value};
    }

    # return the *Lookup string return value
    return $Value;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # if no CustomerUserID is present, consider the logged in customer
    if ( !$Param{CustomerUserID} ) {
        $Param{CustomerUserID} = $Self->{UserID};
    }

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
                %Param,
                Action => $Self->{Action},
            );
        }
    }
    return \%SLA;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # check needed
    return \%Service if !$Param{QueueID} && !$Param{TicketID};

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # if no CustomerUserID is present, consider the logged in customer
    if ( !$Param{CustomerUserID} ) {
        $Param{CustomerUserID} = $Self->{UserID};
    }

    # check if still no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
            %Param,
            Action => $Self->{Action},
        );
    }
    return \%Service;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities;

    # Initially we have just the default Queue Parameter
    # so make sure to get the ID in that case
    my $QueueID;
    if ( !$Param{QueueID} && $Param{Queue} ) {
        $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Param{Queue} );
    }
    if ( $Param{QueueID} || $QueueID || $Param{TicketID} ) {
        %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );

    }
    return \%Priorities;
}

sub _GetQueues {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check own selection
    my %NewQueues;
    if ( $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewQueues = %{ $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Queues;
        if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Queues = $Kernel::OM->Get('Kernel::System::Ticket')->MoveList(
                %Param,
                Type           => 'create',
                Action         => $Self->{Action},
                QueueID        => $Self->{QueueID},
                CustomerUserID => $Self->{UserID},
            );
        }
        else {
            %Queues = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList();
        }

        # get create permission queues
        my %UserGroups = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'create',
            Result => 'HASH',
        );

        # build selection string
        QUEUEID:
        for my $QueueID ( sort keys %Queues ) {
            my %QueueData = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next QUEUEID if !$UserGroups{ $QueueData{GroupID} };

            my $String = $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;

            # remove trailing spaces
            $String =~ s{\s+\z}{} if !$QueueData{Comment};

            if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(
                    ID => $Queues{$QueueID},
                );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewQueues{$QueueID} = $String;
        }
    }

    return \%NewQueues;
}

sub _GetStates {
    my ( $Self, %Param ) = @_;

    my %States = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
        %Param,

        # Set default values for new process ticket
        QueueID  => $Param{QueueID}  || 1,
        TicketID => $Param{TicketID} || '',

        # remove type, since if Ticket::Type is active in sysconfig, the Type parameter will
        # be sent and the TicketStateList will send the parameter as State Type
        Type => undef,

        Action         => $Self->{Action},
        CustomerUserID => $Self->{UserID},
    );

    return \%States;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # get type
    my %Type;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _ShowDialogError {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->CustomerHeader( Type => 'Small' );
    $Output .= $LayoutObject->CustomerError(%Param);
    $Output .= $LayoutObject->CustomerFooter( Type => 'Small' );
    return $Output;
}

sub _GetInputDefinitionDynamicFields {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my %DynamicField;

    # This subroutine takes a DFEntry and the DynamicFieldObject as arguments
    # It retrieves the dynamic field definition for the given DFEntry
    # If the definition is not available, it retrieves it from the DynamicFieldObject
    # Returns the dynamic field definition
    my $GetDynamicField = sub {

        my ($DFEntry) = @_;

        my $DynamicField = $DFEntry->{Definition} // $DynamicFieldObject->DynamicFieldGet(
            Name => $DFEntry->{DF},
        );

        return $DynamicField;
    };

    ITEM:
    for my $IncludeItem ( @{ $Param{InputFieldDefinition} } ) {

        if ( $IncludeItem->{Grid} ) {

            for my $Row ( @{ $IncludeItem->{Grid}{Rows} } ) {

                DFENTRY:
                for my $DFEntry ( $Row->@* ) {

                    my $DynamicField = $GetDynamicField->($DFEntry);
                    if ( IsHashRefWithData($DynamicField) ) {
                        $DynamicField->{Mandatory}      = $DFEntry->{Mandatory};
                        $DynamicField->{Readonly}       = $DFEntry->{Readonly};
                        $DynamicField{ $DFEntry->{DF} } = $DynamicField;
                    }
                    else {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "DynamicFieldConfig missing for field: $DFEntry->{DF}, or is not a Ticket Dynamic Field!",
                        );

                        next DFENTRY;
                    }
                }
            }
        }
        elsif ( $IncludeItem->{DF} ) {

            my $DynamicField = $GetDynamicField->($IncludeItem);
            if ($DynamicField) {
                $DynamicField->{Mandatory}          = $IncludeItem->{Mandatory};
                $DynamicField->{Readonly}           = $IncludeItem->{Readonly};
                $DynamicField{ $IncludeItem->{DF} } = $DynamicField;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "DynamicFieldConfig missing for field: $IncludeItem->{DF}, or is not a Ticket Dynamic Field!",
                );
                next ITEM;
            }
        }
        else {
            next ITEM;
        }
    }

    return \%DynamicField;
}

1;
