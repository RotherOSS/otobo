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

package Kernel::GenericInterface::Invoker::Elasticsearch::CustomerCompanyManagement;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker::Elasticsearch::CustomerCompanyManagement - GenericInterface test Invoker backend

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
    for my $Needed (qw/CustomerID Event/) {
        if ( !$Param{Data}{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Need $Needed!",
            };
        }
    }

    # delete the company from elasticsearch - only called from the delete Webservice
    if ( $Param{Data}{Event} eq 'CustomerCompanyDelete' ) {
        my %Content = (
            query => {
                term => {
                    CustomerID => $Param{Data}{CustomerID},
                }
            }
        );

        return {
            Success => 1,
            Data    => {
                docapi => '_delete_by_query',
                id     => '',
                %Content,
            },
        };
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # prepare request by gathering all fields which have to be stored
    my %Content;
    {
        my $Store  = $ConfigObject->Get('Elasticsearch::CustomerCompanyStoreFields');
        my $Search = $ConfigObject->Get('Elasticsearch::CustomerCompanySearchFields');

        my %DataToStore;
        for my $Field ( @{$Store}, @{$Search} ) {
            $DataToStore{$Field} = 1;
        }

        %Content = map { $_ => $Param{Data}{NewData}{$_} } keys %DataToStore;
    }

    my $API;

    # set CustomerCompanyKey
    my $BackendConfig        = $ConfigObject->Get( $Param{Data}{NewData}{Source} );
    my $CustomerCompanyKeyES = "CustomerID";
    if ( $BackendConfig->{CustomerCompanyKey} ) {
        $CustomerCompanyKeyES = "";
        ITEM:
        for my $Item ( @{ $BackendConfig->{Map} } ) {
            if ( $Item->[2] eq $BackendConfig->{CustomerCompanyKey} ) {
                $CustomerCompanyKeyES = $Item->[0];

                last ITEM;
            }
        }
    }

    # do nothing for invalid customer companies
    if ( !$CustomerCompanyKeyES || !$Param{Data}{NewData}{$CustomerCompanyKeyES} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "No entry for '$CustomerCompanyKeyES' - source: $Param{Data}{NewData}{Source}.",
        );
        return {
            Success           => 1,
            StopCommunication => 1,
        };
    }

    $Content{CustomerCompanyKey} = $Param{Data}{NewData}{$CustomerCompanyKeyES};

    # create a new company
    if ( $Param{Data}{Event} eq 'CustomerCompanyAdd' ) {

        # do nothing for invalid companies
        if ( defined $Param{Data}{NewData}{ValidID} && $Param{Data}{NewData}{ValidID} != 1 ) {
            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        $API = '_doc';
    }

    # company update
    elsif ( $Param{Data}{Event} eq 'CustomerCompanyUpdate' ) {

        # if the Customer is set to invalid, delete it
        if ( $Param{Data}{NewData}{ValidID} != 1 ) {
            if ( $Param{Data}{OldData}{ValidID} == 1 ) {
                my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');

                # delete the old entry by calling myself
                my $NodeResult = $RequesterObject->Run(
                    WebserviceID => $Self->{WebserviceID},
                    Invoker      => 'CustomerCompanyManagement',
                    Asynchronous => 0,
                    Data         => {
                        Event      => 'CustomerCompanyDelete',
                        CustomerID => $Param{Data}{OldData}{CustomerID},
                    },
                );
            }

            return {
                Success           => 1,
                StopCommunication => 1,
            };
        }

        # if the CustomerID itself changed, we have to recreate the entry
        elsif ( $Param{Data}{OldData}{CustomerID} ne $Param{Data}{NewData}{CustomerID} ) {
            my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');

            # delete the old entry by calling myself
            my $NodeResult = $RequesterObject->Run(
                WebserviceID => $Self->{WebserviceID},
                Invoker      => 'CustomerCompanyManagement',
                Asynchronous => 0,
                Data         => {
                    Event      => 'CustomerCompanyDelete',
                    CustomerID => $Param{Data}{OldData}{CustomerID},
                },
            );

            # if the old company was invalid, just return
            if ( $Param{Data}{OldData}{ValidID} != 1 ) {
                return {
                    Success           => 1,
                    StopCommunication => 1,
                };
            }

            # create the new one
            $API = '_doc';
        }

        else {
            # if the old company was invalid, create, else update
            if ( $Param{Data}{OldData}{ValidID} != 1 ) {
                $API = '_doc';
            }

            else {
                %Content = (
                    doc => {%Content},
                );

                $API = '_update';
            }
        }
    }

    return {
        Success => 1,
        Data    => {
            docapi => $API,
            id     => $Param{Data}{CustomerID},
            %Content,
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

    if ( $Param{Data}->{ResponseContent} && $Param{Data}->{ResponseContent} =~ m{ReSchedule=1} ) {

        # ResponseContent has URI like params, convert them into a hash
        my %QueryParams = split /[&=]/, $Param{Data}->{ResponseContent};

        # unscape URI strings in query parameters
        for my $Param ( sort keys %QueryParams ) {
            $QueryParams{$Param} = URI::Escape::uri_unescape( $QueryParams{$Param} );
        }

        # fix ExecutrionTime param
        if ( $QueryParams{ExecutionTime} ) {
            $QueryParams{ExecutionTime} =~ s{(\d+)\+(\d+)}{$1 $2};
        }

        return {
            Success      => 0,
            ErrorMessage => 'Re-Scheduling...',
            Data         => \%QueryParams,
        };
    }

    return {
        Success => 1,
        Data    => $Param{Data},
    };
}

1;
