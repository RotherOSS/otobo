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

package Kernel::System::DynamicFieldDB;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
);

use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::DynamicFieldDB - module to interact with the databases

=head1 DESCRIPTION

All methods for the communication to external databases

=head1 PUBLIC INTERFACE


=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $DynamicFieldDBObject = $Kernel::OM->Get('Kernel::System::DynamicFieldDB');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed config
    die "Got no DynamicFieldConfig!" if !$Param{DynamicFieldConfig};
    $Self->{DynamicFieldConfig} = $Param{DynamicFieldConfig};

    # generate the database DSN
    my $DatabaseDSN = '';
    if ( $Self->{DynamicFieldConfig}->{Config}->{DBType} eq 'oracle' ) {
        $DatabaseDSN = 'DBI:Oracle'
            . ':sid=' . $Self->{DynamicFieldConfig}->{Config}->{SID}
            . ';host=' . $Self->{DynamicFieldConfig}->{Config}->{Server}
            . ';port=' . $Self->{DynamicFieldConfig}->{Config}->{Port};
    }
    elsif ( $Self->{DynamicFieldConfig}->{Config}->{DBType} eq 'ODBC' ) {
        $DatabaseDSN = 'DBI:' . $Self->{DynamicFieldConfig}->{Config}->{DBType}
            . ':driver=' . $Self->{DynamicFieldConfig}->{Config}->{Driver}
            . ';database=' . $Self->{DynamicFieldConfig}->{Config}->{DBName}
            . ';server=' . $Self->{DynamicFieldConfig}->{Config}->{Server}
            . ';port=' . $Self->{DynamicFieldConfig}->{Config}->{Port};
    }
    elsif ( $Self->{DynamicFieldConfig}->{Config}->{DBType} eq 'postgresql' ) {
        $DatabaseDSN = 'DBI:Pg'
            . ':dbname=' . $Self->{DynamicFieldConfig}->{Config}->{DBName}
            . ';host=' . $Self->{DynamicFieldConfig}->{Config}->{Server};

        # Only append port if configured, DBD::Pg chokes otherwise.
        if ( $Self->{DynamicFieldConfig}->{Config}->{Port} ) {
            $DatabaseDSN .= ';port=' . $Self->{DynamicFieldConfig}->{Config}->{Port};
        }
    }
    else {
        $DatabaseDSN = 'DBI:' . $Self->{DynamicFieldConfig}->{Config}->{DBType}
            . ':database=' . $Self->{DynamicFieldConfig}->{Config}->{DBName}
            . ';host=' . $Self->{DynamicFieldConfig}->{Config}->{Server}
            . ';port=' . $Self->{DynamicFieldConfig}->{Config}->{Port};
    }

    # get the correct database type
    my $DatabaseType = '';
    if ( $Self->{DynamicFieldConfig}->{Config}->{DBType} eq 'ODBC' ) {
        $DatabaseType = 'mssql';
    }
    else {
        $DatabaseType = $Self->{DynamicFieldConfig}->{Config}->{DBType};
    }

    # get the specific database object
    $Self->{DBObject} = Kernel::System::DB->new(
        DatabaseDSN  => $DatabaseDSN,
        DatabaseUser => $Self->{DynamicFieldConfig}->{Config}->{User},
        DatabasePw   => $Self->{DynamicFieldConfig}->{Config}->{Password},
        Type         => $DatabaseType,
    );

    $Self->{LikeEscapeString} = $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString');

    return $Self;
}

=head2 DatabaseSearchByConfig()

returns an array with the search results and additional meta information

    my @Result = $DynamicFieldDBObject->DatabaseSearchByConfig(
        Config => $DynamicFieldConfig->{Config},
        Search => 'My Search Term',
    );

Returns:

    [
      [
        {
          'Datatype' => 'INTEGER',
          'Identifier' => '1',
          'Label' => 'test_id'
        },
        {
          'Data' => 'MyTestNode',
          'Label' => 'test_node'
        },
        {
          'Data' => 'MyTestCustomer',
          'Label' => 'test_kunde'
        },
        {
          'Data' => 'MyTestType',
          'Label' => 'test_typ'
        }
      ],
      [
        {
          'Datatype' => 'INTEGER',
          'Identifier' => '2',
          'Label' => 'test_id'
        },
        {
          'Data' => 'MyTestNode2',
          'Label' => 'test_node'
        },
        {
          'Data' => 'MyTestCustomer2',
          'Label' => 'test_kunde'
        },
        {
          'Data' => 'MyTestType2',
          'Label' => 'test_typ'
        }
      ]
    ];

=cut

sub DatabaseSearchByConfig {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Config} || !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need proper DynamicField configuration!',
        );
        return;
    }
    if ( ( !$Param{Search} || !IsStringWithData( $Param{Search} ) ) && !$Param{Identifier} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need proper search term for the sql statement or a valid identifier!',
        );
        return;
    }

    # prepare the possible values hash based on the
    # sequential number of any item
    my $PreparedPossibleValues = {};

    # user is on one of the ticket creation screens
    my $TicketCreationScreen = 0;

    KEY:
    for my $Key ( sort keys %{ $Param{Config}->{PossibleValues} } ) {

        next KEY if !$Key;

        if ( $Key =~ m/^\w+_(\d+)$/ ) {

            my $SequenceNumber = $1;

            if ( !IsHashRefWithData( $PreparedPossibleValues->{$SequenceNumber} ) ) {
                $PreparedPossibleValues->{$SequenceNumber} = {
                    "$Key" => $Param{Config}->{PossibleValues}->{$Key},
                };
            }
            else {

                # get the filter values if needed
                if (
                    $Key =~ m/^FieldFilter_(?:\d)$/
                    && $Param{Config}->{PossibleValues}->{$Key}
                    && $Param{TicketID}
                    )
                {
                    # check if we need ticket information or dynamic field information
                    if ( $Param{Config}->{PossibleValues}->{$Key} =~ m/^DynamicField_/ ) {

                        # get the pure DynamicField name without prefix
                        my $DFName = substr( $Param{Config}->{PossibleValues}->{$Key}, 13 );

                        # get dynamic field config
                        my $DFConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                            Name => $DFName,
                        );

                        # get the current dynamic field value to process
                        my $DynamicFieldValue = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
                            DynamicFieldConfig => $DFConfig,
                            ObjectID           => $Param{TicketID},
                        );

                        $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $DynamicFieldValue || '';
                    }
                    else {

                        # get the ticket information if a ticket id is given
                        my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
                            TicketID => $Param{TicketID},
                            UserID   => 1,
                            Extended => 1,
                        );

                        $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $TicketData{ $Param{Config}->{PossibleValues}->{$Key} };
                    }
                }
                else {

                    # if there is a param for the Key, but not TicketID => user is on one of the ticket creation screens
                    if ( $Param{ $Param{Config}->{PossibleValues}->{$Key} } ) {

                        # set possible values string just if we get the field filter key
                        # to prevent setting wrong keys if the configured database column
                        # is equal to one of the ticket data keys
                        if ( $Key =~ m/^FieldFilter_/smxi ) {

                            $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $Param{ $Param{Config}->{PossibleValues}->{$Key} };
                        }
                        else {
                            $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $Param{Config}->{PossibleValues}->{$Key};
                        }

                        $TicketCreationScreen++;
                    }
                    else {

                        $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $Param{Config}->{PossibleValues}->{$Key};
                    }
                }
            }
        }
    }

    # replace * with % in the search term
    $Param{Search} =~ s/\*/%/g;
    $Param{Search} =~ s/%%/%/g;

    # extract the SELECT items out of the possible values
    my $SQL = 'SELECT ';
    my @ResultDataTemplate;
    my @WHEREItems;
    my @BindParams;
    my @BindParamsNewOrder;
    my %FilterParams;
    my %ColumnKeyMap;
    my $FirstRun = 1;

    KEY:
    for my $Key ( sort keys %{$PreparedPossibleValues} ) {

        next KEY if !$Key;
        next KEY if !IsHashRefWithData( $PreparedPossibleValues->{$Key} );

        # create a hash for the meta information of every result
        my %MetaDataItem;

        # check for the identifier
        if ( $Key eq $Param{Config}->{Identifier} ) {

            # set the identifier flag
            $MetaDataItem{Identifier} = $Param{Config}->{Identifier};

            # the identifier needs the datatype as well
            # (this column will be stored in the dynamic field)
            $MetaDataItem{Datatype} = $PreparedPossibleValues->{$Key}->{"FieldDatatype_$Key"};
        }

        # check if the field is a 'searchfield' and should belong to
        # the WHERE clauses
        if ( $PreparedPossibleValues->{$Key}->{"Searchfield_$Key"} ) {

            # fill the where items with the field names
            push @WHEREItems, $PreparedPossibleValues->{$Key}->{"FieldName_$Key"};

            # push a bind param for every where clause
            # use the filter value if given
            # only if there is a TicketID or user is on Ticket Creation Screen
            if (
                $PreparedPossibleValues->{$Key}->{"FieldFilter_$Key"}
                && ( $Param{TicketID} || $TicketCreationScreen )
                )
            {

                # save the column name which will be filtered
                $FilterParams{ $PreparedPossibleValues->{$Key}->{"FieldName_$Key"} } = 1;

                push @BindParams, \$PreparedPossibleValues->{$Key}->{"FieldFilter_$Key"};

                # save the array key of the fieldname for @BindParams
                $ColumnKeyMap{ $PreparedPossibleValues->{$Key}->{"FieldName_$Key"} } = scalar @BindParams - 1;
            }
            else {
                push @BindParams, \$Param{Search};

                # save the array key of the fieldname for @BindParams
                $ColumnKeyMap{ $PreparedPossibleValues->{$Key}->{"FieldName_$Key"} } = scalar @BindParams - 1;
            }
        }

        # check if the field is a 'listfield' and should belong to
        # the SELECT FROM clauses.
        if (
            $PreparedPossibleValues->{$Key}->{"Listfield_$Key"}
            || $Key eq $Param{Config}->{Identifier}
            )
        {

            # save the label per result set
            if ( IsStringWithData( $PreparedPossibleValues->{$Key}->{"FieldLabel_$Key"} ) ) {
                $MetaDataItem{Label} = $PreparedPossibleValues->{$Key}->{"FieldLabel_$Key"};
            }

            # check for the identifier
            if (
                $PreparedPossibleValues->{$Key}->{"Listfield_$Key"}
                && $Key eq $Param{Config}->{Identifier}
                )
            {
                $MetaDataItem{Listfield} = 'on';
            }

            if ($FirstRun) {
                $SQL .= $PreparedPossibleValues->{$Key}->{"FieldName_$Key"};
                $FirstRun = 0;
            }
            else {
                $SQL .= ',' . $PreparedPossibleValues->{$Key}->{"FieldName_$Key"};
            }

            # push the meta information to the meta data array
            push @ResultDataTemplate, \%MetaDataItem;
        }
    }

    # add the table to select from
    $SQL .= ' FROM ' . $Param{Config}->{DBTable};

    # add the WHERE clauses to the statement
    $SQL .= ' WHERE ';

    # check for case-sensitivity searches
    #
    # On Oracle, PostgreSQL and Oracle databases, the LIKE-Statements are
    # case-sensitive. On MySQL-Servers it depends on the currently used
    # collation of the desired table. Therefore the LOWER-Statement is used
    # on case-insensitive searches for every platform. If case-sensitive
    # searches are used on MySQL-Servers, the BINARY-Type will be used next
    # to the LIKE-Statements to make the patterns case-sensitive
    my $MySQLBinaryType = '';
    my $LOWEROpen       = '';
    my $LOWERClose      = '';

    if ( $Param{Config}->{CaseSensitive} ) {

        if ( $Param{Config}->{DBType} eq 'mysql' ) {

            # setup the mysql-related binary type for LIKE-Statements
            $MySQLBinaryType = 'BINARY';
        }
    }
    else {

        # use the LOWER-statements in case of insensitivity
        $LOWEROpen  = 'LOWER(';
        $LOWERClose = ')';
    }

    if ( $Param{Identifier} ) {

        my $IdentifierNumber    = $Param{Config}->{Identifier};
        my $IdentifierFieldName = $Param{Config}->{PossibleValues}->{"FieldName_$IdentifierNumber"};

        $SQL .= "$IdentifierFieldName=?";
        @BindParams = ();
        push @BindParams, \$Param{Identifier};
    }
    else {

        @BindParamsNewOrder = ();
        $FirstRun           = 1;

        # workaround for postgresql:
        # in postgresql LIKE-Statements are always string compares
        # therefore explicitly change the types
        my $FieldExtension = $Self->{DynamicFieldConfig}->{Config}->{DBType} eq 'postgresql' ? '::text' : '';

        my $WHERESQL = '';

        # process not filtered columns
        FIELD:
        for my $Field (@WHEREItems) {

            next FIELD if !$Field;

            if ($FirstRun) {

                if ( !$FilterParams{$Field} ) {

                    my $QuotedPart = $Self->{DBObject}->Quote( ${ $BindParams[ $ColumnKeyMap{$Field} ] }, 'Like' )
                        || '';

                    $WHERESQL
                        .= "$LOWEROpen $Field$FieldExtension $LOWERClose LIKE $MySQLBinaryType $LOWEROpen '$QuotedPart' $LOWERClose";

                    # proof of concept that oracle needs special treatment
                    # with underscores in LIKE argument, it always needs the ESCAPE parameter
                    # if you want to search for a literal _ (underscore)
                    # get like escape string needed for some databases (e.g. oracle)
                    # this does no harm for other databases, so it should always be used where
                    # a LIKE search is used
                    $WHERESQL .= $Self->{LikeEscapeString};

                    $FirstRun = 0;
                }
            }
            else {

                if ( !$FilterParams{$Field} ) {

                    my $QuotedPart = $Self->{DBObject}->Quote( ${ $BindParams[ $ColumnKeyMap{$Field} ] }, 'Like' )
                        || '';

                    $WHERESQL
                        .= " OR $LOWEROpen $Field$FieldExtension $LOWERClose LIKE $MySQLBinaryType $LOWEROpen '$QuotedPart' $LOWERClose";

                    # proof of concept that oracle needs special treatment
                    # with underscores in LIKE argument, it always needs the ESCAPE parameter
                    # if you want to search for a literal _ (underscore)
                    # get like escape string needed for some databases (e.g. oracle)
                    # this does no harm for other databases, so it should always be used where
                    # a LIKE search is used
                    $WHERESQL .= $Self->{LikeEscapeString};
                }
            }
        }

        if ($WHERESQL) {
            $SQL .= '( ' . $WHERESQL . ' ) ';
        }

        $WHERESQL = '';

        # reset the FirstRun counter and process the filtered columns
        FIELD:
        for my $Field (@WHEREItems) {

            next FIELD if !$Field;

            if ($FirstRun) {
                if ( $FilterParams{$Field} ) {

                    my $QuotedPart = $Self->{DBObject}->Quote( ${ $BindParams[ $ColumnKeyMap{$Field} ] }, 'Like' )
                        || '';

                    $WHERESQL
                        .= "$LOWEROpen $Field$FieldExtension $LOWERClose LIKE $MySQLBinaryType $LOWEROpen '$QuotedPart' $LOWERClose";

                    # proof of concept that oracle needs special treatment
                    # with underscores in LIKE argument, it always needs the ESCAPE parameter
                    # if you want to search for a literal _ (underscore)
                    # get like escape string needed for some databases (e.g. oracle)
                    # this does no harm for other databases, so it should always be used where
                    # a LIKE search is used
                    $WHERESQL .= $Self->{LikeEscapeString};

                    $FirstRun = 0;
                }
            }
            else {
                # AND-Chain on filtered columns
                if ( $FilterParams{$Field} ) {
                    $WHERESQL .= " AND $Field = ?";

                    # save the new bind param order
                    push @BindParamsNewOrder, $BindParams[ $ColumnKeyMap{$Field} ];
                }
            }
        }

        if ($WHERESQL) {
            $SQL .= $WHERESQL;
        }

        # overwrite the bind params with the new order
        @BindParams = @BindParamsNewOrder;
    }

    # determine if the result should be limited and ask the database
    if (
        $Param{ResultLimit}
        && $Param{ResultLimit} =~ /^\d+$/
        )
    {
        return if !$Self->{DBObject}->Prepare(
            SQL   => $SQL,
            Bind  => \@BindParams,
            Limit => $Param{ResultLimit},
        );
    }
    else {

        return if !$Self->{DBObject}->Prepare(
            SQL  => $SQL,
            Bind => \@BindParams,
        );
    }

    # result information
    my @Result;
    my $Count = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my @ResultItem;

        my $RowCount = scalar @Row;

        for my $Key ( 0 .. $RowCount ) {

            my %ResultItemField;

            # copy the label every row
            $ResultItemField{Label} = $ResultDataTemplate[$Count]->{Label};

            # check for the identifier
            if ( $ResultDataTemplate[$Count]->{Identifier} ) {

                # save the datatype for the identifier as well
                $ResultItemField{Datatype} = $ResultDataTemplate[$Count]->{Datatype};

                # save the value as identifier
                $ResultItemField{Identifier} = $Row[$Key];

                # check if the value should also be displayed
                if ( $ResultDataTemplate[$Count]->{Listfield} ) {
                    $ResultItemField{Data} = $Row[$Key];
                }
            }
            else {
                $ResultItemField{Data} = $Row[$Key];
            }

            $Count++;

            # push the current field to the ResultItem array
            push @ResultItem, \%ResultItemField;
        }

        # push the current result item (row) to the result array
        push @Result, \@ResultItem;

        # reset the counter
        $Count = 0;
    }

    return @Result;
}

sub DatabaseSearchDetails {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Config} || !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need proper DynamicField configuration!',
        );
        return;
    }

    if ( !$Param{Identifier} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need identifier to gather detailed data!',
        );
        return;
    }

    # prepare the possible values hash based on the
    # sequential number of any item
    my $PreparedPossibleValues = {};

    KEY:
    for my $Key ( sort keys %{ $Param{Config}->{PossibleValues} } ) {

        next KEY if !$Key;

        if ( $Key =~ m/^\w+_(\d+)$/ ) {

            my $SequenceNumber = $1;

            $PreparedPossibleValues->{$SequenceNumber} = {
                FieldName  => $Param{Config}->{PossibleValues}->{"FieldName_$SequenceNumber"},
                FieldLabel => $Param{Config}->{PossibleValues}->{"FieldLabel_$SequenceNumber"},
            };
        }
    }

    # extract the SELECT items out of the possible values
    my $SQL      = 'SELECT ';
    my $FirstRun = 1;
    my @PossibleValuesKeys;

    KEY:
    for my $Key ( sort keys %{$PreparedPossibleValues} ) {

        next KEY if !$Key;

        push @PossibleValuesKeys, $Key;

        if ($FirstRun) {
            $SQL .= $PreparedPossibleValues->{$Key}->{FieldName};
            $FirstRun = 0;
        }
        else {
            $SQL .= ',' . $PreparedPossibleValues->{$Key}->{FieldName};
        }
    }

    # add the table to select from
    $SQL .= ' FROM ' . $Param{Config}->{DBTable};

    # add the WHERE clauses to the statement
    $SQL .= ' WHERE ';

    my $IdentifierNumber    = $Param{Config}->{Identifier};
    my $IdentifierFieldName = $Param{Config}->{PossibleValues}->{"FieldName_$IdentifierNumber"};

    $SQL .= "$IdentifierFieldName=?";

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{Identifier} ],
        Limit => 1,
    );

    # result information
    my @Result;

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $RowCount = scalar @Row;

        KEY:
        for my $Key ( 0 .. $RowCount ) {

            my %ResultItemField;

            # copy the label of every row
            if ( $PossibleValuesKeys[$Key] ) {
                $ResultItemField{Label} = $PreparedPossibleValues->{ $PossibleValuesKeys[$Key] }->{FieldLabel};
            }

            next KEY if !$ResultItemField{Label};

            # copy value for label
            $ResultItemField{Data} = $Row[$Key];

            # push the current field to the ResultItem array
            push @Result, \%ResultItemField;
        }
    }

    return \@Result;
}

=head2 DatabaseSearchByAttributes()

returns a hash with the search results

    my @Result = $DynamicFieldDBObject->DatabaseSearchByAttributes(
        Config => $DynamicFieldConfig->{Config},
        Search => \%MySearchTerms,
    );

Returns:

    {
      'Columns' => [
                     'type',
                     'customer',
                     'node'
                   ],
      'Data' => [
                  [
                    'MyTestType',
                    'MyTestCustomer',
                    'MyTestNode'
                  ],
                  [
                    'MyTestType2',
                    'MyTestCustomer2',
                    'MyTestNode2'
                  ]
                ]
    };

=cut

sub DatabaseSearchByAttributes {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Config} || !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need proper DynamicField configuration!',
        );
        return;
    }

    if ( !$Param{Search} || !IsHashRefWithData( $Param{Search} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need proper search terms for the sql statement!',
        );
        return;
    }

    # prepare the possible values hash based on the
    # sequential number of any item
    my $PreparedPossibleValues = {};
    my @FilterColumns;
    my @BindParams;

    KEY:
    for my $Key ( sort keys %{ $Param{Config}->{PossibleValues} } ) {

        next KEY if !$Key;

        if ( $Key =~ m/^\w+_(\d+)$/ ) {

            my $SequenceNumber = $1;

            if ( !IsHashRefWithData( $PreparedPossibleValues->{$SequenceNumber} ) ) {
                $PreparedPossibleValues->{$SequenceNumber} = {
                    "$Key" => $Param{Config}->{PossibleValues}->{$Key},
                };
            }
            else {

                # get the filter values if needed
                if (
                    $Key =~ m/^FieldFilter_(?:\d)$/
                    && $Param{Config}->{PossibleValues}->{$Key}
                    && $Param{TicketID}
                    )
                {

                    # check if we need ticket information or dynamic field information
                    if ( $Param{Config}->{PossibleValues}->{$Key} =~ m/^DynamicField_/ ) {

                        # get the pure DynamicField name without prefix
                        my $DFName = substr( $Param{Config}->{PossibleValues}->{$Key}, 13 );

                        # get dynamic field config
                        my $DFConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                            Name => $DFName,
                        );

                        # get the current dynamic field value to process
                        my $DynamicFieldValue = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
                            DynamicFieldConfig => $DFConfig,
                            ObjectID           => $Param{TicketID},
                        );

                        $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $DynamicFieldValue || '';
                    }
                    else {

                        # get the ticket information if a ticket id is given
                        my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
                            TicketID => $Param{TicketID},
                            UserID   => 1,
                            Extended => 1,
                        );

                        $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $TicketData{ $Param{Config}->{PossibleValues}->{$Key} };

                    }
                }
                else {

                    # if there is a param for the Key, but not TicketID => user is on one of the ticket creation screens
                    if ( $Param{ $Param{Config}->{PossibleValues}->{$Key} } ) {

                        # set possible values string just if we get the field filter key
                        # to prevent setting wrong keys if the configured database column
                        # is equal to one of the ticket data keys
                        if ( $Key =~ m/^FieldFilter_/smxi ) {

                            $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $Param{ $Param{Config}->{PossibleValues}->{$Key} };
                        }
                        else {
                            $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $Param{Config}->{PossibleValues}->{$Key};
                        }
                    }
                    else {

                        $PreparedPossibleValues->{$SequenceNumber}->{$Key} = $Param{Config}->{PossibleValues}->{$Key};
                    }
                }

                if (
                    $Key =~ m/^FieldFilter_/smxi
                    && $Param{Config}->{PossibleValues}->{$Key}
                    )
                {

                    push @FilterColumns, $Param{Config}->{PossibleValues}->{"FieldName_$SequenceNumber"};

                    if ( $Param{ $Param{Config}->{PossibleValues}->{$Key} } ) {
                        push @BindParams, \$Param{ $Param{Config}->{PossibleValues}->{$Key} };
                    }
                    else {
                        push @BindParams, \$PreparedPossibleValues->{$SequenceNumber}->{$Key};
                    }
                }
            }
        }
    }

    # extract the SELECT items out of the possible values
    my $SQL = 'SELECT ';
    my @ResultDataTemplate;
    my @SELECTItems;
    my @WHERESQL;
    my $Counter       = 0;
    my $IdentifierKey = 0;
    my $FirstRun      = 1;

    # iterate over all available fields
    FIELDID:
    for my $FieldID ( sort keys %{$PreparedPossibleValues} ) {

        next FIELDID if !$FieldID;

        # do not process columns that are not searchable, listable or identifier
        if (
            !$PreparedPossibleValues->{$FieldID}->{"Listfield_$FieldID"}
            && !$PreparedPossibleValues->{$FieldID}->{"Searchfield_$FieldID"}
            && $Param{Config}->{Identifier} != $FieldID
            )
        {
            next FIELDID;
        }

        # get the current column name
        my $ColumnName = $PreparedPossibleValues->{$FieldID}->{"FieldName_$FieldID"};

        # get SELECT items
        if (
            $PreparedPossibleValues->{$FieldID}->{"Listfield_$FieldID"}
            || $FieldID == $Param{Config}->{Identifier}
            )
        {

            # save the identifier key
            if ( $FieldID == $Param{Config}->{Identifier} ) {
                $IdentifierKey = $Counter;
            }

            if ($FirstRun) {
                $SQL .= "$ColumnName";
                $FirstRun = 0;
            }
            else {
                $SQL .= ",$ColumnName";
            }

            # get the WHERE parameters
            push @SELECTItems, $ColumnName;
        }

        # check for case-sensitivity searches
        #
        # On Oracle, PostgreSQL and Oracle databases, the LIKE-Statements are
        # case-sensitive. On MySQL-Servers it depends on the currently used
        # collation of the desired table. Therefore the LOWER-Statement is used
        # on case-insensitive searches for every platform. If case-sensitive
        # searches are used on MySQL-Servers, the BINARY-Type will be used next
        # to the LIKE-Statements to make the patterns case-sensitive
        my $MySQLBinaryType = '';
        my $LOWEROpen       = '';
        my $LOWERClose      = '';

        if ( $Param{Config}->{CaseSensitive} ) {

            if ( $Param{Config}->{DBType} eq 'mysql' ) {

                # setup the mysql-related binary type for LIKE-Statements
                $MySQLBinaryType = 'BINARY';
            }
        }
        else {

            # use the LOWER-statements in case of insensitivity
            $LOWEROpen  = 'LOWER(';
            $LOWERClose = ')';
        }

        # get WHERE items and Bind params
        if ( $Param{Search}->{$FieldID} && $ColumnName ) {

            # workaround for postgresql:
            # in postgresql LIKE-Statements are always string compares
            # therefore explicitly change the types
            if ( $Self->{DynamicFieldConfig}->{Config}->{DBType} eq 'postgresql' ) {
                $ColumnName .= '::text';
            }

            # replace * with % in the search parameters
            my $BindParam = $Param{Search}->{$FieldID};
            $BindParam =~ s/\*/%/g;
            $BindParam =~ s/%%/%/g;

            my $QuotedPart = $Self->{DBObject}->Quote( $BindParam, 'Like' );

            # proof of concept that oracle needs special treatment
            # with underscores in LIKE argument, it always needs the ESCAPE parameter
            # if you want to search for a literal _ (underscore)
            # get like escape string needed for some databases (e.g. oracle)
            # this does no harm for other databases, so it should always be used where
            # a LIKE search is used

            # get the WHERE parameters
            push @WHERESQL,
                "$LOWEROpen $ColumnName $LOWERClose LIKE $MySQLBinaryType $LOWEROpen '$QuotedPart' $LOWERClose"
                . $Self->{LikeEscapeString};
        }

        $Counter++;
    }

    # Create SQL filter.
    my $SQLFilter = '';
    for my $ColumnName (@FilterColumns) {
        $SQLFilter .= " AND $ColumnName = ? ";
    }

    # add the table to select from
    $SQL .= ' FROM ' . $Param{Config}->{DBTable};

    # add the WHERE clauses to the statement
    if ( IsArrayRefWithData( \@WHERESQL ) ) {
        $SQL .= ' WHERE ' . join( ' AND ', @WHERESQL ) . $SQLFilter;
    }

    # determine if the result should be limited and ask the database
    if (
        $Param{ResultLimit} =~ /^\d+$/
        && $Param{ResultLimit} > 0
        )
    {
        return if !$Self->{DBObject}->Prepare(
            SQL   => $SQL,
            Bind  => \@BindParams,
            Limit => $Param{ResultLimit},
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL  => $SQL,
            Bind => \@BindParams,
        );
    }

    # result information
    my %Result;
    my @ResultData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my %ResultItem;

        # save the identifier
        $ResultItem{Identifier} = $Row[$IdentifierKey];

        # get the identifier field id
        my $IdentifierID = $Param{Config}->{Identifier};

        if ( !$PreparedPossibleValues->{$IdentifierID}->{"Listfield_$IdentifierID"} ) {

            # delete the identifier entry from the results
            splice @Row, $IdentifierKey, 1;
            delete $SELECTItems[$IdentifierKey];
        }

        # save the normal result
        $ResultItem{Data} = \@Row;

        # push the current result item (row) to the result array
        push @ResultData, \%ResultItem;
    }

    $Result{Data}    = \@ResultData;
    $Result{Columns} = \@SELECTItems;

    return %Result;
}

=head2 DatabaseSearchHistoricalData()

returns a hash with the search results

    my @Result = $DynamicFieldDBObject->DatabaseSearchHistoricalData(
        SelectFields    => \@SelectFields,
        DBTable         => $DynamicFieldConfig->{Config}->{DBName},
        IdentifierField => $IdentifierField,
        IdentifierValue => $IdentifierValue,
    );

Returns:

    [
        'MyTestType',
        'MyTestCustomer',
        'MyTestNode'
    ]

=cut

sub DatabaseSearchHistoricalData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SelectFields} || !IsArrayRefWithData( $Param{SelectFields} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need proper select fields array!',
        );
        return;
    }

    # validate needed data
    for my $Needed (
        qw(IdentifierField IdentifierValue)
        )
    {
        if ( !$Param{$Needed} ) {
            die "Got no $Needed!";
        }
    }

    # prepare the sql statement
    my $SQL = 'SELECT ';

    # iterate over all available select fields
    my $FirstRun = 1;

    FIELDNAME:
    for my $FieldName ( @{ $Param{SelectFields} } ) {

        next FIELDNAME if !$FieldName;

        if ($FirstRun) {
            $SQL .= "$FieldName";
            $FirstRun = 0;
        }
        else {
            $SQL .= ",$FieldName";
        }
    }

    # add the table to select from
    $SQL .= ' FROM ' . $Self->{DynamicFieldConfig}->{Config}->{DBTable};

    # add the WHERE clauses to the statement
    $SQL .= " WHERE $Param{IdentifierField}=?";

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{IdentifierValue} ],
        Limit => 1,
    );

    # result information
    my @Result;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        @Result = @Row;
    }

    return @Result;
}

1;
