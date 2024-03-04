# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Ticket::ArticleFeatures;

use strict;
use warnings;

use parent qw(Kernel::System::EventHandler);
use File::Copy;
use utf8;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Ticket::ArticleFeatures - functions to manage ticket article edit and delete features

=head1 DESCRIPTION



=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ArticleFeaturesObject = $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'Ticket::EventModulePost',
    );

    return $Self;
}

=head2 IsArticleDeleted()

Return if article is Marked as Deleted.

    my $Success = $ArticleFeaturesObject->IsArticleDeleted(
        ArticleID => 123,   # required
        ReturnID  => 1, # optional
    );

Returns db success:

    $Success = 1; 1: If is deleted, 0: If is not

    or 

    $Success = 100; Deleted Version ID if param ReturnID is provided

=cut

sub IsArticleDeleted {
    my ( $Self, %Param ) = @_;

    foreach my $Needed ( qw(ArticleID) ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $IsDeleted;
    $Param{ReturnID} ||= '';

    $DBObject->Prepare( 
        SQL    => 'SELECT id FROM article_version WHERE source_article_id = ? AND article_delete = 1',
        Bind   => [ \$Param{ArticleID} ],
        Limit  => 1
    );

    ARTICLE:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $IsDeleted = $Param{ReturnID} ? $Row[0] : 1;
        last ARTICLE;
    }
    
    return $IsDeleted;
}

=head2 ArticleDelete()

Mark an article as Deleted.

    my $Success = $ArticleFeaturesObject->ArticleDelete(
        ArticleID => 123,   # required
        TicketID  => 100,   # required
        UserID    => 1,     # required
    );

Returns db success:

    $Success = 1; 1: If successful, 0: Error

=cut

sub ArticleDelete {
    my ( $Self, %Param ) = @_;


    foreach my $Needed ( qw(ArticleID TicketID UserID) ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $ArticleExists;

    #Check if article is already mark as deleted
    return if !$DBObject->Prepare(
        SQL   => 'SELECT id FROM article WHERE id = ?',
        Bind  => [ \$Param{ArticleID} ]
    );
    
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleExists = $Row[0];
    }

    return if !$ArticleExists;

    my $DeleteVersion = $Self->ArticleVersion(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID},
        UserID    => $Param{UserID},
        Delete    => 1
    );

    return if !$DeleteVersion;

    $DBObject->Do(
        SQL  => 'DELETE FROM article_data_mime_attachment WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ]
    );    

    $DBObject->Do(
        SQL  => 'DELETE FROM article_data_mime WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ]
    ); 

    $DBObject->Do(
        SQL  => 'DELETE FROM article_flag WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ]
    );     

    $DBObject->Do(
        SQL  => 'DELETE FROM article_search_index WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ]
    );  

    $DBObject->Do(
        SQL  => 'DELETE FROM ticket_history WHERE ticket_id = ? AND article_id = ?',
        Bind => [ \$Param{TicketID}, \$Param{ArticleID} ]
    );      

    $DBObject->Do(
        SQL  => 'DELETE FROM article_flag WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ]
    ); 

    my $Success = $DBObject->Do(
        SQL  => 'DELETE FROM article WHERE id = ?',
        Bind => [ \$Param{ArticleID} ]
    ); 

    if ( $Success ) {
        my $CacheKey = '_MetaArticleList::' . $Param{TicketID};

        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'Article',
            Key  => $CacheKey,
        );        
    }
    
    return $Success;
}


=head2 ArticleVersion()

Create an Article Version.

    my $Success = $ArticleFeaturesObject->ArticleVersion(
        ArticleID => 123,   # required
        UserID    => 1,     # required
        Delete    => 1,     # optional for delete process
    );

Returns db success:

    $Success = 1; 1: If successful, 0: Error

=cut

sub ArticleVersion {
    my ( $Self, %Param ) = @_;

    foreach my $Needed ( qw(ArticleID UserID) ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{Delete} ||= 0;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $NewArticleVersion;

    return if !$DBObject->Do(
        SQL => "INSERT INTO article_version (source_article_id, ticket_id, article_sender_type_id, communication_channel_id, is_visible_for_customer,
                search_index_needs_rebuild, insert_fingerprint, create_time, create_by, change_time, change_by, version_create_by, version_create_time, article_delete)
                SELECT id, ticket_id, article_sender_type_id, communication_channel_id, is_visible_for_customer,
                search_index_needs_rebuild, insert_fingerprint, create_time, create_by, change_time, change_by, $Param{UserID}, current_timestamp, $Param{Delete} FROM article where ID = ?",
        Bind => [ \$Param{ArticleID} ]
    );

    #Determine new article Version ID
    $DBObject->Prepare(
        SQL   => 'SELECT id FROM article_version WHERE source_article_id = ? ORDER BY id DESC',
        Bind  => [ \$Param{ArticleID} ],
        Limit => 1
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
      $NewArticleVersion = $Row[0];
    }

    return if !$NewArticleVersion;

    if ( $Param{Delete} ) {

        my $Success = $DBObject->Do(
            SQL  => "INSERT INTO ticket_history_version (history_id, article_id, name, history_type_id, ticket_id, source_article_id, type_id, 
                    queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by)
                    SELECT id,    $NewArticleVersion,    name, history_type_id, ticket_id, article_id, type_id, 
                    queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by FROM ticket_history WHERE ticket_id = ? AND article_id = ?",
            Bind => [ \$Param{TicketID}, \$Param{ArticleID} ]
        );

        #Rollback if error ocurrs when backing up article history
        if ( !$Success ) {
            $DBObject->Do(
                SQL  => "DELETE FROM article_version WHERE id = ?",
                Bind => [ \$NewArticleVersion ]
            ); 

           $DBObject->Do(
                SQL  => "DELETE FROM ticket_history WHERE id IN (SELECT MAX(th.id) FROM ticket_history th
                        INNER JOIN ticket_history_type tht ON tht.id = th.history_type_id AND tht.name = 'ArticleDelete'
                        WHERE th.ticket_id = ? AND article_id = ?)",
                Bind => [ \$Param{TicketID}, $Param{ArticleID} ]
           );

            $Kernel::OM->Get('Kernel::System::Log')->Log( 
                Priority     => 'error',
                Message     => 'There was an error trying to create article ticket history version!'
            );

            return;
        }        
    }    

    $DBObject->Do(
        SQL =>  "INSERT INTO article_data_mime_version (article_id, a_from, a_reply_to, a_to, a_cc, a_bcc, a_subject, a_message_id, a_message_id_md5, a_in_reply_to, a_references,
                a_content_type, a_body, incoming_time, content_path, create_time, create_by, change_time, change_by)
                SELECT $NewArticleVersion, a_from, a_reply_to, a_to, a_cc, a_bcc, a_subject, a_message_id, a_message_id_md5, a_in_reply_to, a_references,
                a_content_type, a_body, incoming_time, content_path, create_time, create_by, change_time, change_by 
                FROM article_data_mime
                WHERE article_id = ?",
        Bind => [ \$Param{ArticleID} ]
    );    

    $DBObject->Do(
        SQL =>  "INSERT INTO article_data_mime_attachment_version (article_id, filename, content_size, content_type, content_id, content_alternative, disposition, content,
                create_time, create_by, change_time, change_by)
                SELECT $NewArticleVersion, filename, content_size, content_type, content_id, content_alternative, disposition, content, create_time, create_by, change_time, change_by
                FROM article_data_mime_attachment
                WHERE article_id = ? ORDER BY id ASC",
        Bind => [ \$Param{ArticleID} ]
    );    

    $DBObject->Do(
        SQL =>  "INSERT INTO article_flag_version (article_id, article_key, article_value, create_time, create_by)
                SELECT $NewArticleVersion, article_key, article_value, create_time, create_by
                FROM article_flag
                WHERE article_id = ?",
        Bind => [ \$Param{ArticleID} ]
    ); 
    
    return $NewArticleVersion;
}

=head2 ArticleRestore()

Restore an article.

    my $Success = $ArticleFeaturesObject->ArticleRestore(
        ArticleID => 123,   # required
        TicketID  => 100,   # required
    );

Returns db success:

    $Success = 1; 1: If successful, 0: Error

=cut

sub ArticleRestore {
    my ( $Self, %Param ) = @_;


    foreach my $Needed ( qw(ArticleID TicketID) ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $ArticleID;
    my $ArticleVersionID;

    #Check if article was successfuly inserted
    $DBObject->Prepare(
        SQL   => 'SELECT id FROM article_version WHERE source_article_id = ? AND article_delete = 1',
        Bind  => [ \$Param{ArticleID} ],
        Limit => 1
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
      $ArticleVersionID = $Row[0];
    }    
    
    return if !$ArticleVersionID;

    return if !$DBObject->Do(
        SQL => "INSERT INTO article (id, ticket_id, article_sender_type_id, communication_channel_id, is_visible_for_customer,
                search_index_needs_rebuild, insert_fingerprint, create_time, create_by, change_time, change_by)
                SELECT source_article_id, ticket_id, article_sender_type_id, communication_channel_id, is_visible_for_customer,
                search_index_needs_rebuild, insert_fingerprint, create_time, create_by, change_time, change_by FROM article_version where source_article_id = ? and article_delete = 1",
        Bind => [ \$Param{ArticleID} ]
    );

    #Check if article was successfuly inserted
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM article WHERE id = ?',
        Bind  => [ \$Param{ArticleID} ],
        Limit => 1
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
      $ArticleID = $Row[0];
    }    

    return if !$ArticleID;

    $DBObject->Do(
        SQL =>  "INSERT INTO article_data_mime (article_id, a_from, a_reply_to, a_to, a_cc, a_bcc, a_subject, a_message_id, a_message_id_md5, a_in_reply_to, a_references,
                a_content_type, a_body, incoming_time, content_path, create_time, create_by, change_time, change_by)
                SELECT $ArticleID, a_from, a_reply_to, a_to, a_cc, a_bcc, a_subject, a_message_id, a_message_id_md5, a_in_reply_to, a_references,
                a_content_type, a_body, incoming_time, content_path, create_time, create_by, change_time, change_by 
                FROM article_data_mime_version
                WHERE article_id = ?",
        Bind => [ \$ArticleVersionID ]
    );    

    $DBObject->Do(
        SQL =>  "INSERT INTO article_data_mime_attachment (article_id, filename, content_size, content_type, content_id, content_alternative, disposition, content,
                create_time, create_by, change_time, change_by)
                SELECT $ArticleID, filename, content_size, content_type, content_id, content_alternative, disposition, content, create_time, create_by, change_time, change_by
                FROM article_data_mime_attachment_version
                WHERE article_id = ?",
        Bind => [ \$ArticleVersionID ]
    );    

    $DBObject->Do(
        SQL =>  "INSERT INTO article_flag (article_id, article_key, article_value, create_time, create_by)
                SELECT $ArticleID, article_key, article_value, create_time, create_by
                FROM article_flag_version
                WHERE article_id = ?",
        Bind => [ \$ArticleVersionID ]
    );    

    my $Success = $DBObject->Do(
        SQL  => "INSERT INTO ticket_history (id, article_id, name, history_type_id, ticket_id, type_id, 
                queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by)
                SELECT history_id,    $ArticleID,    name, history_type_id, ticket_id, type_id, 
                queue_id, owner_id, priority_id, state_id, create_time, create_by, change_time, change_by FROM ticket_history_version WHERE ticket_id = ? AND article_id = ?",
        Bind => [ \$Param{TicketID}, \$ArticleVersionID ]
    );    

    if ( $Success ) {

        $DBObject->Do(
            SQL  => "DELETE FROM ticket_history_version WHERE article_id = ?",
            Bind => [ \$ArticleVersionID ]
        ); 

        $DBObject->Do(
            SQL  => "DELETE FROM article_data_mime_attachment_version WHERE article_id = ?",
            Bind => [ \$ArticleVersionID ]
        );

        $DBObject->Do(
            SQL  => "DELETE FROM article_data_mime_version WHERE article_id = ?",
            Bind => [ \$ArticleVersionID ]
        ); 

        $DBObject->Do(
            SQL  => "DELETE FROM article_flag_version WHERE article_id = ?",
            Bind => [ \$ArticleVersionID ]
        );

        $DBObject->Do(
            SQL  => "DELETE FROM article_version WHERE id = ?",
            Bind => [ \$ArticleVersionID ]
        );                

        my $CacheKey = '_MetaArticleList::' . $Param{TicketID};

        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'Article',
            Key  => $CacheKey,
        );  

        $Kernel::OM->Get('Kernel::System::Ticket')->_TicketCacheClear( TicketID => $Param{TicketID} );
    }    
    
    return $Success;
}

=head2 ShowDeletedArticles()

Mark ticket for viewing deleted articles.

    my $Success = $ArticleFeaturesObject->ShowDeletedArticles(
        TicketID  => 100,   # required
        UserID    => 1,     # required
        GetStatus => 1,     # optional
    );

Returns db success:

    $Success = 1; 1: If successful, 0: Error
    
    or 
    $Success = 100; Flag ID: If for status Get

=cut

sub ShowDeletedArticles {
    my ( $Self, %Param ) = @_;

    foreach my $Needed ( qw(TicketID UserID) ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $IsMarked = 0;
    my $Success;
    $Param{GetStatus} ||= '';

    #Check if article is already mark as deleted
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM article_delete_flag
            WHERE ticket_id = ? AND user_id = ?
        ',
        Bind  => [ \$Param{TicketID}, \$Param{UserID} ],
        Limit => 1,
    );
  
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $IsMarked = $Row[0];
    }

    return $IsMarked if $Param{GetStatus};

    if ( $IsMarked ) {
        $Success = $DBObject->Do(
            SQL  => 'DELETE FROM article_delete_flag WHERE ticket_id = ? AND user_id = ?' ,
            Bind => [ \$Param{TicketID}, \$Param{UserID} ]
        );
    } else {
        $Success = $DBObject->Do(
            SQL  => 'INSERT INTO article_delete_flag (ticket_id, user_id) VALUES (?, ?)',
            Bind => [ \$Param{TicketID}, \$Param{UserID} ]
        );
    }
  
    return $Success;
}

=head2 VersionHistoryGet()

Return article version history.

    my $VersionHistory = $ArticleFeaturesObject->VersionHistoryGet(
        ArticleID => 123,   # required
        TicketID  => 100,   # required
    );

Returns:

    $Versions = {
        '1' => {
            CreateTime => '2023-12-01 08:00:00',
            FullName   => 'John Smith',
            CreateBy   => 5,
        }
    };

=cut

sub VersionHistoryGet {
    my ( $Self, %Param ) = @_;

    foreach my $Needed ( qw(TicketID ArticleID) ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my %Entries;

    $DBObject->Prepare(
        SQL => "SELECT sh.id, sh.version_create_time, usr.first_name, usr.last_name, sh.version_create_by
                FROM article_version sh, users usr WHERE 
                sh.ticket_id = ? AND sh.source_article_id = ? AND sh.create_by = usr.id AND sh.article_delete <> 1
                ORDER BY sh.id asc",
        Bind => [ \$Param{TicketID}, \$Param{ArticleID} ],
    );    

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Entries{$Row[0]} = {
            CreateTime => $Row[1],
            FullName   => "$Row[2] $Row[3]",
            CreateBy   => $Row[4],
        };
    }
    
    return \%Entries;
}

=head2 IsArticleEdited()

Return if article is edited.

    my $Success = $ArticleFeaturesObject->IsArticleEdited(
        ArticleID => 123,   # required
        TicketID  => 100,   # required
    );

Returns db success:

    $Success = 1; 1: If is edited, 0: If is not

=cut

sub IsArticleEdited {
    my ( $Self, %Param ) = @_;

    foreach my $Needed ( qw(TicketID ArticleID) ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $IsEdited = 0;

    $DBObject->Prepare(
        SQL  => "SELECT av.id
                 FROM article_version av WHERE 
                 av.ticket_id = ? AND av.source_article_id = ? and av.article_delete <> 1",
        Bind  => [ \$Param{TicketID}, \$Param{ArticleID} ],
        Limit => 1
    );    

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $IsEdited = 1;
    }
    
    return $IsEdited;
}

1;
