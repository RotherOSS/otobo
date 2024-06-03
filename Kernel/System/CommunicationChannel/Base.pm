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

package Kernel::System::CommunicationChannel::Base;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::CommunicationChannel::Base - base class for communication channels

=head1 DESCRIPTION

This is a base class for communication channels and should not be instantiated directly.

    package Kernel::CommunicationChannel::MyChannel;
    use parent 'Kernel::CommunicationChannel::Base';

    # methods go here

=cut

=head1 PUBLIC INTERFACE

=head2 new()

Do not instantiate this class, instead use the real communication channel sub classes.
Also, don't use the constructor directly, use the ObjectManager instead:

    my $ChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel::MyChannel');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Die if someone tries to instantiate the base class.
    if ( $Type eq __PACKAGE__ ) {
        die 'Virtual method in base class must not be called.';
    }

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ArticleDataTables()

Returns list of communication channel article tables for backend data storage. All backends must
implement this method.

    my @ArticleDataTables = $ChannelObject->ArticleDataTables();

    @ArticleTables = (
        'article_data_mime',
        'article_data_mime_plain',
        'article_data_mime_attachment',
    );

=cut

sub ArticleDataTables {
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleDataArticleIDField()

Returns the name of the field used to link the channel article tables for backend data storage to
the main article table.

    my $ArticleIDField = $ChannelObject->ArticleDataArticleIDField();
    $ArticleIDField = 'article_id';

=cut

sub ArticleDataArticleIDField {
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleBackend()

Returns communication channel article backend object. Override this method in your class.

    my $ArticleBackend = $ChannelObject->ArticleBackend();

This method will always return a valid object, so that you can chain-call on the return value like:

    $ChannelObject->ArticleBackend()->ArticleGet(...);

=cut

sub ArticleBackend {
    die 'Virtual method in base class must not be called.';
}

=head2 PackageNameGet()

Returns name of the package that provides communication channel. Override this method in your class.

    my $PackageName = $ChannelObject->PackageNameGet();
    $PackageName = 'MyPackage';

=cut

sub PackageNameGet {
    die 'Virtual method in base class must not be called.';
}

1;
