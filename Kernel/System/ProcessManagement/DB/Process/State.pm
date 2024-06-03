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

package Kernel::System::ProcessManagement::DB::Process::State;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ProcessManagement::DB::Process::State

=head1 DESCRIPTION

Process Management DB State backend

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ProcessStateObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process::State');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # create States list
    $Self->{StateList} = {
        'S1' => Translatable('Active'),
        'S2' => Translatable('Inactive'),
        'S3' => Translatable('FadeAway'),
    };

    return $Self;
}

=head2 StateList()

get a State list

    my $List = $StateObject->StateList(
        UserID => 123,
    );

    Returns:

    $List = {
        'S1' => 'Active',
        'S2' => 'Inactive',
        'S3' => 'FadeAway',
    }

=cut

sub StateList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    return $Self->{StateList};
}

=head2 StateLookup()

get State name or State EntityID

    my $Name = $StateObject->StateLookup(
        EntityID => 'S1',
        UserID   => 123,
    );

    Returns:
    $Name = 'Active';

    my $EntityID = $StateObject->StateLookup(
        Name     => 'Active',
        UserID   => 123,
    );

    Returns:
    $EntityID = 'S1';

=cut

sub StateLookup {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    if ( !$Param{EntityID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EntityID or Name is required!",
        );
        return;
    }

    # return state name
    my $Result;
    if ( $Param{EntityID} ) {
        $Result = $Self->{StateList}->{ $Param{EntityID} };
    }

    # return state entity ID
    else {
        my %ReversedStateList = reverse %{ $Self->{StateList} };
        $Result = $ReversedStateList{ $Param{Name} };
    }

    return $Result;
}

1;
