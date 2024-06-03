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

package Kernel::System::SupportDataCollector::Plugin::Webserver::Version;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
);
our @SoftObjectDependencies = (
    'Kernel::System::Web::Request',
);

sub GetDisplayPath {
    return Translatable('Webserver');
}

sub Run {
    my $Self = shift;

    # Skip the plugin, if the support data collection isn't running in a web request.
    return $Self->GetResults() if !$ENV{GATEWAY_INTERFACE};

    my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ServerSoftware = $ParamObject->ServerSoftware();

    if ($ServerSoftware) {
        $Self->AddResultInformation(
            Label => Translatable('Webserver Version'),
            Value => $ServerSoftware,
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => Translatable('Webserver Version'),
            Value   => '',
            Message => Translatable('Could not determine webserver version.')
        );
    }

    return $Self->GetResults();
}

1;
