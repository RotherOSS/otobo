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

package Kernel::System::Ticket::Event::StoreHistoricalData;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::DynamicFieldDB ();
use Kernel::System::VariableCheck  qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    for my $NeededData (qw(TicketID)) {
        if ( !$Param{Data}->{$NeededData} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $NeededData in Data!",
            );
            return;
        }
    }

    # check for the correct events
    if ( $Param{Event} !~ m{^(?:TicketDynamicFieldUpdate_.+?|ArticleDynamicFieldUpdate)$} ) {
        return;
    }

    # Loop protection: only execute this handler once for each ticket.
    return if $Kernel::OM->Get('Kernel::System::Ticket')->{StoreHistoricalData}->{ $Param{Data}->{TicketID} }++;

    # check for article id during article dynamic field updates
    if ( $Param{Event} eq 'ArticleDynamicFieldUpdate' ) {
        if ( !$Param{Data}->{ArticleID} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need ArticleID in Data!",
            );
            return;
        }
    }

    # check if we got a ticket or article to process and save the data
    # as well as the related object id for further processing
    my %ObjectData;
    my $ObjectID;

    if ( $Param{Event} =~ m{^(?:TicketDynamicFieldUpdate_.+?)$} ) {

        # get the data of the ticket
        %ObjectData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{Data}->{TicketID},
            DynamicFields => 1,
            UserID        => 1,
        );

        # save the ticket id
        $ObjectID = $Param{Data}->{TicketID};
    }
    else {

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
            TicketID  => $Param{Data}->{TicketID},
            ArticleID => $Param{Data}->{ArticleID},
        );

        # get the data of the ticket
        %ObjectData = $ArticleBackendObject->ArticleGet(
            TicketID      => $Param{Data}->{TicketID},
            ArticleID     => $Param{Data}->{ArticleID},
            DynamicFields => 1,
            UserID        => 1,
        );

        # save the article id
        $ObjectID = $Param{Data}->{ArticleID};
    }

    # get dynamic field object
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # iterate over the dynamic fields
    OBJECTDATAKEY:
    for my $ObjectDataKey ( sort keys %ObjectData ) {

        next OBJECTDATAKEY if !$ObjectDataKey;
        next OBJECTDATAKEY if $ObjectDataKey !~ m{DynamicField_.+?};
        next OBJECTDATAKEY if !$ObjectData{$ObjectDataKey};

        # get the pure DynamicField name without prefix
        my $DynamicFieldName = substr( $ObjectDataKey, 13 );

        # get dynamic field config
        my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicFieldName,
        );

        next OBJECTDATAKEY if !IsHashRefWithData($DynamicFieldConfig);
        next OBJECTDATAKEY if $DynamicFieldConfig->{FieldType} ne 'Database';

        # get the database table column <-> dynamic field mapping
        my $HistoricalDataMappingConfig = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFieldDB::StoreHistoricalData');

        # skip if we got no configuration
        return 1 if !$HistoricalDataMappingConfig;

        if ( !IsHashRefWithData($HistoricalDataMappingConfig) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Error reading the configuration while storing historical data!',
            );
        }

        # prepare the historical data mapping
        my %HistoricalDataMapping;
        my $SourceMatch = 0;

        # Sort keys by starting numbers instead of lexical sort.
        # Key '9-SourceDynamicField5' has to be before key '10-TargetDynamicFields5'.
        MAPPINGKEY:
        for my $MappingKey (
            sort { ( $a =~ m/^(\d+)/ )[0] <=> ( $b =~ m/^(\d+)/ )[0] }
            keys %{$HistoricalDataMappingConfig}
            )
        {

            next MAPPINGKEY if !$MappingKey;
            next MAPPINGKEY if !$HistoricalDataMappingConfig->{$MappingKey};

            # store source dynamic field and target fields per key
            if ( $MappingKey =~ m{^(?:\d+)-SourceDynamicField(\d+)$} ) {

                # check if the source entry matches the current dynamic field
                next MAPPINGKEY if $HistoricalDataMappingConfig->{$MappingKey} ne $DynamicFieldName;

                $HistoricalDataMapping{$1}->{Source} = $HistoricalDataMappingConfig->{$MappingKey};
                $SourceMatch = 1;
            }
            elsif ( $MappingKey =~ m{^(?:\d+)-TargetDynamicFields(\d+)$} ) {

                # save target field entries if we have a related source entry
                next MAPPINGKEY if !$HistoricalDataMapping{$1};
                next MAPPINGKEY if !IsStringWithData( $HistoricalDataMapping{$1}->{Source} );

                $HistoricalDataMapping{$1}->{Target} = $HistoricalDataMappingConfig->{$MappingKey};
            }
        }

        # source dynamic field don't match the configuration entries
        next OBJECTDATAKEY if !$SourceMatch;

        # throw an error if more than one configuration option points
        # to the same source dynamic field
        if ( scalar keys %HistoricalDataMapping > 1 ) {

            my $MultipleFieldUse = 0;
            my %FieldSeen;

            KEY:
            for my $Key ( sort keys %HistoricalDataMapping ) {

                next KEY if !$Key;
                next KEY if !IsHashRefWithData( $HistoricalDataMapping{$Key} );

                if ( $FieldSeen{ $HistoricalDataMapping{$Key}->{Source} } ) {
                    $MultipleFieldUse = 1;
                    last KEY;
                }

                $FieldSeen{ $HistoricalDataMapping{$Key}->{Source} } = 1;
            }

            if ($MultipleFieldUse) {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        'More than one configuration option points to the same source dynamic field!',
                );
                return;
            }
        }

        # get the current dynamic field value to process
        my $DynamicFieldValue = $BackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $ObjectID,
        );

        # prepare identifier values to be processed
        my @IdentifierValues;

        if ( ref $DynamicFieldValue eq 'ARRAY' ) {
            @IdentifierValues = @{$DynamicFieldValue};
        }
        else {

            my @CommaSeparatedValues = split /,/, $Param{Value};

            if ( IsArrayRefWithData( \@CommaSeparatedValues ) ) {
                @IdentifierValues = @CommaSeparatedValues;
            }
            else {
                @IdentifierValues = ( $Param{Value} );
            }
        }

        next OBJECTDATAKEY if !IsArrayRefWithData( \@IdentifierValues );

        # get the identifier field name
        my $IdentifierNumber = $DynamicFieldConfig->{Config}->{Identifier};
        my $IdentifierField  = $DynamicFieldConfig->{Config}->{PossibleValues}->{"FieldName_$IdentifierNumber"};

        # get the only key in the mapping hash
        my $DataMappingKey;

        KEY:
        for my $Key ( sort keys %HistoricalDataMapping ) {
            if ( $Key && IsHashRefWithData( $HistoricalDataMapping{$Key} ) ) {
                $DataMappingKey = $Key;
                last KEY;
            }
        }

        # get the fields to require from the database
        my @SearchFields = ( sort keys %{ $HistoricalDataMapping{$DataMappingKey}->{Target} } );

        # get the dynamic field database object
        my $DynamicFieldDBObject = Kernel::System::DynamicFieldDB->new(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        # execute the request
        my @Result = $DynamicFieldDBObject->DatabaseSearchHistoricalData(
            SelectFields    => \@SearchFields,
            IdentifierField => $IdentifierField,
            IdentifierValue => $IdentifierValues[-1],
        );

        # save the results in the target dynamic fields
        my $ResultCounter = 0;
        KEY:
        for my $Key (@SearchFields) {

            next KEY if !$Key;

            my $TargetDynamicFieldName = $HistoricalDataMapping{$DataMappingKey}->{Target}->{$Key};

            # get dynamic field config
            my $TargetDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $TargetDynamicFieldName,
            );

            if ( !IsHashRefWithData($TargetDynamicFieldConfig) ) {

                # for the next value
                $ResultCounter++;

                next KEY;
            }

            # save the value in the target dynamic field
            my $Success = $BackendObject->ValueSet(
                DynamicFieldConfig => $TargetDynamicFieldConfig,
                ObjectID           => $ObjectID,
                Value              => $Result[$ResultCounter],
                UserID             => 1,
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'Error saving historical data in the target dynamic field!',
                );
            }

            # for the next value
            $ResultCounter++;
        }
    }

    return 1;
}

1;
