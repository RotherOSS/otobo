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

package scripts::DBUpdateTo11_0::Base;

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

=head1 NAME

scripts::DBUpdateTo11_0::Base - base class for migrations.

=head1 PUBLIC INTERFACE

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {}, $Type;
}

=head2 RebuildConfig()

Refreshes the configuration to make sure that a ZZZAAuto.pm is present after the upgrade.

    $DBUpdateObject->RebuildConfig(
        UnitTestMode      => 1,         # (optional) Prevent discarding all objects at the end.
        CleanUpIfPossible => 1,         # (optional) Removes leftover settings that are not contained in XML files,
                                        #   but only if all XML files for installed packages are present.
    );

=cut

sub RebuildConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $Verbose         = $Param{CommandlineOptions}->{Verbose} || 0;

    my $CleanUp = $Param{CleanUpIfPossible} ? 1 : 0;

    if ($CleanUp) {
        my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

        PACKAGE:
        for my $Package ( $PackageObject->RepositoryList() ) {

            # Only check the deployment state of the XML configuration files for performance reasons.
            #   Otherwise, this would be too slow on systems with many packages.
            $CleanUp = $PackageObject->_ConfigurationFilesDeployCheck(
                Name    => $Package->{Name}->{Content},
                Version => $Package->{Version}->{Content},
            );

            # Stop if any package has its configuration wrong deployed, configuration cleanup should not
            #   take place in the lines below. Otherwise modified setting values can be lost.
            if ( !$CleanUp ) {
                if ($Verbose) {
                    print "\n    Configuration cleanup was not possible as packages are not correctly deployed!\n";
                }
                last PACKAGE;
            }
        }
    }

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            Force   => 1,
            UserID  => 1,
            CleanUp => $CleanUp,
        )
        )
    {
        print "\n\n    Error:There was a problem writing XML to DB.\n";
        return;
    }

    # Rebuild ZZZAAuto.pm with current values
    if (
        !$SysConfigObject->ConfigurationDeploy(
            Comments     => $Param{Comments} || "Configuration Rebuild",
            AllSettings  => 1,
            Force        => 1,
            NoValidation => 1,
            UserID       => 1,
        )
        )
    {
        print "\n\n    Error:There was a problem writing ZZZAAuto.pm.\n";
        return;
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    if ($Verbose) {
        print "\n    If you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";
    }

    return 1 if $Param{UnitTestMode};

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=head2 CacheCleanup()

Clean up the cache.

    $DBUpdateObject->CacheCleanup();

=cut

sub CacheCleanup {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    return 1;
}

=head2 ExecuteXMLDBArray()

Parse and execute an XML array. Tables and columns are not created when they already exist.

    my $Success = $DBUpdateObject->ExecuteXMLDBArray(
        XMLArray          => \@XMLArray,
        Old2NewTableNames => {                                        # optional
            'article'            => 'article_data_mime',
            'article_plain'      => 'article_data_mime_plain',
            'article_attachment' => 'article_data_mime_attachment',
        },
    );

=cut

sub ExecuteXMLDBArray {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !IsArrayRefWithData( $Param{XMLArray} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need XMLArray!",
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    XMLSTRING:
    for my $XMLString ( $Param{XMLArray}->@* ) {

        # new table
        if ( $XMLString =~ m{ <(?:Table|TableCreate) \s+ Name="([^"]+)" }xms ) {

            my $TableName = $1;

            return unless $TableName;

            # check if table exists already
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            next XMLSTRING if $TableExists;
        }

        # alter table (without renaming the table!)
        elsif ( $XMLString =~ m{ <TableAlter \s+ Name="([^"]+)" }xms ) {

            my $TableName = $1;

            return unless $TableName;

            # check if table exists
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            # the table must already exist
            next XMLSTRING unless $TableExists;

            # check if there is a table mapping hash
            if ( IsHashRefWithData( $Param{Old2NewTableNames} ) ) {

                # check if there is a new table name in the mapping
                my $NewTableName = $Param{Old2NewTableNames}->{$TableName} || '';
                if ($NewTableName) {

                    # check if new table exists already
                    my $NewTableExists = $Self->TableExists(
                        Table => $NewTableName,
                    );

                    # the new table must not yet exist
                    next XMLSTRING if $NewTableExists;
                }
            }

            # extract columns that should be added
            if ( $XMLString =~ m{ <ColumnAdd \s+ Name="([^"]+)" }xms ) {

                my $ColumnName = $1;

                return unless $ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip creating the column if the column exists already
                next XMLSTRING if $ColumnExists;
            }

            # extract columns that should be dropped
            if ( $XMLString =~ m{ <ColumnDrop \s+ Name="([^"]+)" }xms ) {

                my $ColumnName = $1;

                return unless $ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip dropping the column if the column does not exist
                next XMLSTRING if !$ColumnExists;
            }

            # extract indexes that should be added
            if ( $XMLString =~ m{<IndexCreate \s+ Name="([^"]+)" }xms ) {

                my $IndexName = $1;

                return unless $IndexName;

                my $IndexExists = $Self->IndexExists(
                    Table => $TableName,
                    Index => $IndexName,
                );

                # skip the index creation if it already exits
                next XMLSTRING if $IndexExists;
            }
        }

        # rename table
        elsif ( $XMLString =~ m{ <TableAlter \s+ NameOld="([^"]+)" \s+ NameNew="([^"]+)" }xms ) {

            my $OldTableName = $1;
            my $NewTableName = $2;

            return unless $OldTableName;
            return unless $NewTableName;

            # check if old table exists
            my $OldTableExists = $Self->TableExists(
                Table => $OldTableName,
            );

            # the old table must still exist
            next XMLSTRING unless $OldTableExists;

            # check if new table exists already
            my $NewTableExists = $Self->TableExists(
                Table => $NewTableName,
            );

            # the new table must not yet exist
            next XMLSTRING if $NewTableExists;
        }

        # drop table
        elsif ( $XMLString =~ m{ <TableDrop \s+ Name="([^"]+)" }xms ) {

            my $TableName = $1;

            return unless $TableName;

            # check if table still exists
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            # skip if table has already been deleted
            next XMLSTRING unless $TableExists;

            # TODO: actually drop the table
        }

        # insert data
        elsif ( $XMLString =~ m{ <Insert \s+ Table="([^"]+)" }xms ) {

            my $TableName = $1;

            return unless $TableName;

            # extract id column and value for auto increment fields
            if ( $XMLString =~ m{ <Data \s+ Key="([^"]+)" \s+ Type="AutoIncrement"> (\d+) }xms ) {

                my $ColumnName  = $1;
                my $ColumnValue = $2;

                return unless $ColumnName;
                return unless $ColumnValue;

                # check if value exists already
                return unless $DBObject->Prepare(
                    SQL   => "SELECT $ColumnName FROM $TableName WHERE $ColumnName = ?",
                    Bind  => [ \$ColumnValue ],
                    Limit => 1,
                );

                my $Exists;
                while ( my @Row = $DBObject->FetchrowArray() ) {
                    $Exists = $Row[0];
                }

                # skip this entry if it exists already
                next XMLSTRING if $Exists;
            }
        }

        # TODO: Add more special handling for other operations as needed!

        # execute the XML string
        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
    }

    return 1;
}

=head2 ExecuteXMLDBString()

Parse and execute an XML string.

    $DBUpdateObject->ExecuteXMLDBString( XMLString => <<'END_XML' );
    <TableAlter Name="gi_webservice_config">
      <ColumnDrop Name="config_md5"/>
    </TableAlter>
    END_XML

=cut

sub ExecuteXMLDBString {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{XMLString} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need XMLString!",
        );
        return;
    }

    my $XMLString = $Param{XMLString};

    # Create database specific SQL and PostSQL commands out of XML.
    my @SQL;
    my @SQLPost;
    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # Create database specific SQL.
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # Create database specific PostSQL.
    push @SQLPost, $DBObject->SQLProcessorPost();

    # Execute SQL.
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            print "\n";
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }

    return 1;
}

=head2 TableExists()

Checks if the given table exists in the database.

    my $Result = $DBUpdateObject->TableExists(
        Table => 'ticket',
    );

Returns true if the table exists, otherwise false.

=cut

sub TableExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Table} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Table!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TableNames = map { lc $_ => 1 } $DBObject->ListTables;

    return unless $TableNames{ lc $Param{Table} };
    return 1;
}

=head2 ColumnExists()

Checks if the given column exists in the given table.

    my $Result = $DBUpdateObject->ColumnExists(
        Table  => 'ticket',
        Column =>  'id',
    );

Returns true if the column exists, otherwise false.

=cut

sub ColumnExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Table Column)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL   => "SELECT * FROM $Param{Table}",
        Limit => 1,
    );

    my %ColumnNames = map { lc $_ => 1 } $DBObject->GetColumnNames();

    return unless $ColumnNames{ lc $Param{Column} };
    return 1;
}

=head2 IndexExists()

Checks if the given index exists in the given table.

    my $Result = $DBUpdateObject->IndexExists(
        Table => 'ticket',
        Index =>  'id',
    );

Returns true if the index exists, otherwise false.

=cut

sub IndexExists {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(Table Index)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBType = $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('Type');

    my ( $SQL, @Bind );

    if ( $DBType eq 'mysql' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM information_schema.statistics
            WHERE table_schema = DATABASE() AND table_name = ? AND index_name = ?
        ';
        push @Bind, \$Param{Table}, \$Param{Index};
    }
    elsif ( $DBType eq 'postgresql' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM pg_indexes
            WHERE indexname = ?
        ';
        push @Bind, \$Param{Index};
    }
    elsif ( $DBType eq 'oracle' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM user_indexes
            WHERE index_name = ?
        ';
        push @Bind, \$Param{Index};
    }
    else {
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my @Result = $DBObject->FetchrowArray();

    return if !$Result[0];

    return 1;
}

=head2 SettingUpdate()

Update an existing SysConfig Setting in a migration context. It will skip updating both read-only and already modified
settings by default.

    $DBUpdateObject->SettingUpdate(
        Name                   => 'Setting::Name',           # (required) setting name
        IsValid                => 1,                         # (optional) 1 or 0, modified 0
        EffectiveValue         => $SettingEffectiveValue,    # (optional)
        UserModificationActive => 0,                         # (optional) 1 or 0, modified 0
        TargetUserID           => 2,                         # (optional) ID of the user for which the modified setting is meant,
                                                             #   leave it undef for global changes.
        NoValidation           => 1,                         # (optional) no value type validation.
        ContinueOnModified     => 0,                         # (optional) Do not skip already modified settings.
                                                             #   1 or 0, default 0
        Verbose                => 0,                         # (optional) 1 or 0, default 0
    );

=cut

sub SettingUpdate {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );

        return;
    }

    my $SettingName = $Param{Name};

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Try to get the default setting from OTRS 6 for the new setting name.
    my %CurrentSetting = $SysConfigObject->SettingGet(
        Name  => $SettingName,
        NoLog => 1,
    );

    # Skip settings which already have been modified in the meantime.
    if ( $CurrentSetting{ModifiedID} && !$Param{ContinueOnModified} ) {
        if ( $Param{Verbose} ) {
            print "\n        - Setting '$Param{Name}' is already modified in the system skipping...\n\n";
        }
        return 1;
    }

    # Skip this setting if it is a read-only setting.
    if ( $CurrentSetting{IsReadonly} ) {
        if ( $Param{Verbose} ) {
            print "\n        - Setting '$Param{Name}' is is set to read-only skipping...\n\n";
        }
        return 1;
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $SettingName,
        Force  => 1,
        UserID => 1,
    );

    my %Result = $SysConfigObject->SettingUpdate(
        %Param,
        Name              => $SettingName,
        IsValid           => $Param{IsValid} || 1,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    return $Result{Success};
}

1;
