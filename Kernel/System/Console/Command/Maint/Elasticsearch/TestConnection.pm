# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::Console::Command::Maint::Elasticsearch::TestConnection;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

# Inform the object manager about the hard dependencies.
# This module must be discarded when one of the hard dependencies has been discarded.
our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Elasticsearch',
    'Kernel::System::GenericInterface::Webservice',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Test the connection to Eleasticsearch.');

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Elasticsearch::Active') ) {
        $Self->Print("<red>The SysConfig setting Elasticsearch::Active is not on.</red>\n");

        die;
    }

    # check whether elastic search web service is enabled
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $ESWebservice = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    if ( !$ESWebservice ) {
        $Self->Print("<red>Elasticsearch webservice not found! Unable to continue.</red>\n");

        die;
    }

    if ( $ESWebservice->{ValidID} != 1 ) {
        $Self->Print("<red>Elasticsearch webservice is not activated.</red>\n");

        die;
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ESObject = $Kernel::OM->Get('Kernel::System::Elasticsearch');

    # test the connection to the server
    if ( $ESObject->TestConnection() ) {
        $Self->Print("<green>Connection could be established!</green>\n");

        return 0;
    }

    # no connection
    $Self->Print("<red>Connection could not be established!</red>\n");

    return 0;
}

1;
