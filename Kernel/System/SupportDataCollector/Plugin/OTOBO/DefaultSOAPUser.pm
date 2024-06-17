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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::DefaultSOAPUser;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SOAPUser     = $ConfigObject->Get('SOAP::User')     || '';
    my $SOAPPassword = $ConfigObject->Get('SOAP::Password') || '';

    if ( $SOAPUser eq 'some_user' && ( $SOAPPassword eq 'some_pass' || $SOAPPassword eq '' ) ) {
        $Self->AddResultProblem(
            Label   => Translatable('Default SOAP Username And Password'),
            Value   => '',
            Message =>
                Translatable(
                    'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.'
                ),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Default SOAP Username And Password'),
            Value => '',
        );
    }

    return $Self->GetResults();
}

1;
