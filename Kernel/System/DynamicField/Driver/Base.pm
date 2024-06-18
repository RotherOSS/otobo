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

package Kernel::System::DynamicField::Driver::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Base - common fields backend functions

=head1 PUBLIC INTERFACE

=cut

sub ValueIsDifferent {
    my ( $Self, %Param ) = @_;

    # special cases where the values are different but they should be reported as equals
    return if !defined $Param{Value1} && ( defined $Param{Value2} && $Param{Value2} eq '' );
    return if !defined $Param{Value2} && ( defined $Param{Value1} && $Param{Value1} eq '' );

    # compare the results
    return DataIsDifferent(
        Data1 => \$Param{Value1},
        Data2 => \$Param{Value2}
    );
}

sub ValueDelete {
    my ( $Self, %Param ) = @_;

    my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueDelete(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        UserID   => $Param{UserID},
    );

    return $Success;
}

sub AllValuesDelete {
    my ( $Self, %Param ) = @_;

    my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->AllValuesDelete(
        FieldID => $Param{DynamicFieldConfig}->{ID},
        UserID  => $Param{UserID},
    );

    return $Success;
}

sub HasBehavior {
    my ( $Self, %Param ) = @_;

    # return fail if Behaviors hash does not exists
    return if !IsHashRefWithData( $Self->{Behaviors} );

    # return success if the dynamic field has the expected behavior
    return IsPositiveInteger( $Self->{Behaviors}->{ $Param{Behavior} } );
}

sub SearchFieldPreferences {
    my ( $Self, %Param ) = @_;

    my @Preferences = (
        {
            Type        => '',
            LabelSuffix => '',
        },
    );

    return \@Preferences;
}

=head2 EditLabelRender()

creates the label HTML to be used in edit masks.

    my $LabelHTML = $BackendObject->EditLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        FieldName          => 'TheField',               # the value to be set on the 'for' attribute
        AdditionalText     => 'Between'                 # other text to be placed next to FieldName
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub EditLabelRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig FieldName)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(Label)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    my $Name      = $Param{FieldName};
    my $LabelText = $Param{DynamicFieldConfig}->{Label};

    my $LabelID    = 'Label' . $Param{FieldName};
    my $HTMLString = '';

    if ( !$Param{CustomerInterface} ) {
        if ( $Param{Mandatory} ) {

            # opening tag
            $HTMLString = <<"EOF";
<label id="$LabelID" for="$Name" class="Mandatory">
    <span class="Marker">*</span>
EOF
        }
        else {

            # opening tag
            $HTMLString = <<"EOF";
<label id="$LabelID" for="$Name">
EOF
        }

        # text
        $HTMLString .= $Param{LayoutObject}->Ascii2Html(
            Text => $Param{LayoutObject}->{LanguageObject}->Translate("$LabelText")
        );
        if ( $Param{AdditionalText} ) {
            $HTMLString .= " (";
            $HTMLString .= $Param{LayoutObject}->Ascii2Html(
                Text => $Param{LayoutObject}->{LanguageObject}->Translate("$Param{AdditionalText}")
            );
            $HTMLString .= ")";
        }
        $HTMLString .= ":\n";

        # closing tag
        $HTMLString .= <<"EOF";
</label>
EOF
    }

    # CustomerTicketMessage and Zoom
    else {

        # opening tag
        $HTMLString = "<label id='$LabelID' for='$Name'" .
            ( $Param{Mandatory} ? " class='Mandatory'>\n" : ">\n" );

        # text
        $HTMLString .= $Param{LayoutObject}->Ascii2Html(
            Text => $Param{LayoutObject}->{LanguageObject}->Translate("$LabelText")
        );
        if ( $Param{AdditionalText} ) {
            $HTMLString .= " (";
            $HTMLString .= $Param{LayoutObject}->Ascii2Html(
                Text => $Param{LayoutObject}->{LanguageObject}->Translate("$Param{AdditionalText}")
            );
            $HTMLString .= ")";
        }

        if ( $Param{Mandatory} ) {
            $HTMLString .= " <span class='Marker'>*</span>";
        }

        # closing tag
        $HTMLString .= "\n</label>\n";

    }

    return $HTMLString;
}

=head2 ValueSearch()

Searches/fetches dynamic field value.

    my $Value = $BackendObject->ValueSearch(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Search             => 'test',
    );

    Returns [
        {
            ID            => 437,
            FieldID       => 23,
            ObjectID      => 133,
            ValueText     => 'some text',
            ValueDateTime => '1977-12-12 12:00:00',
            ValueInt      => 123,
        },
    ];

=cut

sub ValueSearch {
    my ( $Self, %Param ) = @_;

    # check mandatory parameters
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DynamicFieldConfig!"
        );
        return;
    }

    my $SearchTerm = $Param{Search};
    my $Operator   = 'Equals';
    if ( $Self->HasBehavior( Behavior => 'IsLikeOperatorCapable' ) ) {
        $SearchTerm = '%' . $Param{Search} . '%';
        $Operator   = 'Like';
    }

    my $SearchSQL = $Self->SearchSQLGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        TableAlias         => 'dynamic_field_value',
        SearchTerm         => $SearchTerm,
        Operator           => $Operator,
    );

    if ( !defined $SearchSQL || !length $SearchSQL ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error generating search SQL!"
        );
        return;
    }

    my $Values = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSearch(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        Search    => $Param{Search},
        SearchSQL => $SearchSQL,
    );

    return $Values;
}

1;
