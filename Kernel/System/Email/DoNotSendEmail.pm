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

package Kernel::System::Email::DoNotSendEmail;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{Type} = 'DoNotSendEmail';

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => 'Received message for emulated sending without real external connections.',
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => 'Validating message contents.',
    );

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            my $ErrorMessage = "Need $_!";

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::Email::DoNotSendEmail',
                Value         => $ErrorMessage,
            );

            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
    }

    # from
    if ( !defined $Param{From} ) {
        $Param{From} = '';
    }

    # recipient
    my $ToString = join ', ', @{ $Param{ToArray} };

    $Param{CommunicationLogObject}->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => "Sending email from '$Param{From}' to '$ToString'.",
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => "Email successfully sent!",
    );

    $Param{CommunicationLogObject}->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return {
        Success => 1,
    };
}

1;
