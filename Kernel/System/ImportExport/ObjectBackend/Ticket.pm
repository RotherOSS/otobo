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

package Kernel::System::ImportExport::ObjectBackend::Ticket;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use Encode;
use MIME::Base64 qw(encode_base64 decode_base64);

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::ImportExport',
    'Kernel::System::LinkObject',
    'Kernel::System::Lock',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::SLA',
    'Kernel::System::Service',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Type',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::ImportExport::ObjectBackend::Ticket - import/export backend for tickets

=head1 DESCRIPTION

All functions to import and export tickets.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $BackendObject = $Kernel::OM->Get('Kernel::System::ImportExport::ObjectBackend::Ticket');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Changing the config
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Fiddling with SysConfig in the constructor is a bit hackish.
    # It should be fine as the ImportExport object is only used in console commands
    # and in a single frontend module. The changed config object in the frontend module
    # is fine as the config object is recreated for each request.
    $ConfigObject->Set(
        Key   => 'SendmailModule',
        Value => 'Kernel::System::Email::DoNotSendEmail',
    );
    $ConfigObject->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    # turn off some event handlers
    $ConfigObject->Set(
        Key   => 'Ticket::EventModulePost###950-TicketAppointments',
        Value => undef,
    );
    $ConfigObject->Set(
        Key   => 'Ticket::EventModulePost###8000-GenericInterface',
        Value => undef,
    );

    # allocate new hash for object
    return bless {
        TicketIDRelation       => {},
        TicketNumberIDRelation => {},
        AllFoundTicketIDs      => undef,    # will be initialized in first call to ExportDataGet()
        LastHandledIndex       => -1,       # used for chunking
        ChunkingFinished       =>  0,       # indicate that chunking is finished
    }, $Type;
}

=head2 ObjectAttributesGet()

get the object attributes of an object as a ref to an array of hash references

    my $Attributes = $ObjectBackend->ObjectAttributesGet(
        UserID => 1,
    );

=cut

sub ObjectAttributesGet {
    my ( $Self, %Param ) = @_;

    # check needed object
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return;
    }

    my %StateList = $Kernel::OM->Get('Kernel::System::State')->StateList(
        UserID => 1,
    );
    my %PriorityList = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
        Valid => 1,
    );
    my %LockList = $Kernel::OM->Get('Kernel::System::Lock')->LockList(
        UserID => 1,
    );
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my @Attributes;    # will be returned

    # queue
    {
        my %QueueList = $Kernel::OM->Get('Kernel::System::Queue')->QueueList;
        push @Attributes,
            {
                Key   => 'QueueID',
                Name  => 'Default Queue',
                Input => {
                    Type        => 'Selection',
                    Data        => \%QueueList,
                    Required    => 1,
                    Translation => 0,
                    Class       => 'Modernize',
                },
            };
    }

    if ( $ConfigObject->Get('Ticket::Type') ) {
        my %TypeList = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
            Valid => 1,
        );

        push @Attributes, {
            Key   => 'TypeID',
            Name  => 'Default Type',
            Input => {
                Type        => 'Selection',
                Data        => \%TypeList || {},
                Required    => 1,
                Translation => 1,
                Class       => 'Modernize',
            },
        };
    }

    if ( $ConfigObject->Get('Ticket::Service') ) {
        my %ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            UserID => 1,
        );

        push @Attributes, {
            Key   => 'ServiceID',
            Name  => 'Default Service',
            Input => {
                Type         => 'Selection',
                Data         => \%ServiceList || {},
                Required     => 0,
                Translation  => 0,
                PossibleNone => 1,
                Class        => 'Modernize',
            },
        };

        my %SLAList = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            UserID => 1,
        );

        push @Attributes, {
            Key   => 'SLAID',
            Name  => 'Default SLA',
            Input => {
                Type         => 'Selection',
                Data         => \%SLAList || {},
                Required     => 0,
                Translation  => 0,
                PossibleNone => 1,
                Class        => 'Modernize',
            },
        };
    }

    push @Attributes,
        {
            Key   => 'StateID',
            Name  => 'Default state',
            Input => {
                Type        => 'Selection',
                Data        => \%StateList,
                Required    => 1,
                Translation => 1,
                Class       => 'Modernize',
            },
        },
        {
            Key   => 'PriorityID',
            Name  => 'Default priority',
            Input => {
                Type        => 'Selection',
                Data        => \%PriorityList,
                Required    => 1,
                Translation => 1,
                Class       => 'Modernize',
            },
        },
        {
            Key   => 'OwnerID',
            Name  => 'Default owner',
            Input => {
                Type        => 'Selection',
                Data        => \%UserList,
                Required    => 1,
                Translation => 0,
                Class       => 'Modernize',
            },
        };

    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        push @Attributes,
            {
                Key   => 'ResponsibleID',
                Name  => 'Default responsible',
                Input => {
                    Type         => 'Selection',
                    Data         => \%UserList,
                    Required     => 0,
                    PossibleNone => 1,
                    Translation  => 0,
                    Class        => 'Modernize',
                },
            };
    }

    push @Attributes,
        {
            Key   => 'LockID',
            Name  => 'Default lock',
            Input => {
                Type        => 'Selection',
                Data        => \%LockList,
                Required    => 1,
                Translation => 1,
                Class       => 'Modernize',
            },
        },
        {
            Key   => 'CustomerID',
            Name  => 'Default CustomerID',
            Input => {
                Type      => 'Text',
                Required  => 0,
                Size      => 50,
                MaxLength => 250,
            },
        },
        {
            Key   => 'CustomerUserID',
            Name  => 'Default CustomerUserID',
            Input => {
                Type      => 'Text',
                Required  => 0,
                Size      => 50,
                MaxLength => 250,
            },
        },
        {
            Key   => 'ArchiveFlag',
            Name  => 'Default ArchiveFlag',
            Input => {
                Type         => 'Selection',
                Data         => { map { $_ => $_ } qw( y n ) },
                Required     => 1,
                Translation  => 0,
                Class        => 'Modernize',
                ValueDefault => 'n',
            },
        },
        {
            Key   => 'Subject',
            Name  => 'Default subject',
            Input => {
                Type         => 'Text',
                Required     => 0,
                Size         => 50,
                MaxLength    => 250,
                ValueDefault => $ConfigObject->Get('TicketImport::DefaultSubject'),
            },
        },
        {
            Key   => 'Body',
            Name  => 'Default body',
            Input => {
                Type         => 'Text',
                Required     => 0,
                Size         => 50,
                MaxLength    => 250,
                ValueDefault => $ConfigObject->Get('TicketImport::DefaultBody'),
            },
        },
        {
            Key   => 'SenderType',
            Name  => 'Default sender type',
            Input => {
                Type => 'Selection',
                Data => {
                    agent    => 'agent',
                    customer => 'customer',
                },
                Required => 1,
                Class    => 'Modernize',
            },
        },
        {
            Key   => 'IsVisibleToCustomer',
            Name  => 'Default is visible to customer',
            Input => {
                Type => 'Checkbox',
            },
        },
        {
            Key   => 'EmptyFieldsLeaveTheOldValues',
            Name  => 'Empty fields indicate that the current values are kept',
            Input => {
                Type => 'Checkbox',
            },
        },
        {
            Key   => 'AllowedOwnerInTarget',
            Name  => 'Only update tickets of this user in the target system',
            Input => {
                Type      => 'Text',
                Required  => 0,
                Size      => 50,
                MaxLength => 191,      # length of users.login field in the database
            },
        };

    # article related options
    push @Attributes,
        {
            Key   => 'IncludeArticles',
            Name  => 'Import/Export articles',
            Input => {
                Type => 'Checkbox',
            },
        },
        {
            Key   => 'ArticleBackend',
            Name  => 'Default Backend',
            Input => {
                Type         => 'Selection',
                Data         => { map { $_ => $_ } qw( Email Phone Internal ) },
                Required     => 1,
                Translation  => 0,
                Class        => 'Modernize',
                ValueDefault => 'n',
            },
        },
        {
            Key   => 'ArticleSeparateLines',
            Name  => 'Store articles on separate lines indicated by a blank first entry',
            Input => {
                Type => 'Checkbox',
            },
        },
        {
            Key   => 'IncludeAttachments',
            Name  => 'Import/Export attachments (as the last entries per line)',
            Input => {
                Type => 'Checkbox',
            },
        };

    return \@Attributes;
}

=head2 MappingObjectAttributesGet()

gets the mapping attributes of an object as reference to an array of hash references.

    my $Attributes = $ObjectBackend->MappingObjectAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

Returns:

    # TODO
    my $Attributes = [
        {
            Input => {
                Data => [
                    [...]
                ],
            },
        },
    ];

=cut

sub MappingObjectAttributesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

    # get object data
    my $ObjectData = $ImportExportObject->ObjectDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return [] unless $ObjectData;
    return [] unless ref $ObjectData eq 'HASH';

    # the possible mappings depend on the activated feature set
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my @TypeElements        = $ConfigObject->Get('Ticket::Type')        ? qw( Type TypeID )                 : ();
    my @ServiceElements     = $ConfigObject->Get('Ticket::Service')     ? qw( Service ServiceID SLA SLAID ) : ();
    my @ResponsibleElements = $ConfigObject->Get('Ticket::Responsible') ? qw( Responsible ResponsibleID )   : ();
    my @ElementList =
        map { { Key => $_, Value => $_ } }
        (
            qw( TicketID TicketNumber Title ),
            @TypeElements,
            qw( Queue QueueID ),
            @ServiceElements,
            qw( StateID Priority PriorityID CustomerID CustomerUserID Owner OwnerID Lock LockID ),
            @ResponsibleElements,
            qw( ArchiveFlag Created )
        );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # columns for dynamic fields
    {
        my $DynFieldList = $DynamicFieldObject->DynamicFieldList(
            ObjectType => 'Ticket',
            ResultType => 'HASH',
        );
        push @ElementList,
            map { { Key => "DynamicField_$_", Value => "DynamicField_$_" } }
            sort
            values $DynFieldList->%*;
    }

    if ( $ObjectData->{IncludeArticles} ) {
        if ( $ObjectData->{ArticleSeparateLines} ) {
            push @ElementList, {
                Key   => 'Article_TicketID',
                Value => 'Article_TicketID',
            };
        }

        # columns for articles
        push @ElementList, map { { Key => "Article_$_", Value => "Article_$_" } }
            qw( ArticleID ArticleBackend From To Cc Bcc Subject Body SenderType IsVisibleForCustomer
            MessageID ReplyTo InReplyTo References Charset MimeType PlainEmail CreateTime );

        # columns for article dynamic fields
        my $DynFieldList = $DynamicFieldObject->DynamicFieldList(
            ObjectType => 'Article',
            ResultType => 'HASH',
        );
        push @ElementList,
            map { { Key => "Article_DynamicField_$_", Value => "Article_DynamicField_$_" } }
            sort
            values $DynFieldList->%*;
    }

    return [
        {
            Key   => 'Key',
            Name  => Translatable('Key'),
            Input => {
                Type         => 'Selection',
                Data         => \@ElementList,
                Required     => 1,
                Translation  => 0,
                PossibleNone => 1,
                Class        => 'Modernize',
            },
        },
        {
            Key   => 'Identifier',
            Name  => Translatable('Identifier'),
            Input => {
                Type => 'Checkbox',
            },
        },
    ];
}

=head2 SearchAttributesGet()

get the search object attributes of an object as array/hash reference

    my $AttributeList = $ObjectBackend->SearchAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );


=cut

sub SearchAttributesGet {
    my ( $Self, %Param ) = @_;

    #  note that there is no search by owner or responsible

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # TODO: why is the ObjectData needed here?
    # get object data
    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');
    my $ObjectData         = $ImportExportObject->ObjectDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return [] unless $ObjectData;
    return [] unless ref $ObjectData eq 'HASH';

    my %QueueList = $Kernel::OM->Get('Kernel::System::Queue')->QueueList();

    my %StateList = $Kernel::OM->Get('Kernel::System::State')->StateList(
        UserID => 1,
    );

    my %PriorityList = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
        Valid => 1,
    );

    my @Attributes = (
        {
            Key   => 'QueueIDs',
            Name  => 'Queue',
            Input => {
                Type         => 'Selection',
                Data         => \%QueueList,
                Required     => 0,
                Translation  => 0,
                PossibleNone => 1,
                Size         => 5,
                Multiple     => 1,
                Class        => 'Modernize',
            },
        },
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $ConfigObject->Get('Ticket::Type') ) {
        my %TypeList = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
            Valid => 1,
        );

        push @Attributes, {
            Key   => 'TypeIDs',
            Name  => 'Type',
            Input => {
                Type         => 'Selection',
                Data         => \%TypeList || {},
                Required     => 0,
                Translation  => 1,
                PossibleNone => 1,
                Size         => 5,
                Multiple     => 1,
                Class        => 'Modernize',
            },
        };
    }

    if ( $ConfigObject->Get('Ticket::Service') ) {
        my %ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            UserID => 1,
        );

        push @Attributes, {
            Key   => 'ServiceIDs',
            Name  => 'Service',
            Input => {
                Type         => 'Selection',
                Data         => \%ServiceList || {},
                Required     => 0,
                Translation  => 0,
                PossibleNone => 1,
                Size         => 5,
                Multiple     => 1,
                Class        => 'Modernize',
            },
        };

        my %SLAList = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            UserID => 1,
        );

        push @Attributes, {
            Key   => 'SLAIDs',
            Name  => 'SLA',
            Input => {
                Type         => 'Selection',
                Data         => \%SLAList || {},
                Required     => 0,
                Translation  => 0,
                PossibleNone => 1,
                Size         => 5,
                Multiple     => 1,
                Class        => 'Modernize',
            },
        };
    }

    push @Attributes,
        {
            Key   => 'StateIDs',
            Name  => 'State',
            Input => {
                Type         => 'Selection',
                Data         => \%StateList,
                Required     => 0,
                PossibleNone => 1,
                Translation  => 1,
                Size         => 5,
                Multiple     => 1,
                Class        => 'Modernize',
            },
        },
        {
            Key   => 'PriorityIDs',
            Name  => 'Priority',
            Input => {
                Type         => 'Selection',
                Data         => \%PriorityList,
                Required     => 0,
                PossibleNone => 1,
                Translation  => 1,
                Size         => 5,
                Multiple     => 1,
                Class        => 'Modernize',
            },
        },
        {
            Key   => 'CustomerID',
            Name  => 'CustomerID',
            Input => {
                Type      => 'Text',
                Size      => 50,
                MaxLength => 250,
            },
        };

    # Filter by create or change time, specify in minutes
    {
        my @KeyAndNames = (
            [ TicketCreateTimeNewerMinutes => 'Ticket Create Time (newer) [min]' ],
            [ TicketCreateTimeOlderMinutes => 'Ticket Create Time (older) [min]' ],
            [ TicketChangeTimeNewerMinutes => 'Ticket Change Time (newer) [min]' ],
            [ TicketChangeTimeOlderMinutes => 'Ticket Change Time (older) [min]' ],
        );
        for my $ArrRef (@KeyAndNames) {
            my ( $Key, $Name ) = $ArrRef->@*;
            push @Attributes,
                {
                    Key   => $Key,
                    Name  => $Name,
                    Input => {
                        Type      => 'Text',
                        Size      => 50,
                        MaxLength => 50,
                    },
                },
                ;
        }
    }

    # Filter by create or change time, specify by date and time
    {
        my @KeyAndNames = (
            [ TicketCreateTimeNewerDate     => 'Ticket Create Time (after)' ],
            [ TicketCreateTimeOlderDate     => 'Ticket Create Time (before)' ],
            [ TicketLastChangeTimeNewerDate => 'Ticket Last Change Time (after)' ],
            [ TicketLastChangeTimeOlderDate => 'Ticket Last Change Time (before)' ],
        );
        for my $ArrRef (@KeyAndNames) {
            my ( $Key, $Name ) = $ArrRef->@*;
            push @Attributes,
                {
                    Key   => $Key,
                    Name  => $Name,
                    Input => {
                        Type     => 'DateTime',
                        Optional => 1,
                    },
                },
                ;
        }
    }

    return \@Attributes;
}

=head2 ExportDataGet()

get export data as a reference to an array for array references, that is a C<2D-table>

    my $Rows = $ObjectBackend->ExportDataGet(
        TemplateID => 123,
        UserID     => 1,
    );

When the parameter C<ChunkSize> is passed then chunked export mode is assumed.
On the first invocation the complete search result list is retrieved
and stored in the instance. Then the detailed data for first chunk is returned.
Each subsequent invocation only gets the detailed data for the next chunk.

=cut

sub ExportDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

    # get object data
    my $ObjectData = $ImportExportObject->ObjectDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check object data
    if ( !$ObjectData || ref $ObjectData ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No object data found for the template id $Param{TemplateID}",
        );

        return;
    }

    # get the mapping list
    my $MappingList = $ImportExportObject->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check the mapping list
    if ( !$MappingList || ref $MappingList ne 'ARRAY' || !@{$MappingList} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No valid mapping list found for the template id $Param{TemplateID}",
        );
        return;
    }

    # create the mapping object list
    my @MappingObjectList;
    for my $MappingID ( @{$MappingList} ) {

        # get mapping object data
        my $MappingObjectData = $ImportExportObject->MappingObjectDataGet(
            MappingID => $MappingID,
            UserID    => $Param{UserID},
        );

        # check mapping object data
        if ( !$MappingObjectData || ref $MappingObjectData ne 'HASH' ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "No valid mapping list found for the template id $Param{TemplateID}",
            );

            return;
        }

        push @MappingObjectList, $MappingObjectData;
    }

    # List of IDs for tickets that are to be exported.
    # In chunked mode this is only chunk. In non-chunked mode these are all relevant IDs.
    my @TicketIDs;
    {
        # Search all Ticket_IDs.
        # When in chunked mode then get the complete list in the first invocation and store it as instance data.
        # For simplicities sake assume that the template ID does not change in subsequent calls.
        #
        # TicketSearch() has a default limit of 10_000. This is fine in a webapp but not for a complete export.
        # As a workaround set the limit to a large number like one billion.
        my %TicketSearchParam = (
            Limit      => 1_000_000_000,
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );
        if ( $Param{ChunkSize} >= 1 ) {

            # search only on the first invocation
            $Self->{AllFoundTicketIDs} //= [ $Self->_TicketSearch(%TicketSearchParam) ];

            # do the chunking
            my $NewLastHandledIndex = $Self->{LastHandledIndex} + $Param{ChunkSize};
            my $EndIndex            = $#{ $Self->{AllFoundTicketIDs} };
            if ( $NewLastHandledIndex >= $EndIndex ) {
                $Self->{ChunkingFinished} = 1;
                $NewLastHandledIndex = $EndIndex;
            }
            @TicketIDs = @{ $Self->{AllFoundTicketIDs} }[ $Self->{LastHandledIndex} + 1 .. $NewLastHandledIndex ];
            $Self->{LastHandledIndex} = $NewLastHandledIndex;
        }
        else {
            @TicketIDs = $Self->_TicketSearch(%TicketSearchParam);
        }
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my @ExportData;
    my %TicketData;

    my @TicketMapping;
    my @ArticleMapping;
    my $TicketMappingLast;
    my $ArticleMappingLast = 0;    # in case of separate lines an empty entry will precede (thus not -1)
    my $StorePlainEmail    = 0;

    for my $i ( 0 .. $#MappingObjectList ) {

        # handle empty key
        if ( !$MappingObjectList[$i]{Key} ) {
            $TicketMapping[$i]{Key} = '';
            if ( !$ObjectData->{ArticleSeparateLines} ) {
                $TicketMappingLast = $i;
            }
        }

        # article keys
        elsif ( $MappingObjectList[$i]{Key} =~ /^Article_(.+)$/ ) {
            if ( $ObjectData->{ArticleSeparateLines} ) {
                push @ArticleMapping, $MappingObjectList[$i];
                $ArticleMapping[ ++$ArticleMappingLast ]{Key} = $1;
                $TicketMapping[$i]{Key} = '';
            }
            else {
                $ArticleMapping[$i]      = $MappingObjectList[$i];
                $ArticleMapping[$i]{Key} = $1;
                $ArticleMappingLast      = $i;
            }

            if ( $1 eq 'PlainEmail' ) {
                $StorePlainEmail = 1;
            }
        }

        # ticket keys
        else {
            $TicketMapping[$i] = $MappingObjectList[$i];
            $TicketMappingLast = $i;
        }
    }

    # export tickets ...
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    for my $TicketID (@TicketIDs) {

        %TicketData = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            UserID        => 1,
            DynamicFields => 1,
        );

        # add data to the export data array
        my @TicketItem;
        for my $i ( 0 .. $TicketMappingLast ) {

            # extract key
            my $Key = $TicketMapping[$i]{Key};

            $TicketItem[$i] = $Key && defined $TicketData{$Key}
                ? IsArrayRefWithData( $TicketData{$Key} )
                    ? join( '###', ( map { encode_base64( Encode::encode( 'UTF-8', $_ ) ) } $TicketData{$Key}->@* ) )
                    : $TicketData{$Key}
                : '';
        }

        if ( !$ObjectData->{IncludeArticles} || $ObjectData->{ArticleSeparateLines} ) {
            push @ExportData, \@TicketItem;
        }

        if ( $ObjectData->{IncludeArticles} ) {

            # Get article data.
            my @Articles = $ArticleObject->ArticleList(
                TicketID => $TicketID,
            );

            my $ArticleCount = 0;
            for my $Article (@Articles) {

                my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$Article} );

                my %ArticleFull = $ArticleBackendObject->ArticleGet(
                    TicketID      => $TicketID,
                    ArticleID     => $Article->{ArticleID},
                    DynamicFields => 1,
                    UserID        => 1,
                );

                $ArticleFull{ArticleBackend} = $ArticleBackendObject->ChannelNameGet();

                if ( $StorePlainEmail && $ArticleBackendObject->can('ArticlePlain') ) {
                    $ArticleFull{PlainEmail} = $ArticleBackendObject->ArticlePlain(
                        ArticleID => $Article->{ArticleID},
                        UserID    => 1,
                    );
                }

                my @ArticleItem = $ObjectData->{ArticleSeparateLines} ? ('') : @TicketItem;
                ARTICLEMAP:
                for my $i ( 0 .. $ArticleMappingLast ) {

                    # empty fields are done in the ticket part
                    next ARTICLEMAP unless $ArticleMapping[$i];

                    # extract key
                    my $Key = $ArticleMapping[$i]{Key};

                    $ArticleItem[$i] = defined $ArticleFull{$Key}
                        ? IsArrayRefWithData( $ArticleFull{$Key} )
                            ? join( '###', ( map { encode_base64( Encode::encode( 'UTF-8', $_ ) ) } $ArticleFull{$Key}->@* ) )
                            : $ArticleFull{$Key}
                        : '';
                }

                if ( $ObjectData->{IncludeAttachments} && $ArticleBackendObject->can('ArticleAttachmentIndex') ) {
                    my %Index = $ArticleBackendObject->ArticleAttachmentIndex(
                        ArticleID => $Article->{ArticleID},
                    );

                    for my $Key ( sort keys %Index ) {
                        my %Attachment = $ArticleBackendObject->ArticleAttachment(
                            TicketID  => $TicketID,
                            ArticleID => $Article->{ArticleID},
                            FileID    => $Key,
                        );

                        for my $Key (qw( Filename ContentType Disposition )) {
                            $Attachment{$Key} = Encode::encode( 'UTF-8', $Attachment{$Key} );
                        }

                        my $AttachmentString;
                        for my $Key (qw( Filename ContentID ContentType Disposition Content ContentAlternative )) {
                            $Attachment{$Key} //= '';
                            $AttachmentString .= $AttachmentString ? '###' : '';
                            $AttachmentString .= $Key . '###' . encode_base64( $Attachment{$Key} );
                        }

                        push @ArticleItem, $AttachmentString;
                    }
                }

                push @ExportData, \@ArticleItem;
            }
        }
    }

    return \@ExportData;
}

=head2 ImportDataSave()

imports a single entity of the import data. The C<TemplateID> points to the definition
of the current import. C<ImportDataRow> holds the data. C<Counter> is only used in
error messages, for indicating which item was not imported successfully.

The decision what constitute an empty value is a bit hairy. Here are the rules.
Fields that are not even mentioned in the Import definition are empty. These are the 'not defined' fields.
Empty strings and undefined values constitute empty fields.
Fields with with only one or more whitespace characters are not empty.
Fields with the digit '0' are not empty.

    my ( $TicketID, $RetCode ) = $ObjectBackend->ImportDataSave(
        TemplateID    => 123,
        ImportDataRow => $ArrayRef,
        Counter       => 367,
        UserID        => 1,
    );

An empty C<TicketID> indicates failure. Otherwise it indicates the
location of the imported data.
C<RetCode> is either 'Created', 'Updated' or 'Skipped'. 'Created' means that a new
ticket has been created. 'Updated' means that the ticket has been updated. 'Skipped'
means that the data is identical and no changes were made.

No codes have yet been defined for the failure case.

=cut

sub ImportDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID ImportDataRow Counter UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # check import data row
    if ( ref $Param{ImportDataRow} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't import entity $Param{Counter}: ImportDataRow must be an array reference",
        );

        return;
    }

    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');

    # get object data, that is the config of this template
    my $ObjectData = $ImportExportObject->ObjectDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check object data
    if ( !$ObjectData || ref $ObjectData ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "Can't import entity $Param{Counter}: "
                . "No object data found for the template id '$Param{TemplateID}'",
        );

        return;
    }

    # get and check the mapping list
    my $MappingList = $ImportExportObject->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );
    if ( !$MappingList || ref $MappingList ne 'ARRAY' || !@{$MappingList} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "Can't import entity $Param{Counter}: "
                . "No valid mapping list found for the template id '$Param{TemplateID}'",
        );

        return;
    }

    # create the mapping object list
    # TODO: why is this called for every row of the import file ?
    my @MappingObjectList;
    for my $MappingID ( $MappingList->@* ) {

        # get mapping object data
        my $MappingObjectData = $ImportExportObject->MappingObjectDataGet(
            MappingID => $MappingID,
            UserID    => $Param{UserID},
        );

        # check mapping object data
        if ( !$MappingObjectData || ref $MappingObjectData ne 'HASH' ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Can't import entity $Param{Counter}: "
                    . "No mapping object data found for the mapping id '$MappingID'",
            );

            return;
        }

        push @MappingObjectList, $MappingObjectData;
    }

    # prepare import data
    my %Ticket;
    my %Article;
    my %Identifier;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $MappingConfig = $ConfigObject->Get('ImportExport::Ticket::ImportValueMap') // {};
    my %ValueMap =
        map { $_->{Key} => $_->{Map} }
        values $MappingConfig->%*;

    # handle a separate article
    # TODO: what about "0" ?
    if ( $ObjectData->{IncludeArticles} && $ObjectData->{ArticleSeparateLines} && !$Param{ImportDataRow}[0] ) {

        # handling an article an a separate line
        my $i = 1;
        MAPPINGOBJECTDATA:
        for my $MappingObjectData (@MappingObjectList) {

            if ( $MappingObjectData->{Key} =~ /^Article_(.+)$/ ) {
                my $Value = $Param{ImportDataRow}[ $i++ ];
                $Article{$1} = defined $Value && $ValueMap{ $MappingObjectData->{Key} } && defined $ValueMap{ $MappingObjectData->{Key} }{$Value}
                    ? $ValueMap{ $MappingObjectData->{Key} }{$Value} : $Value;
            }
            else {
                next MAPPINGOBJECTDATA;
            }

            next MAPPINGOBJECTDATA unless $MappingObjectData->{Identifier};

            if ( $MappingObjectData->{Key} ne 'Article_ArticleID' ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "Can't import entity $Param{Counter}: "
                        . "Articles can only be identified via 'Article_ArticleID' not by '$MappingObjectData->{Key}'.",
                );
                return;
            }
            elsif ( !$Param{ImportDataRow}[ $i - 1 ] ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "Can't import entity $Param{Counter}: "
                        . "'Article_ArticleID' can not be empty or 0 when used as identifier.",
                );
                return;
            }

            $Identifier{Article}{ArticleID} = 1;
        }

        if ( $ObjectData->{IncludeAttachments} && $i <= $#{ $Param{ImportDataRow} } ) {

            # the last and unmapped entries are attachments
            $Article{Attachments} = [ @{ $Param{ImportDataRow} }[ $i .. $#{ $Param{ImportDataRow} } ] ];
        }
    }
    else {

        # handling a ticket line
        MAPPINGOBJECTDATA:
        for my $i ( 0 .. $#MappingObjectList ) {

            my $MappingObjectData = $MappingObjectList[$i];

            my $Value = $Param{ImportDataRow}[$i];
            $Value = defined $Value && $ValueMap{ $MappingObjectData->{Key} } && defined $ValueMap{ $MappingObjectData->{Key} }{$Value}
                ? $ValueMap{ $MappingObjectData->{Key} }{$Value} : $Value;

            if ( $MappingObjectData->{Key} =~ m/^Article_(.+)$/ ) {
                next MAPPINGOBJECTDATA if $ObjectData->{ArticleSeparateLines};
                next MAPPINGOBJECTDATA unless $ObjectData->{IncludeArticles};

                $Article{$1} = $Value;
            }
            else {
                $Ticket{ $MappingObjectData->{Key} } = $Value;
            }

            # identifiers are usually TicketID or TicketNumber
            next MAPPINGOBJECTDATA unless $MappingObjectData->{Identifier};

            if ( !$Value ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "Can't import entity $Param{Counter}: "
                        . "'$MappingObjectData->{Key}' can not be empty or 0 when used as identifier.",
                );

                return;
            }

            if ( $MappingObjectData->{Key} eq 'Article_ArticleID' ) {
                $Identifier{Article}{ArticleID} = 1;
            }
            elsif ( $MappingObjectData->{Key} =~ /^Article_/ ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "Can't import entity $Param{Counter}: "
                        . "Currently only Article_ArticleID is a valid identifier for articles (not '$MappingObjectData->{Key}').",
                );

                return;
            }
            else {
                $Identifier{Ticket}{ $MappingObjectData->{Key} } = 1;
            }
        }

        if ( %Article && $ObjectData->{IncludeAttachments} && $#MappingObjectList < $#{ $Param{ImportDataRow} } ) {

            # the last and unmapped entries are attachments
            $Article{Attachments} = [ @{ $Param{ImportDataRow} }[ $#MappingObjectList + 1 .. $#{ $Param{ImportDataRow} } ] ];
        }
    }

    my $Status = 'Skipped';
    $Self->{Error} = '';
    if (
        %Ticket
        &&
        ( !$Ticket{TicketID} || !exists $Self->{TicketIDRelation}{ $Ticket{TicketID} } )
        )
    {
        $Status = $Self->_ImportTicket(
            Ticket     => \%Ticket,
            Identifier => $Identifier{Ticket},
            ObjectData => $ObjectData,
        );

        if ( !$Status ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Can't import entity $Param{Counter}: "
                    . "TicketImport: $Self->{Error}",
            );

            return;
        }
    }

    if ( %Article && $ObjectData->{IncludeArticles} ) {
        my $ArticleStatus = $Self->_ImportArticle(
            Article    => \%Article,
            Identifier => $Identifier{Article},
            ObjectData => $ObjectData,
        );

        if ( !$ArticleStatus ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Can't import entity $Param{Counter}: "
                    . "ArticleImport: $Self->{Error}",
            );

            return;
        }

        if ( $Status eq 'Skipped' && $ArticleStatus eq 'Created' ) {
            $Status = 'Updated';
        }
    }

    return ( $Self->{LastTicketID}, $Status );
}

=head1 Internal Subroutines

=head2 _TicketSearch

just a wrapper around C<Kernel::System::Ticket::TicketSearch()>

=cut

sub _TicketSearch {
    my ( $Self, %Param ) = @_;

    my $ImportExportObject = $Kernel::OM->Get('Kernel::System::ImportExport');
    my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

    # get search data
    my $SearchData = $ImportExportObject->SearchDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    my %IsSelection = map { $_ => 1 } qw( TypeIDs QueueIDs ServiceIDs SLAIDs StateIDs PriorityIDs CustomerID );

    my %SearchDataPrepared;
    KEY:
    for my $Key ( keys %{$SearchData} ) {
        next KEY unless defined $SearchData->{$Key};

        $SearchDataPrepared{$Key} = $IsSelection{$Key} ? [ split /#####/, $SearchData->{$Key} ] : $SearchData->{$Key};
    }

    # make sure that sort is not called in scalar context
    my @SortedTicketIDs = sort { $a <=> $b } $TicketObject->TicketSearch(
        %SearchDataPrepared,
        Result => 'ARRAY',
        UserID => 1,
    );

    return @SortedTicketIDs;
}

sub _ImportTicket {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    my %Ticket = $Param{Ticket}->%*;    # data from the import file
    my %DBTicket;                       # Ticket as retrieved from the database
    my $Status = 'Skipped';

    if ( $Param{Identifier} ) {
        my $DBTicketID;

        # TicketID takes precedence over TicketNumber
        if ( $Param{Identifier}{TicketID} ) {

            # check previously imported tickets of this run
            if ( $Self->{TicketIDRelation}{ $Ticket{TicketID} } ) {

                # we silently skip this ticket, if it already has been imported
                # this situation will always occur when articles are not imported separately
                # for the sake of consistency, we treat other situations the same, although they are less clear
                my $Prio = !$Param{ObjectData}{ArticleSeparateLines}
                    && $Self->{LastTicketID} == $Self->{TicketIDRelation}{ $Ticket{TicketID} } ? 'debug' : 'info';
                $LogObject->Log(
                    Priority => $Prio,
                    Message  => "Skipping ticket creation for entity $Param{Counter} (TicketID $Ticket{TicketID}) as it was handled before."
                );
                $Self->{LastTicketID} = $Self->{TicketIDRelation}{ $Ticket{TicketID} };

                return $Status;
            }

            # existing but undefined entry means previous error - we skip and do nothing
            elsif ( exists $Self->{TicketIDRelation}{ $Ticket{TicketID} } ) {
                return $Self->_ImportError(
                    %Param,
                    Message => "TicketID $Ticket{TicketID} was incorrectly imported before canceling new try.",
                );
            }

            # exclude tickets which were created in this run and by chance got the current TicketID
            elsif ( !{ reverse $Self->{TicketIDRelation}->%* }->{ $Ticket{TicketID} } ) {
                $DBTicketID = $Ticket{TicketID};
            }
        }
        elsif ( $Param{Identifier}{TicketNumber} ) {

            # check previously imported tickets of this run
            if ( $Self->{TicketNumberIDRelation}{ $Ticket{TicketNumber} } ) {

                # we silently skip this ticket, if it already has been imported
                # this situation will always occur when articles are not imported separately
                # for the sake of consistency, we treat other situations the same, although they are less clear
                my $Prio = !$Param{ObjectData}{ArticleSeparateLines}
                    && $Self->{LastTicketID} == $Self->{TicketNumberIDRelation}{ $Ticket{TicketNumber} } ? 'debug' : 'info';
                $LogObject->Log(
                    Priority => $Prio,
                    Message  => "Skipping ticket creation for entity $Param{Counter} (TicketNumber $Ticket{TicketNumber}) as it was handled before."
                );
                $Self->{LastTicketID} = $Self->{TicketNumberIDRelation}{ $Ticket{TicketNumber} };
                return $Self->{LastTicketID};
            }

            # existing but undefined entry means previous error - we skip and do nothing
            elsif ( exists $Self->{TicketNumberIDRelation}{ $Ticket{TicketNumber} } ) {
                return $Self->_ImportError(
                    %Param,
                    Message => "TicketNumber $Ticket{TicketNumber} was incorrectly imported before canceling new try.",
                );
            }

            # exclude tickets which were created in this run and by chance got the current TicketNumber
            # TODO: how is CreatedNumbers provided with content ?
            elsif ( !$Self->{CreatedNumbers}{ $Ticket{TicketNumber} } ) {
                $DBTicketID = $TicketObject->TicketIDLookup(
                    TicketNumber => $Ticket{TicketNumber},
                );
            }
        }
        else {
            return $Self->_ImportError(
                %Param,
                Message =>
                    'For ticket correlation checks either TicketID or TicketNumber has to be included as identifier. (Using no identifier to just create new tickets is also possible.)',
            );
        }

        if ($DBTicketID) {
            %DBTicket = $TicketObject->TicketGet(
                TicketID      => $DBTicketID,
                DynamicFields => 0,
                UserID        => 1,
                Silent        => 1,
            );
        }
    }

    # verify whether we really got the right ticket, all identifiers must match
    if (%DBTicket) {
        ATTR:
        for my $Attr ( keys $Param{Identifier}->%* ) {
            if ( $DBTicket{$Attr} ne $Ticket{$Attr} ) {
                %DBTicket = ();

                last ATTR;
            }
        }
    }

    # just update the ticket if it is already present
    if (%DBTicket) {
        $Status = 'Skipped';

        # There are cases when a ticket update should not take place. Currently one
        # one of these cases is supported. This case is for updating owners of tickets.
        # Only tickets that are not owned by a specific agent. Usually this special agent
        # is the default agent of a previous import.
        if ( $Param{ObjectData}->{AllowedOwnerInTarget} ) {
            return 'Skipped' unless $DBTicket{Owner} eq $Param{ObjectData}->{AllowedOwnerInTarget};
        }

        # decide whether the old values should be kept
        my $SkipEmpty = $Param{ObjectData}{EmptyFieldsLeaveTheOldValues};

        # customer
        $Ticket{CustomerID}     ||= $SkipEmpty ? $DBTicket{CustomerID}     : $Param{ObjectData}{CustomerID};
        $Ticket{CustomerUserID} ||= $SkipEmpty ? $DBTicket{CustomerUserID} : $Param{ObjectData}{CustomerUserID};
        $DBTicket{CustomerID}     //= '';
        $DBTicket{CustomerUserID} //= '';

        if ( ( !$Ticket{CustomerID} && $DBTicket{CustomerID} ) || ( !$Ticket{CustomerUserID} && $DBTicket{CustomerUserID} ) ) {
            $LogObject->Log(
                Priority => 'notice',
                Message  => "Unexpected state encountered for existing TicketID $Ticket{TicketID} (Entity $Param{Counter}): "
                    . "Ticket customer can not be emptied - not a real chronological update; ignoring this, and keeping Customer(User)ID.",
            );
        }

        {
            my $Update = $Ticket{CustomerID} && $Ticket{CustomerID} ne $DBTicket{CustomerID} ? 1 :
                $Ticket{CustomerUserID} && $Ticket{CustomerUserID} ne $DBTicket{CustomerUserID} ? 1 : 0;

            if ($Update) {
                $Status = 'Updated';
                my $Success = $TicketObject->TicketCustomerSet(
                    No       => $Ticket{CustomerID},
                    User     => $Ticket{CustomerUserID},
                    TicketID => $DBTicket{TicketID},
                    UserID   => 1,
                );

                return $Self->_ImportError(
                    %Param,
                    Message => "Could not update Customer(User) for TicketID $DBTicket{TicketID}",
                ) unless $Success;
            }
        }

        # title
        $Ticket{Title} ||=
            ( defined $Ticket{Title} && $Ticket{Title} eq '0' ) ? '0' :
            $SkipEmpty                                          ? $DBTicket{Title} :
            $Param{ObjectData}{Subject}                         ? $Param{ObjectData}{Subject} : '';

        if ( $Ticket{Title} ne $DBTicket{Title} ) {
            $Status = 'Updated';
            my $Success = $TicketObject->TicketTitleUpdate(
                Title    => $Ticket{Title},
                TicketID => $DBTicket{TicketID},
                UserID   => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not update Title for TicketID $DBTicket{TicketID}",
            ) unless $Success;
        }

        # queue
        if ( !$Ticket{QueueID} && $Ticket{Queue} ) {
            $Ticket{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
                Queue => $Ticket{Queue},
            );
        }
        $Ticket{QueueID} ||= $SkipEmpty ? $DBTicket{QueueID} : $Param{ObjectData}{QueueID};

        if ( $Ticket{QueueID} ne $DBTicket{QueueID} ) {
            $Status = 'Updated';
            my $Success = $TicketObject->TicketQueueSet(
                QueueID  => $Ticket{QueueID},
                TicketID => $DBTicket{TicketID},
                UserID   => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not update Queue for TicketID $DBTicket{TicketID}",
            ) unless $Success;
        }

        # need for checking the activated features: Ticket::Type, Ticket::Responsible, Ticket::Service
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # type
        if ( $ConfigObject->Get('Ticket::Type') ) {
            if ( !$Ticket{TypeID} && $Ticket{Type} ) {
                $Ticket{TypeID} = $Kernel::OM->Get('Kernel::System::Type')->TypeLookup(
                    Type => $Ticket{Type},
                );
            }
            $Ticket{TypeID} ||= $SkipEmpty ? $DBTicket{TypeID} : $Param{ObjectData}{TypeID};

            if ( $Ticket{TypeID} ne $DBTicket{TypeID} ) {
                $Status = 'Updated';
                my $Success = $TicketObject->TicketTypeSet(
                    TypeID   => $Ticket{TypeID},
                    TicketID => $DBTicket{TicketID},
                    UserID   => 1,
                );

                return $Self->_ImportError(
                    %Param,
                    Message => "Could not update Type for TicketID $DBTicket{TicketID}",
                ) unless $Success;
            }
        }

        if ( $ConfigObject->Get('Ticket::Service') ) {

            # service
            if ( !$Ticket{ServiceID} && $Ticket{Service} ) {
                $Ticket{ServiceID} = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
                    Name => $Ticket{Service},
                );
            }
            $Ticket{ServiceID} ||= $SkipEmpty ? $DBTicket{ServiceID} : $Param{ObjectData}{ServiceID};
            $DBTicket{ServiceID} //= '';

            if ( !$Ticket{ServiceID} && $DBTicket{ServiceID} ) {
                $LogObject->Log(
                    Priority => 'notice',
                    Message  => "Unexpected state encountered for existing TicketID $Ticket{TicketID} (Entity $Param{Counter}): "
                        . "Services can not be emptied - not a real chronological update; ignoring this, and keeping the Service.",
                );
            }

            if ( $Ticket{ServiceID} && $Ticket{ServiceID} ne $DBTicket{ServiceID} ) {
                $Status = 'Updated';
                my $Success = $TicketObject->TicketServiceSet(
                    ServiceID => $Ticket{ServiceID},
                    TicketID  => $DBTicket{TicketID},
                    UserID    => 1,
                );

                return $Self->_ImportError(
                    %Param,
                    Message => "Could not update Service for TicketID $DBTicket{TicketID}",
                ) unless $Success;
            }

            # SLA
            if ( !$Ticket{SLAID} && $Ticket{SLA} ) {
                $Ticket{SLAID} = $Kernel::OM->Get('Kernel::System::SLA')->SLALookup(
                    SLA => $Ticket{SLA},
                );
            }
            $Ticket{SLAID} ||= $SkipEmpty ? $DBTicket{SLAID} : $Param{ObjectData}{SLAID};
            $DBTicket{SLAID} //= '';

            if ( !$Ticket{SLAID} && $DBTicket{SLAID} ) {
                $LogObject->Log(
                    Priority => 'notice',
                    Message  => "Unexpected state encountered for existing TicketID $Ticket{TicketID} (Entity $Param{Counter}): "
                        . "SLAs can not be emptied - not a real chronological update; ignoring this, and keeping the SLA.",
                );
            }

            if ( $Ticket{SLAID} && $Ticket{SLAID} ne $DBTicket{SLAID} ) {
                $Status = 'Updated';
                my $Success = $TicketObject->TicketSLASet(
                    SLAID    => $Ticket{SLAID},
                    TicketID => $DBTicket{TicketID},
                    UserID   => 1,
                );

                return $Self->_ImportError(
                    %Param,
                    Message => "Could not update SLA for TicketID $DBTicket{TicketID}",
                ) unless $Success;
            }
        }

        # owner
        if ( !$Ticket{OwnerID} && $Ticket{Owner} ) {
            $Ticket{OwnerID} = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $Ticket{Owner},
            );
        }
        $Ticket{OwnerID} ||= $SkipEmpty ? $DBTicket{OwnerID} : $Param{ObjectData}{OwnerID};

        if ( !$Ticket{OwnerID} && $DBTicket{OwnerID} ) {
            $LogObject->Log(
                Priority => 'notice',
                Message  => "Unexpected state encountered for existing TicketID $Ticket{TicketID} (Entity $Param{Counter}): "
                    . "Owners can not be emptied - not a real chronological update; ignoring this, and keeping the Owner.",
            );
        }

        if ( $Ticket{OwnerID} && $Ticket{OwnerID} ne $DBTicket{OwnerID} ) {
            $Status = 'Updated';
            my $Success = $TicketObject->TicketOwnerSet(
                NewUserID => $Ticket{OwnerID},
                TicketID  => $DBTicket{TicketID},
                UserID    => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not update Owner for TicketID $DBTicket{TicketID}",
            ) unless $Success;
        }

        # lock
        if ( !$Ticket{LockID} && $Ticket{Lock} ) {
            $Ticket{LockID} = $Kernel::OM->Get('Kernel::System::Lock')->LockLookup(
                Lock => $Ticket{Lock},
            );
        }
        $Ticket{LockID} ||= $SkipEmpty ? $DBTicket{LockID} : $Param{ObjectData}{LockID};

        # check whether an owner exists here - if not trying to lock will fail
        if ( $Ticket{OwnerID} && $Ticket{LockID} ne $DBTicket{LockID} ) {
            $Status = 'Updated';
            my $Success = $TicketObject->TicketLockSet(
                LockID   => $Ticket{LockID},
                TicketID => $DBTicket{TicketID},
                UserID   => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not update Lock for TicketID $DBTicket{TicketID}",
            ) unless $Success;
        }

        # responsible
        if ( $ConfigObject->Get('Ticket::Responsible') ) {
            if ( !$Ticket{ResponsibleID} && $Ticket{Responsible} ) {
                $Ticket{ResponsibleID} = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                    UserLogin => $Ticket{Responsible},
                );
            }
            $Ticket{ResponsibleID} ||= $SkipEmpty ? $DBTicket{ResponsibleID} : $Param{ObjectData}{ResponsibleID};

            if ( !$Ticket{ResponsibleID} && $DBTicket{ResponsibleID} ) {
                $LogObject->Log(
                    Priority => 'notice',
                    Message  => "Unexpected state encountered for existing TicketID $Ticket{TicketID} (Entity $Param{Counter}): "
                        . "Responsibles can not be emptied - not a real chronological update; ignoring this, and keeping the Responsible.",
                );
            }

            if ( $Ticket{ResponsibleID} && $Ticket{ResponsibleID} ne $DBTicket{ResponsibleID} ) {
                $Status = 'Updated';
                my $Success = $TicketObject->TicketResponsibleSet(
                    NewUserID => $Ticket{ResponsibleID},
                    TicketID  => $DBTicket{TicketID},
                    UserID    => 1,
                );

                return $Self->_ImportError(
                    %Param,
                    Message => "Could not update Responsible for TicketID $DBTicket{TicketID}",
                ) unless $Success;
            }
        }

        # priority
        if ( !$Ticket{PriorityID} && $Ticket{Priority} ) {
            $Ticket{PriorityID} = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
                Priority => $Ticket{Priority},
            );
        }
        $Ticket{PriorityID} ||= $SkipEmpty ? $DBTicket{PriorityID} : $Param{ObjectData}{PriorityID};

        if ( $Ticket{PriorityID} ne $DBTicket{PriorityID} ) {
            $Status = 'Updated';
            my $Success = $TicketObject->TicketPrioritySet(
                PriorityID => $Ticket{PriorityID},
                TicketID   => $DBTicket{TicketID},
                UserID     => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not update Priority for TicketID $DBTicket{TicketID}",
            ) unless $Success;
        }

        # state
        if ( !$Ticket{StateID} && $Ticket{State} ) {
            $Ticket{StateID} = $Kernel::OM->Get('Kernel::System::State')->StateLookup(
                State => $Ticket{State},
            );
        }
        $Ticket{StateID} ||= $SkipEmpty ? $DBTicket{StateID} : $Param{ObjectData}{StateID};

        if ( $Ticket{StateID} ne $DBTicket{StateID} ) {
            $Status = 'Updated';
            my $Success = $TicketObject->TicketStateSet(
                StateID  => $Ticket{StateID},
                TicketID => $DBTicket{TicketID},
                UserID   => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not update State for TicketID $DBTicket{TicketID}",
            ) unless $Success;
        }

        # archive flag
        $Ticket{ArchiveFlag} ||= $SkipEmpty ? $DBTicket{ArchiveFlag} : $Param{ObjectData}{ArchiveFlag};

        if ( $Ticket{ArchiveFlag} ne $DBTicket{ArchiveFlag} ) {
            $Status = 'Updated';
            my $Success = $TicketObject->TicketArchiveFlagSet(
                ArchiveFlag => $Ticket{ArchiveFlag},
                TicketID    => $DBTicket{TicketID},
                UserID      => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not update ArchiveFlag for TicketID $DBTicket{TicketID}",
            ) unless $Success;
        }
    }

    # A new ticket will be created. Collect the input for TicketCreate in %DBTicket.
    else {
        $Status = 'Created';

        # customer
        $DBTicket{CustomerID}   = $Ticket{CustomerID}     || $Param{ObjectData}{CustomerID};
        $DBTicket{CustomerUser} = $Ticket{CustomerUserID} || $Param{ObjectData}{CustomerUserID};

        # title
        $DBTicket{Title} = ( $Ticket{Title} || ( defined $Ticket{Title} && $Ticket{Title} eq '0' ) )
            ?
            $Ticket{Title}
            :
            $Param{ObjectData}{Subject};

        # queue
        if ( !$Ticket{QueueID} && $Ticket{Queue} ) {
            $Ticket{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
                Queue => $Ticket{Queue},
            );
        }
        $DBTicket{QueueID} = $Ticket{QueueID} || $Param{ObjectData}{QueueID};

        # need for checking the activated features: Ticket::Type, Ticket::Responsible, Ticket::Service
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # type
        if ( $ConfigObject->Get('Ticket::Type') ) {
            if ( !$Ticket{TypeID} && $Ticket{Type} ) {
                $Ticket{TypeID} = $Kernel::OM->Get('Kernel::System::Type')->TypeLookup(
                    Type => $Ticket{Type},
                );
            }
            $DBTicket{TypeID} = $Ticket{TypeID} || $Param{ObjectData}{TypeID};
        }

        if ( $ConfigObject->Get('Ticket::Service') ) {

            # service
            if ( !$Ticket{ServiceID} && $Ticket{Service} ) {
                $Ticket{ServiceID} = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
                    Name => $Ticket{Service},
                );
            }
            $DBTicket{ServiceID} = $Ticket{ServiceID} || $Param{ObjectData}{ServiceID};

            # sla
            if ( !$Ticket{SLAID} && $Ticket{SLA} ) {
                $Ticket{SLAID} = $Kernel::OM->Get('Kernel::System::SLA')->SLALookup(
                    SLA => $Ticket{SLA},
                );
            }
            $DBTicket{SLAID} = $Ticket{SLAID} || $Param{ObjectData}{SLAID};
        }

        # owner
        if ( !$Ticket{OwnerID} && $Ticket{Owner} ) {
            $Ticket{OwnerID} = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $Ticket{Owner},
            );
        }
        $DBTicket{OwnerID} = $Ticket{OwnerID} || $Param{ObjectData}{OwnerID};

        # lock
        if ( !$Ticket{LockID} && $Ticket{Lock} ) {
            $Ticket{LockID} = $Kernel::OM->Get('Kernel::System::Lock')->LockLookup(
                Lock => $Ticket{Lock},
            );
        }
        $DBTicket{LockID} = $Ticket{LockID} || $Param{ObjectData}{LockID};

        # responsible
        if ( $ConfigObject->Get('Ticket::Responsible') ) {
            if ( !$Ticket{ResponsibleID} && $Ticket{Responsible} ) {
                $Ticket{ResponsibleID} = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                    UserLogin => $Ticket{Responsible},
                );
            }
            $DBTicket{ResponsibleID} = $Ticket{ResponsibleID} || $Param{ObjectData}{ResponsibleID};
        }

        # priority
        if ( !$Ticket{PriorityID} && $Ticket{Priority} ) {
            $Ticket{PriorityID} = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
                Priority => $Ticket{Priority},
            );
        }
        $DBTicket{PriorityID} = $Ticket{PriorityID} || $Param{ObjectData}{PriorityID};

        # state
        if ( !$Ticket{StateID} && $Ticket{State} ) {
            $Ticket{StateID} = $Kernel::OM->Get('Kernel::System::State')->StateLookup(
                State => $Ticket{State},
            );
        }
        $DBTicket{StateID} = $Ticket{StateID} || $Param{ObjectData}{StateID};

        # archive flag
        $DBTicket{ArchiveFlag} = $Ticket{ArchiveFlag} || $Param{ObjectData}{ArchiveFlag};

        # Handle pending transaction events of the previously created ticket
        # before creating a new ticket.
        $TicketObject->EventHandlerTransaction;

        # Create a new ticket. The transaction events generated here will be handled
        # before the next ticket creation or during global destruction.
        $DBTicket{TicketID} = $TicketObject->TicketCreate(
            %DBTicket,
            TN     => $Ticket{TicketNumber} // '',
            UserID => 1,
        );

        return $Self->_ImportError(
            %Param,
            Message => 'Could not create new ticket',
        ) unless $DBTicket{TicketID};

        $DBTicket{TicketNumber} = $TicketObject->TicketNumberLookup(
            TicketID => $DBTicket{TicketID},
        );

        if ( $Ticket{Created} ) {
            $Self->{DBObject} //= $Kernel::OM->Get('Kernel::System::DB');

            return unless $Self->{DBObject}->Do(
                SQL  => "UPDATE ticket SET create_time = ? WHERE id = ?",
                Bind => [ \$Ticket{Created}, \$DBTicket{TicketID} ],
            );
        }

        # Fetch additional data from the source installation if configured.
        my $SyncDBConfig = $ConfigObject->Get('ImportExport::Ticket::SynchronizeWithForeignDB');
        if ($SyncDBConfig) {
            my $Success = $Self->_SynchronizeExtendedDBEntries(
                ForeignDB       => $SyncDBConfig,
                ForeignTicketID => $Ticket{TicketID},
                TicketID        => $DBTicket{TicketID},
            );

            return $Self->_ImportError(
                %Param,
                Message => "Could not synchronize extended DB entries for ticket $DBTicket{TicketID}",
            ) unless $Success;
        }
    }

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my %StandardMultiSelect       = map { $_ => 1 } qw( Multiselect Database WebService );

    # dynamic fields
    DYNAMICFIELD:
    for my $Attr ( keys %Ticket ) {

        # only handle dynamic fields
        next DYNAMICFIELD unless $Attr =~ m/^DynamicField_(.+)$/;

        my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $1,
        );

        # get the current value
        my $DBValue = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $DBTicket{TicketID},
            UserID             => 1,
        );

        # multi select fields need special treatment
        if ( $StandardMultiSelect{ $DynamicFieldConfig->{FieldType} } || ref $DBValue eq 'ARRAY' ) {
            $Ticket{$Attr} = $Ticket{$Attr} ? [ map { decode( 'UTF-8', decode_base64($_) ) } split( /###/, $Ticket{$Attr} ) ] : [];
        }

        next DYNAMICFIELD unless $DynamicFieldBackendObject->ValueIsDifferent(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value1             => $Ticket{$Attr},
            Value2             => $DBValue,
        );

        if ( $Status eq 'Skipped' ) {
            $Status = 'Updated';
        }

        my $Success = $DynamicFieldBackendObject->FieldValueValidate(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{$Attr},
            UserID             => 1,
        );

        if ($Success) {

            # set the value
            $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $DBTicket{TicketID},
                Value              => $Ticket{$Attr},
                ExternalSource     => 1,
                UserID             => 1,
            );
        }

        return $Self->_ImportError(
            %Param,
            Message => "Could not update $Attr to '$Ticket{$Attr}' for TicketID $DBTicket{TicketID}",
        ) unless $Success;
    }

    if ( $Param{Identifier}{TicketID} || $Param{ObjectData}{IncludeArticles} ) {

        # TODO: why the check on IncludeArticles
        if ( $Ticket{TicketID} ) {
            $Self->{TicketIDRelation}{ $Ticket{TicketID} } = $DBTicket{TicketID};
        }
    }
    if ( $Param{Identifier}{TicketNumber} ) {
        $Self->{TicketNumberIDRelation}{ $Ticket{TicketNumber} } = $DBTicket{TicketID};
    }

    # remember the ticket ID so that articles can be attached to it
    $Self->{LastTicketID} = $DBTicket{TicketID};

    return $Status;
}

sub _ImportArticle {
    my ( $Self, %Param ) = @_;

    my %Article = $Param{Article}->%*;

    my $TicketID =
        $Article{TicketID} && $Self->{TicketIDRelation}{ $Article{TicketID} } ? $Self->{TicketIDRelation}{ $Article{TicketID} } :
        $Self->{LastTicketID}                                                 ? $Self->{LastTicketID} : '';

    return $Self->_ImportError(
        %Param,
        Message => "Could not find new TicketID for Article",
    ) unless $TicketID;

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    if ( $Param{Identifier} && $Param{Identifier}{ArticleID} && $Article{ArticleID} ) {
        my @DBArticles = $ArticleObject->ArticleList(
            TicketID  => $TicketID,
            ArticleID => $Article{ArticleID},
        );

        return 'Skipped' if @DBArticles;
    }

    my %ValidImportChannel = map { $_ => 1 } qw( Email Internal Phone );
    my $ChannelName        = $Article{ArticleBackend} || $Param{ObjectData}{ArticleBackend};

    return $Self->_ImportError(
        %Param,
        Message => "'$ChannelName' is (currently) not a supported ArticleBackend",
    ) unless $ValidImportChannel{$ChannelName};

    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => $ChannelName );

    if ( $ChannelName eq 'Email' && !$Article{MessageID} ) {
        my $Time   = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
        my $Random = rand 999999;
        my $FQDN   = $ConfigObject->Get('FQDN');
        $Article{MessageID} = "<$Time.$Random\@$FQDN>";
    }

    my $HistoryComment = '%%Imported Article';
    if ( $Article{TicketID} || $Article{ArticleID} ) {
        $HistoryComment .= ' - Legacy';
        $HistoryComment .= $Article{TicketID}  ? " TID: $Article{TicketID};"  : '';
        $HistoryComment .= $Article{ArticleID} ? " AID: $Article{ArticleID};" : '';
    }

    # Handle pending transaction events of the previously created article
    # before creating a new article.
    $ArticleBackendObject->EventHandlerTransaction;
    $ArticleObject->EventHandlerTransaction;

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        NoAgentNotify        => 1,
        TicketID             => $TicketID,
        SenderType           => $Article{SenderType} || $Param{ObjectData}{SenderType},
        IsVisibleForCustomer => defined $Article{IsVisibleForCustomer}
            && $Article{IsVisibleForCustomer} ne '' ? $Article{IsVisibleForCustomer} : $Param{ObjectData}{IsVisibleForCustomer} // 0,
        From           => $Article{From},
        To             => $Article{To},
        Cc             => $Article{Cc},
        Bcc            => $Article{Bcc},
        ReplyTo        => $Article{ReplyTo},
        InReplyTo      => $Article{InReplyTo},
        References     => $Article{References},
        Subject        => $Article{Subject}  || $Param{ObjectData}{Subject},
        Body           => $Article{Body}     || $Param{ObjectData}{Body},
        Charset        => $Article{Charset}  || 'utf-8',
        MimeType       => $Article{MimeType} || 'text/plain',
        HistoryType    => 'Misc',
        HistoryComment => $HistoryComment,
        MessageID      => $Article{MessageID},
        UserID         => 1,
    );

    return $Self->_ImportError(
        %Param,
        Message => "Could not create the article",
    ) unless $ArticleID;

    if ( $Article{CreateTime} ) {
        $Self->{DBObject} //= $Kernel::OM->Get('Kernel::System::DB');

        return unless $Self->{DBObject}->Do(
            SQL  => "UPDATE article SET create_time = ? WHERE id = ?",
            Bind => [ \$Article{CreateTime}, \$ArticleID ],
        );
    }

    my $SyncDBConfig = $ConfigObject->Get('ImportExport::Ticket::SynchronizeWithForeignDB');
    if ($SyncDBConfig) {
        my $Success = $Self->_SynchronizeExtendedDBEntries(
            ForeignDB        => $SyncDBConfig,
            ForeignArticleID => $Article{ArticleID},
            ArticleID        => $ArticleID,
            TicketID         => $TicketID,
        );

        return $Self->_ImportError(
            %Param,
            Message => "Could not synchronize extended DB entries for ticket $ArticleID",
        ) unless $Success;
    }

    # attachments
    if ( $Param{ObjectData}{IncludeAttachments} && $Article{Attachments} ) {
        for my $AttachmentString ( $Article{Attachments}->@* ) {
            my %Attachment = split( /###/, $AttachmentString, -1 );

            for my $Key ( keys %Attachment ) {
                $Attachment{$Key} = $Attachment{$Key} eq '' ? '' : decode_base64( $Attachment{$Key} );
            }

            KEY:
            for my $Key (qw( Filename ContentType Disposition )) {
                next KEY unless $Attachment{$Key};

                $Attachment{$Key} = Encode::decode( 'UTF-8', $Attachment{$Key} );
            }

            my $Success = $ArticleBackendObject->ArticleWriteAttachment(
                %Attachment,
                ArticleID => $ArticleID,
                UserID    => 1,
            );

            return $Self->_ImportError(
                %Param,
                Message => "Error with importing an attachment for article $ArticleID",
            ) unless $Success;
        }
    }

    # plain email
    if ( $Article{PlainEmail} ) {
        my $Success = $ArticleBackendObject->ArticleWritePlain(
            ArticleID => $ArticleID,
            Email     => $Article{PlainEmail},
            UserID    => 1,
        );

        return $Self->_ImportError(
            %Param,
            Message => "Error with importing the plain email for article $ArticleID",
        ) unless $Success;
    }

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my %StandardMultiSelect       = map { $_ => 1 } qw( Multiselect Database WebService );

    # dynamic fields
    DYNAMICFIELD:
    for my $Attr ( keys %Article ) {
        my $DynamicFieldConfig;
        if ( $Attr =~ /^DynamicField_(.+)$/ ) {
            $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $1,
            );
        }
        else {
            next DYNAMICFIELD;
        }

        # get the current value
        my $DBValue = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $ArticleID,
            UserID             => 1,
        );

        # multi select fields need special treatment
        if ( $StandardMultiSelect{ $DynamicFieldConfig->{FieldType} } || ref $DBValue eq 'ARRAY' ) {
            $Article{$Attr} = $Article{$Attr} ? [ map { decode( 'UTF-8', decode_base64($_) ) } split( /###/, $Article{$Attr} ) ] : [];
        }

        next DYNAMICFIELD unless $DynamicFieldBackendObject->ValueIsDifferent(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value1             => $Article{$Attr},
            Value2             => $DBValue,
        );

        my $Success = $DynamicFieldBackendObject->FieldValueValidate(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Article{$Attr},
            UserID             => 1,
        );

        if ($Success) {

            # set the value
            $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ArticleID,
                Value              => $Article{$Attr},
                ExternalSource     => 1,
                UserID             => 1,
            );
        }

        return $Self->_ImportError(
            %Param,
            Message => "Could not update $Attr for ArticleID $ArticleID",
        ) unless $Success;
    }

    return 'Created';
}

sub _ImportError {
    my ( $Self, %Param ) = @_;

    $Self->{Error} = $Param{Message} || '';

    if ( exists $Param{Ticket} ) {
        $Self->{LastTicketID} = undef;

        if ( $Param{Identifier} && $Param{Identifier}{TicketID} && $Param{Ticket}{TicketID} ) {
            $Self->{TicketIDRelation}{ $Param{Ticket}{TicketID} } = undef;
        }
        elsif ( $Param{Identifier} && $Param{Identifier}{TicketNumber} && $Param{Ticket}{TicketNumber} ) {
            $Self->{TicketNumberIDRelation}{ $Param{Ticket}{TicketNumber} } = undef;
        }
    }

    elsif ( exists $Param{Article} ) {
        my $ImportedTID = $Param{Article}{TicketID} ? $Self->{TicketIDRelation}{ $Param{Article}{TicketID} } : $Self->{LastTicketID};
        my $ExtraInfo   = $Param{Article}{TicketID} ? " Originial TicketID: $Param{Article}{TicketID};"      : '';
        $ExtraInfo     .= $ImportedTID               ? " Imported TicketID: $ImportedTID;"                 : '';
        $ExtraInfo     .= $Param{Article}{ArticleID} ? " Originial ArticleID: $Param{Article}{ArticleID};" : '';
        $Self->{Error} .= $ExtraInfo;
    }

    return;
}

sub _SynchronizeExtendedDBEntries {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ForeignDB}{DatabaseDSN} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need a DatabaseDSN in the ForeignDB settings',
        );

        return;
    }

    if ( !$Param{TicketID} || !( ( $Param{ArticleID} && $Param{ForeignArticleID} || $Param{ForeignTicketID} ) ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID and either ArticleID and ForeignArticleID or ForeignTicketID!',
        );

        return;
    }

    if ( !$Self->{FDBObject} || !$Self->{DBObject} ) {
        $Self->{DBObject}  = $Kernel::OM->Get('Kernel::System::DB');
        $Self->{FDBObject} = Kernel::System::DB->new(
            $Param{ForeignDB}->%*,
        );
    }

    if ( $Param{ArticleID} ) {

        # article_flag
        return unless $Self->{FDBObject}->Prepare(
            SQL  => 'SELECT create_by FROM article_flag WHERE article_id = ? AND article_key = ? AND article_value = ?',
            Bind => [ \$Param{ForeignArticleID}, \'Seen', \1 ],
        );

        while ( my @Row = $Self->{FDBObject}->FetchrowArray() ) {
            return unless $Self->{DBObject}->Do(
                SQL => 'INSERT INTO article_flag (article_id, article_key, article_value, create_time, create_by)' .
                    'VALUES (?, ?, ?, current_timestamp, ?)',
                Bind => [ \$Param{ArticleID}, \'Seen', \1, \$Row[0] ],
            );
        }

        # article_history
        return unless $Self->{FDBObject}->Prepare(
            SQL => 'SELECT name, history_type_id, type_id, queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by ' .
                'FROM ticket_history WHERE article_id = ?',
            Bind => [ \$Param{ForeignArticleID} ],
        );

        while ( my @Row = $Self->{FDBObject}->FetchrowArray() ) {
            return unless $Self->{DBObject}->Do(
                SQL =>
                    'INSERT INTO ticket_history (ticket_id, article_id, name, history_type_id, type_id, queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by)'
                    .
                    'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                Bind => [ \$Param{TicketID}, \$Param{ArticleID}, ( map { \$_ } @Row ) ],
            );
        }

        return 1;
    }

    # ticket_flag
    return unless $Self->{FDBObject}->Prepare(
        SQL  => 'SELECT create_by FROM ticket_flag WHERE ticket_id = ? AND ticket_key = ? AND ticket_value = ?',
        Bind => [ \$Param{ForeignTicketID}, \'Seen', \1 ],
    );

    while ( my @Row = $Self->{FDBObject}->FetchrowArray() ) {
        return unless $Self->{DBObject}->Do(
            SQL => 'INSERT INTO ticket_flag (ticket_id, ticket_key, ticket_value, create_time, create_by)' .
                'VALUES (?, ?, ?, current_timestamp, ?)',
            Bind => [ \$Param{TicketID}, \'Seen', \1, \$Row[0] ],
        );
    }

    # ticket_history
    return unless $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ticket_history WHERE ticket_id = ? AND (article_id IS NULL OR article_id = 0)',
        Bind => [ \$Param{TicketID} ],
    );

    $Kernel::OM->Get('Kernel::System::Ticket')->HistoryAdd(
        Name         => "\%\%Imported Ticket - Legacy TicketID: $Param{ForeignTicketID}",
        HistoryType  => 'Misc',
        TicketID     => $Param{TicketID},
        CreateUserID => 1,
    );

    return unless $Self->{FDBObject}->Prepare(
        SQL => 'SELECT name, history_type_id, type_id, queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by ' .
            'FROM ticket_history WHERE ticket_id = ? AND (article_id IS NULL OR article_id = 0)',
        Bind => [ \$Param{ForeignTicketID} ],
    );

    while ( my @Row = $Self->{FDBObject}->FetchrowArray() ) {
        return unless $Self->{DBObject}->Do(
            SQL =>
                'INSERT INTO ticket_history (ticket_id, name, history_type_id, type_id, queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by)'
                .
                'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            Bind => [ \$Param{TicketID}, ( map { \$_ } @Row ) ],
        );
    }

    # link_relation
    my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');
    my $ForeignTicketObjectID;

    my %ForeignLinkObjects;
    my %LObjectIDs;

    return unless $Self->{FDBObject}->Prepare(
        SQL  => "SELECT id,name FROM link_object ",
        Bind => [],
    );
    while ( my @Row = $Self->{FDBObject}->FetchrowArray() ) {
        $ForeignLinkObjects{ $Row[0] } = $Row[1];
        $LObjectIDs{ $Row[1] }         = $LinkObject->ObjectLookup(
            Name => $Row[1],
        );

        if ( $Row[1] eq 'Ticket' ) {
            $ForeignTicketObjectID = $Row[0];
        }
    }

    my %ForeignLinkTypes;
    my %LTypeIDs;

    return unless $Self->{FDBObject}->Prepare(
        SQL  => "SELECT id,name FROM link_type ",
        Bind => [],
    );
    while ( my @Row = $Self->{FDBObject}->FetchrowArray() ) {
        $ForeignLinkTypes{ $Row[0] } = $Row[1];
        $LTypeIDs{ $Row[1] }         = $LinkObject->TypeLookup(
            Name   => $Row[1],
            UserID => 1,
        );
    }

    my %Direction = (
        source => 'target',
        target => 'source',
    );

    for my $Key ( keys %Direction ) {

        return unless $Self->{FDBObject}->Prepare(
            SQL => "SELECT $Key" . "_object_id, $Key" . "_key, type_id, state_id FROM link_relation " .
                "WHERE $Direction{$Key}_object_id = ? AND $Direction{$Key}_key = ?",
            Bind => [ \$ForeignTicketObjectID, \$Param{ForeignTicketID} ],
        );

        LINK:
        while ( my @Row = $Self->{FDBObject}->FetchrowArray() ) {

            $Row[0] = $LObjectIDs{ $ForeignLinkObjects{ $Row[0] } };
            $Row[2] = $LTypeIDs{ $ForeignLinkTypes{ $Row[2] } };

            # deal with other imported tickets
            if ( $Row[0] == $LObjectIDs{Ticket} ) {
                next LINK if $Row[1] > $Param{ForeignTicketID};

                $Row[1] = exists $Self->{TicketIDRelation}{ $Row[1] } ? $Self->{TicketIDRelation}{ $Row[1] } : $Row[1];
            }

            return unless $Self->{DBObject}->Do(
                SQL =>
                    "INSERT INTO link_relation ($Direction{$Key}_object_id, $Direction{$Key}_key, $Key\_object_id, $Key\_key, type_id, state_id, create_time, create_by) " .
                    "VALUES (?, ?, ?, ?, ?, ?, current_timestamp, ?)",
                Bind => [ \$LObjectIDs{Ticket}, \$Param{TicketID}, ( map { \$_ } @Row ), \1 ],
            );
        }
    }

    # ticket_watcher
    # TODO

    # form_draft
    # TODO

    # calender_appointment_ticket
    # TODO

    return 1;
}

1;
