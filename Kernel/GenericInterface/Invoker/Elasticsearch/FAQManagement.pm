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

package Kernel::GenericInterface::Invoker::Elasticsearch::FAQManagement;

use v5.24;
use strict;
use warnings;

use Time::HiRes();

# core modules
use MIME::Base64 qw(encode_base64);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker::Elasticsearch::FAQManagement

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Invoker->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # check needed params and store them in $Self
    for my $Needed (qw/DebuggerObject WebserviceID/) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Need $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=head2 PrepareRequest()

prepare the invocation of the configured remote web service.
This will just return the data that was passed to the function.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # check needed
    for my $Needed (qw/Event ItemID/) {
        if ( !$Param{Data}{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Need $Needed!",
            };
        }
    }

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # do nothing if FAQs are not configured
    if ( !$ConfigObject->Get('Elasticsearch::FAQStoreFields') ) {
        return {
            Success           => 1,
            StopCommunication => 1,
        };
    }

    # handle all events which are neither update nor creation first

    # delete the FAQ item
    if ( $Param{Data}{Event} eq 'FAQDelete' ) {
        my %Content = (
            query => {
                term => {
                    ItemID => $Param{Data}{ItemID},
                }
            }
        );

        return {
            Success => 1,
            Data    => {
                docapi => '_delete_by_query',
                id     => '',
                %Content,
            },
        };
    }

    # put a single temporary attachment into a queue
    # more than one attachement could be put per call, but this would make error handling harder
    if ( $Param{Data}{Event} eq 'PutTMPAttachment' ) {

        # get file format to be ingested
        my $FileFormat = $ConfigObject->Get('Elasticsearch::IngestAttachmentFormat');
        my %FormatHash = map { $_ => 1 } @{$FileFormat};

        my $MaxFilesize = $ConfigObject->Get('Elasticsearch::IngestMaxFilesize');
        my $Filename    = $Param{Data}{Filename};
        my $ContentType = $Param{Data}{ContentType};
        my $Filesize    = $Param{Data}{Filesize};

        # ingest attachment only if filesize less than defined in sysconfig
        if ( $Filesize > $MaxFilesize ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        my ($TypeFormat) = $ContentType =~ m/^.*?\/([\d\w]+)/;
        my ($NameFormat) = $Filename    =~ m/\.([\d\w]+)$/;

        my %Data;
        if ( $FormatHash{$TypeFormat} || $FormatHash{$NameFormat} ) {
            my $Encoded = encode_base64( $Param{Data}{Content} );
            $Encoded =~ s/\n//g;
            $Data{filename} = $Filename;
            $Data{data}     = $Encoded;
        }
        else {
            # not a valid file type
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        return {
            Success => 1,
            Data    => {
                docapi      => '_doc',
                path        => 'Attachments',    # actually the pipeline
                id          => '',
                Attachments => [ \%Data ],
            },
        };
    }

    # handle the regular updating and creation

    # get needed objects
    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # attachment management
    if ( $Param{Data}{Event} eq 'FAQAttachmentAddPost' ) {
        my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');

        # create a temporary index to "ingest" the attachment
        my $Result = $RequesterObject->Run(
            WebserviceID => $Self->{WebserviceID},
            Invoker      => 'FAQIngestAttachment',
            Asynchronous => 0,
            Data         => {
                %{ $Param{Data} },
                Event => 'PutTMPAttachment',
            },
        );

        # return, if attachment was not added
        if ( !$Result || !$Result->{Data}{_id} ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        # set parameters
        my %Request = (
            id => $Result->{Data}{_id},
        );
        my %API = (
            docapi => '_doc',
        );
        my %IndexName = (
            index => 'tmpattachments',
        );

        # retrieve the result of the ingest-plugin
        $Result = $RequesterObject->Run(
            WebserviceID => $Self->{WebserviceID},
            Invoker      => 'UtilsIngest_GET',
            Asynchronous => 0,
            Data         => {
                IndexName => \%IndexName,
                Request   => \%Request,
                API       => \%API,
            },
        );

        # prepare processed data to be appended to the attachment array of the FAQ
        my @AttachmentArray;
        for my $AttachmentAttr ( @{ $Result->{Data}{_source}{Attachments} } ) {
            my %Attachment = (
                Filename => $AttachmentAttr->{filename},
                Content  => $AttachmentAttr->{attachment}{content},
            );
            push @AttachmentArray, \%Attachment;
        }

        # delete the doc in tmpattachment
        $Result = $RequesterObject->Run(
            WebserviceID => $Self->{WebserviceID},
            Invoker      => 'UtilsIngest_DELETE',
            Asynchronous => 0,
            Data         => {
                IndexName => \%IndexName,
                Request   => \%Request,
                API       => \%API,
            },
        );

        # update the CI with the extracted data
        my %Content = (
            script => {
                source => 'ctx._source.Attachments.addAll(params.new)',
                params => {
                    new => \@AttachmentArray,
                },
            },
        );

        return {
            Success => 1,
            Data    => {
                docapi => '_update',
                id     => $Param{Data}{ItemID},
                %Content,
            }
        };
    }

    if ( $Param{Data}{Event} eq 'FAQAttachmentDeletePost' ) {
        my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');

        # set parameters
        my %Request = (
            id => $Param{Data}{ItemID},
        );
        my %API = (
            docapi => '_doc',
        );
        my %IndexName = (
            index => 'faq',
        );

        # retrieve the current attachments
        my $Result = $RequesterObject->Run(
            WebserviceID => $Self->{WebserviceID},
            Invoker      => 'UtilsIngest_GET',
            Asynchronous => 0,
            Data         => {
                IndexName => \%IndexName,
                Request   => \%Request,
                API       => \%API,
            },
        );

        # prepare processed data to be appended to the attachment array of the FAQ
        my @AttachmentArray = ();
        for my $Attachment ( @{ $Result->{Data}{_source}{Attachments} } ) {

            # sort out deleted attachment
            if ( $Attachment->{Filename} ne $Param{Data}{Filename} ) {
                push @AttachmentArray, \%{$Attachment};
            }
        }

        my %Content = (
            Attachments => \@AttachmentArray,
        );

        return {
            Success => 1,
            Data    => {
                docapi => '_update',
                id     => $Param{Data}{ItemID},
                doc    => \%Content,
            }
        };
    }

    # ignore events other than FAQCreate or FAQUpdate
    if ( $Param{Data}{Event} !~ /FAQCreate|FAQUpdate/ ) {
        return {
            Success           => 1,
            StopCommunication => 1,
        };
    }

    # define the default API
    my $API = $Param{Data}{Event} eq 'FAQCreate' ? '_doc' : '_update';

    # gather all fields which have to be stored
    my $Store              = $ConfigObject->Get('Elasticsearch::FAQStoreFields');
    my $Search             = $ConfigObject->Get('Elasticsearch::FAQSearchFields');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my %DataToStore;
    for my $Field ( @{ $Store->{Basic} }, @{ $Search->{Basic} } ) {
        $DataToStore{$Field} = 1;
    }

    DYNAMICFIELD:
    for my $DynamicFieldName ( @{ $Store->{DynamicField} }, @{ $Search->{DynamicField} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicFieldName,
        );

        next DYNAMICFIELD unless $DynamicField;

        if ( $DynamicField->{ObjectType} eq 'FAQ' ) {
            $DataToStore{"DynamicField_$DynamicFieldName"} = 1;
        }
    }

    # prepare request
    my %Content;
    my $GetDynamicFields = ( IsArrayRefWithData( $Search->{DynamicField} ) || IsArrayRefWithData( $Store->{DynamicField} ) ) ? 1 : 0;
    my %FAQ              = $FAQObject->FAQGet(
        ItemID        => $Param{Data}{ItemID},
        DynamicFields => 1,
        ItemFields    => 1,
        UserID        => 1
    );

    ITEMFIELD:
    for my $ItemField (qw(Field1 Field2 Field3 Field4 Field5 Field6)) {
        next ITEMFIELD if !$FAQ{$ItemField};
        $FAQ{$ItemField} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $FAQ{$ItemField},
        );
    }

    # iterate over dynamic fields and replace value with DisplayValueRender result
    if ($GetDynamicFields) {
        DYNAMICFIELD:
        for my $DFName ( grep { $DataToStore{$_} && $_ =~ /^DynamicField_/ } keys %DataToStore ) {
            my $DFNameShort = substr $DFName, length('DynamicField_');
            my $DFConfig    = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                Name => $DFNameShort,
            );
            next DYNAMICFIELD unless IsHashRefWithData($DFConfig);
            my $DFValueStructure = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
                DynamicFieldConfig => $DFConfig,
                Value              => $FAQ{$DFName},
                HTMLOutput         => 0,
                LayoutObject       => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
            );
            $FAQ{$DFName} = $DFValueStructure->{Value};
        }
    }
    %Content = (
        ( map { $_ => $FAQ{$_} } keys %DataToStore ),
    );

    if ( $API eq '_update' ) {
        delete $Content{Attachments};

        return {
            Success => 1,
            Data    => {
                docapi => $API,
                id     => $Param{Data}{ItemID},
                doc    => \%Content,
            },
        };
    }
    else {
        $Content{Attachments} = [];

        return {
            Success => 1,
            Data    => {
                docapi => $API,
                id     => $Param{Data}{ItemID},
                %Content,
            },
        };
    }
}

=head2 HandleResponse()

handle response data of the configured remote web service.
This will just return the data that was passed to the function.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote web service
        ResponseErrorMessage => '',             # in case of web service error
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # if there was an error in the response, forward it
    if ( !$Param{ResponseSuccess} ) {
        return {
            Success      => 0,
            ErrorMessage => $Param{ResponseErrorMessage},
        };
    }

    # Per default there is no rescheduling of Elasticsearch::ConfigItemManagement requests,
    # but ErrorHandling::RequestRetry could have been configured manually, e.g. via the admin interface.
    if ( $Param{Data}{ResponseContent} && $Param{Data}{ResponseContent} =~ m{ReSchedule=1} ) {

        # ResponseContent has URI like params, convert them into a hash
        my %QueryParams = split /[&=]/, $Param{Data}{ResponseContent};

        # unescape URI strings in query parameters
        for my $Param ( sort keys %QueryParams ) {
            $QueryParams{$Param} = URI::Escape::uri_unescape( $QueryParams{$Param} );
        }

        # fix ExecutionTime param
        if ( $QueryParams{ExecutionTime} ) {
            $QueryParams{ExecutionTime} =~ s{(\d+)\+(\d+)}{$1 $2};
        }

        return {
            Success      => 0,
            ErrorMessage => 'Re-Scheduling...',
            Data         => \%QueryParams,
        };
    }

    return {
        Success => 1,
        Data    => $Param{Data},
    };
}

1;
