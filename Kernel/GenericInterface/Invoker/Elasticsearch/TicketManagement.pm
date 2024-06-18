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

package Kernel::GenericInterface::Invoker::Elasticsearch::TicketManagement;

use v5.24;
use strict;
use warnings;

# core modules
use MIME::Base64 qw(encode_base64);

# CPAN modules
use URI::Escape qw(uri_unescape);

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker::Elasticsearch::TicketManagement

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
In most cases this will set up the C<docapi> and other parameters for the Elasticsearch REST interface.
In some cases the request will be aborted by returning C<StopCommunication => 1>.
In other cases one or more different web service calls will be performed and the original request will be aborted.

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
    for my $Needed (qw/Event/) {
        if ( !$Param{Data}{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Need $Needed!",
            };
        }
    }

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # handle all events which are neither update nor creation first

    # delete the ticket
    if ( $Param{Data}{Event} eq 'TicketDelete' ) {
        my %Content = (
            query => {
                term => {
                    TicketID => $Param{Data}{TicketID},
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

    # archive flag update
    if ( $Param{Data}{Event} eq 'TicketArchiveFlagUpdate' ) {

        # delete archived tickets
        if ( $Param{Data}{ArchiveFlag} eq 'y' ) {
            my %Content = (
                query => {
                    term => {
                        TicketID => $Param{Data}{TicketID},
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

        # restore unarchived tickets
        elsif ( $Param{Data}{ArchiveFlag} eq 'n' ) {
            my $ESObject      = $Kernel::OM->Get('Kernel::System::Elasticsearch');
            my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

            # create the ticket
            $ESObject->TicketCreate(
                TicketID => $Param{Data}{TicketID},
            );

            # create the articles, when the ticket is already deleted then the article list will be empty
            my @ArticleList = $ArticleObject->ArticleList(
                TicketID => $Param{Data}{TicketID}
            );
            for my $Article (@ArticleList) {
                $ESObject->ArticleCreate(
                    TicketID  => $Param{Data}{TicketID},
                    ArticleID => $Article->{ArticleID},
                );
            }
        }

        return {
            Success           => 1,
            StopCommunication => 1,
        };
    }

    # put a single temporary attachment into a queue
    # more than one attachement could be put per call, but this would make error handling harder
    if ( $Param{Data}->{Event} eq 'PutTMPAttachment' ) {

        my $ArticleObject  = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackend = $ArticleObject->BackendForArticle(
            TicketID  => $Param{Data}->{TicketID},
            ArticleID => $Param{Data}->{ArticleID},
        );

        # Nothing to do when that article is not found.
        # This happens frequently in unit tests.
        # Use an explicit check of the type because it looks like
        # Kernel::System::Ticket::Article::Backend::Invalid::ArticleAttachment() is not implemented.
        if ( !$ArticleBackend || ref $ArticleBackend eq 'Kernel::System::Ticket::Article::Backend::Invalid' ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        my %ArticleAttachment = $ArticleBackend->ArticleAttachment(
            ArticleID => $Param{Data}->{ArticleID},
            FileID    => $Param{Data}->{AttachmentFileID},
        );

        if ( !%ArticleAttachment ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        # collect Base64 encoded attachments,
        # ignoring attachments that are too large or have unsupported format
        my $Attachment;
        ATTACHMENT:
        {
            # Ingest attachment only if filesize is less than the max size defined in sysconfig
            my $FileSize    = $ArticleAttachment{FilesizeRaw};
            my $MaxFilesize = $ConfigObject->Get('Elasticsearch::IngestMaxFilesize');

            next ATTACHMENT if $FileSize > $MaxFilesize;

            # only ingest supported file formats
            # the file format is extracted from both the content type and from the file name
            my $FileFormat        = $ConfigObject->Get('Elasticsearch::IngestAttachmentFormat');
            my %FormatIsSupported = map { $_ => 1 } $FileFormat->@*;
            my ($TypeFormat)      = $ArticleAttachment{ContentType} =~ m/^.*?\/(\w+)/;
            my $FileName          = $ArticleAttachment{Filename};
            my ($NameFormat)      = $FileName =~ m/\.(\w+)$/;
            my $Supported         = ( $TypeFormat && $FormatIsSupported{$TypeFormat} ) || ( $NameFormat && $FormatIsSupported{$NameFormat} );

            next ATTACHMENT if !$Supported;

            # the file content is expected to be Base64 encoded, without embedded newlines
            my $Encoded = encode_base64( $ArticleAttachment{Content}, '' );
            $Attachment = {
                filename => $FileName,
                data     => $Encoded,
            };
        }

        # nothing to do when the attachment should not be indexed
        if ( !defined $Attachment ) {
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
                Attachments => [$Attachment],
            },
        };
    }

    # post attachment to the ticket index
    if ( $Param{Data}->{Event} eq 'PostAttachmentContent' ) {
        return {
            Success => 1,
            Data    => {
                docapi => '_update',
                id     => $Param{Data}->{TicketID},
                $Param{Data}->{Content}->%*,
            }
        };
    }

    # queue update: if changed, we need to change the groupid of all tickets within that queue
    if ( $Param{Data}{Event} eq 'QueueUpdate' ) {

        if ( $Param{Data}{Queue}{GroupID} ne $Param{Data}{OldQueue}{GroupID} ) {
            return {
                Success => 1,
                Data    => {
                    docapi => '_update_by_query',
                    id     => '',
                    query  => {
                        term => {
                            QueueID => $Param{Data}{Queue}{QueueID},
                        },
                    },
                    script => {
                        source => "ctx._source.GroupID=params.value",
                        params => {
                            value => $Param{Data}{Queue}{GroupID},
                        },
                        lang => "painless",
                    },
                },
            };
        }

        # if the GroupID didn't change, there's nothing to do
        else {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }
    }

    # handle the regular updating and creation

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # handle excluded queues
    my $ExcludedQueues = $ConfigObject->Get('Elasticsearch::ExcludedQueues');
    if ($ExcludedQueues) {
        my %QueueIsExcluded = map { $_ => 1 } $ExcludedQueues->@*;

        my %Ticket = $TicketObject->TicketGet(
            TicketID => $Param{Data}{TicketID},
        );

        # if the ticket is not found, then it surely is not in an excluded queue
        if ( !%Ticket ) {

            # do nothing
        }

        # if the queue is changed, check if the ticket has to be created or deleted in ES
        elsif ( $Param{Data}{Event} eq 'TicketQueueUpdate' ) {

            # return if both, old and new queue are excluded
            if ( $QueueIsExcluded{ $Ticket{Queue} } && $QueueIsExcluded{ $Param{Data}{OldTicketData}{Queue} } ) {
                return {
                    Success           => 1,
                    StopCommunication => 1,
                };
            }

            # delete ticket, if moved to excluded queue
            elsif ( $QueueIsExcluded{ $Ticket{Queue} } ) {
                my %Content = (
                    query => {
                        term => {
                            TicketID => $Param{Data}{TicketID},
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

            # restore ticket, if moved from excluded queue
            elsif ( $QueueIsExcluded{ $Param{Data}{OldTicketData}{Queue} } ) {
                my $ESObject      = $Kernel::OM->Get('Kernel::System::Elasticsearch');
                my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

                # create the ticket
                $ESObject->TicketCreate(
                    TicketID => $Param{Data}{TicketID},
                );

                # create the articles, when the ticket is already deleted then the article list will be empty
                my @ArticleList = $ArticleObject->ArticleList(
                    TicketID => $Param{Data}{TicketID}
                );
                for my $Article (@ArticleList) {
                    $ESObject->ArticleCreate(
                        TicketID  => $Param{Data}{TicketID},
                        ArticleID => $Article->{ArticleID},
                    );
                }

                return {
                    Success           => 1,
                    StopCommunication => 1,
                };
            }
        }

        # in all other cases just skip tickets in excluded queues
        elsif ( $QueueIsExcluded{ $Ticket{Queue} } ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }
    }

    # gather all fields which have to be stored
    my $Store  = $ConfigObject->Get('Elasticsearch::TicketStoreFields');
    my $Search = $ConfigObject->Get('Elasticsearch::TicketSearchFields');

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my %DataToStore;
    if ( $Param{Data}{Event} =~ m/^Article/ ) {

        # standard fields
        for my $Field ( @{ $Store->{Article} }, @{ $Search->{Article} } ) {
            $DataToStore{$Field} = 1;
        }

        DYNAMICFIELD:
        for my $DynamicFieldName ( @{ $Store->{DynamicField} }, @{ $Search->{DynamicField} } ) {
            my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFieldName,
            );

            next DYNAMICFIELD unless $DynamicField;

            if ( $DynamicField->{ObjectType} eq 'Article' ) {
                $DataToStore{"DynamicField_$DynamicFieldName"} = 1;
            }
        }
    }
    else {
        # standard fields
        for my $Field ( @{ $Store->{Ticket} }, @{ $Search->{Ticket} } ) {
            $DataToStore{$Field} = 1;
        }

        DYNAMICFIELD:
        for my $DynamicFieldName ( @{ $Store->{DynamicField} }, @{ $Search->{DynamicField} } ) {
            my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFieldName,
            );

            next DYNAMICFIELD unless $DynamicField;

            if ( $DynamicField->{ObjectType} eq 'Ticket' ) {
                $DataToStore{"DynamicField_$DynamicFieldName"} = 1;
            }
        }

        # age is calculated from created dynamically in Kernel/System/Elasticsearch.pm if needed
        if ( $DataToStore{Age} ) {
            $DataToStore{Created} = 1;
            delete $DataToStore{Age};
        }
    }

    # prepare request
    my %Content;
    my $API;

    # ticket create
    if ( $Param{Data}{Event} eq 'TicketCreate' ) {

        # get the ticket
        my $GetDynamicFields = ( IsArrayRefWithData( $Search->{DynamicField} ) || IsArrayRefWithData( $Store->{DynamicField} ) ) ? 1 : 0;
        my %Ticket           = $TicketObject->TicketGet(
            TicketID      => $Param{Data}{TicketID},
            DynamicFields => $GetDynamicFields,
        );

        # Nothing to do when the newly created ticket is already gone.
        # This happens frequently in unit tests.
        if ( !%Ticket ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        # iterate over dynamic fields and replace value with DisplayValueRender result
        if ($GetDynamicFields) {
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
            DYNAMICFIELD:
            for my $DFName ( grep { $DataToStore{$_} && $_ =~ /^DynamicField_/ } keys %DataToStore ) {
                my $DFNameShort = substr $DFName, length('DynamicField_');
                my $DFConfig    = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                    Name => $DFNameShort,
                );
                next DYNAMICFIELD unless IsHashRefWithData($DFConfig);
                my $DFValueStructure = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
                    DynamicFieldConfig => $DFConfig,
                    Value              => $Ticket{$DFName},
                    HTMLOutput         => 0,
                    LayoutObject       => $LayoutObject,
                );
                $Ticket{$DFName} = $DFValueStructure->{Value};
            }
        }

        # set content
        %Content = map { $_ => $Ticket{$_} } keys %DataToStore;

        # initialize article array
        $Content{ArticlesExternal}    = [];
        $Content{ArticlesInternal}    = [];
        $Content{AttachmentsExternal} = [];
        $Content{AttachmentsInternal} = [];

        # store time as seconds to epoch
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Content{Created},
            }
        );
        $Content{Created} = $DateTimeObject->ToEpoch();

        $API = '_doc';
    }

    # article create
    elsif ( $Param{Data}{Event} eq 'ArticleCreate' ) {

        # get the article
        my $GetDynamicFields = ( IsArrayRefWithData( $Search->{DynamicField} ) || IsArrayRefWithData( $Store->{DynamicField} ) ) ? 1 : 0;
        my $ArticleObject    = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackend   = $ArticleObject->BackendForArticle(
            TicketID  => $Param{Data}{TicketID},
            ArticleID => $Param{Data}{ArticleID},
        );

        # Nothing to do when the newly created article is not found.
        # This happens frequently in unit tests.
        # Use an explicit check of the type because it looks like
        # Kernel::System::Ticket::Article::Backend::Invalid::ArticleGet() returns a hash with the key SenderType
        if ( !$ArticleBackend || ref $ArticleBackend eq 'Kernel::System::Ticket::Article::Backend::Invalid' ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        my %Article = $ArticleBackend->ArticleGet(
            TicketID      => $Param{Data}{TicketID},
            ArticleID     => $Param{Data}{ArticleID},
            DynamicFields => $GetDynamicFields,
        );

        # iterate over dynamic fields and replace value with DisplayValueRender result
        if ($GetDynamicFields) {
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
            DYNAMICFIELD:
            for my $DFName ( grep { $DataToStore{$_} && $_ =~ /^DynamicField_/ } keys %DataToStore ) {
                my $DFNameShort = substr $DFName, length('DynamicField_');
                my $DFConfig    = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                    Name => $DFNameShort,
                );
                next DYNAMICFIELD unless IsHashRefWithData($DFConfig);
                my $DFValueStructure = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
                    DynamicFieldConfig => $DFConfig,
                    Value              => $Article{$DFName},
                    HTMLOutput         => 0,
                    LayoutObject       => $LayoutObject,
                );
                $Article{$DFName} = $DFValueStructure->{Value};
            }
        }

        my %ArticleContent = map { $_ => $Article{$_} } keys %DataToStore;
        my $Destination    = $Article{IsVisibleForCustomer} ? 'External' : 'Internal';

        # get a list of attachments
        my %AttachmentIndex = $ArticleBackend->ArticleAttachmentIndex(
            ArticleID       => $Param{Data}->{ArticleID},
            ExcludeHTMLBody => 1,
        );
        if (%AttachmentIndex) {

            my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
            my %API             = (
                docapi => '_doc',
            );
            my %IndexName = (
                index => 'tmpattachments',
            );

            # post the attachments to the index tmpattachments, processing them with the pipeline Attachments
            my @PlainTextArray;
            ATTACHMENT_FILE_ID:
            for my $AttachmentFileID ( sort keys %AttachmentIndex ) {

                # put attachment into the index tmpattachments and ingest it into tmpattachment
                my $IngestResult = $RequesterObject->Run(
                    WebserviceID => $Self->{WebserviceID},
                    Invoker      => 'TicketIngestAttachment',
                    Asynchronous => 0,
                    Data         => {
                        Event            => 'PutTMPAttachment',
                        TicketID         => $Param{Data}->{TicketID},
                        ArticleID        => $Param{Data}->{ArticleID},
                        Destination      => $Destination,
                        AttachmentFileID => $AttachmentFileID,
                    },
                );

                # proceed only when the attachment was ingested
                next ATTACHMENT_FILE_ID unless $IngestResult;
                next ATTACHMENT_FILE_ID unless $IngestResult->{Data};
                next ATTACHMENT_FILE_ID unless $IngestResult->{Data}->{_id};

                # get the ingested attachment with the plain text content
                my %Request = (
                    id => $IngestResult->{Data}->{_id},
                );
                my $IngestGetResult = $RequesterObject->Run(
                    WebserviceID => $Self->{WebserviceID},
                    Invoker      => 'UtilsIngest_GET',
                    Asynchronous => 0,
                    Data         => {
                        IndexName => \%IndexName,
                        Request   => \%Request,
                        API       => \%API,
                    },
                );

                # collect the filename and the extracted plain text, actually only one attachment
                for my $Attachment ( $IngestGetResult->{Data}->{_source}->{Attachments}->@* ) {
                    push @PlainTextArray, {
                        Filename => $Attachment->{filename},
                        Content  => $Attachment->{attachment}->{content},
                    };
                }

                # delete the attachment in the tmpattachment index
                my $IndexDeleteResult = $RequesterObject->Run(
                    WebserviceID => $Self->{WebserviceID},
                    Invoker      => 'UtilsIngest_DELETE',
                    Asynchronous => 0,
                    Data         => {
                        IndexName => \%IndexName,
                        Request   => \%Request,
                        API       => \%API,
                    },
                );
            }

            # post filename and plain text of the attachments into the ticket
            if (@PlainTextArray) {
                my $PostAttachmentResult = $RequesterObject->Run(
                    WebserviceID => $Self->{WebserviceID},
                    Invoker      => 'TicketManagement',
                    Asynchronous => 0,
                    Data         => {
                        Event    => 'PostAttachmentContent',
                        TicketID => $Param{Data}->{TicketID},
                        Content  => {
                            script => {
                                source => 'ctx._source.Attachments' . $Destination . '.addAll(params.new)',
                                params => {
                                    new => \@PlainTextArray,
                                },
                            },
                        },
                    },
                );
            }
        }

        # set up request for the non-attachment attributes
        %Content = (
            script => {
                source => 'ctx._source.Articles' . $Destination . '.addAll(params.new)',
                params => {
                    new => [ \%ArticleContent ],
                },
            },
        );

        $API = '_update';
    }

    # at ticket creation customerupdate is sent before ticketcreate and is not needed here
    elsif ( $Param{Data}->{Event} eq 'TicketCustomerUpdate' && $Param{Data}->{TicketCreated} == 1 ) {
        return {
            Success           => 1,
            StopCommunication => 1,
        };
    }

    # diverse updates
    else {
        # get the ticket
        my $GetDynamicFields = ( IsArrayRefWithData( $Search->{DynamicField} ) || IsArrayRefWithData( $Store->{DynamicField} ) ) ? 1 : 0;
        my %Ticket           = $TicketObject->TicketGet(
            TicketID      => $Param{Data}->{TicketID},
            DynamicFields => $GetDynamicFields,
        );

        # Nothing to do when the updated ticket is gone.
        # This might happen in unit tests.
        if ( !%Ticket ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        # iterate over dynamic fields and replace value with DisplayValueRender result
        if ($GetDynamicFields) {
            my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
            DYNAMICFIELD:
            for my $DFName ( grep { $DataToStore{$_} && $_ =~ /^DynamicField_/ } keys %DataToStore ) {
                my $DFNameShort = substr $DFName, length('DynamicField_');
                my $DFConfig    = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                    Name => $DFNameShort,
                );
                next DYNAMICFIELD unless IsHashRefWithData($DFConfig);
                my $DFValueStructure = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
                    DynamicFieldConfig => $DFConfig,
                    Value              => $Ticket{$DFName},
                    HTMLOutput         => 0,
                    LayoutObject       => $LayoutObject,
                );
                $Ticket{$DFName} = $DFValueStructure->{Value};
            }
        }

        # only submit potentially changed values
        delete $DataToStore{Created};
        delete $DataToStore{TicketNumber};

        %Content = (
            doc => { map { $_ => $Ticket{$_} } keys %DataToStore },
        );
        $API = '_update';
    }

    return {
        Success => 1,
        Data    => {
            docapi => $API,
            id     => $Param{Data}{TicketID},
            %Content,
        },
    };
}

=head2 AssessResponse()

In most cases the transport object assesses the validity of the request result. When the transport finds that the response indicates an error,
then error logging and handling kicks in. But at least for Elasticsearch support it is useful to have a function that provides custom
rules for inspecting the request result. It can find that responses with specific content are valid even though e.g. the HTTP status indicates
an error.

This function should be used with care. Actual actions should be implemented in C<HandleResponse()>.

=cut

sub AssessResponse {
    my ( $Self, %Param ) = @_;

    my ( $RestClient, $RestCommand, $Controller, $ErrorMessage ) = @Param{qw(RestClient RestCommand Controller ErrorMessage)};

    # Elasticsearch::Ticketmanagement specific assessment is only possible
    # when the response content is a valid JSON string, representing an object.
    my $JSONObject      = $Kernel::OM->Get('Kernel::System::JSON');
    my $ResponseContent = $RestClient->responseContent;
    my $Result          = $JSONObject->Decode(
        Data => $ResponseContent,
    );
    if ( defined $Result && ref $Result eq 'HASH' ) {

        # A common error is that an attribute of an ticket has changed,
        # but the ticket itself is not indexed.
        # This case will be handled in HandleResponse().
        if (
            $Result->{error}
            && $Result->{error}->{type} eq 'document_missing_exception'
            )
        {
            $Self->{DebuggerObject}->Info(
                Summary => $ErrorMessage,
                Data    => "The indexed ticket is missing. The ticket will be reindexed."
            );

            return;    # disable error handling
        }

        # Another error that is to be expected are encrypted documents, e.g. encrypted PDFs.
        # It is OK when these documents are not searchable.
        if (
            $Result->{error}
            && $Result->{error}->{type} eq 'parse_exception'
            && $Result->{error}->{caused_by}
            && $Result->{error}->{caused_by}->{type}
            && $Result->{error}->{caused_by}->{type} eq 'encrypted_document_exception'
            )
        {
            $Self->{DebuggerObject}->Info(
                Summary => $ErrorMessage,
                Data    => "The indexed document is encrypted and will therefore not be indexed."
            );

            return;    # disable error handling
        }

    }

    # Fall back to basically the same error assessment as in the HTTP::REST transport object
    my $ResponseCode = $RestClient->responseCode;
    my $ResponseError;
    if ( !IsStringWithData($ResponseCode) ) {
        $ResponseError = $ErrorMessage;
    }

    if ( $ResponseCode !~ m{ \A 20 \d \z }xms ) {
        $ResponseError = $ErrorMessage . " Response code '$ResponseCode'.";
    }

    if ( $ResponseCode ne '204' && !IsStringWithData($ResponseContent) ) {
        $ResponseError .= ' No content provided.';
    }

    return $ResponseError;
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

    # Per default there is no rescheduling of Elasticsearch::TicketManagement requests,
    # but ErrorHandling::RequestRetry could have been configured manually, e.g. via the admin interface.
    if ( $Param{Data}->{ResponseContent} && $Param{Data}->{ResponseContent} =~ m{ReSchedule=1} ) {

        # ResponseContent has URI like params, convert them into a hash
        my %QueryParams = split /[&=]/, $Param{Data}->{ResponseContent};

        # unescape URI strings in query parameters
        for my $Param ( sort keys %QueryParams ) {
            $QueryParams{$Param} = uri_unescape( $QueryParams{$Param} );
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

    # Special handling for Elasticsearch::TicketManagement:
    # Reindex a ticket when it isn't available in Elasticsearch as a side effect.
    # Example:
    #     {"error":{"root_cause":[{"type":"document_missing_exception",\
    #     "reason":"[_doc][5]: document missing","index_uuid":"rH43T-SsTz-H_k8aFg13dQ","shard":"0","index":"ticket"}],\
    #     "type":"document_missing_exception",\
    #     "reason":"[_doc][5]: document missing","index_uuid":"rH43T-SsTz-H_k8aFg13dQ","shard":"0","index":"ticket"},"status":404}
    if ( $Param{Data}->{error} && $Param{Data}->{error}->{type} eq 'document_missing_exception' ) {
        my $ESObject      = $Kernel::OM->Get('Kernel::System::Elasticsearch');
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        # create the ticket
        my ($TicketID) = $Param{Data}->{error}->{reason} =~ m/ \Q[_doc][\E (\d+) \Q]:\E \s /x;    # e.g. "[_doc][5]: "
        my $Errors = 0;
        if ( !$ESObject->TicketCreate( TicketID => $TicketID ) ) {
            $Errors++;
        }

        # create the articles
        my @ArticleList = $ArticleObject->ArticleList( TicketID => $TicketID );
        for my $Article (@ArticleList) {
            my $Success = $ESObject->ArticleCreate(
                TicketID  => $TicketID,
                ArticleID => $Article->{ArticleID},
            );
            $Errors++ if !$Success;
        }

        # ignoring errors
    }

    return {
        Success => 1,
        Data    => $Param{Data},
    };
}

1;
