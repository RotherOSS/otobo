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

package Kernel::System::DynamicField::Driver::RichText;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseText);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::HTMLUtils',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::DynamicField::Driver::RichText - driver for the RichText dynamic field

=head1 DESCRIPTION

DynamicFields RichText Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ($Type) = @_;

    # Changes needed, if we add this in the framework:
    # - output customer frontend?
    # - at the moment without inline image support (add this in a later step)!

    # Call constructor of the base class.
    my $Self = $Type->SUPER::new;

    # Settings that are specific to the RichText dynamic field

    # set the maximum length for the rich-text fields to still be a searchable field
    # in some database systems
    $Self->{MaxLength} = 3800;

    # set Text specific field behaviors unless an extension already set it
    $Self->{Behaviors}->{IsSortable}    //= 0;
    $Self->{Behaviors}->{IsHTMLContent} //= 0;

    return $Self;
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value = '';

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = $FieldConfig->{DefaultValue} // '';
    }
    $Value = $Param{Value} // $Value;

    # extract the dynamic field value from the web request
    my $FieldValue = $Self->EditFieldValueGet(
        %Param,
    );

    # set values from ParamObject if present
    if ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    # set the rows number
    my $RowsNumber = defined $FieldConfig->{Rows} && $FieldConfig->{Rows} ? $FieldConfig->{Rows} : '7';

    # set the cols number
    my $ColsNumber = defined $FieldConfig->{Cols} && $FieldConfig->{Cols} ? $FieldConfig->{Cols} : '42';

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldRichText';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set classes according to mandatory and acl hidden params
    if ( $Param{ACLHidden} && $Param{Mandatory} ) {
        $FieldClass .= ' Validate_Required_IfVisible';
    }
    elsif ( $Param{Mandatory} ) {
        $FieldClass .= ' Validate_Required';
    }

    # set error css class
    if ( $Param{ServerError} ) {
        $FieldClass .= ' ServerError';
    }

    # set validation class for maximum characters
    $FieldClass .= ' Validate_MaxLength';

    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $FieldLabel,
    );

    # TODO ask about this
    # TODO maybe the following whould be a good idea?
    #   use List::Util qw(min);
    #   my $MaxLength = min ( $Param{MaxLength, $Self->{MaxLength} );
    # create field HTML
    # the XHTML definition does not support maxlength attribute for a text-area field,
    # we use data-maxlength instead
    # Notice that some browsers count new lines \n\r as only 1 character. In these cases the
    # validation framework might generate an error while the user is still capable to enter text in the
    # text-area. Otherwise the maxlength property will prevent to enter more text than the maximum.
    my $MaxLength = $Param{MaxLength} // $Self->{MaxLength};

    my $ErrorMessage1 = $Param{LayoutObject}->{LanguageObject}->Translate("This field is required or");
    my $ErrorMessage2 = $Param{LayoutObject}->{LanguageObject}->Translate("The field content is too long!");
    my $ErrorMessage3 = $Param{LayoutObject}->{LanguageObject}->Translate( "Maximum size is %s characters.", $MaxLength );

    # TODO ask about column config
    my %FieldTemplateData = (
        FieldClass        => $FieldClass,
        FieldName         => $FieldName,
        FieldLabelEscaped => $FieldLabelEscaped,
        Readonly          => $Param{Readonly},
        RowsNumber        => $RowsNumber,
        ColsNumber        => $ColsNumber,
        MaxLength         => $MaxLength,
        ErrorMessage1     => $ErrorMessage1,
        ErrorMessage2     => $ErrorMessage2,
        ErrorMessage3     => $ErrorMessage3,
        DivID             => $FieldName . 'Error',
        ValueEscaped      => $Param{LayoutObject}->Ascii2Html(
            Text => $Value,
        ),
    );

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/RichText'
        :
        'DynamicField/Agent/RichText';

    if ( $Param{ServerError} ) {
        $FieldTemplateData{DivIDServerError} = $FieldTemplateData{FieldName} . 'ServerError';
        $FieldTemplateData{ErrorMessage}     = Translatable( $Param{ErrorMessage} || 'This field is required.' );
    }
    if ( $Param{Mandatory} ) {
        $FieldTemplateData{DivIDMandatory}       = $FieldTemplateData{FieldName} . 'Error';
        $FieldTemplateData{FieldRequiredMessage} = Translatable('This field is required.');
    }

    my $HTMLString = $Param{LayoutObject}->Output(
        TemplateFile => $FieldTemplateFile,
        Data         => {
            %FieldTemplateData,
        },
    );

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        Mandatory => $Param{Mandatory} || '0',
        FieldName => $FieldName,
    );

    return {
        Field => $HTMLString,
        Label => $LabelString,
    };
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        ParamObject        => $Param{ParamObject},

        # not necessary for this Driver but place it for consistency reasons
        ReturnValueStructure => 1,
    );

    my $ServerError;
    my $ErrorMessage;

    # perform necessary validations
    if ( $Param{Mandatory} && $Value eq '' ) {
        $ServerError = 1;
    }
    elsif ( length $Value > $Self->{MaxLength} ) {
        $ServerError  = 1;
        $ErrorMessage = "The field content is too long! Maximum size is $Self->{MaxLength} characters.";
    }
    elsif (
        IsArrayRefWithData( $Param{DynamicFieldConfig}->{Config}->{RegExList} )
        && ( $Param{Mandatory} || ( !$Param{Mandatory} && $Value ne '' ) )
        )
    {

        # check regular expressions
        my @RegExList = @{ $Param{DynamicFieldConfig}->{Config}->{RegExList} };

        REGEXENTRY:
        for my $RegEx (@RegExList) {

            if ( $Value !~ $RegEx->{Value} ) {
                $ServerError  = 1;
                $ErrorMessage = $RegEx->{ErrorMessage};

                last REGEXENTRY;
            }
        }
    }

    # return resulting structure
    return {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # activate HTMLOutput when it wasn't specified
    my $HTMLOutput = $Param{HTMLOutput} // 1;

    # get raw Title and Value strings from field value
    my $Value = defined $Param{Value} ? $Param{Value} : '';
    my $Title = $Value;

    # return nothing, if the value is empty
    if ( !$Value ) {

        my $Data = {
            Value => undef,
            Title => undef,
            Link  => undef,
        };

        return $Data;
    }

    $Param{ValueMaxChars} ||= '';

    # HTMLOutput transformations
    if ( !$HTMLOutput ) {

        $Value = $Param{LayoutObject}->RichText2Ascii(
            String => $Value,
        );

        if ( $Value && $Param{ValueMaxChars} && ( length $Value > $Param{ValueMaxChars} ) ) {
            $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '[...]';
        }

        $Title = $Param{LayoutObject}->RichText2Ascii(
            String => $Title,
        );

        if ( $Title && $Param{TitleMaxChars} && ( length $Title > $Param{TitleMaxChars} ) ) {
            $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '[...]';
        }

        # this field type does not support the Link Feature
        my $Link;

        # return data structure
        return {
            Value => $Value,
            Title => $Title,
            Link  => $Link,
        };
    }

    # prepare html rendering informations
    my $FieldName  = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel = $Param{DynamicFieldConfig}->{Label};

    # get agents preferences
    my %UserPreferences;
    if ( $Param{LayoutObject}{SessionSource} eq 'AgentInterface' ) {
        %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
            UserID => $Param{LayoutObject}->{UserID},
        );
    }

    # remember if user already closed message about links in iframes
    if ( %UserPreferences && !defined $Self->{DoNotShowBrowserLinkMessage} ) {
        if ( $UserPreferences{UserAgentDoNotShowBrowserLinkMessage} ) {
            $Self->{DoNotShowBrowserLinkMessage} = 1;
        }
        else {
            $Self->{DoNotShowBrowserLinkMessage} = 0;
        }
    }

    # TODO check this for a framework merge: don't show at the moment, add some JS/CSS later for the correct functioanlity
    # show message about links in iframes, if user didn't close it already
    # if ( !$Self->{DoNotShowBrowserLinkMessage} ) {
    #     $Param{LayoutObject}->Block(
    #         Name => 'BrowserLinkMessage',
    #     );
    # }

    my $TranslatedDialogTitle = $Param{LayoutObject}->{LanguageObject}->Translate( "Full %s Text", $FieldLabel );

    my $JSCode = <<"EOF";
\$('a#ShowDynamicFieldRichText_$FieldName').off('click').on('click', function(Event) {
    Event.preventDefault();
    Event.stopPropagation();

    Core.UI.Dialog.ShowContentDialog(\$('#DynamicFieldRichText_$FieldName').html(), '$TranslatedDialogTitle', '20px', 'Center', true);

    return false;
});
EOF

    # get HTML utils object
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    # remove active html content (scripts, applets, etc...)
    my %SafeContent = $HTMLUtilsObject->Safety(
        String       => $Value,
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 0,
        NoJavaScript => 1,
    );

    # take the safe content
    $Value = $SafeContent{String};

    # detect all plain text links and put them into an HTML <a> tag
    $Value = $HTMLUtilsObject->LinkQuote(
        String => $Value,
    );

    # set target="_blank" attribute to all HTML <a> tags
    # the LinkQuote function needs to be called again
    $Value = $HTMLUtilsObject->LinkQuote(
        String    => $Value,
        TargetAdd => 1,
    );

    # add needed HTML headers
    $Value = $HTMLUtilsObject->DocumentComplete(
        String => $Value,
    );

    # add js to call ShowContentDialog()
    $Param{LayoutObject}->AddJSOnDocumentComplete( Code => $JSCode );

    # escape single quotes
    $Value =~ s/'/&#39;/g;

    my $RenderedTemplate = $Param{LayoutObject}->Output(
        TemplateFile => 'DynamicField/Agent/RichTextDisplayValue',
        Data         => {
            FieldName => $FieldName,
            Value     => $Value,
        }
    );

    # return a data structure
    return {
        Value => $RenderedTemplate,
        Title => undef,
        Link  => undef,
    };
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldName  = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel = $Param{DynamicFieldConfig}->{Label};

    # set the field value
    my $Value = ( defined $Param{DefaultValue} ? $Param{DefaultValue} : '' );

    # get the field value, this function is always called after the profile is loaded
    my $FieldValue = $Self->SearchFieldValueGet(%Param);

    # set values from profile if present
    if ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    # check if value is an array reference (GenericAgent Jobs and NotificationEvents)
    if ( IsArrayRefWithData($Value) ) {
        $Value = @{$Value}[0];
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText';

    my $ValueEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $Value,
    );

    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $FieldLabel,
    );

    my $HTMLString = <<"EOF";
<input type="text" class="$FieldClass" id="$FieldName" name="$FieldName" title="$FieldLabelEscaped" value="$ValueEscaped" />
EOF

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        FieldName => $FieldName,
    );

    return {
        Field => $HTMLString,
        Label => $LabelString,
    };
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # get field value
    my $Value = $Self->SearchFieldValueGet(%Param);

    if ( !$Value ) {
        return {
            Parameter => {
                'Like' => '',
            },
            Display => '',
        };
    }

    # return search parameter structure
    return {
        Parameter => {
            'Like' => '*' . $Value . '*',
        },
        Display => $Value,
    };
}

1;
