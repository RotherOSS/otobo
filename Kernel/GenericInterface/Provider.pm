# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

package Kernel::GenericInterface::Provider;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;

# core modules
use Storable;

# CPAN modules
use URI::Escape;
use Plack::Response;

# OTOBO modules
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport;
use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Operation;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(IsHashRefWithData);
use Kernel::System::Web::Exception;

our @ObjectDependencies = (
    'Kernel::GenericInterface::ErrorHandling',
    'Kernel::System::Log',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::GenericInterface::Provider - handler for incoming web service requests.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $Interface = $Kernel::OM->Get('Kernel::GenericInterface::Provider');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # register object params
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Log' => {
            LogPrefix => 'GenericInterfaceProvider',
        },
        'Kernel::System::Web::Request' => {
            PSGIEnv => $Param{PSGIEnv} || 0,
        },
    );

    # start with an empty hash for the new object
    return bless {}, $Type;
}

=head2 Content()

Receives the current incoming web service request, handles it,
and returns an appropriate answer based on the requested web service.
Set headers in Kernels::System::Web::Request singleton as side effect.
Can die and throw an exception to be caught be Plack::Middleware::HTTPExceptions.

    # put this in the handler script
    my $Content = $Interface->Content();

=cut

sub Content {
    my $Self = shift;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $RequestURI = $ParamObject->RequestURI();

    # Locate and verify the desired web service based on the request URI and load its configuration data.

    # Check RequestURI for a web service by id or name.
    my %WebserviceGetData;
    if (
        $RequestURI
        && $RequestURI
        =~ m{ nph-genericinterface[.]pl/ (?: WebserviceID/ (?<ID> \d+ ) | Webservice/ (?<Name> [^/?]+ ) ) }smx
        )
    {
        %WebserviceGetData = (
            ID   => $+{ID},
            Name => $+{Name} ? URI::Escape::uri_unescape( $+{Name} ) : undef,
        );
    }

    # URI is empty or invalid.
    if ( ! %WebserviceGetData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine WebserviceID or Webservice from query string '$RequestURI'",
        );

        # generate status 500 response under PSGI
        # otherwise return undef and Apache will generate 500 Error
        return $Self->_ThrowWebException();
    }

    # Check if requested web service exists and is valid.
    my $WebserviceObject      = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $WebserviceList        = $WebserviceObject->WebserviceList();
    my %WebserviceListReverse = reverse %{$WebserviceList};
    if (
        $WebserviceGetData{Name}  && !$WebserviceListReverse{ $WebserviceGetData{Name} }
        || $WebserviceGetData{ID} && !$WebserviceList->{ $WebserviceGetData{ID} }
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not find valid web service for query string '$RequestURI'",
        );

        # generate status 500 response under PSGI
        # otherwise return undef and Apache will generate 500 Error
        return $Self->_ThrowWebException();
    }

    my $Webservice = $WebserviceObject->WebserviceGet(%WebserviceGetData);
    if ( !IsHashRefWithData($Webservice) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "Could not load web service configuration for query string '$RequestURI'",
        );

        # generate status 500 response under PSGI
        # otherwise return undef and Apache will generate 500 Error
        return $Self->_ThrowWebException();
    }

    # Create a debugger instance which will log the details of this communication entry.
    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig    => $Webservice->{Config}->{Debugger},
        WebserviceID      => $Webservice->{ID},
        CommunicationType => 'Provider',
        RemoteIP          => $ParamObject->RemoteAddr(),
    );

    if ( ref $DebuggerObject ne 'Kernel::GenericInterface::Debugger' ) {

        # generate status 500 response under PSGI
        # otherwise return undef and Apache will generate 500 Error
        return $Self->_ThrowWebException();
    }

    $DebuggerObject->Debug(
        Summary => 'Communication sequence started',
        Data    => \%ENV,
    );

    #
    # Create the network transport backend and read the network request.
    #

    my $ProviderConfig = $Webservice->{Config}->{Provider};

    $Self->{TransportObject} = Kernel::GenericInterface::Transport->new(
        DebuggerObject  => $DebuggerObject,
        TransportConfig => $ProviderConfig->{Transport},
    );

    # Bail out if transport initialization failed.
    if ( ref $Self->{TransportObject} ne 'Kernel::GenericInterface::Transport' ) {

        $DebuggerObject->Error(
            Summary => 'TransportObject could not be initialized',
            Data    => $Self->{TransportObject},
        );

        # generate status 500 response under PSGI
        # otherwise return undef and Apache will generate 500 Error
        return $Self->_ThrowWebException();
    }

    # Combine all data for error handler we got so far.
    my %HandleErrorData = (
        DebuggerObject   => $DebuggerObject,
        WebserviceID     => $Webservice->{ID},
        WebserviceConfig => $Webservice->{Config},
    );

    # Read request content.
    my $FunctionResult = $Self->{TransportObject}->ProviderProcessRequest();

    # If the request was not processed correctly, send error to client.
    if ( !$FunctionResult->{Success} ) {

        my $Summary = $FunctionResult->{ErrorMessage} // 'TransportObject returned an error, cancelling Request';

        return $Self->_HandleError(
            %HandleErrorData,
            DataInclude => {},
            ErrorStage  => 'ProviderRequestReceive',
            Summary     => $Summary,
            Data        => $FunctionResult->{Data} // $Summary,
        );
    }

    # prepare the data include configuration and payload
    my %DataInclude = (
        ProviderRequestInput => $FunctionResult->{Data},
    );

    my $Operation = $FunctionResult->{Operation};

    $DebuggerObject->Debug(
        Summary => "Detected operation '$Operation'",
    );

    #
    # Map the incoming data based on the configured mapping.
    #

    my $DataIn = $FunctionResult->{Data};

    $DebuggerObject->Debug(
        Summary => "Incoming data before mapping",
        Data    => $DataIn,
    );

    # Decide if mapping needs to be used or not.
    if (
        IsHashRefWithData( $ProviderConfig->{Operation}->{$Operation}->{MappingInbound} )
        )
    {
        my $MappingInObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $DebuggerObject,
            Operation      => $Operation,
            OperationType  => $ProviderConfig->{Operation}->{$Operation}->{Type},
            MappingConfig  =>
                $ProviderConfig->{Operation}->{$Operation}->{MappingInbound},
        );

        # If mapping initialization failed, bail out.
        if ( ref $MappingInObject ne 'Kernel::GenericInterface::Mapping' ) {
            $DebuggerObject->Error(
                Summary => 'MappingIn could not be initialized',
                Data    => $MappingInObject,
            );

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $DebuggerObject,
                ErrorMessage   => $FunctionResult->{ErrorMessage},
            ) // '';
        }

        # add operation to data for error handler
        $HandleErrorData{Operation} = $Operation;

        $FunctionResult = $MappingInObject->Map(
            Data => $DataIn,
        );

        if ( !$FunctionResult->{Success} ) {

            my $Summary = $FunctionResult->{ErrorMessage} // 'MappingInObject returned an error, cancelling Request';

            return $Self->_HandleError(
                %HandleErrorData,
                DataInclude => \%DataInclude,
                ErrorStage  => 'ProviderRequestMap',
                Summary     => $Summary,
                Data        => $FunctionResult->{Data} // $Summary,
            );
        }

        # extend the data include payload
        $DataInclude{ProviderRequestMapOutput} = $FunctionResult->{Data};

        $DataIn = $FunctionResult->{Data};

        $DebuggerObject->Debug(
            Summary => "Incoming data after mapping",
            Data    => $DataIn,
        );
    }

    #
    # Execute actual operation.
    #

    my $OperationObject = Kernel::GenericInterface::Operation->new(
        DebuggerObject => $DebuggerObject,
        Operation      => $Operation,
        OperationType  => $ProviderConfig->{Operation}->{$Operation}->{Type},
        WebserviceID   => $Webservice->{ID},
    );

    # If operation initialization failed, bail out.
    if ( ref $OperationObject ne 'Kernel::GenericInterface::Operation' ) {
        $DebuggerObject->Error(
            Summary => 'Operation could not be initialized',
            Data    => $OperationObject,
        );

        # Set default error message.
        my $ErrorMessage = 'Unknown error in Operation initialization';

        # Check if we got an error message from the operation and overwrite it.
        if ( IsHashRefWithData($OperationObject) && $OperationObject->{ErrorMessage} ) {
            $ErrorMessage = $OperationObject->{ErrorMessage};
        }

        return $Self->_GenerateErrorResponse(
            DebuggerObject => $DebuggerObject,
            ErrorMessage   => $ErrorMessage,
        ) // '';
    }

    # add operation object to data for error handler
    $HandleErrorData{OperationObject} = $OperationObject;

    $FunctionResult = $OperationObject->Run(
        Data => $DataIn,
    );

    if ( !$FunctionResult->{Success} ) {

        my $Summary = $FunctionResult->{ErrorMessage} // 'OperationObject returned an error, cancelling Request';

        return $Self->_HandleError(
            %HandleErrorData,
            DataInclude => \%DataInclude,
            ErrorStage  => 'ProviderRequestProcess',
            Summary     => $Summary,
            Data        => $FunctionResult->{Data} // $Summary,
            HTTPStatus  => $FunctionResult->{HTTPStatus} // 500,
        );
    }

    # extend the data include payload
    $DataInclude{ProviderResponseInput} = $FunctionResult->{Data};

    #
    # Map the outgoing data based on configured mapping.
    #

    my $DataOut = $FunctionResult->{Data};

    $DebuggerObject->Debug(
        Summary => "Outgoing data before mapping",
        Data    => $DataOut,
    );

    # Decide if mapping needs to be used or not.
    if (
        IsHashRefWithData(
            $ProviderConfig->{Operation}->{$Operation}->{MappingOutbound}
        )
        )
    {
        my $MappingOutObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $DebuggerObject,
            Operation      => $Operation,
            OperationType  => $ProviderConfig->{Operation}->{$Operation}->{Type},
            MappingConfig  =>
                $ProviderConfig->{Operation}->{$Operation}->{MappingOutbound},
        );

        # If mapping initialization failed, bail out
        if ( ref $MappingOutObject ne 'Kernel::GenericInterface::Mapping' ) {
            $DebuggerObject->Error(
                Summary => 'MappingOut could not be initialized',
                Data    => $MappingOutObject,
            );

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $DebuggerObject,
                ErrorMessage   => $FunctionResult->{ErrorMessage},
            ) // '';
        }

        $FunctionResult = $MappingOutObject->Map(
            Data        => $DataOut,
            DataInclude => \%DataInclude,
        );

        if ( !$FunctionResult->{Success} ) {

            my $Summary = $FunctionResult->{ErrorMessage} // 'MappingOutObject returned an error, cancelling Request';

            return $Self->_HandleError(
                %HandleErrorData,
                DataInclude => \%DataInclude,
                ErrorStage  => 'ProviderResponseMap',
                Summary     => $Summary,
                Data        => $FunctionResult->{Data} // $Summary,
            );
        }

        # extend the data include payload
        $DataInclude{ProviderResponseMapOutput} = $FunctionResult->{Data};

        $DataOut = $FunctionResult->{Data};

        $DebuggerObject->Debug(
            Summary => "Outgoing data after mapping",
            Data    => $DataOut,
        );
    }

    #
    # Generate the actual response.
    #

    my $Response = $Self->{TransportObject}->ProviderGenerateResponse(
        Success => 1,
        Data    => $DataOut,
        HTTPStatus => $FunctionResult->{HTTPStatus} // 200,
    );

    if ( ! $Response->{Success} ) {

        my $Summary = $FunctionResult->{ErrorMessage} // 'TransportObject returned an error, cancelling Request';

        return $Self->_HandleError(
            %HandleErrorData,
            DataInclude => \%DataInclude,
            ErrorStage  => 'ProviderResponseTransmit',
            Summary     => $Summary,
            Data        => $FunctionResult->{Data} // $Summary,
        );
    }

    return $Response->{Output};
}

=begin Internal:

=head2 _GenerateErrorResponse()

prepares header and content for an error response

    my $Output = $Self->_GenerateErrorResponse(
        DebuggerObject => $DebuggerObject,
        ErrorMessage   => $ErrorMessage,
    ) // '';
    print STDOUT $Output;

=cut

sub _GenerateErrorResponse {
    my ( $Self, %Param ) = @_;

    my $Response = $Self->{TransportObject}->ProviderGenerateResponse(
        Success      => 0,
        ErrorMessage => $Param{ErrorMessage},
        HTTPStatus   => $Param{HTTPStatus},
    );

    if ( !$Response->{Success} ) {
        $Param{DebuggerObject}->Error(
            Summary => 'Error response could not be sent',
            Data    => $Response->{ErrorMessage},
        );
    }

    return $Response->{Output};
}

=head2 _HandleError()

handles errors by
- informing operation about it (if supported)
- calling an error handling layer

    my $Output = $RequesterObject->_HandleError(
        DebuggerObject   => $DebuggerObject,
        WebserviceID     => 1,
        WebserviceConfig => $WebserviceConfig,
        DataInclude      => $DataIncludeStructure,
        ErrorStage       => 'PrepareRequest',        # at what point did the error occur?
        Summary          => 'an error occurred',
        Data             => $ErrorDataStructure,
        OperationObject  => $OperationObject,        # optional
        Operation        => 'OperationName',         # optional
        HTTPStatus       => 400,                     # optional
    );
    print STDOUT $Output;

=cut

sub _HandleError {
    my ( $Self, %Param ) = @_;

    NEEDED:
    for my $Needed (qw(DebuggerObject WebserviceID WebserviceConfig DataInclude ErrorStage Summary Data)) {
        next NEEDED if $Param{$Needed};
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got no $Needed!",
        );

        return $Self->_GenerateErrorResponse(
            DebuggerObject => $Param{DebuggerObject},
            ErrorMessage   => "Got no $Needed!",
        ) // '';
    }

    my $ErrorHandlingResult = $Kernel::OM->Get('Kernel::GenericInterface::ErrorHandling')->HandleError(
        WebserviceID      => $Param{WebserviceID},
        WebserviceConfig  => $Param{WebserviceConfig},
        CommunicationID   => $Param{DebuggerObject}->{CommunicationID},
        CommunicationType => 'Provider',
        CommunicationName => $Param{Operation},
        ErrorStage        => $Param{ErrorStage},
        Summary           => $Param{Summary},
        Data              => $Param{Data},
    );

    if (
        !$Param{Operation}
        || !$Param{OperationObject}
        || !$Param{OperationObject}->{BackendObject}->can('HandleError')
        )
    {
        return $Self->_GenerateErrorResponse(
            DebuggerObject => $Param{DebuggerObject},
            ErrorMessage   => $Param{Summary},
            HTTPStatus     => $Param{HTTPStatus},
        ) // '';
    }

    my $HandleErrorData;
    if ( !defined $Param{Data} || IsString( $Param{Data} ) ) {
        $HandleErrorData = $Param{Data} // '';
    }
    else {
        $HandleErrorData = Storable::dclone( $Param{Data} );
    }
    $Param{DebuggerObject}->Debug(
        Summary => 'Error data before mapping',
        Data    => $HandleErrorData,
    );

    my $OperationConfig = $Param{WebserviceConfig}->{Provider}->{Operation}->{ $Param{Operation} };

    # TODO: use separate mapping config for errors.
    if ( IsHashRefWithData( $OperationConfig->{MappingInbound} ) ) {
        my $MappingErrorObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $Param{DebuggerObject},
            Operation      => $Param{Operation},
            OperationType  => $OperationConfig->{Type},
            MappingConfig  => $OperationConfig->{MappingInbound},
        );

        # If mapping init failed, bail out.
        if ( ref $MappingErrorObject ne 'Kernel::GenericInterface::Mapping' ) {
            $Param{DebuggerObject}->Error(
                Summary => 'MappingErr could not be initialized',
                Data    => $MappingErrorObject,
            );

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $Param{DebuggerObject},
                ErrorMessage   => 'MappingErr could not be initialized',
            ) // '';
        }

        # Map error data.
        my $MappingErrorResult = $MappingErrorObject->Map(
            Data => {
                Fault => $HandleErrorData,
            },
            DataInclude => {
                %{ $Param{DataInclude} },
                ProviderErrorHandlingOutput => $ErrorHandlingResult->{Data},
            },
        );
        if ( !$MappingErrorResult->{Success} ) {
            return $Self->_GenerateErrorResponse(
                DebuggerObject => $Param{DebuggerObject},
                ErrorMessage   => $MappingErrorResult->{ErrorMessage},
            ) // '';
        }

        $HandleErrorData = $MappingErrorResult->{Data};

        $Param{DebuggerObject}->Debug(
            Summary => 'Error data after mapping',
            Data    => $HandleErrorData,
        );
    }

    my $OperationHandleErrorOutput = $Param{OperationObject}->HandleError(
        Data => $HandleErrorData,
    );
    if ( !$OperationHandleErrorOutput->{Success} ) {
        $Param{DebuggerObject}->Error(
            Summary => 'Error handling error data in Operation',
            Data    => $OperationHandleErrorOutput->{ErrorMessage},
        );
    }

    return $Self->_GenerateErrorResponse(
        DebuggerObject => $Param{DebuggerObject},
        ErrorMessage   => $Param{Summary},
    ) // '';
}

=head2 _ThrowWebException()

when not running under PSGI return an empty string, which will be passed on as empty content.
Apache generates status code 500 for that.

Under PSGI explicitly generate a response with code 500.

    # this sub dies
    $RequesterObject->_ThrowWebException();

=cut

sub _ThrowWebException {
    my $Self = shift;

    # for OTOBO_RUNS_UNDER_PSGI

    my $RedirectResponse = Plack::Response->new(
        500,
        [],
        ''
    );

    # The exception is caught be Plack::Middleware::HTTPExceptions
    die Kernel::System::Web::Exception->new(
        PlackResponse => $RedirectResponse
    );
}

=end Internal:

=cut

1;
