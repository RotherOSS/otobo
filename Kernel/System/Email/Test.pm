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

package Kernel::System::Email::Test;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::CommunicationLog',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{CacheKey}  = 'Emails';
    $Self->{CacheType} = 'EmailTest';

    $Self->{Type} = 'Test';

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    my $Class = ref $Self;

    # Get and delete the communication-log object from the Params because all the
    # other params will be cached (necessary for the unit tests).
    my $CommunicationLogObject = delete $Param{CommunicationLogObject};

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => $Class,
        Value         => 'Received message for emulated sending without real external connections.',
    );

    # get already stored emails from cache
    my $Emails = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Key  => $Self->{CacheKey},
        Type => $Self->{CacheType},
    ) // [];

    # recipient
    my $ToString = join ', ', @{ $Param{ToArray} };

    $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => $Class,
        Value         => sprintf( "Sending email from '%s' to '%s'.", $Param{From} // '', $ToString ),
    );

    push @{$Emails}, \%Param;

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Key   => $Self->{CacheKey},
        Type  => $Self->{CacheType},
        Value => $Emails,
        TTL   => 60 * 60 * 24,
    );

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => $Class,
        Value         => "Email successfully sent!",
    );

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return {
        Success => 1,
    };
}

sub EmailsGet {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Key  => $Self->{CacheKey},
        Type => $Self->{CacheType},
    ) // [];
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );
}

1;
