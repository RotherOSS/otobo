# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::Web::Exception;

=head1 NAME

Kernel::System::Web::Exception - an exception object for Plack::Middleware::HTTPExceptions

=head1 SYNOPSIS

    use Kernel::System::Web::Exception;

    # fatal error encounted during handling of a request
    my $IsFatal = 1;
    if ( $IsFatal ) {
        my $Content = "HTTP/1.1 200 OK\nContent-Type: text/plan{\n\nOberwalting, we have a problem";
        die Kernel::System::Web::Exception->new( Content => $Content );
    }

=head1 DESCRIPTION

The thrown instance provides the method C<as_psgi()> which can be handled by C<Plack::Middleware::HTTPExceptions>.

=cut

use v5.24.0;
use warnings;
use utf8;

# core modules

# CPAN modules
use CGI::Parse::PSGI qw(parse_cgi_output);

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 PUBLIC INTERFACE

=head2 new()

create an exception object

    use Kernel::System::Web::Exception;

    my $Content = "HTTP/1.1 200 OK\nContent-Type: text/plan{\n\nOberwalting, we have a problem";

    die Kernel::System::Web::Exception->new( Content => $Content );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # start with a hash containing the params
    return bless {%Param}, $Type;
}

=head2 as_psgi()

make use of a caught exception object

    my $Response = $CaughtObject->as_psgi()

=cut

sub as_psgi {    ## no critic qw(OTOBO::RequireCamelCase)
    my $Self = shift;

    # The thrower created the error message
    if ( $Self->{Content} ) {
        utf8::encode( $Self->{Content} );

        return parse_cgi_output( \$Self->{Content} );
    }

    # error as default
    return Plack::Response->new( 500, { 'Content-Type' => 'text/html' }, 'empty exception' );
}

1;
