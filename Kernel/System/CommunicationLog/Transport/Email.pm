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

package Kernel::System::CommunicationLog::Transport::Email;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::MailAccount',
);

=head1 NAME

Kernel::System::CommunicationLog::Transport::Email

=head1 DESCRIPTION

This class provides functions to retrieve transport specific information.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 CommunicationAccountLinkGet()

Returns relative link information if AccountType and AccountID are present.

=cut

sub CommunicationAccountLinkGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{AccountID};

    return "Action=AdminMailAccount;Subaction=Update;ID=$Param{AccountID}";
}

=head2 CommunicationAccountLabelGet()

Returns related account label if AccountType and AccountID are present.

=cut

sub CommunicationAccountLabelGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{AccountType};
    return if !$Param{AccountID};

    my %MailAccount = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGet(
        ID => $Param{AccountID},
    );

    return if !%MailAccount;

    my $Label = "$MailAccount{Host} / $MailAccount{Login} ($Param{AccountType})";

    return $Label;
}

1;
