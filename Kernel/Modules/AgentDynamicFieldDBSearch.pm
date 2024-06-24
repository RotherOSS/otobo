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

package Kernel::Modules::AgentDynamicFieldDBSearch;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

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
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my $UserObject  = $Kernel::OM->Get('Kernel::System::User');

    # get needed params
    my $DynamicFieldName = $ParamObject->GetParam( Param => 'DynamicFieldName' ) || '';
    my $TicketID         = $ParamObject->GetParam( Param => 'TicketID' )         || '';
    my $Search           = $ParamObject->GetParam( Param => 'Term' )             || '';
    my $Identifier       = $ParamObject->GetParam( Param => 'Identifier' )       || '';

    # put all ticket related data in Param
    $Param{CustomerUserID} = $ParamObject->GetParam( Param => 'SelectedCustomerUser' );
    $Param{CustomerID}     = $ParamObject->GetParam( Param => 'CustomerID' );
    $Param{ResponsibleID}  = $ParamObject->GetParam( Param => 'NewResponsibleID' ) || '';
    $Param{OwnerID}        = $ParamObject->GetParam( Param => 'NewUserID' )        || '';
    $Param{Dest}           = $ParamObject->GetParam( Param => 'Dest' )             || '';
    $Param{PriorityID}     = $ParamObject->GetParam( Param => 'PriorityID' )       || '';
    $Param{ServiceID}      = $ParamObject->GetParam( Param => 'ServiceID' )        || '';
    $Param{SLAID}          = $ParamObject->GetParam( Param => 'SLAID' )            || '';
    $Param{StateID}        = $ParamObject->GetParam( Param => 'NextStateID' )      || '';
    $Param{Subject}        = $ParamObject->GetParam( Param => 'Subject' )          || '';
    $Param{TypeID}         = $ParamObject->GetParam( Param => 'TypeID' )           || '';

    # Also get params from process management
    $Param{QueueID} = $ParamObject->GetParam( Param => 'QueueID' ) || '';
    $Param{CustomerUserID} ||= $ParamObject->GetParam( Param => 'CustomerUserID' ) || '';
    $Param{ResponsibleID}  ||= $ParamObject->GetParam( Param => 'ResponsibleID' )  || '';
    $Param{OwnerID}        ||= $ParamObject->GetParam( Param => 'OwnerID' )        || '';
    $Param{StateID}        ||= $ParamObject->GetParam( Param => 'StateID' )        || '';

    # get all the dynamic fields
    my $DynamicFields = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => [ 'Ticket', 'Article' ],
    );

    my @DynamicFieldNames;

    # get DynamicField values
    DYNAMICFIELD:
    for my $DynamicFieldConfig (@$DynamicFields) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        push @DynamicFieldNames, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    # fetch Dynamic fields
    for my $Name (@DynamicFieldNames) {
        $Param{$Name} = $ParamObject->GetParam( Param => $Name );
    }

    # get type using TypeID if it's defined
    if ( $Param{TypeID} ) {

        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
            ID => $Param{TypeID},
        );

        if (%Type) {
            $Param{Type} = $Type{Name};
        }
    }

    # get Priority using Prio if it's defined
    if ( $Param{PriorityID} ) {

        my %PriorityList = $Kernel::OM->Get('Kernel::System::Priority')->PriorityGet(
            PriorityID => $Param{PriorityID},
            UserID     => 1,
        );

        if (%PriorityList) {
            $Param{Priority} = $PriorityList{Name};
        }
    }

    # get SLA using SLA  if it's defined
    if ( $Param{SLAID} ) {

        my %SLAData = $Kernel::OM->Get('Kernel::System::SLA')->SLAGet(
            SLAID  => $Param{SLAID},
            UserID => 1,
        );

        if (%SLAData) {
            $Param{SLA} = $SLAData{Name};
        }
    }

    # get State
    if ( $Param{StateID} ) {

        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        my %State = $StateObject->StateGet(
            ID => $Param{StateID},
        );

        if (%State) {
            $Param{State} = $State{Name};

            # get StateType
            my %List = $StateObject->StateGetStatesByType(
                Type   => 'Viewable',
                Result => 'HASH',
            );

            if ( IsHashRefWithData( \%List ) ) {
                my %StateType = reverse %List;
                $Param{StateType} = $StateType{ $State{Name} };
            }
        }
    }

    # get Service
    if ( $Param{ServiceID} ) {

        my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceGet(
            ServiceID => $Param{ServiceID},
            UserID    => 1,
        );

        if ( IsHashRefWithData( \%Service ) ) {
            $Param{Service} = $Service{Name};
        }
    }

    # see if only a name has been passed
    if ( $Param{Dest} && $Param{Dest} !~ m{ \A (\d+)? \| \| .+ \z }xms ) {

        # see if we can get an ID for this queue name
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

    # get Owner
    if ( $Param{OwnerID} ) {

        # get Owner and Responsible names
        my %Owner = $UserObject->GetUserData(
            UserID => $Param{OwnerID},
        );

        $Param{Owner} = $Owner{UserLogin} if %Owner;
    }

    # get Responsible
    if ( $Param{ResponsibleID} ) {
        my %Responsible = $UserObject->GetUserData(
            UserID => $Param{ResponsibleID},
        );

        $Param{Responsible} = $Responsible{UserLogin};
    }

    # check for a given DynamicField name
    if ( !$DynamicFieldName || !IsStringWithData($DynamicFieldName) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DynamicFieldName!",
        );

        return $Self->_Return();
    }

    # get the pure DynamicField name without prefix
    $DynamicFieldName = substr( $DynamicFieldName, 13 );

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
        my $CacheKey  = $DynamicFieldName . ';' . $Search . ';' . $Identifier;
        my $CacheTTL  = $DynamicFieldConfig->{Config}->{CacheTTL};
        my $CacheType = 'DynamicFieldDB';

        # if db output is filtered, add the filter to the CacheKey
        for my $Key ( sort keys %{ $DynamicFieldConfig->{Config}{PossibleValues} } ) {
            if ( $Key =~ /^FieldFilter_/ && $DynamicFieldConfig->{Config}{PossibleValues}{$Key} =~ /^(DynamicField_.+)/ ) {
                my $Content = $Param{$1} // '';
                my ($FieldNo) = $Key =~ /^FieldFilter_(\d+)/;
                $CacheKey .= ";$FieldNo:$Content";
            }
        }

        if ($CacheTTL) {

            my $CacheResult = $Kernel::OM->Get('Kernel::System::Cache')->Get(
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
            %Param
        );

        # undef result if nothing to be returned
        if ( IsArrayRefWithData( $Result[0] ) ) {

            # Setting the time to live to 0 effectively disables caching.
            # Don't even call Set(), in order to avoid error messages from Kernel::System::Cache::Redis
            if ($CacheTTL) {
                $Kernel::OM->Get('Kernel::System::Cache')->Set(
                    Type  => $CacheType,
                    Key   => $CacheKey,
                    Value => \@Result,
                    TTL   => $CacheTTL,
                );
            }

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
    if ( IsArrayRefWithData( $Param{Data} ) ) {
        return $LayoutObject->JSONReply(
            Data => $Param{Data},
        );
    }

    return $LayoutObject->JSONReply(
        Data => [],
    );
}

1;
