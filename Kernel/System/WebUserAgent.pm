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

package Kernel::System::WebUserAgent;

use strict;
use warnings;

# core modules
use List::Util qw(first);

# CPAN modules
use HTTP::Headers  ();
use LWP::UserAgent ();

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::WebUserAgent - a web user agent lib

=head1 DESCRIPTION

All web user agent functions.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    use Kernel::System::WebUserAgent;

    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        Timeout => 15,                  # optional, timeout
        Proxy   => 'proxy.example.com', # optional, proxy
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # get database object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Self->{Timeout} = $Param{Timeout} || $ConfigObject->Get('WebUserAgent::Timeout') || 15;
    $Self->{Proxy}   = $Param{Proxy}   || $ConfigObject->Get('WebUserAgent::Proxy')   || '';

    return $Self;
}

=head2 Request()

return the content of requested URL.

Simple GET request:

    my %Response = $WebUserAgentObject->Request(
        URL => 'http://example.com/somedata.xml',
        SkipSSLVerification => 1, # (optional)
        NoLog               => 1, # (optional)
    );

Or a POST request; attributes can be a hashref like this:

    my %Response = $WebUserAgentObject->Request(
        URL  => 'http://example.com/someurl',
        Type => 'POST',
        Data => { Attribute1 => 'Value', Attribute2 => 'Value2' },
        SkipSSLVerification => 1, # (optional)
        NoLog               => 1, # (optional)
    );

alternatively, you can use an arrayref like this:

    my %Response = $WebUserAgentObject->Request(
        URL  => 'http://example.com/someurl',
        Type => 'POST',
        Data => [ Attribute => 'Value', Attribute => 'OtherValue' ],
        SkipSSLVerification => 1, # (optional)
        NoLog               => 1, # (optional)
    );

returns

    %Response = (
        Status  => '200 OK',    # http status
        Content => $ContentRef, # content of requested URL
    );

You can even pass some headers

    my %Response = $WebUserAgentObject->Request(
        URL    => 'http://example.com/someurl',
        Type   => 'POST',
        Data   => [ Attribute => 'Value', Attribute => 'OtherValue' ],
        Header => {
            Authorization => 'Basic xxxx',
            Content_Type  => 'text/json',
        },
        SkipSSLVerification => 1, # (optional)
        NoLog               => 1, # (optional)
    );

If you need to set credentials

    my %Response = $WebUserAgentObject->Request(
        URL          => 'http://example.com/someurl',
        Type         => 'POST',
        Data         => [ Attribute => 'Value', Attribute => 'OtherValue' ],
        Credentials  => {
            User     => 'otobo_user',
            Password => 'otobo_password',
            Realm    => 'OTOBO Unittests',
            Location => 'ftp.otobo.org:80',
        },
        SkipSSLVerification => 1, # (optional)
        NoLog               => 1, # (optional)
    );

=cut

sub Request {
    my ( $Self, %Param ) = @_;

    # define method - default to GET
    $Param{Type} ||= 'GET';

    my $Response;

    # init agent
    my $UserAgent = LWP::UserAgent->new();

    # In some scenarios like transparent HTTPS proxies, it can be neccessary to turn off
    #   SSL certificate validation.
    if (
        $Param{SkipSSLVerification}
        || $Kernel::OM->Get('Kernel::Config')->Get('WebUserAgent::DisableSSLVerification')
        )
    {
        $UserAgent->ssl_opts(
            verify_hostname => 0,
        );
    }

    # set credentials
    if ( $Param{Credentials} ) {
        my %CredentialParams    = %{ $Param{Credentials} || {} };
        my @Keys                = qw(Location Realm User Password);
        my $AllCredentialParams = !first { !defined $_ } @CredentialParams{@Keys};

        if ($AllCredentialParams) {
            $UserAgent->credentials(
                @CredentialParams{@Keys},
            );
        }
    }

    # set headers
    if ( $Param{Header} ) {
        $UserAgent->default_headers(
            HTTP::Headers->new( %{ $Param{Header} } ),
        );
    }

    # set timeout
    $UserAgent->timeout( $Self->{Timeout} );

    # get database object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # set user agent
    $UserAgent->agent(
        $ConfigObject->Get('Product') . ' ' . $ConfigObject->Get('Version')
    );

    # set proxy
    if ( $Self->{Proxy} ) {
        $UserAgent->proxy( [ 'http', 'https', 'ftp' ], $Self->{Proxy} );
    }

    if ( $Param{Type} eq 'GET' ) {

        # perform get request on URL
        $Response = $UserAgent->get( $Param{URL} );
    }

    else {

        # check for Data param
        if ( !IsArrayRefWithData( $Param{Data} ) && !IsHashRefWithData( $Param{Data} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    'WebUserAgent POST: Need Data param containing a hashref or arrayref with data.',
            );
            return ( Status => 0 );
        }

        # perform post request plus data
        $Response = $UserAgent->post( $Param{URL}, $Param{Data} );
    }

    if ( !$Response->is_success() ) {

        if ( !$Param{NoLog} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't perform $Param{Type} on $Param{URL}: " . $Response->status_line(),
            );
        }

        return (
            Status => $Response->status_line(),
        );
    }

    # get the content to convert internal used charset
    my $ResponseContent = $Response->decoded_content();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$ResponseContent );

    if ( $Param{Return} && $Param{Return} eq 'REQUEST' ) {
        return (
            Status  => $Response->status_line(),
            Content => \$Response->request()->as_string(),
        );
    }

    # return request
    return (
        Status  => $Response->status_line(),
        Content => \$ResponseContent,
    );
}

1;
