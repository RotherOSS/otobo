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

package Kernel::Modules::AgentTicketAttachment;
## nofilter(TidyAll::Plugin::OTOBO::Perl::Print)

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get ArticleID
    my $TicketID  = $ParamObject->GetParam( Param => 'TicketID' );
    my $ArticleID = $ParamObject->GetParam( Param => 'ArticleID' );
    my $FileID    = $ParamObject->GetParam( Param => 'FileID' );

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    # check params
    if ( !$FileID || !$ArticleID || !$TicketID ) {
        $LogObject->Log(
            Message  => 'FileID, TicketID and ArticleID are needed!',
            Priority => 'error',
        );
        return $LayoutObject->ErrorScreen();
    }

    my $TicketNumber = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup(
        TicketID => $TicketID,
    );

    # get needed objects
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    # check permissions
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );

    # check permissions
    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID},
    );
    if ( !$Access ) {

        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # get a attachment
    my %Data = $ArticleBackendObject->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID    => $FileID,
    );
    if ( !%Data ) {
        $LogObject->Log(
            Message  => "No such attachment ($FileID).",
            Priority => 'error',
        );
        return $LayoutObject->ErrorScreen();
    }

    my $Viewers = $ParamObject->GetParam( Param => 'Viewer' ) || 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # find viewer for ContentType
    my $Viewer = '';
    if ( $Viewers && $ConfigObject->Get('MIME-Viewer') ) {
        for ( sort keys %{ $ConfigObject->Get('MIME-Viewer') } ) {
            if ( $Data{ContentType} =~ /^$_/i ) {
                $Viewer = $ConfigObject->Get('MIME-Viewer')->{$_};
                $Viewer =~ s/\<OTOBO_CONFIG_(.+?)\>/$ConfigObject->{$1}/g;
            }
        }
    }

    # show with viewer
    if ( $Viewers && $Viewer ) {

        # write tmp file
        my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');
        my ( $FH, $Filename ) = $FileTempObject->TempFile();
        if ( open my $ViewerDataFH, '>', $Filename ) {    ## no critic qw(OTOBO::ProhibitOpen)
            print $ViewerDataFH $Data{Content};
            close $ViewerDataFH;
        }
        else {

            # log error
            $LogObject->Log(
                Priority => 'error',
                Message  => "Cant write $Filename: $!",
            );

            return $LayoutObject->ErrorScreen();
        }

        # use viewer
        my $Content = '';
        if ( open my $ViewerFH, '-|', "$Viewer $Filename" ) {    ## no critic qw(OTOBO::ProhibitOpen)
            while (<$ViewerFH>) {
                $Content .= $_;
            }
            close $ViewerFH;
        }
        else {
            return $LayoutObject->FatalError(
                Message => "Can't open: $Viewer $Filename: $!",
            );
        }

        # return new page
        return $LayoutObject->Attachment(
            %Data,
            ContentType => 'text/html',
            Content     => $Content,
            Type        => 'inline',
            Sandbox     => 1,
        );
    }

    # download it AttachmentDownloadType is configured
    return $LayoutObject->Attachment(
        %Data,
        Sandbox => 1,
    );
}

1;
