# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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

A wrapper around M<Plack::Response>. Use for collecting the HTTP headers that should be emitted.

=head1 PUBLIC INTERFACE

=head2 new()

create response object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $ResponseObject = $Kernel::OM->Get('Kernel::System::Web::Response');

=cut

sub new {
    my $Type = shift;

    # wrap an instance of Plack::Response
    my $Self = {
        Response => Plack::Response->new(@_);
    };

    return bless $Self, $Type;
}

=head2 Headers()

a wrapper of Plack::Response::headers().

=cut

sub Headers {
    my $Self = shift;

    return $Self->{Response}->headers(@_);
}

=head2 Header()

a wrapper of Plack::Response::header().

=cut

sub Header {
    my $Self = shift;

    return $Self->{Response}->header(@_);
}

=head2 Code()

a wrapper of Plack::Response::code().

=cut

sub Code {
    my $Self = shift;

    return $Self->{Response}->code(@_);
}

=head2 Content()

a wrapper of Plack::Response::content().

=cut

sub Content {
    my $Self = shift;

    return $Self->{Response}->content(@_);
}

=head2 Finalize()

a wrapper of Plack::Response::finalize().

=cut

sub Finalize {
    my $Self = shift;

    return $Self->{Response}->finalize();
}

1;
