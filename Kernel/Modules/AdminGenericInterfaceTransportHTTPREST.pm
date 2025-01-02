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

package Kernel::Modules::AdminGenericInterfaceTransportHTTPREST;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    # Set possible values handling strings.
    $Self->{EmptyString}     = '_AdditionalHeaders_EmptyString_Dont_Use_It_String_Please';
    $Self->{DuplicateString} = '_AdditionalHeaders_DuplicatedString_Dont_Use_It_String_Please';
    $Self->{DeletedString}   = '_AdditionalHeaders_DeletedString_Dont_Use_It_String_Please';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject      = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $WebserviceID      = $ParamObject->GetParam( Param => 'WebserviceID' )      || '';
    my $CommunicationType = $ParamObject->GetParam( Param => 'CommunicationType' ) || '';

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        # Check for WebserviceID.
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need WebserviceID!'),
            );
        }

        # Get web service configuration.
        my $WebserviceData = $WebserviceObject->WebserviceGet( ID => $WebserviceID );

        # Check for valid web service configuration.
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
            );
        }

        return $Self->_ShowEdit(
            %Param,
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
            Action            => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # invalid sub-action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} ne 'ChangeAction' ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need valid Subaction!'),
        );
    }

    # ------------------------------------------------------------ #
    # sub-action ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #

    # Challenge token check for write action.
    $LayoutObject->ChallengeTokenCheck();

    # Check for WebserviceID.
    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    # Get web service configuration.
    my $WebserviceData = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # Check for valid web service configuration.
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    # Get parameter from web browser.
    my $GetParam = $Self->_GetParams();

    # Check required parameters.
    my %Error;

    # To store the clean new configuration locally.
    my $TransportConfig;

    # Get requester specific settings.
    if ( $CommunicationType eq 'Requester' ) {

        NEEDED:
        for my $Needed (qw( Host DefaultCommand Timeout )) {
            $TransportConfig->{$Needed} = $GetParam->{$Needed};
            next NEEDED if defined $GetParam->{$Needed};

            $Error{ $Needed . 'ServerError' }        = 'ServerError';
            $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
        }

        # Set error for non integer content.
        if ( $GetParam->{Timeout} && !IsInteger( $GetParam->{Timeout} ) ) {
            $Error{TimeoutServerError}        = 'ServerError';
            $Error{TimeoutServerErrorMessage} = Translatable('This field should be an integer.');
        }

        # Check authentication options.
        if ( $GetParam->{AuthType} && $GetParam->{AuthType} eq 'BasicAuth' ) {

            # Get BasicAuth settings.
            for my $ParamName (qw( AuthType BasicAuthUser BasicAuthPassword )) {
                $TransportConfig->{Authentication}->{$ParamName} = $GetParam->{$ParamName};
            }
            NEEDED:
            for my $Needed (qw( BasicAuthUser BasicAuthPassword )) {
                next NEEDED if defined $GetParam->{$Needed} && length $GetParam->{$Needed};

                $Error{ $Needed . 'ServerError' }        = 'ServerError';
                $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
            }
        }
        elsif ( $GetParam->{AuthType} && $GetParam->{AuthType} eq 'Kerberos' ) {

            # Get BasicAuth settings.
            for my $ParamName (qw( AuthType KerberosUser KerberosKeytab )) {
                $TransportConfig->{Authentication}->{$ParamName} = $GetParam->{$ParamName};
            }
            NEEDED:
            for my $Needed (qw( KerberosUser KerberosKeytab )) {
                next NEEDED if defined $GetParam->{$Needed} && length $GetParam->{$Needed};

                $Error{ $Needed . 'ServerError' }        = 'ServerError';
                $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
            }
        }

        # Check proxy options.
        if ( $GetParam->{UseProxy} && $GetParam->{UseProxy} eq 'Yes' ) {

            # Get Proxy settings.
            for my $ParamName (qw( UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude )) {
                $TransportConfig->{Proxy}->{$ParamName} = $GetParam->{$ParamName};
            }
        }

        # Check SSL options.
        if ( $GetParam->{UseSSL} && $GetParam->{UseSSL} eq 'Yes' ) {

            # Get SSL authentication settings.
            for my $ParamName (qw( UseSSL SSLPassword SSLVerifyHostname SSLVerifyMode )) {
                $TransportConfig->{SSL}->{$ParamName} = $GetParam->{$ParamName};
            }
            PARAMNAME:
            for my $ParamName (qw( SSLCertificate SSLKey SSLCAFile SSLCADir )) {
                $TransportConfig->{SSL}->{$ParamName} = $GetParam->{$ParamName};

                # Check if file/directory exists and is accessible.
                next PARAMNAME if !$GetParam->{$ParamName};
                if ( $ParamName eq 'SSLCADir' ) {
                    next PARAMNAME if -d $GetParam->{$ParamName};
                }
                else {
                    next PARAMNAME if -f $GetParam->{$ParamName};
                }
                $Error{ $ParamName . 'ServerError' }        = 'ServerError';
                $Error{ $ParamName . 'ServerErrorMessage' } = Translatable('File or Directory not found.');
            }
        }

        my $Invokers = $WebserviceData->{Config}->{$CommunicationType}->{Invoker};

        if ( IsHashRefWithData($Invokers) ) {

            INVOKER:
            for my $CurrentInvoker ( sort keys %{$Invokers} ) {

                my $Controller = $ParamObject->GetParam(
                    Param => 'InvokerControllerMapping' . $CurrentInvoker,
                );

                if ( !$Controller ) {
                    $Error{ 'InvokerControllerMapping' . $CurrentInvoker . 'ServerError' } = 'ServerError';
                    $Error{
                        'InvokerControllerMapping'
                            . $CurrentInvoker
                            . 'ServerErrorMessage'
                    } = Translatable('This field is required');
                    next INVOKER;
                }

                $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Controller} = $Controller;

                my $Command = $ParamObject->GetParam(
                    Param => 'Command' . $CurrentInvoker
                );
                next INVOKER if !$Command;

                $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Command} = $Command;
            }
        }
    }

    # Get provider specific settings.
    else {

        NEEDED:
        for my $Needed (qw( MaxLength KeepAlive )) {
            $TransportConfig->{$Needed} = $GetParam->{$Needed};
            next NEEDED if defined $GetParam->{$Needed};

            $Error{ $Needed . 'ServerError' }        = 'ServerError';
            $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
        }

        # Set error for non integer content.
        if ( $GetParam->{MaxLength} && !IsInteger( $GetParam->{MaxLength} ) ) {
            $Error{MaxLengthServerError}        = 'ServerError';
            $Error{MaxLengthServerErrorMessage} = Translatable('This field should be an integer.');
        }

        my $Operations = $WebserviceData->{Config}->{$CommunicationType}->{Operation};

        if ( IsHashRefWithData($Operations) ) {

            OPERATION:
            for my $CurrentOperation ( sort keys %{$Operations} ) {

                my $Route = $ParamObject->GetParam(
                    Param => 'RouteOperationMapping' . $CurrentOperation,
                );

                if ( !$Route ) {
                    $Error{ 'RouteOperationMapping' . $CurrentOperation . 'ServerError' }        = 'ServerError';
                    $Error{ 'RouteOperationMapping' . $CurrentOperation . 'ServerErrorMessage' } = Translatable('This field is required');
                    next OPERATION;
                }

                $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{Route} = $Route;

                my @RequestMethod = $ParamObject->GetArray(
                    Param => 'RequestMethod' . $CurrentOperation,
                );
                next OPERATION if !scalar @RequestMethod;

                $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{RequestMethod} = \@RequestMethod;
            }
        }

        # Get additional headers.
        $TransportConfig->{AdditionalHeaders} = $Self->_GetAdditionalHeaders();
    }

    my $OperationType = $CommunicationType eq 'Requester' ? 'Invoker' : 'Operation';

    # Get operations with (potential) specific headers.
    my @OperationOutboundHeaders = $ParamObject->GetArray( Param => 'OperationOutboundHeadersActive' );

    # Create lookup for MD5 operation names.
    my %OperationMD5Lookup;
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    for my $Operation ( sort keys %{ $WebserviceData->{Config}{$CommunicationType}{$OperationType} // {} } ) {
        my $OperationMD5 = $MainObject->MD5sum(
            String => \$Operation,
        );
        $OperationMD5Lookup{$OperationMD5} = $Operation;
    }

    # Get common and operation specific headers.
    my @HeaderBlacklist = @{ $Kernel::OM->Get('Kernel::Config')->Get( 'GenericInterface::' . $OperationType . '::OutboundHeaderBlacklist' ) // [] };

    my %ErrorHeaders;
    my %Headers;
    OPERATION:
    for my $Operation ( '', @OperationOutboundHeaders ) {

        my $ValueCounter = $ParamObject->GetParam(
            Param => 'OutboundHeaders' . $Operation . 'ValueCounter'
        );

        next OPERATION if !$ValueCounter;

        my %UsedKeys;
        my $ErrorValueCounter = 0;
        INDEX:
        for my $Index ( 1 .. $ValueCounter ) {

            my $KeyParam   = 'OutboundHeaders' . $Operation . 'Key_' . $Index;
            my $ValueParam = 'OutboundHeaders' . $Operation . 'Value_' . $Index;

            # Skip deleted entries.
            if (
                !defined $ParamObject->GetParam( Param => $KeyParam )
                && !defined $ParamObject->GetParam( Param => $ValueParam )
                )
            {
                next INDEX;
            }
            else {
                ++$ErrorValueCounter;
            }

            my $KeyErrorParam   = 'OutboundHeaders' . $Operation . 'Key_' . $ErrorValueCounter;
            my $ValueErrorParam = 'OutboundHeaders' . $Operation . 'Value_' . $ErrorValueCounter;
            my $Key             = $ParamObject->GetParam( Param => $KeyParam )   // '';
            my $Value           = $ParamObject->GetParam( Param => $ValueParam ) // '';

            # Remember values for edit screen (in case of errors).
            if ($Operation) {
                push @{ $ErrorHeaders{Specific}{$Operation} },
                    {
                        Key   => $Key,
                        Value => $Value,
                    };
            }
            else {
                push @{ $ErrorHeaders{Common} },
                    {
                        Key   => $Key,
                        Value => $Value,
                    };
            }

            # Duplicate key detection.
            if ($Key) {
                if ( $UsedKeys{$Key} ) {
                    $Error{ $KeyErrorParam . 'ServerError' }        = 'ServerError';
                    $Error{ $KeyErrorParam . 'ServerErrorMessage' } = Translatable('This key is already used');
                }
                elsif ( grep { $_ eq $Key } @HeaderBlacklist ) {
                    $Error{ $KeyErrorParam . 'ServerError' }        = 'ServerError';
                    $Error{ $KeyErrorParam . 'ServerErrorMessage' } = Translatable('This key is not allowed');
                }
                else {
                    $UsedKeys{$Key} = 1;
                }
            }

            # Empty key.
            else {
                $Error{ $KeyErrorParam . 'ServerError' }        = 'ServerError';
                $Error{ $KeyErrorParam . 'ServerErrorMessage' } = Translatable('This field is required');
            }

            if ( !IsStringWithData($Value) ) {
                $Error{ $ValueErrorParam . 'ServerError' }        = 'ServerError';
                $Error{ $ValueErrorParam . 'ServerErrorMessage' } = Translatable('This field is required');
            }

            next INDEX
                if $Error{ $KeyErrorParam . 'ServerError' }
                || $Error{ $ValueErrorParam . 'ServerError' };

            # Operation specific header
            if ($Operation) {
                $Headers{Specific}{ $OperationMD5Lookup{$Operation} }->{$Key} = $Value;
                next INDEX;
            }

            # Common headers
            $Headers{Common}{$Key} = $Value;
        }
    }
    $TransportConfig->{OutboundHeaders} = \%Headers;

    # Set new configuration.
    $WebserviceData->{Config}{$CommunicationType}{Transport}{Config} = $TransportConfig;

    # If there is an error return to edit screen.
    if ( IsHashRefWithData( \%Error ) ) {
        return $Self->_ShowEdit(
            %Error,
            %Param,
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
            Action            => 'Change',
        );
    }

    # Otherwise save configuration and return to overview screen.
    my $Success = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $WebserviceData->{Name},
        Config  => $WebserviceData->{Config},
        ValidID => $WebserviceData->{ValidID},
        UserID  => $Self->{UserID},
    );

    # If the user would like to continue editing the transport config, just redirect to the edit screen.
    if (
        defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
        && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
        )
    {
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=Change;WebserviceID=$WebserviceID;CommunicationType=$CommunicationType;",
        );
    }
    else {

        # Otherwise return to overview.
        return $LayoutObject->Redirect(
            OP => "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;",
        );
    }
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $Param{Type}           = 'HTTP::REST';
    $Param{WebserviceName} = $Param{WebserviceData}->{Name};
    my $TransportConfig = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config};

    # Extract display parameters from transport config.
    for my $ParamName (
        qw(
            Host DefaultCommand KeepAlive MaxLength Timeout
            AdditionalHeaders
        )
        )
    {
        $Param{$ParamName} = $TransportConfig->{$ParamName};
    }
    for my $ParamName (qw( AuthType BasicAuthUser BasicAuthPassword KerberosUser KerberosKeytab )) {
        $Param{$ParamName} = $TransportConfig->{Authentication}->{$ParamName};
    }
    for my $ParamName (qw( UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir SSLVerifyHostname SSLVerifyMode )) {
        $Param{$ParamName} = $TransportConfig->{SSL}->{$ParamName};
    }
    for my $ParamName (qw( UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude )) {
        $Param{$ParamName} = $TransportConfig->{Proxy}->{$ParamName};
    }

    my @PossibleRequestMethods = qw(GET POST PUT PATCH DELETE HEAD OPTIONS CONNECT TRACE);

    # Check if communication type is requester.
    if ( $Param{CommunicationType} eq 'Requester' ) {

        # create default command types select
        $Param{DefaultCommandStrg} = $LayoutObject->BuildSelection(
            Data          => \@PossibleRequestMethods,
            Name          => 'DefaultCommand',
            SelectedValue => $Param{DefaultCommand} || 'GET',
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Create Timeout select.
        $Param{TimeoutStrg} = $LayoutObject->BuildSelection(
            Data          => [ '30', '60', '90', '120', '150', '180', '210', '240', '270', '300' ],
            Name          => 'Timeout',
            SelectedValue => $Param{Timeout} || '120',
            Sort          => 'NumericValue',
            Class         => 'Modernize',
        );

        # Create Authentication types select.
        $Param{AuthenticationStrg} = $LayoutObject->BuildSelection(
            Data          => [ 'BasicAuth', 'Kerberos' ],
            Name          => 'AuthType',
            SelectedValue => $Param{AuthType} || '-',
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable authentication methods if they are not selected.
        $Param{BasicAuthHidden} = 'Hidden';
        $Param{KerberosHidden}  = 'Hidden';
        if ( $Param{AuthType} && $Param{AuthType} eq 'BasicAuth' ) {
            $Param{BasicAuthHidden}                   = '';
            $Param{BasicAuthUserServerError}          = 'Validate_Required';
            $Param{BasicAuthPasswordValidateRequired} = 'Validate_Required';
        }
        elsif ( $Param{AuthType} && $Param{AuthType} eq 'Kerberos' ) {
            $Param{KerberosHidden}                 = '';
            $Param{KerberosUserServerError}        = 'Validate_Required';
            $Param{KerberosKeytabValidateRequired} = 'Validate_Required';
        }

        # Create use Proxy select.
        $Param{UseProxyStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'UseProxy',
            SelectedValue => $Param{UseProxy} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Create Proxy exclude select.
        $Param{ProxyExcludeStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'ProxyExclude',
            SelectedValue => $Param{ProxyExclude} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable Proxy options if they are not selected.
        $Param{ProxyHidden} = 'Hidden';
        if ( $Param{UseProxy} && $Param{UseProxy} eq 'Yes' )
        {
            $Param{ProxyHidden} = '';
        }

        # Create use SSL select.
        $Param{UseSSLStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'UseSSL',
            SelectedValue => $Param{UseSSL} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Create noverify_hostname selection.
        $Param{SSLVerifyHostStrg} = $LayoutObject->BuildSelection(
            Data => {
                'Yes' => Translatable('Yes'),
                'No'  => Translatable('No'),
            },
            Name          => 'SSLVerifyHostname',
            SelectedValue => $Param{SSLVerifyHostname} || Translatable('Yes'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Create noverify_mode selection.
        $Param{SSLVerifyModeStrg} = $LayoutObject->BuildSelection(
            Data => {
                'Yes' => Translatable('Yes'),
                'No'  => Translatable('No'),
            },
            Name          => 'SSLVerifyMode',
            SelectedValue => $Param{SSLVerifyMode} || Translatable('Yes'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable SSL options if they are not selected.
        $Param{SSLHidden} = 'Hidden';
        if ( $Param{UseSSL} && $Param{UseSSL} eq 'Yes' )
        {
            $Param{SSLHidden} = '';
        }

        my $Invokers = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Invoker};
        if ( IsHashRefWithData($Invokers) ) {

            for my $CurrentInvoker ( sort keys %{$Invokers} ) {

                my $CommandStrg = $LayoutObject->BuildSelection(
                    Data          => \@PossibleRequestMethods,
                    Name          => 'Command' . $CurrentInvoker,
                    SelectedValue =>
                        $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Command}
                        || '-',
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                    Class        => 'Modernize',
                );

                $LayoutObject->Block(
                    Name => 'InvokerControllerMapping',
                    Data => {
                        Invoker            => $CurrentInvoker,
                        Controller         => $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Controller},
                        CommandStrg        => $CommandStrg,
                        ServerError        => $Param{ 'InvokerControllerMapping' . $CurrentInvoker . 'ServerError' } || '',
                        ServerErrorMessage => $Param{
                            'InvokerControllerMapping'
                                . $CurrentInvoker
                                . 'ServerErrorMessage'
                            }
                            || '',
                    },
                );
            }
        }
    }

    # Check if communication type is requester.
    elsif ( $Param{CommunicationType} eq 'Provider' ) {
        my $Operations = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Operation};
        if ( IsHashRefWithData($Operations) ) {

            for my $CurrentOperation ( sort keys %{$Operations} ) {

                my $RequestMethodStrg = $LayoutObject->BuildSelection(
                    Data          => \@PossibleRequestMethods,
                    Name          => 'RequestMethod' . $CurrentOperation,
                    SelectedValue => $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{RequestMethod}
                        || ['-'],
                    PossibleNone => 1,
                    Multiple     => 1,
                    Sort         => 'AlphanumericValue',
                    Class        => 'Modernize',
                );

                $LayoutObject->Block(
                    Name => 'RouteOperationMapping',
                    Data => {
                        Operation          => $CurrentOperation,
                        Route              => $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{Route},
                        RequestMethodStrg  => $RequestMethodStrg,
                        ServerError        => $Param{ 'RouteOperationMapping' . $CurrentOperation . 'ServerError' } || '',
                        ServerErrorMessage => $Param{
                            'RouteOperationMapping'
                                . $CurrentOperation
                                . 'ServerErrorMessage'
                            }
                            || '',
                    },
                );
            }
        }

        $Param{KeepAliveStrg} = $LayoutObject->BuildSelection(
            Data => {
                0 => Translatable('No'),
                1 => Translatable('Yes'),
            },
            Name         => 'KeepAlive',
            SelectedID   => $Param{KeepAlive} || 0,
            PossibleNone => 0,
            Translation  => 1,
            Class        => 'Modernize',
        );
    }

    # Common params first.
    my @CommonHeaders;
    if ( IsArrayRefWithData( $Param{ErrorHeaders}{Common} ) ) {
        @CommonHeaders = @{ $Param{ErrorHeaders}{Common} };
    }

    # Fallback for previously used 'additional response headers'.
    elsif ( IsHashRefWithData( $TransportConfig->{AdditionalHeaders} ) ) {
        @CommonHeaders = map {
            {
                Key   => $_,
                Value => $TransportConfig->{AdditionalHeaders}{$_}
            }
            }
            sort keys %{ $TransportConfig->{AdditionalHeaders} };
    }
    elsif (
        IsHashRefWithData( $TransportConfig->{OutboundHeaders}{Common} )
        )
    {
        @CommonHeaders = map {
            {
                Key   => $_,
                Value => $TransportConfig->{OutboundHeaders}{Common}{$_}
            }
            }
            sort keys %{ $TransportConfig->{OutboundHeaders}{Common} };
    }

    $Param{OutboundHeadersValueCounter} =
        @CommonHeaders ? scalar @CommonHeaders : 0;

    # Generate params for outbound headers.
    $LayoutObject->Block(
        Name => 'OutboundHeaders',
        Data => { %Param, },
    );

    if (@CommonHeaders) {
        my $ValueCounter = 0;

        for my $Row (@CommonHeaders) {
            $LayoutObject->Block(
                Name => 'OutboundHeadersValueRow',
                Data => {
                    %Param,
                    Key          => $Row->{Key},
                    ValueCounter => ++$ValueCounter,
                    Value        => $Row->{Value},
                },
            );
        }

    }

    # Now operation specific headers.
    my $OperationsForOutboundHeaders;
    if ( $Param{CommunicationType} eq 'Requester' ) {
        $OperationsForOutboundHeaders =
            $Param{WebserviceData}{Config}{Requester}{Invoker};
    }
    else {
        $OperationsForOutboundHeaders =
            $Param{WebserviceData}{Config}{Provider}{Operation};
    }

    my %SpecificHeaders;
    if ( IsHashRefWithData( $Param{ErrorHeaders}{Specific} ) ) {
        %SpecificHeaders = %{ $Param{ErrorHeaders}{Specific} };
    }
    elsif (
        IsHashRefWithData( $TransportConfig->{OutboundHeaders}{Specific} )
        )
    {
        for my $Operation (
            sort keys %{ $TransportConfig->{OutboundHeaders}{Specific} }
            )
        {
            $SpecificHeaders{$Operation} = [
                map {
                    {
                        Key   => $_,
                        Value => $TransportConfig->{OutboundHeaders}{Specific}
                            {$Operation}{$_}
                    }
                }
                    sort keys %{
                        $TransportConfig->{OutboundHeaders}{Specific}
                        {$Operation}
                    }
            ];
        }
    }

    if ( IsHashRefWithData($OperationsForOutboundHeaders) ) {

        $LayoutObject->Block(
            Name => 'OutboundHeadersOperationSpecific',
            Data => { %Param, },
        );

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
        my @SelectionData;
        OPERATION:
        for my $Operation ( sort keys %{$OperationsForOutboundHeaders} ) {
            my $OperationMD5 = $MainObject->MD5sum(
                String => \$Operation,
            );

            my $HaveOperationConfig =
                IsArrayRefWithData( $SpecificHeaders{$Operation} ) ? 1 : 0;

            $LayoutObject->Block(
                Name => 'OutboundHeadersOperationSpecificEntry',
                Data => {
                    Operation => $OperationMD5,
                    Active    => $HaveOperationConfig
                    ? 'HeaderContainerActive'
                    : '',
                },
            );

            if ( !$HaveOperationConfig ) {
                push @SelectionData,
                    {
                        Key   => $OperationMD5,
                        Value => $Operation,
                    };
                next OPERATION;
            }

            push @SelectionData,
                {
                    Key      => $OperationMD5,
                    Value    => $Operation,
                    Disabled => 1,
                };

            my $ValuesUsedCount = @{ $SpecificHeaders{$Operation} };
            $LayoutObject->Block(
                Name => 'OutboundHeadersOperationSpecificEntryValue',
                Data => {
                    Operation     => $OperationMD5,
                    OperationName => $Operation,
                    ValueCounter  => $ValuesUsedCount,
                },
            );

            my $ValueCounter = 0;
            for my $Row ( @{ $SpecificHeaders{$Operation} } ) {
                $LayoutObject->Block(
                    Name => 'OutboundHeadersOperationSpecificEntryValueRow',
                    Data => {
                        %Param,
                        Operation    => $OperationMD5,
                        Key          => $Row->{Key},
                        ValueCounter => ++$ValueCounter,
                        Value        => $Row->{Value},
                    },
                );
            }
        }

        # Generate list of available (unused) operations for outbound header selection.
        $Param{OutboundHeadersOperationSelectionStrg} =
            $LayoutObject->BuildSelection(
                Data         => \@SelectionData,
                Name         => 'OutboundHeadersOperationSelection',
                PossibleNone => 1,
                Class        => 'Modernize',
            );
        $LayoutObject->Block(
            Name => 'OutboundHeadersOperationSelection',
            Data => { %Param, },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceTransportHTTPREST',
        Data         => { %Param, },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $GetParam;

    # Get parameters from web browser.
    for my $ParamName (
        qw(
            Host DefaultCommand MaxLength KeepAlive Timeout
            AuthType CredentialID BasicAuthUser BasicAuthPassword BearerAuthToken
            UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude
            UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir
            SSLVerifyHostname SSLVerifyMode
        )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }
    return $GetParam;
}

sub _GetAdditionalHeaders {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get ValueCounters.
    my $ValueCounter = $ParamObject->GetParam( Param => 'ValueCounter' ) || 0;

    # Get possible values.
    my $AdditionalHeaderConfig;
    VALUEINDEX:
    for my $ValueIndex ( 1 .. $ValueCounter ) {
        my $Key = $ParamObject->GetParam( Param => 'Key' . '_' . $ValueIndex ) // '';

        # Check if key was deleted by the user and skip it.
        next VALUEINDEX if $Key eq $Self->{DeletedString};

        # Skip empty key.
        next VALUEINDEX if $Key eq '';

        my $Value = $ParamObject->GetParam( Param => 'Value' . '_' . $ValueIndex ) // '';
        $AdditionalHeaderConfig->{$Key} = $Value;
    }

    return $AdditionalHeaderConfig;
}

1;
