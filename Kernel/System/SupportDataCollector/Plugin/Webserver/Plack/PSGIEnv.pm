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

package Kernel::System::SupportDataCollector::Plugin::Webserver::Plack::PSGIEnv;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

# core modules
use Scalar::Util qw(reftype);

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
);
our @SoftObjectDependencies = (
    'Kernel::System::Web::Request',
);

sub GetDisplayPath {
    return join '/', Translatable('Webserver'), Translatable('PSGI Environment');
}

sub Run {
    my $Self = shift;

    # Skip the plugin, if the support data collection isn't running in a web request.
    return $Self->GetResults() unless $ENV{GATEWAY_INTERFACE};

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    return $Self->GetResults() unless $ParamObject->{Query};
    return $Self->GetResults() unless $ParamObject->{Query}->can('env');

    # Accessing the Query attribute directly is a bit hackish
    my $PSGIEnv = $ParamObject->{Query}->env();
    KEY:
    for my $Key ( sort { $a cmp $b } keys $PSGIEnv->%* ) {

        # avoid confusing stringification
        next KEY if ref $PSGIEnv->{$Key};

        # typeglobs are not reliably cached, so skip those
        # e.g. 'Label' => 'psgi.errors', 'Value' => *::STDERR,
        next KEY if reftype( \$PSGIEnv->{$Key} ) eq 'GLOB';

        $Self->AddResultInformation(
            Identifier => $Key,
            Label      => $Key,
            Value      => $PSGIEnv->{$Key},
        );
    }

    return $Self->GetResults();
}

1;
