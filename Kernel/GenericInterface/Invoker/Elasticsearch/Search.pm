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

package Kernel::GenericInterface::Invoker::Elasticsearch::Search;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker::Elasticsearch::Search

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Invoker->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params and store them in $Self
    for my $Needed (qw/DebuggerObject WebserviceID/) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Need $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=head2 PrepareRequest()

prepare the invocation of the configured remote web service.
This will just return the data that was passed to the function.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # check needed
    for my $Needed (qw/IndexName/) {
        if ( !$Param{Data}{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    if ( !IsArrayRefWithData( $Param{Data}{Must} ) && !IsArrayRefWithData( $Param{Data}{Filter} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Must or Filter in the search data!",
        );
        return;
    }

    # build search query
    my %SearchQuery;

    # simple queries without filters
    if ( !$Param{Data}{Filter} && scalar @{ $Param{Data}{Must} } == 1 ) {
        $SearchQuery{query} = $Param{Data}{Must}[0];
    }

    # complex queries
    else {
        if ( $Param{Data}{Filter} ) {
            $SearchQuery{query}{bool}{filter} = $Param{Data}{Filter};
        }
        if ( $Param{Data}{Must} ) {
            $SearchQuery{query}{bool}{must} = $Param{Data}{Must};
        }
    }

    # define return data
    if ( $Param{Data}{Return} ) {
        $SearchQuery{_source}{includes} = IsArrayRefWithData( $Param{Data}{Return} ) ? $Param{Data}{Return} : [ $Param{Data}{Return} ];
    }

    # return size
    if ( $Param{Data}{Limit} ) {
        $SearchQuery{size} = $Param{Data}{Limit};
    }

    # sort the results
    if ( $Param{Data}{Sort} ) {
        $SearchQuery{sort} = $Param{Data}{Sort};
    }

    return {
        Success => 1,
        Data    => {
            index => $Param{Data}{IndexName},
            %SearchQuery,
        },
    };

}

=head2 HandleResponse()

handle response data of the configured remote web service.
This will just return the data that was passed to the function.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote web service
        ResponseErrorMessage => '',             # in case of web service error
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # if there was an error in the response, forward it
    if ( !$Param{ResponseSuccess} ) {
        return {
            Success      => 0,
            ErrorMessage => $Param{ResponseErrorMessage},
        };
    }

    #TODO more specific error handling

    my @Return;

    # gather the returned info
    if ( $Param{Data}{hits}{hits} ) {
        @Return = map { $_->{_source} } @{ $Param{Data}{hits}{hits} };
    }

    return {
        Success => 1,
        Data    => \@Return,
    };
}

1;
