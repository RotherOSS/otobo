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

package Kernel::GenericInterface::Transport;

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Transport - GenericInterface network transport interface

=head1 PUBLIC INTERFACE

=head2 new()

create an object.

    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Transport;

    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig   => {
            DebugThreshold  => 'debug',
            TestMode        => 0,           # optional, in testing mode the data will not be written to the DB
            # ...
        },
        WebserviceID      => 12,
        CommunicationType => Requester, # Requester or Provider
        RemoteIP          => 192.168.1.1, # optional
    );
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        DebuggerObject => $DebuggerObject,
        TransportConfig => {
            Type => 'HTTP::SOAP',
            Config => {
                ...
            },
        },
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {}, $Type;

    for my $Needed (qw( DebuggerObject TransportConfig)) {
        $Self->{$Needed} = $Param{$Needed} || return {
            Success => 0,
            Summary => "Got no $Needed!",
        };
    }

    # select and instantiate the backend
    my $Backend = 'Kernel::GenericInterface::Transport::' . $Self->{TransportConfig}->{Type};

    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Backend) ) {
        return $Self->{DebuggerObject}->Error( Summary => "Backend $Backend not found." );
    }

    $Self->{BackendObject} = $Backend->new( $Self->%* );

    # if the backend constructor failed, it returns an error hash, pass it on in this case
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $Backend;

    return $Self;
}

=head2 ProviderProcessRequest()

process an incoming web service request. This function has to read the request data
from the web server process.

    my $Result = $TransportObject->ProviderProcessRequest();

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Operation       => 'DesiredOperation',  # name of the operation to perform
        Data            => {                    # data payload of request
            ...
        },
    };

=cut

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    my $Result = $Self->{BackendObject}->ProviderProcessRequest(%Param);

    # make sure an operation is provided in success case
    if ( $Result->{Success} && !$Result->{Operation} ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'TransportObject backend did not return an operation',
        );
    }

    return $Result;
}

=head2 ProviderGenerateResponse()

generate response for an incoming web service request.

Throws a L<Kernel::System::Web::Exception> which contains a Plack response object.

    $TransportObject->ProviderGenerateResponse(
        Success         => 1,       # 1 or 0
        ErrorMessage    => '',      # in case of an error, optional
        Data            => {        # data payload for response, optional
            ...
        },
    );

=cut

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    my $ErrorMessage;
    if ( !defined $Param{Success} ) {
        $ErrorMessage = 'Missing parameter Success.';
    }
    elsif ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $ErrorMessage = 'Data is not a hash reference.';
    }

    # throw errors as an exception
    if ($ErrorMessage) {

        $Self->{DebuggerObject}->Error(
            Summary => $ErrorMessage,
        );

        # The Content-Length will be set later in the middleware Plack::Middleware::ContentLength. This requires that
        # there are no multi-byte characters in the delivered content. This is because the middleware
        # uses core::length() for determining the content length.
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$ErrorMessage );

        # a response with code 500
        my $PlackResponse = Plack::Response->new(
            500,
            [],
            $ErrorMessage,
        );

        # The exception is caught be Plack::Middleware::HTTPExceptions
        die Kernel::System::Web::Exception->new(
            PlackResponse => $PlackResponse,
        );
    }

    # throws an exception
    $Self->{BackendObject}->ProviderGenerateResponse(%Param);

    return;    # actually not reached
}

=head2 RequesterPerformRequest()

generate an outgoing web service request, receive the response and return its data.
The actual work is done by the backend objects.

    my $Result = $TransportObject->RequesterPerformRequest(
        Operation       => 'remote_op', # name of remote operation to perform
        Data            => {            # data payload for request
            ...
        },
    );

Returns:

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {
            ...
        },
    };

=cut

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Operation} ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Missing parameter Operation.',
        );
    }

    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Data is not a hash reference.',
        );
    }

    return $Self->{BackendObject}->RequesterPerformRequest(%Param);
}

1;
