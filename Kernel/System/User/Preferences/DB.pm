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

package Kernel::System::User::Preferences::DB;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ConfigObject} = $Kernel::OM->Get('Kernel::Config');

    # preferences table data
    $Self->{PreferencesTable} = $Self->{ConfigObject}->Get('PreferencesTable')
        || 'user_preferences';
    $Self->{PreferencesTableKey} = $Self->{ConfigObject}->Get('PreferencesTableKey')
        || 'preferences_key';
    $Self->{PreferencesTableValue} = $Self->{ConfigObject}->Get('PreferencesTableValue')
        || 'preferences_value';
    $Self->{PreferencesTableUserID} = $Self->{ConfigObject}->Get('PreferencesTableUserID')
        || 'user_id';

    $Self->{CacheType} = 'User';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    # create cache prefix
    $Self->{CachePrefix} = 'UserPreferencesDB'
        . $Self->{PreferencesTable}
        . $Self->{PreferencesTableKey}
        . $Self->{PreferencesTableValue}
        . $Self->{PreferencesTableUserID};

    return $Self;
}

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Key)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $Value = $Param{Value} // '';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete old data
    return if !$DBObject->Do(
        SQL => "
            DELETE FROM $Self->{PreferencesTable}
            WHERE $Self->{PreferencesTableUserID} = ?
                AND $Self->{PreferencesTableKey} = ?",
        Bind => [ \$Param{UserID}, \$Param{Key} ],
    );

    # insert new data
    return if !$DBObject->Do(
        SQL => "
            INSERT INTO $Self->{PreferencesTable}
            ($Self->{PreferencesTableUserID}, $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue})
            VALUES (?, ?, ?)",
        Bind => [ \$Param{UserID}, \$Param{Key}, \$Value ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => $Self->{CachePrefix} . $Param{UserID},
    );

    return 1;
}

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # read cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $Self->{CachePrefix} . $Param{UserID},
    );
    return %{$Cache} if $Cache;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get preferences
    return if !$DBObject->Prepare(
        SQL => "
            SELECT $Self->{PreferencesTableKey}, $Self->{PreferencesTableValue}
            FROM $Self->{PreferencesTable}
            WHERE $Self->{PreferencesTableUserID} = ?",
        Bind => [ \$Param{UserID} ],
    );

    # fetch the result
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $Self->{CachePrefix} . $Param{UserID},
        Value => \%Data,
    );

    return %Data;
}

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    my $Key   = $Param{Key}   || '';
    my $Value = $Param{Value} || '';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Lower = '';
    if ( $DBObject->GetDatabaseFunction('CaseSensitive') ) {
        $Lower = 'LOWER';
    }

    my $SQL = "
        SELECT $Self->{PreferencesTableUserID}, $Self->{PreferencesTableValue}
        FROM $Self->{PreferencesTable}
        WHERE $Self->{PreferencesTableKey} = ?";
    my @Bind = ( \$Key );

    if ($Value) {
        $SQL .= " AND $Lower($Self->{PreferencesTableValue}) LIKE $Lower(?)";
        push @Bind, \$Value;
    }

    # get preferences
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # fetch the result
    my %UserID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $UserID{ $Row[0] } = $Row[1];
    }

    return %UserID;
}

1;
