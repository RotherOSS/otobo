# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Modules::AgentReferenceSearch;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # only search is supported
    return $LayoutObject->JSONReply(
        Data => {
            Success  => 0,
            Messsage => qq{Subaction '$Self->{Subaction}' is not supported!},
        },
    ) if $Self->{Subaction};

    # Get name of the DF from $ParamObject, bail out when not found
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Field       = $ParamObject->GetParam( Param => 'Field' );
    my $DFName;
    if (
        !$Field
        ||
        (
            $Field !~ m{ \A Autocomplete_DynamicField_ (.*) \z }xms
            && $Field !~ m{ \A Search_DynamicField_ (.*) \z }xms
        )
        )
    {
        return $LayoutObject->JSONReply(
            Data => {
                Success  => 0,
                Messsage => 'Need Field!',
            },
        );
    }
    else {
        $DFName = $1;    # remove either the prefix Autocomplete_DynamicField_ or the prefix Search_DynamicField_
    }

    # Get config for the dynamic field and check the sanity.
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => $DFName,
    );

    # check the dynamic field
    if ( !IsHashRefWithData($DynamicField) || $DynamicField->{FieldType} ne 'Reference' ) {
        return $LayoutObject->JSONReply(
            Data => {
                Success  => 0,
                Messsage => 'Error reading dynamic field!',
            }
        );
    }

    # search referenced object
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $ObjectType   = $DynamicField->{Config}->{ReferencedObjectType};
    my $PluginModule = join '::', 'Kernel::System::DynamicField::Driver::Reference', $ObjectType;

    if ( !$MainObject->Require($PluginModule) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't load Reference dynamic field plugin module for object type $ObjectType!",
        );

        return;
    }

    # create a plugin object
    # TODO: maybe use a module like Kernel::System::DynamicFieldReference.pm
    my $PluginObject = $PluginModule->new;
    if ( !$PluginObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Couldn't create a plugin object for object type $ObjectType!",
        );

        return;
    }

    my $MaxResults = int( $ParamObject->GetParam( Param => 'MaxResults' ) || 20 );
    my $Term       = $ParamObject->GetParam( Param => 'Term' ) || '';

    my @ObjectIDs = $PluginObject->SearchObjects(
        Term       => $Term,
        MaxResults => $MaxResults,
        UserID     => 1,             # TODO: what about Permission check
    );

    my @Results;
    for my $ObjectID (@ObjectIDs) {
        my %Description = $PluginObject->ObjectDescriptionGet(
            ObjectID => $ObjectID,
            UserID   => 1,           # TODO: what about Permission check
        );

        push @Results, {
            Key   => $ObjectID,
            Value => $Description{Long},
        };
    }

    return $LayoutObject->JSONReply(
        Data => \@Results,
    );
}

1;
