# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

package Kernel::System::ResponseTemplatesStatePreselection;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ResponseTemplatesStatePreselection - auto response template lib

=head1 DESCRIPTION

All std response functions. E. g. to add std response or other functions.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 StandardTemplateGet()

get std template attributes

    my %StandardTemplate = $StandardTemplateObject->StandardTemplateGet(
        ID => 123,
    );

Returns:

    %StandardTemplate = (
        ID                       => '123',
        Name                     => 'Simple template',
        PreSelectedTicketStateID => 2,
    );

=cut

sub StandardTemplateGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!'
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Prepare(
        SQL => '
            SELECT name, preselected_ticket_state_id
            FROM standard_template
            WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        %Data = (
            ID                       => $Param{ID},
            Name                     => $Data[0],
            PreSelectedTicketStateID => $Data[1],
        );
    }
    return %Data;
}

=head2 StandardTemplateUpdate()

update std template attributes

    $StandardTemplateObject->StandardTemplateUpdate(
        ID                       => 123,
        PreSelectedTicketStateID => 2, (optional, will be set to null otherwise)
        UserID                   => 123,
    );

=cut

sub StandardTemplateUpdate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ID UserID)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( !$Param{PreSelectedTicketStateID} ) {
        $Param{PreSelectedTicketStateID} = undef;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Do(
        SQL => '
            UPDATE standard_template
            SET preselected_ticket_state_id = ?, change_by = ?
            WHERE id = ?
        ',
        Bind => [
            \$Param{PreSelectedTicketStateID}, \$Param{UserID}, \$Param{ID},
        ],
    );
    return 1;
}

1;
