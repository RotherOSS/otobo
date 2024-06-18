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

package Kernel::GenericInterface::Transport::HTTP::Test;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules

# CPAN modules
use HTTP::Request::Common qw(POST);
use LWP::UserAgent        ();
use LWP::Protocol         ();
use Plack::Response       ();

# OTOBO modules
use Kernel::System::Web::Exception ();

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Transport::HTTP::Test - GenericInterface network transport interface for testing purposes

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Transport->new();

    use Kernel::GenericInterface::Transport;

    my $TransportObject = Kernel::GenericInterface::Transport->new(

        TransportConfig => {
            Type => 'HTTP::Test',
            Config => {
                Fail => 0,  # 0 or 1
            },
        },
    );

In the config parameter 'Fail' you can tell the transport to simulate
failed network requests. If 'Fail' is set to 0, the transport will return
the query string of the requests as return data (see L</RequesterPerformRequest()>
for an example);

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {}, $Type;

    for my $Needed (qw( DebuggerObject TransportConfig)) {
        $Self->{$Needed} = $Param{$Needed} || return {
            Success      => 0,
            ErrorMessage => "Got no $Needed!"
        };
    }

    return $Self;
}

=head2 ProviderProcessRequest()

this will read the incoming HTTP request via CGI and
return the HTTP parameters in the data hash.

=cut

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    if ( $Self->{TransportConfig}->{Config}->{Fail} ) {

        return {
            Success      => 0,
            ErrorMessage => "HTTP status code: 500",
            Data         => {},
        };
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %Result;
    for my $ParamName ( $ParamObject->GetParamNames() ) {
        $Result{$ParamName} = $ParamObject->GetParam( Param => $ParamName );
    }

    # special handling for empty post request
    if ( scalar keys %Result == 1 && exists $Result{POSTDATA} && !$Result{POSTDATA} ) {
        %Result = ();
    }

    if ( !%Result ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'No request data found.',
        );
    }

    return {
        Success   => 1,
        Data      => \%Result,
        Operation => 'test_operation',
    };
}

=head2 ProviderGenerateResponse()

Throws a L<Kernel::System::Web::Exception> which contains a Plack response object.

This will generate a query string from the passed data hash.
and generate an HTTP response with this string as the body.

The response will be thrown as an exception.

=cut

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    my $PlackResponse;

    if ( $Self->{TransportConfig}->{Config}->{Fail} ) {

        my $ErrorMessage = 'Test response generation failed';

        # The Content-Length will be set later in the middleware Plack::Middleware::ContentLength. This requires that
        # there are no multi-byte characters in the delivered content. This is because the middleware
        # uses core::length() for determining the content length.
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$ErrorMessage );

        # a response with code 500
        $PlackResponse = Plack::Response->new(
            500,
            [],
            $ErrorMessage,
        );

    }
    elsif ( !$Param{Success} ) {
        my $ErrorMessage = $Param{ErrorMessage} || 'Internal Server Error';

        # The Content-Length will be set later in the middleware Plack::Middleware::ContentLength. This requires that
        # there are no multi-byte characters in the delivered content. This is because the middleware
        # uses core::length() for determining the content length.
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$ErrorMessage );

        # a response with code 500
        $PlackResponse = Plack::Response->new(
            500,
            [],
            $ErrorMessage,
        );
    }
    else {

        # generate a request string from the data
        my $Request = POST( 'http://testhost.local/', Content => $Param{Data} );

        # The Content-Length will be set later in the middleware Plack::Middleware::ContentLength. This requires that
        # there are no multi-byte characters in the delivered content. This is because the middleware
        # uses core::length() for determining the content length.
        my $Content = $Request->content;
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Content );

        $PlackResponse = Plack::Response->new(
            200,
            [ 'Content-Type' => 'text/plain; charset=UTF-8' ],
            $Content
        );
    }

    my $SerialisedResponse = join "\n",
        $PlackResponse->code,
        $PlackResponse->headers->as_string,
        $PlackResponse->body;
    $Self->{DebuggerObject}->Debug(
        Summary => 'Sending HTTP response',
        Data    => $SerialisedResponse,
    );

    # The exception is caught be Plack::Middleware::HTTPExceptions
    die Kernel::System::Web::Exception->new(
        PlackResponse => $PlackResponse,
    );
}

=head2 RequesterPerformRequest()

in Fail mode, returns error status. Otherwise, returns the
query string generated out of the data for the HTTP response.

    my $Result = $TransportObject->RequesterPerformRequest(
        Data => {
            A => 'A',
            b => 'b',
        },
    );

Returns

    $Result = {
        Success => 1,
        Data => {
            ResponseData => 'A=A&b=b',
        },
    };

=cut

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    if ( $Self->{TransportConfig}->{Config}->{Fail} ) {

        return {
            Success      => 0,
            ErrorMessage => "HTTP status code: 500",
            Data         => {},
        };
    }

    # use custom protocol handler to avoid sending out real network requests
    LWP::Protocol::implementor(
        testhttp => 'Kernel::GenericInterface::Transport::HTTP::Test::CustomHTTPProtocol'
    );
    my $UserAgent = LWP::UserAgent->new();
    my $Response  = $UserAgent->post( 'testhttp://localhost.local/', Content => $Param{Data} );

    return {
        Success => 1,
        Data    => {
            ResponseContent => $Response->content(),
        },
    };
}

=begin Internal:

=cut

=head1 NAME

Kernel::GenericInterface::Transport::HTTP::Test::CustomHTTPProtocol

=head1 DESCRIPTION

This package is used to handle the custom HTTP requests of
Kernel::GenericInterface::Transport::HTTP::Test.
The requests are immediately answered with a response, without
sending them out to the network.

=cut

package Kernel::GenericInterface::Transport::HTTP::Test::CustomHTTPProtocol;    ## no critic qw(Modules::ProhibitMultiplePackages)

use parent qw(LWP::Protocol);

sub new {
    my $Class = shift;

    return $Class->SUPER::new(@_);
}

sub request {    ## no critic qw(Subroutines::RequireArgUnpacking)
    my $Self = shift;

    my ( $Request, $Proxy, $Arg, $Size, $Timeout ) = @_;

    my $Response = HTTP::Response->new( 200 => "OK" );
    $Response->protocol('HTTP/1.0');
    $Response->content_type("text/plain; charset=UTF-8");
    $Response->add_content_utf8( $Request->content() );
    $Response->date(time);

    return $Response;
}

=end Internal:

=cut

1;
