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

package Kernel::Modules::AgentElasticsearchQuickResult;
## nofilter(TidyAll::Plugin::OTOBO::Perl::DBObject)

use strict;
use warnings;

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
    my $Self = {%Param};
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
    my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my $ESObject              = $Kernel::OM->Get('Kernel::System::Elasticsearch');

    if ( $Self->{Subaction} eq 'SearchUpdate' ) {

        my $SearchObjects = $ConfigObject->Get('Elasticsearch::QuickSearchShow');

        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        # check module permissions to determine whether results can be shown
        my %Permission;
        MODULE:
        for my $Module (qw/AgentTicketZoom AdminCustomerCompany AdminCustomerUser AgentITSMConfigItemZoom/) {
            my $ModuleReg = $ConfigObject->Get('Frontend::Module')->{$Module};

            # module is not configured
            if ( !$ModuleReg ) {
                $Permission{$Module} = 0;
                next MODULE;
            }

            # no restrictions
            if ( ref $ModuleReg->{GroupRo} eq 'ARRAY' && !scalar @{ $ModuleReg->{GroupRo} } ) {
                $Permission{$Module} = 1;
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

                    $Permission{$Module} = 1;
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
                    $Permission{$Module} = 1;
                }
            }
        }

        # get objects
        my ( @TicketIDs, @CustomerKeys, @CustomerUserKeys, @ConfigItems );

        if ( $SearchObjects->{Ticket} && $SearchObjects->{Ticket}{Count} && $Permission{AgentTicketZoom} ) {

            # Search ticket by ES sort by age. Show $Size results (default to 10 in SysConfig)
            @TicketIDs = $ESObject->TicketSearch(
                Fulltext => $ParamObject->GetParam( Param => 'FulltextES' ),
                UserID   => $Self->{UserID},
                Limit    => $SearchObjects->{Ticket}{Count},
                Result   => 'FULL',
            );
        }

        if (
            $SearchObjects->{CustomerCompany}
            && $SearchObjects->{CustomerCompany}{Count}
            && $Permission{AdminCustomerCompany}
            )
        {
            # Search customer by ES.
            @CustomerKeys = $ESObject->CustomerCompanySearch(
                Fulltext => $ParamObject->GetParam( Param => 'FulltextES' ),
                Limit    => $SearchObjects->{CustomerCompany}{Count},
                Result   => 'ARRAY',
            );
        }

        if ( $SearchObjects->{CustomerUser} && $SearchObjects->{CustomerUser}{Count} && $Permission{AdminCustomerUser} )
        {
            # Search customer user by ES.
            @CustomerUserKeys = $ESObject->CustomerUserSearch(
                Fulltext => $ParamObject->GetParam( Param => 'FulltextES' ),
                Limit    => $SearchObjects->{CustomerUser}{Count},
                Result   => 'ARRAY',
            );
        }

        if ( $SearchObjects->{ConfigItem} && $SearchObjects->{ConfigItem}{Count} && $Permission{AgentITSMConfigItemZoom} )
        {
            # Search customer user by ES.
            @ConfigItems = $ESObject->ConfigItemSearch(
                Fulltext => $ParamObject->GetParam( Param => 'FulltextES' ),
                Limit    => $SearchObjects->{ConfigItem}{Count},
                Result   => 'FULL',
                UserID   => $Self->{UserID},
            );
        }

        # Start to fill the blockdata for the template
        if (@TicketIDs) {
            my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
            my %Queues      = $QueueObject->QueueList( Valid => 0 );

            for my $Attr ( @{ $SearchObjects->{Ticket}{Attributes} } ) {
                $LayoutObject->Block(
                    Name => 'TicketHeader',
                    Data => {
                        Header => $SearchObjects->{Ticket}{AttributeHeader}{$Attr},
                    },
                );
            }

            # Block ticket data
            for my $Ticket (@TicketIDs) {

                my ( $TicketID, $TicketParam ) = ( %{$Ticket} );

                $LayoutObject->Block(
                    Name => 'RecordTicket',
                    Data => {},
                );

                for my $Attr ( @{ $SearchObjects->{Ticket}{Attributes} } ) {

                    # prepare special attributes
                    if ( $Attr eq 'Age' ) {
                        $TicketParam->{Age} = $LayoutObject->CustomerAge(
                            Age   => $TicketParam->{Age},
                            Space => ' ',
                        );
                    }
                    elsif ( $Attr eq 'Created' ) {
                        my $CreatedFormat = $ConfigObject->Get('Elasticsearch::QuickSearchCreatedFormat');
                        if ($CreatedFormat) {
                            $TicketParam->{Created} = $Kernel::OM->Create(
                                'Kernel::System::DateTime',
                                ObjectParams => {
                                    Epoch => $TicketParam->{Created},
                                }
                            )->Format(
                                Format => $CreatedFormat,
                            );
                        }
                    }
                    elsif ( $Attr eq 'Queue' ) {
                        $TicketParam->{Queue} = $TicketParam->{Queue} // $Queues{ $TicketParam->{QueueID} };
                    }

                    # block entry
                    $LayoutObject->Block(
                        Name => 'TicketEntry',
                        Data => {
                            TicketID => $TicketID,
                            Title    => $TicketParam->{Title},
                            Entry    => $TicketParam->{$Attr},
                        },
                    );
                }
            }
        }

        if (@CustomerKeys) {
            for my $Attr ( @{ $SearchObjects->{CustomerCompany}{Attributes} } ) {
                $LayoutObject->Block(
                    Name => 'CompanyHeader',
                    Data => {
                        Header => $SearchObjects->{CustomerCompany}{AttributeHeader}{$Attr},
                    },
                );
            }

            # Block customer
            for my $CustomerKey (@CustomerKeys) {
                my %CustomerCompanyData = $CustomerCompanyObject->CustomerCompanyGet(
                    CustomerID => $CustomerKey,
                );

                $LayoutObject->Block(
                    Name => 'RecordCustomer',
                    Data => {},
                );

                for my $Attr ( @{ $SearchObjects->{CustomerCompany}{Attributes} } ) {

                    # block entry
                    $LayoutObject->Block(
                        Name => 'CompanyEntry',
                        Data => {
                            CustomerKey => $CustomerKey,
                            Entry       => $CustomerCompanyData{$Attr},
                        },
                    );
                }
            }
        }

        if (@CustomerUserKeys) {
            for my $Attr ( @{ $SearchObjects->{CustomerUser}{Attributes} } ) {
                $LayoutObject->Block(
                    Name => 'CustomerUserHeader',
                    Data => {
                        Header => $SearchObjects->{CustomerUser}{AttributeHeader}{$Attr},
                    },
                );
            }

            # Block customer user
            for my $CustomerUserKey (@CustomerUserKeys) {
                my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $CustomerUserKey,
                );

                $LayoutObject->Block(
                    Name => 'RecordCustomerUser',
                    Data => {},
                );

                for my $Attr ( @{ $SearchObjects->{CustomerUser}{Attributes} } ) {

                    # block entry
                    $LayoutObject->Block(
                        Name => 'CustomerUserEntry',
                        Data => {
                            CustomerUserKey => $CustomerUserKey,
                            Entry           => $CustomerUserData{$Attr},
                        },
                    );
                }
            }
        }

        if (@ConfigItems) {
            for my $Attr ( @{ $SearchObjects->{ConfigItem}{Attributes} } ) {
                $LayoutObject->Block(
                    Name => 'ConfigItemHeader',
                    Data => {
                        Header => $SearchObjects->{ConfigItem}{AttributeHeader}{$Attr},
                    },
                );
            }

            # Block ticket data
            for my $ConfigItem (@ConfigItems) {

                my ( $ConfigItemID, $ConfigItemParam ) = ( %{$ConfigItem} );

                $LayoutObject->Block(
                    Name => 'RecordConfigItem',
                    Data => {},
                );

                # block entries
                for my $Attr ( @{ $SearchObjects->{ConfigItem}{Attributes} } ) {
                    $LayoutObject->Block(
                        Name => 'ConfigItemEntry',
                        Data => {
                            ConfigItemID => $ConfigItemID,
                            Title        => $ConfigItemParam->{Title},
                            Entry        => $ConfigItemParam->{$Attr},
                        },
                    );
                }
            }
        }

        # Create output
        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentElasticsearchQuickResult',
            Data         => {
                %Param,
                Tickets       => scalar @TicketIDs,
                Companies     => scalar @CustomerKeys,
                CustomerUsers => scalar @CustomerUserKeys,
                ConfigItems   => scalar @ConfigItems,
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
        Content     => '<div/>',
        Type        => 'inline',
    );
}

1;
