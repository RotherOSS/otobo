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
use Email::Address::XS 1.04 ();

# OTOBO modules

our @ObjectDependencies = (
);

=encoding UTF-8

=head1 NAME

Kernel::System::EmailAddress - parse address lists and provide methods for working with the returned address objects

=head1 DESCRIPTION

The method C<ParseAddressLine()> returns an array of C<Email::Address::XS> objects.

The other methods provide access to these instances of C<Email::Address::XS>.

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

    my @AddressObjects = $EmailAddressObject->ParseAddressLine(
        Line => $Email
    );

Wrapper for C<Email::Address::XS->parse($Line)>, but cache it, since it's
not too fast, and often called.

Returns an array of C<Email::Address::XS> objects.

=cut

sub ParseAddressLine {
    my ( $Self, %Param ) = @_;

    my $Line  = $Param{Line};
    my $Cache = $Self->{ParseAddressLineCache};

    return $Cache->{$Line}->@* if $Cache->{$Line};

    my @AddressObjects = Email::Address::XS->parse($Line);
    $Cache->{$Line} = \@AddressObjects;

    return @AddressObjects;
}

=head2 GetAddress()

extracts the bare address from a complete email address. Only a single email address should be passed.

    my $SenderEmail = $EmailAddressObject->GetAddress(
        Email => 'August Ausprobierer <gustl@testanything.org>',
    );

or

    my $AddressObject = Email::Address::XS->new(
        'August Ausprobierer',
        'gustl@testanything.org'
    );
    my $SenderEmail = $EmailAddressObject->GetAddress(
        AddressObject => $AddressObject,
    );

Both variants return

    $SenderEmail = 'gustl@testanything.org'

Note that the address must contain the @ symbol.

=cut

sub GetAddress {
    my ( $Self, %Param ) = @_;

    if ( exists $Param{Email} ) {

        # get last address in the list, but only a single email address is expected
        my $Email = '';
        for my $EmailSplit ( $Self->ParseAddressLine( Line => $Param{Email} ) ) {
            $Email = $EmailSplit->address;
        }

        return $Email;
    }

    if ( exists $Param{AddressObject} ) {
        return $Param{AddressObject}->address;
    }

    # return empty list as a fallback
    return;
}

=head2 GetRealName()

extract the C<RealName>, that is the phrase, from a complete email address. Only a single email address should be passed.

    my $RealName = $EmailAddressObject->GetRealName(
        Email => 'Erna Extremtesterin <extremerna@testanything.org>',
    );

or

    my $AddressObject = Email::Address::XS->new(
        'Erna Extremtesterin',
        'extremerna@testanything.org'
    );
    my $RealName = $EmailAddressObject->GetRealName(
        AddressObject => $AddressObject,
    );

Both variants return

    $RealName = 'Erna Extremtesterin'

=cut

sub GetRealName {
    my ( $Self, %Param ) = @_;

    # The parameter AddressObject has precedence
    if ( exists $Param{AddressObject} ) {
        return $Param{AddressObject}->phrase;
    }

    # find "NamePart, NamePart" <some@example.com> (get not recognized by Email::Address::XS)
    if ( $Param{Email} =~ /"(.+?)"\s+?\<.+?@.+?\..+?\>/ ) {
        my $RealName = $1;

        # removes unnecessary blank spaces, if the string has quotes.
        # This is because of bug 6059
        $RealName =~ s/"\s+?(.+?)\s+?"/"$1"/g;

        return $RealName;
    }

    # fallback to Email::Address::XS
    # The real name of the last address is returned, but note that usually only a single address is passed
    my $RealName;
    for my $EmailSplit ( $Self->ParseAddressLine( Line => $Param{Email} ) ) {
        $RealName = $EmailSplit->phrase;
    }

    return $RealName;
}

=head2 Format()

Format a Email::Address::XS object or an address given as a string.

    my $FormattedAddress = $EmailAddressObject->Format(
        AddressObject => Email::Address::XS->new(
            'Erna Extremtesterin',
            'extremerna@testanything.org'
            'extreme testing is good'
        );
    );

or

    my $FormattedAddress = $EmailAddressObject->Format(
        Email => 'dummy <dummy@testanything.org>,   Erna Extremtesterin     <extremerna@testanything.org>   (extreme testing is good) ',
    );

or

    my $FormattedAddress = $EmailAddressObject->Format(
        Realname => 'Ben 🐛 Bugfinder',
        Address => 'bugfinder@testanything.org'
    );

The first two variants support comments. They return:

    $FormattedAddress = 'Erna Extremtesterin <extremerna@testanything.org> (extreme testing is good)'

The third variant does not support comments. It returns:

    $FormattedAddress = '"Ben 🐛 Bugfinder" <bugfinder@testanything.org>';

An empty string is returned as fallback.

=cut

sub Format {
    my ( $Self, %Param ) = @_;

    # The parameter AddressObject has precedence
    if ( exists $Param{AddressObject} ) {
        return $Param{AddressObject}->format;
    }

    # The parameter Email is second in line
    if ( exists $Param{Email} ) {

        # get last address in the list, but only a single email address is expected
        my $FormattedAddress = '';

        for my $EmailSplit ( $Self->ParseAddressLine( Line => $Param{Email} ) ) {
            $FormattedAddress = $EmailSplit->format // '';
        }

        return $FormattedAddress;
    }

    # alternatively the phrase and the address can be passed
    if ( $Param{Realname} || $Param{Address} ) {
        return Email::Address::XS->new(
            phrase  => $Param{Realname},
            address => $Param{Address},
        )->format;
    }

    # the fallback
    return '';
}

1;
