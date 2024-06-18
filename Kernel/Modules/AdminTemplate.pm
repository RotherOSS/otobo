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

package Kernel::Modules::AdminTemplate;

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

    # set pref for columns key
    $Self->{PrefKeyIncludeInvalid} = 'IncludeInvalid' . '-' . $Self->{Action};

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    $Self->{IncludeInvalid} = $Preferences{ $Self->{PrefKeyIncludeInvalid} };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject            = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject           = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
    my $StdAttachmentObject    = $Kernel::OM->Get('Kernel::System::StdAttachment');
    my $QueueObject            = $Kernel::OM->Get('Kernel::System::Queue');

    my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';

    $Param{IncludeInvalid} = $ParamObject->GetParam( Param => 'IncludeInvalid' );

    if ( defined $Param{IncludeInvalid} ) {
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{PrefKeyIncludeInvalid},
            Value  => $Param{IncludeInvalid},
        );

        $Self->{IncludeInvalid} = $Param{IncludeInvalid};
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID   = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data = $StandardTemplateObject->StandardTemplateGet(
            ID => $ID,
        );

        my @SelectedAttachment;
        my %SelectedAttachmentData = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
            StandardTemplateID => $ID,
        );
        for my $Key ( sort keys %SelectedAttachmentData ) {
            push @SelectedAttachment, $Key;
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ( $Self->{LightAdmin} ) {
            my %Queues = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $ID );
            $Data{Permission} = $QueueObject->QueueListPermission(
                QueueIDs => [ keys %Queues ],
                UserID   => $Self->{UserID},
                Default  => 'rw',
            );

            # No permission for the template.
            if ( !$Data{Permission} ) {
                %Data = ();
            }
            elsif ( $Data{Permission} eq 'ro' ) {
                $Output .= $LayoutObject->Notify(
                    Priority => 'Notice',
                    Data     => $LayoutObject->{LanguageObject}->Translate('No permission to edit this template.'),
                );
            }
        }

        $Output .= $LayoutObject->Notify( Info => Translatable('Template updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Self->_Edit(
            Action => 'Change',
            %Data,
            SelectedAttachments => \@SelectedAttachment,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @NewIDs = $ParamObject->GetArray( Param => 'IDs' );
        if ( $Self->{LightAdmin} ) {
            my @CheckedIDs;
            for my $ID (@NewIDs) {
                my $Permission = $StdAttachmentObject->StdAttachmentStandardTemplatePermission(
                    ID     => $ID,
                    UserID => $Self->{UserID},
                );
                if ( $Permission eq 'rw' ) {
                    push @CheckedIDs, $ID;
                }
            }
            @NewIDs = @CheckedIDs;
        }

        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Comment ValidID TemplateType)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        $GetParam{'Template'} = $ParamObject->GetParam(
            Param => 'Template',
            Raw   => 1
        ) || '';

        # get composed content type
        $GetParam{ContentType} = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $GetParam{ContentType} = 'text/html';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TemplateType)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check if a standard template exist with this name
        my $NameExists = $StandardTemplateObject->NameExistsCheck(
            Name => $GetParam{Name},
            ID   => $GetParam{ID}
        );

        if ($NameExists) {
            $Errors{NameExists}    = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        if ( $Self->{LightAdmin} ) {
            my %Queues     = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $GetParam{ID} );
            my $Permission = $QueueObject->QueueListPermission(
                QueueIDs => [ keys %Queues ],
                UserID   => $Self->{UserID},
                Default  => 'rw',
            );

            # No permission to change the template.
            if ( $Permission ne 'rw' ) {
                $Errors{NoPermission} = 1;
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            if (
                $StandardTemplateObject->StandardTemplateUpdate(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {
                my %AttachmentsAll = $StdAttachmentObject->StdAttachmentList();

                # create hash with selected queues
                my %AttachmentsSelected = map { $_ => 1 } @NewIDs;

                # check all used attachments
                for my $AttachmentID ( sort keys %AttachmentsAll ) {
                    my $Active = $AttachmentsSelected{$AttachmentID} ? 1 : 0;

                    # set attachment to standard template relation
                    my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
                        AttachmentID       => $AttachmentID,
                        StandardTemplateID => $GetParam{ID},
                        Active             => $Active,
                        UserID             => $Self->{UserID},
                    );
                }

                # if the user would like to continue editing the template, just redirect to the edit screen
                if (
                    defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
                    && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
                    )
                {
                    my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
                    return $LayoutObject->Redirect(
                        OP => "Action=$Self->{Action};Subaction=Change;ID=$ID;Notification=Update"
                    );
                }
                else {

                    # otherwise return to overview
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
                }
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action              => 'Change',
            Errors              => \%Errors,
            SelectedAttachments => \@NewIDs,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @NewIDs = $ParamObject->GetArray( Param => 'IDs' );
        if ( $Self->{LightAdmin} ) {
            my @CheckedIDs;
            for my $ID (@NewIDs) {
                my $Permission = $StdAttachmentObject->StdAttachmentStandardTemplatePermission(
                    ID     => $ID,
                    UserID => $Self->{UserID},
                );
                if ( $Permission eq 'rw' ) {
                    push @CheckedIDs, $ID;
                }
            }
            @NewIDs = @CheckedIDs;
        }

        my ( %GetParam, %Errors );

        for my $Parameter (qw(ID Name Comment ValidID TemplateType)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        $GetParam{'Template'} = $ParamObject->GetParam(
            Param => 'Template',
            Raw   => 1
        ) || '';

        # get composed content type
        $GetParam{ContentType} = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $GetParam{ContentType} = 'text/html';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TemplateType)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check if a standard template exists with this name
        my $NameExists = $StandardTemplateObject->NameExistsCheck( Name => $GetParam{Name} );
        if ($NameExists) {
            $Errors{NameExists}    = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add template
            my $StandardTemplateID = $StandardTemplateObject->StandardTemplateAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );
            if ($StandardTemplateID) {

                my %AttachmentsAll = $StdAttachmentObject->StdAttachmentList();

                # create hash with selected queues
                my %AttachmentsSelected = map { $_ => 1 } @NewIDs;

                # check all used attachments
                for my $AttachmentID ( sort keys %AttachmentsAll ) {
                    my $Active = $AttachmentsSelected{$AttachmentID} ? 1 : 0;

                    # set attachment to standard template relation
                    my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
                        AttachmentID       => $AttachmentID,
                        StandardTemplateID => $StandardTemplateID,
                        Active             => $Active,
                        UserID             => $Self->{UserID},
                    );
                }

                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify(
                    Info => Translatable('Template added!'),
                );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminTemplate',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action              => 'Add',
            Errors              => \%Errors,
            SelectedAttachments => \@NewIDs,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTemplate',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ID = $ParamObject->GetParam( Param => 'ID' );

        if ( $Self->{LightAdmin} ) {
            my %Queues     = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $ID );
            my $Permission = $QueueObject->QueueListPermission(
                QueueIDs => [ keys %Queues ],
                UserID   => $Self->{UserID},
                Default  => 'rw',
            );

            # No permission to delete the template.
            if ( $Permission ne 'rw' ) {
                return $LayoutObject->ErrorScreen();
            }
        }

        my $Delete = $StandardTemplateObject->StandardTemplateDelete(
            ID => $ID,
        );
        if ( !$Delete ) {
            return $LayoutObject->ErrorScreen();
        }

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => $Delete,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Info => Translatable('Template updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminTemplate',
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

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    my $TemplateTypeList = $Kernel::OM->Get('Kernel::Config')->Get('StandardTemplate::Types');

    $Param{TemplateTypeString} = $LayoutObject->BuildSelection(
        Data       => $TemplateTypeList,
        Name       => 'TemplateType',
        SelectedID => $Param{TemplateType},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TemplateTypeInvalid'} || '' ),
    );

    my $StdAttachmentObject = $Kernel::OM->Get('Kernel::System::StdAttachment');
    my %AttachmentData      = $StdAttachmentObject->StdAttachmentList( Valid => 1 );

    if ( $Self->{LightAdmin} ) {
        for my $Key ( sort keys %AttachmentData ) {
            my $Permission = $StdAttachmentObject->StdAttachmentStandardTemplatePermission(
                ID     => $Key,
                UserID => $Self->{UserID},
            );
            if ( $Permission ne 'rw' ) {
                delete $AttachmentData{$Key};
            }
        }
    }

    $Param{AttachmentOption} = $LayoutObject->BuildSelection(
        Data         => \%AttachmentData,
        Name         => 'IDs',
        Multiple     => 1,
        Size         => 6,
        Translation  => 0,
        PossibleNone => 1,
        SelectedID   => $Param{SelectedAttachments},
        Class        => 'Modernize',
    );

    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    if ( $LayoutObject->{BrowserRichText} ) {

        # reformat from plain to html
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/plain/i ) {
            $Param{Template} = $HTMLUtilsObject->ToHTML(
                String => $Param{Template},
            );
        }
    }
    else {

        # reformat from html to plain
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/html/i ) {
            $Param{Template} = $HTMLUtilsObject->ToAscii(
                String => $Param{Template},
            );
        }
    }

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # show appropriate messages for ServerError
    if ( defined $Param{Errors}->{NameExists} && $Param{Errors}->{NameExists} == 1 ) {
        $LayoutObject->Block( Name => 'ExistNameServerError' );
    }
    else {
        $LayoutObject->Block( Name => 'NameServerError' );
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # set up rich text editor
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block(
        Name => 'IncludeInvalid',
        Data => {
            IncludeInvalid        => $Self->{IncludeInvalid},
            IncludeInvalidChecked => $Self->{IncludeInvalid} ? 'checked' : '',
        },
    );
    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
    my %List                   = $StandardTemplateObject->StandardTemplateList(
        UserID => 1,
        Valid  => $Self->{IncludeInvalid} ? 0 : 1,
    );

    # if there are any results, they are shown
    if (%List) {

        my %ListGet;
        for my $ID ( sort keys %List ) {
            %{ $ListGet{$ID} } = $StandardTemplateObject->StandardTemplateGet(
                ID => $ID,
            );
            $ListGet{$ID}->{SortName} = $ListGet{$ID}->{TemplateType} . $ListGet{$ID}->{Name};
        }

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        ID:
        for my $ID ( sort { $ListGet{$a}->{SortName} cmp $ListGet{$b}->{SortName} } keys %ListGet )
        {

            my %Data = %{ $ListGet{$ID} };

            # check queue permissions of linked templates.
            if ( $Self->{LightAdmin} ) {
                my %Queues = $QueueObject->QueueStandardTemplateMemberList( StandardTemplateID => $Data{ID} );
                $Data{Permission} = $QueueObject->QueueListPermission(
                    QueueIDs => [ keys %Queues ],
                    UserID   => $Self->{UserID},
                    Default  => 'rw',
                );
                next ID if !$Data{Permission};
            }

            my @SelectedAttachment;
            my %SelectedAttachmentData = $Kernel::OM->Get('Kernel::System::StdAttachment')->StdAttachmentStandardTemplateMemberList(
                StandardTemplateID => $ID,
            );
            for my $Key ( sort keys %SelectedAttachmentData ) {
                push @SelectedAttachment, $Key;
            }
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                    Attachments => scalar @SelectedAttachment,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    return 1;
}

1;
