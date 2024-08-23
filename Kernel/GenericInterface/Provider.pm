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

package Kernel::GenericInterface::Provider;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use Storable qw(dclone);

# CPAN modules
use URI::Escape     qw(uri_unescape);
use Plack::Response ();

# OTOBO modules
use Kernel::GenericInterface::Debugger  ();
use Kernel::GenericInterface::Transport ();
use Kernel::GenericInterface::Mapping   ();
use Kernel::GenericInterface::Operation ();
use Kernel::System::VariableCheck       qw(IsHashRefWithData);
use Kernel::System::Web::Exception      ();

our @ObjectDependencies = (
    'Kernel::GenericInterface::ErrorHandling',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
    'Kernel::System::Web::Response',
);

=head1 NAME

Kernel::GenericInterface::Provider - handler for incoming web service requests.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $Interface = $Kernel::OM->Get('Kernel::GenericInterface::Provider');

=cut

sub new {
    my ( $Class, %Param ) = @_;

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
    return bless {}, $Class;
}

=head2 Content()

Receives the current incoming web service request, handles it,
and returns an appropriate answer based on the requested web service.
Set headers in Kernels::System::Web::Request singleton as side effect.
Can die and throw Kernel::System::Web::Exception which is expected to be caught by Plack::Middleware::HTTPExceptions.

    # put this in the handler script
    my $Content = $Interface->Content();

=cut

sub Content {
    my ($Self) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $RequestURI  = $ParamObject->RequestURI();

    # Locate and verify the desired web service based on the request URI and load its configuration data.

    # Check RequestURI for a web service by id or name.
    my %WebserviceGetData;
    if (
        $RequestURI
        &&
        $RequestURI =~ m{ nph-genericinterface[.]pl/ (?: WebserviceID/ (?<ID> [0-9]+ ) | Webservice/ (?<Name> [^/?]+ ) ) }smx
        )
    {
        %WebserviceGetData = (
            ID   => $+{ID},
            Name => $+{Name} ? uri_unescape( $+{Name} ) : undef,
        );
    }

    # URI is empty or invalid.
    if ( !%WebserviceGetData ) {
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
    my $ProcessRequestResult = $Self->{TransportObject}->ProviderProcessRequest();

    # If the request was not processed correctly, send error to client.
    if ( !$ProcessRequestResult->{Success} ) {

        my $Summary = $ProcessRequestResult->{ErrorMessage} // 'TransportObject returned an error, cancelling Request';

        return $Self->_HandleError(
            %HandleErrorData,
            DataInclude => {},
            ErrorStage  => 'ProviderRequestReceive',
            Summary     => $Summary,
            Data        => $ProcessRequestResult->{Data} // $Summary,
        );
    }

    # prepare the data include configuration and payload
    my %DataInclude = (
        ProviderRequestInput => $ProcessRequestResult->{Data},
    );

    my $Operation = $ProcessRequestResult->{Operation};

    $DebuggerObject->Debug(
        Summary => "Detected operation '$Operation'",
    );

    #
    # Map the incoming data based on the configured mapping.
    #

    my $DataIn = $ProcessRequestResult->{Data};

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
            MappingConfig  => $ProviderConfig->{Operation}->{$Operation}->{MappingInbound},
        );

        # If mapping initialization failed, bail out.
        if ( ref $MappingInObject ne 'Kernel::GenericInterface::Mapping' ) {
            $DebuggerObject->Error(
                Summary => 'MappingIn could not be initialized',
                Data    => $MappingInObject,
            );

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $DebuggerObject,
                ErrorMessage   => $ProcessRequestResult->{ErrorMessage},
            ) // '';
        }

        # add operation to data for error handler
        $HandleErrorData{Operation} = $Operation;

        my $MappingInResult = $MappingInObject->Map(
            Data => $DataIn,
        );

        if ( !$MappingInResult->{Success} ) {

            my $Summary = $MappingInResult->{ErrorMessage} // 'MappingInObject returned an error, cancelling Request';

            return $Self->_HandleError(
                %HandleErrorData,
                DataInclude => \%DataInclude,
                ErrorStage  => 'ProviderRequestMap',
                Summary     => $Summary,
                Data        => $MappingInResult->{Data} // $Summary,
            );
        }

        # extend the data include payload
        $DataInclude{ProviderRequestMapOutput} = $MappingInResult->{Data};

        $DataIn = $MappingInResult->{Data};

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

    my $OperationResult = $OperationObject->Run(
        Data => $DataIn,
    );

    if ( !$OperationResult->{Success} ) {

        my $Summary = $OperationResult->{ErrorMessage} // 'OperationObject returned an error, cancelling Request';

        return $Self->_HandleError(
            %HandleErrorData,
            DataInclude => \%DataInclude,
            ErrorStage  => 'ProviderRequestProcess',
            Summary     => $Summary,
            Data        => $OperationResult->{Data} // $Summary,
        );
    }

    # extend the data include payload
    $DataInclude{ProviderResponseInput} = $OperationResult->{Data};

    #
    # Map the outgoing data based on configured mapping.
    #

    my $DataOut = $OperationResult->{Data};

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
                ErrorMessage   => $OperationResult->{ErrorMessage},
            ) // '';
        }

        my $MappingOutResult = $MappingOutObject->Map(
            Data        => $DataOut,
            DataInclude => \%DataInclude,
        );

        if ( !$MappingOutResult->{Success} ) {

            my $Summary = $MappingOutResult->{ErrorMessage} // 'MappingOutObject returned an error, cancelling Request';

            return $Self->_HandleError(
                %HandleErrorData,
                DataInclude => \%DataInclude,
                ErrorStage  => 'ProviderResponseMap',
                Summary     => $Summary,
                Data        => $MappingOutResult->{Data} // $Summary,
            );
        }

        # extend the data include payload
        $DataInclude{ProviderResponseMapOutput} = $MappingOutResult->{Data};

        $DataOut = $MappingOutResult->{Data};

        $DebuggerObject->Debug(
            Summary => "Outgoing data after mapping",
            Data    => $DataOut,
        );
    }

    # Generate the actual response and throw it in an Kernel::System::Web::Exception.
    $Self->{TransportObject}->ProviderGenerateResponse(
        Success   => 1,
        Data      => $DataOut,
        Operation => $Operation,    # introduced by OTOBOTicketInvoker
    );

    return;                         # actually not reached
}

=head2 Response()

Generate a PSGI Response object from the content generated by C<Content()>.

    my $Response = $Interface->Response();

=cut

sub Response {
    my ($Self) = @_;

    # Note that no layout object must be created before calling Content().
    # This is because Content() might want to set object params before the initial creations.
    # A notable example is the SetCookies parameter.
    my $Content = $Self->Content();

    # This code is usually never called, as Content() usually throws an exceptiom.
    # The HTTP headers of the OTOBO web response object already have been set up.
    # Enhance it with the HTTP status code and the content.
    return $Kernel::OM->Get('Kernel::System::Web::Response')->Finalize(
        Content => $Content
    );
}

=begin Internal:

=head2 _GenerateErrorResponse()

prepares header and content for an error response

Throws a L<Kernel::System::Web::Exception> containing a Plack response object.

    $Self->_GenerateErrorResponse(
        DebuggerObject => $DebuggerObject,
        ErrorMessage   => $ErrorMessage,
    );

=cut

sub _GenerateErrorResponse {
    my ( $Self, %Param ) = @_;

    # Generate the error response and throw it in an
    # Kernel::System::Web::Exception.
    $Self->{TransportObject}->ProviderGenerateResponse(
        Success      => 0,
        ErrorMessage => $Param{ErrorMessage},
    );

    return;    # actually not reached
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
        ) // '';
    }

    my $HandleErrorData;
    if ( !defined $Param{Data} || IsString( $Param{Data} ) ) {
        $HandleErrorData = $Param{Data} // '';
    }
    else {
        $HandleErrorData = dclone( $Param{Data} );
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

Generate a response with code 500 and empty content and throw it as an exception.

    # this sub dies
    $RequesterObject->_ThrowWebException();

=cut

sub _ThrowWebException {
    my ($Self) = @_;

    my $ServerErrorResponse = Plack::Response->new(
        500,
        [],
        ''
    );

    # The exception is caught be Plack::Middleware::HTTPExceptions
    die Kernel::System::Web::Exception->new(
        PlackResponse => $ServerErrorResponse
    );
}

=end Internal:

=cut

1;
