# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::Web::Response;

use strict;
use warnings;
use v5.24;
use namespace::clean;
use utf8;

# core modules

# CPAN modules
use Plack::Response;

# OTOCO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
);

=head1 NAME

Kernel::System::Web::Response - a wrapper around Plack::Response

=head1 DESCRIPTION

A wrapper around L<Plack::Response>.
Used for collecting the HTTP headers that should be emitted.
Also, the status code set in this object overrides in F<otobo.psgi> the default status code 200..

=head1 PUBLIC INTERFACE

=head2 new()

create an web response object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $ResponseObject = $Kernel::OM->Get('Kernel::System::Web::Response');

=cut

sub new {
    my ( $Class, @Args ) = @_;

    # wrap an instance of Plack::Response
    my $Self = {
        Response => Plack::Response->new(@Args),
    };

    return bless $Self, $Class;
}

=head2 Headers()

a wrapper of Plack::Response::headers().

=cut

sub Headers {
    my ( $Self, @Args ) = @_;

    return $Self->{Response}->headers(@Args);
}

=head2 Header()

a wrapper of Plack::Response::header().

=cut

sub Header {
    my ( $Self, @Args ) = @_;

    return $Self->{Response}->header(@Args);
}

=head2 Cookies()

a wrapper of Plack::Response::cookies().

=cut

sub Cookies {
    my ( $Self, @Args ) = @_;

    return $Self->{Response}->cookies(@Args);
}

=head2 Code()

a wrapper of Plack::Response::code().

=cut

sub Code {
    my ( $Self, @Args ) = @_;

    return $Self->{Response}->code(@Args);
}

=head2 Content()

a wrapper of Plack::Response::content().

=cut

sub Content {
    my ( $Self, @Args ) = @_;

    return $Self->{Response}->content(@Args);
}

=head2 Finalize()

a wrapper of Plack::Response::finalize().

=cut

sub Finalize {
    my $Self = shift;

    return $Self->{Response}->finalize();
}

1;
