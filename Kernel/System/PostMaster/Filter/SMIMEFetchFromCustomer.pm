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

package Kernel::System::PostMaster::Filter::SMIMEFetchFromCustomer;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Crypt::SMIME',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Get parser object.
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(JobConfig GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::SMIMEFetchFromCustomer',
                Value         => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return 1 if !$ConfigObject->Get('SMIME');
    return 1 if !$ConfigObject->Get('SMIME::FetchFromCustomer');

    my $CryptObject;
    eval {
        $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    };
    return 1 if !$CryptObject;

    my @EmailAddressOnField = $Self->{ParserObject}->SplitAddressLine(
        Line => $Self->{ParserObject}->GetParam( WHAT => 'From' ),
    );

    my $IncomingMailAddress;

    for my $EmailAddress (@EmailAddressOnField) {
        $IncomingMailAddress = $Self->{ParserObject}->GetEmailAddress(
            Email => $EmailAddress,
        );
    }

    return 1 if !$IncomingMailAddress;

    my @Files = $CryptObject->FetchFromCustomer(
        Search => $IncomingMailAddress,
    );

    return 1;
}

1;
