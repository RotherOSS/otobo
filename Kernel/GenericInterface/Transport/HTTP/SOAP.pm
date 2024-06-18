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

package Kernel::GenericInterface::Transport::HTTP::SOAP;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use MIME::Base64;
use PerlIO;

# CPAN modules
use HTTP::Status;
use Plack::Response;
use SOAP::Lite;    # for enabling debugging import +trace => 'all'

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Web::Exception;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Transport::HTTP::SOAP - GenericInterface network transport interface for HTTP::SOAP

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Transport->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = bless {}, $Type;

    # Check needed objects.
    for my $Needed (qw(DebuggerObject TransportConfig)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

=head2 ProviderProcessRequest()

Process an incoming web service request. This function has to read the request data
from from the web server process.

Based on the request the Operation to be used is determined.

No out-bound communication is done here, except from continue requests.

In case of an error, the resulting http error code and message are remembered for the response.

    my $Result = $TransportObject->ProviderProcessRequest();

    $Result = {
        Success      => 1,                  # 0 or 1
        ErrorMessage => '',                 # in case of error
        Operation    => 'DesiredOperation', # name of the operation to perform
        Data         => {                   # data payload of request
            ...
        },
    };

=cut

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    # Check transport config.
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return $Self->_Error(
            Summary   => 'HTTP::SOAP Have no TransportConfig',
            HTTPError => 500,
        );
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return $Self->_Error(
            Summary   => 'HTTP::SOAP Have no Config',
            HTTPError => 500,
        );
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # Check namespace config.
    if ( !IsStringWithData( $Config->{NameSpace} ) ) {
        return $Self->_Error(
            Summary   => 'HTTP::SOAP Have no NameSpace in config',
            HTTPError => 500,
        );
    }

    # The HTTP::REST support works with a request object.
    # Just like Kernel::System::Web::InterfaceAgent.
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # Check the input length
    my $Content = q{};
    my $Length;

    # If the HTTP_TRANSFER_ENCODING environment variable is defined, check if is chunked.
    my $Chunked = 0;
    {
        my $TransferEncoding = $ParamObject->HTTP('TRANSFER_ENCODING') // '';
        if ( $TransferEncoding =~ m/^chunked/ ) {
            $Chunked = 1;
        }
    }

    # If chunked transfer encoding is used, read request from chunks and calculate its length afterwards
    if ($Chunked) {
        my $Buffer;
        while ( read( STDIN, $Buffer, 1024 ) ) {
            $Content .= $Buffer;
        }
        $Length = length $Content;
    }
    else {

        # the CGI::PSGI object already has the POST of GET content
        my $RequestMethod = $ParamObject->RequestMethod() // 'POST';
        $Content = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
            Param => "${RequestMethod}DATA",    # e.g. POSTDATA
        );
        $Length = length $Content;
    }

    # No length provided.
    if ( !$Length ) {
        return $Self->_Error(
            Summary   => HTTP::Status::status_message(411),    # 'Length required'
            HTTPError => 411,                                  # HTTP_LENGTH_REQUIRED
        );
    }

    # Request bigger than allowed.
    if ( IsInteger( $Config->{MaxLength} ) && $Length > $Config->{MaxLength} ) {
        return $Self->_Error(
            Summary   => HTTP::Status::status_message(413),
            HTTPError => 413,                                  # HTTP_PAYLOAD_TOO_LARGE
        );
    }

    # In case client requests to continue submission, tell it to continue.
    # TODO: does this work under PSGI ?
    if ( IsStringWithData( $ENV{EXPECT} ) && $ENV{EXPECT} =~ m{ \b 100-Continue \b }xmsi ) {
        $Self->_ThrowWebException(
            HTTPCode => 100,
            Content  => '',
        );
    }

    # Check if we have content.
    if ( !IsStringWithData($Content) ) {
        return $Self->_Error(
            Summary   => 'Could not read input data',
            HTTPError => 500,                           # HTTP_INTERNAL_SERVER_ERROR
        );
    }

    # Convert charset if necessary.
    {
        my $ContentType = $ParamObject->ContentType();
        my $ContentCharset;
        if ( $ContentType =~ m{ \A ( .+ ) ;\s*charset= ["']{0,1} ( .+? ) ["']{0,1} (;|\z) }xmsi ) {

            # Remember content type for the response.
            $Self->{ContentType} = $1;

            $ContentCharset = $2;
        }

        if ( $ContentCharset && $ContentCharset !~ m{ \A utf [-]? 8 \z }xmsi ) {
            $Content = $EncodeObject->Convert2CharsetInternal(
                Text => $Content,
                From => $ContentCharset,
            );
        }
        else {
            $EncodeObject->EncodeInput( \$Content );
        }
    }

    # Send received data to debugger.
    $Self->{DebuggerObject}->Debug(
        Summary => 'Received data by provider from remote system',
        Data    => $Content,
    );

    # Deserialize data.
    my $Deserialized      = eval { SOAP::Deserializer->deserialize($Content); };
    my $DeserializedFault = $@ || '';
    if ($DeserializedFault) {
        return $Self->_Error(
            Summary   => 'Error deserializing message:' . $DeserializedFault,
            HTTPError => 500,
        );
    }

    # Check if the deserialized result is there.
    if ( !defined $Deserialized || !$Deserialized->body() ) {
        return $Self->_Error(
            Summary   => 'Got no result body from deserialized content',
            HTTPError => 500,
        );
    }

    # Get body for request.
    my $Body = $Deserialized->body();

    # Get operation from soap data.
    my $Operation = ( sort keys %{$Body} )[0];

    # Determine local operation name from request wrapper name scheme
    #   possible values are 'Append', 'Plain' and 'Request'.
    my $LocalOperation = $Operation;
    $Config->{RequestNameScheme} //= 'Plain';
    if ( $Config->{RequestNameScheme} eq 'Request' ) {
        $LocalOperation =~ s{ Request \z }{}xms;
    }
    elsif (
        $Config->{RequestNameScheme} eq 'Append'
        && $Config->{RequestNameFreeText}
        && $LocalOperation =~ m{ \A ( .+ ) $Config->{RequestNameFreeText} \z }xms
        )
    {
        $LocalOperation = $1;
    }

    # Remember operation for response.
    $Self->{Operation} = $LocalOperation;

    my $OperationData = $Body->{$Operation};

    # Fall-back for backwards compatibility (SOAP::Lite default behavior).
    if ( !IsStringWithData( $Config->{SOAPAction} ) ) {
        $Config->{SOAPAction} = 'Yes';
    }

    # SOAPAction is for SOAP requests a mandatory header field.
    # Under CGI the value is made available by the webserver as $ENV{HTTP_SOAPACTION}
    # Under PSGI it is available in the Env hashref under the key 'HTTP_SOAPACTION'
    # The Perl module CGI::PSGI takes the setting and
    # make it available via the method HTTP().
    my $SOAPAction = $ParamObject->HTTP('SOAPACTION');

    # Check whether SOAPAction is configured and necessary.
    if (
        $Config->{SOAPAction} eq 'Yes'
        && IsStringWithData($SOAPAction)
        && $SOAPAction ne '""'
        && $SOAPAction ne "''"
        )
    {
        my $SOAPActionStripped = $SOAPAction =~ s{ \A ( ["']? ) (?<SOAPAction> .+? ) \1 \z }{$+{SOAPAction}}xmsr;

        # Fall-back for backwards compatibility.
        if ( !IsStringWithData( $Config->{SOAPActionScheme} ) ) {
            $Config->{SOAPActionScheme} = 'NameSpaceSeparatorOperation';
        }

        my $ExpectedSOAPAction;
        my $ExpectedSOAPActionAlt;
        if (
            $Config->{SOAPActionScheme} eq 'FreeText'
            && IsStringWithData( $Config->{SOAPActionFreeText} )
            )
        {
            $ExpectedSOAPAction = $Config->{SOAPActionFreeText};
        }
        elsif ( $Config->{SOAPActionScheme} eq 'Operation' ) {
            $ExpectedSOAPAction = $LocalOperation;
        }
        elsif (
            $Config->{SOAPActionScheme} eq 'SeparatorOperation'
            && IsStringWithData( $Config->{SOAPActionSeparator} )
            )
        {
            $ExpectedSOAPAction = $Config->{SOAPActionSeparator} . $LocalOperation;
        }
        elsif (
            $Config->{SOAPActionScheme} eq 'NameSpaceSeparatorOperation'
            && IsStringWithData( $Config->{SOAPActionSeparator} )
            )
        {
            $ExpectedSOAPAction = $Config->{NameSpace} . $Config->{SOAPActionSeparator} . $LocalOperation;

            # Fall-back for backwards compatibility
            # this is actually incorrect, but probably needed for the time being (see bug#12196)
            $ExpectedSOAPActionAlt = $Config->{NameSpace} . $LocalOperation;
        }

        # Fall-back for backwards compatibility.
        elsif ( $Config->{SOAPActionScheme} eq 'NameSpaceSeparatorOperation' ) {
            $ExpectedSOAPAction    = $Config->{NameSpace} . '#' . $LocalOperation;
            $ExpectedSOAPActionAlt = $Config->{NameSpace} . '/' . $LocalOperation;
        }

        # Check if SOAPAction header matches up with our expectation.
        # For safety, no check is done if SOAPActionScheme is invalid.
        if (
            $ExpectedSOAPAction
            && $ExpectedSOAPAction ne $SOAPActionStripped
            && ( !$ExpectedSOAPActionAlt || $ExpectedSOAPActionAlt ne $SOAPActionStripped )
            )
        {
            return $Self->_Error(
                Summary => "SOAPAction '$SOAPActionStripped' does not match expected result '$ExpectedSOAPAction'",
            );
        }
    }

    # All OK - return data
    return {
        Success   => 1,
        Operation => $LocalOperation,
        Data      => $OperationData || undef,
    };
}

=head2 ProviderGenerateResponse()

Generates response for an incoming web service request.

Throws a L<Kernel::System::Web::Exception> containing a Plack response object.

The HTTP code of the response object is set accordingly
- C<200> for (syntactically) correct messages
- C<4xx> for http errors
- C<500> for content syntax errors

    $TransportObject->ProviderGenerateResponse(
        Success => 1
        Operation => 'TicketUpdate', # needed for determining outbound headers
        Data      => { # data payload for response, optional
            ...
        },
    );

=cut

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    # Do we have a http error message to return.
    if ( IsStringWithData( $Self->{HTTPError} ) && IsStringWithData( $Self->{HTTPMessage} ) ) {
        $Self->_ThrowWebException(
            HTTPCode => $Self->{HTTPError},
            Content  => $Self->{HTTPMessage},
        );
    }

    # Check data param.
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $Self->_ThrowWebException(
            HTTPCode => 500,
            Content  => 'Invalid data',
        );
    }

    my $Config = $Self->{TransportConfig}->{Config};

    # Check success param.
    my $OperationResponse;
    my $HTTPCode;
    if ( !$Param{Success} ) {

        # Create SOAP Fault structure.
        my $FaultString = $Param{ErrorMessage} || 'Unknown';
        $Param{Data} = {
            faultcode   => 'Server',
            faultstring => $FaultString,
        };

        # Override OperationResponse string to Fault to make the correct SOAP envelope.
        $OperationResponse = 'Fault';

        # Override HTTPCode to 500.
        $HTTPCode = 500;
    }
    else {
        $HTTPCode = 200;

        # Build response wrapper name
        #   possible values are 'Append', 'Plain', 'Replace' and 'Response'.
        $OperationResponse = $Self->{Operation};
        $Config->{ResponseNameScheme} ||= 'Response';
        if ( $Config->{ResponseNameScheme} eq 'Response' ) {
            $Config->{ResponseNameScheme}   = 'Append';
            $Config->{ResponseNameFreeText} = 'Response';
        }
        if ( $Config->{ResponseNameFreeText} ) {
            if ( $Config->{ResponseNameScheme} eq 'Append' ) {

                # Append configured text.
                $OperationResponse .= $Config->{ResponseNameFreeText};
            }
            elsif ( $Config->{ResponseNameScheme} eq 'Replace' ) {

                # Completely replace name with configured text.
                $OperationResponse = $Config->{ResponseNameFreeText};
            }
        }
    }

    # Prepare data.
    my $SOAPResult;
    if ( defined $Param{Data} && IsHashRefWithData( $Param{Data} ) ) {
        my $SOAPData = $Self->_SOAPOutputRecursion(
            Data => $Param{Data},
            Sort => $Config->{Sort},
        );

        # Check output of recursion.
        if ( !$SOAPData->{Success} ) {
            return $Self->_ThrowWebException(
                HTTPCode => 500,
                Content  => "Error in SOAPOutputRecursion: " . $SOAPData->{ErrorMessage},
            );
        }
        $SOAPResult = SOAP::Data->value( @{ $SOAPData->{Data} } );

        if ( ref $SOAPResult ne 'SOAP::Data' ) {
            return $Self->_ThrowWebException(
                HTTPCode => 500,
                Content  => 'Error in SOAP result',
            );
        }
    }

    # Create return structure.
    my @CallData = ( 'response', $OperationResponse );
    if ($SOAPResult) {
        push @CallData, $SOAPResult;
    }
    my $Serialized      = SOAP::Serializer->autotype(0)->default_ns( $Config->{NameSpace} )->envelope(@CallData);
    my $SerializedFault = $@ || '';
    if ($SerializedFault) {
        $Self->_ThrowWebException(
            HTTPCode => 500,
            Content  => 'Error serializing message:' . $SerializedFault,
        );
    }

    # added for OTOBOTicketInvoker
    # Gather additional headers.
    my %ResponseHeaders = $Self->_HeadersGet(
        Type      => 'Operation',
        Operation => $Param{Operation},
    );

    # Mirror some HTTP headers when the request comes from a test script
    # that has temporarily set GenericInterface::Transport::UnitTestHeaders.
    # This feature allows to check outgoing HTTP headers of the generic interface.
    # It was introduced by OTOBOTicketInvoker.
    if ( $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Transport::MirrorUnitTestHTTPHeaders') ) {

        # The HTTP::REST support works with a request object.
        # Just like Kernel::System::Web::InterfaceAgent.
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        my %RequestHeaders;
        for my $EnvKey ( sort $ParamObject->HTTP() ) {
            my $HeaderKey = substr $EnvKey, 5;    # remove leading HTTP_
            $HeaderKey =~ s{_}{-}xmsg;
            $RequestHeaders{$HeaderKey} = $ParamObject->HTTP($EnvKey);
        }

        # If we are in UnitTest header check mode, mirror all request headers in response.
        # The blacklist is not considered here, as we want to verify that the blacklisted headers
        # were not sent in the first place.
        if ( my $MirrorHeaderPrefix = delete $RequestHeaders{UNITTESTHEADERS} ) {

            # Attention: CGI::PSGI and CGI use all-uppercase names for headers.
            # Attention: not sure wheter UntestHeaderBlackList is set in any test script
            my %IsBlacklisted;
            if ( defined $RequestHeaders{UNITTESTHEADERBLACKLIST} ) {
                %IsBlacklisted = map { uc($_) => 1 } split /:/, delete $RequestHeaders{UNITTESTHEADERBLACKLIST};
            }

            HEADER:
            for my $Header ( sort keys %RequestHeaders ) {

                next HEADER if $IsBlacklisted{$Header};

                # the mirrored header are marked with a random prefix
                $ResponseHeaders{ $MirrorHeaderPrefix . $Header } = $RequestHeaders{$Header};
            }
        }
    }

    # No error, still throw an exception
    $Self->_ThrowWebException(
        HTTPCode => $HTTPCode,
        Content  => $Serialized,
        Headers  => \%ResponseHeaders,    # added by OTOBOTicketInvoker
    );

    return;                               # actually not reached
}

=head2 RequesterPerformRequest()

Prepare data payload as XML structure, generate an outgoing web service request,
receive the response and return its data.

    my $Result = $TransportObject->RequesterPerformRequest(
        Operation => 'remote_op', # name of remote operation to perform
        Data      => {            # data payload for request
            ...
        },
    );

    $Result = {
        Success      => 1,        # 0 or 1
        ErrorMessage => '',       # in case of error
        Data         => {
            ...
        },
    };

=cut

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    # Check transport config.
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Have no TransportConfig',
        };
    }

    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Have no Config',
        };
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # Check required config.
    NEEDED:
    for my $Needed (qw(Endpoint NameSpace Timeout)) {
        next NEEDED if IsStringWithData( $Config->{$Needed} );

        return {
            Success      => 0,
            ErrorMessage => "SOAP Transport: Have no $Needed in config",
        };
    }

    # Check data param.
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Invalid Data',
            Data         => $Param{Data},
        };
    }

    # Check operation param.
    if ( !IsStringWithData( $Param{Operation} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Need Operation',
        };
    }

    # Prepare data if we have any.
    my $SOAPData;
    if ( defined $Param{Data} && IsHashRefWithData( $Param{Data} ) ) {
        $SOAPData = $Self->_SOAPOutputRecursion(
            Data => $Param{Data},
            Sort => $Config->{Sort},
        );

        # Check output of recursion.
        if ( !$SOAPData->{Success} ) {
            return {
                Success      => 0,
                ErrorMessage => "Error in SOAPOutputRecursion: " . $SOAPData->{ErrorMessage},
            };
        }
    }

    # Build request wrapper name
    #   possible values are 'Append', 'Plain' and 'Request'.
    my $OperationRequest = $Param{Operation};
    $Config->{RequestNameScheme} ||= 'Plain';
    if ( $Config->{RequestNameScheme} eq 'Request' ) {
        $Config->{RequestNameScheme}   = 'Append';
        $Config->{RequestNameFreeText} = 'Request';
    }
    if ( $Config->{RequestNameScheme} = 'Append' && $Config->{RequestNameFreeText} ) {
        $OperationRequest .= $Config->{RequestNameFreeText};
    }

    # Prepare method.
    my $SOAPMethod = SOAP::Data->name($OperationRequest)->uri( $Config->{NameSpace} );
    if ( ref $SOAPMethod ne 'SOAP::Data' ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Error preparing used method',
        };
    }

    # Prepare connect.
    my $SOAPHandle = eval {
        SOAP::Lite->autotype(0)->default_ns( $Config->{NameSpace} )->proxy(
            $Config->{Endpoint},
            timeout => $Config->{Timeout},
        );
    };
    my $SOAPHandleFault = $@ || '';
    if ($SOAPHandleFault) {
        return {
            Success      => 0,
            ErrorMessage => 'Error creating SOAPHandle: ' . $SOAPHandleFault,
        };
    }

    # Add SSL options if configured.
    if (
        IsHashRefWithData( $Config->{SSL} )
        && IsStringWithData( $Config->{SSL}->{UseSSL} )
        && $Config->{SSL}->{UseSSL} eq 'Yes'
        )
    {
        my %SSLOptionsMap = (
            SSLCertificate => 'SSL_cert_file',
            SSLKey         => 'SSL_key_file',
            SSLPassword    => 'SSL_passwd_cb',
            SSLCAFile      => 'SSL_ca_file',
            SSLCADir       => 'SSL_ca_path',
        );
        SSLOPTION:
        for my $SSLOption ( sort keys %SSLOptionsMap ) {
            next SSLOPTION if !IsStringWithData( $Config->{SSL}->{$SSLOption} );

            if ( $SSLOption ne 'SSLPassword' ) {
                $SOAPHandle->transport()->proxy()->ssl_opts(
                    $SSLOptionsMap{$SSLOption} => $Config->{SSL}->{$SSLOption},
                );
                next SSLOPTION;
            }

            # Passwords needs a special treatment.
            $SOAPHandle->transport()->proxy()->ssl_opts(
                $SSLOptionsMap{$SSLOption} => sub { $Config->{SSL}->{$SSLOption} },
            );
        }
    }

    # Add proxy options if configured.
    if (
        IsHashRefWithData( $Config->{Proxy} )
        && IsStringWithData( $Config->{Proxy}->{UseProxy} )
        && $Config->{Proxy}->{UseProxy} eq 'Yes'
        )
    {

        # Explicitly use no proxy (even if configured system wide).
        if (
            IsStringWithData( $Config->{Proxy}->{ProxyExclude} )
            && $Config->{Proxy}->{ProxyExclude} eq 'Yes'
            )
        {
            $SOAPHandle->transport()->proxy()->no_proxy();
        }

        # Use proxy.
        elsif ( IsStringWithData( $Config->{Proxy}->{ProxyHost} ) ) {

            # set host
            $SOAPHandle->transport()->proxy()->proxy(
                [ 'http', 'https', ],
                $Config->{Proxy}->{ProxyHost},
            );

            # Add proxy authentication.
            if (
                IsStringWithData( $Config->{Proxy}->{ProxyUser} )
                && IsStringWithData( $Config->{Proxy}->{ProxyPassword} )
                )
            {
                $SOAPHandle->transport()->http_request()->proxy_authorization_basic(
                    $Config->{Proxy}->{ProxyUser},
                    $Config->{Proxy}->{ProxyPassword},
                );
            }
        }
    }

    # Add authentication options if configured (hard wired to basic authentication at the moment).
    if (
        IsHashRefWithData( $Config->{Authentication} )
        && IsStringWithData( $Config->{Authentication}->{AuthType} )
        && $Config->{Authentication}->{AuthType} eq 'BasicAuth'
        && IsStringWithData( $Config->{Authentication}->{BasicAuthUser} )
        && IsStringWithData( $Config->{Authentication}->{BasicAuthPassword} )
        )
    {
        $SOAPHandle->transport()->http_request()->authorization_basic(
            $Config->{Authentication}->{BasicAuthUser},
            $Config->{Authentication}->{BasicAuthPassword},
        );
    }

    # Determine target SOAPAction header.
    my $SOAPAction;

    # Fall-back for backwards compatibility (SOAP::Lite default behavior)
    if ( !IsStringWithData( $Config->{SOAPAction} ) ) {
        $Config->{SOAPAction}          = 'Yes';
        $Config->{SOAPActionScheme}    = 'NameSpaceSeparatorOperation';
        $Config->{SOAPActionSeparator} = '#';
    }

    if ( $Config->{SOAPAction} eq 'No' ) {
        $SOAPAction = '';
    }

    # Construct SOAPAction header.
    else {

        # Fall-back for backwards compatibility.
        if ( !IsStringWithData( $Config->{SOAPActionScheme} ) ) {
            $Config->{SOAPActionScheme} = 'NameSpaceSeparatorOperation';
        }

        if (
            $Config->{SOAPActionScheme} eq 'FreeText'
            && IsStringWithData( $Config->{SOAPActionFreeText} )
            )
        {
            $SOAPAction = $Config->{SOAPActionFreeText};
        }
        elsif ( $Config->{SOAPActionScheme} eq 'Operation' ) {
            $SOAPAction = $Param{Operation};
        }
        elsif (
            $Config->{SOAPActionScheme} eq 'SeparatorOperation'
            && IsStringWithData( $Config->{SOAPActionSeparator} )
            )
        {
            $SOAPAction = $Config->{SOAPActionSeparator} . $Param{Operation};
        }
        elsif (
            $Config->{SOAPActionScheme} eq 'NameSpaceSeparatorOperation'
            && IsStringWithData( $Config->{SOAPActionSeparator} )
            )
        {
            $SOAPAction = $Config->{NameSpace} . $Config->{SOAPActionSeparator} . $Param{Operation};
        }

        # Fall-back for the following cases:
        #   - SOAPActionScheme is invalid
        #   - SOAPActionFreeText is required but not set
        #   - SOAPActionSeparator is required but not set
        else {
            $SOAPAction = '';
        }
    }

    # Set SOAPAction header now.
    $SOAPHandle->on_action(
        sub { '"' . $SOAPAction . '"' }
    );

    # Send request to server.
    #
    # For SOAP::Lite version > .712 if $SOAPData->{Data} is an array and is sent directly the
    #   result is that the data is surrounded by <soapenc:Array>, to avoid this is necessary to
    #   pass each part of the $SOAPData->{Data} Array one by one.
    my @CallData = ($SOAPMethod);
    if ($SOAPData) {

        # Check if $SOAPData->{Data} is an array reference.
        if ( IsArrayRefWithData( $SOAPData->{Data} ) ) {

            # pPush array element ($DataPart) one by one.
            for my $DataPart ( @{ $SOAPData->{Data} } ) {
                push @CallData, $DataPart;
            }
        }

        # Otherwise use the same method as before.
        else {
            push @CallData, $SOAPData->{Data};
        }
    }

    # added for OTOBOTicketInvoker

    # Gather additional headers.
    my %Headers = (
        $Self->_HeadersGet(
            Type      => 'Invoker',
            Operation => $Param{Operation},
        ),
    );

    # Trigger mirror mode for headers (undocumented - only for UnitTests)
    if ( $Config->{UnitTestHeaders} ) {
        $Headers{Unittestheaders} = $Config->{UnitTestHeaders};
    }

    # Set additional http headers.
    if (%Headers) {
        $SOAPHandle->transport()->proxy()->http_request()->push_header(%Headers);
    }

    my $SOAPResult = eval {
        $SOAPHandle->call(@CallData);
    };
    my $SOAPResultFault = $@ || '';
    if ($SOAPResultFault) {
        return {
            Success      => 0,
            ErrorMessage => 'Error in SOAP call: ' . $SOAPResultFault,
        };
    }

    # Check if the soap result is there.
    if ( !defined $SOAPResult || !$SOAPResult->body() ) {
        return {
            Success      => 0,
            ErrorMessage => 'Got no result body from soap call',
        };
    }

    # Send sent data to debugger.
    if ( !$SOAPResult->context()->transport()->proxy()->http_response()->request()->content() ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Could not get XML data sent to remote system',
        };
    }
    my $XMLRequest = $SOAPResult->context()->transport()->proxy()->http_response()->request()->content();

    # Get encode object.
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    $EncodeObject->EncodeInput( \$XMLRequest );
    $Self->{DebuggerObject}->Debug(
        Summary => 'XML data sent to remote system',
        Data    => $XMLRequest,
    );

    # Check received data.
    if ( !$SOAPResult->context()->transport()->proxy()->http_response()->content() ) {
        return {
            Success      => 0,
            ErrorMessage => 'Could not get XML data received from remote system',
        };
    }
    my $XMLResponse = $SOAPResult->context()->transport()->proxy()->http_response()->content();

    # Convert charset if necessary.
    if ( $Config->{Encoding} && $Config->{Encoding} !~ m{ \A utf -? 8 \z }xmsi ) {
        $XMLResponse = $EncodeObject->Convert(
            Text => $XMLResponse,
            From => $Config->{Encoding},
            To   => 'utf-8',
        );
    }
    else {
        $EncodeObject->EncodeInput( \$XMLResponse );
    }

    # Send processed data to debugger
    $Self->{DebuggerObject}->Debug(
        Summary => 'XML data received from remote system',
        Data    => $XMLResponse,
    );

    # Deserialize response.
    my $Deserialized = eval {
        SOAP::Deserializer->deserialize($XMLResponse);
    };

    # Check if deserializing was successful.
    if ( !defined $Deserialized || !$Deserialized->body() ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Could not deserialize received XML data',
        };
    }

    my $Body = $Deserialized->body();

    # Check if we got a SOAP Fault message.
    if ( exists $Body->{'Fault'} ) {
        my $ErrorMessage = '';
        for my $Key ( sort keys %{ $Body->{Fault} } ) {
            $ErrorMessage .= "$Key: $Body->{Fault}->{$Key}, ";
        }
        $ErrorMessage = substr $ErrorMessage, 0, -2;
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # Build response wrapper name
    #   possible values are 'Append', 'Plain', 'Replace' and 'Response'
    my $OperationResponse = $Param{Operation};
    $Config->{ResponseNameScheme} ||= 'Response';
    if ( $Config->{ResponseNameScheme} eq 'Response' ) {
        $Config->{ResponseNameScheme}   = 'Append';
        $Config->{ResponseNameFreeText} = 'Response';
    }
    if ( $Config->{ResponseNameFreeText} ) {
        if ( $Config->{ResponseNameScheme} eq 'Append' ) {

            # Append configured text.
            $OperationResponse .= $Config->{ResponseNameFreeText};
        }
        elsif ( $Config->{ResponseNameScheme} eq 'Replace' ) {

            # Completely replace name with configured text.
            $OperationResponse = $Config->{ResponseNameFreeText};
        }
    }

    # Check if we have response data for the specified operation in the soap result.
    if ( !exists $Body->{$OperationResponse} ) {
        return {
            Success      => 0,
            ErrorMessage =>
                "No response data found for specified operation '$Param{Operation}'"
                . " in soap response",
        };
    }

    # added for OTOBOTicketInvoker

    # Export mirrored headers (only used for UnitTests)
    my %UnitTestHeaders;
    if ( $Config->{UnitTestHeaders} ) {

        my %AllResponseHeaders = $SOAPResult->context()->transport()->proxy()->http_response()->headers()->flatten();
        HEADER:
        for my $Header ( sort keys %AllResponseHeaders ) {
            next HEADER if length($Header) < 25;
            next HEADER if substr( $Header, 0, 25 ) ne $Config->{UnitTestHeaders};

            $UnitTestHeaders{ substr( $Header, 25 ) } = $AllResponseHeaders{$Header};
        }
    }

    # All OK - return result.
    return {
        Success         => 1,
        Data            => $Body->{$OperationResponse} || undef,
        UnitTestHeaders => \%UnitTestHeaders,                      # added for OTOBOTicketInvoker
    };
}

=begin Internal:

=head2 _Error()

Take error parameters from request processing.
Error message is written to debugger, written to environment for response.
Error is generated to be passed to provider/requester.

    my $Result = $TransportObject->_Error(
        Summary   => 'Message',    # error message
        HTTPError => 500,          # http error code, optional
    );

    $Result = {
        Success      => 0,
        ErrorMessage => 'Message', # error message from given summary
    };

=cut

sub _Error {
    my ( $Self, %Param ) = @_;

    # Check needed params.
    if ( !IsString( $Param{Summary} ) ) {
        return $Self->_Error(
            Summary   => 'Need Summary!',
            HTTPError => 500,
        );
    }

    # Log to debugger.
    $Self->{DebuggerObject}->Error(
        Summary => $Param{Summary},
    );

    # Remember data for response.
    if ( IsStringWithData( $Param{HTTPError} ) ) {
        $Self->{HTTPError}   = $Param{HTTPError};
        $Self->{HTTPMessage} = $Param{Summary};
    }

    # Return to provider/requester.
    return {
        Success      => 0,
        ErrorMessage => $Param{Summary},
    };
}

=head2 _ThrowWebException()

creates a M<Plack::Response> object, wrap it into a M<Kernel::System::Web::Exception> object
and throw that object as an exception.

    # this sub dies
    $TransportObject->_ThrowWebException(
        HTTPCode => 200,     # http code to be returned, optional
        Content  => $XML,    # message content, XML response on normal execution
    );

=cut

sub _ThrowWebException {
    my ( $Self, %Param ) = @_;

    # Check params.
    my $Success = 1;
    my $ErrorMessage;
    if ( defined $Param{HTTPCode} && !IsInteger( $Param{HTTPCode} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid internal HTTPCode';
        $Success         = 0;
        $ErrorMessage    = 'Invalid internal HTTPCode';
    }
    elsif ( defined $Param{Content} && !IsString( $Param{Content} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid Content';
        $Success         = 0;
        $ErrorMessage    = 'Invalid Content';
    }

    # prepare protocol
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Protocol    = $ParamObject->ServerProtocol() // 'HTTP/1.0';

    # FIXME: according to SOAP::Transport::HTTP the previous should not be used
    #   for all supported browsers 'Status:' should be used here
    #   this breaks apache though

    # prepare data
    $Param{Content}  ||= '';
    $Param{HTTPCode} ||= 500;

    my $ContentType = $Param{HTTPCode} eq 200 ? ( $Self->{ContentType} || 'text/xml' ) : 'text/plain';

    # Log to debugger.
    my $DebugLevel = $Param{HTTPCode} eq 200 ? 'debug' : 'error';
    $Self->{DebuggerObject}->DebugLog(
        DebugLevel => $DebugLevel,
        Summary    => "Returning provider data to remote system (HTTP Code: $Param{HTTPCode})",
        Data       => $Param{Content},
    );

    # Set keep-alive.
    my $ConfigKeepAlive = $Kernel::OM->Get('Kernel::Config')->Get('SOAP::Keep-Alive');

    # header for the response that will be thrown
    my @Headers;
    push @Headers, 'Content-Type' => "$ContentType; charset=UTF-8";
    push @Headers, 'Connection'   => ( $ConfigKeepAlive ? 'Keep-Alive' : 'close' );

    # The Content-Length will be set later in the middleware Plack::Middleware::ContentLength. This requires that
    # there are no multi-byte characters in the delivered content. This is because the middleware
    # uses core::length() for determining the content length.
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Content} );

    # Prepare additional headers.
    if ( IsHashRefWithData( $Self->{TransportConfig}->{Config}->{AdditionalHeaders} ) ) {
        my %AdditionalHeaders = $Self->{TransportConfig}->{Config}->{AdditionalHeaders}->%*;
        for my $AdditionalHeader ( sort keys %AdditionalHeaders ) {
            push @Headers, $AdditionalHeader => ( $AdditionalHeaders{$AdditionalHeader} || '' );
        }
    }

    # added for OTOBOTicketInvoker
    # Set additional headers.
    if ( $Param{Headers} ) {
        for my $Header ( sort keys %{ $Param{Headers} } ) {
            push @Headers, $Header => $Param{Headers}->{$Header};
        }
    }

    # generate the response
    my $PlackResponse = Plack::Response->new(
        $Param{HTTPCode},
        \@Headers,
        $Param{Content}
    );

    # The exception is caught be Plack::Middleware::HTTPExceptions
    die Kernel::System::Web::Exception->new(
        PlackResponse => $PlackResponse
    );
}

=head2 _SOAPOutputRecursion()

Convert Perl data structure into a structure usable for SOAP::Lite.

Because some systems require data in a specific order,
the sort order of hash ref entries (and only those) can be specified optionally.
If entries exist that are not mentioned in sorting config,
they will be added after the sorted entries in ascending alphanumerical order.

Example:
$Data = {
    Key1 => 'Value',
    Key2 => {
        Key3 => 'Value',
        Key4 => [
            'Value',
            'Value',
            {
                Key5 => 'Value',
            },
        ],
    },
};
$Sort = [                                  # wrapper for level 1
    {                                      # first entry for level 1
        Key2 => [                          # wrapper for level 2
            {                              # first entry for level 2
                Key4 => [
                    undef,
                    undef,
                    [                      # wrapper for level 3
                        {
                            Key5 => undef, # first entry for level 3
                        },
                    ],                     # wrapper for level 3
                ],
            },                             # first entry for level 2
            {                              # second entry for level 2
                Key3 => undef,
            },                             # second entry for level 2
        ],                                 # wrapper for level 2
    }                                      # first entry for level 1
    {                                      # second entry for level 1
        Key1 => undef,
    }                                      # second entry for level 1
];                                         # wrapper for level 1

    my $Result = $TransportObject->_SOAPOutputRecursion(
        Data => {           # data payload
            ...
        },
        Sort => {           # sorting instructions, optional
            ...
        },
    );

    $Result = {
        Success      => 1,  # 0 or 1
        ErrorMessage => '', # in case of error
        Data         => {   # data payload in SOAP::Data format
            ...
        },
    };

=cut

sub _SOAPOutputRecursion {
    my ( $Self, %Param ) = @_;

    # Get and check types of data and sort elements.
    my $Type = $Self->_SOAPOutputTypesGet(%Param);
    return $Type if !$Type->{Success};

    # Process undefined data.
    if ( $Type->{Data} eq 'UNDEFINED' ) {
        return {
            Success => 1,
            Data    => '',
        };
    }

    # Process string.
    if ( $Type->{Data} eq 'STRING' ) {
        return {
            Success => 1,
            Data    => $Self->_SOAPOutputProcessString( Data => $Param{Data} ),
        };
    }

    # Process array ref.
    if ( $Type->{Data} eq 'ARRAYREF' ) {
        my @Result;
        KEY:
        for my $Key ( @{ $Param{Data} } ) {

            # Process key.
            my $RecurseResult = $Self->_SOAPOutputRecursion(
                Data => $Key,
                Sort => $Param{Sort},
            );

            # Return on error.
            return $RecurseResult if !$RecurseResult->{Success};

            # Treat result of strings differently.
            if ( !defined $Key || IsString($Key) || IsString( $RecurseResult->{Data} ) ) {
                push @Result, $RecurseResult->{Data};
                next KEY;
            }
            push @Result, \SOAP::Data->value( @{ $RecurseResult->{Data} } );
        }

        # Return result of successful recursion.
        return {
            Success => 1,
            Data    => \@Result,
        };
    }

    # Process hash ref.
    # Sorted entries first.
    my %UnsortedData = %{ $Param{Data} };
    my @SortedData;
    my @Result;
    if ( $Type->{Sort} eq 'ARRAYREF' ) {
        ELEMENT:
        for my $SortArrayElement ( @{ $Param{Sort} } ) {

            # For easier reading - structure has already been validated in _SOAPOutputTypesGet().
            my ($SortKey) = sort keys %{$SortArrayElement};

            # Missing data elements are OK, we just skip them.
            next ELEMENT if !exists $UnsortedData{$SortKey};

            # Add to sorted data and remove from remaining data hash.
            push @SortedData, {
                Key  => $SortKey,
                Data => $UnsortedData{$SortKey},
                Sort => $SortArrayElement->{$SortKey},
            };
            delete $UnsortedData{$SortKey};
            next ELEMENT;
        }
    }

    # Add remaining hash entries.
    for my $Key ( sort keys %UnsortedData ) {
        push @SortedData, {
            Key  => $Key,
            Data => $UnsortedData{$Key},
        };
    }

    # Process (potentially sorted) hash entries.
    ENTRY:
    for my $Entry (@SortedData) {

        # Process element.
        my $RecurseResult = $Self->_SOAPOutputHashRecursion(
            Data => $Entry->{Data},
            Sort => $Entry->{Sort},
        );

        # Return on error.
        return $RecurseResult if !$RecurseResult->{Success};

        # Process key and add key/value pair to result.
        push @Result, SOAP::Data->name( $Entry->{Key} )->value( $RecurseResult->{Data} );
    }

    # Return result of successful recursion.
    return {
        Success => 1,
        Data    => \@Result,
    };
}

=head2 _SOAPOutputHashRecursion()

This is a part of _SOAPOutputRecursion.
It contains the functions to process a hash key/value pair.

    my $Result = $TransportObject->_SOAPOutputHashRecursion(
        Data => { # data payload
            ...
        },
        Sort => { # sort data payload
            ...
        },
    );

    $Result = {
        Success      => 1,  # 0 or 1
        ErrorMessage => '', # in case of error
        Data         => (   # data payload in SOAP::Data format
            ...
        ),
    };

=cut

sub _SOAPOutputHashRecursion {
    my ( $Self, %Param ) = @_;

    # Process data.
    my $RecurseResult = $Self->_SOAPOutputRecursion(%Param);

    # Return on error.
    return $RecurseResult if !$RecurseResult->{Success};

    # Set result based on data type.
    my $Result;
    if ( !defined $Param{Data} || IsString( $Param{Data} ) || IsString( $RecurseResult->{Data} ) ) {
        $Result = $RecurseResult->{Data};
    }
    elsif ( IsArrayRefWithData( $Param{Data} ) ) {
        $Result = SOAP::Data->value( @{ $RecurseResult->{Data} } );
    }
    elsif ( IsHashRefWithData( $Param{Data} ) ) {
        $Result = \SOAP::Data->value( @{ $RecurseResult->{Data} } );
    }

    # This should have caused an error before, but just in case.
    else {
        return {
            Success      => 0,
            ErrorMessage => 'Unexpected problem - data value is invalid',
        };
    }

    # Return result of successful recursion.
    return {
        Success => 1,
        Data    => $Result,
    };
}

=head2 _SOAPOutputProcessString()

This is a part of _SOAPOutputRecursion.
It contains functions to quote invalid XML characters and encode the string

    my $Result = $TransportObject->_SOAPOutputProcessString(
        Data => 'a <string> & more',
    );

    $Result = 'a &lt;string> &amp; more';

=cut

sub _SOAPOutputProcessString {
    my ( $Self, %Param ) = @_;

    return '' if !defined $Param{Data};

    # Escape characters that are invalid in XML (or might cause problems).
    $Param{Data} =~ s{ & }{&amp;}xmsg;
    $Param{Data} =~ s{ < }{&lt;}xmsg;
    $Param{Data} =~ s{ > }{&gt;}xmsg;

    # Remove restricted characters #x1-#x8, #xB-#xC, #xE-#x1F, #x7F-#x84 and #x86-#x9F.
    $Param{Data} =~ s{ [\x01-\x08\x0B-\x0C\x0E-\x1F\x7F-\x84\x86-\x9F] }{}msxg;

    return $Param{Data};
}

=head2 _SOAPOutputTypesGet()

Determine and validate types of data and (optional) sort attributes.

The structure may contain multiple levels with scalars, array references and hash references.
Empty array references and array references directly within array references
are not permitted as they don't have a valid XML representation.
Undefined data and empty hash references are treated as empty string.

The sorting structure has to be equal to the data structure
with hash references replaced by an array reference and its elements wrapped in individual hash references.
Values in the sorting structure are ignored but have to be specified
(at least 'undef') for correct type detection.

    my $Result = $TransportObject->_SOAPOutputTypesGet(
        Data => {           # data payload
            ...
        },
        Sort => {           # sorting instructions, optional
            ...
        },
    );

    $Result = {
        Success      => 1,              # 0 or 1
        ErrorMessage => '',             # in case of error
        Data         => 'HASHREF',      # type of data content
        Sort         => 'ARRAYREF',     # type of sort content
    };

=cut

sub _SOAPOutputTypesGet {
    my ( $Self, %Param ) = @_;

    # Check types.
    my %Type;
    KEY:
    for my $Key (qw(Data Sort)) {

        # Those are valid.
        if ( !defined $Param{$Key} ) {
            $Type{$Key} = 'UNDEFINED';
            next KEY;
        }
        my $Ref = ref $Param{$Key};
        if ( !$Ref ) {
            $Type{$Key} = 'STRING';
            next KEY;
        }
        if ( IsArrayRefWithData( $Param{$Key} ) ) {
            $Type{$Key} = 'ARRAYREF';
            next KEY;
        }

        # Hash ref is only allowed for data.
        if ( IsHashRefWithData( $Param{$Key} ) ) {
            $Type{$Key} = 'HASHREF';
            next KEY;
        }

        # Clean up empty hash references for data and empty array references for sort.
        if (
            $Key eq 'Data' && $Ref eq 'HASH'
            || $Key eq 'Sort' && $Ref eq 'ARRAY'
            )
        {
            $Param{$Key} = undef;
            $Type{$Key}  = 'UNDEFINED';
            next KEY;
        }

        # Everything else is invalid - throw error.
        if ( $Ref eq 'HASH' || $Ref eq 'ARRAY' ) {
            $Ref .= ' (empty)';
        }
        return {
            Success      => 0,
            ErrorMessage => "$Key type '$Ref' is invalid",
        };
    }

    # If there is no data to be sorted set sorting accordingly.
    if ( $Type{Data} eq 'UNDEFINED' && $Type{Sort} ne 'UNDEFINED' ) {
        $Type{Sort} = 'UNDEFINED';
    }

    # Types of data and sort must match if sorting is used (=is defined)
    #   if data is hash reference sort must be array reference.
    if (
        $Type{Sort} ne 'UNDEFINED'
        && $Type{Data} ne $Type{Sort}
        && !(
            $Type{Data} eq 'HASHREF'
            && $Type{Sort} eq 'ARRAYREF'
        )
        )
    {
        return {
            Success      => 0,
            ErrorMessage => "Types of Data '$Type{Data}' and Sort '$Type{Sort}' don't match",
        };
    }

    # Sort array content check.
    if ( $Type{Sort} eq 'ARRAYREF' ) {
        for my $SortArrayElement ( @{ $Param{Sort} } ) {
            if ( !IsHashRefWithData($SortArrayElement) ) {
                return {
                    Success      => 0,
                    ErrorMessage => 'Element of sort array is not a hash reference',
                };
            }
            my @SortArrayElementKeys = sort keys %{$SortArrayElement};
            if ( scalar @SortArrayElementKeys != 1 ) {
                return {
                    Success      => 0,
                    ErrorMessage =>
                        'Sort array element hash reference must contain exactly one key/value pair',
                };
            }
            if ( !IsStringWithData( $SortArrayElementKeys[0] ) ) {
                return {
                    Success      => 0,
                    ErrorMessage =>
                        'Key of sort array element hash reference must be a non zero-length string',
                };
            }
        }
    }

    # Return validated types.
    return {
        Success => 1,
        Data    => $Type{Data},
        Sort    => $Type{Sort},
    };
}

# introduced for OTOBOTicketInvoker
sub _HeadersGet {
    my ( $Self, %Param ) = @_;

    my $Config = $Self->{TransportConfig}->{Config}->{OutboundHeaders};

    # Fallback for previously used 'additional response headers'.
    if ( IsHashRefWithData( $Self->{TransportConfig}->{Config}->{AdditionalHeaders} ) ) {
        $Config = {
            Common => $Self->{TransportConfig}->{Config}->{AdditionalHeaders},
        };
    }

    return () if !IsHashRefWithData($Config);

    # Common headers.
    # These come first as specific headers might override them.
    my @HeaderBlacklist
        = @{
            $Kernel::OM->Get('Kernel::Config')->Get( 'GenericInterface::' . $Param{Type} . '::OutboundHeaderBlacklist' )
            // []
        };
    my %Headers;
    if ( IsHashRefWithData( $Config->{Common} ) ) {
        HEADER:
        for my $Header ( sort keys %{ $Config->{Common} } ) {
            next HEADER if grep { $_ eq $Header } @HeaderBlacklist;

            $Headers{$Header} = $Config->{Common}->{$Header};
        }
    }

    # Operation/Invoker specific headers.
    return %Headers if !$Param{Operation};
    if ( IsHashRefWithData( $Config->{Specific}->{ $Param{Operation} } ) ) {
        HEADER:
        for my $Header ( sort keys %{ $Config->{Specific}->{ $Param{Operation} } } ) {
            next HEADER if grep { $_ eq $Header } @HeaderBlacklist;

            $Headers{$Header} = $Config->{Specific}->{ $Param{Operation} }->{$Header};
        }
    }

    return %Headers;
}

=end Internal:

=cut

1;
