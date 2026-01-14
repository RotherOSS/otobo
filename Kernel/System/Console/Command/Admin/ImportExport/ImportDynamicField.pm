# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::Console::Command::Admin::ImportExport::ImportDynamicField;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::YAML',
    'Kernel::System::ZnunyHelper',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Import dynamic field data from a YAML file.');
    $Self->AddOption(
        Name        => 'update',
        Description => "Flag if existing dynamic field data should be overwritten.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'source',
        Description => "Specify the path to the file which contains the data for importing.",
        Required    => 1,
        ValueRegex  => qr/.*/,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->GetArgument('source');
    if ( !$Source ) {

        # source is optional, even if an import without source is unsatisfying
    }
    elsif ( -r $Source ) {

        # a readable file is fine
    }
    else {
        die "The source $Source does not exist or can not be read.";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Starting dynamic field import...</yellow>\n");

    # get object
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $YAMLObject        = $Kernel::OM->Get('Kernel::System::YAML');
    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    # fetch params
    my $File                      = $Self->GetArgument('source') || '';
    my $OverwriteExistingEntities = $Self->GetOption('update')   || 0;

    # read file
    my $DFYAML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
    );
    my $DFData = $YAMLObject->Load(
        Data => ${$DFYAML},
    );

    # ------------------------------------------------------------ #
    # Import DynamicFields
    # ------------------------------------------------------------ #
    my $FieldTypeConfig = $ConfigObject->Get('DynamicFields::Driver');
    if ( IsHashRefWithData( $DFData->{DynamicFields} ) ) {

        my @DynamicFieldsImport;
        DYNAMICFIELD:
        for my $DynamicField ( sort keys %{ $DFData->{DynamicFields} } ) {
            $Self->Print("<yellow>Currently processing field $DynamicField...</yellow>\n");

            next DYNAMICFIELD if !IsHashRefWithData( $DFData->{DynamicFields}{$DynamicField} );

            my $FieldType = $DFData->{DynamicFields}{$DynamicField}{FieldType};

            if ( !IsHashRefWithData( $FieldTypeConfig->{$FieldType} ) ) {

                $Self->Print(
                    "<red>Could not import dynamic field '$DFData->{DynamicFields}->{$DynamicField}->{Name}' - Dynamic field backend for FieldType '$DFData->{DynamicFields}->{$DynamicField}->{FieldType}' does not exists! Skipping it...</red>\n"
                );

                next DYNAMICFIELD;
            }

            push @DynamicFieldsImport, $DFData->{DynamicFields}{$DynamicField};
        }

        if ($OverwriteExistingEntities) {
            $ZnunyHelperObject->_DynamicFieldsCreate(@DynamicFieldsImport);
        }
        else {
            $ZnunyHelperObject->_DynamicFieldsCreateIfNotExists(@DynamicFieldsImport);
        }
    }

    # ------------------------------------------------------------ #
    # Import DynamicFieldsScreens
    # ------------------------------------------------------------ #

    if ( IsHashRefWithData( $DFData->{DynamicFieldsScreens} ) ) {
        $Self->Print("<yellow>Currently processing dynamic field screens config. This may take some time...</yellow>\n");

        my %DynamicFieldsScreensImport;
        DYNAMICFIELDSCREEN:
        for my $DynamicField ( sort keys %{ $DFData->{DynamicFieldsScreens} } ) {

            $DynamicFieldsScreensImport{$DynamicField} = $DFData->{DynamicFieldsScreens}{$DynamicField};
        }

        if (%DynamicFieldsScreensImport) {
            $ZnunyHelperObject->_DynamicFieldsScreenConfigImport(
                Config => \%DynamicFieldsScreensImport,
            );
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
