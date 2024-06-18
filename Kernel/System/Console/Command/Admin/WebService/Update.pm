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

package Kernel::System::Console::Command::Admin::WebService::Update;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Main',
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Update an existing web service.');
    $Self->AddOption(
        Name        => 'webservice-id',
        Description => "The ID of an existing web service.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/\A\d+\z/smx,
    );
    $Self->AddOption(
        Name        => 'source-path',
        Description => "Specify the location of the web service YAML configuration file.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Self->GetOption('source-path');
    if ( !-r $SourcePath ) {
        die "Source file $SourcePath does not exist / is not readable.\n";
    }

    my $WebServiceList = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceList();

    my $WebServiceID = $Self->GetOption('webservice-id');
    if ( !$WebServiceList->{$WebServiceID} ) {
        die "A web service with the ID $WebServiceID does not exists in this system.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Updating web service...</yellow>\n");

    # read config
    my $Content = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Self->GetOption('source-path'),
    );
    if ( !$Content ) {
        $Self->PrintError('Could not read YAML source.');
        return $Self->ExitCodeError();
    }

    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => ${$Content} );

    if ( !$Config ) {
        $Self->PrintError('Could not parse YAML source.');
        return $Self->ExitCodeError();
    }

    # get current web service
    my $WebServiceID = $Self->GetOption('webservice-id');

    my $WebService =
        $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
            ID => $WebServiceID,
        );

    if ( !$WebService ) {
        $Self->PrintError("Could not get a web service with the ID $WebServiceID from the database!");
        return $Self->ExitCodeError();
    }

    # update web service
    my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        ID      => $WebService->{ID},
        Name    => $WebService->{Name},
        Config  => $Config,
        ValidID => 1,
        UserID  => 1,
    );
    if ( !$Success ) {
        $Self->PrintError('Could not update web service!');
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
