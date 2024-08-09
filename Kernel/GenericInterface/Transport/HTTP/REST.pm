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

package Kernel::GenericInterface::Transport::HTTP::REST;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use MIME::Base64 qw(encode_base64);

# CPAN modules
use HTTP::Status    qw(status_message);
use REST::Client    ();
use URI::Escape     qw(uri_escape_utf8 uri_unescape);
use Plack::Response ();

# OTOBO modules
use Kernel::System::VariableCheck  qw(:all);
use Kernel::System::Web::Exception ();

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Transport::HTTP::REST - GenericInterface network transport interface for HTTP::REST

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
            Summary   => 'REST Transport: Have no TransportConfig',
            HTTPError => 500,
        );
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return $Self->_Error(
            Summary   => 'Rest Transport: Have no Config',
            HTTPError => 500,
        );
    }
    my $Config = $Self->{TransportConfig}->{Config};
    $Self->{KeepAlive} = $Config->{KeepAlive} || 0;

    if ( !IsHashRefWithData( $Config->{RouteOperationMapping} ) ) {
        return $Self->_Error(
            Summary   => "HTTP::REST Can't find RouteOperationMapping in Config",
            HTTPError => 500,
        );
    }

    # The HTTP::REST support works with a request object.
    # Just like Kernel::System::Web::InterfaceAgent.
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    my $RequestURI = $ParamObject->RequestURI;
    $RequestURI =~ s{.*Webservice(?:ID)?\/[^\/]+(\/.*)$}{$1}xms;

    # Remove any query parameter from the URL
    #   e.g. from /Ticket/1/2?UserLogin=user&Password=secret
    #   to /Ticket/1/2?.
    my $QueryParamsStr = '';
    if ( $RequestURI =~ s{([^?]+)(.+)?}{$1} ) {

        # Remember the query parameters e.g. ?UserLogin=user&Password=secret.
        # It is fine when $2 is not defined, that is when there is no '?' in $RequestURI
        $QueryParamsStr = $2;
    }

    my %QueryParams;
    if ($QueryParamsStr) {

        # Remove question mark '?' in the beginning.
        substr $QueryParamsStr, 0, 1, '';

        # Convert query parameters into a hash
        #   e.g. from UserLogin=user&Password=secret
        #   to (
        #        UserLogin => 'user',
        #        Password  => 'secret',
        #      );
        for my $QueryParam ( split /[;&]/, $QueryParamsStr ) {
            my ( $Key, $Value ) = split /=/, $QueryParam;

            # Convert + characters to its encoded representation, see bug#11917.
            $Value =~ s{\+}{%20}g;

            # Unescape URI strings in query parameters.
            $Key   = uri_unescape($Key);
            $Value = uri_unescape($Value);

            # Encode variables.
            $EncodeObject->EncodeInput( \$Key );
            $EncodeObject->EncodeInput( \$Value );

            if ( !defined $QueryParams{$Key} ) {
                $QueryParams{$Key} = $Value || '';
            }

            # Elements specified multiple times will be added as array reference.
            elsif ( ref $QueryParams{$Key} eq '' ) {
                $QueryParams{$Key} = [ $QueryParams{$Key}, $Value ];
            }
            else {
                push @{ $QueryParams{$Key} }, $Value;
            }
        }
    }

    my $Operation;
    my %URIData;
    my $RequestMethod = $ParamObject->RequestMethod() || 'GET';
    ROUTE:
    for my $CurrentOperation ( sort keys %{ $Config->{RouteOperationMapping} } ) {

        next ROUTE if !IsHashRefWithData( $Config->{RouteOperationMapping}->{$CurrentOperation} );

        my %RouteMapping = %{ $Config->{RouteOperationMapping}->{$CurrentOperation} };

        if ( IsArrayRefWithData( $RouteMapping{RequestMethod} ) ) {
            next ROUTE if !grep { $RequestMethod eq $_ } @{ $RouteMapping{RequestMethod} };
        }

        # Convert the configured route with the help of extended regexp patterns
        #   to a regexp. This generated regexp is used to:
        #   1.) Determine the Operation for the request
        #   2.) Extract additional parameters from the RequestURI
        #   For further information: http://perldoc.perl.org/perlre.html#Extended-Patterns
        #
        #   For example, from the RequestURI: /Ticket/1/2
        #       and the route setting:        /Ticket/:TicketID/:Other
        #       %URIData will then contain:
        #       (
        #           TicketID => 1,
        #           Other    => 2,
        #       );
        my $RouteRegEx = $RouteMapping{Route};
        $RouteRegEx =~ s{:([^\/]+)}{(?<$1>[^\/]+)}xmsg;

        next ROUTE if !( $RequestURI =~ m{^ $RouteRegEx $}xms );

        # Import URI params.
        for my $URIKey ( sort keys %+ ) {
            my $URIValue = $+{$URIKey};

            # Unescape value
            $URIValue = uri_unescape($URIValue);

            # Encode value.
            $EncodeObject->EncodeInput( \$URIValue );

            # Add to URI data.
            $URIData{$URIKey} = $URIValue;
        }

        $Operation = $CurrentOperation;

        # Leave with the first matching regexp.
        last ROUTE;
    }

    # Combine query params with URIData params, URIData has more precedence.
    if (%QueryParams) {
        %URIData = ( %QueryParams, %URIData, );
    }

    if ( !$Operation ) {
        return $Self->_Error(
            Summary   => "HTTP::REST Error while determine Operation for request URI '$RequestURI'.",
            HTTPError => 500,
        );
    }

    # The body supplied by POST, PUT, and PATCH has already been read in. This should be safe
    # as $CGI::POST_MAX has been set as an emergency brake.
    # For Checking the length we can therefor use the actual length.
    my $Content = $ParamObject->GetParam( Param => uc($RequestMethod) . 'DATA' );
    my $Length  = length $Content;

    # No length provided, return the information we have.
    # Also return for 'GET' method because it does not allow sending an entity-body in requests.
    # For more information, see https://bugs.otrs.org/show_bug.cgi?id=14203.
    if ( !$Length || $RequestMethod eq 'GET' ) {
        return {
            Success   => 1,
            Operation => $Operation,
            Data      => {
                %URIData,
                RequestMethod => $RequestMethod,
            },
        };
    }

    # Request bigger than allowed.
    if ( IsInteger( $Config->{MaxLength} ) && $Length > $Config->{MaxLength} ) {
        return $Self->_Error(
            Summary   => status_message(413),
            HTTPError => 413,                   # HTTP_PAYLOAD_TOO_LARGE
        );
    }

    # There might be a different request method.
    # NOTE: this is redundant and kept only for compatability with older versions
    if ( !IsStringWithData($Content) && $RequestMethod ne 'GET' ) {
        my $ParamName = $RequestMethod . 'DATA';
        $Content = $ParamObject->GetParam(
            Param => $ParamName,
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
        my ($ContentCharset) = $ContentType =~ m{ \A .* charset= ["']? ( [^"']+ ) ["']? \z }xmsi;
        if ( $ContentCharset && $ContentCharset !~ m{ \A utf [-]? 8 \z }xmsi ) {
            $Content = $EncodeObject->Convert2CharsetInternal(
                Text => $Content,
                From => $ContentCharset,
            );
        }
        else {
            # this sets the UTF-8 flag
            $EncodeObject->EncodeInput( \$Content );
        }
    }

    # Send received data to debugger.
    $Self->{DebuggerObject}->Debug(
        Summary => 'Received data by provider from remote system',
        Data    => $Content,
    );

    my $ContentDecoded = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $Content,
    );

    if ( !$ContentDecoded ) {
        return $Self->_Error(
            Summary   => 'Error while decoding request content.',
            HTTPError => 500,
        );
    }

    my $ReturnData;
    if ( IsHashRefWithData($ContentDecoded) ) {

        $ReturnData = $ContentDecoded;
        @{$ReturnData}{ keys %URIData } = values %URIData;
    }
    elsif ( IsArrayRefWithData($ContentDecoded) ) {

        ELEMENT:
        for my $CurrentElement ( @{$ContentDecoded} ) {

            if ( IsHashRefWithData($CurrentElement) ) {
                @{$CurrentElement}{ keys %URIData } = values %URIData;
            }

            push @{$ReturnData}, $CurrentElement;
        }
    }
    else {
        return $Self->_Error(
            Summary   => 'Unsupported request content structure.',
            HTTPError => 500,
        );
    }

    # All OK - return data
    return {
        Success   => 1,
        Operation => $Operation,
        Data      => $ReturnData,
    };
}

=head2 ProviderGenerateResponse()

Generates response for an incoming web service request.

Throws a L<Kernel::System::Web::Exception> which contains a Plack response object.

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

    # Check success param.
    my $HTTPCode = 200;
    if ( !$Param{Success} ) {

        # Create Fault structure.
        my $FaultString = $Param{ErrorMessage} || 'Unknown';
        $Param{Data} = {
            faultcode   => 'Server',
            faultstring => $FaultString,
        };

        # Override HTTPCode to 500.
        $HTTPCode = 500;
    }

    # Orepare data.
    my $JSONString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Data},
    );

    if ( !$JSONString ) {
        $Self->_ThrowWebException(
            HTTPCode => 500,
            Content  => 'Error while encoding return JSON structure.',
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

        # The HTTP::Headers::Fast also includes Content-Type and Content-Length,
        # which should not be mirrored.
        my %RequestHeaders;
        FIELD_NAME:
        for my $FieldName ( sort $ParamObject->Headers->header_field_names ) {
            next FIELD_NAME if $FieldName eq 'Content-Type';
            next FIELD_NAME if $FieldName eq 'Content-Length';

            # normalize to uppercase separated by '-', e.g. FUNNY-FIELD
            my $HeaderKey = uc $FieldName;
            $HeaderKey =~ s{_}{-}xmsg;
            $RequestHeaders{$HeaderKey} = $ParamObject->Header($FieldName);
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
        Content  => $JSONString,
        Headers  => \%ResponseHeaders,    # added by OTOBOTicketInvoker
    );

    return;                               # actually not reached
}

=head2 RequesterPerformRequest()

Emit an outgoing web service request and receive the response. The supplied data is either sent
as JSON in the body or is added to the requested URL as a list of parameters.
Inspect the response and report the result as not successful when there are problems.
Return the received data otherwise.

    my $Result = $TransportObject->RequesterPerformRequest(
        Operation => 'remote_op', # name of remote operation to perform
        Data      => {            # data payload for request
            ...
        },
    );

in case of success:

    $Result = {
        Success       => 1,
        SizeExceeded  => 0,  # either 0 or 1 depending on the length of the response
        Data          => {
            ...
        },
    };

in case of failure:

    $Result = {
        Success      => 0,
        ErrorMessage => 'some message',
    };

=cut

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    # Check transport config.
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'REST Transport: Have no TransportConfig',
        };
    }

    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'REST Transport: Have no Config',
        };
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # Check required config.
    NEEDED:
    for my $Needed (qw(Host DefaultCommand Timeout)) {
        next NEEDED if IsStringWithData( $Config->{$Needed} );

        return {
            Success      => 0,
            ErrorMessage => "REST Transport: Have no $Needed in config",
        };
    }

    # Check data param.
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return {
            Success      => 0,
            ErrorMessage => 'REST Transport: Invalid Data',
        };
    }

    # Check operation param.
    if ( !IsStringWithData( $Param{Operation} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'REST Transport: Need Operation',
        };
    }

    # Create header container and add proper content type.
    # These headers will be used for calling the remote server.
    my %Headers = ( 'Content-Type' => 'application/json' );

    # Add AdditionalHeaders, but do not overwrite existing headers
    if ( IsHashRefWithData( $Self->{TransportConfig}->{Config}->{AdditionalHeaders} ) ) {
        my %AdditionalHeaders = $Self->{TransportConfig}->{Config}->{AdditionalHeaders}->%*;
        for my $AdditionalHeader ( sort keys %AdditionalHeaders ) {
            if ( !IsStringWithData( $Headers{$AdditionalHeader} ) ) {
                $Headers{$AdditionalHeader} = $AdditionalHeaders{$AdditionalHeader};
            }
        }
    }

    # set up a REST session
    my $RestClient = REST::Client->new(
        {
            host    => $Config->{Host},
            timeout => $Config->{Timeout},
        }
    );

    if ( !$RestClient ) {

        my $ErrorMessage = "Error while creating REST client from 'REST::Client'.";

        # Log to debugger.
        $Self->{DebuggerObject}->Error(
            Summary => $ErrorMessage,
        );

        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
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
                $RestClient->getUseragent()->ssl_opts(
                    $SSLOptionsMap{$SSLOption} => $Config->{SSL}->{$SSLOption},
                );
                next SSLOPTION;
            }

            # Passwords needs a special treatment.
            $RestClient->getUseragent()->ssl_opts(
                $SSLOptionsMap{$SSLOption} => sub { $Config->{SSL}->{$SSLOption} },
            );
        }

        # skip hostname verification
        if (
            IsStringWithData( $Config->{SSL}->{SSLVerifyHostname} )
            && $Config->{SSL}->{SSLVerifyHostname} eq 'No'
            )
        {
            $RestClient->getUseragent()->ssl_opts( verify_hostname => 0 );
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
            $RestClient->getUseragent()->no_proxy();
        }

        # Use proxy.
        elsif ( IsStringWithData( $Config->{Proxy}->{ProxyHost} ) ) {

            # Set host.
            $RestClient->getUseragent()->proxy(
                [ 'http', 'https', ],
                $Config->{Proxy}->{ProxyHost},
            );

            # Add proxy authentication.
            if (
                IsStringWithData( $Config->{Proxy}->{ProxyUser} )
                && IsStringWithData( $Config->{Proxy}->{ProxyPassword} )
                )
            {
                $Headers{'Proxy-Authorization'} = 'Basic ' . encode_base64(
                    $Config->{Proxy}->{ProxyUser} . ':' . $Config->{Proxy}->{ProxyPassword}
                );
            }
        }
    }

    # Add authentication options if configured.
    if ( IsHashRefWithData( $Config->{Authentication} ) && IsStringWithData( $Config->{Authentication}->{AuthType} ) ) {

        # basic auth
        if (
            $Config->{Authentication}->{AuthType} eq 'BasicAuth'
            && IsStringWithData( $Config->{Authentication}->{BasicAuthUser} )
            && IsStringWithData( $Config->{Authentication}->{BasicAuthPassword} )
            )
        {
            $Headers{Authorization} = 'Basic ' . encode_base64(
                $Config->{Authentication}->{BasicAuthUser} . ':' . $Config->{Authentication}->{BasicAuthPassword}
            );
        }

        # kerberos
        elsif (
            $Config->{Authentication}->{AuthType} eq 'Kerberos'
            && IsStringWithData( $Config->{Authentication}->{KerberosUser} )
            && IsStringWithData( $Config->{Authentication}->{KerberosKeytab} )
            )
        {
            if ( !-e $Config->{Authentication}->{KerberosKeytab} ) {
                $Self->{DebuggerObject}->Error(
                    Summary => "'$Config->{Authentication}->{KerberosKeytab}' does not exist.",
                );

                return {
                    Success      => 0,
                    ErrorMessage => "'$Config->{Authentication}->{KerberosKeytab}' does not exist.",
                };
            }
            if ( $Config->{Authentication}->{KerberosUser} =~ /[^\w[0-9]\-\._@]/ ) {
                $Self->{DebuggerObject}->Error(
                    Summary => "Invalid user format '$Config->{Authentication}->{KerberosUser}'.",
                );

                return {
                    Success      => 0,
                    ErrorMessage => "Invalid user format '$Config->{Authentication}->{KerberosUser}'.",
                };
            }

            my $KinitString = 'kinit -k -t ' . $Config->{Authentication}->{KerberosKeytab} . ' ' . $Config->{Authentication}->{KerberosUser};
            my $LogMessage  = qx{$KinitString 2>&1};

            if ( IsStringWithData($LogMessage) ) {
                $Self->{DebuggerObject}->Error(
                    Summary => 'kinit: ' . $LogMessage,
                );

                return {
                    Success      => 0,
                    ErrorMessage => 'kinit: ' . $LogMessage,
                };
            }
        }
    }

    if ( $Param{CustomHeader} ) {
        %Headers = (
            %Headers,
            %{ $Param{CustomHeader} },
        );

        $Self->{DebuggerObject}->Debug(
            Summary => "Custom headers used (might overwrite authorization)",
            Data    => join( '; ', keys $Param{CustomHeader}->%* ),
        );
    }

    my $RestCommand = $Config->{DefaultCommand};
    if ( IsStringWithData( $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Command} ) )
    {
        $RestCommand = $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Command};
    }

    $RestCommand = uc $RestCommand;

    if ( !grep { $_ eq $RestCommand } qw(GET POST PUT PATCH DELETE HEAD OPTIONS CONNECT TRACE) ) {

        my $ErrorMessage = "'$RestCommand' is not a valid REST command.";

        # Log to debugger.
        $Self->{DebuggerObject}->Error(
            Summary => $ErrorMessage,
        );

        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    if (
        !IsHashRefWithData( $Config->{InvokerControllerMapping} )
        || !IsHashRefWithData( $Config->{InvokerControllerMapping}->{ $Param{Operation} } )
        || !IsStringWithData(
            $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Controller}
        )
        )
    {
        my $ErrorMessage = "REST Transport: Have no Invoker <-> Controller mapping for Invoker '$Param{Operation}'.";

        # Log to debugger.
        $Self->{DebuggerObject}->Error(
            Summary => $ErrorMessage,
        );

        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    my $Controller = $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Controller};

    # Remove any query parameters that might be in the config,
    #   For example, from the controller: /Ticket/:TicketID/?:UserLogin&:Password
    #   controller must remain  /Ticket/:TicketID/
    my $QueryParamsStr = '';
    if ( $Controller =~ s{([^?]+)(.+)?}{$1} ) {

        # Remember the query parameters e.g. ?:UserLogin&:Password.
        # It is fine when $2 is not defined, that is when there is no '?' in $RequestURI
        $QueryParamsStr = $2;
    }

    # Replace any URI params with their actual value.
    #    for example: from /Ticket/:TicketID/:Other
    #    to /Ticket/1/2 (considering that $Param{Data} contains TicketID = 1 and Other = 2).
    my @ParamsToDelete;
    for my $ParamName ( sort keys %{ $Param{Data} } ) {
        if ( $Controller =~ m{:$ParamName(?=/|\?|$)}msx ) {
            my $ParamValue = $Param{Data}->{$ParamName};
            $ParamValue = uri_escape_utf8($ParamValue);
            $Controller =~ s{:$ParamName(?=/|\?|$)}{$ParamValue}msxg;
            push @ParamsToDelete, $ParamName;
        }
    }

    $Self->{DebuggerObject}->Debug(
        Summary => 'URI after interpolating URI params from outgoing data',
        Data    => "$RestCommand $Controller",
    );

    if ($QueryParamsStr) {

        # Replace any query params with their actual value
        #    for example: from ?UserLogin:UserLogin&Password=:Password
        #    to ?UserLogin=user&Password=secret
        #    (considering that $Param{Data} contains UserLogin = 'user' and Password = 'secret').
        my $ReplaceFlag;
        for my $ParamName ( sort keys %{ $Param{Data} } ) {
            if ( $QueryParamsStr =~ m{:$ParamName(?=&|$)}msx ) {
                my $ParamValue = $Param{Data}->{$ParamName};
                $ParamValue = uri_escape_utf8($ParamValue);
                $QueryParamsStr =~ s{:$ParamName(?=&|$)}{$ParamValue}msxg;
                push @ParamsToDelete, $ParamName;
                $ReplaceFlag = 1;
            }
        }

        # Append query params in the URI.
        if ($ReplaceFlag) {
            $Controller .= $QueryParamsStr;

            $Self->{DebuggerObject}->Debug(
                Summary => 'URI after interpolating Query params from outgoing data',
                Data    => "$RestCommand $Controller",
            );
        }
    }

    # Remove already used params.
    for my $ParamName (@ParamsToDelete) {
        delete $Param{Data}->{$ParamName};
    }

    # Get JSON and Encode object.
    my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    if ( IsHashRefWithData( $Param{Data} ) ) {

        # POST, PUT and PATCH can have Data in the Body.
        if (
            $RestCommand eq 'POST'
            || $RestCommand eq 'PUT'
            || $RestCommand eq 'PATCH'
            )
        {
            $Self->{DebuggerObject}->Debug(
                Summary => "Remaining outgoing data to be sent",
                Data    => $Param{Data},
            );

            $Param{Data} = $JSONObject->Encode(
                Data => $Param{Data},
            );

            # Make sure data is correctly encoded.
            $EncodeObject->EncodeOutput( \$Param{Data} );
        }

        # Whereas GET and the others just have a the data added to the Query URI.
        else {
            my $QueryParams = $RestClient->buildQuery( $Param{Data}->%* );

            # Check if controller already have a  question mark '?'.
            if ( $Controller =~ m{\?}msx ) {

                # Replace question mark '?' by an ampersand '&'.
                $QueryParams =~ s{\A\?}{&};
            }

            $Controller .= $QueryParams;

            $Self->{DebuggerObject}->Debug(
                Summary => "URI after adding Query params from outgoing data",
                Data    => $Controller,
            );

            $Self->{DebuggerObject}->Debug(
                Summary => "Remaining outgoing data to be sent",
                Data    => "No data is sent in the request body as $RestCommand command sets all"
                    . " Data as query params",
            );
        }
    }

    my @RequestParam = ($Controller);

    # Only POST, PUT or PATCH have a body. If it is empty
    # (i. e. $Param{Data} = {}), undef is passed to REST::Client.
    if (
        $RestCommand eq 'POST'
        || $RestCommand eq 'PUT'
        || $RestCommand eq 'PATCH'
        )
    {
        my $Body;
        if ( IsStringWithData( $Param{Data} ) ) {
            $Body = $Param{Data};
        }

        push @RequestParam, $Body;
    }

    # added for OTOBOTicketInvoker

    # Gather additional headers.
    %Headers = (
        %Headers,
        $Self->_HeadersGet(
            Type      => 'Invoker',
            Operation => $Param{Operation},
        ),
    );

    # Trigger mirror mode for headers (undocumented - only for UnitTests)
    if ( $Config->{UnitTestHeaders} ) {
        $Headers{Unittestheaders} = $Config->{UnitTestHeaders};
    }

    # Add headers to request
    push @RequestParam, \%Headers;

    # the actual request to the remote service
    $RestClient->$RestCommand(@RequestParam);

    my $ErrorMessage = "Error while performing REST '$RestCommand' request to Controller '$Controller' on Host '$Config->{Host}'.";
    my $ResponseError;
    if ( $Param{CustomResponseAssessor} ) {
        $ResponseError = $Param{CustomResponseAssessor}->(
            RestClient   => $RestClient,
            RestCommand  => $RestCommand,
            Controller   => $Controller,
            ErrorMessage => $ErrorMessage,
        );
    }
    else {
        $ResponseError = _AssessResponse(
            RestClient   => $RestClient,
            ErrorMessage => $ErrorMessage,
        );
    }

    my $ResponseCode    = $RestClient->responseCode();
    my $ResponseContent = $RestClient->responseContent();

    # Return early in case an error on response.
    if ($ResponseError) {
        my $ResponseData = IsStringWithData($ResponseContent)
            ?
            "Response content: '$ResponseContent'"
            :
            'No content provided.';

        # log to debugger and return as unsuccessfull
        return $Self->{DebuggerObject}->Error(
            Summary => $ResponseError,
            Data    => $ResponseData,
        );
    }

    # Send processed data to debugger.
    my $SizeExceeded = 0;
    {
        my $MaxSizeKiloBytes = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::ResponseLoggingMaxSize')
            || 200;
        my $MaxSizeBytes = $MaxSizeKiloBytes * 1024;
        my $SizeBytes    = bytes::length($ResponseContent);

        if ( $SizeBytes < $MaxSizeBytes ) {
            $Self->{DebuggerObject}->Debug(
                Summary => 'JSON data received from remote system',
                Data    => $ResponseContent,
            );
        }
        else {
            $SizeExceeded = 1;
            $Self->{DebuggerObject}->Debug(
                Summary => "JSON data received from remote system was too large for logging",
                Data    => 'See SysConfig option GenericInterface::Operation::ResponseLoggingMaxSize to change the maximum.',
            );
        }
    }

    $ResponseContent = $EncodeObject->Convert2CharsetInternal(
        Text => $ResponseContent,
        From => 'utf-8',
    );

    # To convert the data into a hash, use the JSON module.
    my $Result;

    if ( $ResponseCode ne '204' ) {

        $Result = $JSONObject->Decode(
            Data => $ResponseContent,
        );

        if ( !$Result ) {
            my $ResponseError = $ErrorMessage . ' Error while parsing JSON data.';

            # Log to debugger.
            $Self->{DebuggerObject}->Error(
                Summary => $ResponseError,
            );

            return {
                Success      => 0,
                ErrorMessage => $ResponseError,
            };
        }
    }

    # introduced for OTOBOTicketInvoker

    # Report mirrored headers, only used for UnitTests
    my %UnitTestHeaders;
    if ( $Config->{UnitTestHeaders} ) {
        HEADER:
        for my $Header ( $RestClient->responseHeaders ) {
            next HEADER if length($Header) < 25;
            next HEADER if substr( $Header, 0, 25 ) ne $Config->{UnitTestHeaders};

            $UnitTestHeaders{ substr( $Header, 25 ) } = $RestClient->responseHeader($Header);
        }
    }

    # All OK - return result.
    return {
        Success         => 1,
        Data            => $Result || undef,
        SizeExceeded    => $SizeExceeded,
        UnitTestHeaders => \%UnitTestHeaders,    # added by OTOBOTicketInvoker
    };
}

=begin Internal:

=head2 _AssessResponse()

Inspect the response immediately after the request.

=cut

sub _AssessResponse {
    my %Param = @_;

    my ( $RestClient, $ErrorMessage ) = @Param{qw(RestClient ErrorMessage)};

    my $ResponseCode    = $RestClient->responseCode;
    my $ResponseContent = $RestClient->responseContent;

    my $ResponseError;    # will be returned

    if ( !IsStringWithData($ResponseCode) ) {
        $ResponseError = $ErrorMessage;
    }

    if ( $ResponseCode !~ m{ \A 20 [0-9] \z }xms ) {
        $ResponseError = $ErrorMessage . " Response code '$ResponseCode'.";
    }

    if ( $ResponseCode ne '204' && !IsStringWithData($ResponseContent) ) {
        $ResponseError .= ' No content provided.';
    }

    return $ResponseError;
}

=head2 _ThrowWebException()

creates a M<Plack::Response> object, wrap it into a M<Kernel::System::Web::Exception>
and throw that object as an exception.

    # the sub dies
    $TransportObject->_ThrowWebException(
        HTTPCode => 500,               # http code to be returned, optional
        Content  => 'error message',   # message content
        Headers  => { Key => 'Val' }   # additional headers, optional
    );

=cut

sub _ThrowWebException {
    my ( $Self, %Param ) = @_;

    # Check params.
    if ( defined $Param{HTTPCode} && !IsInteger( $Param{HTTPCode} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid internal HTTPCode';
    }
    elsif ( defined $Param{Content} && !IsString( $Param{Content} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid Content';
    }

    # FIXME: according to SOAP::Transport::HTTP the previous should not be used
    #   for all supported browsers 'Status:' should be used here
    #   this breaks apache though

    # prepare data
    $Param{Content}  ||= '';
    $Param{HTTPCode} ||= 500;

    my $ContentType = $Param{HTTPCode} eq 200 ? 'application/json' : 'text/plain';

    # Log to debugger.
    my $DebugLevel = $Param{HTTPCode} eq 200 ? 'debug' : 'error';
    $Self->{DebuggerObject}->DebugLog(
        DebugLevel => $DebugLevel,
        Summary    => "Returning provider data to remote system (HTTP Code: $Param{HTTPCode})",
        Data       => $Param{Content},
    );

    # header for the response that will be thrown
    my @Headers;
    push @Headers, 'Content-Type' => "$ContentType; charset=UTF-8";
    push @Headers, 'Connection'   => ( $Self->{KeepAlive} ? 'Keep-Alive' : 'close' );

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

    # introduced by OTOBOTicketInvoker
    # Set additional headers.
    if ( $Param{Headers} ) {
        for my $Header ( sort keys $Param{Headers}->%* ) {
            push @Headers, $Header => $Param{Headers}->{$Header};
        }
    }

    # create the response
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

    # check needed params
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

    return unless IsHashRefWithData($Config);

    # the blacklisted headers are not sent
    my %IsBlacklisted = map
        { uc($_) => 1 }
        @{ $Kernel::OM->Get('Kernel::Config')->Get( 'GenericInterface::' . $Param{Type} . '::OutboundHeaderBlacklist' ) // [] };

    # Common headers.
    # These come first as specific headers might override them.
    my %Headers;
    if ( IsHashRefWithData( $Config->{Common} ) ) {
        HEADER:
        for my $Header ( sort keys $Config->{Common}->%* ) {
            next HEADER if $IsBlacklisted{ uc $Header };

            $Headers{$Header} = $Config->{Common}->{$Header};
        }
    }

    # Operation/Invoker specific headers.
    return %Headers unless $Param{Operation};
    return %Headers unless ref $Config->{Specific} eq 'HASH';
    return %Headers unless IsHashRefWithData( $Config->{Specific}->{ $Param{Operation} } );

    HEADER:
    for my $Header ( sort keys $Config->{Specific}->{ $Param{Operation} }->%* ) {
        next HEADER if $IsBlacklisted{ uc $Header };

        $Headers{$Header} = $Config->{Specific}->{ $Param{Operation} }->{$Header};
    }

    return %Headers;
}

=end Internal:

=cut

1;
