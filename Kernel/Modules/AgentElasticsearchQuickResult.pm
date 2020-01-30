# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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


## nofilter(TidyAll::Plugin::OTOBO::Perl::DBObject)
package Kernel::Modules::AgentElasticsearchQuickResult;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Modules::AgentElasticsearchQuickResult - ticket search via Elasticsearch

=head1 DESCRIPTION

AgentElasticsearchQuickResult returns n-number of tickets, customer, and customer user (defined by the sysconfig) from the ES-query sorted by descending age

=head2 new()

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

Quicksearch result is updated via AJAX.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
    my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my $ESObject              = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $Count                 = $ConfigObject->Get('Elasticsearch::QuickSearchSettings')->{'TicketResultCount'};

    if ( $Self->{Subaction} eq 'SearchUpdate' ) {
        
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        # check module permissions to determine whether results can be shown
        my %Permission;
        MODULE:
        for my $Module ( qw/AgentTicketZoom AdminCustomerCompany AdminCustomerUser/ ) {
            my $ModuleReg = $ConfigObject->Get('Frontend::Module')->{ $Module };

            # module is not configured
            if ( !$ModuleReg ) {
                $Permission{ $Module } = 0;
                next MODULE;
            }

            # no restrictions
            if ( ref $ModuleReg->{GroupRo} eq 'ARRAY' && !scalar @{ $ModuleReg->{GroupRo} } ) {
                $Permission{ $Module } = 1;
                next MODULE;
            }

            next MODULE if !$ModuleReg->{GroupRo};

            if ( ref $ModuleReg->{GroupRo} eq 'ARRAY' ) {
                INNER:
                for my $GroupName ( @{ $ModuleReg->{GroupRo} } ) {
                    next INNER if !$GroupName;
                    next INNER if !$GroupObject->PermissionCheck(
                        UserID    => $Self->{UserID},
                        GroupName => $GroupName,
                        Type      => 'ro',
                    );
                    
                    $Permission{ $Module } = 1;
                    next MODULE;
                }
            }
            else {
                my $HasPermission = $GroupObject->PermissionCheck(
                    UserID    => $Self->{UserID},
                    GroupName => $ModuleReg->{GroupRo},
                    Type      => 'ro',

                );
                if ($HasPermission) {
                    $Permission{ $Module } = 1;
                }
            }
        }

        # get objects
        my ( @TicketIDs, @CustomerIDs, @CustomerUserIDs );

        if ( $Permission{AgentTicketZoom} ) {
            # Search ticket by ES sort by age. Show $Size results (default to 10 in SysConfig)
            @TicketIDs = $ESObject->TicketSearch(
                Fulltext            => $ParamObject->GetParam( Param => 'FulltextES' ),
                UserID              => $Self->{UserID},
                Limit               => $Count,
                Result              => 'FULL',
            );
        }

        if ( $Permission{AdminCustomerCompany} ) {
            # Search customer by ES.
            @CustomerIDs = $ESObject->CustomerCompanySearch(
                IndexName => 'customer',
                Fulltext  => $ParamObject->GetParam( Param => 'FulltextES' ),
                Limit     => $Count,
                Result    => 'ARRAY',
            );
        }

        if ( $Permission{AdminCustomerUser} ) {
            # Search customer user by ES.
            @CustomerUserIDs = $ESObject->CustomerUserSearch(
                IndexName => 'customeruser',
                Fulltext  => $ParamObject->GetParam( Param => 'FulltextES' ),
                Limit     => $Count,
                Result    => 'ARRAY',
            );
        }

        # Start to fill the blockdata for the template (See Kernel/Output/HTML/Templates/Standard/AgentElasticsearchQuickResult.tt)
        if ( @TicketIDs ) {
            # Block ticket data
            for my $Ticket (@TicketIDs) {
        
                #my %TicketParam = $TicketObject->TicketGet( TicketID => $TicketID );
                my ( $TicketID, $TicketParam ) = ( %{ $Ticket } );
        
                $LayoutObject->Block(
                    Name => 'Record',
                    Data => {
                        TicketID => $TicketID,
                    },
                );
        
                my $Age = $LayoutObject->CustomerAge(
                    Age   => $TicketParam->{Age},
                    Space => ' ',
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
        }

        if ( @CustomerIDs ) {
            # Block customer
            for my $CustomerID (@CustomerIDs) {
                $LayoutObject->Block(
                    Name => 'RecordCustomer',
                    Data => {
                        CustomerID => $CustomerID,
                    },
                );
        
                my %CustomerCompanyData = $CustomerCompanyObject->CustomerCompanyGet(
                    CustomerID => $CustomerID,
                );
                $LayoutObject->Block(
                    Name => 'RecordCustomerCompanyName',
                    Data => {
                        CustomerCompanyName => $CustomerCompanyData{CustomerCompanyName},
                        CustomerID          => $CustomerID,
                    },
                );
        
                $LayoutObject->Block(
                    Name => 'RecordCustomerCompanyComment',
                    Data => {
                        CustomerCompanyComment => $CustomerCompanyData{CustomerCompanyComment},
                        CustomerID             => $CustomerID,
                    },
                );
        
                $LayoutObject->Block(
                    Name => 'RecordCustomerCompanyID',
                    Data => {
                        CustomerID => $CustomerID,
                    },
                );
        
            }
        }

        if ( @CustomerUserIDs ) {
            # Block customer user
            for my $CustomerUserID (@CustomerUserIDs) {
                my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $CustomerUserID,
                );
        
                $LayoutObject->Block(
                    Name => 'RecordCustomerUser',
                    Data => {
                        CustomerUserID => $CustomerUserID,
                    },
                );
        
                $LayoutObject->Block(
                    Name => 'RecordCustomerUserID',
                    Data => {
                        CustomerUserID => $CustomerUserID,
                    },
                );
        
                $LayoutObject->Block(
                    Name => 'RecordCustomerUserName',
                    Data => {
                        CustomerUserName => $CustomerUserData{UserFullname},
                        CustomerUserID   => $CustomerUserID,
                    },
                );
        
                $LayoutObject->Block(
                    Name => 'RecordCustomerUserCompany',
                    Data => {
                        CustomerUserCompany => $CustomerUserData{CustomerCompanyName},
                        CustomerID          => $CustomerUserData{CustomerID},
                    },
                );
        
            }
        }

        # Create output
        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentElasticsearchQuickResult',
            Data         => {
                %Param,
                Tickets       => scalar @TicketIDs,
                Companies     => scalar @CustomerIDs,
                CustomerUsers => scalar @CustomerUserIDs,
            }
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
        Content     => '',
        Type        => 'inline',
    );
}

1;
