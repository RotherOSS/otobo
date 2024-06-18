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

package Kernel::System::PostMaster::Filter::DetectBounceEmail;

use strict;
use warnings;

# core modules

# CPAN modules
use Sisimai::Data    ();
use Sisimai::Message ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Ensure that the flag X-OTOBO-Bounce doesn't exist if we didn't analysed it yet.
    delete $Param{GetParam}->{'X-OTOBO-Bounce'};

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => ref($Self),
        Value         => 'Checking if is a Bounce e-mail.',
    );

    my $BounceMessage = Sisimai::Message->new( data => $Self->{ParserObject}->GetPlainEmail() );

    return 1 if !$BounceMessage;

    my $BounceData = Sisimai::Data->make( data => $BounceMessage );

    return 1 if !$BounceData || !@{$BounceData};

    my $MessageID = $BounceData->[0]->messageid();

    return 1 if !$MessageID;

    $MessageID = sprintf '<%s>', $MessageID;

    $Param{GetParam}->{'X-OTOBO-Bounce'}                   = 1;
    $Param{GetParam}->{'X-OTOBO-Bounce-OriginalMessageID'} = $MessageID;
    $Param{GetParam}->{'X-OTOBO-Bounce-ErrorMessage'}      = $Param{GetParam}->{Body};
    $Param{GetParam}->{'X-OTOBO-Loop'}                     = 1;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => ref($Self),
        Value         => sprintf(
            'Detected Bounce for e-mail "%s"',
            $MessageID,
        ),
    );

    return 1;
}

1;
