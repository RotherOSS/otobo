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

package Kernel::System::Console::Command::Admin::StandardTemplate::QueueLink;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Queue',
    'Kernel::System::StandardTemplate',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Link a template to a queue.');
    $Self->AddOption(
        Name        => 'template-name',
        Description => "Name of the template which should be linked to the given queue.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'queue-name',
        Description => "Name of the queue the given template should be linked to.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check template
    $Self->{TemplateName} = $Self->GetOption('template-name');
    $Self->{TemplateID}   = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateLookup( StandardTemplate => $Self->{TemplateName} );
    if ( !$Self->{TemplateID} ) {
        die "Standard template '$Self->{TemplateName}' does not exist.\n";
    }

    # check queue
    $Self->{QueueName} = $Self->GetOption('queue-name');
    $Self->{QueueID}   = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Self->{QueueName} );
    if ( !$Self->{QueueID} ) {
        die "Queue '$Self->{QueueName}' does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Trying to link template $Self->{TemplateName} to queue $Self->{QueueName}...</yellow>\n");

    if (
        !$Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberAdd(
            StandardTemplateID => $Self->{TemplateID},
            QueueID            => $Self->{QueueID},
            Active             => 1,
            UserID             => 1,
        )
        )
    {
        $Self->PrintError("Can't link template to queue.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
