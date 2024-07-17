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

package Kernel::Modules::CustomerElasticsearchQuickResult;
## nofilter(TidyAll::Plugin::OTOBO::Perl::DBObject)

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Modules::CustomerElasticsearchQuickResult - ticket search via Elasticsearch

=head1 DESCRIPTION

CustomerElasticsearchQuickResult returns n-number of tickets (defined by the sysconfig) from the ES-query sorted by descending age

=head2 new()

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

Quicksearch result is updated via AJAX.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ESObject              = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $DisableCompanyTickets = $ConfigObject->Get('Ticket::Frontend::CustomerDisableCompanyTicketAccess');

    my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');
    my $Count         = $SearchObjects->{Ticket} ? $SearchObjects->{Ticket}{Count} : 0;
    my $ESStrLength   = length $ParamObject->GetParam( Param => 'FulltextES' );

    # Subaction eq SearchUpdate is returned by on click and on input events of the ESfulltext-field. See Core.UI.Elasticsearch.js
    if ( $Self->{Subaction} eq 'SearchUpdate' && $ESStrLength > 1 && $Count ) {

        # Add filter for customer company if the company tickets are not disabled.
        my %Selection;
        if ( !$DisableCompanyTickets ) {
            my %AccessibleCustomers = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupContextCustomers(
                CustomerUserID => $Self->{UserID},
            );
            $Selection{CustomerIDRaw} = [ keys %AccessibleCustomers ];
        }
        else {
            $Selection{CustomerUserLoginRaw} = $Self->{UserID};
        }

        # Search ticket by ES sort by age. Show $Size results.
        my @TicketIDs = $ESObject->TicketSearch(
            %Selection,
            Fulltext       => $ParamObject->GetParam( Param => 'FulltextES' ),
            CustomerUserID => $Self->{UserID},
            Limit          => $Count,
            Permission     => 'ro',
            Result         => 'FULL',
        );

        # Block ticket data
        for my $Ticket (@TicketIDs) {

            # we only have one key and one value in each array element
            my ( $TicketID, $TicketParam ) = ( %{$Ticket} );

            $LayoutObject->Block(
                Name => 'Record',
                Data => {
                    TicketID => $TicketID,
                },
            );

            my $Age = $LayoutObject->CustomerAge(
                Age       => $TicketParam->{Age},
                Space     => ' ',
                CreatedAt => $TicketParam->{Created},
            );

            $LayoutObject->Block(
                Name => 'RecordTicketAge',
                Data => {
                    TicketID  => $TicketID,
                    TicketAge => $Age,
                },
            );

            $LayoutObject->Block(
                Name => 'RecordTicketNumber',
                Data => {
                    TicketID     => $TicketID,
                    TicketNumber => $TicketParam->{TicketNumber},
                },
            );
            $LayoutObject->Block(
                Name => 'RecordTicketTitle',
                Data => {
                    TicketID    => $TicketID,
                    TicketTitle => $TicketParam->{Title},
                },
            );
        }

        # Create output
        my $Output = $LayoutObject->Output(
            TemplateFile => 'CustomerElasticsearchQuickResult',
            Data         => \%Param,
        );

        #Return HTML-output back to callback function in Core.UI.Elasticsearch.js
        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Output || '',
            Type        => 'inline',
        );
    }

    return $LayoutObject->Attachment(
        NoCache     => 1,
        ContentType => 'text/html',
        Charset     => $LayoutObject->{UserCharset},
        Content     => '<div/>',
        Type        => 'inline',
    );
}

1;
