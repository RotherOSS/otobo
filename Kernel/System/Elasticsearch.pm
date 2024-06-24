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

package Kernel::System::Elasticsearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

# Inform the object manager about the hard dependencies.
# This module must be discarded when one of the hard dependencies has been discarded.
our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::GenericInterface::Requester',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerCompany',
    'Kernel::System::CustomerGroup',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::Ticket',
    'Kernel::System::User',
);

# Inform the CodePolicy about the soft dependencies that are intentionally not in @ObjectDependencies.
# Soft dependencies are modules that used by this object, but who don't affect the state of this object.
# There is no need to discard this module when one of the soft dependencies is discarded.
our @SoftObjectDependencies = (
    'Kernel::System::GeneralCatalog',
    'Kernel::System::ITSMConfigItem',
);

=head1 NAME

Kernel::System::Elasticsearch - Elasticsearch Backend

=head1 DESCRIPTION

This module processes search calls for various otobo classes to call the generic Elasticsearch search invoker

=head2 new()

Create an Elasticsearch object. Do not use it directly, instead use:

    my $ESObject = $Kernel::OM->Get('Kernel::System::Elasticsearch');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # get the Elasticsearch webservice id
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $Webservice       = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    $Self->{WebserviceID} = $Webservice->{ID};

    return $Self;
}

=head2 TicketSearch()

Performs a ticket search via Elasticsearch.

    my @TicketIDs = $ESObject->TicketSearch(
        # result (required)
        Result => 'ARRAY' || 'HASH' || 'COUNT' || 'FULL',

        # user search (UserID is required)
        UserID     => 123,
        Permission => 'ro' || 'rw',

        # customer search (CustomerUserID is required)
        CustomerUserID => 123,
        Permission     => 'ro' || 'rw',

        # result limit
        Limit => 100,

        # CustomerID (optional) as STRING or as ARRAYREF
        CustomerID => '123',
        CustomerID => ['123', 'ABC'],

        # CustomerIDRaw (optional) as STRING or as ARRAYREF
        # CustomerID without QueryCondition checking
        #The raw value will be used if is set this parameter
        CustomerIDRaw => '123 + 345',
        CustomerIDRaw => ['123', 'ABC','123 && 456','ABC % efg'],

        # CustomerUserLogin (optional) as STRING as ARRAYREF
        CustomerUserLogin => 'uid123',
        CustomerUserLogin => ['uid123', 'uid777'],

        # CustomerUserLoginRaw (optional) as STRING as ARRAYREF
        #The raw value will be used if is set this parameter
        CustomerUserLoginRaw => 'uid',
        CustomerUserLoginRaw => 'uid + 123',
        CustomerUserLoginRaw => ['uid  -  123', 'uid # 777 + 321'],

        # OrderBy and SortBy (optional)
        OrderBy => 'Down',  # Down|Up
        SortBy  => 'Age',   # Score|Age

        # CacheTTL, cache search result in seconds (optional)
        CacheTTL => 60 * 15,
    );

=cut

sub TicketSearch {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ResultType   = $Param{Result}  || 'ARRAY';
    my $OrderBy      = $Param{OrderBy} || [ 'Down',  'Down' ];
    my $SortBy       = $Param{SortBy}  || [ 'Score', 'Age' ];
    my $Limit        = $Param{Limit}   || 10000;

    # check required params
    if ( !$Param{UserID} && !$Param{CustomerUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID or CustomerUserID params for permission check!',
        );
        return;
    }

    # gather the info for the Elasticsearch query preparation
    # Must is read as all conditions have to be met, Should is read as at least one condition has to be met
    my ( @Filters, @Musts );

    # user groups
    if ( $Param{UserID} && $Param{UserID} != 1 ) {

        # get users groups
        my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Param{UserID},
            Type   => $Param{Permission} || 'ro',
        );

        # return if we have no permissions
        return if !%GroupList;

        # add permission restrictions
        push @Filters, {
            terms => {
                GroupID => [ keys %GroupList ],
            },
        };
    }

    # customer groups
    if ( $Param{CustomerUserID} ) {
        my %GroupList = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberList(
            UserID => $Param{CustomerUserID},
            Type   => $Param{Permission} || 'ro',
            Result => 'HASH',
        );

        # return if we have no permissions
        return if !%GroupList;

        # get all customer ids
        my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $Param{CustomerUserID},
        );

        # prepare combination of customer<->group access
        # add default combination first ( CustomerIDs + CustomerUserID <-> rw access groups )
        # this group will always be added (ensures previous behavior)
        my @CustomerGroupPermission;
        push @CustomerGroupPermission, {
            CustomerIDs    => \@CustomerIDs,
            CustomerUserID => $Param{CustomerUserID},
            GroupIDs       => [ sort keys %GroupList ],
        };

        # add all combinations based on group access for other CustomerIDs (if available)
        # only active if customer group support and extra permission context are enabled
        my $CustomerGroupObject    = $Kernel::OM->Get('Kernel::System::CustomerGroup');
        my $ExtraPermissionContext = $CustomerGroupObject->GroupContextNameGet(
            SysConfigName => '100-CustomerID-other',
        );
        if ( $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport') && $ExtraPermissionContext ) {

            # add lookup for CustomerID
            my %CustomerIDsLookup = map { $_ => $_ } @CustomerIDs;

            # for all CustomerIDs get groups with access to other CustomerIDs
            my %ExtraPermissionGroups;
            CUSTOMERID:
            for my $CustomerID (@CustomerIDs) {
                my %CustomerIDExtraPermissionGroups = $CustomerGroupObject->GroupCustomerList(
                    CustomerID => $CustomerID,
                    Type       => $Param{Permission} || 'ro',
                    Context    => $ExtraPermissionContext,
                    Result     => 'HASH',
                );
                next CUSTOMERID if !%CustomerIDExtraPermissionGroups;

                # add to groups
                %ExtraPermissionGroups = (
                    %ExtraPermissionGroups,
                    %CustomerIDExtraPermissionGroups,
                );
            }

            # add all unique accessible Group<->Customer combinations to query
            # for performance reasons all groups corresponsing with a unique customer id combination
            #   will be combined into one part
            my %CustomerIDCombinations;
            GROUPID:
            for my $GroupID ( sort keys %ExtraPermissionGroups ) {
                my @ExtraCustomerIDs = $CustomerGroupObject->GroupCustomerList(
                    GroupID => $GroupID,
                    Type    => $Param{Permission} || 'ro',
                    Result  => 'ID',
                );
                next GROUPID if !@ExtraCustomerIDs;

                # exclude own CustomerIDs for performance reasons
                my @MergedCustomerIDs = grep { !$CustomerIDsLookup{$_} } @ExtraCustomerIDs;
                next GROUPID if !@MergedCustomerIDs;

                # remember combination
                my $CustomerIDString = join ',', sort @MergedCustomerIDs;
                if ( !$CustomerIDCombinations{$CustomerIDString} ) {
                    $CustomerIDCombinations{$CustomerIDString} = {
                        CustomerIDs => \@MergedCustomerIDs,
                    };
                }
                push @{ $CustomerIDCombinations{$CustomerIDString}->{GroupIDs} }, $GroupID;
            }

            # add to query combinations
            push @CustomerGroupPermission, sort values %CustomerIDCombinations;
        }

        # now add all combinations to query:
        # this will compile a search restriction based on customer_id/customer_user_id and group
        #   and will match if any of the permission combination is met
        # a permission combination could be:
        #     ( <CustomerUserID> OR <CUSTOMERID1> ) AND ( <GROUPID1> )
        # or
        #     ( <CustomerID1> OR <CUSTOMERID2> OR <CUSTOMERID3> ) AND ( <GROUPID1> OR <GROUPID2> )
        my @CustomerIDGroupCombinations;
        ENTRY:
        for my $Entry (@CustomerGroupPermission) {
            my $DirectConditions;
            my @CustomerIDs;

            if ( IsArrayRefWithData( $Entry->{CustomerIDs} ) ) {
                push @CustomerIDs, @{ $Entry->{CustomerIDs} };
            }

            if ( defined $Param{CustomerUserLoginRaw} || ( $Entry->{CustomerUserID} && !@CustomerIDs ) ) {
                $DirectConditions = {
                    term => {
                        CustomerUserID => $Param{CustomerUserLoginRaw} // $Entry->{CustomerUserID},
                    },
                };
            }
            elsif ( @CustomerIDs && $Entry->{CustomerUserID} ) {
                $DirectConditions = {
                    bool => {
                        should => [
                            {
                                term => {
                                    CustomerUserID => $Entry->{CustomerUserID},
                                },
                            },
                            {
                                terms => {
                                    CustomerID => \@CustomerIDs,
                                },
                            },
                        ],
                    },
                };
            }
            elsif (@CustomerIDs) {
                $DirectConditions = {
                    terms => {
                        CustomerID => \@CustomerIDs,
                    },
                };
            }
            else {
                next ENTRY;
            }

            push @CustomerIDGroupCombinations, {
                bool => {
                    filter => [
                        $DirectConditions,
                        {
                            terms => {
                                GroupID => $Entry->{GroupIDs},
                            },
                        },
                    ],
                },
            };

        }

        if ( scalar @CustomerIDGroupCombinations == 1 ) {
            push @Filters, $CustomerIDGroupCombinations[0];
        }
        else {
            push @Filters, {
                bool => {
                    should => \@CustomerIDGroupCombinations,
                },
            };
        }

    }

    # fulltext search
    if ( defined $Param{Fulltext} ) {

        # get fields to search
        my $FulltextFields = $ConfigObject->Get('Elasticsearch::TicketSearchFields');
        my @SearchFields   = @{ $FulltextFields->{Ticket} };
        push @SearchFields, ( map {"ArticlesExternal.$_"} @{ $FulltextFields->{Article} } );
        push @SearchFields, ( "AttachmentsExternal.Content", "AttachmentsExternal.Filename" );

        # add internal fields
        if ( $Param{UserID} ) {
            push @SearchFields, ( map {"ArticlesInternal.$_"} @{ $FulltextFields->{Article} } );
            push @SearchFields, ( "AttachmentsInternal.Content", "AttachmentsInternal.Filename" );
        }

        # handle dynamic fields
        if ( $FulltextFields->{DynamicField} ) {
            my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
            my $ZoomConfig         = $ConfigObject->Get('Ticket::Frontend::CustomerTicketZoom') || {};
            my $CustomerFields     = $ZoomConfig->{DynamicField};

            DYNAMICFIELD:
            for my $DynamicFieldName ( @{ $FulltextFields->{DynamicField} } ) {
                my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                    Name => $DynamicFieldName,
                );
                next DYNAMICFIELD unless IsHashRefWithData($DynamicField);

                # agent search
                if ( $Param{UserID} ) {

                    # add all ticket dynamic fields
                    if ( $DynamicField->{ObjectType} eq 'Ticket' ) {
                        push @SearchFields, "DynamicField_$DynamicFieldName";
                    }

                    # add article dynamicfields for both internal and external articles
                    elsif ( $DynamicField->{ObjectType} eq 'Article' ) {
                        push @SearchFields,
                            (
                                "ArticlesExternal.DynamicField_$DynamicFieldName",
                                "ArticlesInternal.DynamicField_$DynamicFieldName"
                            );
                    }
                }

                # customer search
                else {
                    # check if dynamic field is visible for customers
                    next DYNAMICFIELD if ( !$CustomerFields || !$CustomerFields->{$DynamicFieldName} );

                    # add ticket dynamic fields
                    if ( $DynamicField->{ObjectType} eq 'Ticket' ) {
                        push @SearchFields, "DynamicField_$DynamicFieldName";
                    }

                    # add article dynamicfields for external articles
                    elsif ( $DynamicField->{ObjectType} eq 'Article' ) {
                        push @SearchFields, ("ArticlesExternal.DynamicField_$DynamicFieldName");
                    }
                }
            }
        }

        # add queue restrictions
        push @Musts, {
            query_string => {
                fields => \@SearchFields,
                query  => "*$Param{Fulltext}*",
            },
        };

    }

    # define the return type
    my $Return = ( $ResultType eq 'HASH' ) ? [qw(TicketID TicketNumber)] :
        ( $ResultType eq 'FULL' ) ? '' : 'TicketID';

    # define the sorting
    my @Sort;
    my %O2E = qw(Down desc Up asc);
    if ( !ref($SortBy) ) {
        $SortBy  = [$SortBy];
        $OrderBy = [$OrderBy];
    }
    for my $i ( 0 .. $#{$SortBy} ) {

        # score is Elasticsearch specific
        if ( $SortBy->[$i] eq 'Score' ) { $SortBy->[$i] = '_score' }

        # age is not stored in Elasticsearch
        if ( $SortBy->[$i] eq 'Age' ) {
            $SortBy->[$i]  = 'Created';
            $OrderBy->[$i] = $OrderBy->[$i] eq 'Up' ? 'Up' : 'Down';
        }

        push @Sort, { $SortBy->[$i] => $O2E{ $OrderBy->[$i] } };
    }

    # call the Elasticsearch webservice
    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'Search',
        Asynchronous => 0,
        Data         => {
            IndexName => 'ticket',
            Must      => \@Musts,
            Filter    => \@Filters,
            Limit     => $Limit,
            Return    => $Return,
            Sort      => \@Sort,
        }
    );

    # convert the Elasticsearch return to the needed OTRS structure and return
    if ( $ResultType eq 'HASH' ) {
        return (
            map {
                { $_->{TicketID} => $_->{TicketNumber} }
            } @{ $Result->{Data} }
        );
    }

    elsif ( $ResultType eq 'ARRAY' ) {
        return ( map { $_->{TicketID} } @{ $Result->{Data} } );
    }

    elsif ( $ResultType eq 'FULL' ) {

        # age has to be calulated
        my $Now = $Kernel::OM->Create(
            'Kernel::System::DateTime'
        )->ToEpoch();

        for my $Data ( @{ $Result->{Data} } ) {
            $Data->{Age} = $Now - $Data->{Created};
        }
        return (
            map {
                { $_->{TicketID} => $_ }
            } @{ $Result->{Data} }
        );
    }

    elsif ( $ResultType eq 'COUNT' ) {
        return scalar @{ $Result->{Data} };
    }

}

sub CustomerCompanySearch {
    my ( $Self, %Param ) = @_;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ResultType   = $Param{Result} || 'ARRAY';
    my $Limit        = $Param{Limit}  || 10000;

    my ( @Musts, @Filters );
    if ( defined $Param{Fulltext} ) {

        my $FulltextFields = $ConfigObject->Get('Elasticsearch::CustomerCompanySearchFields');

        push @Musts, {
            query_string => {
                fields => $FulltextFields,
                query  => "*$Param{Fulltext}*",
            },
        };
    }

    # the return usually will be CustomerID, but it can be different for custom backends
    my $Return = 'CustomerCompanyKey';

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'Search',
        Asynchronous => 0,
        Data         => {
            IndexName => 'customer',
            Must      => \@Musts,
            Filter    => \@Filters,
            Limit     => $Limit,
            Return    => $Return,
        }
    );

    if ( $ResultType eq 'ARRAY' ) {
        return ( map { $_->{CustomerCompanyKey} } @{ $Result->{Data} } );
    }
    elsif ( $ResultType eq 'COUNT' ) {
        return scalar @{ $Result->{Data} };
    }

}

sub CustomerUserSearch {
    my ( $Self, %Param ) = @_;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ResultType   = $Param{Result} || 'ARRAY';
    my $Limit        = $Param{Limit}  || 10000;

    my ( @Musts, @Filters );
    if ( defined $Param{Fulltext} ) {

        my $FulltextFields = $ConfigObject->Get('Elasticsearch::CustomerUserSearchFields');

        push @Musts, {
            query_string => {
                fields => $FulltextFields,
                query  => "*$Param{Fulltext}*",
            },
        };
    }

    # the return usually will be UserLogin, but it can be different for custom backends
    my $Return = ( $ResultType eq 'HASH' ) ? [qw(CustomerKey UserFullname)] : 'CustomerKey';

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'Search',
        Asynchronous => 0,
        Data         => {
            IndexName => 'customeruser',
            Must      => \@Musts,
            Filter    => \@Filters,
            Limit     => $Limit,
            Return    => $Return,
        }
    );
    if ( $ResultType eq 'HASH' ) {
        return (
            map {
                { $_->{CustomerKey} => $_->{UserFullname} }
            } @{ $Result->{Data} }
        );
    }
    elsif ( $ResultType eq 'ARRAY' ) {
        return ( map { $_->{CustomerKey} } @{ $Result->{Data} } );
    }
    elsif ( $ResultType eq 'COUNT' ) {
        return scalar @{ $Result->{Data} };
    }
}

=head2 ConfigItemSearch()

Performs a config item search via Elasticsearch.

    $ESObject->ConfigItemSearch(
        Fulltext => $String,
        Limit    => 20,     # optional
        Result   => ARRAY,  # optional, ARRAY (default) | FULL

    );

=cut

sub ConfigItemSearch {
    my ( $Self, %Param ) = @_;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ResultType   = $Param{Result} || 'ARRAY';
    my $Limit        = $Param{Limit}  || 10000;

    # check required params
    for my $Needed (qw/UserID Fulltext/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my ( @Musts, @Filters );

    # get general catalog object
    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');

    # get class list
    my $ClassList = $GeneralCatalogObject->ItemList(
        Class => 'ITSM::ConfigItem::Class',
    );

    # get config item object
    my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');

    # check for access rights on the classes
    for my $ClassID ( sort keys %{$ClassList} ) {
        my $HasAccess = $ConfigItemObject->Permission(
            Type    => 'ro',
            Scope   => 'Class',
            ClassID => $ClassID,
            UserID  => $Param{UserID},
        );

        delete $ClassList->{$ClassID} if !$HasAccess;
    }

    # set up class filter corresponding to the access rights
    push @Filters, {
        bool => {
            filter => [
                {
                    terms => {
                        ClassID => [ keys %{$ClassList} ],
                    },
                },
            ],
        },
    };

    if ( defined $Param{Fulltext} ) {

        my $FulltextFields = $ConfigObject->Get('Elasticsearch::ConfigItemSearchFields');
        my @SearchFields   = (
            @{ $FulltextFields->{Basic} // [] },
        );

        if ( $FulltextFields->{Attachments} ) {
            push @SearchFields, ( 'Attachments.Content', 'Attachments.Filename' );
        }

        # handle dynamic fields
        if ( $FulltextFields->{DynamicField} ) {
            my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

            DYNAMICFIELD:
            for my $DynamicFieldName ( @{ $FulltextFields->{DynamicField} } ) {
                my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                    Name => $DynamicFieldName,
                );
                next DYNAMICFIELD unless IsHashRefWithData($DynamicField);

                # add all config item dynamic fields
                if ( $DynamicField->{ObjectType} eq 'ITSMConfigItem' ) {
                    push @SearchFields, "DynamicField_$DynamicFieldName";
                }
            }
        }

        push @Musts, {
            query_string => {
                fields => \@SearchFields,
                query  => "*$Param{Fulltext}*",
            },
        };
    }

    # define the return type
    my $Return = ( $ResultType eq 'FULL' ) ? '' : 'ConfigItemID';

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'Search',
        Asynchronous => 0,
        Data         => {
            IndexName => 'configitem',
            Must      => \@Musts,
            Filter    => \@Filters,
            Limit     => $Limit,
            Return    => $Return,
        }
    );

    if ( $ResultType eq 'FULL' ) {
        return (
            map {
                { $_->{ConfigItemID} => $_ }
            } @{ $Result->{Data} }
        );
    }
    else {
        return ( map { $_->{ConfigItemID} } @{ $Result->{Data} } );
    }

}

=head2 TicketCreate()

Explicitly creates a ticket in the Elasticsearch database. Happens event based in a productive system.
E.g. when a Ticket is restored from the archive or when when a ticket is moved from an excluded queue.

    $ESObject->TicketCreate(
        TicketID => $TicketID,
    );

=cut

sub TicketCreate {
    my ( $Self, %Param ) = @_;

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'TicketManagement',
        Asynchronous => 0,
        Data         => {
            Event    => 'TicketCreate',
            TicketID => $Param{TicketID},
        }
    );

    return $Result->{Success};

}

=head2 ArticleCreate()

Explicitly creates an article in the Elasticsearch database. Happens event based in a productive system.

    $ESObject->ArticleCreate(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

=cut

sub ArticleCreate {
    my ( $Self, %Param ) = @_;

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'TicketManagement',
        Asynchronous => 0,
        Data         => {
            Event     => 'ArticleCreate',
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
        }
    );

    return $Result->{Success};

}

=head2 CustomerCompanyAdd()

Explicitly creates a customer company in the Elasticsearch database. Happens event based in a productive system.

    $ESObject->CustomerCompanyAdd(
        CustomerID => $CustomerID,
    );

=cut

sub CustomerCompanyAdd {
    my ( $Self, %Param ) = @_;

    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my %CustomerCompany       = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $Param{CustomerID},
    );

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'CustomerCompanyManagement',
        Asynchronous => 0,
        Data         => {
            Event      => 'CustomerCompanyAdd',
            CustomerID => $Param{CustomerID},
            NewData    => \%CustomerCompany,
        }
    );

    return $Result->{Success};

}

=head2 CustomerUserAdd()

Explicitly creates a customer company in the Elasticsearch database. Happens event based in a productive system.

    $ESObject->CustomerUserAdd(
        UserLogin => $UserLogin,
    );

=cut

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my %CustomerUser       = $CustomerUserObject->CustomerUserDataGet(
        User => $Param{UserLogin},
    );

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'CustomerUserManagement',
        Asynchronous => 0,
        Data         => {
            Event   => 'CustomerUserAdd',
            NewData => \%CustomerUser,
        }
    );

    return $Result->{Success};

}

=head2 ConfigItemCreate()

Explicitly creates a config item in the Elasticsearch database. Happens mostly event based in a productive system.

    $ESObject->ConfigItemCreate(
        ConfigItemID => $ConfigItemID,
    );

=cut

sub ConfigItemCreate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/ConfigItemID/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');

    # create the config item
    my $Result = $RequesterObject->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'ConfigItemManagement',
        Asynchronous => 0,
        Data         => {
            Event        => 'ConfigItemCreate',
            ConfigItemID => $Param{ConfigItemID},
        }
    );
    return if !$Result->{Success};

    # update the version
    $Result = $RequesterObject->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'ConfigItemManagement',
        Asynchronous => 0,
        Data         => {
            Event        => 'VersionCreate',
            ConfigItemID => $Param{ConfigItemID},
        }
    );

    # update the attachments
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::ConfigItemSearchFields')->{'Attachments'} ) {
        my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');

        my @Attachments = $ConfigItemObject->ConfigItemAttachmentList(
            ConfigItemID => $Param{ConfigItemID},
        );

        for my $AttachmentName (@Attachments) {
            my $Attachment = $ConfigItemObject->ConfigItemAttachmentGet(
                ConfigItemID => $Param{ConfigItemID},
                Filename     => $AttachmentName,
            );

            $Result = $RequesterObject->Run(
                WebserviceID => $Self->{WebserviceID},
                Invoker      => 'ConfigItemManagement',
                Asynchronous => 0,
                Data         => {
                    %{$Attachment},
                    Event        => 'AttachmentAddPost',
                    ConfigItemID => $Param{ConfigItemID},
                }
            );
        }
    }

    return 1;

}

=head2 TestConnection()

Test the connection to the Elasticsearch server.

    my $Success = $ESObject->TestConnection();

=cut

sub TestConnection {
    my ( $Self, %Param ) = @_;

    my %DummyIndex = (
        index => '',
    );
    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'Utils_GET',
        Asynchronous => 0,
        Data         => {
            IndexName => \%DummyIndex,
        }
    );

    return $Result->{Success};
}

=head2 CreateIndex()

Create a new index.

    my $Success = $ESObject->CreateIndex(
        IndexName => {
            name => 'something',
        },
        Request   => {
            settings => { ... },
            mappings => { ... },
        },
    );

=cut

sub CreateIndex {
    my ( $Self, %Param ) = @_;

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'Utils_PUT',
        Asynchronous => 0,
        Data         => {
            IndexName => $Param{IndexName},
            Request   => $Param{Request},
        }
    );

    return $Result->{Success};
}

=head2 DropIndex()

Drop a complete index.

    $ESObject->DropIndex(
        IndexName => 'name',
    );

=cut

sub DropIndex {
    my ( $Self, %Param ) = @_;

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'Utils_DELETE',
        Asynchronous => 0,
        Data         => {
            IndexName => $Param{IndexName},
        }
    );

    return $Result->{Success};
}

sub DeletePipeline {
    my ( $Self, %Param ) = @_;

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'UtilsPipeline_DELETE',
        Asynchronous => 0,
        Data         => {
            IndexName => {},
        }
    );

    return $Result->{Success};
}

sub CreatePipeline {
    my ( $Self, %Param ) = @_;

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $Self->{WebserviceID},
        Invoker      => 'UtilsPipeline_PUT',
        Asynchronous => 0,
        Data         => {
            IndexName => '',
            Request   => $Param{Request},
        }
    );

    return $Result->{Success};

}

=head2 IndexSettingsGet()

Get settings for a certain index

    my $Settings = $ESObject->IndexSettingsGet(
        Config   => $Config,
        Template => $Template,
    ;)

=cut

sub IndexSettingsGet {
    my ( $Self, %Param ) = @_;

    my $Config = $Param{Config};

    my $Settings = $Self->_ExpandTemplate(
        Item         => $Param{Template},
        Config       => $Config,
        LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
    );

    return $Settings;
}

sub _ExpandTemplate {
    my ( $Self, %Param ) = @_;

    my $Config = $Param{Config};
    my $Node   = $Param{Item};

    if ( ref $Node eq 'HASH' ) {
        my %Expanded;
        for my $Key ( keys( %{$Node} ) ) {
            $Expanded{$Key} = $Self->_ExpandTemplate(
                Item         => $Node->{$Key},
                Config       => $Config,
                LayoutObject => $Param{LayoutObject},
            );
        }

        return \%Expanded;
    }
    elsif ( ref $Node eq 'ARRAY' ) {
        my @Expanded;
        for my $Item ( @{$Node} ) {
            push(
                @Expanded,
                $Self->_ExpandTemplate(
                    Item         => $Item,
                    Config       => $Config,
                    LayoutObject => $Param{LayoutObject},
                )
            );
        }

        return \@Expanded;
    }
    elsif ( !defined($Node) ) {
        return;
    }
    elsif ( IsNumber($Node) ) {
        return $Node;
    }
    elsif ( IsString($Node) ) {
        return $Param{LayoutObject}->Output(
            Template => $Node,
            Data     => $Config,
        );
    }
    else {
        return $Node;
    }
}

=head2 InitialSetup()

This method is used by I<installer.pl> and by alternative install scripts to get a working
initial setup.

    my ($Success, $FatalError) = $ESObject->InitialSetup()

=cut

sub InitialSetup {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # activate Elasticsearch in the SysConfig
    {
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            LockAll => 1,
            Force   => 1,
            UserID  => 1,
        );
        $SysConfigObject->SettingUpdate(
            Name              => 'Elasticsearch::Active',
            IsValid           => 1,
            UserID            => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
        );
        $SysConfigObject->SettingUnlock(
            UnlockAll => 1,
        );

        # TODO: handle errors
    }

    my $Success = 1;

    # initialize standard indices
    if ($Success) {
        my $Errors;
        my $IndexConfig = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::IndexSettings');
        my $DefaultConfig;
        if ($IndexConfig) {
            $DefaultConfig = $IndexConfig->{Default};
        }
        else {
            $DefaultConfig = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::ArticleIndexCreationSettings');
        }

        # throw an fatal error when we are in a web context
        return 0, 1 unless $DefaultConfig;

        my $DefaultTemplate;
        my $IndexTemplate = $Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::IndexTemplate');
        if ($IndexTemplate) {
            $DefaultTemplate = $IndexTemplate->{Default};
        }
        else {

            # throw an fatal error when we are in a web context
            return 0, 1;
        }

        # Create pipelines.
        # Writing the string 'foreach' in a funny way, as some versions of the CodePolicy
        # replaced it with the string 'for'.
        my %Pipeline = (
            description => "Extract external attachment information",
            processors  => [
                {
                    q{foreach} => {
                        field     => "Attachments",
                        processor => {
                            attachment => {
                                target_field => "_ingest._value.attachment",
                                field        => "_ingest._value.data"
                            }
                        }
                    }
                },
                {
                    q{foreach} => {
                        field     => "Attachments",
                        processor => {
                            remove => {
                                field => "_ingest._value.data"
                            }
                        }
                    }
                },
            ]
        );

        my $Success = $Self->CreatePipeline(
            Request => \%Pipeline,
        );
        $Errors++ unless $Success;

        # create index for customer
        my %RequestCustomer = (
            settings => $Self->IndexSettingsGet(
                Config   => $IndexConfig->{Customer}   // $DefaultConfig,
                Template => $IndexTemplate->{Customer} // $DefaultTemplate,
            ),
            mappings => {
                properties => {
                    CustomerID => {
                        type => 'keyword',
                    },
                }
            },
        );
        $Success = $Self->CreateIndex(
            IndexName => { index => 'customer' },
            Request   => \%RequestCustomer,
        );
        $Errors++ unless $Success;

        # create index for customer users
        my %RequestCustomerUser = (
            settings => $Self->IndexSettingsGet(
                Config   => $IndexConfig->{CustomerUser}   // $DefaultConfig,
                Template => $IndexTemplate->{CustomerUser} // $DefaultTemplate,
            ),
            mappings => {
                properties => {
                    UserLogin => {
                        type => 'keyword',
                    },
                }
            },
        );
        $Success = $Self->CreateIndex(
            IndexName => { index => 'customeruser' },
            Request   => \%RequestCustomerUser,
        );
        $Errors++ unless $Success;

        # create index for tickets
        my %RequestTicket = (
            settings => $Self->IndexSettingsGet(
                Config   => $IndexConfig->{Ticket}   // $DefaultConfig,
                Template => $IndexTemplate->{Ticket} // $DefaultTemplate,
            ),
            mappings => {
                properties => {
                    GroupID => {
                        type => 'integer',
                    },
                    QueueID => {
                        type => 'integer',
                    },
                    CustomerID => {
                        type => 'keyword',
                    },
                    CustomerUserID => {
                        type => 'keyword',
                    },
                }
            },
        );
        $Success = $Self->CreateIndex(
            IndexName => { index => 'ticket' },
            Request   => \%RequestTicket,
        );
        $Errors++ unless $Success;

        $Success = 0 if $Errors;
    }

    if ($Success) {
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            LockAll => 1,
            Force   => 1,
            UserID  => 1,
        );
        my %Setting = $SysConfigObject->SettingGet(
            Name => 'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext',
        );
        $SysConfigObject->SettingUpdate(
            Name              => 'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext',
            IsValid           => 1,
            UserID            => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            EffectiveValue    => $Setting{EffectiveValue},
        );
        $SysConfigObject->SettingUnlock(
            UnlockAll => 1,
        );
    }
    else {
        # disable in case of failure
        my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
        my $ESWebservice     = $WebserviceObject->WebserviceGet(
            Name => 'Elasticsearch',
        );

        $WebserviceObject->WebserviceUpdate(
            %{$ESWebservice},
            ValidID => 2,
            UserID  => 1,
        );

        # SysConfig
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            LockAll => 1,
            Force   => 1,
            UserID  => 1,
        );
        $SysConfigObject->SettingUpdate(
            Name              => 'Elasticsearch::Active',
            IsValid           => 0,
            UserID            => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
        );
        $SysConfigObject->SettingUnlock(
            UnlockAll => 1,
        );
    }

    # 'Rebuild' the configuration.
    $SysConfigObject->ConfigurationDeploy(
        Comments    => "Quick setup of Elasticsearch",
        AllSettings => 1,
        Force       => 1,
        UserID      => 1,
    );

    return $Success, 0;
}

1;
