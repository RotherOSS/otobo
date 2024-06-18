# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package scripts::DBUpdateTo11_0::DBHandleArticleEditTables;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_0::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBHandleArticleEditTables - create tables for the article edit feature and add ticket history entries

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my @CreateTableXMLStrings;
    push @CreateTableXMLStrings, <<'END_SQL';
<!-- article version meta data -->
<Table Name="article_version">
    <Column Name="id" Required="true" AutoIncrement="true" PrimaryKey="true" Size="20" Type="BIGINT"></Column>
    <Column Name="ticket_id" Required="false" Size="20" Type="BIGINT"></Column>
    <Column Name="article_sender_type_id" Required="false" Size="6" Type="SMALLINT"></Column>
    <Column Name="communication_channel_id" Required="false" Size="20" Type="BIGINT"></Column>
    <Column Name="is_visible_for_customer" Required="false" Size="6" Type="SMALLINT"></Column>
    <Column Name="search_index_needs_rebuild" Required="false" Size="6" Type="SMALLINT"></Column>
    <Column Name="insert_fingerprint" Required="false" Size="64" Type="VARCHAR"></Column>
    <Column Name="create_time" Required="false" Type="DATE"></Column>
    <Column Name="create_by" Required="false" Size="11" Type="INTEGER"></Column>
    <Column Name="change_time" Required="false" Type="DATE"></Column>
    <Column Name="change_by" Required="false" Size="11" Type="INTEGER"></Column>
    <Column Name="source_article_id" Required="true" Size="20" Type="BIGINT"></Column>
    <Column Name="version_create_by" Required="true" Size="11" Type="INTEGER"></Column>
    <Column Name="version_create_time" Required="true" Type="DATE"></Column>
    <Column Name="article_delete" Required="false" Size="1" Type="INTEGER"></Column>
    <Index Name="article_version_article_sender_type_id">
        <IndexColumn Name="article_sender_type_id">
        </IndexColumn>
    </Index>
    <Index Name="article_version_communication_channel_id">
        <IndexColumn Name="communication_channel_id">
        </IndexColumn>
    </Index>
    <Index Name="article_version_search_index_needs_rebuild">
        <IndexColumn Name="search_index_needs_rebuild">
        </IndexColumn>
    </Index>
    <Index Name="article_version_ticket_id">
        <IndexColumn Name="ticket_id">
        </IndexColumn>
    </Index>
    <Index Name="article_version_create_by_id">
        <IndexColumn Name="create_by">
        </IndexColumn>
    </Index>
    <Index Name="article_version_change_by_id">
        <IndexColumn Name="change_by">
        </IndexColumn>
    </Index>
    <Index Name="article_version_version_create_by_id">
        <IndexColumn Name="version_create_by">
        </IndexColumn>
    </Index>
    <ForeignKey ForeignTable="article_sender_type">
        <Reference Foreign="id" Local="article_sender_type_id">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="change_by">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="communication_channel">
        <Reference Foreign="id" Local="communication_channel_id">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="create_by">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="ticket">
        <Reference Foreign="id" Local="ticket_id">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="version_create_by">
        </Reference>
    </ForeignKey>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="article_flag_version">
    <Column Name="article_id" Required="true" Size="20" Type="BIGINT"></Column>
    <Column Name="article_key" Required="true" Size="50" Type="VARCHAR"></Column>
    <Column Name="article_value" Required="true" Size="50" Type="VARCHAR"></Column>
    <Column Name="create_time" Required="true" Type="DATE"></Column>
    <Column Name="create_by" Required="true" Size="11" Type="INTEGER"></Column>
    <Index Name="article_flag_version_article_id">
        <IndexColumn Name="article_id">
        </IndexColumn>
    </Index>
    <Index Name="article_flag_version_article_id_create_by">
        <IndexColumn Name="article_id">
        </IndexColumn>
        <IndexColumn Name="create_by">
        </IndexColumn>
    </Index>
    <Index Name="article_flag_version_create_by_id">
        <IndexColumn Name="create_by">
        </IndexColumn>
    </Index>
    <ForeignKey ForeignTable="article_version">
        <Reference Foreign="id" Local="article_id">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="create_by">
        </Reference>
    </ForeignKey>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="article_data_mime_version">
    <Column Name="id" Required="true" AutoIncrement="true" PrimaryKey="true" Size="20" Type="BIGINT"></Column>
    <Column Name="article_id" Required="true" Size="20" Type="BIGINT"></Column>
    <Column Name="a_from" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="a_reply_to" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="a_to" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="a_cc" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="a_bcc" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="a_subject" Required="false" Size="300" Type="VARCHAR"></Column>
    <Column Name="a_message_id" Required="false" Size="300" Type="VARCHAR"></Column>
    <Column Name="a_message_id_md5" Required="false" Size="32" Type="VARCHAR"></Column>
    <Column Name="a_in_reply_to" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="a_references" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="a_content_type" Required="false" Size="250" Type="VARCHAR"></Column>
    <Column Name="a_body" Required="false" Size="65536" Type="VARCHAR"></Column>
    <Column Name="incoming_time" Required="true" Size="11" Type="INTEGER"></Column>
    <Column Name="content_path" Required="false" Size="250" Type="VARCHAR"></Column>
    <Column Name="create_time" Required="true" Type="DATE"></Column>
    <Column Name="create_by" Required="true" Size="11" Type="INTEGER"></Column>
    <Column Name="change_time" Required="true" Type="DATE"></Column>
    <Column Name="change_by" Required="true" Size="11" Type="INTEGER"></Column>
    <Index Name="article_data_mime_version_article_id">
        <IndexColumn Name="article_id">
        </IndexColumn>
    </Index>
    <Index Name="article_data_mime_version_message_id_md5">
        <IndexColumn Name="a_message_id_md5">
        </IndexColumn>
    </Index>
    <Index Name="article_data_mime_version_create_by_id">
        <IndexColumn Name="create_by">
        </IndexColumn>
    </Index>
    <Index Name="article_data_mime_version_change_by_id">
        <IndexColumn Name="change_by">
        </IndexColumn>
    </Index>
    <ForeignKey ForeignTable="article_version">
        <Reference Foreign="id" Local="article_id">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="change_by">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="create_by">
        </Reference>
    </ForeignKey>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="article_data_mime_att_version">
    <Column Name="id" Required="true" AutoIncrement="true" PrimaryKey="true" Size="20" Type="BIGINT"></Column>
    <Column Name="article_id" Required="true" Size="20" Type="BIGINT"></Column>
    <Column Name="filename" Required="false" Size="250" Type="VARCHAR"></Column>
    <Column Name="content_size" Required="false" Size="30" Type="VARCHAR"></Column>
    <Column Name="content_type" Required="false" Size="300" Type="VARCHAR"></Column>
    <Column Name="content_id" Required="false" Size="250" Type="VARCHAR"></Column>
    <Column Name="content_alternative" Required="false" Size="50" Type="VARCHAR"></Column>
    <Column Name="disposition" Required="false" Size="15" Type="VARCHAR"></Column>
    <Column Name="content" Required="false" Type="LONGBLOB"></Column>
    <Column Name="create_time" Required="true" Type="DATE"></Column>
    <Column Name="create_by" Required="true" Size="11" Type="INTEGER"></Column>
    <Column Name="change_time" Required="true" Type="DATE"></Column>
    <Column Name="change_by" Required="true" Size="11" Type="INTEGER"></Column>
    <Index Name="article_data_mime_att_version_article_id">
        <IndexColumn Name="article_id">
        </IndexColumn>
    </Index>
    <Index Name="article_data_mime_att_version_create_by_id">
        <IndexColumn Name="create_by">
        </IndexColumn>
    </Index>
    <Index Name="article_data_mime_att_version_change_by_id">
        <IndexColumn Name="change_by">
        </IndexColumn>
    </Index>
    <ForeignKey ForeignTable="article_version">
        <Reference Foreign="id" Local="article_id">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="change_by">
        </Reference>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Foreign="id" Local="create_by">
        </Reference>
    </ForeignKey>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="article_version_history">
    <Column Name="id" Required="true" AutoIncrement="true" PrimaryKey="true" Size="20" Type="BIGINT"></Column>
    <Column Name="history_id" Required="true" Size="20" Type="BIGINT"></Column>
    <Column Name="article_id" Required="true" Size="20" Type="BIGINT"></Column>
    <Index Name="article_version_history_article_id">
        <IndexColumn Name="article_id">
        </IndexColumn>
    </Index>
    <Index Name="article_version_history_history_id">
        <IndexColumn Name="history_id">
        </IndexColumn>
    </Index>
    <ForeignKey ForeignTable="ticket_history">
        <Reference Foreign="id" Local="history_id">
        </Reference>
    </ForeignKey>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="time_accounting_version">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
    <Column Name="ticket_id" Required="true" Type="BIGINT"/>
    <Column Name="article_id" Required="false" Type="BIGINT"/>
    <Column Name="time_unit" Required="true" Size="10,2"  Type="DECIMAL"/>
    <Column Name="create_time" Required="true" Type="DATE"/>
    <Column Name="create_by" Required="true" Type="INTEGER"/>
    <Column Name="change_time" Required="true" Type="DATE"/>
    <Column Name="change_by" Required="true" Type="INTEGER"/>
    <Index Name="time_accounting_ticket_id">
        <IndexColumn Name="ticket_id"/>
    </Index>
    <ForeignKey ForeignTable="ticket">
        <Reference Local="ticket_id" Foreign="id"/>
    </ForeignKey>
    <ForeignKey ForeignTable="article_version">
        <Reference Local="article_id" Foreign="id"/>
    </ForeignKey>
    <ForeignKey ForeignTable="users">
        <Reference Local="create_by" Foreign="id"/>
        <Reference Local="change_by" Foreign="id"/>
    </ForeignKey>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Insert Table="ticket_history_type">
    <Data Key="id" Type="AutoIncrement">52</Data>
    <Data Key="name" Type="Quote">ArticleDynamicFieldUpdate</Data>
    <Data Key="valid_id">1</Data>
    <Data Key="create_time">current_timestamp</Data>
    <Data Key="create_by">1</Data>
    <Data Key="change_time">current_timestamp</Data>
    <Data Key="change_by">1</Data>
</Insert>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Insert Table="ticket_history_type">
    <Data Key="id" Type="AutoIncrement">53</Data>
    <Data Key="name" Type="Quote">ArticleEdit</Data>
    <Data Key="valid_id">1</Data>
    <Data Key="create_time">current_timestamp</Data>
    <Data Key="create_by">1</Data>
    <Data Key="change_time">current_timestamp</Data>
    <Data Key="change_by">1</Data>
</Insert>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Insert Table="ticket_history_type">
    <Data Key="id" Type="AutoIncrement">54</Data>
    <Data Key="name" Type="Quote">ArticleRestore</Data>
    <Data Key="valid_id">1</Data>
    <Data Key="create_time">current_timestamp</Data>
    <Data Key="create_by">1</Data>
    <Data Key="change_time">current_timestamp</Data>
    <Data Key="change_by">1</Data>
</Insert>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Insert Table="ticket_history_type">
    <Data Key="id" Type="AutoIncrement">55</Data>
    <Data Key="name" Type="Quote">ArticleDelete</Data>
    <Data Key="valid_id">1</Data>
    <Data Key="create_time">current_timestamp</Data>
    <Data Key="create_by">1</Data>
    <Data Key="change_time">current_timestamp</Data>
    <Data Key="change_by">1</Data>
</Insert>
END_SQL

    # The table structure has not changed.
    # So the tables can simply be kept when they already existed in the source system.
    return unless $Self->ExecuteXMLDBArray(
        XMLArray => \@CreateTableXMLStrings,
    );

    return 1;
}

1;
