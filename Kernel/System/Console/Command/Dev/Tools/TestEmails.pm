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

package Kernel::System::Console::Command::Dev::Tools::TestEmails;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand Kernel::System::Console::Command::List);

our @ObjectDependencies = (
    'Kernel::System::Email::Test',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Get emails from test backend and output them to screen.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TestBackendObject = $Kernel::OM->Get('Kernel::System::Email::Test');

    my $Emails = $TestBackendObject->EmailsGet();
    for my $Email ( @{ $Emails || [] } ) {
        my $Header = ${ $Email->{Header} };
        my $From   = 'From - ';
        if ( $Header =~ /Date:\s(.*?)\n/ ) {
            $From .= $1;
        }
        my $Body = ${ $Email->{Body} };
        $Self->Print( $From . "\n" . $Header . "\n\n" . $Body . "\n\n" );
    }

    $TestBackendObject->CleanUp();

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
