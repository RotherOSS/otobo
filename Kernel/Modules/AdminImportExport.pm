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

package Kernel::Modules::AdminImportExport;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # ------------------------------------------------------------ #
    # template edit (common)
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'TemplateEdit1' ) {

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        if ( !$ObjectList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No object backend found!'),
            );

            return;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        # get params
        my $TemplateData;
        my $TemplateID = $ParamObject->GetParam( Param => 'TemplateID' );

        my $SaveContinue = $ParamObject->GetParam( Param => 'SubmitNext' );

        if ( !$SaveContinue ) {

            # if needed new form
            if ( !$TemplateID ) {
                return $Self->_MaskTemplateEdit1(
                    New => 1,
                    %Param,
                );
            }

            # if there is template id
            # get template data
            $TemplateData = $ImportExportObject->TemplateGet(
                TemplateID => $TemplateID,
                UserID     => $Self->{UserID},
            );

            if ( !$TemplateData->{TemplateID} ) {
                $LayoutObject->FatalError(
                    Message => Translatable('Template not found!'),
                );

                return;
            }

            # if edit
            if ( $TemplateData->{TemplateID} ) {
                return $Self->_MaskTemplateEdit1( %Param, %{$TemplateData} );
            }
        }

        # if save & continue
        my %ServerError;

        # get all data for params and check for errors
        for my $Param (qw(Comment Object Format Name ValidID TemplateID)) {
            $TemplateData->{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }

        # is a new template?
        my $New;
        if ( !$TemplateData->{TemplateID} ) {
            $New = 1;
        }

        # check needed fields
        # for new templates
        if ($New) {

            if ( !$TemplateData->{Object} ) {
                $ServerError{Object} = 1;
            }

            if ( !$TemplateData->{Format} ) {
                $ServerError{Format} = 1;
            }

        }

        # for all templates
        if ( !$TemplateData->{Name} ) {
            $ServerError{Name} = 1;
        }

        # if some error
        if ( $ServerError{Format} || $ServerError{Object} || $ServerError{Name} ) {
            return $Self->_MaskTemplateEdit1(
                ServerError => \%ServerError,
                New         => $New,
                %{$TemplateData},
            );
        }

        # save to database
        my $Success;

        if ($New) {
            $TemplateData->{TemplateID} = $ImportExportObject->TemplateAdd(
                %{$TemplateData},
                UserID => $Self->{UserID},
            );
            $Success = $TemplateData->{TemplateID};
        }
        else {
            $Success = $ImportExportObject->TemplateUpdate(
                UserID => $Self->{UserID},
                %{$TemplateData},
            );
        }

        if ( !$Success ) {
            $LayoutObject->FatalError(
                Message => Translatable('Can\'t insert/update template!'),
            );

            return;
        }

        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=TemplateEdit2;TemplateID=$TemplateData->{TemplateID}",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (object)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit2' ) {

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        if ( !$ObjectList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No object backend found!'),
            );

            return;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        # get template id
        my $TemplateID = $ParamObject->GetParam( Param => 'TemplateID' );

        if ( !$TemplateID ) {
            $LayoutObject->FatalError(
                Message => Translatable('Needed TemplateID!'),
            );

            return;
        }

        my $SubmitNext = $ParamObject->GetParam( Param => 'SubmitNext' );

        if ( !$SubmitNext ) {
            return $Self->_MaskTemplateEdit2( TemplateID => $TemplateID );
        }

        # save template starts here

        # get object attributes
        my $ObjectAttributeList = $ImportExportObject->ObjectAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        my %AttributeValues;

        my $Error = 0;
        my %ServerError;
        my %DataTypeError;

        # get attribute values from form
        for my $Item ( $ObjectAttributeList->@* ) {

            # get form data
            $AttributeValues{ $Item->{Key} } = $LayoutObject->ImportExportFormDataGet(
                Item => $Item,
            );

            # reload form if value is required and is not there
            if ( $Item->{Form}->{Invalid} ) {
                $ServerError{ $Item->{Name} } = 1;
                $Error = 1;
            }

            if ( $AttributeValues{ $Item->{Key} } ) {

                # look for regexp for data type allowed
                if (
                    $Item->{Input}->{Regex}
                    &&
                    !$AttributeValues{ $Item->{Key} } =~ $Item->{Input}->{Regex}
                    )
                {

                    $DataTypeError{ $Item->{Name} } = 1;
                    $Error = 1;
                }
            }
        }

        # reload with server errors
        if ($Error) {
            return $Self->_MaskTemplateEdit2(
                ServerError      => \%ServerError,
                DataTypeError    => \%DataTypeError,
                TemplateDataForm => \%AttributeValues,
                TemplateID       => $TemplateID,
            );
        }

        # save the object data
        $ImportExportObject->ObjectDataSave(
            TemplateID => $TemplateID,
            ObjectData => \%AttributeValues,
            UserID     => $Self->{UserID},
        );

        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=TemplateEdit3;TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (format)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit3' ) {

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        if ( !$ObjectList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No object backend found!'),
            );

            return;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        # get template id
        my $TemplateID = $ParamObject->GetParam( Param => 'TemplateID' );

        if ( !$TemplateID ) {
            $LayoutObject->FatalError(
                Message => Translatable('Needed TemplateID!'),
            );

            return;
        }

        my $SubmitNext = $ParamObject->GetParam( Param => 'SubmitNext' );

        if ( !$SubmitNext ) {
            return $Self->_MaskTemplateEdit3( TemplateID => $TemplateID );
        }

        # save starting here

        # get format attributes
        my $FormatAttributeList = $ImportExportObject->FormatAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get format data
        my $FormatData = $ImportExportObject->FormatDataGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        my $Error = 0;
        my %ServerError;

        # get attribute values from form
        my %AttributeValues;
        for my $Item ( $FormatAttributeList->@* ) {

            # get form data
            $AttributeValues{ $Item->{Key} } = $LayoutObject->ImportExportFormDataGet(
                Item => $Item,
            );

            # reload form if value is required
            if ( $Item->{Form}->{Invalid} ) {
                $ServerError{ $Item->{Name} } = 1;
                $Error = 1;
            }
        }

        # reload with server errors
        if ($Error) {
            return $Self->_MaskTemplateEdit3(
                ServerError => \%ServerError,
                TemplateID  => $TemplateID,
            );
        }

        # save the format data
        $ImportExportObject->FormatDataSave(
            TemplateID => $TemplateID,
            FormatData => \%AttributeValues,
            UserID     => $Self->{UserID},
        );

        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=TemplateEdit4;TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (mapping)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit4' ) {

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        if ( !$ObjectList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No object backend found!'),
            );

            return;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $ParamObject->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $ImportExportObject->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $LayoutObject->FatalError(
                Message => Translatable('Template not found!'),
            );

            return;
        }

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionOverview' );

        $LayoutObject->AddJSData(
            Key   => 'TemplateEdit4',
            Value => 1,
        );

        # output headline
        $LayoutObject->Block(
            Name => 'TemplateEdit4',
            Data => {
                %{$TemplateData},
                ObjectName => $ObjectList->{ $TemplateData->{Object} },
                FormatName => $FormatList->{ $TemplateData->{Format} },
            },
        );

        # get as list of mapping IDs for this template
        my $MappingIDs = $ImportExportObject->MappingList(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # get object attributes
        my $MappingObjectAttributes = $ImportExportObject->MappingObjectAttributesGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # create the object specific headers and add the common headers
        my $NumColumns;
        {
            my @Headers = map { $_->{Name} } $MappingObjectAttributes->@*;
            push @Headers, 'Column', 'Up', 'Down', 'Delete';

            for my $Header (@Headers) {

                # output attribute row
                $LayoutObject->Block(
                    Name => 'TemplateEdit4TableHeader',
                    Data => {
                        Header => $Header,
                    },
                );
            }

            # to use in colspan for 'no data found' message
            $NumColumns = @Headers;
        }

        my $EmptyMap            = 1;
        my $AttributeRowCounter = 0;
        for my $MappingID ( $MappingIDs->@* ) {

            $EmptyMap = 0;

            # output attribute row
            $LayoutObject->Block(
                Name => 'TemplateEdit4Row',
                Data => {
                    MappingID => $MappingID,
                },
            );

            # get mapping object data
            my $MappingObjectData = $ImportExportObject->MappingObjectDataGet(
                MappingID => $MappingID,
                UserID    => $Self->{UserID},
            );

            # get mapping format data
            my $MappingFormatData = $ImportExportObject->MappingFormatDataGet(
                MappingID => $MappingID,
                UserID    => $Self->{UserID},
            );

            for my $Item ( $MappingObjectAttributes->@* ) {

                # create form input
                my $InputString = $LayoutObject->ImportExportFormInputCreate(
                    Item   => $Item,
                    Prefix => 'Object::' . $AttributeRowCounter . '::',
                    Value  => $MappingObjectData->{ $Item->{Key} },
                    ID     => $Item->{Key} . $AttributeRowCounter,
                );

                # output attribute row
                $LayoutObject->Block(
                    Name => 'TemplateEdit4Column',
                    Data => {
                        Name      => $Item->{Name},
                        ID        => 'Object::' . $AttributeRowCounter . '::' . $Item->{Key},
                        InputStrg => $InputString,
                        Counter   => $AttributeRowCounter,
                    },
                );
            }

            # output column counter
            $LayoutObject->Block(
                Name => 'TemplateEdit4MapNumberColumn',
                Data => {
                    Counter => $AttributeRowCounter,
                },
            );

            # hide the up button for first element and down button for the last element
            my $UpBlock;
            my $DownBlock;
            my $NumberOfElements = $MappingIDs->@*;

            if ( $AttributeRowCounter == 0 ) {
                $UpBlock = 'TemplateEdit4NoUpButton';
            }
            else {
                $UpBlock = 'TemplateEdit4UpButton';
            }

            # check if this is the last element
            if ( $AttributeRowCounter == ( $NumberOfElements - 1 ) ) {
                $DownBlock = 'TemplateEdit4NoDownButton';
            }
            else {
                $DownBlock = 'TemplateEdit4DownButton';
            }

            # up button block
            $LayoutObject->Block(
                Name => $UpBlock,
                Data => { MappingID => $MappingID },
            );

            # down button block
            $LayoutObject->Block(
                Name => $DownBlock,
                Data => { MappingID => $MappingID },
            );

            $AttributeRowCounter++;
        }

        # output an empty list
        if ($EmptyMap) {

            # output list
            $LayoutObject->Block(
                Name => 'TemplateEdit4NoMapFound',
                Data => {
                    Columns => $NumColumns,
                },
            );
        }

        # output the complete HTML
        return join '',
            $LayoutObject->Header,
            $LayoutObject->NavigationBar,
            $LayoutObject->Output(
                TemplateFile => 'AdminImportExport',
                Data         => \%Param,
            ),
            $LayoutObject->Footer;
    }

    # ------------------------------------------------------------ #
    # template save (mapping)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateSave4' ) {

        # get template id
        my $TemplateID = $ParamObject->GetParam( Param => 'TemplateID' );

        my %Submit = (
            SubmitNext => 'TemplateEdit5',
            SubmitBack => 'TemplateEdit3',
            Reload     => 'TemplateEdit4',
            MappingAdd => 'TemplateEdit4',
        );

        # get submit action
        my $Subaction    = $Submit{Reload};
        my $SubmitButton = '';

        PARAM:
        for my $SubmitKey ( sort keys %Submit ) {
            next PARAM if !$ParamObject->GetParam( Param => $SubmitKey );

            $Subaction    = $Submit{$SubmitKey};
            $SubmitButton = $SubmitKey;

            last PARAM;
        }

        # get mapping data list
        my $MappingIDs = $ImportExportObject->MappingList(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get object attributes
        my $MappingObjectAttributes = $ImportExportObject->MappingObjectAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get format attributes
        my $MappingFormatAttributes = $ImportExportObject->MappingFormatAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        my $Counter = 0;
        MAPPINGID:
        for my $MappingID ( $MappingIDs->@* ) {

            # get object attribute values
            my %ObjectAttributeValues;
            for my $Item ( $MappingObjectAttributes->@* ) {

                # get object form data
                $ObjectAttributeValues{ $Item->{Key} } = $LayoutObject->ImportExportFormDataGet(
                    Item   => $Item,
                    Prefix => 'Object::' . $Counter . '::',
                );
            }

            # save the mapping object data
            $ImportExportObject->MappingObjectDataSave(
                MappingID         => $MappingID,
                MappingObjectData => \%ObjectAttributeValues,
                UserID            => $Self->{UserID},
            );

            # get format attribute values
            my %FormatAttributeValues;
            for my $Item ( $MappingFormatAttributes->@* ) {

                # get format form data
                $FormatAttributeValues{ $Item->{Key} } = $LayoutObject->ImportExportFormDataGet(
                    Item   => $Item,
                    Prefix => 'Format::' . $Counter . '::',
                );
            }

            # save the mapping format data
            $ImportExportObject->MappingFormatDataSave(
                MappingID         => $MappingID,
                MappingFormatData => \%FormatAttributeValues,
                UserID            => $Self->{UserID},
            );

            $Counter++;
        }

        MAPPINGID:
        for my $MappingID ( $MappingIDs->@* ) {

            # delete this mapping row
            if ( $ParamObject->GetParam( Param => "MappingDelete::$MappingID" ) ) {
                $ImportExportObject->MappingDelete(
                    MappingID  => $MappingID,
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                next MAPPINGID;
            }

            # move mapping data row up
            if ( $ParamObject->GetParam( Param => "MappingUp::$MappingID" ) ) {
                $ImportExportObject->MappingUp(
                    MappingID  => $MappingID,
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                next MAPPINGID;
            }

            # move mapping data row down
            if ( $ParamObject->GetParam( Param => "MappingDown::$MappingID" ) ) {
                $ImportExportObject->MappingDown(
                    MappingID  => $MappingID,
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                next MAPPINGID;
            }
        }

        # add a new mapping row
        if ( $SubmitButton eq 'MappingAdd' ) {
            $ImportExportObject->MappingAdd(
                TemplateID => $TemplateID,
                UserID     => $Self->{UserID},
            );
        }

        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=$Subaction;TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template edit (search)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateEdit5' ) {

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        if ( !$ObjectList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No object backend found!'),
            );

            return;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $ParamObject->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $ImportExportObject->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $LayoutObject->FatalError(
                Message => Translatable('Template not found!'),
            );

            return;
        }

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionOverview' );

        # get search data
        my $SearchData = $ImportExportObject->SearchDataGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # create rescrict export string
        my $RestrictExportStrg = $LayoutObject->ImportExportFormInputCreate(
            Item => {
                Key   => 'RestrictExport',
                Input => {
                    Type => 'Checkbox',
                },
            },
            Value => scalar keys $SearchData->%*,
        );

        # output list
        $LayoutObject->Block(
            Name => 'TemplateEdit5',
            Data => {
                %{$TemplateData},
                RestrictExportStrg => $RestrictExportStrg,
            },
        );

        # get search attributes
        my $SearchAttributeList = $ImportExportObject->SearchAttributesGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        # output object attributes
        for my $Item ( $SearchAttributeList->@* ) {

            # create form input
            my $InputString = $LayoutObject->ImportExportFormInputCreate(
                Item  => $Item,
                Value => $SearchData->{ $Item->{Key} },
                Class => 'Modernize',
            );

            # output attribute row
            $LayoutObject->Block(
                Name => 'TemplateEdit5Element',
                Data => {
                    Name      => $Item->{Name} || '',
                    InputStrg => $InputString,
                    ID        => $Item->{Key},
                },
            );
        }

        # output the complete HTML
        return join '',
            $LayoutObject->Header,
            $LayoutObject->NavigationBar,
            $LayoutObject->Output(
                TemplateFile => 'AdminImportExport',
                Data         => \%Param,
            ),
            $LayoutObject->Footer;
    }

    # ------------------------------------------------------------ #
    # template save (search)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateSave5' ) {

        # get template id
        my $TemplateID = $ParamObject->GetParam( Param => 'TemplateID' );

        my %Submit = (
            SubmitNext => 'Overview',
            SubmitBack => 'TemplateEdit4',
            Reload     => 'TemplateEdit5',
        );

        # get submit action
        my $Subaction = $Submit{Reload};

        PARAM:
        for my $SubmitKey ( sort keys %Submit ) {
            next PARAM if !$ParamObject->GetParam( Param => $SubmitKey );

            $Subaction = $Submit{$SubmitKey};
            last PARAM;
        }

        # delete all search restrictions
        if ( !$ParamObject->GetParam( Param => 'RestrictExport' ) ) {

            # delete all search data
            $ImportExportObject->SearchDataDelete(
                TemplateID => $TemplateID,
                UserID     => $Self->{UserID},
            );

            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=$Subaction;TemplateID=$TemplateID",
            );
        }

        # get search attributes
        my $SearchAttributeList = $ImportExportObject->SearchAttributesGet(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        # get attribute values from form
        my %AttributeValues;
        for my $Item ( $SearchAttributeList->@* ) {

            # get form data
            $AttributeValues{ $Item->{Key} } = $LayoutObject->ImportExportFormDataGet(
                Item => $Item,
            );

            # reload form if value is required
            if ( $Item->{Form}->{Invalid} ) {
                $Subaction = $Submit{Reload};
            }
        }

        # save the search data
        $ImportExportObject->SearchDataSave(
            TemplateID => $TemplateID,
            SearchData => \%AttributeValues,
            UserID     => $Self->{UserID},
        );

        return $LayoutObject->Redirect(
            OP => "Action=$Self->{Action};Subaction=$Subaction;TemplateID=$TemplateID",
        );
    }

    # ------------------------------------------------------------ #
    # template delete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TemplateDelete' ) {

        # get template id
        my $TemplateID = $ParamObject->GetParam( Param => 'TemplateID' );

        # delete template from database
        my $Delete = $ImportExportObject->TemplateDelete(
            TemplateID => $TemplateID,
            UserID     => $Self->{UserID},
        );

        return $LayoutObject->Attachment(
            ContentType => 'text/html',
            Content     => ($Delete) ? $TemplateID : 0,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # import information
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ImportInformation' ) {

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        if ( !$ObjectList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No object backend found!'),
            );

            return;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $ParamObject->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $ImportExportObject->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $LayoutObject->FatalError(
                Message => Translatable('Template not found!'),
            );

            return;
        }

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionOverview' );

        # output list
        $LayoutObject->Block(
            Name => 'ImportInformation',
            Data => {
                %{$TemplateData},
            },
        );

        # output the complete HTML
        return join '',
            $LayoutObject->Header,
            $LayoutObject->NavigationBar,
            $LayoutObject->Output(
                TemplateFile => 'AdminImportExport',
                Data         => \%Param,
            ),
            $LayoutObject->Footer;
    }

    # ------------------------------------------------------------ #
    # import
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Import' ) {

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $ParamObject->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $ImportExportObject->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $LayoutObject->FatalError(
                Message => Translatable('Template not found!'),
            );

            return;
        }

        # get source file
        my %SourceFile = $ParamObject->GetUploadAll(
            Param  => 'SourceFile',
            Source => 'String',
        );

        $SourceFile{Content} ||= '';

        # import data
        my $Result = $ImportExportObject->Import(
            TemplateID    => $TemplateData->{TemplateID},
            SourceContent => \$SourceFile{Content},
            UserID        => $Self->{UserID},
        );

        if ( !$Result ) {
            $LayoutObject->FatalError(
                Message => Translatable('Error occurred. Import impossible! See Syslog for details.'),
            );

            return;
        }

        # output import results
        $LayoutObject->Block(
            Name => 'ImportResult',
            Data => {
                %{$Result},
            },
        );

        # get all return codes and collect the duplicate names
        my @DuplicateNames;
        RETURNCODE:
        for my $RetCode ( sort keys %{ $Result->{RetCode} } ) {

            # just get the duplicate name
            if ( $RetCode =~ m{ \A DuplicateName \s+ (.+) }xms ) {
                push @DuplicateNames, $1;
            }
            else {
                $LayoutObject->Block(
                    Name => 'ImportResultReturnCode',
                    Data => {
                        ReturnCodeName  => $RetCode,
                        ReturnCodeCount => $Result->{RetCode}->{$RetCode},
                    },
                );
            }
        }

        # output duplicate names if neccessary
        if (@DuplicateNames) {

            my $DuplicateNamesString = join ', ', @DuplicateNames;

            $LayoutObject->Block(
                Name => 'ImportResultDuplicateNames',
                Data => {
                    DuplicateNames => $DuplicateNamesString,
                },
            );
        }

        # output last processed line mumber of import file
        if ( $Result->{Failed} ) {
            $LayoutObject->Block(
                Name => 'ImportResultLastLineNumber',
                Data => {
                    LastLineNumber => $Result->{Counter},
                },
            );
        }

        # start output
        return join '',
            $LayoutObject->Header,
            $LayoutObject->NavigationBar,
            $LayoutObject->Output(
                TemplateFile => 'AdminImportExport',
                Data         => \%Param,
            ),
            $LayoutObject->Footer;
    }

    # ------------------------------------------------------------ #
    # export
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Export' ) {

        # get params
        my $TemplateData = {};
        $TemplateData->{TemplateID} = $ParamObject->GetParam( Param => 'TemplateID' );

        # get template data
        $TemplateData = $ImportExportObject->TemplateGet(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$TemplateData->{TemplateID} ) {
            $LayoutObject->FatalError(
                Message => Translatable('Template not found!'),
            );

            return;
        }

        # export data
        my $Result = $ImportExportObject->Export(
            TemplateID => $TemplateData->{TemplateID},
            UserID     => $Self->{UserID},
        );

        if ( !$Result ) {
            $LayoutObject->FatalError(
                Message => Translatable('Error occurred. Export impossible! See Syslog for details.'),
            );

            return;
        }

        # TODO: does application/x-ndjson need "\r\n" as separator?
        my $FileContent = join "\n", $Result->{DestinationContent}->@*;

        # TODO: the formatters should tell their extension, and MIME type
        # TODO: Could not find a MIME type for concatenated JSON
        my $Extension = lc $TemplateData->{Format};
        my %MimeType  = (
            csv  => 'text/csv',
            json => 'text/plain'    # or 'application/x-ndjson', 'application/json-seq'
        );
        return $LayoutObject->Attachment(
            Type        => 'attachment',
            Filename    => "Export.$Extension",
            ContentType => ( $MimeType{$Extension} // 'text/plain' ),
            Content     => $FileContent,
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        # show a note that the user needs to insatll any module that provides an import/export backend.
        if ( !$ObjectList ) {

            # output overview
            $LayoutObject->Block(
                Name => 'Overview',
                Data => {
                    %Param,
                },
            );

            $LayoutObject->Block( Name => 'NoteObjectBackend' );

            # output header and navbar
            return join '',
                $LayoutObject->Header,
                $LayoutObject->NavigationBar,
                $LayoutObject->Output(
                    TemplateFile => 'AdminImportExport',
                    Data         => \%Param,
                ),
                $LayoutObject->Footer;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        # output overview
        $LayoutObject->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );

        $LayoutObject->Block( Name => 'ActionList' );
        $LayoutObject->Block( Name => 'ActionAdd' );
        $LayoutObject->Block( Name => 'NoteCreateTemplate' );

        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        my $EmptyDatabase = 1;

        CLASS:
        for my $Object ( sort { $ObjectList->{$a} cmp $ObjectList->{$b} } keys %{$ObjectList} ) {

            # get template list
            my $TemplateList = $ImportExportObject->TemplateList(
                Object => $Object,
                UserID => $Self->{UserID},
            );

            if ( !$TemplateList || ref $TemplateList ne 'ARRAY' || !$TemplateList->@* ) {
                next CLASS;
            }

            $EmptyDatabase = 0;

            # output list
            $LayoutObject->Block(
                Name => 'OverviewList',
                Data => {
                    ObjectName => $ObjectList->{$Object},
                },
            );

            for my $TemplateID ( $TemplateList->@* ) {

                # get template data
                my $TemplateData = $ImportExportObject->TemplateGet(
                    TemplateID => $TemplateID,
                    UserID     => $Self->{UserID},
                );

                # output row
                $LayoutObject->Block(
                    Name => 'OverviewListRow',
                    Data => {
                        %{$TemplateData},
                        FormatName => $FormatList->{ $TemplateData->{Format} },
                        Valid      => $ValidList{ $TemplateData->{ValidID} },
                    },
                );
            }
        }

        # output an empty list
        if ($EmptyDatabase) {

            # output list
            $LayoutObject->Block(
                Name => 'OverviewList',
                Data => {
                    ObjectName => Translatable('Template List'),
                },
            );
            $LayoutObject->Block( Name => 'NoDataFoundMsg' );
        }

        # output the complete HTML
        return join '',
            $LayoutObject->Header,
            $LayoutObject->NavigationBar,
            $LayoutObject->Output(
                TemplateFile => 'AdminImportExport',
                Data         => \%Param,
            ),
            $LayoutObject->Footer;
    }
}

sub _MaskTemplateEdit1 {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # output overview
    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # generate ValidOptionStrg
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;
    my $ValidOptionStrg  = $LayoutObject->BuildSelection(
        Name       => 'ValidID',
        Data       => \%ValidList,
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize',
    );

    my $Class = ' Validate_Required ';

    if ( $ServerError{Name} ) {
        $Class .= 'ServerError';
    }

    $LayoutObject->Block(
        Name => 'TemplateEdit1',
        Data => {
            %Param,
            ValidOptionStrg => $ValidOptionStrg,
            NameClass       => $Class,
        },
    );

    if ( $Param{TemplateID} ) {
        $LayoutObject->Block(
            Name => 'EditObjectFormat',
            Data => {
                %Param,
                ObjectName => $Param{Object},
                FormatName => $Param{Format},
            },
        );
    }

    # for new Import/Export templates
    if ( $Param{New} ) {

        # get ImportExport object
        my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

        # get object list
        my $ObjectList = $ImportExportObject->ObjectList;

        if ( !$ObjectList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No object backend found!'),
            );

            return;
        }

        # get format list
        my $FormatList = $ImportExportObject->FormatList;

        if ( !$FormatList ) {
            $LayoutObject->FatalError(
                Message => Translatable('No format backend found!'),
            );

            return;
        }

        $Class = ' Validate_Required ';

        if ( $ServerError{Object} ) {
            $Class .= 'ServerError';
        }

        # generate ObjectOptionStrg
        my $ObjectOptionStrg = $LayoutObject->BuildSelection(
            Data         => $ObjectList,
            Name         => 'Object',
            SelectedID   => $Param{Object} || '',
            PossibleNone => 1,
            Translation  => 1,
            Class        => $Class . ' Modernize',
        );

        $Class = ' Validate_Required ';
        if ( $ServerError{Format} ) {
            $Class .= 'ServerError';
        }

        # generate FormatOptionStrg
        my $FormatOptionStrg = $LayoutObject->BuildSelection(
            Data         => $FormatList,
            Name         => 'Format',
            SelectedID   => $Param{Format} || '',
            PossibleNone => 1,
            Translation  => 1,
            Class        => $Class . ' Modernize',
        );

        $LayoutObject->Block(
            Name => 'NewObjectFormat',
            Data => {
                ObjectOption => $ObjectOptionStrg,
                FormatOption => $FormatOptionStrg,
            },
        );
    }

    # output the complete HTML
    return join '',
        $LayoutObject->Header,
        $LayoutObject->NavigationBar,
        $LayoutObject->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        ),
        $LayoutObject->Footer;
}

sub _MaskTemplateEdit2 {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my %DataTypeError;
    if ( $Param{DataTypeError} ) {
        %DataTypeError = %{ $Param{DataTypeError} };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $TemplateID;
    if ( $Param{TemplateID} ) {
        $TemplateID = $Param{TemplateID};
    }
    else {
        $LayoutObject->FatalError(
            Message => Translatable('Needed TemplateID!'),
        );

        return;
    }

    # get ImportExport object
    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

    # get template data
    my $TemplateData;
    $TemplateData = $ImportExportObject->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    if ( !$TemplateData->{TemplateID} ) {
        $LayoutObject->FatalError(
            Message => Translatable('Template not found!'),
        );

        return;
    }

    $LayoutObject->AddJSData(
        Key   => 'BackURL',
        Value => "Action=$Self->{Action};Subaction=TemplateEdit1;TemplateID=$TemplateID",
    );

    $LayoutObject->AddJSData(
        Key   => 'BaseLink',
        Value => $LayoutObject->{Baselink},
    );

    $LayoutObject->AddJSData(
        Key   => 'TemplateOverview',
        Value => 1,
    );

    # output overview
    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # output list
    $LayoutObject->Block(
        Name => 'TemplateEdit2',
        Data => $TemplateData,
    );

    # get object attributes
    my $ObjectAttributeList = $ImportExportObject->ObjectAttributesGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    # get object data
    my $ObjectData = $ImportExportObject->ObjectDataGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    # javascript validation class per datatype
    my %JSClass;
    my %PredefinedErrorMessages;

    $JSClass{Number}                = 'Validate_Number';
    $JSClass{NumberBiggerThanZero}  = 'Validate_NumberBiggerThanZero';
    $JSClass{Integer}               = 'Validate_NumberInteger';
    $JSClass{IntegerBiggerThanZero} = 'Validate_NumberIntegerBiggerThanZero';

    $PredefinedErrorMessages{Number}                = $LayoutObject->{LanguageObject}->Translate('number');
    $PredefinedErrorMessages{NumberBiggerThanZero}  = $LayoutObject->{LanguageObject}->Translate('number bigger than zero');
    $PredefinedErrorMessages{Integer}               = $LayoutObject->{LanguageObject}->Translate('integer');
    $PredefinedErrorMessages{IntegerBiggerThanZero} = $LayoutObject->{LanguageObject}->Translate('integer bigger than zero');

    # output object attributes
    for my $Item ( $ObjectAttributeList->@* ) {

        my $Class = ' ';
        my $Value;
        my $ErrorMessage;

        if ( $Item->{Input}->{Required} ) {
            $Class        = 'Validate_Required';
            $ErrorMessage = $LayoutObject->{LanguageObject}->Translate('Element required, please insert data');
        }

        if ( $Item->{Input}->{DataType} ) {
            $Class .= " $JSClass{ $Item->{Input}->{DataType} }";
            $ErrorMessage = $LayoutObject->{LanguageObject}->Translate(
                'Invalid data, please insert a valid %s',
                $PredefinedErrorMessages{ $Item->{Input}->{DataType} }
            );
        }

        # get data from form or from database
        # ServerError = show the wrong data in form
        # !ServerError = show database data or new fields

        if ( $Param{ServerError} || $Param{DataTypeError} ) {
            $Value = $Param{TemplateDataForm}->{ $Item->{Key} };
        }
        else {
            $Value = $ObjectData->{ $Item->{Key} };
        }

        # error area

        # prepare different data & message per error
        if ( $ServerError{ $Item->{Name} } || $DataTypeError{ $Item->{Name} } ) {
            $Class .= ' ServerError';
        }

        # create form input
        my $InputString = $LayoutObject->ImportExportFormInputCreate(
            Item  => $Item,
            Class => $Class . ' Modernize',
            Value => $Value,
        );

        # build id
        my $ID;
        if ( $Item->{Prefix} ) {
            $ID = "$Item->{Prefix}$Item->{Key}";
        }
        else {
            $ID = $Item->{Key};
        }

        # output attribute row
        $LayoutObject->Block(
            Name => 'TemplateEdit2Element',
            Data => {
                Name         => $Item->{Name} || '',
                InputStrg    => $InputString,
                ID           => $ID,
                ErrorMessage => $ErrorMessage,
                Mandatory    => $Item->{Input}->{Required} ? 1 : 0,
            },
        );
    }

    # output the complete HTML
    return join '',
        $LayoutObject->Header,
        $LayoutObject->NavigationBar,
        $LayoutObject->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        ),
        $LayoutObject->Footer;
}

sub _MaskTemplateEdit3 {
    my ( $Self, %Param ) = @_;

    my %ServerError;
    if ( $Param{ServerError} ) {
        %ServerError = %{ $Param{ServerError} };
    }

    my $TemplateID;
    if ( $Param{TemplateID} ) {
        $TemplateID = $Param{TemplateID};
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$TemplateID ) {
        $LayoutObject->FatalError(
            Message => Translatable('Template not found!'),
        );

        return;
    }

    # get ImportExport object
    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

    # get template data
    my $TemplateData = $ImportExportObject->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => $Self->{UserID},
    );

    if ( !$TemplateData->{TemplateID} ) {
        $LayoutObject->FatalError(
            Message => Translatable('Template not found!'),
        );

        return;
    }

    $Param{BackURL} = "Action=$Self->{Action};Subaction=TemplateEdit2;TemplateID=$TemplateID";

    # output overview
    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->AddJSData(
        Key   => 'BackURL',
        Value => $Param{BackURL},
    );

    $LayoutObject->AddJSData(
        Key   => 'BaseLink',
        Value => $LayoutObject->{Baselink},
    );

    $LayoutObject->AddJSData(
        Key   => 'TemplateOverview',
        Value => 1,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # output list
    $LayoutObject->Block(
        Name => 'TemplateEdit3',
        Data => $TemplateData,
    );

    # get format attributes
    my $FormatAttributeList = $ImportExportObject->FormatAttributesGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    # get format data
    my $FormatData = $ImportExportObject->FormatDataGet(
        TemplateID => $TemplateData->{TemplateID},
        UserID     => $Self->{UserID},
    );

    if ( !$FormatData ) {
        $LayoutObject->FatalError(
            Message => Translatable('Format not found!'),
        );

        return;
    }

    # output format attributes
    for my $Item ( $FormatAttributeList->@* ) {

        # build id
        my $ID;
        if ( $Item->{Prefix} ) {
            $ID = "$Item->{Prefix}$Item->{Key}";
        }
        else {
            $ID = "$Item->{Key}";
        }

        my $Class = ' ';
        if ( $Item->{Input}->{Required} ) {
            $Class = 'Validate_Required ';
        }

        if ( $ServerError{ $Item->{Name} } ) {
            $Class .= ' ServerError';
        }

        # create form input
        my $InputString = $LayoutObject->ImportExportFormInputCreate(
            Item  => $Item,
            Class => $Class . ' Modernize',
            Value => $FormatData->{ $Item->{Key} },
        );

        # output attribute row
        $LayoutObject->Block(
            Name => 'TemplateEdit3Element',
            Data => {
                Name      => $Item->{Name} || '',
                InputStrg => $InputString,
                ID        => $ID,
                Mandatory => $Item->{Input}->{Required} ? 1 : 0,
            },
        );

        # output required notice
        if ( $Item->{Input}->{Required} ) {
            $LayoutObject->Block(
                Name => 'TemplateEdit3ElementRequired',
                Data => {
                    Name => $Item->{Name} || '',
                    ID   => $ID,
                },
            );
        }
    }

    # output header and navbar
    return join '',
        $LayoutObject->Header,
        $LayoutObject->NavigationBar,
        $LayoutObject->Output(
            TemplateFile => 'AdminImportExport',
            Data         => \%Param,
        ),
        $LayoutObject->Footer;
}

1;
