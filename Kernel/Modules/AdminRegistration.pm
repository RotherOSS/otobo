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

package Kernel::Modules::AdminRegistration;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

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

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if cloud services are disabled
    my $CloudServicesDisabled = $ConfigObject->Get('CloudServices::Disabled') || 0;

    # define parameter for breadcrumb during system registration
    my $WithoutBreadcrumb;

    if ($CloudServicesDisabled) {

        my $Output = $LayoutObject->Header(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'CloudServicesDisabled',
            Data         => \%Param
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    # if system is not yet registered, sub-action should be 'register'
    if ( $RegistrationState ne 'registered' ) {

        $Self->{Subaction} ||= 'OTOBOIDValidate';

        # sub-action can't be 'Deregister' or UpdateNow
        if ( $Self->{Subaction} eq 'Deregister' || $Self->{Subaction} eq 'UpdateNow' ) {
            $Self->{Subaction} = 'OTOBOIDValidate';
        }

        # during system registration, don't create breadcrumb item 'Validate OTOBO-ID'
        $WithoutBreadcrumb = 1 if $Self->{Subaction} eq 'OTOBOIDValidate';
    }

    # get needed objects
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $RegistrationObject = $Kernel::OM->Get('Kernel::System::Registration');

    # ------------------------------------------------------------ #
    # Daemon not running screen
    # ------------------------------------------------------------ #
    if (
        $Self->{Subaction} ne 'OTOBOIDValidate'
        && $RegistrationState ne 'registered'
        && !$Self->_DaemonRunning()
        )
    {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'DaemonNotRunning',
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # check OTOBO ID
    # ------------------------------------------------------------ #

    elsif ( $Self->{Subaction} eq 'CheckOTOBOID' ) {

        my $OTOBOID  = $ParamObject->GetParam( Param => 'OTOBOID' )  || '';
        my $Password = $ParamObject->GetParam( Param => 'Password' ) || '';

        my %Response = $RegistrationObject->TokenGet(
            OTOBOID  => $OTOBOID,
            Password => $Password,
        );

        # redirect to next page on success
        if ( $Response{Token} ) {
            my $NextAction = $RegistrationState ne 'registered' ? 'Register' : 'Deregister';
            return $LayoutObject->Redirect(
                OP => "Action=AdminRegistration;Subaction=$NextAction;Token="
                    . $LayoutObject->LinkEncode( $Response{Token} )
                    . ';OTOBOID='
                    . $LayoutObject->LinkEncode($OTOBOID),
            );
        }

        # redirect to current screen with error message
        my %Result = (
            Success => $Response{Success} ? 'OK' : 'False',
            Message => $Response{Reason} || '',
            Token   => $Response{Token}  || '',
        );

        my $Output = $LayoutObject->Header();
        $Output .= $Response{Reason}
            ? $LayoutObject->Notify(
                Priority => 'Error',
                Info     => $Response{Reason},
            )
            : '';
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'OTOBOIDValidation',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'OTOBOIDValidationForm',
            Data => \%Param,
        );

        my $Block = $RegistrationState ne 'registered'
            ? 'OTOBOIDRegistration'
            : 'OTOBOIDDeregistration';

        $LayoutObject->Block(
            Name => $Block,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # OTOBO ID validation
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'OTOBOIDValidate' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
                Subaction => $WithoutBreadcrumb ? '' : $Self->{Subaction},
            },
        );

        my $EntitlementStatus = 'forbidden';

        $LayoutObject->Block(
            Name => 'OTOBOIDValidation',
            Data => \%Param,
        );

        # check if the daemon is not running
        if ( $RegistrationState ne 'registered' && !$Self->_DaemonRunning() ) {

            $LayoutObject->Block(
                Name => 'OTOBOIDValidationDaemonNotRunning',
            );
        }
        else {

            $LayoutObject->Block(
                Name => 'OTOBOIDValidationForm',
                Data => \%Param,
            );
        }

        my $Block = $RegistrationState ne 'registered' ? 'OTOBOIDRegistration' : 'OTOBOIDDeregistration';
        $LayoutObject->Block(
            Name => $Block,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => {%Param},
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # registration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Register' ) {

        my %GetParam;
        $GetParam{Token}   = $ParamObject->GetParam( Param => 'Token' );
        $GetParam{OTOBOID} = $ParamObject->GetParam( Param => 'OTOBOID' );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
                Subaction => $Self->{Subaction},
            },
        );

        $Param{SystemTypeOption} = $LayoutObject->BuildSelection(
            Data => {
                Production  => Translatable('Production'),
                Test        => Translatable('Test'),
                Training    => Translatable('Training'),
                Development => Translatable('Development'),
            },
            PossibleNone  => 1,
            Name          => 'Type',
            SelectedValue => $Param{SystemType},
            Class         => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
        );

        my $EnvironmentObject = $Kernel::OM->Get('Kernel::System::Environment');
        my %OSInfo            = $EnvironmentObject->OSInfoGet();
        my %DBInfo            = $EnvironmentObject->DBInfoGet();

        $LayoutObject->Block(
            Name => 'Registration',
            Data => {
                FQDN         => $ConfigObject->Get('FQDN'),
                OTOBOVersion => $ConfigObject->Get('Version'),
                PerlVersion  => sprintf( "%vd", $^V ),
                %Param,
                %GetParam,
                %OSInfo,
                %DBInfo,
            },
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # deregistration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Deregister' ) {

        my %GetParam;
        $GetParam{Token}   = $ParamObject->GetParam( Param => 'Token' );
        $GetParam{OTOBOID} = $ParamObject->GetParam( Param => 'OTOBOID' );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
                Subaction => $Self->{Subaction},
            }
        );

        $LayoutObject->Block(
            Name => 'Deregistration',
            Data => \%GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
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

        my ( %GetParam, %Errors );
        for my $Parameter (qw(SupportDataSending Type Description OTOBOID Token)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Type)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            $RegistrationObject->Register(
                Token              => $GetParam{Token},
                OTOBOID            => $GetParam{OTOBOID},
                SupportDataSending => $GetParam{SupportDataSending} || 'No',
                Type               => $GetParam{Type},
                Description        => $GetParam{Description},
            );

            return $LayoutObject->Redirect(
                OP => 'Action=AdminRegistration',
            );
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # edit screen
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Edit' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
                Subaction => $Self->{Subaction},
            }
        );

        my %RegistrationData = $RegistrationObject->RegistrationDataGet();

        $Param{Description} //= $RegistrationData{Description};

        $Param{SystemTypeOption} = $LayoutObject->BuildSelection(
            Data => {
                Production  => Translatable('Production'),
                Test        => Translatable('Test'),
                Training    => Translatable('Training'),
                Development => Translatable('Development'),
            },
            PossibleNone  => 1,
            Name          => 'Type',
            SelectedValue => $Param{Type} // $RegistrationData{Type},
            Class         => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
        );

        # fall-back for support data sending switch
        if ( !defined $RegistrationData{SupportDataSending} ) {
            $RegistrationData{SupportDataSending} = 'No';
        }

        # check SupportDataSending if it is enable
        $Param{SupportDataSendingChecked} = '';
        if ( $RegistrationData{SupportDataSending} eq 'Yes' ) {
            $Param{SupportDataSendingChecked} = 'checked="checked"';
        }

        $LayoutObject->Block(
            Name => 'Edit',
            Data => {
                FQDN         => $ConfigObject->Get('FQDN'),
                OTOBOVersion => $ConfigObject->Get('Version'),
                PerlVersion  => sprintf( "%vd", $^V ),
                %Param,
            },
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # edit action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $RegistrationType   = $ParamObject->GetParam( Param => 'Type' );
        my $Description        = $ParamObject->GetParam( Param => 'Description' );
        my $SupportDataSending = $ParamObject->GetParam( Param => 'SupportDataSending' ) || 'No';

        my %Result = $RegistrationObject->RegistrationUpdateSend(
            Type               => $RegistrationType,
            Description        => $Description,
            SupportDataSending => $SupportDataSending,
        );

        # log change
        if ( $Result{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  =>
                    "System Registration: User $Self->{UserID} changed Description: '$Description', Type: '$RegistrationType'.",
            );

        }

        return $LayoutObject->Redirect(
            OP => 'Action=AdminRegistration',
        );
    }

    # ------------------------------------------------------------ #
    # deregister action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeregisterAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $RegistrationObject->Deregister(
            OTOBOID => $ParamObject->GetParam( Param => 'OTOBOID' ),
            Token   => $ParamObject->GetParam( Param => 'Token' ),
        );

        return $LayoutObject->Redirect(
            OP => 'Action=Admin',
        );
    }

    # ------------------------------------------------------------ #
    # sent data overview
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SentDataOverview' ) {
        return $Self->_SentDataOverview();
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        my %RegistrationData = $RegistrationObject->RegistrationDataGet();

        $Self->_Overview(
            %RegistrationData,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRegistration',
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

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderNew' );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionUpdate' );
    $LayoutObject->Block( Name => 'ActionSentDataOverview' );
    $LayoutObject->Block( Name => 'ActionDeregister' );

    $LayoutObject->Block(
        Name => 'OverviewRegistered',
        Data => \%Param,
    );

    return 1;
}

sub _SentDataOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            %Param,
            Subaction => 'SentDataOverview',
        }
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    my %RegistrationData = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationDataGet();

    $LayoutObject->Block(
        Name => 'SentDataOverview',
    );

    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    if ( $RegistrationState ne 'registered' ) {
        $LayoutObject->Block( Name => 'SentDataOverviewNoData' );
    }
    else {
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my %OSInfo       = $Kernel::OM->Get('Kernel::System::Environment')->OSInfoGet();
        my %System       = (
            PerlVersion        => sprintf( "%vd", $^V ),
            OSType             => $OSInfo{OS},
            OSVersion          => $OSInfo{OSName},
            OTOBOVersion       => $ConfigObject->Get('Version'),
            FQDN               => $ConfigObject->Get('FQDN'),
            DatabaseVersion    => $Kernel::OM->Get('Kernel::System::DB')->Version(),
            SupportDataSending => $Param{SupportDataSending} || $RegistrationData{SupportDataSending} || 'No',
        );
        my $RegistrationUpdateDataDump = $Kernel::OM->Get('Kernel::System::Main')->Dump( \%System );

        my $SupportDataDump;
        if ( $System{SupportDataSending} eq 'Yes' ) {
            my %SupportData = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect();
            $SupportDataDump = $Kernel::OM->Get('Kernel::System::Main')->Dump( $SupportData{Result} );
        }

        $LayoutObject->Block(
            Name => 'SentDataOverviewData',
            Data => {
                RegistrationUpdate => $RegistrationUpdateDataDump,
                SupportData        => $SupportDataDump,
            },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminRegistration',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _DaemonRunning {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get the NodeID from the SysConfig settings, this is used on High Availability systems.
    my $NodeID = $ConfigObject->Get('NodeID') || 1;

    # get running daemon cache
    my $Running = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'DaemonRunning',
        Key  => $NodeID,
    );

    return $Running;
}

1;
