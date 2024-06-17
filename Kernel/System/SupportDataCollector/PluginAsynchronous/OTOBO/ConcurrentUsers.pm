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

package Kernel::System::SupportDataCollector::PluginAsynchronous::OTOBO::ConcurrentUsers;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginAsynchronous);

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::SystemData',
    'Kernel::System::DateTime',
);

sub GetDisplayPath {
    return
        'OTOBO@Table:TimeStamp,UserSessionUnique|Unique agents,UserSession|Agent sessions,CustomerSessionUnique|Unique customers,CustomerSession|Customer sessions';
}

sub Run {
    my $Self = shift;

    my $ConcurrentUsers = $Self->_GetAsynchronousData();

    # the table details data
    $Self->AddResultInformation(
        Label => Translatable('Concurrent Users Details'),
        Value => $ConcurrentUsers || [],
    );

    # get the full display path
    my $DisplayPathFull = $Self->GetDisplayPath();

    # get the display path, display type and additional information for the output
    my ( $DisplayPath, $DisplayType, $DisplayAdditional ) = split( m{[\@\:]}, $DisplayPathFull // '' );

    # get the table columns (possible with label)
    my @TableColumns = split( m{,}, $DisplayAdditional // '' );

    COLUMN:
    for my $Column (@TableColumns) {

        next COLUMN if !$Column;

        # get the identifier and label
        my ( $Identifier, $Label ) = split( m{\|}, $Column );

        # set the identifier as default label
        $Label ||= $Identifier;

        next COLUMN if $Identifier eq 'TimeStamp';

        my $MaxValue = 0;

        ENTRY:
        for my $Entry ( @{$ConcurrentUsers} ) {

            next ENTRY if !$Entry->{$Identifier};
            next ENTRY if $Entry->{$Identifier} && $Entry->{$Identifier} <= $MaxValue;

            $MaxValue = $Entry->{$Identifier} || 0;
        }

        $Self->AddResultInformation(
            DisplayPath => Translatable('OTOBO') . '/' . Translatable('Concurrent Users'),
            Identifier  => $Identifier,
            Label       => "Max. $Label",
            Value       => $MaxValue,
        );
    }

    return $Self->GetResults();
}

sub RunAsynchronous {
    my $Self = shift;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTimeNow  = $DateTimeObject->ToEpoch();

    $DateTimeObject->Add( Hours => 1 );

    # Get the time values and use only the full hour.
    my $DateTimeValues = $DateTimeObject->Get();
    $DateTimeObject->Set(
        Year   => $DateTimeValues->{Year},
        Month  => $DateTimeValues->{Month},
        Day    => $DateTimeValues->{Day},
        Hour   => $DateTimeValues->{Hour},
        Minute => 0,
        Second => 0,
    );
    my $TimeStamp = $DateTimeObject->ToString();

    my $AsynchronousData = $Self->_GetAsynchronousData();

    my $CurrentHourPosition;

    if ( IsArrayRefWithData($AsynchronousData) ) {

        # already existing entry counter
        my $AsynchronousDataCount = scalar @{$AsynchronousData} - 1;

        # check if for the current hour already a value exists
        COUNTER:
        for my $Counter ( 0 .. $AsynchronousDataCount ) {

            next COUNTER
                if $AsynchronousData->[$Counter]->{TimeStamp}
                && $AsynchronousData->[$Counter]->{TimeStamp} ne $TimeStamp;

            $CurrentHourPosition = $Counter;

            last COUNTER;
        }

        # set the check timestamp to one week ago
        $DateTimeObject->Subtract( Days => 7 );
        my $CheckTimeStamp = $DateTimeObject->ToString();

        # remove all entries older than one week
        @{$AsynchronousData} = grep { $_->{TimeStamp} && $_->{TimeStamp} ge $CheckTimeStamp } @{$AsynchronousData};
    }

    # get AuthSession object
    my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # delete the old session ids
    my @Expired = $AuthSessionObject->GetExpiredSessionIDs();
    for ( 0 .. 1 ) {
        for my $SessionID ( @{ $Expired[$_] } ) {
            $AuthSessionObject->RemoveSessionID( SessionID => $SessionID );
        }
    }

    # to count the agents and customer user sessions
    my %CountConcurrentUser = (
        TimeStamp             => $TimeStamp,
        UserSessionUnique     => 0,
        UserSession           => 0,
        CustomerSession       => 0,
        CustomerSessionUnique => 0,
    );

    for my $UserType (qw(User Customer)) {

        my %ActiveSessions = $AuthSessionObject->GetActiveSessions(
            UserType => $UserType,
        );

        $CountConcurrentUser{ $UserType . 'Session' }       = $ActiveSessions{Total};
        $CountConcurrentUser{ $UserType . 'SessionUnique' } = scalar keys %{ $ActiveSessions{PerUser} };
    }

    # update the concurrent user counter, if a higher value for the current hour exists
    if ( defined $CurrentHourPosition ) {

        my $ChangedConcurrentUserCounter;

        IDENTIFIER:
        for my $Identifier (qw(UserSessionUnique UserSession CustomerSession CustomerSessionUnique)) {

            next IDENTIFIER
                if $AsynchronousData->[$CurrentHourPosition]->{$Identifier} >= $CountConcurrentUser{$Identifier};

            $AsynchronousData->[$CurrentHourPosition]->{$Identifier} = $CountConcurrentUser{$Identifier};

            $ChangedConcurrentUserCounter = 1;
        }

        return 1 if !$ChangedConcurrentUserCounter;
    }
    else {
        push @{$AsynchronousData}, \%CountConcurrentUser;
    }

    $Self->_StoreAsynchronousData(
        Data => $AsynchronousData,
    );

    return 1;
}

1;
