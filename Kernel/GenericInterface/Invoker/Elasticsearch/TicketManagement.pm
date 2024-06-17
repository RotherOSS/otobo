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

use strict;
use warnings;

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

    # put a temporary attachment
    if ( $Param{Data}{Event} eq 'PutTMPAttachment' ) {

        # get file format to be ingested
        my $FileFormat = $ConfigObject->Get('Elasticsearch::IngestAttachmentFormat');
        my %FormatHash = map { $_ => 1 } @{$FileFormat};

        my $MaxFilesize    = $ConfigObject->Get('Elasticsearch::IngestMaxFilesize');
        my $ArticleObject  = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackend = $ArticleObject->BackendForArticle(
            TicketID  => $Param{Data}{TicketID},
            ArticleID => $Param{Data}{ArticleID},
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

        my @Attachments;
        ATTACHMENT:
        for my $AttachmentIndex ( sort keys %{ $Param{Data}{AttachmentIndex} } ) {
            my %ArticleAttachment = $ArticleBackend->ArticleAttachment(
                ArticleID => $Param{Data}{ArticleID},
                FileID    => $AttachmentIndex,
            );

            next ATTACHMENT if !%ArticleAttachment;

            use MIME::Base64;
            use Encode qw(encode);
            my $FileName = $ArticleAttachment{Filename};
            my $FileType = $ArticleAttachment{ContentType};
            my $FileSize = $ArticleAttachment{FilesizeRaw};

            # Ingest attachment if only filesize less than defined in sysconfig
            next ATTACHMENT if $FileSize > $MaxFilesize;

            $FileType =~ /^.*?\/([\d\w]+)/;
            my $TypeFormat = $1;
            $FileName =~ /\.([\d\w]+)$/;
            my $NameFormat = $1;

            if ( $FormatHash{$TypeFormat} || $FormatHash{$NameFormat} ) {
                my $Encoded = encode_base64( $ArticleAttachment{Content} );
                $Encoded =~ s/\n//g;
                my %Data;
                $Data{filename} = $FileName;
                $Data{data}     = $Encoded;
                push( @Attachments, \%Data );
            }
        }

        return {
            Success => 1,
            Data    => {
                docapi      => '_doc',
                path        => 'Attachments',
                id          => '',
                Attachments => \@Attachments,
            },
        };
    }

    # post attachment to the ticket index
    if ( $Param{Data}{Event} eq 'PostAttachmentContent' ) {
        return {
            Success => 1,
            Data    => {
                docapi => '_update',
                id     => $Param{Data}{TicketID},
                %{ $Param{Data}{Content} },
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

        my %ArticleContent = map { $_ => $Article{$_} } keys %DataToStore;
        my $Destination    = $Article{IsVisibleForCustomer} ? 'External' : 'Internal';

        # put attachment and ingest it into tmpattachment
        my %AttachmentIndex = $ArticleBackend->ArticleAttachmentIndex(
            ArticleID       => $Param{Data}{ArticleID},
            ExcludeHTMLBody => 1,
        );
        my @AttachmentArray;
        if (%AttachmentIndex) {
            my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
            my $Result          = $RequesterObject->Run(
                WebserviceID => $Self->{WebserviceID},
                Invoker      => 'TicketIngestAttachment',
                Asynchronous => 0,
                Data         => {
                    Event           => 'PutTMPAttachment',
                    TicketID        => $Param{Data}{TicketID},
                    ArticleID       => $Param{Data}{ArticleID},
                    Destination     => $Destination,
                    AttachmentIndex => \%AttachmentIndex,
                },
            );

            # get the ingested attachment from tmpattachment and put its content and filename into articlesr
            my %Request = (
                id => $Result->{Data}->{_id},
            );
            my %API = (
                docapi => '_doc',
            );
            my %IndexName = (
                index => 'tmpattachments',
            );

            # get the ingested attachment
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

            for my $AttachmentAttr ( @{ $Result->{Data}->{_source}->{Attachments} } ) {
                my %Attachment = (
                    Filename => $AttachmentAttr->{filename},
                    Content  => $AttachmentAttr->{attachment}->{content},
                );
                push @AttachmentArray, \%Attachment;
            }

            %Content = (
                script => {
                    source => 'ctx._source.Attachments' . $Destination . '.addAll(params.new)',
                    params => {
                        new => \@AttachmentArray,
                    },
                },
            );

            # post into ticket
            $Result = $RequesterObject->Run(
                WebserviceID => $Self->{WebserviceID},
                Invoker      => 'TicketManagement',
                Asynchronous => 0,
                Data         => {
                    Event    => 'PostAttachmentContent',
                    TicketID => $Param{Data}{TicketID},
                    Content  => \%Content,
                },
            );

            # finally delete the tmpattachment index
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
        }

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
    elsif ( $Param{Data}{Event} eq 'TicketCustomerUpdate' && $Param{Data}{TicketCreated} == 1 ) {
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
            TicketID      => $Param{Data}{TicketID},
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

    if ( $Param{Data}->{ResponseContent} && $Param{Data}->{ResponseContent} =~ m{ReSchedule=1} ) {

        # ResponseContent has URI like params, convert them into a hash
        my %QueryParams = split /[&=]/, $Param{Data}->{ResponseContent};

        # unscape URI strings in query parameters
        for my $Param ( sort keys %QueryParams ) {
            $QueryParams{$Param} = URI::Escape::uri_unescape( $QueryParams{$Param} );
        }

        # fix ExecutrionTime param
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
