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

package Kernel::System::Console::Command::Admin::WebService::Add;

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

    $Self->Description('Create a new web service.');
    $Self->AddOption(
        Name        => 'name',
        Description => "The name of the new web service.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
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

    my $List             = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceList();
    my %WebServiceLookup = reverse %{$List};

    my $Name = $Self->GetOption('name');
    if ( $WebServiceLookup{$Name} ) {
        die "A web service with name $Name already exists in this system.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Creating web service...</yellow>\n");

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

    # add new web service
    my $ID = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceAdd(
        Name    => $Self->GetOption('name'),
        Config  => $Config,
        ValidID => 1,
        UserID  => 1,
    );

    if ( !$ID ) {
        $Self->PrintError('Could not create web service!');
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
