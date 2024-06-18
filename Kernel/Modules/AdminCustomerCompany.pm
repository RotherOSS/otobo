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

package Kernel::Modules::AdminCustomerCompany;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {%Param}, $Type;

    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerCompany',
    );

    # set pref for columns key
    $Self->{PrefKeyIncludeInvalid} = 'IncludeInvalid' . '-' . $Self->{Action};

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    $Self->{IncludeInvalid} = $Preferences{ $Self->{PrefKeyIncludeInvalid} };

    $Self->{DynamicFieldLookup} = { map { $_->{Name} => $_ } @{$DynamicFieldConfigs} };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Nav               = $ParamObject->GetParam( Param => 'Nav' ) || 0;
    my $NavigationBarType = $Nav eq 'Agent' ? 'Customers' : 'Admin';
    my $Search            = $ParamObject->GetParam( Param => 'Search' );
    $Search
        ||= $ConfigObject->Get('AdminCustomerCompany::RunInitialWildcardSearch') ? '*' : '';
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    my %GetParam;
    $GetParam{Source}         = $ParamObject->GetParam( Param => 'Source' ) || 'CustomerCompany';
    $GetParam{IncludeInvalid} = $ParamObject->GetParam( Param => 'IncludeInvalid' );

    if ( defined $GetParam{IncludeInvalid} ) {
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{PrefKeyIncludeInvalid},
            Value  => $GetParam{IncludeInvalid},
        );

        $Self->{IncludeInvalid} = $GetParam{IncludeInvalid};
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $CustomerID   = $ParamObject->GetParam( Param => 'CustomerID' )   || $ParamObject->GetParam( Param => 'ID' ) || '';
        my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';
        my %Data         = $CustomerCompanyObject->CustomerCompanyGet(
            CustomerID => $CustomerID,
        );
        $Data{CustomerCompanyID} = $CustomerID;
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );
        $Output .= $LayoutObject->Notify( Info => Translatable('Customer company updated!') )
            if ( $Notification && $Notification eq 'Update' );
        $Self->_Edit(
            Action => 'Change',
            Nav    => $Nav,
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %Errors;
        $GetParam{CustomerCompanyID} = $ParamObject->GetParam( Param => 'CustomerCompanyID' );

        my @CustomerCompanyMap = $ConfigObject->Get( $GetParam{Source} )->{Map}->@*;

        # The readonly fields should not be settable from the WebApp.
        # So update with the old values, regardless what was passed from the client.
        # The old data is only needed when there are any readonly fields.
        my %OldData;
        if ( any { $_->[7] } @CustomerCompanyMap ) {
            %OldData = $CustomerCompanyObject->CustomerCompanyGet(
                CustomerID => $GetParam{CustomerCompanyID},
            );
        }

        # Get dynamic field backend object.
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        ENTRY:
        for my $Entry (@CustomerCompanyMap) {

            # check dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "DynamicField $Entry->[2] not found!",
                    );
                    next ENTRY;
                }

                my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $ParamObject,
                    Mandatory          => $Entry->[4],
                );

                if ( $ValidationResult->{ServerError} ) {
                    $Errors{ $Entry->[0] } = $ValidationResult;
                }
                else {

                    # generate storable value of dynamic field edit field
                    $GetParam{ $Entry->[0] } = $DynamicFieldBackendObject->EditFieldValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ParamObject        => $ParamObject,
                        LayoutObject       => $LayoutObject,
                    );
                }
            }

            # reuse the old data for readonly field
            elsif ( $Entry->[7] ) {
                $GetParam{ $Entry->[0] } = $OldData{ $Entry->[0] };
            }

            # check remaining non-dynamic-field mandatory fields
            else {
                $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) // '';
                if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                    $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
                }
            }
        }

        if ( !defined $GetParam{CustomerID} ) {
            $GetParam{CustomerID} = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
        }

        # check for duplicate entries
        if ( $GetParam{CustomerCompanyID} ne $GetParam{CustomerID} ) {

            # get CustomerCompany list
            my %List = $CustomerCompanyObject->CustomerCompanyList(
                Search => $Param{Search},
                Valid  => 0,
            );

            # check duplicate field
            if ( %List && $List{ $GetParam{CustomerID} } ) {
                $Errors{Duplicate} = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            my $Update = $CustomerCompanyObject->CustomerCompanyUpdate( %GetParam, UserID => $Self->{UserID} );

            if ($Update) {

                my $SetDFError;

                # set dynamic field values
                ENTRY:
                for my $Entry (@CustomerCompanyMap) {
                    next ENTRY if $Entry->[5] ne 'dynamic_field';

                    my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                        $SetDFError .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Dynamic field %s not found!',
                                $Entry->[2],
                            ),
                        );

                        next ENTRY;
                    }

                    my $ValueSet = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectName         => $GetParam{CustomerID},
                        Value              => $GetParam{ $Entry->[0] },
                        UserID             => $Self->{UserID},
                    );

                    if ( !$ValueSet ) {
                        $SetDFError .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Unable to set value for dynamic field %s!',
                                $Entry->[2],
                            ),
                        );

                        next ENTRY;
                    }
                }

                my $ContinueAfterSave = $ParamObject->GetParam( Param => 'ContinueAfterSave' ) || 0;

                # if set DF error exists, create notification
                if ($SetDFError) {

                    # if the user would like to continue editing the customer company, just redirect to the edit screen
                    if ( $ContinueAfterSave eq '1' ) {
                        $Self->_Edit(
                            Action => 'Change',
                            Nav    => $Nav,
                            Errors => \%Errors,
                            %GetParam,
                        );
                    }
                    else {
                        $Self->_Overview(
                            Nav    => $Nav,
                            Search => $Search,
                            %GetParam,
                        );
                    }
                    my $Output = $LayoutObject->Header();
                    $Output .= $LayoutObject->NavigationBar(
                        Type => $NavigationBarType,
                    );
                    $Output .= $LayoutObject->Notify( Info => Translatable('Customer company updated!') );
                    $Output .= $SetDFError;
                    $Output .= $LayoutObject->Output(
                        TemplateFile => 'AdminCustomerCompany',
                        Data         => \%Param,
                    );
                    $Output .= $LayoutObject->Footer();
                    return $Output;
                }

                # if the user would like to continue editing the customer company, just redirect to the edit screen
                if ( $ContinueAfterSave eq '1' ) {
                    my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
                    return $LayoutObject->Redirect(
                        OP =>
                            "Action=$Self->{Action};Subaction=Change;CustomerID=" . $LayoutObject->LinkEncode($CustomerID) . ";Nav=$Nav;Notification=Update"
                    );
                }
                else {

                    # otherwise return to overview
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
                }
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );

        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        # set notification for duplicate entry
        if ( $Errors{Duplicate} ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Info     => $LayoutObject->{LanguageObject}->Translate(
                    'Customer Company %s already exists!',
                    $GetParam{CustomerID},
                ),
            );
        }

        $Self->_Edit(
            Action => 'Change',
            Nav    => $Nav,
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );
        $Self->_Edit(
            Action => 'Add',
            Nav    => $Nav,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %Errors;

        my $CustomerCompanyKey = $ConfigObject->Get( $GetParam{Source} )->{CustomerCompanyKey};
        my $CustomerCompanyID;

        # Get dynamic field backend object.
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        ENTRY:
        for my $Entry ( @{ $ConfigObject->Get( $GetParam{Source} )->{Map} } ) {

            # check dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "DynamicField $Entry->[2] not found!",
                    );
                    next ENTRY;
                }

                my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $ParamObject,
                    Mandatory          => $Entry->[4],
                );

                if ( $ValidationResult->{ServerError} ) {
                    $Errors{ $Entry->[0] } = $ValidationResult;
                }
                else {

                    # generate storable value of dynamic field edit field
                    $GetParam{ $Entry->[0] } = $DynamicFieldBackendObject->EditFieldValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ParamObject        => $ParamObject,
                        LayoutObject       => $LayoutObject,
                    );
                }
            }

            # check remaining non-dynamic-field mandatory fields
            else {
                $GetParam{ $Entry->[0] } = $ParamObject->GetParam( Param => $Entry->[0] ) // '';
                if ( !$GetParam{ $Entry->[0] } && $Entry->[4] ) {
                    $Errors{ $Entry->[0] . 'Invalid' } = 'ServerError';
                }
            }

            # save customer company key for checking duplicate
            if ( $Entry->[2] eq $CustomerCompanyKey ) {
                $CustomerCompanyID = $GetParam{ $Entry->[0] };
            }
        }

        # get CustomerCompany list
        my %List = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{Search},
            Valid  => 0,
        );

        # check duplicate field
        if ( %List && $List{$CustomerCompanyID} ) {
            $Errors{Duplicate} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add company
            if (
                $CustomerCompanyObject->CustomerCompanyAdd(
                    %GetParam,
                    UserID => $Self->{UserID},
                )
                )
            {

                $Self->_Overview(
                    Nav    => $Nav,
                    Search => $Search,
                    %GetParam,
                );
                my $Output = join '',
                    $LayoutObject->Header,
                    $LayoutObject->NavigationBar(
                        Type => $NavigationBarType,
                    ),
                    $LayoutObject->Notify(
                        Info => Translatable('Customer company added!'),
                    );

                # set dynamic field values
                ENTRY:
                for my $Entry ( @{ $ConfigObject->Get( $GetParam{Source} )->{Map} } ) {
                    next ENTRY if $Entry->[5] ne 'dynamic_field';

                    my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                    if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                        $Output .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Dynamic field %s not found!',
                                $Entry->[2],
                            ),
                        );

                        next ENTRY;
                    }

                    my $ValueSet = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectName         => $GetParam{CustomerID},
                        Value              => $GetParam{ $Entry->[0] },
                        UserID             => $Self->{UserID},
                    );

                    if ( !$ValueSet ) {
                        $Output .= $LayoutObject->Notify(
                            Info => $LayoutObject->{LanguageObject}->Translate(
                                'Unable to set value for dynamic field %s!',
                                $Entry->[2],
                            ),
                        );

                        next ENTRY;
                    }
                }

                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminCustomerCompany',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();

                return $Output;
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );

        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        # set notification for duplicate entry
        if ( $Errors{Duplicate} ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Info     => $LayoutObject->{LanguageObject}->Translate(
                    'Customer Company %s already exists!',
                    $CustomerCompanyID,
                ),
            );
        }

        $Self->_Edit(
            Action => 'Add',
            Nav    => $Nav,
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
            %GetParam,
        );
        my $Output       = $LayoutObject->Header();
        my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';
        $Output .= $LayoutObject->NavigationBar(
            Type => $NavigationBarType,
        );
        $Output .= $LayoutObject->Notify( Info => Translatable('Customer company updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerCompany',
            Data         => \%Param,
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
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

    # send parameter ReadOnly to JS object
    $LayoutObject->AddJSData(
        Key   => 'ReadOnly',
        Value => $ConfigObject->{ $Param{Source} }->{ReadOnly},
    );

    # Get valid object.
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    $Param{'ValidOption'} = $LayoutObject->BuildSelection(
        Data       => { $ValidObject->ValidList(), },
        Name       => 'ValidID',
        Class      => 'Modernize',
        SelectedID => $Param{ValidID},
    );

    # Get needed objects.
    my $ParamObject               = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    ENTRY:
    for my $Entry ( @{ $ConfigObject->Get( $Param{Source} )->{Map} } ) {
        if ( $Entry->[0] ) {

            # Handle dynamic fields
            if ( $Entry->[5] eq 'dynamic_field' ) {

                my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Entry->[2] };

                next ENTRY if !IsHashRefWithData($DynamicFieldConfig);

                # Get HTML for dynamic field
                my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Param{ $Entry->[0] } ? $Param{ $Entry->[0] } : undef,
                    Mandatory          => $Entry->[4],
                    LayoutObject       => $LayoutObject,
                    ParamObject        => $ParamObject,

                    # Server error, if any
                    %{ $Param{Errors}->{ $Entry->[0] } },
                );

                # skip fields for which HTML could not be retrieved
                next ENTRY if !IsHashRefWithData($DynamicFieldHTML);

                $LayoutObject->Block(
                    Name => 'PreferencesGeneric',
                    Data => {},
                );

                $LayoutObject->Block(
                    Name => 'DynamicField',
                    Data => {
                        Name  => $DynamicFieldConfig->{Name},
                        Label => $DynamicFieldHTML->{Label},
                        Field => $DynamicFieldHTML->{Field},
                    },
                );

                next ENTRY;
            }

            my $Block = 'Input';

            # build selections or input fields
            if ( $ConfigObject->Get( $Param{Source} )->{Selections}->{ $Entry->[0] } ) {
                my $OptionRequired = '';
                if ( $Entry->[4] ) {
                    $OptionRequired = 'Validate_Required';
                }

                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $LayoutObject->BuildSelection(
                    Data =>
                        $ConfigObject->Get( $Param{Source} )->{Selections}
                        ->{ $Entry->[0] },
                    Name  => $Entry->[0],
                    Class => "$OptionRequired Modernize " .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    Translation => 1,
                    Sort        => 'AlphanumericKey',
                    SelectedID  => $Param{ $Entry->[0] },
                    Max         => 35,
                );

            }
            elsif ( $Entry->[0] =~ m/^CustomerCompanyCountry/i ) {

                # build Country selection with English names
                $Block = 'Option';
                my $OptionRequired = $Entry->[4] ? 'Validate_Required' : '';
                my $CountryList;
                if ( $ConfigObject->Get('ReferenceData::TranslatedCountryNames') ) {

                    # Flag+Name => code
                    $CountryList = $Kernel::OM->Get('Kernel::System::ReferenceData')->CLDRCountryList(
                        Language => $LayoutObject->{UserLanguage},
                    );

                    # Make sure that the previous value exists in the selection list even if it isn't a country code.
                    my $PreviousCountry = $Param{ $Entry->[0] };
                    if ($PreviousCountry) {
                        $CountryList->{$PreviousCountry} //= $PreviousCountry;
                    }
                }
                else {

                    # English name => English name
                    $CountryList = $Kernel::OM->Get('Kernel::System::ReferenceData')->CountryList;
                }

                $Param{Option} = $LayoutObject->BuildSelection(
                    Data         => $CountryList,
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                    Name         => $Entry->[0],
                    Class        => "$OptionRequired Modernize " .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    SelectedID => ( $Param{ $Entry->[0] } // 1 ),
                );
            }
            elsif ( $Entry->[0] =~ m/^ValidID/i ) {

                # build ValidID string
                $Block = 'Option';
                my $OptionRequired = $Entry->[4] ? 'Validate_Required' : '';
                $Param{Option} = $LayoutObject->BuildSelection(
                    Data  => { $ValidObject->ValidList(), },
                    Name  => $Entry->[0],
                    Class => "$OptionRequired Modernize " .
                        ( $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '' ),
                    SelectedID => defined( $Param{ $Entry->[0] } ) ? $Param{ $Entry->[0] } : 1,
                );
            }
            else {
                $Param{Value} = $Param{ $Entry->[0] } || '';
            }

            # show required flag
            if ( $Entry->[4] ) {
                $Param{MandatoryClass} = 'class="Mandatory"';
                $Param{StarLabel}      = '<span class="Marker">*</span>';
                $Param{RequiredClass}  = 'Validate_Required';
            }
            else {
                $Param{MandatoryClass} = '';
                $Param{StarLabel}      = '';
                $Param{RequiredClass}  = '';
            }

            # show readonly flag
            if ( $Entry->[7] ) {
                $Param{ReadOnlyType} = 'readonly';
            }
            else {
                $Param{ReadOnlyType} = '';
            }

            # add form option
            if ( $Param{Type} && $Param{Type} eq 'hidden' ) {
                $Param{Preferences} .= $Param{Value};
            }
            else {
                $LayoutObject->Block(
                    Name => 'PreferencesGeneric',
                    Data => {
                        Item => $Entry->[1],
                        %Param
                    },
                );
                $LayoutObject->Block(
                    Name => "PreferencesGeneric$Block",
                    Data => {
                        %Param,
                        Item         => $Entry->[1],
                        Name         => $Entry->[0],
                        Value        => $Param{ $Entry->[0] },
                        InvalidField => $Param{Errors}->{ $Entry->[0] . 'Invalid' } || '',
                    },
                );
                if ( $Entry->[4] ) {
                    $LayoutObject->Block(
                        Name => "PreferencesGeneric${Block}Required",
                        Data => {
                            Name => $Entry->[0],
                        },
                    );
                }
            }
        }
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'IncludeInvalid',
        Data => {
            IncludeInvalid        => $Self->{IncludeInvalid},
            IncludeInvalidChecked => $Self->{IncludeInvalid} ? 'checked' : '',
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionSearch',
        Data => \%Param,
    );

    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    # get writable data sources
    my %CustomerCompanySource = $CustomerCompanyObject->CustomerCompanySourceList(
        ReadOnly => 0,
    );

    # only show Add option if we have at least one writable backend
    if ( scalar keys %CustomerCompanySource ) {
        $Param{SourceOption} = $LayoutObject->BuildSelection(
            Data       => { %CustomerCompanySource, },
            Name       => 'Source',
            SelectedID => $Param{Source} || '',
            Class      => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'ActionAdd',
            Data => \%Param,
        );
    }

    # if there are any registries to search, the table is filled and shown
    if ( $Param{Search} ) {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # same Limit as $Self->{CustomerCompany}->{CustomerCompanySearchListLimit}
        # smallest Limit from all sources
        my $Limit;
        SOURCE:
        for my $Count ( '', 1 .. 10 ) {
            next SOURCE if !$ConfigObject->Get("CustomerCompany$Count");
            my $CustomerUserMap = $ConfigObject->Get("CustomerCompany$Count");
            next SOURCE if !$CustomerUserMap->{CustomerCompanySearchListLimit};
            if ( !defined $Limit || $CustomerUserMap->{CustomerCompanySearchListLimit} < $Limit ) {
                $Limit = $CustomerUserMap->{CustomerCompanySearchListLimit};
            }
        }

        # as fallback take the hardcoded limit of Kernel/System/CustomerCompany/DB.pm
        $Limit //= 50000;

        my %ListAllItems = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{Search},
            Limit  => $Limit + 1,
            Valid  => 0,
        );

        if ( keys %ListAllItems <= $Limit ) {
            my $ListAllItems = keys %ListAllItems;
            $LayoutObject->Block(
                Name => 'OverviewHeader',
                Data => {
                    ListAll => $ListAllItems,
                    Limit   => $Limit,
                },
            );
        }

        my %List = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{Search},
            Valid  => $Self->{IncludeInvalid} ? 0 : 1,
        );

        if ( keys %ListAllItems > $Limit ) {
            my $ListAllItems   = keys %ListAllItems;
            my $SearchListSize = keys %List;

            $LayoutObject->Block(
                Name => 'OverviewHeader',
                Data => {
                    SearchListSize => $SearchListSize,
                    ListAll        => $ListAllItems,
                    Limit          => $Limit,
                },
            );
        }

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        if ( !$ConfigObject->Get( $Param{Source} )->{Params}->{ForeignDB} ) {
            $LayoutObject->Block( Name => 'LocalDB' );
        }

        # if there are results to show
        if (%List) {
            for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {

                my %Data = $CustomerCompanyObject->CustomerCompanyGet( CustomerID => $ListKey );
                $LayoutObject->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        %Data,
                        Search => $Param{Search},
                        Nav    => $Param{Nav},
                    },
                );

                if ( !$ConfigObject->Get( $Param{Source} )->{Params}->{ForeignDB} ) {
                    $LayoutObject->Block(
                        Name => 'LocalDBRow',
                        Data => {
                            Valid => $ValidList{ $Data{ValidID} },
                            %Data,
                        },
                    );
                }

            }
        }

        # otherwise it displays a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }
    }

    # if there is nothing to search it shows a message
    else
    {
        $LayoutObject->Block(
            Name => 'NoSearchTerms',
            Data => {},
        );
    }
    return 1;
}

1;
