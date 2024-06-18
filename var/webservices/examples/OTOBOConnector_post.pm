# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package var::webservices::examples::OTOBOConnector_post;
## nofilter(TidyAll::Plugin::OTOBO::Perl::PerlCritic)

use strict;
use warnings;

use parent qw(var::webservices::examples::Base);

our @ObjectDependencies = (
    'Kernel::System::GenericInterface::Webservice',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Response = (
        Success => 1,
    );

    my $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        Name => 'OTOBOConnector',
    );

    # This setting is provided by OTOBOTicketInvoker package.
    my @Data = (
        {
            'GenericInterface::Invoker::Settings::ResponseDynamicField' => {
                $Webservice->{ID} => 'PreWebTicketID',
            },
        },
    );

    $Response{Success} = $Self->SystemConfigurationUpdate(
        WebServiceName => 'OTOBO Connector',
        Data           => \@Data,
    );

    return %Response;
}

1;
