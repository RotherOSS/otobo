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

package Kernel::Modules::AdminCustomerDashboardInfoTile;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # LightAdmin Param
    if ( !$Param{AccessRw} && $Param{AccessRo} ) {
        $Self->{LightAdmin} = 1;
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject                    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject                     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $CustomerDashboardInfoTileObject = $Kernel::OM->Get('Kernel::System::CustomerDashboard::InfoTile');

    my $ID                = $ParamObject->GetParam( Param => 'ID' ) || '';
    my $SessionVisibility = 'Collapsed';

    # ------------------------------------------------------------ #
    # CustomerDashboardInfoTileNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CustomerDashboardInfoTileNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # CustomerDashboardInfoTileNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'CustomerDashboardInfoTileNewAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check required parameters
        my %Error;
        my @NotifyData;

        # get CustomerDashboardInfoTile parameters from web browser
        my $CustomerDashboardInfoTileData = $Self->_GetParams(
            Error => \%Error,
        );

        # a StartDate should always be defined before StopDate
        if (
            (
                $CustomerDashboardInfoTileData->{StartDateUsed}
                && $CustomerDashboardInfoTileData->{StopDateUsed}
            )
            && $CustomerDashboardInfoTileData->{StartDate} > $CustomerDashboardInfoTileData->{StopDate}
            )
        {

            # set server error
            $Error{StartDateServerError} = 'ServerError';

            # add notification
            push @NotifyData, {
                Priority => 'Error',
                Info     => Translatable('Start date shouldn\'t be defined after Stop date!'),
            };
        }

        if ( !$CustomerDashboardInfoTileData->{Name} ) {

            # add server error class
            $Error{NameServerError} = 'ServerError';

            # add notification
            push @NotifyData, {
                Priority => 'Error',
                Info     => Translatable('Name is missing!'),
            };
        }

        # if ( !$CustomerDashboardInfoTileData->{Content} ) {

        #     # add server error class
        #     $Error{ContentServerError} = 'ServerError';

        #     # add notification
        #     push @NotifyData, {
        #         Priority => 'Error',
        #         Info     => Translatable('Content is missing!'),
        #     };
        # }

        if ( !$CustomerDashboardInfoTileData->{ValidID} ) {

            # add server error class
            $Error{ValidIDServerError} = 'ServerError';

            # add notification
            push @NotifyData, {
                Priority => 'Error',
                Info     => Translatable('ValidID is missing!'),
            };
        }

        if ( !$CustomerDashboardInfoTileData->{Groups} && $Self->{LightAdmin} ) {

            # add server error class
            $Error{GroupsServerError} = 'ServerError';

            # add notification
            push @NotifyData, {
                Priority => 'Error',
                Info     => Translatable('Group is missing!'),
            };
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {

            return $Self->_ShowEdit(
                %Error,
                %Param,
                NotifyData                    => \@NotifyData,
                CustomerDashboardInfoTileData => $CustomerDashboardInfoTileData,
                Action                        => 'New',
            );
        }

        my $ID = $CustomerDashboardInfoTileObject->InfoTileAdd(
            StartDate      => $CustomerDashboardInfoTileData->{StartDate},
            StartDateUsed  => $CustomerDashboardInfoTileData->{StartDateUsed},
            StopDate       => $CustomerDashboardInfoTileData->{StopDate},
            StopDateUsed   => $CustomerDashboardInfoTileData->{StopDateUsed},
            Name           => $CustomerDashboardInfoTileData->{Name},
            Content        => $CustomerDashboardInfoTileData->{Content},
            MarqueeContent => $CustomerDashboardInfoTileData->{MarqueeContent},
            Groups         => $CustomerDashboardInfoTileData->{Groups},
            ValidID        => $CustomerDashboardInfoTileData->{ValidID},
            UserID         => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error creating the info tile entry'),
            );
        }

        # redirect to edit screen
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=CustomerDashboardInfoTileEdit;ID=$ID;Notification=Add"
            );
        }
        else {
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Add" );
        }
    }

    # ------------------------------------------------------------ #
    # Edit View
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'CustomerDashboardInfoTileEdit' ) {

        # initialize notify container
        my @NotifyData;

        # check for ID
        if ( !$ID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need ID!'),
            );
        }

        # get customerdashboard info data
        my $CustomerDashboardInfoTileData = $CustomerDashboardInfoTileObject->InfoTileGet(
            ID     => $ID,
            UserID => $Self->{UserID},
        );

        my $Access = $CustomerDashboardInfoTileObject->InfoTilePermission(
            Type   => 'rw',
            ID     => $ID,
            UserID => $Self->{UserID}
        );

        if ( !$CustomerDashboardInfoTileData || !$Access ) {
            return $LayoutObject->NoPermission(
                Message => Translatable(
                    "This Entry does not exist, or you don't have permissions to access it in its current state."
                ),
                withHeader => 'no'
            );
        }

        # include time stamps on the correct key
        for my $Key (qw(StartDate StopDate)) {

            # try to convert to TimeStamp
            my $DateTimeObject;
            if ( $CustomerDashboardInfoTileData->{ $Key . 'Used' } ) {
                $DateTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $CustomerDashboardInfoTileData->{$Key},
                    }
                );
            }
            $CustomerDashboardInfoTileData->{ $Key . 'TimeStamp' } =
                $DateTimeObject ? $DateTimeObject->ToString() : undef;
        }

        # check for valid tomerdashboard infodata
        if ( !IsHashRefWithData($CustomerDashboardInfoTileData) ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Could not get data for ID %s',
                    $ID
                ),
            );
        }

        if ( ( $ParamObject->GetParam( Param => 'Notification' ) || '' ) eq 'Add' ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => Translatable('Info tile entry was added successfully!'),
            };
        }

        if ( ( $ParamObject->GetParam( Param => 'Notification' ) || '' ) eq 'Update' ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => Translatable('Info tile entry was updated successfully!'),
            };
        }

        if ( $ParamObject->GetParam( Param => 'Kill' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => Translatable('Session has been killed!'),
            };

            # set class for expanding sessions widget
            $SessionVisibility = 'Expanded';
        }

        if ( $ParamObject->GetParam( Param => 'KillAll' ) ) {

            # add notification
            push @NotifyData, {
                Priority => 'Notice',
                Info     => Translatable('All sessions have been killed, except for your own.'),
            };

            # set class for expanding sessions widget
            $SessionVisibility = 'Expanded';
        }

        return $Self->_ShowEdit(
            %Param,
            ID                            => $ID,
            CustomerDashboardInfoTileData => $CustomerDashboardInfoTileData,
            NotifyData                    => \@NotifyData,
            SessionVisibility             => $SessionVisibility,
            Action                        => 'Edit',
        );

    }

    # ------------------------------------------------------------ #
    # Customer Dashboard Info Tile edit action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'CustomerDashboardInfoTileEditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check required parameters
        my %Error;
        my @NotifyData;

        # get CustomerDashboardInfoTile parameters from web browser
        my $CustomerDashboardInfoTileData = $Self->_GetParams(
            Error => \%Error,
        );

        # a StartDate should always be defined before StopDate
        if (
            (
                $CustomerDashboardInfoTileData->{StartDate}
                && $CustomerDashboardInfoTileData->{StopDate}
            )
            && $CustomerDashboardInfoTileData->{StartDate} > $CustomerDashboardInfoTileData->{StopDate}
            )
        {
            $Error{StartDateServerError} = 'ServerError';

            # add notification
            push @NotifyData, {
                Priority => 'Error',
                Info     => Translatable('Start date shouldn\'t be defined after Stop date!'),
            };
        }

        if ( !$CustomerDashboardInfoTileData->{Name} ) {

            # add server error class
            $Error{NameServerError} = 'ServerError';

        }

        if ( !$CustomerDashboardInfoTileData->{ValidID} ) {

            # add server error class
            $Error{ValidIDServerError} = 'ServerError';
        }

        if ( !$CustomerDashboardInfoTileData->{Groups} && $Self->{LightAdmin} ) {

            # add server error class
            $Error{GroupsServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {

            return $Self->_ShowEdit(
                %Error,
                %Param,
                NotifyData                    => \@NotifyData,
                ID                            => $ID,
                CustomerDashboardInfoTileData => $CustomerDashboardInfoTileData,
                Action                        => 'Edit',
            );
        }

        # otherwise update configuration and return to edit screen
        my $UpdateResult = $CustomerDashboardInfoTileObject->InfoTileUpdate(
            StartDate      => $CustomerDashboardInfoTileData->{StartDate},
            StopDate       => $CustomerDashboardInfoTileData->{StopDate},
            StartDateUsed  => $CustomerDashboardInfoTileData->{StartDateUsed},
            StopDateUsed   => $CustomerDashboardInfoTileData->{StopDateUsed},
            Name           => $CustomerDashboardInfoTileData->{Name},
            Content        => $CustomerDashboardInfoTileData->{Content},
            MarqueeContent => $CustomerDashboardInfoTileData->{MarqueeContent},
            Groups         => $CustomerDashboardInfoTileData->{Groups},
            ValidID        => $CustomerDashboardInfoTileData->{ValidID},
            UserID         => $Self->{UserID},
            ID             => $ID,
        );

        # show error if can't create
        if ( !$UpdateResult ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error updating the info tile entry'),
            );
        }

        # redirect to edit screen
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=CustomerDashboardInfoTileEdit;ID=$ID;Notification=Update"
            );
        }
        else {
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
        }

    }

    # ------------------------------------------------------------ #
    # Customer Dashboard Info Tile Delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        if ( !$ID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "No Customer Dashboard Info Tile ID $ID",
                Priority => 'error',
            );
        }

        my $Delete = $CustomerDashboardInfoTileObject->InfoTileDelete(
            ID     => $ID,
            UserID => $Self->{UserID},
        );
        if ( !$Delete ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'It was not possible to delete the info tile entry: %s!',
                    $ID
                ),
            );
        }
        return $LayoutObject->Redirect( OP => 'Action=AdminCustomerDashboardInfoTile' );

    }

    # ------------------------------------------------------------ #
    # else, show customer dashboard info tile list
    # ------------------------------------------------------------ #
    else {

        my $CustomerDashboardInfoTileList = $CustomerDashboardInfoTileObject->InfoTileListGet(
            UserID => $Self->{UserID},
        );

        # check permissions on each tile
        my %InfoTileList;
        for my $EntryID ( keys %{$CustomerDashboardInfoTileList} ) {
            my $Access = $CustomerDashboardInfoTileObject->InfoTilePermission(
                Type   => 'rw',
                ID     => $EntryID,
                UserID => $Self->{UserID},
            );
            if ($Access) {
                $InfoTileList{$EntryID} = $CustomerDashboardInfoTileList->{$EntryID};
            }
        }

        if ( !%InfoTileList ) {

            # no data found block
            $LayoutObject->Block(
                Name => 'NoDataRow',
            );
        }
        else {

            # sort items; sorting priorities: start date, changed date, created date
            my @Tiles       = values(%InfoTileList);
            my @TilesSorted = sort { $b->{StartDate} cmp $a->{StartDate} || $b->{Changed} cmp $a->{Changed} || $b->{Created} cmp $a->{Created} } @Tiles;

            for my $CustomerDashboardInfoTile (@TilesSorted) {

                # set the valid state
                $CustomerDashboardInfoTile->{ValidID} = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $CustomerDashboardInfoTile->{ValidID} );

                # include time stamps on the correct key
                for my $Key (qw(StartDate StopDate)) {

                    if ( $CustomerDashboardInfoTile->{ $Key . "Used" } ) {

                        my $DateTimeObject = $Kernel::OM->Create(
                            'Kernel::System::DateTime',
                            ObjectParams => {
                                String => $CustomerDashboardInfoTile->{$Key},
                            },
                        );

                        $DateTimeObject->ToTimeZone( TimeZone => $Self->{UserTimeZone} );

                        $CustomerDashboardInfoTile->{ $Key . 'TimeStamp' } = $DateTimeObject->ToString();
                    }
                    else {
                        $CustomerDashboardInfoTile->{ $Key . 'TimeStamp' } = '';
                    }
                }

                my $Access = $CustomerDashboardInfoTileObject->InfoTilePermission(
                    Type   => 'rw',
                    ID     => $CustomerDashboardInfoTile->{ID},
                    UserID => $Self->{UserID}
                );

                if ($Access) {

                    # create blocks
                    $LayoutObject->Block(
                        Name => 'ViewRow',
                        Data => {
                            %{$CustomerDashboardInfoTile},
                        },
                    );
                }
            }
        }

        # generate output
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ( ( $ParamObject->GetParam( Param => 'Notification' ) || '' ) eq 'Update' ) {
            $Output .= $LayoutObject->Notify(
                Info => Translatable('Info tile entry was updated successfully!')
            );
        }
        elsif ( ( $ParamObject->GetParam( Param => 'Notification' ) || '' ) eq 'Add' ) {
            $Output .= $LayoutObject->Notify(
                Info => Translatable('Info tile entry was added successfully!')
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerDashboardInfoTile',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $GroupObject   = $Kernel::OM->Get('Kernel::System::Group');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # get CustomerDashboardInfoTile information
    my $CustomerDashboardInfoTileData = $Param{CustomerDashboardInfoTileData} || {};

    my %TimeConfig;
    for my $Prefix (qw(StartDate StopDate)) {

        # time setting if available
        if (
            $CustomerDashboardInfoTileData->{$Prefix}
            && $CustomerDashboardInfoTileData->{$Prefix}
            =~ m{^(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)$}xi
            )
        {
            $TimeConfig{$Prefix}->{ $Prefix . 'Year' }   = $1;
            $TimeConfig{$Prefix}->{ $Prefix . 'Month' }  = $2;
            $TimeConfig{$Prefix}->{ $Prefix . 'Day' }    = $3;
            $TimeConfig{$Prefix}->{ $Prefix . 'Hour' }   = $4;
            $TimeConfig{$Prefix}->{ $Prefix . 'Minute' } = $5;
            $TimeConfig{$Prefix}->{ $Prefix . 'Second' } = $6;
        }
    }

    # start date info
    $Param{StartDateString} = $LayoutObject->BuildDateSelection(
        %{$CustomerDashboardInfoTileData},
        %{ $TimeConfig{StartDate} },
        Prefix            => 'StartDate',
        Format            => 'DateInputFormatLong',
        YearPeriodPast    => 0,
        YearPeriodFuture  => 10,
        StartDateClass    => $Param{StartDateInvalid} || ' ',
        StartDateOptional => 1,
        StartDateUsed     => $CustomerDashboardInfoTileData->{StartDateUsed} || 0,
    );

    # stop date info
    $Param{StopDateString} = $LayoutObject->BuildDateSelection(
        %{$CustomerDashboardInfoTileData},
        %{ $TimeConfig{StopDate} },
        Prefix           => 'StopDate',
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 10,
        StopDateClass    => $Param{StopDateInvalid} || ' ',
        StopDateOptional => 1,
        StopDateUsed     => $CustomerDashboardInfoTileData->{StopDateUsed} || 0,
    );

    # group selection
    my %GroupList;
    if ( $Self->{LightAdmin} ) {
        %GroupList = $GroupObject->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'rw',
        );
        $Param{GroupSelectionMandatory} = 'Mandatory';
    }
    else {
        %GroupList = $GroupObject->GroupList();
    }

    my @Selected;
    if ( $CustomerDashboardInfoTileData->{Groups} ) {
        @Selected = split /,/, $CustomerDashboardInfoTileData->{Groups};
    }
    else {

    }

    my $GroupSelectionClass;
    if ( $Self->{LightAdmin} ) {
        $GroupSelectionClass = 'Modernize Validate_Required ' . ( $Param{GroupSelectionServerError} || '' );
    }
    else {
        $GroupSelectionClass = 'Modernize ' . ( $Param{GroupSelectionServerError} || '' );
    }

    $Param{GroupSelection} = $LayoutObject->BuildSelection(
        Data       => \%GroupList,
        Name       => 'Groups',
        Class      => $GroupSelectionClass,
        Multiple   => 1,
        SelectedID => \@Selected,
    );

    $LayoutObject->SetRichTextParameters(
        Data => \%Param,
    );

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $CustomerDashboardInfoTileData->{ValidID} || 1,
        Class      => 'Modernize Validate_Required ' . ( $Param{ValidIDServerError} || '' ),
    );

    if (
        defined $CustomerDashboardInfoTileData->{ShowLoginMessage}
        && $CustomerDashboardInfoTileData->{ShowLoginMessage} == '1'
        )
    {
        $Param{Checked} = 'checked="checked"';
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $LayoutObject->Notify(
                %{$Notification},
            );
        }
    }

    # get all sessions
    my @List     = $SessionObject->GetAllSessionIDs();
    my $Table    = '';
    my $Counter  = @List;
    my %MetaData = ();
    my @UserSessions;
    $MetaData{UserSession}         = 0;
    $MetaData{CustomerSession}     = 0;
    $MetaData{UserSessionUniq}     = 0;
    $MetaData{CustomerSessionUniq} = 0;

    if ( $Param{Action} eq 'Edit' ) {

        for my $SessionID (@List) {
            my $List = '';
            my %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );
            if ( $Data{UserType} && $Data{UserLogin} ) {
                $MetaData{"$Data{UserType}Session"}++;
                if ( !$MetaData{"$Data{UserLogin}"} ) {
                    $MetaData{"$Data{UserType}SessionUniq"}++;
                    $MetaData{"$Data{UserLogin}"} = 1;
                }
            }

            $Data{UserType} = 'Agent' if ( !$Data{UserType} || $Data{UserType} ne 'Customer' );

            # store data to be used later for showing a users session table
            push @UserSessions, {
                SessionID     => $SessionID,
                UserFirstname => $Data{UserFirstname},
                UserLastname  => $Data{UserLastname},
                UserFullname  => $Data{UserFullname},
                UserType      => $Data{UserType},
            };
        }

        # show users session table
        for my $UserSession (@UserSessions) {

            # create blocks
            $LayoutObject->Block(
                Name => $UserSession->{UserType} . 'Session',
                Data => {
                    %{$UserSession},
                    %Param,
                },
            );
        }

        # no customer sessions found
        if ( !$MetaData{CustomerSession} ) {

            $LayoutObject->Block(
                Name => 'CustomerNoDataRow',
            );
        }

        # no agent sessions found
        if ( !$MetaData{UserSession} ) {

            $LayoutObject->Block(
                Name => 'AgentNoDataRow',
            );
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminCustomerDashboardInfoTile$Param{Action}",
        Data         => {
            Counter => $Counter,
            %Param,
            %{$CustomerDashboardInfoTileData},
            %MetaData
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters from web browser
    for my $ParamName (
        qw(
        ID Name Content MarqueeContent ValidID )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName );
    }

    # date handling: check if dates are used
    for my $Prefix (qw(Start Stop)) {
        if ( $ParamObject->GetParam( Param => $Prefix . "DateUsed" ) ) {
            for my $Item (qw(Year Month Day Hour Minute Used)) {
                $GetParam->{ $Prefix . "Date" . $Item } = $ParamObject->GetParam( Param => $Prefix . "Date" . $Item );
            }
        }
        else {
            $GetParam->{ $Prefix . 'DateUsed' } = $ParamObject->GetParam( Param => $Prefix . 'DateUsed' );
        }
    }

    my @Groups = $ParamObject->GetArray( Param => 'Groups' );

    if (@Groups) {
        $GetParam->{Groups} = join ',', @Groups;
    }

    $Param{ShowLoginMessage} ||= 0;

    ITEM:
    for my $Item (qw(StartDate StopDate)) {
        if ( $GetParam->{ $Item . "Used" } ) {

            my %DateStructure;

            # check needed stuff
            PERIOD:
            for my $Period (qw(Year Month Day Hour Minute)) {

                if ( !defined $GetParam->{ $Item . $Period } ) {
                    $Param{Error}->{ $Item . 'Invalid' } = 'ServerError';
                    next ITEM;
                }

                $DateStructure{$Period} = $GetParam->{ $Item . $Period };
            }

            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    %DateStructure,
                    TimeZone => $Self->{UserTimeZone},
                },
            );
            if ( !$DateTimeObject ) {
                $Param{Error}->{ $Item . 'Invalid' } = 'ServerError';
                next ITEM;
            }

            $GetParam->{$Item} = $DateTimeObject->ToEpoch();
            $GetParam->{ $Item . 'TimeStamp' } = $DateTimeObject->ToString();
        }
        else {
            $GetParam->{$Item} = '';
            $GetParam->{ $Item . 'TimeStamp' } = '';
        }
    }

    return $GetParam;
}

1;
