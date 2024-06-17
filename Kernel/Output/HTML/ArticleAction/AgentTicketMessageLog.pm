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

package Kernel::Output::HTML::ArticleAction::AgentTicketMessageLog;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog::DB',
    'Kernel::System::Log',
    'Kernel::System::Group',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub CheckAccess {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check basic conditions.
    if ( $Param{ChannelName} ne 'Email' ) {
        return;
    }

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{AdminCommunicationLog};

    # Check if module is registered.
    return if !$Config;

    # If no group or RO group is specified, always allow access.
    return 1 if !@{ $Config->{Group} || [] } && !@{ $Config->{GroupRo} || [] };

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # Check group access for frontend module.
    my $Permission;

    TYPE:
    for my $Type (qw(Group GroupRo)) {
        GROUP:
        for my $Group ( @{ $Config->{$Type} || [] } ) {
            $Permission = $GroupObject->PermissionCheck(
                UserID    => $Param{UserID},
                GroupName => $Group,
                Type      => 'rw',
            );
            last GROUP if $Permission;
        }
        last TYPE if $Permission;
    }

    return $Permission;
}

sub GetConfig {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Ticket Article UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $CommunicationLogDBObj = $Kernel::OM->Get(
        'Kernel::System::CommunicationLog::DB',
    );

    my $Result = $CommunicationLogDBObj->ObjectLookupGet(
        TargetObjectID   => $Param{Article}->{ArticleID},
        TargetObjectType => 'Article',
    );

    return if !$Result || !%{$Result};

    my $ObjectLogID     = $Result->{ObjectLogID};
    my $CommunicationID = $Result->{CommunicationID};

    my %MenuItem = (
        ItemType    => 'Link',
        Description => Translatable('View message log details for this article'),
        Name        => Translatable('Message Log'),
        Link        =>
            "Action=AdminCommunicationLog;Subaction=Zoom;CommunicationID=$CommunicationID;ObjectLogID=$ObjectLogID"
    );

    return ( \%MenuItem );
}

1;
