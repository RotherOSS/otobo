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

package Kernel::Modules::CustomerTicketOverview;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);
use Kernel::Language              qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # disable output of customer company tickets
    my $DisableCompanyTickets = $ConfigObject->Get('Ticket::Frontend::CustomerDisableCompanyTicketAccess');

    # check subaction
    if ( !$Self->{Subaction} ) {
        return $LayoutObject->Redirect(
            OP => 'Action=CustomerTicketOverview;Subaction=MyTickets',
        );
    }
    elsif ( $Self->{Subaction} eq 'CompanyTickets' && $DisableCompanyTickets ) {
        return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
    }

    # check needed CustomerID
    if ( !$Self->{UserCustomerID} ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => Translatable('Need CustomerID!'),
        );
        $Output .= $LayoutObject->CustomerFooter();

        return $Output;
    }

    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    my $SortBy         = $ParamObject->GetParam( Param => 'SortBy' )  || 'Age';
    my $OrderByCurrent = $ParamObject->GetParam( Param => 'OrderBy' ) || 'Down';
    my $Fulltext       = $ParamObject->GetParam( Param => 'Fulltext' );

    # filter definition
    my %Filters = (
        MyTickets => {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    CustomerUserLoginRaw => $Self->{UserID},
                    OrderBy              => $OrderByCurrent,
                    SortBy               => $SortBy,
                    CustomerUserID       => $Self->{UserID},
                    Permission           => 'ro',
                },
            },
            Open => {
                Name   => 'Open',
                Prio   => 1100,
                Search => {
                    CustomerUserLoginRaw => $Self->{UserID},
                    StateType            => 'CustomerOpen',
                    OrderBy              => $OrderByCurrent,
                    SortBy               => $SortBy,
                    CustomerUserID       => $Self->{UserID},
                    Permission           => 'ro',
                },
            },
            Closed => {
                Name   => 'Closed',
                Prio   => 1200,
                Search => {
                    CustomerUserLoginRaw => $Self->{UserID},
                    StateType            => 'CustomerClosed',
                    OrderBy              => $OrderByCurrent,
                    SortBy               => $SortBy,
                    CustomerUserID       => $Self->{UserID},
                    Permission           => 'ro',
                },
            },
        },
    );

    my $UserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    my @CustomerIDs;

    # Add filter for customer company if the company tickets are not disabled.
    if ( !$DisableCompanyTickets ) {
        my %AccessibleCustomers = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupContextCustomers(
            CustomerUserID => $Self->{UserID},
        );

        # Show customer companies as additional filter selection.
        if ( $Self->{Subaction} eq 'CompanyTickets' && scalar keys %AccessibleCustomers > 1 ) {

            @CustomerIDs = $ParamObject->GetArray( Param => 'CustomerIDs' );

            # Prevent array item duplication.
            my %CustomerIDsHash = map { $_ => 1 } @CustomerIDs;
            @CustomerIDs = sort keys %CustomerIDsHash;

            $Param{CustomerIDStrg} = $LayoutObject->BuildSelection(
                Data       => \%AccessibleCustomers,
                Name       => 'CustomerIDs',
                Multiple   => 1,
                Size       => 1,
                SelectedID => \@CustomerIDs,
                Class      => 'Modernize',
            );

            # Remember the active customer ID filter.
            $Param{CustomerIDs} = '';
            for my $CustomerID (@CustomerIDs) {
                $Param{CustomerIDs} .= ';CustomerIDs=' . $LayoutObject->LinkEncode($CustomerID);
            }
        }
        else {

            # Default behavior - use all available customer IDs.
            @CustomerIDs = sort keys %AccessibleCustomers;
        }

        $Filters{CompanyTickets} = {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    CustomerIDRaw  => \@CustomerIDs,
                    OrderBy        => $OrderByCurrent,
                    SortBy         => $SortBy,
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
            Open => {
                Name   => 'Open',
                Prio   => 1100,
                Search => {
                    CustomerIDRaw  => \@CustomerIDs,
                    StateType      => 'CustomerOpen',
                    OrderBy        => $OrderByCurrent,
                    SortBy         => $SortBy,
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
            Closed => {
                Name   => 'Closed',
                Prio   => 1200,
                Search => {
                    CustomerIDRaw  => \@CustomerIDs,
                    StateType      => 'CustomerClosed',
                    OrderBy        => $OrderByCurrent,
                    SortBy         => $SortBy,
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
        };
    }

    if ( $Self->{Subaction} eq 'Search' ) {

        # check whether company tickets are shown
        my %Selection = @CustomerIDs
            ?
            ( CustomerIDRaw => \@CustomerIDs )
            :
            ( CustomerUserLoginRaw => $Self->{UserID} );

        $Filters{Search} = {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    %Selection,
                    OrderBy             => $OrderByCurrent,
                    SortBy              => $SortBy,
                    CustomerUserID      => $Self->{UserID},
                    Permission          => 'ro',
                    Fulltext            => $Fulltext,
                    FullTextIndex       => 1,
                    ContentSearchPrefix => '*',
                    ContentSearchSuffix => '*',
                },
            },
            Open => {
                Name   => 'Open',
                Prio   => 1100,
                Search => {
                    %Selection,
                    StateType           => 'CustomerOpen',
                    OrderBy             => $OrderByCurrent,
                    SortBy              => $SortBy,
                    CustomerUserID      => $Self->{UserID},
                    Permission          => 'ro',
                    Fulltext            => $Fulltext,
                    FullTextIndex       => 1,
                    ContentSearchPrefix => '*',
                    ContentSearchSuffix => '*',
                },
            },
            Closed => {
                Name   => 'Closed',
                Prio   => 1200,
                Search => {
                    %Selection,
                    StateType           => 'CustomerClosed',
                    OrderBy             => $OrderByCurrent,
                    SortBy              => $SortBy,
                    CustomerUserID      => $Self->{UserID},
                    Permission          => 'ro',
                    Fulltext            => $ParamObject->GetParam( Param => 'Fulltext' ),
                    FullTextIndex       => 1,
                    ContentSearchPrefix => '*',
                    ContentSearchSuffix => '*',
                },
            },
        };
    }

    my $FilterCurrent = $ParamObject->GetParam( Param => 'Filter' );
    if ( !$FilterCurrent ) {
        $FilterCurrent = ( $Self->{Subaction} && $Self->{Subaction} eq 'Search' ) ? 'All' : 'Open';
    }

    # check if filter is valid
    if ( !$Filters{ $Self->{Subaction} }->{$FilterCurrent} ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Invalid Filter: %s!', $FilterCurrent ),
        );
        $Output .= $LayoutObject->CustomerFooter();

        return $Output;
    }

    # check if archive search is allowed, otherwise search for all tickets
    my %SearchInArchive;
    if (
        $ConfigObject->Get('Ticket::ArchiveSystem')
        && !$ConfigObject->Get('Ticket::CustomerArchiveSystem')
        )
    {
        $SearchInArchive{ArchiveFlags} = [ 'y', 'n' ];
    }

    my %NavBarFilter;
    my $Counter         = 0;
    my $AllTickets      = 0;
    my $AllTicketsTotal = 0;
    my $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');

    for my $Filter ( sort keys %{ $Filters{ $Self->{Subaction} } } ) {
        $Counter++;

        my $Count = $TicketObject->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{$Filter}->{Search} },
            %SearchInArchive,
            Result => 'COUNT',
        ) || 0;

        my $ClassA = '';
        if ( $Filter eq $FilterCurrent ) {
            $ClassA     = 'Selected';
            $AllTickets = $Count;
        }
        if ( $Filter eq 'All' ) {
            $AllTicketsTotal = $Count;
        }
        $NavBarFilter{ $Filters{ $Self->{Subaction} }->{$Filter}->{Prio} } = {
            %{ $Filters{ $Self->{Subaction} }->{$Filter} },
            Count  => $Count,
            Filter => $Filter,
            ClassA => $ClassA,
        };
    }

    my $StartHit  = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    my $PageShown = $Self->{UserShowTickets} || 1;
    my $TicketListHTML;
    my %PageNav;

    if ( !$AllTicketsTotal ) {

        my $CustomTexts = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverviewCustomEmptyText');

        # show message if there are no tickets
        my $TicketListObject = $Kernel::OM->Get('Kernel::Output::HTML::TicketOverview::CustomerList');
        $TicketListHTML = $TicketListObject->Run(
            TicketIDs   => [],
            NoAllTotal  => $Self->{Subaction} eq 'Search' ? 0            : 1,
            CustomTexts => ( ref $CustomTexts eq 'HASH' ) ? $CustomTexts : 0,
        );

    }
    else {

        if ( $AllTickets > $PageShown ) {

            # create pagination
            my $Link = 'SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
                . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderByCurrent )
                . ';Filter=' . $LayoutObject->Ascii2Html( Text => $FilterCurrent )
                . ';Subaction=' . $LayoutObject->Ascii2Html( Text => $Self->{Subaction} )
                . ';';

            # remember fulltext query
            if ( defined $Fulltext ) {
                $Link .= 'Fulltext=' . $LayoutObject->Ascii2Html( Text => $Fulltext ) . ';';
            }

            # Add CustomerIDs parameter if needed.
            if ( IsArrayRefWithData( \@CustomerIDs ) ) {
                for my $CustomerID (@CustomerIDs) {
                    $Link .= "CustomerIDs=$CustomerID;";
                }
            }

            %PageNav = $LayoutObject->PageNavBar(
                Limit     => 10000,
                StartHit  => $StartHit,
                PageShown => $PageShown,
                AllHits   => $AllTickets,
                Action    => 'Action=CustomerTicketOverview',
                Link      => $Link,
                IDPrefix  => 'CustomerTicketOverview',
            );
        }

        my $OrderBy = 'Down';
        if ( $OrderByCurrent eq 'Down' ) {
            $OrderBy = 'Up';
        }
        my $Sort       = '';
        my $StateSort  = '';
        my $TicketSort = '';
        my $TitleSort  = '';
        my $AgeSort    = '';
        my $QueueSort  = '';
        my $OwnerSort  = '';

        # this sets the opposite to the $OrderBy
        if ( $OrderBy eq 'Down' ) {
            $Sort = 'SortAscending';
        }
        if ( $OrderBy eq 'Up' ) {
            $Sort = 'SortDescending';
        }

        if ( $SortBy eq 'State' ) {
            $StateSort = $Sort;
        }
        elsif ( $SortBy eq 'Ticket' ) {
            $TicketSort = $Sort;
        }
        elsif ( $SortBy eq 'Title' ) {
            $TitleSort = $Sort;
        }
        elsif ( $SortBy eq 'Age' ) {
            $AgeSort = $Sort;
        }
        elsif ( $SortBy eq 'Queue' ) {
            $QueueSort = $Sort;
        }
        elsif ( $SortBy eq 'Owner' ) {
            $OwnerSort = $Sort;
        }

        my $Owner = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{Owner};
        my $Queue = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{Queue};

        if ($Owner) {
            $LayoutObject->Block(
                Name => 'OverviewNavBarPageOwner',
                Data => {
                    OrderBy   => $OrderBy,
                    OwnerSort => $OwnerSort,
                    Filter    => $FilterCurrent,
                },
            );
        }

        if ($Queue) {
            $LayoutObject->Block(
                Name => 'OverviewNavBarPageQueue',
                Data => {
                    OrderBy   => $OrderBy,
                    QueueSort => $QueueSort,
                    Filter    => $FilterCurrent,
                },
            );
        }

        # show header filter
        for my $Key ( sort keys %NavBarFilter ) {
            $LayoutObject->Block(
                Name => 'FilterHeader',
                Data => {
                    %Param,
                    %{ $NavBarFilter{$Key} },
                    Fulltext => $ParamObject->GetParam( Param => 'Fulltext' ),
                },
            );
        }

        # get the dynamic fields for this screen
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # get dynamic field config for frontend module
        my $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::CustomerTicketOverview")->{DynamicField};
        my $DynamicField       = $DynamicFieldObject->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Ticket'],
            FieldFilter => $DynamicFieldFilter || {},
        );

        # reduce the dynamic fields to only the ones that are desinged for customer interface
        my @CustomerDynamicFields;
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsCustomerInterfaceCapable',
            );
            next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

            push @CustomerDynamicFields, $DynamicFieldConfig;
        }
        $DynamicField = \@CustomerDynamicFields;

        # Dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $Label = $DynamicFieldConfig->{Label};

            # get field sortable condition
            my $IsSortable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsSortable',
            );

            if ($IsSortable) {
                my $CSS = '';
                if (
                    $SortBy
                    && ( $SortBy eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                    )
                {
                    if ( $OrderByCurrent && ( $OrderByCurrent eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescending';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscending';
                    }
                }

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField',
                    Data => {
                        %Param,
                        CSS => $CSS,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicFieldSortable',
                    Data => {
                        %Param,
                        OrderBy          => $OrderBy,
                        Label            => $Label,
                        DynamicFieldName => $DynamicFieldConfig->{Name},
                        Filter           => $FilterCurrent,
                    },
                );

                # example of dynamic fields order customization
                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        %Param,
                        CSS => $CSS,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . '_Sortable',
                    Data => {
                        %Param,
                        OrderBy          => $OrderBy,
                        Label            => $Label,
                        DynamicFieldName => $DynamicFieldConfig->{Name},
                        Filter           => $FilterCurrent,
                    },
                );
            }
            else {

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField',
                    Data => {
                        %Param,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicFieldNotSortable',
                    Data => {
                        %Param,
                        Label => $Label,
                    },
                );

                # example of dynamic fields order customization
                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        %Param,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . '_NotSortable',
                    Data => {
                        %Param,
                        Label => $Label,
                    },
                );
            }
        }

        my @ViewableTickets = $TicketObject->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{$FilterCurrent}->{Search} },
            %SearchInArchive,
            Result => 'ARRAY',
        );

        # show tickets
        my $TicketListObject = $Kernel::OM->Get('Kernel::Output::HTML::TicketOverview::CustomerList');
        $TicketListHTML = $TicketListObject->Run(
            StartHit  => $StartHit,
            PageShown => $PageShown,
            TicketIDs => \@ViewableTickets,
        );

    }

    # create & return output
    my $Title = $Self->{Subaction};
    if ( $Title eq 'MyTickets' ) {
        $Title = Translatable('My Tickets');
    }
    elsif ( $Title eq 'CompanyTickets' ) {
        $Title = Translatable('Company Tickets');
    }
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $LayoutObject->CustomerHeader(
        Title   => $Title,
        Refresh => $Refresh,
    );

    # AddJSData for ES
    my $ESActive = $ConfigObject->Get('Elasticsearch::Active');

    $LayoutObject->AddJSData(
        Key   => 'ESActive',
        Value => $ESActive,
    );

    my $NewTicketAccessKey = $ConfigObject->Get('CustomerFrontend::Navigation')->{'CustomerTicketMessage'}{'002-Ticket'}[0]{'AccessKey'}
        || '';

    $Output .= $LayoutObject->Output(
        TemplateFile => 'CustomerTicketOverview',
        Data         => {
            %Param,
            %PageNav,
            AccessKey      => $NewTicketAccessKey,
            TicketListHTML => $TicketListHTML,
            Fulltext       => $ParamObject->GetParam( Param => 'Fulltext' ),
        },
    );

    # build NavigationBar
    $Output .= $LayoutObject->CustomerNavigationBar();

    # get page footer
    $Output .= $LayoutObject->CustomerFooter();

    return $Output;
}

1;
