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

package Kernel::System::Console::Command::Admin::DynamicField::Delete;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

## nofilter(TidyAll::Plugin::OTOBO::Perl::ForeachToFor)

# Inform the object manager about the hard dependencies.
# This module must be discarded when one of the hard dependencies has been discarded.
our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        "Delete DynamicFields. \n" .
            "Deletes dynamic fields and all associated values from the OTOBO system. \n" .
            "To execute the deletion automatically, please use --force. \n" .
            "Otherwise, the fields for deletion are displayed first and only deleted after confirmation."
    );

    $Self->AddOption(
        Name        => 'name',
        Description => 'Name of the DynamicField.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'name-regex',
        Description => 'Regex to find all DynamicField names.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'id',
        Description => 'ID of the DynamicField.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d/smx,
    );
    $Self->AddOption(
        Name        => 'objecttype',
        Description => 'Objecttype of the DynamicField, which should be deleted (Ticket, Article, Customer, CustomerUser, FAQ, ITSMConfigItem...).',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'fieldtype',
        Description => 'Fieldtype of the DynamicField, which should be deleted (Text,Dropdown...).',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'namespace',
        Description => 'Namespace of the DynamicField, which should be deleted.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'all-invalid',
        Description => 'Delete all invalid DynamicFields (only invalid, not temp invalid).',
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'all-tmpinvalid',
        Description => 'Delete all temp invalid DynamicFields.',
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'all',
        Description => 'Delete all DynamicFields.',
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    #    $Self->AddOption(
    #        Name        => 'all-unused',
    #        Description => 'Delete all unused Dynamicfiels.',
    #        Required    => 0,
    #        HasValue    => 1,
    #        ValueRegex  => qr/\d/smx,
    #    );
    $Self->AddOption(
        Name        => 'force',
        Description => 'Delete all DynamicField values and fields.',
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Find fields that should be deleted...</yellow>\n");

    my $DynamicFieldObject      = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    my %DeleteHash;

    my %DynamicFieldLookup = reverse %{
        $DynamicFieldObject->DynamicFieldList(
            Valid      => 0,
            ResultType => 'HASH',
            )
            || {}
    };

    DYNAMICFIELD:
    for my $DynFieldName ( sort keys %DynamicFieldLookup ) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynFieldName,
        );

        if ( $Self->GetOption('all') && $DynamicField->{InternalField} != 1 ) {
            $DeleteHash{$DynFieldName} = $DynamicField->{ID};
            next DYNAMICFIELD;
        }

        if ( $Self->GetOption('name') && $Self->GetOption('name') eq $DynFieldName ) {
            $DeleteHash{$DynFieldName} = $DynamicField->{ID};
            next DYNAMICFIELD;
        }

        if ( $Self->GetOption('name-regex') ) {
            my $Regex = $Self->GetOption('name-regex');
            if ( $DynFieldName =~ m/$Regex/ ) {
                $DeleteHash{$DynFieldName} = $DynamicField->{ID};
                next DYNAMICFIELD;
            }
        }

        if ( $Self->GetOption('id') && $Self->GetOption('id') == $DynamicField->{ID} ) {
            $DeleteHash{$DynFieldName} = $DynamicField->{ID};
            next DYNAMICFIELD;
        }

        if ( $Self->GetOption('objecttype') && $Self->GetOption('objecttype') eq $DynamicField->{ObjectType} ) {
            $DeleteHash{$DynFieldName} = $DynamicField->{ID};
            next DYNAMICFIELD;
        }

        if ( $Self->GetOption('fieldtype') && $Self->GetOption('fieldtype') eq $DynamicField->{FieldType} ) {
            $DeleteHash{$DynFieldName} = $DynamicField->{ID};
            next DYNAMICFIELD;
        }

        if ( $Self->GetOption('namespace') ) {
            my $Namespace = $Self->GetOption('namespace');

            if ( $DynFieldName =~ /^$Namespace-.*$/ ) {
                $DeleteHash{$DynFieldName} = $DynamicField->{ID};
                next DYNAMICFIELD;
            }
        }

        if ( $Self->GetOption('all-invalid') && $DynamicField->{ValidID} == 2 ) {
            $DeleteHash{$DynFieldName} = $DynamicField->{ID};
            next DYNAMICFIELD;
        }

        if ( $Self->GetOption('all-tmpinvalid') && $DynamicField->{ValidID} == 3 ) {
            $DeleteHash{$DynFieldName} = $DynamicField->{ID};
            next DYNAMICFIELD;
        }
    }

    # Now we show all for delete marked fields:
    if ( IsHashRefWithData( \%DeleteHash ) ) {
        $Self->Print("<green>These fields are marked for deletion:</green>\n");
        for my $FieldName ( sort keys %DeleteHash ) {
            $Self->Print("<green>Name: $FieldName - ID: $DeleteHash{$FieldName}</green>\n");
        }
    }
    else {
        $Self->Print("<yellow>There are no fields to delete!</yellow>\n");
    }

    if ( !$Self->GetOption('force') ) {
        $Self->Print("\n<yellow>Please confirm the deletion of all fields and values by typing 'y'es</yellow>\n\t");
        return $Self->ExitCodeOk() if <STDIN> !~ /^ye?s?$/i;
    }

    # Delete DynamicField values
    for my $FieldName ( sort keys %DeleteHash ) {
        my $SuccessDelValue = $DynamicFieldValueObject->AllValuesDelete(
            FieldID => $DeleteHash{$FieldName},
            UserID  => 1,
        );

        if ($SuccessDelValue) {
            $Self->Print("\n<green>Delete DynamicField $FieldName values if they exist.</green>\n\t");
        }
        else {
            $Self->Print("Can't delete field values for field: $FieldName.");
        }

        my $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DeleteHash{$FieldName},
            UserID => 1,
        );

        if ($Success) {
            $Self->Print("\n<green>Delete DynamicField $FieldName.</green>\n\t");
        }
        else {
            $Self->Print("Can't delete field $FieldName.");
        }
    }

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
