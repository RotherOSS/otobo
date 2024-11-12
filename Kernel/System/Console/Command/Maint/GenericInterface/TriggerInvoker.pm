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

package Kernel::System::Console::Command::Maint::GenericInterface::TriggerInvoker;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::GenericInterface::Requester',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::GenericInterface::Webservice',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Triggers a given Invoker webservice.');
    $Self->AddArgument(
        Name        => 'webservice',
        Description => "Select name of web service to be triggered.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/./smx,
    );
    $Self->AddArgument(
        Name        => 'invoker',
        Description => "Select Invoker to be triggered.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/./,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Invoker        = $Self->GetArgument('invoker');
    my $WebserviceName = $Self->GetArgument('webservice');

    # Check if all requirements are met (web service exists and has needed method).
    my $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        Name => $WebserviceName,
    );

    if ( !IsHashRefWithData($Webservice) ) {
        $Self->Print(
            "<red>Required web service '$WebserviceName' does not exist!</red>\n"
        );
        return $Self->ExitCodeError();
    }
    if ( $Webservice->{ValidID} ne '1' ) {
        $Self->Print(
            "<red>Required web service '$WebserviceName' is invalid!</red>\n"
        );
        return $Self->ExitCodeError();
    }

    my $InvokerControllerMapping = $Webservice->{Config}{Requester}{Transport}{Config}{InvokerControllerMapping};

    if ( !IsHashRefWithData($InvokerControllerMapping) ) {
        $Self->Print(
            "<red>Web service '$WebserviceName' does not contain required REST controller mapping!</red>\n"
        );
        return $Self->ExitCodeError();
    }
    if ( !IsHashRefWithData( $InvokerControllerMapping->{$Invoker} ) ) {
        $Self->Print(
            "<red>Web service '$WebserviceName' does not contain the Invoker '$Invoker'!</red>\n"
        );
        return $Self->ExitCodeError();
    }

    # Remember data for task.
    $Self->{InvokerTaskData} = {
        WebserviceID => $Webservice->{ID},
        Invoker      => $Invoker,
        Data         => { Dummy => 1 },
    };

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Invoker = $Self->GetArgument('invoker');

    $Self->Print(
        "<yellow>Triggering $Invoker for immediate (asynchronous) execution.</yellow>\n"
    );

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run( $Self->{InvokerTaskData}->%* );

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
