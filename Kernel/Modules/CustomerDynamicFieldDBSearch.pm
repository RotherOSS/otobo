# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::Modules::CustomerDynamicFieldDBSearch;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get config
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get needed params
    my $DynamicFieldName = $ParamObject->GetParam( Param => 'DynamicFieldName' ) || '';
    my $TicketID         = $ParamObject->GetParam( Param => 'TicketID' )         || '';
    my $Search           = $ParamObject->GetParam( Param => 'Term' )             || '';
    my $Identifier       = $ParamObject->GetParam( Param => 'Identifier' )       || '';

    # Put all ticket related data in Param, Owner, Responsible are not selectable in
    #   customer interface, CustomerIserID and CustomerID are fixed.
    $Param{CustomerUserID} = $Self->{UserLogin};
    $Param{CustomerID}     = $Self->{UserCustomerID};
    $Param{Dest}           = $ParamObject->GetParam( Param => 'Dest' )       || '';
    $Param{PriorityID}     = $ParamObject->GetParam( Param => 'PriorityID' ) || '';
    $Param{ServiceID}      = $ParamObject->GetParam( Param => 'ServiceID' )  || '';
    $Param{SLAID}          = $ParamObject->GetParam( Param => 'SLAID' )      || '';
    $Param{Subject}        = $ParamObject->GetParam( Param => 'Subject' )    || '';
    $Param{TypeID}         = $ParamObject->GetParam( Param => 'TypeID' )     || '';

    # State could be selected in followup and also in process management.
    $Param{StateID} = $ParamObject->GetParam( Param => 'StateID' ) || '';

    # Also get params from process management
    $Param{QueueID} = $ParamObject->GetParam( Param => 'QueueID' ) || '';

    # Get all the dynamic fields
    my $DynamicFields = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => [ 'Ticket', 'Article' ],
    );

    my @DynamicFieldNames;

    # Get dynamic field names
    DYNAMICFIELD:
    for my $DynamicFieldConfig (@$DynamicFields) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        push @DynamicFieldNames, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    # Fetch dynamic fields from web request
    for my $Name (@DynamicFieldNames) {
        $Param{$Name} = $ParamObject->GetParam( Param => $Name );
    }

    # Get Type using TypeID if it's defined.
    if ( $Param{TypeID} ) {

        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
            ID => $Param{TypeID},
        );

        if (%Type) {
            $Param{Type} = $Type{Name};
        }
    }

    # Get Priority using PriorityID if it's defined.
    if ( $Param{PriorityID} ) {

        my %PriorityList = $Kernel::OM->Get('Kernel::System::Priority')->PriorityGet(
            PriorityID => $Param{PriorityID},
            UserID     => 1,
        );

        if (%PriorityList) {
            $Param{Priority} = $PriorityList{Name};
        }
    }

    # Get SLA using SLAID if it's defined.
    if ( $Param{SLAID} ) {

        my %SLAData = $Kernel::OM->Get('Kernel::System::SLA')->SLAGet(
            SLAID  => $Param{SLAID},
            UserID => 1,
        );

        if (%SLAData) {
            $Param{SLA} = $SLAData{Name};
        }
    }

    # Get Service using ServiceID if it's defined.
    if ( $Param{ServiceID} ) {

        my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceGet(
            ServiceID => $Param{ServiceID},
            UserID    => 1,
        );

        if ( IsHashRefWithData( \%Service ) ) {
            $Param{Service} = $Service{Name};
        }
    }

    # Get queue object.
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # Check if only a name has been passed.
    if ( $Param{Dest} && $Param{Dest} !~ m{ \A (\d+)? \| \| .+ \z }xms ) {

        # Check if we can get an ID for this queue name.
        my $DestID = $QueueObject->QueueLookup(
            Queue => $Param{Dest},
        );

        if ($DestID) {
            $Param{Dest} = $DestID . '||' . $Param{Dest};
        }
        else {
            $Param{Dest} = '';
        }
    }

    my ( $NewQueueID, $From ) = split( /\|\|/, $Param{Dest} );
    $NewQueueID ||= $Param{QueueID} // '';
    if ($NewQueueID) {
        my %Queue = $QueueObject->GetSystemAddress( QueueID => $NewQueueID );
        $Param{QueueID} = $NewQueueID;
        $Param{Queue}   = $Queue{Name};
    }

    # Check for a given DynamicField name.
    if ( !$DynamicFieldName || !IsStringWithData($DynamicFieldName) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DynamicFieldName!",
        );

        return $Self->_Return();
    }

    # Get the pure DynamicField name without prefix
    $DynamicFieldName = substr( $DynamicFieldName, length 'DynamicField_' );

    # get the dynamic field value for the current ticket
    my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        Name => $DynamicFieldName,
    );

    # determine the maximum amount of displayable results
    my $ResultLimit = 0;

    if (
        defined $DynamicFieldConfig->{Config}->{ResultLimit}
        && $DynamicFieldConfig->{Config}->{ResultLimit} =~ /^\d+$/
        && $DynamicFieldConfig->{Config}->{ResultLimit} > 0
        )
    {
        $ResultLimit = $DynamicFieldConfig->{Config}->{ResultLimit};
    }

    # ---------------------------------------------------------- #
    # AJAXGetDynamicFieldConfig
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'AJAXGetDynamicFieldConfig' ) {

        # just push the multiselect configuration for security reasons
        my @Result;
        push @Result, { Multiselect => $DynamicFieldConfig->{Config}->{Multiselect} };

        return $Self->_Return(
            Data => \@Result,
        );
    }

    # ---------------------------------------------------------- #
    # SearchByAutoCompletion
    # ---------------------------------------------------------- #
    else {

        # get the dynamic field database object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::DynamicFieldDB' => {
                DynamicFieldConfig => $DynamicFieldConfig,
            },
        );
        my $DynamicFieldDBObject = $Kernel::OM->Get('Kernel::System::DynamicFieldDB');

        # add prefix and suffix if present
        if ( IsStringWithData( $DynamicFieldConfig->{Config}->{Searchprefix} ) ) {
            $Search = $DynamicFieldConfig->{Config}->{Searchprefix} . $Search;
        }
        if ( IsStringWithData( $DynamicFieldConfig->{Config}->{Searchsuffix} ) ) {
            $Search .= $DynamicFieldConfig->{Config}->{Searchsuffix};
        }

        # result caching
        my $CacheKey    = $DynamicFieldName . ';' . $Search . ';' . $Identifier;
        my $CacheTTL    = $DynamicFieldConfig->{Config}->{CacheTTL};
        my $CacheType   = 'DynamicFieldDB';
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        if ($CacheTTL) {

            my $CacheResult = $CacheObject->Get(
                Type => $CacheType,
                Key  => $CacheKey,
            );

            if ( ref $CacheResult eq 'ARRAY' ) {
                return $Self->_Return(
                    Data => $CacheResult,
                );
            }
        }

        # perform the search based on the given dynamic field config
        my @Result = $DynamicFieldDBObject->DatabaseSearchByConfig(
            Config      => $DynamicFieldConfig->{Config},
            Search      => $Search,
            Identifier  => $Identifier,
            TicketID    => $TicketID,
            ResultLimit => $ResultLimit,
            %Param,
        );

        # undef result if nothing to be returned
        if ( IsArrayRefWithData( $Result[0] ) ) {

            # update / set the cache
            $CacheObject->Set(
                Type  => $CacheType,
                Key   => $CacheKey,
                Value => \@Result,
                TTL   => $CacheTTL,
            );

            return $Self->_Return(
                Data => \@Result,
            );
        }
        else {
            return $Self->_Return();
        }
    }
}

sub _Return {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build JSON output
    my $JSON;
    if ( IsArrayRefWithData( $Param{Data} ) ) {
        $JSON = $LayoutObject->JSONEncode(
            Data => $Param{Data},
        );
    }

    # send response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON || $LayoutObject->JSONEncode(
            Data => [],
        ),
        Type    => 'inline',
        NoCache => 1,
    );
}

1;
