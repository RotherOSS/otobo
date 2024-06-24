# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::Output::HTML::FilterElementPost::AddDynamicFieldNames;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Get template name.
    my $TemplateName = $Param{TemplateFile} || '';
    return 1 if !$TemplateName;

    # Get valid modules.
    my $ValidTemplates = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Output::FilterElementPost')
        ->{'OutputFilterPostAddDynamicFieldNames'}->{Templates};

    # Apply only if template is valid in config.
    return 1 if !$ValidTemplates->{$TemplateName};

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $DynamicFieldFilter;

    # For process management we don't have a setting with the available dynamic fields,
    #   so we need to to extract them each time they are rendered
    if ( $TemplateName =~ m {ProcessManagement} ) {

        # Define SysConfig key to store the dynamic field names
        my $ConfigKey = "OTOBOCommunity::DynamicFieldDB::$Self->{SessionID}::ProcessManagement";

        if ( $TemplateName eq 'ProcessManagement/DynamicField' ) {

            # Extract dynamic field name from the HTML DOM (use array form with RegEx capturing groups)
            my ($DynamicFieldName) = ${ $Param{Data} } =~ m{\s+ <div [ ] class="Row [ ] Row_DynamicField_([a-zA-Z\d]+)">}msx;

            if ($DynamicFieldName) {

                # Get current dynamic fields (this might be already populated by previous dynamic
                #   fields in the process activity dialog).
                my $DynamicFields = $ConfigObject->Get($ConfigKey) || [];

                # Add current dynamic field name to the list.
                push @{$DynamicFields}, $DynamicFieldName;

                # Update setting.
                $ConfigObject->Set(
                    Key   => $ConfigKey,
                    Value => $DynamicFields,
                );
            }

            # No output is needed here only dynamic field names gathering and temporary storing
            return 1;
        }
        elsif ( $TemplateName =~ m{(?: Customer)? ActivityDialogFooter}msx ) {

            # When the footer is render all dynamic fields has been already render so its safe to
            #   continue with the processing.

            # Get dynamic field from the configuration that was set during dynamic field rendering.
            my $DynamicFields = $ConfigObject->Get($ConfigKey) || [];

            # Convert the dynamic fields displayed on the screen to a filter for later use.
            %{$DynamicFieldFilter} = map { $_ => 1 } @{$DynamicFields};
        }
    }
    else {

        # Get the Config for the current action (non process management screens has their own
        #    dynamic filed configuration)
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Param{TemplateFile}");

        # Set configured dynamic fields as a filter for later use.
        $DynamicFieldFilter = $Config->{DynamicField} || {};

    }

    # Get DynamicFieldNames.
    my $DynamicFields = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # Make sure dynamic fields exists.
    my @DynamicFieldNames;
    DYNAMICFIELD:
    for my $DynamicFieldConfig (@$DynamicFields) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        push @DynamicFieldNames, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    # Create a string with the quoted dynamic field names separated by commas.
    my $DynamicFieldNamesStrg = join ',', @DynamicFieldNames;

    # Add a hidden input containing DynamicField names.
    my $Search  = '(\s+<input type="hidden" name="Action")';
    my $Replace = << "END";
\n<!--Start OTOBOCommunity-->
<input type="hidden" name="DynamicFieldNamesStrg" id="DynamicFieldNamesStrg" value="$DynamicFieldNamesStrg" />
<!--End OTOBOCommunity-->
END

    # For process management we need to add the hidden input before the closure of the field set.
    if ( $TemplateName =~ m{ProcessManagement/(?: Customer)? ActivityDialogFooter}msx ) {
        $Search = '(\s+</fieldset>)';
    }

    # Update the source.
    ${ $Param{Data} } =~ s{$Search}{$Replace $1};

    return 1;
}

1;
