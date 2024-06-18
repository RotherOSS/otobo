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

package Kernel::System::Web::App;

=head1 NAME

Kernel::System::Web::App - a PSGI App module that wraps the OTOBO interface modules

=head1 SYNOPSIS

    # A Plack app module

=head1 DESCRIPTION

Call the C<Response()> method of the interface modules. The constructor argument I<Interface> is required.
The argument I<Debug> is optional and defaults to 0.

    mount "/public.pl" => Kernel::System::Web::App->new(
        Debug     => 0,
        Interface =>  'Kernel::System::Web::InterfacePublic',
    )->to_app;

=cut

use strict;
use warnings;
use v5.24;
use utf8;

use parent qw(Plack::Component);

# core modules

# CPAN modules
use Plack::Util;

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 PUBLIC INTERFACE

=head2 prepare_app()

load the requested interface module

=cut

sub prepare_app {
    my ($Self) = @_;

    # set defaults
    $Self->{Debug} //= 0;

    # load interface modules on startup
    Plack::Util::load_class( $Self->{Interface} );

    return;
}

=head2 call()

generate a PSGI response for a PSGI Environment

=cut

sub call {
    my ( $Self, $Env ) = @_;

    # $Self->{Interface} was loaded in prepare_app().
    return $Self->{Interface}->new(
        Debug   => $Self->{Debug},
        PSGIEnv => $Env,
    )->Response;
}

1;
