# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::EmailAddress;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Mail::Address 2.18 ();

# OTOBO modules

our @ObjectDependencies = (
);

=head1 NAME

Kernel::System::EmailAddress - parse address lists and provide methods for working with the returned address objects

=head1 DESCRIPTION

The method C<ParseAddressLine()> returns an array of C<Mail::Address> objects.

The other methods provide access to these instances of C<Mail::Address>.

=head1 PUBLIC INTERFACE

=head2 new()

create a service definition module for email addresses. Do not use it directly, instead use:

    my $EmailAddressObject = $Kernel::OM->Get('Kernel::System::EmailAddress');

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    return bless {
        ParseAddressLineCache => {},
    }, $Type;
}

=head2 ParseAddressLine()

    my @MailAddressObjects = $ParserObject->ParseAddressLine( Line => $Email );

Wrapper for C<Mail::Address->parse($Line)>, but cache it, since it's
not too fast, and often called.

Returns an array of C<Mail::Address> objects.

=cut

sub ParseAddressLine {
    my ( $Self, %Param ) = @_;

    my $Line  = $Param{Line};
    my $Cache = $Self->{ParseAddressLineCache};

    return $Cache->{$Line}->@* if $Cache->{$Line};

    my @AddressObjects = Mail::Address->parse($Line);
    $Cache->{$Line} = \@AddressObjects;

    return @AddressObjects;
}

1;
