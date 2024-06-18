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

package Kernel::System::SupportDataCollector::PluginBase;

use strict;
use warnings;

# core modules
use Scalar::Util qw(blessed);

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our $StatusUnknown = 0;
our $StatusInfo    = 1;
our $StatusOK      = 2;
our $StatusWarning = 3;
our $StatusProblem = 4;

our %Status2Name = (
    $StatusUnknown => Translatable('Unknown'),
    $StatusOK      => Translatable('OK'),
    $StatusWarning => Translatable('Warning'),
    $StatusProblem => Translatable('Problem'),
    $StatusInfo    => Translatable('Information'),
);

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash ref to object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

# Override this in the plugins to specify their DisplayPath
sub GetDisplayPath {
    return Translatable('General');
}

sub AddResultUnknown {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusUnknown,
    );
}

sub AddResultInformation {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusInfo,
    );
}

sub AddResultOk {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusOK,
    );
}

sub AddResultWarning {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusWarning,
    );
}

sub AddResultProblem {
    my ( $Self, %Param ) = @_;

    return $Self->_AddResult(
        %Param,
        Status => $StatusProblem,
    );
}

sub _AddResult {
    my ( $Self, %Param ) = @_;

    my %Result = %Param;
    $Result{Identifier} //= '';
    $Result{Identifier} =~ s{:+}{_};    # Replace all :: in the Identifier
    if ( $Result{Identifier} ) {
        $Result{Identifier} = blessed($Self) . "::$Result{Identifier}";
    }
    else {
        $Result{Identifier} = blessed($Self);
    }

    $Result{ShortIdentifier} = $Result{Identifier};
    $Result{ShortIdentifier} =~ s{Kernel::System::SupportDataCollector::Plugin(Asynchronous)?::}{}xmsg;

    $Result{DisplayPath} //= $Self->GetDisplayPath();

    $Self->{Results} //= [];
    push @{ $Self->{Results} }, \%Result;
    return;
}

sub GetResults {
    my ( $Self, %Param ) = @_;

    return (
        Success => 1,
        Result  => $Self->{Results} // [],
    );
}

1;
