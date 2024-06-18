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

package Kernel::System::CommunicationChannel::Email;

use strict;
use warnings;

use parent 'Kernel::System::CommunicationChannel::Base';

our @ObjectDependencies = (
    'Kernel::System::Ticket::Article::Backend::Email',
);

=head1 NAME

Kernel::System::CommunicationChannel::Email - email communication channel class

=head1 DESCRIPTION

This is a class for email communication channel.

=cut

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel::Email');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ArticleDataTables()

Returns list of communication channel article tables for backend data storage.

    my @ArticleDataTables = $ChannelObject->ArticleDataTables();

    @ArticleTables = (
        'article_data_mime',
        'article_data_mime_plain',
        'article_data_mime_attachment',
    );

=cut

sub ArticleDataTables {
    return (
        'article_data_mime',
        'article_data_mime_plain',
        'article_data_mime_attachment',
        'article_data_mime_send_error',
    );
}

=head2 ArticleDataArticleIDField()

Returns the name of the field used to link the channel article tables for backend data storage to
the main article table.

    my $ArticleIDField = $ChannelObject->ArticleDataArticleIDField();
    $ArticleIDField = 'article_id';

=cut

sub ArticleDataArticleIDField {
    return 'article_id';
}

=head2 ArticleBackend()

Returns communication channel article backend object.

    my $ArticleBackend = $ChannelObject->ArticleBackend();

This method will always return a valid object, so that you can chain-call on the return value like:

    $ChannelObject->ArticleBackend()->ArticleGet(...);

=cut

sub ArticleBackend {
    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');
}

=head2 PackageNameGet()

Returns name of the package that provides communication channel.

    my $PackageName = $ChannelObject->PackageNameGet();
    $PackageName = 'Framework';

=cut

sub PackageNameGet {
    return 'Framework';
}

1;
