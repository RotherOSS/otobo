# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::DB::mysql;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub new {
    my ( $Class, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Class;
}

sub LoadPreferences {
    my ( $Self, %Param ) = @_;

    # db settings
    $Self->{'DB::Limit'}                = 'limit';
    $Self->{'DB::DirectBlob'}           = 1;
    $Self->{'DB::QuoteSingle'}          = '\\';
    $Self->{'DB::QuoteBack'}            = '\\';
    $Self->{'DB::QuoteSemicolon'}       = '\\';
    $Self->{'DB::QuoteUnderscoreStart'} = '\\';
    $Self->{'DB::QuoteUnderscoreEnd'}   = '';
    $Self->{'DB::CaseSensitive'}        = 0;
    $Self->{'DB::LikeEscapeString'}     = '';

    # how to determine server version
    # version can have package prefix, we need to extract that
    # example of VERSION() output: '5.5.32-0ubuntu0.12.04.1'
    # if VERSION() contains 'MariaDB', add MariaDB, otherwise MySQL.
    $Self->{'DB::Version'} = "SELECT CONCAT( IF (INSTR( VERSION(),'MariaDB'),'MariaDB ','MySQL '), SUBSTRING_INDEX(VERSION(),'-',1))";

    # how to get list of tables in the current schema
    $Self->{'DB::ListTables'} = 'SHOW TABLES';

    # how to turn off foreign key checks for the current session
    $Self->{'DB::DeactivateForeignKeyChecks'} = 'SET FOREIGN_KEY_CHECKS = 0';

    # how to delete all rows of a table, use with sprintf for inserting the table name
    $Self->{'DB::PurgeTable'} = 'TRUNCATE TABLE %s';

    # this is primarily needed during migration
    $Self->{'DB::Substring'} = 'SUBSTRING(%s, %s, %s)';

    # DBI/DBD::mysql attributes
    # disable automatic reconnects as they do not execute DB::Connect, which will
    # cause charset problems
    $Self->{'DB::Attribute'} = {
        mysql_auto_reconnect => 0,
    };

    # set current time stamp if different to "current_timestamp"
    $Self->{'DB::CurrentTimestamp'} = '';

    # set encoding of selected data to utf8
    $Self->{'DB::Encode'} = 1;

    # shell setting
    $Self->{'DB::Comment'}     = '# ';
    $Self->{'DB::ShellCommit'} = ';';

    #$Self->{'DB::ShellConnect'} = '';

    # init sql setting on db connect
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        $Self->{'DB::Connect'} = 'SET NAMES utf8mb4';
    }

    return 1;
}

sub Quote {
    my ( $Self, $Text, $Type ) = @_;

    if ( defined ${$Text} ) {
        if ( $Self->{'DB::QuoteBack'} ) {
            ${$Text} =~ s/\\/$Self->{'DB::QuoteBack'}\\/g;
        }
        if ( $Self->{'DB::QuoteSingle'} ) {
            ${$Text} =~ s/'/$Self->{'DB::QuoteSingle'}'/g;
        }
        if ( $Self->{'DB::QuoteSemicolon'} ) {
            ${$Text} =~ s/;/$Self->{'DB::QuoteSemicolon'};/g;
        }
        if ( $Type && $Type eq 'Like' ) {
            if ( $Self->{'DB::QuoteUnderscoreStart'} || $Self->{'DB::QuoteUnderscoreEnd'} ) {
                ${$Text}
                    =~ s/_/$Self->{'DB::QuoteUnderscoreStart'}_$Self->{'DB::QuoteUnderscoreEnd'}/g;
            }
        }
    }

    return $Text;
}

sub DatabaseCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!'
        );

        return;
    }

    # return SQL
    return "CREATE DATABASE $Param{Name} DEFAULT CHARSET=utf8mb4";
}

sub DatabaseDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!'
        );

        return;
    }

    # return SQL
    return "DROP DATABASE IF EXISTS $Param{Name}";
}

sub TableCreate {
    my ( $Self, @Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SQLStart = '';
    my $SQLEnd   = '';
    my $SQL      = '';
    my @Column;
    my $TableName = '';
    my $ForeignKey;
    my %Foreign;
    my $IndexCurrent;
    my %Index;
    my $UniqCurrent;
    my %Uniq;
    my $PrimaryKey = '';
    my @Return;

    for my $Tag (@Param) {

        if (
            ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' )
            && $Tag->{TagType} eq 'Start'
            )
        {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQLStart .= $Self->{'DB::Comment'} . " create table $Tag->{Name}\n";
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }
        }
        if ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' ) {
            if ( $Tag->{TagType} eq 'Start' ) {
                $SQLStart .= "CREATE TABLE $Tag->{Name} (\n";
                $TableName = $Tag->{Name};
            }
            elsif ( $Tag->{TagType} eq 'End' ) {
                $SQLEnd .= ')';
            }
        }
        elsif ( $Tag->{Tag} eq 'Column' && $Tag->{TagType} eq 'Start' ) {
            push @Column, $Tag;
        }
        elsif ( $Tag->{Tag} eq 'Index' && $Tag->{TagType} eq 'Start' ) {
            $IndexCurrent = $Tag->{Name};
        }
        elsif ( $Tag->{Tag} eq 'IndexColumn' && $Tag->{TagType} eq 'Start' ) {
            push @{ $Index{$IndexCurrent} }, $Tag;
        }
        elsif ( $Tag->{Tag} eq 'Unique' && $Tag->{TagType} eq 'Start' ) {
            $UniqCurrent = $Tag->{Name} || $TableName . '_U_' . int( rand(999) );
        }
        elsif ( $Tag->{Tag} eq 'UniqueColumn' && $Tag->{TagType} eq 'Start' ) {
            push @{ $Uniq{$UniqCurrent} }, $Tag;
        }
        elsif ( $Tag->{Tag} eq 'ForeignKey' && $Tag->{TagType} eq 'Start' ) {
            $ForeignKey = $Tag->{ForeignTable};
        }
        elsif ( $Tag->{Tag} eq 'Reference' && $Tag->{TagType} eq 'Start' ) {
            push @{ $Foreign{$ForeignKey} }, $Tag;
        }
    }
    for my $Tag (@Column) {

        # type translation
        $Tag = $Self->_TypeTranslation($Tag);

        # add new line
        if ($SQL) {
            $SQL .= ",\n";
        }

        # normal data type
        $SQL .= "    $Tag->{Name} $Tag->{Type}";

        # handle require
        if ( $Tag->{Required} && lc $Tag->{Required} eq 'true' ) {
            $SQL .= ' NOT NULL';
        }
        else {
            $SQL .= ' NULL';
        }

        # handle default
        if ( defined $Tag->{Default} ) {
            if ( $Tag->{Type} =~ /int/i ) {
                $SQL .= " DEFAULT " . $Tag->{Default};
            }
            else {
                $SQL .= " DEFAULT '" . $Tag->{Default} . "'";
            }
        }

        # auto increment
        if ( $Tag->{AutoIncrement} && lc $Tag->{AutoIncrement} eq 'true' ) {
            $SQL .= ' AUTO_INCREMENT';
        }

        # add primary key
        if ( $Tag->{PrimaryKey} && $Tag->{PrimaryKey} =~ /true/i ) {
            $PrimaryKey = "    PRIMARY KEY($Tag->{Name})";
        }
    }

    # add primary key
    if ($PrimaryKey) {
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= $PrimaryKey;
    }

    # add uniq
    for my $Name ( sort keys %Uniq ) {
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= "    UNIQUE INDEX $Name (";
        my @Array = @{ $Uniq{$Name} };
        for ( 0 .. $#Array ) {
            if ( $_ > 0 ) {
                $SQL .= ', ';
            }
            $SQL .= $Array[$_]->{Name};
        }
        $SQL .= ')';
    }

    # add index
    for my $Name ( sort keys %Index ) {
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= "    INDEX $Name (";
        my @Array = @{ $Index{$Name} };
        for ( 0 .. $#Array ) {
            if ( $_ > 0 ) {
                $SQL .= ', ';
            }
            $SQL .= $Array[$_]->{Name};
            if ( $Array[$_]->{Size} ) {
                $SQL .= "($Array[$_]->{Size})";
            }
        }
        $SQL .= ')';
    }
    $SQL .= "\n";
    push @Return, $SQLStart . $SQL . $SQLEnd;

    # add foreign keys
    for my $ForeignKey ( sort keys %Foreign ) {
        my @Array = @{ $Foreign{$ForeignKey} };
        for ( 0 .. $#Array ) {
            push @{ $Self->{Post} },
                $Self->ForeignKeyCreate(
                    LocalTableName   => $TableName,
                    Local            => $Array[$_]->{Local},
                    ForeignTableName => $ForeignKey,
                    Foreign          => $Array[$_]->{Foreign},
                );
        }
    }

    return @Return;
}

sub TableDrop {
    my ( $Self, @Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SQL = '';
    for my $Tag (@Param) {
        if ( $Tag->{Tag} eq 'Table' && $Tag->{TagType} eq 'Start' ) {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQL .= $Self->{'DB::Comment'} . " drop table $Tag->{Name}\n";
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }
        }
        $SQL .= 'DROP TABLE IF EXISTS ' . $Tag->{Name};

        return $SQL;
    }

    return;
}

sub TableAlter {
    my ( $Self, @Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SQLStart = '';
    my @SQL;
    my @Index;
    my $IndexName     = '';
    my $ForeignTable  = '';
    my $ReferenceName = '';
    my @Reference;
    my $Table = '';

    for my $Tag (@Param) {

        if ( $Tag->{Tag} eq 'TableAlter' && $Tag->{TagType} eq 'Start' ) {
            $Table = $Tag->{Name} || $Tag->{NameNew};
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQLStart .= $Self->{'DB::Comment'} . " alter table $Table\n";
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }

            # rename table
            if ( $Tag->{NameOld} && $Tag->{NameNew} ) {
                push @SQL, $SQLStart . "ALTER TABLE $Tag->{NameOld} RENAME $Tag->{NameNew}";
            }
            $SQLStart .= "ALTER TABLE $Table";
        }
        elsif ( $Tag->{Tag} eq 'ColumnAdd' && $Tag->{TagType} eq 'Start' ) {

            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);

            # normal data type
            push @SQL, $SQLStart . " ADD $Tag->{Name} $Tag->{Type} NULL";

            # investigate the default value
            my $Default = '';
            if ( $Tag->{Type} =~ /int/i ) {
                $Default = defined $Tag->{Default} ? $Tag->{Default} : 0;
            }
            else {
                $Default = defined $Tag->{Default} ? "'$Tag->{Default}'" : "''";
            }

            # investigate Required and AutoIncrement
            my $Required      = ( $Tag->{Required}      && lc $Tag->{Required} eq 'true' )      ? 1 : 0;
            my $AutoIncrement = ( $Tag->{AutoIncrement} && lc $Tag->{AutoIncrement} eq 'true' ) ? 1 : 0;

            # handle default and require
            if ( $Required || defined $Tag->{Default} ) {

                # fill up empty rows
                push @SQL, "UPDATE $Table SET $Tag->{Name} = $Default WHERE $Tag->{Name} IS NULL";

                my $SQLAlter = "ALTER TABLE $Table CHANGE $Tag->{Name} $Tag->{Name} $Tag->{Type}";

                # add default
                if ( defined $Tag->{Default} ) {
                    $SQLAlter .= " DEFAULT $Default";
                }

                # add Required
                $SQLAlter .= $Required ? ' NOT NULL' : ' NULL';

                # add AutoIncrement, assuming the AutoIncrement fields are marked as Required
                $SQLAlter .= $AutoIncrement ? ' AUTO_INCREMENT' : '';

                push @SQL, $SQLAlter;
            }
        }
        elsif ( $Tag->{Tag} eq 'ColumnChange' && $Tag->{TagType} eq 'Start' ) {

            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);

            # When the altered column is a primary key then 'NOT NULL' is sensible,
            # and 'NULL' is not sensible. Setting the column to 'NULL' is only
            # useful for supporting default values. But default values are not needed
            # for primary keys anyways. So, for supporting altering primary keyse we
            # have the flag 'NoDefault' which evades all handling of default values.
            my $WithDefault = ( $Tag->{NoDefault} && lc $Tag->{NoDefault} eq 'true' ) ? 0 : 1;
            my $Default;

            # normal data type with NULL values allowed
            if ($WithDefault) {
                push @SQL, $SQLStart . " CHANGE $Tag->{NameOld} $Tag->{NameNew} $Tag->{Type} NULL";

                # set default as NULL (not on TEXT/BLOB/LONGBLOB type, not supported by mysql)
                if ( $Tag->{Type} !~ /^(TEXT|MEDIUMTEXT|BLOB|LONGBLOB)$/i ) {
                    push @SQL, "ALTER TABLE $Table CHANGE $Tag->{NameNew} $Tag->{NameNew} $Tag->{Type} DEFAULT NULL";
                }

                # investigate the default value
                if ( $Tag->{Type} =~ /int/i ) {
                    $Default = defined $Tag->{Default} ? $Tag->{Default} : 0;
                }
                else {
                    $Default = defined $Tag->{Default} ? "'$Tag->{Default}'" : "''";
                }
            }

            # investigate Required and AutoIncrement
            my $Required      = ( $Tag->{Required}      && lc $Tag->{Required} eq 'true' )      ? 1 : 0;
            my $AutoIncrement = ( $Tag->{AutoIncrement} && lc $Tag->{AutoIncrement} eq 'true' ) ? 1 : 0;

            # handle default and require
            if ( !$WithDefault || $Required || defined $Tag->{Default} ) {

                # fill up empty rows
                if ($WithDefault) {
                    push @SQL, "UPDATE $Table SET $Tag->{NameNew} = $Default WHERE $Tag->{NameNew} IS NULL";
                }

                my $SQLAlter = "ALTER TABLE $Table CHANGE $Tag->{NameNew} $Tag->{NameNew} $Tag->{Type}";

                # add default
                if ($WithDefault) {
                    $SQLAlter .= defined $Tag->{Default} ? " DEFAULT $Default" : '';
                }

                # add Required
                $SQLAlter .= $Required ? ' NOT NULL' : ' NULL';

                # add AutoIncrement, assuming the AutoIncrement fields are marked as Required
                $SQLAlter .= $AutoIncrement ? ' AUTO_INCREMENT' : '';

                push @SQL, $SQLAlter;
            }
        }
        elsif ( $Tag->{Tag} eq 'ColumnDrop' && $Tag->{TagType} eq 'Start' ) {
            my $SQLEnd = $SQLStart . " DROP $Tag->{Name}";
            push @SQL, $SQLEnd;
        }
        elsif ( $Tag->{Tag} =~ /^((Index|Unique)(Create|Drop))/ ) {
            my $Method = $Tag->{Tag};
            if ( $Tag->{Name} ) {
                $IndexName = $Tag->{Name};
            }
            if ( $Tag->{TagType} eq 'End' ) {
                push @SQL, $Self->$Method(
                    TableName => $Table,
                    Name      => $IndexName,
                    Data      => \@Index,
                );
                $IndexName = '';
                @Index     = ();
            }
        }
        elsif ( $Tag->{Tag} =~ /^(IndexColumn|UniqueColumn)/ && $Tag->{TagType} eq 'Start' ) {
            push @Index, $Tag;
        }
        elsif ( $Tag->{Tag} =~ /^((ForeignKey)(Create|Drop))/ ) {
            my $Method = $Tag->{Tag};
            if ( $Tag->{ForeignTable} ) {
                $ForeignTable = $Tag->{ForeignTable};
            }
            if ( $Tag->{TagType} eq 'End' ) {
                for my $Reference (@Reference) {
                    push @SQL, $Self->$Method(
                        LocalTableName   => $Table,
                        Local            => $Reference->{Local},
                        ForeignTableName => $ForeignTable,
                        Foreign          => $Reference->{Foreign},
                    );
                }
                $ReferenceName = '';
                @Reference     = ();
            }
        }
        elsif ( $Tag->{Tag} =~ /^(Reference)/ && $Tag->{TagType} eq 'Start' ) {
            push @Reference, $Tag;
        }
    }

    return @SQL;
}

sub IndexCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name Data)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }

    my $CreateIndexSQL = "CREATE INDEX $Param{Name} ON $Param{TableName} (";
    my @Array          = @{ $Param{Data} };
    for ( 0 .. $#Array ) {
        if ( $_ > 0 ) {
            $CreateIndexSQL .= ', ';
        }
        $CreateIndexSQL .= $Array[$_]->{Name};
        if ( $Array[$_]->{Size} ) {
            $CreateIndexSQL .= "($Array[$_]->{Size})";
        }
    }
    $CreateIndexSQL .= ')';

    my @SQL;

    # create index only if it does not exist already
    push @SQL,
        "SET \@IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = '$Param{TableName}' AND index_name = '$Param{Name}')";
    push @SQL,
        "SET \@IndexSQLStatement := IF( \@IndexExists = 0, '$CreateIndexSQL', 'SELECT ''INFO: Index $Param{Name} already exists, skipping.''' )";
    push @SQL, "PREPARE IndexStatement FROM \@IndexSQLStatement";
    push @SQL, "EXECUTE IndexStatement";

    # return SQL
    return @SQL;
}

sub IndexDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );

            return;
        }
    }

    my $DropIndexSQL = 'DROP INDEX ' . $Param{Name} . ' ON ' . $Param{TableName};

    my @SQL;

    # drop index only if it does still exist
    push @SQL,
        "SET \@IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = '$Param{TableName}' AND index_name = '$Param{Name}')";
    push @SQL,
        "SET \@IndexSQLStatement := IF( \@IndexExists > 0, '$DropIndexSQL', 'SELECT ''INFO: Index $Param{Name} does not exist, skipping.''' )";
    push @SQL, "PREPARE IndexStatement FROM \@IndexSQLStatement";
    push @SQL, "EXECUTE IndexStatement";

    # return SQL
    return @SQL;
}

sub ForeignKeyCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(LocalTableName Local ForeignTableName Foreign)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }

    # create foreign key name
    my $ForeignKey = "FK_$Param{LocalTableName}_$Param{Local}_$Param{Foreign}";
    if ( length($ForeignKey) > 60 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $ForeignKey,
        );
        $ForeignKey = substr $ForeignKey, 0, 58;
        $ForeignKey .= substr $MD5, 0,  1;
        $ForeignKey .= substr $MD5, 31, 1;
    }

    # add foreign key
    my $CreateForeignKeySQL = "ALTER TABLE $Param{LocalTableName} ADD CONSTRAINT $ForeignKey FOREIGN KEY "
        . "($Param{Local}) REFERENCES $Param{ForeignTableName} ($Param{Foreign})";

    my @SQL;

    # create foreign key
    push @SQL,
        "SET \@FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = '$Param{LocalTableName}' AND constraint_name = '$ForeignKey')";
    push @SQL,
        "SET \@FKSQLStatement := IF( \@FKExists = 0, '$CreateForeignKeySQL', 'SELECT ''INFO: Foreign key constraint $ForeignKey does already exist, skipping.''' )";
    push @SQL, "PREPARE FKStatement FROM \@FKSQLStatement";
    push @SQL, "EXECUTE FKStatement";

    return @SQL;
}

sub ForeignKeyDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(LocalTableName Local ForeignTableName Foreign)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }

    # create foreign key name
    my $ForeignKey = "FK_$Param{LocalTableName}_$Param{Local}_$Param{Foreign}";
    if ( length($ForeignKey) > 60 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $ForeignKey,
        );
        $ForeignKey = substr $ForeignKey, 0, 58;
        $ForeignKey .= substr $MD5, 0,  1;
        $ForeignKey .= substr $MD5, 31, 1;
    }

    my @SQL;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        push @SQL, $Self->{'DB::Comment'}
            . ' MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.';
        push @SQL, $Self->{'DB::Comment'}
            . ' However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.';
    }

    # drop foreign key
    push @SQL,
        "SET \@FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = '$Param{LocalTableName}' AND constraint_name = '$ForeignKey')";
    push @SQL,
        "SET \@FKSQLStatement := IF( \@FKExists > 0, 'ALTER TABLE $Param{LocalTableName} DROP FOREIGN KEY $ForeignKey', 'SELECT ''INFO: Foreign key constraint $ForeignKey does not exist, skipping.''' )";
    push @SQL, "PREPARE FKStatement FROM \@FKSQLStatement";
    push @SQL, "EXECUTE FKStatement";

    # drop index with the same name like the foreign key
    push @SQL,
        "SET \@IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = '$Param{LocalTableName}' AND index_name = '$ForeignKey')";
    push @SQL,
        "SET \@IndexSQLStatement := IF( \@IndexExists > 0, 'DROP INDEX $ForeignKey ON $Param{LocalTableName}', 'SELECT ''INFO: Index $ForeignKey does not exist, skipping.''' )";
    push @SQL, "PREPARE IndexStatement FROM \@IndexSQLStatement";
    push @SQL, "EXECUTE IndexStatement";

    return @SQL;
}

sub UniqueCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name Data)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }
    my $CreateUniqueSQL = "ALTER TABLE $Param{TableName} ADD CONSTRAINT $Param{Name} UNIQUE INDEX (";
    my @Array           = @{ $Param{Data} };
    for ( 0 .. $#Array ) {
        if ( $_ > 0 ) {
            $CreateUniqueSQL .= ', ';
        }
        $CreateUniqueSQL .= $Array[$_]->{Name};
    }
    $CreateUniqueSQL .= ')';

    my @SQL;

    # create unique constraint
    push @SQL,
        "SET \@UniqueExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = '$Param{TableName}' AND constraint_name = '$Param{Name}')";
    push @SQL,
        "SET \@UniqueSQLStatement := IF( \@UniqueExists = 0, '$CreateUniqueSQL', 'SELECT ''INFO: Unique constraint $Param{Name} does already exist, skipping.''' )";
    push @SQL, "PREPARE UniqueStatement FROM \@UniqueSQLStatement";
    push @SQL, "EXECUTE UniqueStatement";

    return @SQL;
}

sub UniqueDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }
    my $DropUniqueSQL = 'ALTER TABLE ' . $Param{TableName} . ' DROP INDEX ' . $Param{Name};

    my @SQL;

    # create unique constraint
    push @SQL,
        "SET \@UniqueExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = '$Param{TableName}' AND constraint_name = '$Param{Name}')";
    push @SQL,
        "SET \@UniqueSQLStatement := IF( \@UniqueExists > 0, '$DropUniqueSQL', 'SELECT ''INFO: Unique constraint $Param{Name} does not exist, skipping.''' )";
    push @SQL, "PREPARE UniqueStatement FROM \@UniqueSQLStatement";
    push @SQL, "EXECUTE UniqueStatement";

    return @SQL;
}

sub Insert {
    my ( $Self, @Param ) = @_;

    # get needed objects
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $SQL = '';
    my ( @Keys, @Values );
    for my $Tag (@Param) {
        if ( $Tag->{Tag} eq 'Insert' && $Tag->{TagType} eq 'Start' ) {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQL .= $Self->{'DB::Comment'} . " insert into table $Tag->{Table}\n";
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }

            # TODO: might be safer to call $Self->QuoteIndetifier() for quoting the table.
            #       but beware that $Tag->{Table} might already be quoted.
            $SQL .= "INSERT INTO $Tag->{Table} ";
        }
        if ( $Tag->{Tag} eq 'Data' && $Tag->{TagType} eq 'Start' ) {
            $Tag->{Key} = ${ $Self->Quote( \$Tag->{Key} ) };
            push @Keys, $Tag->{Key};
            my $Value;
            if ( defined $Tag->{Value} ) {
                $Value = $Tag->{Value};
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'The content for inserts is not longer appreciated '
                        . 'attribut Value, use Content from now on! Reason: You can\'t '
                        . 'use new lines in attributes.',
                );
            }
            elsif ( defined $Tag->{Content} ) {
                $Value = $Tag->{Content};
            }
            else {
                $Value = '';
            }
            if ( $Tag->{Type} && $Tag->{Type} eq 'Quote' ) {
                $Value = '\'' . ${ $Self->Quote( \$Value ) } . '\'';
            }
            else {
                $Value = ${ $Self->Quote( \$Value ) };
            }
            push @Values, $Value;
        }
    }
    my $Key = '';
    for (@Keys) {
        if ( $Key ne '' ) {
            $Key .= ', ';
        }
        $Key .= $_;
    }
    my $Value = '';
    for my $Tmp (@Values) {
        if ( $Value ne '' ) {
            $Value .= ', ';
        }
        if ( $Tmp eq 'current_timestamp' ) {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $Value .= $Tmp;
            }
            else {
                my $Timestamp = $DateTimeObject->ToString();
                $Value .= '\'' . $Timestamp . '\'';
            }
        }
        else {
            $Value .= $Tmp;
        }
    }
    $SQL .= "($Key)\n    VALUES\n    ($Value)";

    return $SQL;
}

sub _TypeTranslation {
    my ( $Self, $Tag ) = @_;

    if ( $Tag->{Type} =~ /^DATE$/i ) {
        $Tag->{Type} = 'DATETIME';
    }
    if ( $Tag->{Type} =~ /^VARCHAR$/i ) {
        if ( $Tag->{Size} > 16777215 ) {
            $Tag->{Type} = 'LONGTEXT';
        }
        elsif ( $Tag->{Size} > 65535 ) {
            $Tag->{Type} = 'MEDIUMTEXT';
        }
        elsif ( $Tag->{Size} > 255 ) {
            $Tag->{Type} = 'TEXT';
        }
        else {
            $Tag->{Type} = 'VARCHAR (' . $Tag->{Size} . ')';
        }
    }
    if ( $Tag->{Type} =~ /^DECIMAL$/i ) {
        $Tag->{Type} = 'DECIMAL (' . $Tag->{Size} . ')';
    }

    return $Tag;
}

1;
