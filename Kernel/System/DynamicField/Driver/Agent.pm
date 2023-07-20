# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::DynamicField::Driver::Agent;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseEntity);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Agent - driver for the Agent dynamic field

=head1 DESCRIPTION

DynamicFields Agent Driver delegate.

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 1,
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 0,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 1,
        'IsLikeOperatorCapable'        => 1,
        'IsSetCapable'                 => 1,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::Agent');

    EXTENSION:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # skip invalid extensions
        next EXTENSION if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension has a new module
        if ( $Extension->{Module} ) {

            # check if module can be loaded
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # check if extension contains more behaviors
        if ( IsHashRefWithData( $Extension->{Behaviors} ) ) {

            %{ $Self->{Behaviors} } = (
                %{ $Self->{Behaviors} },
                %{ $Extension->{Behaviors} }
            );
        }
    }

    return $Self;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # activate HTMLOutput when it wasn't specified
    my $HTMLOutput = $Param{HTMLOutput} // 1;

    # get raw Value strings from field value
    my @Values = !ref $Param{Value}
        ? ( $Param{Value} )
        : scalar $Param{Value}->@* ? $Param{Value}->@*
        :                            ('');

    $Param{ValueMaxChars} ||= '';

    my @ReadableValues;
    my @ReadableTitles;
    for my $ValueItem (@Values) {
        $ValueItem //= '';

        # replace agent login with full name
        if ($ValueItem) {
            $ValueItem = $Kernel::OM->Get('Kernel::System::User')->UserName(
                UserID => $ValueItem,
            );
        }

        # set title as value after update and before limit
        push @ReadableTitles, $ValueItem;

        # HTML Output transformation
        if ($HTMLOutput) {
            $ValueItem = $Param{LayoutObject}->Ascii2Html(
                Text => $ValueItem,
                Max  => $Param{ValueMaxChars},
            );
        }
        else {
            if ( $Param{ValueMaxChars} && length($ValueItem) > $Param{ValueMaxChars} ) {
                $ValueItem = substr( $ValueItem, 0, $Param{ValueMaxChars} ) . '...';
            }
        }

        push @ReadableValues, $ValueItem;
    }

    my $ValueSeparator;
    my $Title = join( ', ', @ReadableTitles );

    # HTMLOutput transformations
    if ($HTMLOutput) {
        $Title = $Param{LayoutObject}->Ascii2Html(
            Text => $Title,
            Max  => $Param{TitleMaxChars} || '',
        );
        $ValueSeparator = '<br/>';
    }
    else {
        if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
            $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
        }
        $ValueSeparator = "\n";
    }

    # this field type does not support the Link Feature
    my $Link;

    # return a data structure
    return {
        Value => '' . join( $ValueSeparator, @ReadableValues ),
        Title => '' . $Title,
        Link  => $Link,
    };
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    # set Value and Title variables
    my $Value = '';
    my $Title = '';

    # check value
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = @{ $Param{Value} };
    }
    else {
        @Values = ( $Param{Value} );
    }

    my @ReadableValues;

    for my $Item (@Values) {
        $Item //= '';

        # replace agent login with full name
        if ($Item) {
            $Item = $Kernel::OM->Get('Kernel::System::User')->UserName(
                UserID => $Item,
            );
        }

        push @ReadableValues, $Item || '';
    }

    # set new line separator
    my $ItemSeparator = ', ';

    # Output transformations
    $Value = join( $ItemSeparator, @ReadableValues );
    $Title = $Value;

    # prepare title
    $Title = $Value;

    if ( $Param{TitleMaxChars} && length $Title > $Param{TitleMaxChars} ) {
        $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
    }

    # return a data structure
    return {
        Value => $Value,
        Title => $Title,
    };
}

sub PossibleValuesGet {
    my ( $Self, %Param ) = @_;

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
    my $UserObject  = $Kernel::OM->Get('Kernel::System::User');

    # to store the possible values
    my %PossibleValues;

    my %AgentList;
    my $GroupFilter = $Param{DynamicFieldConfig}{Config}{GroupFilter};
    if ($GroupFilter) {
        %AgentList = $GroupObject->PermissionGroupGet(
            GroupID => $GroupFilter,
            Type    => 'ro',
        );
    }
    else {
        %AgentList = $UserObject->UserSearch(
            Search => '*',
            Valid  => 1,
        );
    }

    %PossibleValues = (
        %PossibleValues,
        %AgentList,
    );

    %PossibleValues = map { $_ => $UserObject->UserName( UserID => $_ ) } keys %PossibleValues;

    # set PossibleNone attribute
    my $FieldPossibleNone;
    if ( defined $Param{OverridePossibleNone} ) {
        $FieldPossibleNone = $Param{OverridePossibleNone};
    }
    else {
        $FieldPossibleNone = $Param{DynamicFieldConfig}{Config}{PossibleNone} || 0;
    }

    # set none value if defined on field config
    if ($FieldPossibleNone) {
        %PossibleValues = (
            %PossibleValues,
            '' => '-',
        );
    }

    # return the possible values hash as a reference
    return \%PossibleValues;
}

1;
