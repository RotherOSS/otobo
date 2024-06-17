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

package Kernel::Modules::AdminCloudServices;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return $Self->_ShowOverview(
        %Param,
        Action => 'Overview',
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if cloud services are disabled
    my $CloudServicesDisabled = $ConfigObject->Get('CloudServices::Disabled') || 0;

    if ($CloudServicesDisabled) {

        my $Output = $LayoutObject->Header(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'CloudServicesDisabled',
            Data         => \%Param
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # get web services list
    my %CloudServiceList = %{ $ConfigObject->Get('CloudService::Admin::Module') || {} };

    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    ) || '';

    my $SystemIsRegistered = $RegistrationState eq 'registered';

    CLOUDSERVICE:
    for my $CloudService ( sort keys %CloudServiceList ) {

        next CLOUDSERVICE if !$CloudService;
        next CLOUDSERVICE if !IsHashRefWithData( $CloudServiceList{$CloudService} );

        if ( !$CloudServiceList{$CloudService}->{Name} || !$CloudServiceList{$CloudService}->{ConfigDialog} ) {

            # write an error message to the OTOBO log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Configuration of CloudService $CloudService is invalid!",
            );

            # notify the user of problems loading this web service
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
            );

            # continue loading the list of cloud services
            next CLOUDSERVICE;
        }

        # add result row container
        $LayoutObject->Block(
            Name => 'OverviewResultRow',
            Data => {
                CloudService       => $CloudServiceList{$CloudService},
                SystemIsRegistered => $SystemIsRegistered,
            },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminCloudServices',
        Data         => {
            %Param,
            SystemIsRegistered => $SystemIsRegistered,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

1;
