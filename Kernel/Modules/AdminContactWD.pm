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

package Kernel::Modules::AdminContactWD;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    # Determine relevant dynamic fields.
    my $TicketDynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'Ticket',
    );
    $Self->{ContactWDFields} = {};
    FIELD:
    for my $Field ( @{$TicketDynamicFieldList} ) {
        next FIELD if $Field->{FieldType} ne 'ContactWD';
        next FIELD if $Field->{ValidID} ne 1;
        $Self->{ContactWDFields}->{ $Field->{ID} } = $Field;
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';

    my $Source = $ParamObject->GetParam( Param => 'Source' );
    if ( !$Source ) {
        $Source = (
            sort {
                $Self->{ContactWDFields}->{$a}->{Label}
                    cmp $Self->{ContactWDFields}->{$b}->{Label}
            } keys %{ $Self->{ContactWDFields} }
        )[0];
    }

    # Get search terms.
    my $Search = $ParamObject->GetParam( Param => 'Search' );
    $Search
        ||= $Kernel::OM->Get('Kernel::Config')->Get('AdminContactWD::RunInitialWildcardSearch') ? '*' : '';

    # Prepare nav bar.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $NavBar       = $LayoutObject->Header();
    $NavBar .= $LayoutObject->NavigationBar();

    # Override subaction if 'add' button was clicked.
    if ( $Self->{Subaction} eq 'Search' && $ParamObject->GetParam( Param => 'Add' ) ) {
        $Self->{Subaction} = 'Add';
    }

    # Edit contact mask.
    if ( $Self->{Subaction} eq 'Change' ) {

        # get contact data
        my $Contact = $ParamObject->GetParam( Param => 'ID' );
        if ( !$Contact ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No contact is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
        my $ContactData = $Self->{ContactWDFields}->{$Source}->{Config}->{ContactsWithData}->{$Contact};
        if ( !$ContactData ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No data found for given contact in given source!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # Print output.
        my $Output = $NavBar;
        $Output .= $LayoutObject->Notify( Info => Translatable('Contact updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Self->_Edit(
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $Contact,
            Data   => $ContactData,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminContactWD',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # Change action.
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();
        my $Note = '';

        # Get contact and field data.
        my $Contact = $ParamObject->GetParam( Param => 'ID' );
        if ( !$Contact ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No contact is given!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
        my $FieldData = $Self->{ContactWDFields}->{$Source};
        if ( !IsHashRefWithData($FieldData) ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No field data found!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
        if ( !IsHashRefWithData( $FieldData->{Config}->{ContactsWithData}->{$Contact} ) ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No data found for given contact in given source!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # Get submitted params and overwrite old contact values.
        my %NewValues;
        for my $Field ( sort keys %{ $FieldData->{Config}->{PossibleValues} } ) {
            $NewValues{$Field} = $ParamObject->GetParam( Param => $Field ) || '';
        }
        $FieldData->{Config}->{ContactsWithData}->{$Contact} = \%NewValues;

        # Check for missing mandatory fields.
        my %Errors;
        my $MandatoryFields = $FieldData->{Config}->{MandatoryFieldsComputed};
        FIELD:
        for my $Field ( @{$MandatoryFields} ) {
            next FIELD if $NewValues{$Field};
            $Errors{$Field} = 1;
        }

        if ( !%Errors ) {

            # Update contact (=update complete dynamic field).
            my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
                %{$FieldData},
                UserID => $Self->{UserID},
            );
            if ($UpdateSuccess) {

                # If the user would like to continue editing the role, just redirect to the edit screen
                # otherwise return to overview.
                if (
                    defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
                    && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
                    )
                {
                    return $LayoutObject->Redirect(
                        OP =>
                            "Action=$Self->{Action};Subaction=Change;ID=$Contact;Search=Search;Source=$Source;Notification=Update"
                    );
                }
                else {
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
                }
            }
            else {
                $Note = $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # Something went wrong.
        my $Output = $NavBar;
        $Output .= $Note
            ? $LayoutObject->Notify(
                Priority => 'Error',
                Info     => $Note,
            )
            : '';

        $Self->_Edit(
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            Errors => \%Errors,
            ID     => $Contact,
            Data   => \%NewValues,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminContactWD',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # Add contact mask.
    elsif ( $Self->{Subaction} eq 'Add' ) {

        # print output
        my $Output = $NavBar;
        $Self->_Edit(
            Action => 'Add',
            Source => $Source,
            Search => $Search,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminContactWD',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # Add action.
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        # Get field data.
        my $FieldData = $Self->{ContactWDFields}->{$Source};
        if ( !IsHashRefWithData($FieldData) ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No field data found!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # Create contact id, increment highest existing id for new contact.
        my @ReverseSortedKeys = reverse sort { $a <=> $b } keys %{ $FieldData->{Config}->{ContactsWithData} };

        # Get the highest id.
        my ($Contact) = @ReverseSortedKeys;

        $Contact ||= 0;
        ++$Contact;

        # Get submitted params and set new contact values.
        my %NewValues;
        for my $Field ( sort keys %{ $FieldData->{Config}->{PossibleValues} } ) {
            $NewValues{$Field} = $ParamObject->GetParam( Param => $Field ) || '';
        }
        $FieldData->{Config}->{ContactsWithData}->{$Contact} = \%NewValues;

        # Check for missing mandatory fields.
        my %Errors;
        my $MandatoryFields = $FieldData->{Config}->{MandatoryFieldsComputed};
        FIELD:
        for my $Field ( @{$MandatoryFields} ) {
            next FIELD if $NewValues{$Field};
            $Errors{$Field} = 1;
        }

        my $Output = $NavBar;
        if ( !%Errors ) {

            # Create contact (=update complete dynamic field).
            my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldUpdate(
                %{$FieldData},
                UserID => $Self->{UserID},
            );
            if ($UpdateSuccess) {
                $Self->{ContactWDFields}->{$Source} = $FieldData;

                # Get contact data and show screen again.
                $Self->_Overview(
                    Search => $Search,
                    Source => $Source,
                );
                $Output .= $LayoutObject->Notify( Info => Translatable('Contact created!') );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminContactWD',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }

            # Update went wrong
            $Errors{CreateSuccess} = 1;
            $Output .= $LayoutObject->Notify(
                Info     => Translatable('Error creating contact!'),
                Priority => 'Error',
            );
        }

        # Something has gone wrong.
        $Self->_Edit(
            Action => 'Add',
            Source => $Source,
            Search => $Search,
            Errors => \%Errors,
            ID     => $Contact,
            Data   => \%NewValues,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # Overview / search contact list.
    else {

        # Safety check for source.
        if ( !IsHashRefWithData( $Self->{ContactWDFields} ) ) {
            return $LayoutObject->ErrorScreen(
                Message =>
                    Translatable(
                        'No sources found, at least one "Contact with data" dynamic field must be added to the system!'
                    ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
        if ( $Search && !IsHashRefWithData( $Self->{ContactWDFields}->{$Source} ) ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No data found for given source!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        $Self->_Overview(
            Search => $Search,
            Source => $Source,
        );

        # Print output.
        my $Output = $NavBar;
        $Output .= $LayoutObject->Notify( Info => Translatable('Contact updated!') )
            if ( $Notification && $Notification eq 'Update' );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminContactWD',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );

    # Prepare available sources.
    my %Sources;
    for my $DynamicField ( sort keys %{ $Self->{ContactWDFields} } ) {
        $Sources{$DynamicField} = $Self->{ContactWDFields}->{$DynamicField}->{Label};
    }

    $Param{SourceOption} = $LayoutObject->BuildSelection(
        Data       => { %Sources, },
        Name       => 'Source',
        SelectedID => $Param{Source} || '',
        Class      => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'ActionSearch',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'OverviewHeader',
        Data => {
            Label => $Self->{ContactWDFields}->{ $Param{Source} }->{Label},
        },
    );

    if ( $Param{Search} ) {
        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        # Make search safe and use '*' as wildcard.
        my $Search = $Param{Search};
        $Search =~ s{ \A \s+ }{}xms;
        $Search =~ s{ \s+ \z }{}xms;
        $Search = 'A' . $Search . 'Z';
        my @SearchParts = split /\*/, $Search;
        for my $SearchPart (@SearchParts) {
            $SearchPart = quotemeta($SearchPart);
        }
        $Search = join '.*', @SearchParts;
        $Search =~ s{ \A A }{}xms;
        $Search =~ s{ Z \z }{}xms;

        # Search contacts.
        my $PossibleContacts =
            $Self->{ContactWDFields}->{ $Param{Source} }->{Config}->{ContactsWithData};
        my $SearchableFields =
            $Self->{ContactWDFields}->{ $Param{Source} }->{Config}
            ->{SearchableFieldsComputed};
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        my $ContactsFound;
        CONTACT:

        # Sort by name.
        for my $Contact (
            sort { lc( $PossibleContacts->{$a}->{Name} ) cmp lc( $PossibleContacts->{$b}->{Name} ) }
            keys %{$PossibleContacts}
            )
        {
            my $ContactData = $PossibleContacts->{$Contact};
            my $SearchMatch;
            FIELD:
            for my $Field ( @{$SearchableFields} ) {
                next FIELD if $ContactData->{$Field} !~ m{ $Search }xmsi;
                $SearchMatch = 1;
                last FIELD;
            }
            next CONTACT if !$SearchMatch;

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid  => $ValidList{ $ContactData->{ValidID} || '' } || '-',
                    Search => $Param{Search},
                    Name   => $ContactData->{Name},
                    Source => $Param{Source},
                    ID     => $Contact,
                },
            );
            $ContactsFound = 1;
        }

        # when there is no data to show, a message is displayed on the table with this colspan.
        if ( !$ContactsFound ) {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {
                    ColSpan => 2,
                },
            );
        }
    }

    # If there is nothing to search it shows a message.
    else
    {
        $LayoutObject->Block(
            Name => 'NoSearchTerms',
        );
    }
    return;
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            Name => $Self->{ContactWDFields}->{ $Param{Source} }->{Label},
            %Param,
        }
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # Shows header.
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'HeaderEdit',
            Data => {
                Label => $Self->{ContactWDFields}->{ $Param{Source} }->{Label},
            },
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'HeaderAdd',
            Data => {
                Label => $Self->{ContactWDFields}->{ $Param{Source} }->{Label},
            },
        );
    }

    my $PossibleValues  = $Self->{ContactWDFields}->{ $Param{Source} }->{Config}->{PossibleValues};
    my $SortOrder       = $Self->{ContactWDFields}->{ $Param{Source} }->{Config}->{SortOrderComputed};
    my $MandatoryFields = $Self->{ContactWDFields}->{ $Param{Source} }->{Config}->{MandatoryFieldsComputed};
    my %IsMandatory     = map { $_ => 1 } @{$MandatoryFields};
    for my $Field ( @{$SortOrder} ) {
        $LayoutObject->Block(
            Name => 'Item',
        );

        my %GetParam;
        my $Block = 'Input';

        if ( $IsMandatory{$Field} ) {

            # add validation
            $GetParam{RequiredClass}          = 'Validate_Required';
            $GetParam{RequiredLabelClass}     = 'Mandatory';
            $GetParam{RequiredLabelCharacter} = '*';

            if ( $Param{Errors}->{$Field} ) {
                $GetParam{InvalidField} = 'ServerError';
            }
        }

        if ( $Field eq 'ValidID' ) {

            # Build ValidID string.
            $Block = 'Option';
            $GetParam{Option} = $LayoutObject->BuildSelection(
                Data       => { $Kernel::OM->Get('Kernel::System::Valid')->ValidList(), },
                Name       => $Field,
                SelectedID => defined( $Param{Data}->{$Field} ) ? $Param{Data}->{$Field} : 1,
                Class      => "Modernize Validate_Required",
            );
        }
        else {
            $GetParam{Value} = $Param{Data}->{$Field};
        }

        $GetParam{Name}  = $Field;
        $GetParam{Label} = $PossibleValues->{$Field};
        $LayoutObject->Block(
            Name => $Block,
            Data => \%GetParam,
        );
    }

    return 1;
}

1;
