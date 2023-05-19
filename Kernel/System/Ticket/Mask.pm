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

package Kernel::System::Ticket::Mask;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::Ticket::Mask - functions to prepare and administrate ticket masks

=head1 DESCRIPTION

functions to prepare and administrate ticket masks

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $MaskObject = $Kernel::OM->Get('Kernel::System::Ticket::Mask');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 DefinitionSet()

Set the definition for a ticket mask

    my $Success = $MaskObject->DefinitionSet(
        Definition       => \@Definition,
        DefinitionString => $YAMLString,  # either Definition or DefinitionString is needed
        Mask             => $Mask,
        UserID           => $UserID,
    );

=cut

sub DefinitionSet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/UserID Mask/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( $Param{DefinitionString} ) {

        # Validate YAML code by converting it to Perl.
        my $DefinitionRef = $Kernel::OM->Get('Kernel::System::YAML')->Load(
            Data => $Param{DefinitionString},
        );

        if ( ref $DefinitionRef ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need and array in valid YAML!',
            );
            return;
        }
    }
    elsif ( $Param{Definition} ) {
        $Param{DefinitionString} = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
            Data => $Param{Definition},
        );

        if ( !$Param{DefinitionString} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not generate YAML from provided Definition!',
            );
            return;
        }
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Definition or DefinitionString!',
        );
        return;
    }

    $Self->DefinitionDelete(
        Mask      => $Param{Mask},
        KeepCache => 1,
    );

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'INSERT INTO frontend_mask_definition ( mask, definition, create_time, create_by ) VALUES ( ?, ?, current_timestamp, ? )',
        Bind => [ \$Param{Mask}, \$Param{DefinitionString}, \$Param{UserID} ],
    );

    return 1;
}

=head2 DefinitionGet()

Get the definition for a ticket mask

    my $Definition = $MaskObject->DefinitionGet(
        Mask   => $Mask,
        Return => 'ARRAY', # Optional either ARRAY (default) or STRING which returns the YAML
    );

=cut

sub DefinitionGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Mask/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{Return} ||= 'ARRAY';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL   => 'SELECT definition FROM frontend_mask_definition WHERE mask = ?',
        Bind  => [ \$Param{Mask} ],
        Limit => 1,
    );

    my ($DefinitionString) = $DBObject->FetchrowArray();

    return if !$DefinitionString;

    return $DefinitionString if $Param{Return} eq 'STRING';

    return $Kernel::OM->Get('Kernel::System::YAML')->Load(
        Data => $DefinitionString,
    );
}

=head2 DefinitionDelete()

Delete the definition for a ticket mask

    my $Success = $MaskObject->DefinitionDelete(
        Mask => $Mask,
    );

=cut

sub DefinitionDelete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Mask/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM frontend_mask_definition WHERE mask = ?',
        Bind => [ \$Param{Mask} ],
    );
}

=head2 ConfiguredMasksList()

Get all configured masks

    my @Masks = $MaskObject->ConfiguredMasksList();

=cut

sub ConfiguredMasksList {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => 'SELECT mask FROM frontend_mask_definition',
    );

    my @Masks;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Masks, $Row[0];
    }

    return @Masks;
}

1;
